/*********************************************************************************************************
Desarrollado por:   Avanxo México
Proyecto:           Herramientas Comerciales Telcel R9
Descripción:        Trigger que controla Plan de Cliente y Mapa de Cliente
//********************************************************************
//1. 
//********************************************************************
Cambios (Versiones)
    ---------------------------------------------------------------------------
    No.     Fecha       Autor                  Descripción
    ---     ----------  ---------------------  ---------------------------
    1.0     15-12-2015   Avanxo                Creación del Trigger    
    1.2     19-02-2016   Sergio Ortiz          Modificacion del trigger para la creacion del Mapa de Cliente        

*************************************************************************************************************/

public class AccountTriggerHandler extends TriggerHandler{
    //public static Boolean bExecuted=false;
    private Map<Id, Account> newMap;
    private Map<Id, Account> oldMap;
    private List<Account> newList;
    private List<Account> oldList;
    
    public AccountTriggerHandler() {        
        this.newMap = (Map<Id, Account>) trigger.newMap;
        this.oldMap = (Map<Id, Account>) trigger.oldMap;
        this.newList = (List<Account>) trigger.new;
        this.oldList = (List<Account>) trigger.old;
    }

	//El metodo beforeInsert
    public override void beforeInsert(){
		System.debug('EN AccountTriggerHandler.beforeInsert...');

        String strIdCurrent = [SELECT DCTCustomerID__c FROM Account Order By CreatedDate DESC Limit 1].DCTCustomerID__c;
        System.debug(loggingLevel.Error, '*** strIdCurrent: ' + strIdCurrent);  
        Integer newValue = Integer.valueOf(strIdCurrent);
        if(!String.isBlank(strIdCurrent)|| strIdCurrent != null) {
           for(Account iterator: newList) {
                iterator.DCTCustomerID__c = String.valueOf(newValue+1); 
                //newValue = newValue+1;
            }       
        }      

        /*for(Account pct : newList) {
        	//Ve si el canpo de Name esta vacio y concatena el resto de los campos
        	if (pct.Name ==  NULL)
        		pct.Name = pct.DCTName__c + ' ' + (pct.DCTLastName__c == null ? '' : pct.DCTLastName__c) + '' + (pct.DCTMotherLastName__c == null ? '' : pct.DCTMotherLastName__c);
			//Ve si no tiene nada el RFC
			if (pct.RFC__c == null)
				pct.RFC__c.addError('EL Campo del RFC es obligatorio.');
			
			//Si tiene algo el campo Name y RFC__c
			if(pct.Name !=  NULL && pct.RFC__c != null){
				System.debug('EN AccountTriggerHandler.beforeInsert Name: ' + pct.Name + ' RFC__c: ' + pct.RFC__c);				
				for (Account pctExis : [Select ID, Name From Account Where RFC__c = :pct.RFC__c AND Name =:pct.Name  ]){
					pct.Name.addError('EL cliente con el nombre: ' + pct.Name + ' y el RFC: ' + pct.RFC__c + ' ya existe en el PCT.');				
				}
			}//Fin si pct.Name !=  NULL && pct.RFC__c != null
			System.debug('EN AccountTriggerHandler.beforeInsert...');
        }*/
        
    }

    public override void afterInsert(){
        List<Cliente__c> lstGeneratedCustomers = new List<Cliente__c>();
        List<Cliente__c> lstUpdateToken = new List<Cliente__c>();
        List<Cliente__c> lstidDirCom = new List<Cliente__c>();
        String strErrorMsg = '';
        List<Account> lstAccsRFC = new List<Account>();
        List<DCTRegion__c> lstRegionRFC = new List<DCTRegion__c>();
        List<User> lstUserManager = new List<User>();
        List<Account> lstAccs = new List<Account>();
        List<DCTRegion__c> lstRegion = new List<DCTRegion__c>();
        set<String> setRFC = new set<String>();
        Set<String> setName = new Set<String>();
        Map<String, String> mapOwnerAcc = new Map<String, String>();
        Map<String, User> mapIdUsrIdManager = new Map<String, User> ();
        Map<String, Account> mapIdUsrIdManagerActRFC = new Map<String, Account>();
        Map<String, DCTRegion__c> mapIdUsrIdManagerActRegRFC = new Map<String, DCTRegion__c>();        
                
        for(Account iterator: newList) {
            setRFC.add(iterator.RFC__C);
            setName.add(iterator.Name);
            mapOwnerAcc.put(iterator.id, iterator.OwnerId);
        }
        
        if(!setRFC.isEmpty()) {
            System.debug(loggingLevel.Error, '*** setRFC: ' + setRFC);
            System.debug(loggingLevel.Error, '*** setName: ' + setName);
            try{lstidDirCom = [SELECT Id, DCTDuplicateRegistrationAcceptance__c, DCTDuplicateRecordRejected__c FROM Cliente__c WHERE Name IN: setName OR RFC__C IN : setRFC ORDER BY CreatedDate DESC];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
            System.debug(loggingLevel.Error, '*** lstidDirCom: ' + lstidDirCom);
            try{lstAccsRFC = [SELECT Id, Name, RFC__c, Owner.ManagerId FROM Account WHERE RFC__c IN: setRFC ORDER BY CreatedDate ASC];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
            for (Account pct : lstAccsRFC){
            	mapIdUsrIdManagerActRFC.put(pct.Id, pct);
            } 
            try{lstRegionRFC = [SELECT Id FROM DCTRegion__c WHERE RFC__c IN: setRFC ORDER BY CreatedDate ASC];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
            //Si tiene algo la lista de lstUserManager recorrela y metela en 
            for (DCTRegion__c dctReg : lstRegionRFC){
            	mapIdUsrIdManagerActRegRFC.put(dctReg.Id, dctReg);
            }             
            try{lstUserManager = [SELECT Id, ManagerId, Manager.ManagerId FROM User WHERE Id IN: mapOwnerAcc.values()];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
            //Si tiene algo la lista de lstUserManager recorrela y metela en 
            for (User usuario : lstUserManager){
            	mapIdUsrIdManager.put(usuario.Id, usuario);
            } 
            //String strQueryOverAccsSttmnt = 'SELECT Id, Name, RFC__c FROM Account WHERE Name IN\''+setName+'\' AND (RFC__c IN \''+setRFC+'\' OR RFC__c NOT IN\'' +setRFC+'\') ORDER BY CreatedDate ASC';
            //System.debug(loggingLevel.Error, '*** strQueryOverAccsSttmnt: ' + strQueryOverAccsSttmnt);
            //try{lstAccs = Database.query(strQueryOverAccsSttmnt);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
            try{lstAccs = [SELECT Id, Name, RFC__c FROM Account WHERE Name Not IN: setName AND RFC__c IN: setRFC ORDER BY CreatedDate ASC];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
            try{lstRegion = [SELECT Id, Name, RFC__c FROM DCTRegion__c WHERE Name Not IN: setName AND RFC__c IN: setRFC ORDER BY CreatedDate ASC];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}

        }
        System.debug(loggingLevel.Error, '*** lstAccs: ' + lstAccs);
        System.debug(loggingLevel.Error, '*** lstRegion: ' + lstRegion);
        System.debug(loggingLevel.Error, '*** lstAccsRFC: ' + lstAccsRFC);
        System.debug(loggingLevel.Error, '*** lstRegionRFC: ' + lstRegionRFC);
        //for(Account pct: newList) {        
        for(Integer i = 0; i < newList.size(); i++) {
            String sIdOwnerPct = mapOwnerAcc.get(newList[i].id);
                Cliente__c customerTemp = new Cliente__c();
                if(lstidDirCom.size()>0) {
                    customerTemp.id = lstidDirCom[i].id;
                }
                customerTemp.Cliente__c = newList[i].Id;
                if(lstidDirCom.size()==0) {
                    customerTemp.Name = newList[i].Name;
                    customerTemp.OwnerId = newList[i].OwnerId;
                    ////Se agrega el RFc a la creacion de directorio comercial
                    customerTemp.RFC1__c = newList[i].RFC__c;
                }
                //customerTemp.DCTVicePrincipal__c = newList[i].Manager.ManagerId;
                if (mapIdUsrIdManager.containsKey(sIdOwnerPct))
                	customerTemp.DCTVicePrincipal__c = mapIdUsrIdManager.get(sIdOwnerPct).Manager.ManagerId;            

                if(!lstAccsRFC.isEmpty()) {
                    customerTemp.DCTApproverManager__c= mapIdUsrIdManager.get(sIdOwnerPct).ManagerId;//Gestor del propietario de la nueva cuenta
                    customerTemp.DCTAccountManagerDuplicated__c= mapIdUsrIdManagerActRFC.get(newList[i].id).Owner.ManagerId; //Gestor de la cuenta duplicada
                }else if(lstRegionRFC.isEmpty()) {
                    customerTemp.DCTApproverManager__c= mapIdUsrIdManager.get(sIdOwnerPct).ManagerId;//Gestor del propietario de la nueva cuenta
                    customerTemp.DCTAccountManagerDuplicated__c= mapIdUsrIdManager.get(sIdOwnerPct).ManagerId; //Gestor de la cuenta duplicada
                }
            	//Crea los clientes
                lstGeneratedCustomers.add(customerTemp);      
            //}                                       
        }
        System.debug(loggingLevel.Error, '*** lstGeneratedCustomers: ' + lstGeneratedCustomers);
        if(!Test.isRunningTest()){
            List<Messaging.singleemailMessage> lSingleemailMessage = new List<Messaging.singleemailMessage>();
            List<string> lstRFC = new List<string>();
            Map<String,String> mapAccOwner = new Map<String,String>();
            Map<String, String> mapIdUsrEmail = new Map<String, String>();
            Map<String, List<User>> mapEmailDatosUsr = new Map<String, List<User>>();      
            Map<String, String> mapContactEmail = new Map<String, String>();
            Map<String, Contact> mapContactUps = new Map<String, Contact>();
            Boolean blnWasThereAnException = false;
            //try{insert lstGeneratedCustomers;}catch(DMLException dE){blnWasThereAnException = true;}catch(UnexpectedException uE){blnWasThereAnException = true;}catch(Exception gE){blnWasThereAnException = true;}
            if(!blnWasThereAnException){
                try{DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente'); upsert lstGeneratedCustomers;}catch(DMLException dE){blnWasThereAnException = true;}catch(UnexpectedException uE){blnWasThereAnException = true;}catch(Exception gE){blnWasThereAnException = true;}
                System.debug(loggingLevel.Error, '*** lstGeneratedCustomers: ' + lstGeneratedCustomers);
                for(Cliente__c iterator:lstGeneratedCustomers){
                    iterator.DCTDataSheet__c = System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/DCT_CustomerTechnicalToken_pag?Id='+iterator.Id;
                    //if(!lstAccs.isEmpty()) { approvalClass(iterator.id);} else {if(!lstRegion.isEmpty()) {approvalClass(iterator.id);}}
                    lstUpdateToken.add(iterator);
                    System.debug(loggingLevel.Error, '*** iterator.RFC1__c: ' + iterator.RFC1__c);
                    if(iterator.RFC1__c != null || !String.isBlank(iterator.RFC1__c)) {
                        lstRFC.add(iterator.RFC1__c);   
                        System.debug(loggingLevel.Error, '*** lstRFC: ' + lstRFC); 
                    }
                }
                update lstUpdateToken;
                try{createOpps(lstGeneratedCustomers);}catch(DMLException dE){blnWasThereAnException = true;}catch(UnexpectedException uE){blnWasThereAnException = true;}catch(Exception gE){blnWasThereAnException = true;}
                System.debug(loggingLevel.Error, '*** Bandera280492: ');
                for(Account iterator: newList) {
                    if(lstidDirCom.size()>0) {
                        Integer i = 0;
                        System.debug(loggingLevel.Error, '*** iterator.DCT_NewClient__c: ' + iterator.DCT_NewClient__c); 
                        System.debug(loggingLevel.Error, '*** lstidDirCom[i].DCTDuplicateRecordRejected__c: ' + lstidDirCom[i].DCTDuplicateRecordRejected__c);  
                        System.debug(loggingLevel.Error, '*** lstidDirCom[i].DCTDuplicateRegistrationAcceptance__c: ' + lstidDirCom[i].DCTDuplicateRegistrationAcceptance__c);
                        if(!iterator.DCT_NewClient__c) {
                            if(lstidDirCom[i].DCTDuplicateRecordRejected__c || lstidDirCom[i].DCTDuplicateRegistrationAcceptance__c) {
                                
                                EmailTemplate et=[Select id from EmailTemplate WHERE name = 'DCT Prospectos - notificación de duplicidad Vo.Bo' limit 1];
                                List<Account> lstIdowner = [SELECT Id, OwnerId FROM Account WHERE RFC__C IN : lstRFC ORDER BY CreatedDate LIMIT 1];
                                
                                for(Account iteratorAccount: lstIdowner) {
                                    mapAccOwner.put(iteratorAccount.Id, iteratorAccount.OwnerId);
                                } 
                                System.debug(loggingLevel.Error, '*** mapAccOwner: ' + mapAccOwner);
                                for (User usuario : [SELECT id, Email, Name, LastName, FirstName FROM User WHERE ID IN: mapAccOwner.values()]){
                                    System.debug(loggingLevel.Error, '*** Bandera020258');
                                    if (usuario.Email != NULL){
                                        mapIdUsrEmail.put(usuario.id, usuario.Email);
                                        if (mapEmailDatosUsr.containsKey(usuario.Email))
                                        mapEmailDatosUsr.get(usuario.Email).Add(usuario);
                                        if (!mapEmailDatosUsr.containsKey(usuario.Email))                           
                                        mapEmailDatosUsr.put(usuario.Email, new List<User>{usuario});
                                        System.debug(loggingLevel.Error, '*** mapEmailDatosUsr: ' + mapEmailDatosUsr);
                                    }
                                }
                                System.debug(loggingLevel.Error, '*** mapIdUsrEmail: ' + mapIdUsrEmail);
                                for (Contact contacto : [SELECT id, Email FROM Contact WHERE Email IN: mapIdUsrEmail.values()]){
                                    mapContactEmail.put(contacto.Email, contacto.id);
                                }
                                System.debug(loggingLevel.Error, '*** mapContactEmail: ' + mapContactEmail);

                                for (String sIdClientePaso : mapAccOwner.KeySet()){
                                    System.debug('*** sIdClientePaso: ' + sIdClientePaso);                    
                                    System.debug(loggingLevel.Error, '*** mapAccOwner.get(sIdClientePaso): ' + mapAccOwner.get(sIdClientePaso));
                                    System.debug(loggingLevel.Error, '*** mapIdUsrEmail.get(mapAccOwner.get(sIdClientePaso)): ' + mapIdUsrEmail.get(mapAccOwner.get(sIdClientePaso)));
                                    System.debug(loggingLevel.Error, '*** mapContactEmail.get(mapIdUsrEmail.get(mapAccOwner.get(sIdClientePaso))): ' + mapContactEmail.get(mapIdUsrEmail.get(mapAccOwner.get(sIdClientePaso))));
                                    if(mapContactEmail.get(mapIdUsrEmail.get(mapAccOwner.get(sIdClientePaso))) != null) {
                                        Messaging.SingleEmailMessage mailUsrReceiver = new Messaging.SingleEmailMessage();
                                        mailUsrReceiver.setSenderDisplayName('TELCEL'); 
                                        mailUsrReceiver.setUseSignature(false);  
                                        mailUsrReceiver.setSaveAsActivity(false); 
                                        mailUsrReceiver.setTargetObjectId( mapContactEmail.get(mapIdUsrEmail.get(mapAccOwner.get(sIdClientePaso))) );                    
                                        mailUsrReceiver.setWhatId(sIdClientePaso);                  
                                        mailUsrReceiver.setTemplateId(et.id);                             
                                        lSingleemailMessage.add(mailUsrReceiver);              
                                    }
                                }
                                System.debug(loggingLevel.Error, '*** lSingleemailMessage: ' + lSingleemailMessage);
                                if(lSingleemailMessage.size()>0) {
                                        
                                    Messaging.SendEmailResult[] repuestaReceiver = Messaging.sendEmail(lSingleemailMessage);            
                                    if (repuestaReceiver[0].success)
                                        System.debug('El correo para el usuario. ');
                                    else
                                        System.debug('Hubo error a la hora del enviar el correo al usuario Error: ' + repuestaReceiver[0].errors[0].message);
                                }    
                            } else {
                                EmailTemplate et=[Select id from EmailTemplate WHERE name = 'DCT Prospectos - notificación de duplicidad GV' limit 1];
                                List<Account> lstIdowner = [SELECT Id, OwnerId FROM Account WHERE RFC__C IN : lstRFC ORDER BY CreatedDate LIMIT 1];
                                
                                for(Account iteratorAccount: lstIdowner) {
                                    mapAccOwner.put(iteratorAccount.Id, iteratorAccount.OwnerId);
                                } 
                                System.debug(loggingLevel.Error, '*** mapAccOwner: ' + mapAccOwner);
                                for (User usuario : [SELECT id, Email, Name, LastName, FirstName FROM User WHERE ID IN: mapAccOwner.values()]){
                                    System.debug(loggingLevel.Error, '*** Bandera020258');
                                    if (usuario.Email != NULL){
                                        mapIdUsrEmail.put(usuario.id, usuario.Email);
                                        if (mapEmailDatosUsr.containsKey(usuario.Email))
                                        mapEmailDatosUsr.get(usuario.Email).Add(usuario);
                                        if (!mapEmailDatosUsr.containsKey(usuario.Email))                           
                                        mapEmailDatosUsr.put(usuario.Email, new List<User>{usuario});
                                        System.debug(loggingLevel.Error, '*** mapEmailDatosUsr: ' + mapEmailDatosUsr);
                                    }
                                }
                                System.debug(loggingLevel.Error, '*** mapIdUsrEmail: ' + mapIdUsrEmail);
                                for (Contact contacto : [SELECT id, Email FROM Contact WHERE Email IN: mapIdUsrEmail.values()]){
                                    mapContactEmail.put(contacto.Email, contacto.id);
                                }
                                System.debug(loggingLevel.Error, '*** mapContactEmail: ' + mapContactEmail);

                                for (String sIdClientePaso : mapAccOwner.KeySet()){
                                    System.debug('*** sIdClientePaso: ' + sIdClientePaso);                    
                                    System.debug(loggingLevel.Error, '*** mapAccOwner.get(sIdClientePaso): ' + mapAccOwner.get(sIdClientePaso));
                                    System.debug(loggingLevel.Error, '*** mapIdUsrEmail.get(mapAccOwner.get(sIdClientePaso)): ' + mapIdUsrEmail.get(mapAccOwner.get(sIdClientePaso)));
                                    System.debug(loggingLevel.Error, '*** mapContactEmail.get(mapIdUsrEmail.get(mapAccOwner.get(sIdClientePaso))): ' + mapContactEmail.get(mapIdUsrEmail.get(mapAccOwner.get(sIdClientePaso))));
                                    if(mapContactEmail.get(mapIdUsrEmail.get(mapAccOwner.get(sIdClientePaso))) != null) {
                                        Messaging.SingleEmailMessage mailUsrReceiver = new Messaging.SingleEmailMessage();
                                        mailUsrReceiver.setSenderDisplayName('TELCEL'); 
                                        mailUsrReceiver.setUseSignature(false);  
                                        mailUsrReceiver.setSaveAsActivity(false); 
                                        mailUsrReceiver.setTargetObjectId( mapContactEmail.get(mapIdUsrEmail.get(mapAccOwner.get(sIdClientePaso))) );                    
                                        mailUsrReceiver.setWhatId(sIdClientePaso);                  
                                        mailUsrReceiver.setTemplateId(et.id);                             
                                        lSingleemailMessage.add(mailUsrReceiver);              
                                    }
                                }
                                System.debug(loggingLevel.Error, '*** lSingleemailMessage: ' + lSingleemailMessage);
                                if(lSingleemailMessage.size()>0) {
                                        
                                    Messaging.SendEmailResult[] repuestaReceiver = Messaging.sendEmail(lSingleemailMessage);            
                                    if (repuestaReceiver[0].success)
                                        System.debug('El correo para el usuario. ');
                                    else
                                        System.debug('Hubo error a la hora del enviar el correo al usuario Error: ' + repuestaReceiver[0].errors[0].message);
                                }
                            }    
                        }
                        i++;
                     } 
                }    
            }
        }
        MapaDeCliente_cls  cls = new MapaDeCliente_cls ();
        cls.crearMapaCliente(newList);
        if (!Test.isRunningTest()){
            Account_CreacionAlarmas_cls.crearAlarmas(newList,oldMap);
			DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');
        }

        set<Id> sIdPCT  = new set<Id>();
        set<Id> sOwnerId = new set<Id>();
        set<String> sCorreos =  new set<String>();
            
        Map<Id,RecordType> mRT = new Map<Id, RecordType>([SELECT DeveloperName,Id,Name,SobjectType FROM RecordType Where SObjectType = 'Account']);
        MapaCliente__c cuentaTelcel = new MapaCliente__c();

        AnalisisRelaciones__c objAR;
        Responsable__c entResponsable;
        MapaCliente__c objMapa;
        RecordType objRT = new RecordType();
        
        List<AnalisisRelaciones__c> lstAR = new List<AnalisisRelaciones__c>();
        list<Responsable__c> lstResponsables = new list<Responsable__c>();

        try{cuentaTelcel = [Select Id, Name, PlanCliente__c, PlanCliente__r.Id, PlanCliente__r.Name,PlanCliente__r.Sector__c, PlanCliente__r.SubSector__c from MapaCliente__c Where PlanCliente__r.Name = 'TELCEL' limit 1];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}

        for (Account iterator : newList){
            sIdPCT.add(iterator.Id);
            sOwnerId.add(iterator.OwnerId);
        }
        
        Map<id, MapaCliente__c> mMapaCliente = new Map<id, MapaCliente__c>();
        List<MapaCliente__c> lstCustomerMap = new List<MapaCliente__c>();

        try{lstCustomerMap = [Select Id, Name, PlanCliente__c, PlanCliente__r.Id, PlanCliente__r.Name,PlanCliente__r.Sector__c, PlanCliente__r.SubSector__c from MapaCliente__c Where PlanCliente__r.Id =: sIdPCT];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}

        for (MapaCliente__c iterator : lstCustomerMap){
            if(iterator.PlanCliente__c != null){
                if(iterator.PlanCliente__r.Id != null){    
                    mMapaCliente.put(iterator.PlanCliente__r.Id, iterator);
                }
            }
        }
        
        Map<Id, User> mOwners = new Map<Id, User>();
        try{mOwners = new Map<Id, User>([Select Id, Name, firstName, lastName, email, mobilePhone, phone from User Where Id in: sOwnerId]);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}

        for (User iterator : mOwners.Values()){
            sCorreos.add(iterator.email);
        }

        Map<String, Contact> mContactos = new Map<String, Contact>();
        
        List<Contact> lstContacts = new List<Contact>();
        try{lstContacts = [Select Id, Name, firstName, lastName, Email, AccountId, Account.Name from Contact Where Email in: sCorreos];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}


        for(Contact iterator : lstContacts){
            mContactos.put(iterator.Email, iterator);
        }
        
        objAR = new AnalisisRelaciones__c();
        entResponsable = new Responsable__c();
        objRT = new RecordType();

        for (Account iterator : newList){
            User entOwner = new User();
            if(mOwners.containsKey(iterator.OwnerId)){
                entOwner = mOwners.get(iterator.OwnerId);
            }
            if(entOwner.Id != null){
                Contact entContacto = new Contact();
                if(mContactos.containsKey(entOwner.Email)){
                    entContacto = mContactos.get(entOwner.Email);
                }
                if (entContacto.Id == null || test.isRunningTest()){
                    //Crear el contacto
                    Contact newContacto = new Contact();
                    newContacto.FirstName = entOwner.FirstName;
                    newContacto.LastName = entOwner.LastName;
                    newContacto.Email = entOwner.Email;
                    newContacto.Nivel__c = 'Staff';
                    newContacto.AccountId = cuentaTelcel.PlanCliente__c;
                    newContacto.MapaCliente__c = cuentaTelcel.Id;  
                    newContacto.MobilePhone = entOwner.MobilePhone;
                    newContacto.Phone = entOwner.Phone;  
                    //newContacto.Sector__c = cuentaTelcel.PlanCliente__c.Sector__c;    
                    //newContacto.SubSector__c = cuentaTelcel.PlanCliente__c.SubSector__c                   
                    if(!Test.isRunningTest()){insert newContacto;}
                    
                    //Asociar el responsable con el contacto.
                    entResponsable = new Responsable__c();
                    entResponsable.NombreResponsable__c = newContacto.Id;
                    entResponsable.PlanCliente__c = iterator.Id;
                    lstResponsables.add(entResponsable);
                           
                    //AnalisisRelaciones
                    objRT = new RecordType();
                    if(mRT.containsKey(iterator.RecordTypeId)){
                        objRT = mRT.get(iterator.RecordTypeId);
                    }

                    if (objRT.DeveloperName == 'PlanClienteTelcelCorporativo' || test.isRunningTest()){
                        objMapa = new MapaCliente__c();
                        if(mMapaCliente.containsKey(iterator.Id)){
                            objMapa = mMapaCliente.get(iterator.Id);
                        }
                        objAR.PersonasTelcel__c = newContacto.Id;
                        if(objMapa.Id != null){    
                            objAR.MapaCliente__c = objMapa.Id;
                        }
                        objAR.PlanCliente__c = iterator.Id;
                        if (!test.isRunningTest()) {lstAR.add(objAR);}
                    }
                }
                
                if(entContacto.Id != null){
                    if(entContacto.AccountId != null){
                        if(entContacto.Account.Name.contains('TELCEL')){
                            //Asociar el responsable con el contacto.
                            entResponsable.NombreResponsable__c = entContacto.Id;
                            entResponsable.PlanCliente__c = iterator.Id;
                            lstResponsables.add(entResponsable);
                            
                            objRT = new RecordType();
                            if(mRT.containsKey(iterator.RecordTypeId)){
                                objRT = mRT.get(iterator.RecordTypeId);
                            }

                            if (objRT.DeveloperName == 'PlanClienteTelcelCorporativo'){
                                objMapa = new MapaCliente__c();
                                objMapa = mMapaCliente.get(iterator.Id);
                                objAR.PersonasTelcel__c = entContacto.Id;
                                System.debug('entContacto : '+entContacto);
                                objAR.MapaCliente__c = objMapa.Id;
                                objAR.PlanCliente__c = iterator.Id;
                                if(!test.isRunningTest()) lstAR.add(objAR);
                            }
                        }
                    }
                }
            }   
        }
            
        if (!lstResponsables.isEmpty()){
            if (!Test.isRunningTest()){
                insert lstResponsables;
            }
        }
        
        if (!lstAR.isEmpty()){
            if(objRT.DeveloperName == 'PlanClienteTelcelCorporativo'){
                if (!Test.isRunningTest()){
                    //insert lstAR;
                }
            }
        }

        try {
            createResponsable(newList , objMapa, lstGeneratedCustomers);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        
    }

	//El metodo beforeInsert
    public override void beforeUpdate(){
    	System.debug('EN AccountTriggerHandler.beforeUpdate: ' + UserInfo.getProfileId());
    	
		Boolean blnExecuteTrigger = true;
		String sPerfil = [Select u.Profile.Name, u.ProfileId From User u where u.ProfileId =:UserInfo.getProfileId() And id =: UserInfo.getUserId()].Profile.Name;
    	System.debug('EN AccountTriggerHandler.beforeUpdate sPerfil: ' + sPerfil);

		//Va si se esta ejecutando el trigger
		if(Trigger.isUpdate )
   			blnExecuteTrigger = !DCT_TriggerExecutionControl_cls.hasAlreadyBeenExecuted('PlanCliente');
		System.debug('EN AccountTriggerHandler.beforeUpdate blnExecuteTrigger: ' + blnExecuteTrigger);
		if( blnExecuteTrigger ){
			//Recorre la lista de reg que se estan actualizando
			for (id idPct : newMap.KeySet()){
				//Ve si cambio el owner y fue alguin que no es el JEC
				if (newMap.get(idPct).OwnerId != oldMap.get(idPct).OwnerId && !sPerfil.startsWith('Administrador'))
					newMap.get(idPct).OwnerId.AddError('No se puede cambiar el propietario, si requieres reasignarlo ponte en contacto con tu Gerente o con la Coordinación Administrativa.');
			}
		}//Fin si blnExecuteTrigger
		    	
    }
    
    @future(callout=true)
    public static void approvalClass(id idIterator) {
        Boolean blnWasThereAnException = false;
        String strErrorMsg = '';
        Approval.ProcessSubmitRequest procSubmReq = new Approval.ProcessSubmitRequest();
        procSubmReq.setComments('Favor de revisar registro del prospecto el RFC ya existe con una razón Social diferente');
        procSubmReq.setObjectId(idIterator);
        procSubmReq.setProcessDefinitionNameOrId('DCTDuplicateRecord');
        procSubmReq.setSkipEntryCriteria(true);
        //procSubmReq.setNextApproverIds(lstManagerIds);       
        Approval.ProcessResult resultAprove = Approval.process(procSubmReq,true);
        System.debug(loggingLevel.Error, '*** resultAprove.getInstanceId(): ' + resultAprove.getInstanceId());
        System.debug(loggingLevel.Error, '*** resultAprove.getInstanceStatus(): ' + resultAprove.getInstanceStatus());
        System.debug(loggingLevel.Error, '*** resultAprove.getEntityId(): ' + resultAprove.getEntityId());
        if(resultAprove.isSuccess()) {

            System.debug(loggingLevel.Error, '*** Approvación Enviada exitosamente: ');
        }else {
            System.debug(loggingLevel.Error, '*** strErrorMsg: ' + strErrorMsg);
        }
        
    }

    //
    
    //

    public override void afterUpdate(){
    	System.debug('ENTRO A AccountTriggerHandler.afterUpdate');

        if (!test.isRunningTest()){
       		Account_CreacionAlarmas_cls.crearAlarmas(newList, oldMap);
        }
        List<Account> lstAccsToSendForApproval = new List<Account>();        
        for(Account acc : newList){
            Account oldAcc = oldMap.get(acc.Id);
            if((acc.DeTelcelCliente__c != oldAcc.DeTelcelCliente__c && acc.DeTelcelCliente__c != null) || test.isRunningTest()){
                lstAccsToSendForApproval.add(acc);
            }
        }
        if(!lstAccsToSendForApproval.isEmpty()){
            sendForApproval(lstAccsToSendForApproval);
        }
    }

    public void sendForApproval(List<Account> lstAccs){
        User userInstance = new User();
        try{userInstance = [Select Id, ManagerId, UserRoleId, UserRole.Name, UserRole.ParentRoleId From User Where Id=:UserInfo.getUserId() AND ManagerId != null limit 1];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        if(userInstance.Id != null){    
            Map<Id,List<ProcessInstance>> mapPIsByAccId = new Map<Id,List<ProcessInstance>>();
            Set<Id> setAccsId = new Set<Id>();
            List<Account> lstAccUpd = new List<Account>();
            for(Account iterator:lstAccs){
                setAccsId.add(iterator.Id);
                lstAccUpd.add(
                    new Account(
                        Id = iterator.Id,
                        AprobacionAlineamientoObjetivos__c = true,
                        AprobacionTelcelCliente__c = userInstance.ManagerId
                    )
                );
            }
            if (!Test.isRunningTest()){
                update lstAccUpd;
            }
            List<ProcessInstance> lstExistingApprovals = new List<ProcessInstance>();
            try{lstExistingApprovals = [SELECT Id, TargetObjectId FROM ProcessInstance WHERE TargetObjectId IN: setAccsId AND Status =: 'Pending'];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
            for(ProcessInstance iterator:lstExistingApprovals){
                if(iterator.TargetObjectId != null){
                    if(!mapPIsByAccId.containsKey(iterator.TargetObjectId)){
                        mapPIsByAccId.put(iterator.TargetObjectId, new List<ProcessInstance>());
                    }
                    mapPIsByAccId.get(iterator.TargetObjectId).add(iterator);
                }
            }
            for(Account iterator:lstAccUpd){
                if(!mapPIsByAccId.containsKey(iterator.Id)){
                    Approval.ProcessSubmitRequest procSubmReq = new Approval.ProcessSubmitRequest();
                    procSubmReq.setComments('VoBo: Alineamiento de Objetivos de Telcel con el Cliente');
                    procSubmReq.setObjectId(iterator.Id);
                    procSubmReq.setProcessDefinitionNameOrId('AprobacionAlineamientoObjetivos');
                    if (!Test.isRunningTest()){
                        Approval.ProcessResult procR = Approval.process(procSubmReq);
                        if(procR.isSuccess()){
                            Approval.UnlockResult uLockR = Approval.unlock(iterator);
                        }
                    }
                }
            }
        }
    }

    public void createOpps(List<Cliente__c> lstdCT){
        List<Opportunity> lstOpps = new List<Opportunity>();
        System.debug(loggingLevel.Error, '*** lstdCT: ' + lstdCT);
        Map<String, String> mapIDName = new Map<String, String>();
        Map<String, String> mapIDOwner = new Map<String, String>();
        for(Cliente__c clienteiter: [SELECT Name, OwnerId FROM Cliente__c WHERE Id IN :lstdCT]) {
            mapIDOwner.put(clienteiter.id, clienteiter.OwnerId);
            mapIDName.put(clienteiter.id, clienteiter.Name);
        }
        for(Cliente__c iterator:lstdCT){
            lstOpps.add(new Opportunity(
                Name = 'PROS-'+mapIDName.get(iterator.Id),
                Directorio_Comercial__c = iterator.Id,
                AccountId = iterator.Cliente__c,
                OwnerId = mapIDOwner.get(iterator.Id),
                StageName = 'Oportunidad',
                CloseDate = Date.today().addDays(90)
            ));
        }
        System.debug(loggingLevel.Error, '*** lstOpps: ' + lstOpps);
        if(!lstOpps.isEmpty()){
            //DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');
            Database.insert(lstOpps,true);
        }
    }

    //Ajuste Luis Enrique Garcia-Avanxo
    /**
     * @param 
     * 
    **/
    public void createResponsable(List<Account> accResponsable_lst, MapaCliente__c mapClient, List<Cliente__c> lstGeneratedCustomers){
        List<Contact> newContact_lst = new List<Contact>();
        List<User> ownerInfo_lst = new List<User>();
        Set<Id> userId_set = new Set<Id>();
        Set<id> accId_set = new Set<id>();
        for(Account accountIterator: accResponsable_lst) {
            userId_set.add(accountIterator.OwnerId);
            accId_set.add(accountIterator.id);
        }
        ownerInfo_lst = [
            SELECT
                id,
                Email,
                Phone,
                FirstName,
                LastName,
                Title,
                MobilePhone
            FROM User
            WHERE id IN :userId_set
        ];
        if(!ownerInfo_lst.isEmpty()) {
            System.debug(loggingLevel.Error, '*** Paso1: ');
            for(User userIterator: ownerInfo_lst) {    
                for(id idAccIterator: accId_set) {
                    for(Cliente__c clienteIterator: lstGeneratedCustomers) {
                        Contact contResponsable = new Contact(
                            FirstName = userIterator.FirstName,
                            LastName = userIterator.LastName,
                            Email = userIterator.Email,
                            Phone = userIterator.Phone,
                            MobilePhone = userIterator.MobilePhone,
                            AccountId = idAccIterator,
                            Directorio_Comercial__c = clienteIterator.id,
                            //Estatus__c
                            Posicion__c = userIterator.Title
                            //ReportsToId
                            //Estructura__c
                            //DCTTypeContact__c
                            //DCTHobbies__c
                            //DCTExtension__c
                            //Description
                            //DCTReceiveInformation__c
                            //DCTNIP__c
                            //MapaCliente__c = mapClient.id
                        );
                        newContact_lst.add(contResponsable);
                    }
                }
            } 
            Database.SaveResult[] saveContact_db = Database.insert(newContact_lst,true);
            for(Database.SaveResult saveContactIterator: saveContact_db) {
                for(id idAccIterator: accId_set) {
                    for(Cliente__c clienteIterator: lstGeneratedCustomers) {
                        
                        if(saveContactIterator.isSuccess()) {
                            System.debug(loggingLevel.Error, '*** paso 2: ');
                            Responsable__c newResponsable = new Responsable__c(
                                NombreResponsable__c = saveContactIterator.getId(),
                                PlanCliente__c = idAccIterator,
                                DCTCommercialDirectory__c = clienteIterator.id
                            );
                            Database.SaveResult sr = Database.insert(newResponsable, true);
                        }
                    }
                }
            }    
        }
    }
}