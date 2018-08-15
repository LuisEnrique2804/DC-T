public class DCT_NewCustomLead_ext {

	public List<String> lstErrorMsgs          {set;get;}
	public List<String> lstSuccessMsgs        {set;get;}
	public Account      accountRecord         {set;get;}
	public Account      nvoProspecto          {set;get;}    
	public Boolean      blnSuccessfulProcedure{set;get;}
	public String       strManagerName        {set;get;}
	public String       strCareChannel        {set;get;}
	public Boolean      blnIsMoralEntity      {set;get;}
	public Boolean      blnIsNaturalEntity    {set;get;}
	public User         userInstance;
	public Boolean blnWithOnlyMSM = false;
	public Set<String> setIdDirCom {set;get;}
	public Boolean blnFirsProcess {get;set;}
	public Boolean blnIsCicloOk {get;set;}
	public String strCiclo {get;set;}
	public Set<String> setCsApproveCycles {set;get;}
	public Set<String> setCsRejectCycles {set;get;}
	public Set<String> setCsPayStatus {set;get;}

	public void initOrCleanUpMsg(){
		lstErrorMsgs = new List<String>();
		lstSuccessMsgs = new List<String>();
	}

	public void initVarsAndCollection(){
		setIdDirCom = new Set<String>();
		userInstance = new User();
		try{userInstance = [SELECT Id, Name, UserName, Manager.Name, DTC_CanalAtencion__c, ManagerId FROM User WHERE Id=: UserInfo.getUserId() limit 1];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
		if(userInstance.id != null){
			if(userInstance.Name != null){
				strManagerName = userInstance.Name; 
			}
			if(userInstance.DTC_CanalAtencion__c != null){
				strCareChannel = userInstance.DTC_CanalAtencion__c; 
			}	
		}
		blnSuccessfulProcedure = false;
		nvoProspecto = new Account();
		setCsApproveCycles = new Set<String>();
		setCsRejectCycles  = new Set<String>();
		setCsPayStatus     = new Set<String>();
		initOrCleanUpMsg();
	}

	public DCT_NewCustomLead_ext(ApexPages.StandardController stdCtrl){
		initVarsAndCollection();
		blnIsMoralEntity = false;
		blnIsNaturalEntity = false;
		accountRecord = (Account)stdCtrl.getRecord();
		accountRecord.name = '.';
		setCsRejectCycles = DCT_CycleReject_cs__c.getall().keySet();// ciclos 20, 60, 61, 63, 31, 32, 41 y 42
		setCsApproveCycles = DCT_CycleApproveProcess_cs__c.getAll().keySet();//ciclos: 97,98 y 99
		setCsPayStatus = DCT_PayStatus_cs__c.getall().keySet();//estatus de cobranza MOROSO
		System.debug(loggingLevel.Error, '*** setCsApproveCycles: ' + setCsApproveCycles);
		System.debug(loggingLevel.Error, '*** setCsRejectCycles: ' + setCsRejectCycles);
		System.debug(loggingLevel.Error, '*** setCsPayStatus: ' + setCsPayStatus);
		for(String iterator: setCsPayStatus) {
			System.debug(loggingLevel.Error, '*** iterator: ' + iterator);
		}
	}
	
	public void performSaving(){
		
		Boolean          blnWasThereanException                    = false; 
		Boolean          blnIsEverythingOk                         = true;
		String           strErrorMsg                               = '';
		String           strName                                   = '';
		String           strQueryOverDupplicateAccAssignmentSttmnt = '';
		List<Id>         lstManagerIds                             = new List<Id>();
		List<Cliente__c> lstClientid                               = new List<Cliente__c>();
		List<Cliente__c> lstGeneratedCustomers = new List<Cliente__c>();
		List<Account> lstAccsRFC = new List<Account>();
		Map<String, Account> mapIdUsrIdManagerActRFC = new Map<String, Account>();
		Map<String, String> mapRFCOwnerManager = new Map<String, String>();
		List<User> lstUserManager = new List<User>();
		Map<String, User> mapIdUsrIdManager = new Map<String, User> ();
		List<DCTRegion__c> lRegiones = new List<DCTRegion__c>();
		Boolean bDuplicado = false;
		DuplicateValidationResultWrapper duplicatedValidationWrapper;
		Boolean blnIsCiclo23 = false;
		
		//Incializa las variables
		initOrCleanUpMsg();
		//Valida los campos obligatorios y estrucctura
		if(validateInputs()){
			System.debug(loggingLevel.Error, '*** accountRecord: ' + accountRecord);
			//Consulta las regiones para ver si existen registros en los ciclos			 
			if(accountRecord.DTC_LegalEntity__c == 'Física' || accountRecord.DTC_LegalEntity__c == 'FÍsica con Actividad Empresarial.') {
				String strconcaName = accountRecord.DCTLastName__c+' '+accountRecord.DCTMotherLastName__c+' '+accountRecord.DCTName__c;
				for (DCTRegion__c regiones : [SELECT Id, RFC__c, Name, DCTBillingCycle__c, EstatusCobranza__c 
					FROM DCTRegion__c WHERE RFC__c = :accountRecord.RFC__c AND Name = :strconcaName  ORDER BY CreatedDate ASC]){
					System.debug(loggingLevel.Error, '*** regiones: ' + regiones);
					lRegiones.add(regiones);
				}
			} else if (accountRecord.DTC_LegalEntity__c == 'Moral' || accountRecord.DTC_LegalEntity__c == 'Gubernamental') {
				for (DCTRegion__c regiones : [SELECT Id, RFC__c, Name, DCTBillingCycle__c, EstatusCobranza__c 
					FROM DCTRegion__c WHERE RFC__c = :accountRecord.RFC__c AND Name = :accountRecord.DCTControlFieldName__c  ORDER BY CreatedDate ASC]){
					System.debug(loggingLevel.Error, '*** regiones: ' + regiones);
					lRegiones.add(regiones);
				}
			}
			System.debug(loggingLevel.Error, '*** lRegiones: ' + lRegiones.isEmpty());
			//Ve si existen regiones donde validar
			if (!lRegiones.isEmpty()){
				//VCalida los ciclos ciclos 20, 60, 61, 63, 31, 32, 41 y 42
				if (ProspectRegionIsEmpty(lRegiones, setCsRejectCycles, false)){
					blnIsCicloOk = true; 
					lstErrorMsgs.add('El RFC ya esta registrado con un ciclo de facturación: '+ strCiclo +'.');
				}//Fin de ciclos 20, 60, 61, 63, 31, 32, 41 y 42
				else if (ProspectRegionIsEmpty(lRegiones, setCsApproveCycles, false)){ //ciclos: 97,98 y 99
					blnIsCiclo23 = true;
				}//Fin de ciclos: 97,98 y 99
				else if (ProspectRegionIsEmpty(lRegiones, setCsPayStatus, true)){//estatus de cobranza MOROSO
					blnIsCiclo23 = true;					
				}//Fin si estatus de cobranza MOROSO
				System.debug(loggingLevel.Error, '*** blnIsCiclo23: ' + blnIsCiclo23);
				//Si no se ecuentra en los ciclos 20, 60, 61, 63, 31, 32, 41 y 42 pero si se encuentra en
				//Alguno de estos 97,98 y 99 o estatus de cobranza MOROSO
				if (blnIsCiclo23){
					System.debug(loggingLevel.Error, '*** TIENE CICLO 2 O 3 blnIsCiclo23: ' + blnIsCiclo23);					
					NoExisRazonSocialExisreRFC(blnIsCiclo23);
				}//Fin si blnIsCiclo23
			}//Fin si !lRegiones.isEmpty()
			System.debug(loggingLevel.Error, '*** lRegiones: ' + lRegiones);
			//No hay regitro duplicado
			if (lRegiones.isEmpty() || (!blnIsCicloOk && !blnIsCiclo23)){
				duplicatedValidationWrapper = validateIfDuplicatedAccount();
				bDuplicado = duplicatedValidationWrapper.blnIsValid;
			}//Fin si 
			System.debug(loggingLevel.Error, '*** EN duplicatedValidationWrapper: ' + duplicatedValidationWrapper);
			//No hay duplicados bDuplicado = true
			if (bDuplicado && duplicatedValidationWrapper != null){
				if(!blnIsCiclo23){ 
					if (NoExisRazonSocialExisreRFC(blnIsCiclo23)){
						System.debug(loggingLevel.Error, '*** BANDERA: ');
						Map<String,Map<String,RecordType>> mapRTsByDevName = TLCL_Utils_cls.getRecordTypes('DeveloperName');
						if(accountRecord.Segmento__c == 'Corporativo'){
							accountRecord.RecordTypeId = mapRTsByDevName.get('Account').get('PlanClienteTelcelCorporativo').Id;
						}
						if(accountRecord.Segmento__c == 'Empresarial'){
							accountRecord.RecordTypeId = mapRTsByDevName.get('Account').get('PlanClienteTelcelEmpresarial').Id; 
						}
						if(accountRecord.Segmento__c == 'PyME'){
							accountRecord.RecordTypeId = mapRTsByDevName.get('Account').get('PlanClienteTelcelPyME').Id;
						}
						accountRecord.DCT_RegistrationDate__c = Date.today();
						accountRecord.TipoCliente__c = 'Prospecto';
						if(accountRecord.DTC_LegalEntity__c == 'Física' || accountRecord.DTC_LegalEntity__c == 'FÍsica con Actividad Empresarial.') {
							accountRecord.Name = accountRecord.DCTLastName__c+' '+accountRecord.DCTMotherLastName__c+' '+accountRecord.DCTName__c;
						}
						if(accountRecord.DTC_LegalEntity__c == 'Moral' || accountRecord.DTC_LegalEntity__c == 'Gubernamental') {
							accountRecord.Name = accountRecord.DCTControlFieldName__c;
						}
						strName = accountRecord.Name.trim();
						String emailRegex = '^[^.,ÁáÉéÍíÓóÚú]+';
						Matcher InputEmail = Pattern.compile(emailRegex).matcher(strName);
						Boolean BlnMtchStr = InputEmail.matches();
						System.debug(loggingLevel.Error, '*** BlnMtchStr: ' + BlnMtchStr);
						if(!BlnMtchStr ) {
							lstErrorMsgs.add('Validar la información, la Razón Social no debe contener puntos, comas ni acentos.');
							blnIsEverythingOk = false;
						}
						String strTest = accountRecord.Name.toUpperCase();
						
						accountRecord.Name = strTest;
						accountRecord.RFC__c = accountRecord.RFC__c.toUpperCase();
						accountRecord.Estatus__c = 'Activo';
						accountRecord.DCT_NewClient__c = true;
						System.debug(loggingLevel.Error, '*** blnIsEverythingOk: ' + blnIsEverythingOk);
						if(blnIsEverythingOk) {	
							System.debug(loggingLevel.Error, '*** accountRecord: ' + accountRecord);
							Database.SaveResult sr = Database.insert(accountRecord,false);
							if(sr.isSuccess()){
								lstSuccessMsgs.add('El prospecto ha sido creado de manera exitosa.');
								blnSuccessfulProcedure = true;
								System.debug(loggingLevel.Error, '*** El prospecto: ');
							}else{
								for(Database.Error iterator:sr.getErrors()){
									lstErrorMsgs.add(iterator.getMessage());    
								}        
							}
						}					
					}//Fin si !NoExisRazonSocialExisreRFC ()
				}//Fin si blnIsCiclo23
			}//Fin si bDuplicado
			System.debug(loggingLevel.Error, '*** bDuplicado: ' + bDuplicado);
			System.debug(loggingLevel.Error, '*** duplicatedValidationWrapper: ' + duplicatedValidationWrapper);
			//Esta duplivado bDuplicado = false 
			if (!bDuplicado && duplicatedValidationWrapper != null){
				String strconcaName;
				List<DCTAssignmentDuplicateAccount__c> lstAssigsDuplicatedAccounts = new List<DCTAssignmentDuplicateAccount__c>();
				List<DCTAssignmentDuplicateAccount__c> lstAssigsDuplicatedAccounts2 = new List<DCTAssignmentDuplicateAccount__c>();
				if(accountRecord.DTC_LegalEntity__c == 'Física' || accountRecord.DTC_LegalEntity__c == 'FÍsica con Actividad Empresarial.') {
					strconcaName = accountRecord.DCTLastName__c+' '+accountRecord.DCTMotherLastName__c+' '+accountRecord.DCTName__c;
					//strQueryOverDupplicateAccAssignmentSttmnt = 'SELECT '+String.join(new List<String>(SObjectType.DCTAssignmentDuplicateAccount__c.Fields.getMap().keySet()),', ')+' FROM DCTAssignmentDuplicateAccount__c WHERE CustomIdentifier__c = \''+strconcaName+'-'+userInstance.UserName+'\' ';
					//strQueryOverDupplicateAccAssignmentSttmnt = 'SELECT '+String.join(new List<String>(SObjectType.DCTAssignmentDuplicateAccount__c.Fields.getMap().keySet()),', ')+' FROM DCTAssignmentDuplicateAccount__c WHERE CustomIdentifier__c = \''+strconcaName+'\' ';
					for (DCTAssignmentDuplicateAccount__c duplicado : [Select d.RFC__c, d.CustomIdentifier__c, Assigneduser__c From DCTAssignmentDuplicateAccount__c d where d.CustomIdentifier__c  != null 
						And CustomIdentifier__c =:strconcaName and RFC__c =:accountRecord.RFC__c ]){
						lstAssigsDuplicatedAccounts.add(duplicado);
					}				
				}
				if(accountRecord.DTC_LegalEntity__c == 'Moral' || accountRecord.DTC_LegalEntity__c == 'Gubernamental') {
					System.debug(loggingLevel.Error, '*** accountRecord.DCTControlFieldName__c: ' + accountRecord.DCTControlFieldName__c);
					//strQueryOverDupplicateAccAssignmentSttmnt = 'SELECT '+String.join(new List<String>(SObjectType.DCTAssignmentDuplicateAccount__c.Fields.getMap().keySet()),', ')+' FROM DCTAssignmentDuplicateAccount__c WHERE CustomIdentifier__c = \''+accountRecord.DCTControlFieldName__c+'\' ';
					for (DCTAssignmentDuplicateAccount__c duplicado : [Select d.RFC__c, d.CustomIdentifier__c, Assigneduser__c From DCTAssignmentDuplicateAccount__c d where d.CustomIdentifier__c  != null 
						And CustomIdentifier__c =:accountRecord.DCTControlFieldName__c And RFC__c =:accountRecord.RFC__c ]){
						lstAssigsDuplicatedAccounts.add(duplicado);
					}					
				}
				//lstAssigsDuplicatedAccounts = Database.query(strQueryOverDupplicateAccAssignmentSttmnt);
				System.debug(loggingLevel.Error, '*** lstAssigsDuplicatedAccounts: ' + lstAssigsDuplicatedAccounts);
				if(!lstAssigsDuplicatedAccounts.isEmpty()) {	
					for(DCTAssignmentDuplicateAccount__c iterator: lstAssigsDuplicatedAccounts) {
						if(!iterator.Assigneduser__c) {
							lstAssigsDuplicatedAccounts2.add(iterator);
						}
					}
				}	
				System.debug(loggingLevel.Error, '*** lstAssigsDuplicatedAccounts2: ' + lstAssigsDuplicatedAccounts2);
				if(lstAssigsDuplicatedAccounts2.isEmpty()){
					System.debug(loggingLevel.Error, '*** duplicatedValidationWrapper: ' + duplicatedValidationWrapper);
					if(duplicatedValidationWrapper.lstDupAccs.size()>0 || duplicatedValidationWrapper.lstDupProsp.size()>0 || duplicatedValidationWrapper.lstDupRegs.size()>0){
						id idPCT = (duplicatedValidationWrapper.lstDupAccs.size()>0)?duplicatedValidationWrapper.lstDupAccs.get(0).Id:(duplicatedValidationWrapper.lstDupProsp.size()>0?duplicatedValidationWrapper.lstDupProsp.get(0).Id:(duplicatedValidationWrapper.lstDupRegs.size()>0?duplicatedValidationWrapper.lstDupRegs.get(0).Id:null));
						String strIdOwner = (duplicatedValidationWrapper.lstDupAccs.size()>0)?duplicatedValidationWrapper.lstDupAccs.get(0).OwnerId:(duplicatedValidationWrapper.lstDupProsp.size()>0?duplicatedValidationWrapper.lstDupProsp.get(0).OwnerId:(duplicatedValidationWrapper.lstDupRegs.size()>0?duplicatedValidationWrapper.lstDupRegs.get(0).OwnerId:null));
						System.debug(loggingLevel.Error, '*** strIdOwner: ' + strIdOwner);
						lstClientid = [SELECT Id FROM Cliente__c WHERE Cliente__c = : idPCT LIMIT 1];
						System.debug(loggingLevel.Error, '*** strIdOwner != UserInfo.getUserId(): ' + strIdOwner +'!='+ UserInfo.getUserId());
						System.debug(loggingLevel.Error, '*** strIdOwner != UserInfo.getUserId(): ' + strIdOwner != UserInfo.getUserId());
						if(strIdOwner != UserInfo.getUserId()) {
							System.debug(loggingLevel.Error, '*** PAso123456: ');
							System.debug(loggingLevel.Error, '*** blnWithOnlyMSM: ' + blnWithOnlyMSM); 
							if(blnWithOnlyMSM) {
								Database.SaveResult sr = Database.insert(
									new DCTAssignmentDuplicateAccount__c(
										ExistingCustomer__c = (duplicatedValidationWrapper.lstDupAccs.size()>0)?duplicatedValidationWrapper.lstDupAccs.get(0).Id:null,
										Assigneduser__c = false,
										UsertobeAssigned__c = userInstance.Id,
										DCTExistingAccount__c = (lstClientid.size()>0)? lstClientid[0].id:null
									),
									false
								);
								if(!sr.isSuccess()){
									lstErrorMsgs.add(sr.getErrors()[0].getMessage());
								}
							}//Fin si blnWithOnlyMSM
							if(!blnWithOnlyMSM){
								lstErrorMsgs.clear();
								lstErrorMsgs.add('La razón social ya se encuentra registrada.');
							}																					
						}else {
							System.debug(loggingLevel.Error, '*** AQUI ****');
							lstErrorMsgs = new List<String>();
							lstErrorMsgs.add('No puedes estar en la lista de espera de esta cuenta, debido a que ya la registraste previamente');
						}
					}
				} else {
					System.debug(loggingLevel.Error, '*** ===AQUI NO===: ');
					lstErrorMsgs = new List<String>();
					lstErrorMsgs.add('La razón social ya se encuentra registrada con otros dos ejecutivos.');//'La razón social ya se encuentra registrada.'
				}				
			}//Fin si !bDuplicado
			
		}//Fin si validateInputs()
		
	}

	public Boolean NoExisRazonSocialExisreRFC(Boolean bCobranza){
		System.debug('EN NoExisRazonSocialExisreRFC bCobranza: ' + bCobranza);
		
		String strName = '';
		Boolean blnIsEverythingOk = true;
		List<Account> lstAccsRFC = new List<Account>();
		Map<String, Account> mapIdUsrIdManagerActRFC = new Map<String, Account>();
		Map<String, String> mapRFCOwnerManager = new Map<String, String>();
		List<User> lstUserManager = new List<User>();
		Map<String, User> mapIdUsrIdManager = new Map<String, User> ();
		List<DCTRegion__c> lRegiones = new List<DCTRegion__c>();
		List<Cliente__c> lstGeneratedCustomers = new List<Cliente__c>();
		Boolean blnFirsProcess = false;

		System.debug(loggingLevel.Error, '*** Solo se crea el directorio: '+ accountRecord.Name);
		if(accountRecord.DTC_LegalEntity__c == 'Física' || accountRecord.DTC_LegalEntity__c == 'FÍsica con Actividad Empresarial.') {
			accountRecord.Name = accountRecord.DCTLastName__c+' '+accountRecord.DCTMotherLastName__c+' '+accountRecord.DCTName__c;
		}
		if(accountRecord.DTC_LegalEntity__c == 'Moral' || accountRecord.DTC_LegalEntity__c == 'Gubernamental') {
			accountRecord.Name = accountRecord.DCTControlFieldName__c;
		}
		strName = accountRecord.Name.trim();
		String emailRegex = '^[^.,ÁáÉéÍíÓóÚú]+';
		Matcher InputEmail = Pattern.compile(emailRegex).matcher(strName);
		Boolean BlnMtchStr = InputEmail.matches();
		System.debug(loggingLevel.Error, '*** BlnMtchStr: ' + BlnMtchStr);
		if(!BlnMtchStr ) {
			lstErrorMsgs.add('Validar la información, el prospecto no debe contener puntos(.), comas(,) ni acentos.');
			blnIsEverythingOk = false;
		}
		String strTest = accountRecord.Name.toUpperCase();
		System.debug(loggingLevel.Error, '*** blnIsEverythingOk: ' + blnIsEverythingOk);
		System.debug(loggingLevel.Error, '*** accountRecord: ' + accountRecord);
		try{lstAccsRFC = [SELECT Id, Name, RFC__c, Owner.ManagerId FROM Account WHERE RFC__c = :accountRecord.RFC__c ORDER BY CreatedDate ASC LIMIT 1];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        System.debug(loggingLevel.Error, '*** lstAccsRFC: ' + lstAccsRFC);
        for (Account pct : lstAccsRFC){
        	mapIdUsrIdManagerActRFC.put(pct.RFC__c, pct);
        	mapRFCOwnerManager.put(pct.RFC__c, pct.Owner.ManagerId);
        	blnFirsProcess = TRUE;        	
        } 
        System.debug(loggingLevel.Error, '*** mapIdUsrIdManagerActRFC: ' + mapIdUsrIdManagerActRFC);
        System.debug(loggingLevel.Error, '*** mapRFCOwnerManager: ' + mapRFCOwnerManager);
        System.debug(loggingLevel.Error, '*** UserInfo.id: ' + UserInfo.getUserId());
        try{lstUserManager = [SELECT Id, ManagerId, Manager.ManagerId FROM User WHERE Id = :UserInfo.getUserId()];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        //Si tiene algo la lista de lstUserManager recorrela y metela en 
        for (User usuario : lstUserManager){
        	mapIdUsrIdManager.put(usuario.Id, usuario);
        } 
        System.debug(loggingLevel.Error, '*** mapIdUsrIdManager: ' + mapIdUsrIdManager);
		accountRecord.Name = strTest;
		Cliente__c customerTemp = new Cliente__c();
		//customerTemp.Cliente__c = accountRecord.Id;
		customerTemp.Name = accountRecord.Name;
		customerTemp.OwnerId = accountRecord.OwnerId;
		//Se agrega el RFc a la creacion de directorio comercial
		customerTemp.RFC1__c = accountRecord.RFC__c;
		customerTemp.OwnerId = UserInfo.getUserId();
		customerTemp.DCTRegistrationDateBack__c= System.today();
		customerTemp.DCTSalesManagerBack__c= strManagerName;
		customerTemp.DCTLegalPersonBack__c= accountRecord.DTC_LegalEntity__c;
		customerTemp.DCTSectorBack__c= accountRecord.Sector__c;
		customerTemp.DCTSegmentback__c= accountRecord.Segmento__c;
		customerTemp.DCTSubsectorback__c= accountRecord.Subsector__c;
		customerTemp.DCTActivationTypeback__c= accountRecord.DCT_TypeOfProcedure__c; 
		customerTemp.DCTCustomerTypeback__c= 'Prospecto';
		System.debug(loggingLevel.Error, '*** blnFirsProcess: ' + blnFirsProcess);
		if(!blnFirsProcess || bCobranza) {
			customerTemp.DCTDuplicateRecordRejected__c = true;
		}
		//customerTemp.DCTVicePrincipal__c = lstUserManager[i].Manager.ManagerId;
		//customerTemp.DCTVicePrincipal__c = accountRecord.Manager.ManagerId;  
		System.debug(loggingLevel.Error, '*** customerTemp: ' + customerTemp);
		System.debug(loggingLevel.Error, '*** accountRecord.RFC__c: ' + accountRecord.RFC__c);
		System.debug(loggingLevel.Error, '*** mapIdUsrIdManagerActRFC: ' + mapIdUsrIdManagerActRFC);      
		customerTemp.DCTApproverManager__c= mapIdUsrIdManager.get(UserInfo.getUserId()).ManagerId;//Gestor del propietario de la nueva cuenta
        customerTemp.DCTAccountManagerDuplicated__c= (mapRFCOwnerManager.isEmpty() )?null:mapRFCOwnerManager.get(accountRecord.RFC__c);
			//Crea los clientes
	  	lstGeneratedCustomers.add(customerTemp);
	  	System.debug(loggingLevel.Error, '*** lstGeneratedCustomers: ' + lstGeneratedCustomers);
		System.debug(loggingLevel.Error, '*** bCobranza: ' + bCobranza);
		System.debug(loggingLevel.Error, '*** blnIsEverythingOk: ' + blnIsEverythingOk);
		System.debug(loggingLevel.Error, '*** lstAccsRFC: ' + lstAccsRFC);
		if(bCobranza) {	
			System.debug(loggingLevel.Error, '*** lstGeneratedCustomers: ' + lstGeneratedCustomers);
			Database.SaveResult[] sr = Database.insert(lstGeneratedCustomers,false);
			for(Database.SaveResult iteratorSR: sr) {
				if(iteratorSR.isSuccess()) {
		      		lstSuccessMsgs.add('El RFC o la razón social ya se encuentrran registrados tu registro se envio a validacion y/o aprobación.');//Registro de aprobacion pendiente por gerencia de cobranza
		      		blnSuccessfulProcedure = true;
		      		setIdDirCom.add(iteratorSR.getId());
		      		blnIsEverythingOk = false;
				}
			}
		}else if(blnIsEverythingOk && !lstAccsRFC.isEmpty()) {	
			System.debug(loggingLevel.Error, '*** lstGeneratedCustomers: ' + lstGeneratedCustomers);
			Database.SaveResult[] sr = Database.insert(lstGeneratedCustomers,false);
			for(Database.SaveResult iteratorSR: sr) {
				if(iteratorSR.isSuccess()) {
		      		lstSuccessMsgs.add('El RFC o la razón social ya se encuentrran registrados tu registro se envio a validacion y/o aprobación.');//Registro de aprobacion pendiente por gerencia de cobranza
		      		blnSuccessfulProcedure = true;
		      		setIdDirCom.add(iteratorSR.getId());
		      		blnIsEverythingOk = false;
				}
			}
		}	
		if(blnSuccessfulProcedure) {
		  	if((blnFirsProcess && !bCobranza)|| Test.isRunningTest()) {
				for(Cliente__c iterator:lstGeneratedCustomers){
				    System.debug(loggingLevel.Error, '*** Paso1: '+ iterator.id);
				    approvalClass(iterator.id);
				}
		  	}
		}
	  	System.debug(loggingLevel.Error, '*** blnIsEverythingOk: ' + blnIsEverythingOk);
	  	return blnIsEverythingOk;
	}

	@future(callout=true)
  	public static void approvalClass(id idIterator) {
    	Boolean blnWasThereAnException = false;
	    String strErrorMsg = '';
	    System.debug(loggingLevel.Error, '*** idIterator: ' + idIterator);
	    Approval.ProcessSubmitRequest procSubmReq = new Approval.ProcessSubmitRequest();
	    procSubmReq.setComments('Favor de revisar registro del prospecto, el RFC ya existe con una Razón Social diferente.');
	    procSubmReq.setObjectId(idIterator);
	    procSubmReq.setProcessDefinitionNameOrId('DCTDuplicateRecord');
	    procSubmReq.setSkipEntryCriteria(true);
	    //procSubmReq.setNextApproverIds(lstManagerIds);   
	    System.debug(loggingLevel.Error, '*** procSubmReq: ' + procSubmReq);    
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
	
	public void changeStatus(){
		if(accountRecord.DTC_LegalEntity__c == 'Física' || accountRecord.DTC_LegalEntity__c == 'FÍsica con Actividad Empresarial.') {
			blnIsMoralEntity = false;
			blnIsNaturalEntity = true;
		} else if (accountRecord.DTC_LegalEntity__c == 'Moral' || accountRecord.DTC_LegalEntity__c == 'Gubernamental') {
			blnIsMoralEntity = true;
			blnIsNaturalEntity = false;
		}
	}

	public PageReference redirectToDC(){
		System.debug(loggingLevel.Error, '*** Redirect: ');
		PageReference pr = null;
		initOrCleanUpMsg();
		Cliente__c dcInstance = new Cliente__c();
		if(accountRecord.Id != null) {	
			try{dcInstance = [SELECT Id FROM Cliente__c WHERE Cliente__c =: accountRecord.Id];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
		}	else {
			try{dcInstance = [SELECT Id FROM Cliente__c WHERE id IN :setIdDirCom];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
		}
		System.debug(loggingLevel.Error, '*** dcInstance: ' + dcInstance);
		if(dcInstance.Id != null){
			pr = new PageReference('/'+dcInstance.Id);
			pr.setRedirect(true);	
		}

		return pr;
	}

	public Boolean validateInputs(){
		
		Boolean blnIsEverythingOk = true;
		Boolean blnIsNotLegalEntityEmpty = false;
		Boolean blnlenghisOk = true;
		String  strRFC = '';
		if(accountRecord.RFC__c == null || String.isBlank(accountRecord.RFC__c)){
			blnIsEverythingOk = false;
			lstErrorMsgs.add('El RFC no fue establecido.');
		}
		if(accountRecord.Segmento__c == null || String.isBlank(accountRecord.Segmento__c)){
			blnIsEverythingOk = false;
			lstErrorMsgs.add('El segmento no fue establecido.');
		}
		if(accountRecord.Sector__c == null || String.isBlank(accountRecord.Sector__c)){
			blnIsEverythingOk = false;
			lstErrorMsgs.add('El sector no fue establecido.');
		}
		if(accountRecord.DCT_TypeOfProcedure__c == null || String.isBlank(accountRecord.DCT_TypeOfProcedure__c)){
			blnIsEverythingOk = false;
			lstErrorMsgs.add('El tipo de activación no fue establecido.');
		}
		if(accountRecord.Subsector__c == null || String.isBlank(accountRecord.Subsector__c)){
			blnIsEverythingOk = false;
			lstErrorMsgs.add('El Subsector no fue establecido.');
		}
		System.debug(loggingLevel.Error, '*** accountRecord.DTC_LegalEntity__c: ' + accountRecord.DTC_LegalEntity__c);
		//Ajustes Luis Enrique
		if(accountRecord.DTC_LegalEntity__c == null || String.isBlank(accountRecord.DTC_LegalEntity__c)){
			blnIsNotLegalEntityEmpty = true;
			blnIsEverythingOk = false;
			lstErrorMsgs.add(System.Label.DCT_ErrorMessageLegalEntity_lbl);
		}
		if(!blnIsNotLegalEntityEmpty) {
			System.debug(loggingLevel.Error, '*** accountRecord.RFC__c: ' + accountRecord.RFC__c);
			if(accountRecord.RFC__c != null || !String.isBlank(accountRecord.RFC__c)) {	
				if(accountRecord.DTC_LegalEntity__c == 'Moral' || accountRecord.DTC_LegalEntity__c == 'Gubernamental') {
					if(accountRecord.RFC__c.length()!=12) {
						lstErrorMsgs.add(System.label.DCT_ErrorMessageMoralRFC_lbl);
						blnlenghisOk = false;
						blnIsEverythingOk = false;
					}	
					if(accountRecord.DCTControlFieldName__c == null || String.isBlank(accountRecord.DCTControlFieldName__c)) {
						blnIsEverythingOk = false;
						lstErrorMsgs.add('La Razón Social no fue establecido.');		
					}			
				} 
				if(accountRecord.DTC_LegalEntity__c == 'Física' || accountRecord.DTC_LegalEntity__c == 'FÍsica con Actividad Empresarial.') {
					if(accountRecord.DCTLastName__c == null || String.isBlank(accountRecord.DCTLastName__c)){
						blnIsEverythingOk = false;
						lstErrorMsgs.add('El Apellido Paterno no fue establecido.');
					}
					if(accountRecord.DCTMotherLastName__c == null || String.isBlank(accountRecord.DCTMotherLastName__c)){
						blnIsEverythingOk = false;
						lstErrorMsgs.add('El Apellido Materno no fue establecido.');
					}
					if(accountRecord.DCTName__c == null || String.isBlank(accountRecord.DCTName__c)){
						blnIsEverythingOk = false;
						lstErrorMsgs.add('El Nombre no fue establecido.');
					}
					if(accountRecord.RFC__c.length()!=13) {
						lstErrorMsgs.add(System.label.DCT_ErrorMessagePeopleRFC_lbl);
						blnlenghisOk = false;
						blnIsEverythingOk = false;
					}		
				}
			}	
			System.debug(loggingLevel.Error, '*** blnlenghisOk: ' + blnlenghisOk);
			if(blnlenghisOk) {
				if(blnIsEverythingOk) {
					strRFC = accountRecord.RFC__c.trim();
					String emailRegex = System.Label.DCT_RegularExpresionRFC_lbl;
					Matcher InputEmail = Pattern.compile(emailRegex).matcher(strRFC);
					Boolean BlnMtchStr = InputEmail.matches();
					if(!BlnMtchStr ) {
						lstErrorMsgs.add(System.Label.DCT_ErrorMessageRFCStructure_lbl);
						blnIsEverythingOk = false;
					}
				}
			}
		}
		//Fin Ajustes
		return blnIsEverythingOk;
	}

	//Valida ciclos
	public Boolean ProspectRegionIsEmpty(List<DCTRegion__c> lRegionesValidas, Set<String> setCiclosEstatus, Boolean bCobranza){
		System.debug('EN ProspectRegionIsEmpty: lRegionesValidas: ' + lRegionesValidas);
		System.debug('EN ProspectRegionIsEmpty: setCiclosEstatus: ' + setCiclosEstatus);
				
		Boolean blnExisteCiclo = false;
		blnIsCicloOk = false;
		blnFirsProcess = false;
		strCiclo = '';
		for(DCTRegion__c iteratorRegion: lRegionesValidas) {
			//Ve si el registo de la region existe en el ciclo setCiclosEstatus
			if (!bCobranza){
				if(setCiclosEstatus.contains(iteratorRegion.DCTBillingCycle__c)) {
					blnExisteCiclo = true;
					strCiclo = iteratorRegion.DCTBillingCycle__c;
					break;
				}//Fin si setCiclosEstatus.contains(iteratorRegion.DCTBillingCycle__c)
			}
			if (bCobranza){
				if(setCiclosEstatus.contains(iteratorRegion.EstatusCobranza__c)) {
					blnExisteCiclo = true;
					strCiclo = iteratorRegion.EstatusCobranza__c;
					break;
				}//Fin si setCiclosEstatus.contains(iteratorRegion.DCTBillingCycle__c)
			}			
		}//Fin del for para lRegionesValidas
		System.debug(loggingLevel.Error, '*** blnExisteCiclo: ' + blnExisteCiclo);
		return blnExisteCiclo;
	}

	public DuplicateValidationResultWrapper validateIfDuplicatedAccount(){
		DuplicateValidationResultWrapper duplicateResultWrapperInstance = new DuplicateValidationResultWrapper();
		duplicateResultWrapperInstance.blnIsValid = true;
		duplicateResultWrapperInstance.lstDupAccs = new List<Account>();
		duplicateResultWrapperInstance.lstDupRegs = new List<DCTRegion__c>();
		duplicateResultWrapperInstance.lstDupProsp = new List<Cliente__c>();
		String                         strQueryOverAccsSttmnt ='';
		List<Account>                  lstAccs                = new List<Account>();
		List<Account>                  lstAccs2               = new List<Account>();
		List<Account>                  lstAccs3               = new List<Account>();
		List<Account>                  lstAccs4               = new List<Account>();
		List<Account>                  lstAccs5               = new List<Account>();
		List<DCTRegion__c>             lstRegion              = new List<DCTRegion__c>();
		List<DCTRegion__c>             lstRegion2             = new List<DCTRegion__c>();
		List<Cliente__c>               lstProspect            = new List<Cliente__c>();
		List<Cliente__c>               lstProspect2           = new List<Cliente__c>();
		List<Cliente__c>               lstProspect3           = new List<Cliente__c>();
		List<Cliente__c>               lstProspect4           = new List<Cliente__c>();
		List<Cliente__c>               lstProspect5           = new List<Cliente__c>();
		Map<String,List<Account>>      mapAccsByName          = new Map<String,List<Account>>();
		Map<String,List<Account>>      mapAccsByRFC           = new Map<String,List<Account>>();
		Map<String,List<DCTRegion__c>> mapRegByName           = new Map<String,List<DCTRegion__c>>();
		Map<String,List<DCTRegion__c>> mapRegByRFC            = new Map<String,List<DCTRegion__c>>();
		Map<String,List<Cliente__c>>   mapProspByName           = new Map<String,List<Cliente__c>>();
		Map<String,List<Cliente__c>>   mapProspByRFC            = new Map<String,List<Cliente__c>>();
		Boolean blnIsProspect = false;
		System.debug(loggingLevel.Error, '*** accountRecord.DCTControlFieldName__c: ' + accountRecord.DCTControlFieldName__c);
		System.debug(loggingLevel.Error, '*** accountRecord.RFC__c: ' + accountRecord.RFC__c);
		if(accountRecord.DTC_LegalEntity__c == 'Física' || accountRecord.DTC_LegalEntity__c == 'FÍsica con Actividad Empresarial.') {
			String strconcaName = accountRecord.DCTLastName__c+' '+accountRecord.DCTMotherLastName__c+' '+accountRecord.DCTName__c;
			strconcaName = strconcaName.toUpperCase();
			System.debug(loggingLevel.Error, '*** strconcaName: ' + strconcaName);
			lstProspect =[SELECT Id, Name, RFC__c, RecordType.Name, OwnerId FROM Cliente__c WHERE DCTStatus__c = 'Activo' AND Name= :strconcaName /*OR RFC__c = :accountRecord.RFC__c*/  ORDER BY CreatedDate ASC];
			lstAccs =[SELECT Id, Name, RFC__c,TipoCliente__c, OwnerId FROM Account WHERE Name= :strconcaName /*OR RFC__c = :accountRecord.RFC__c*/  ORDER BY CreatedDate ASC];
			//lstRegion = [SELECT Id, RFC__c, Name, OwnerId,EstatusCobranza__c, DCTBillingCycle__c FROM DCTRegion__c WHERE Name= :strconcaName OR RFC__c = :accountRecord.RFC__c ORDER BY CreatedDate ASC];
			lstRegion = [SELECT Id, RFC__c, Name, OwnerId,EstatusCobranza__c, DCTBillingCycle__c FROM DCTRegion__c WHERE Name= :strconcaName ORDER BY CreatedDate ASC];
			System.debug(loggingLevel.Error, '*** lstProspect: ' + lstProspect);
			System.debug(loggingLevel.Error, '*** lstAccs: ' + lstAccs);
			System.debug(loggingLevel.Error, '*** lstRegion: ' + lstRegion);
			if(!lstAccs.isEmpty()) {
				for(Account iterator:lstAccs){
					if(iterator.TipoCliente__c == 'Prospecto') {
						if(iterator.RFC__c == accountRecord.RFC__c) {
							lstAccs2.add(iterator);
							blnWithOnlyMSM = true;
							blnIsProspect = true;
							System.debug(loggingLevel.Error, '*** Bandera141290: ');
						}else {
							lstAccs4.add(iterator);
							System.debug(loggingLevel.Error, '*** Bandera280492: ');
							//blnIsProspect = true;
						}
					}
					if(iterator.TipoCliente__c == 'Cliente Cautivo') {
						if(iterator.RFC__c == accountRecord.RFC__c) {
							lstAccs3.add(iterator);
							//blnWithOnlyMSM = true;
							
						}else {
							lstAccs4.add(iterator);
							
						}
					}
				}
			}
			if(!lstRegion.isEmpty()) {
				for(DCTRegion__c iterator:lstRegion){
					if(iterator.RFC__c == accountRecord.RFC__c) {
						lstRegion2.add(iterator);
						
					}else {
						lstRegion2.add(iterator);
					}
				}
			}
			if(!lstProspect.isEmpty()) {
				for(Cliente__c iterator:lstProspect){
					if(iterator.RecordType.Name == 'Prospecto') {	
						if(iterator.RFC__c == accountRecord.RFC__c) {
							lstProspect2.add(iterator);		
							blnWithOnlyMSM = true;
							blnIsProspect = true;
						}else {
							lstProspect4.add(iterator);
						}
					}
					if(iterator.RecordType.Name == 'Cliente Cautivo') {
						if(iterator.RFC__c == accountRecord.RFC__c) {
							lstProspect3.add(iterator);		
						}else {
							lstProspect4.add(iterator);
						}
					}
				}
			}
		}
		if(accountRecord.DTC_LegalEntity__c == 'Moral' || accountRecord.DTC_LegalEntity__c == 'Gubernamental') {
			lstProspect =[SELECT Id, Name, RFC__c,RFC1__c, RecordType.Name, OwnerId FROM Cliente__c WHERE DCTStatus__c = 'Activo' AND  Name= :accountRecord.DCTControlFieldName__c /*OR RFC__c = :accountRecord.RFC__c*/  ORDER BY CreatedDate ASC];
			lstAccs =[SELECT Id, Name, RFC__c,TipoCliente__c, OwnerId FROM Account WHERE Name= :accountRecord.DCTControlFieldName__c /*OR RFC__c = :accountRecord.RFC__c*/ ORDER BY CreatedDate ASC];
			//lstRegion = [SELECT Id, RFC__c, Name, EstatusCobranza__c, DCTBillingCycle__c, OwnerId FROM DCTRegion__c WHERE Name= :accountRecord.DCTControlFieldName__c OR RFC__c = :accountRecord.RFC__c ORDER BY CreatedDate ASC];
			lstRegion = [SELECT Id, RFC__c, Name, EstatusCobranza__c, DCTBillingCycle__c, OwnerId FROM DCTRegion__c WHERE Name= :accountRecord.DCTControlFieldName__c ORDER BY CreatedDate ASC];
			System.debug(loggingLevel.Error, '*** lstAccs: ' + lstAccs);
			System.debug(loggingLevel.Error, '*** lstRegion: ' + lstRegion);
			System.debug(loggingLevel.Error, '*** lstProspect: ' + lstProspect);
			if(!lstAccs.isEmpty()) {
				for(Account iterator:lstAccs){
					if(iterator.TipoCliente__c == 'Prospecto') {
						if(iterator.RFC__c == accountRecord.RFC__c) {
							lstAccs2.add(iterator);
							blnWithOnlyMSM = true;
							blnIsProspect = true;
							
						}else {
							lstAccs5.add(iterator);
							//blnIsProspect = true;
							
						}
					}
					if(iterator.TipoCliente__c == 'Cliente Cautivo') {
						if(iterator.RFC__c == accountRecord.RFC__c) {
							lstAccs3.add(iterator);
							//blnWithOnlyMSM = true;
							
						}else {
							lstAccs5.add(iterator);
						}
					}
				}
			}
			if(!lstRegion.isEmpty()) {
				for(DCTRegion__c iterator:lstRegion){
					if(iterator.RFC__c == accountRecord.RFC__c) {
						lstRegion2.add(iterator);
					}else {
						lstRegion2.add(iterator);
					}
				}
			}
			if(!lstProspect.isEmpty()) {
				for(Cliente__c iterator:lstProspect){
					System.debug(loggingLevel.Error, '*** iterator.RecordType.Name: ' + iterator.RecordType.Name);
					System.debug(loggingLevel.Error, '*** accountRecord.RFC__c: ' + accountRecord.RFC__c);
					System.debug(loggingLevel.Error, '*** iterator.RFC1__c: ' + iterator.RFC1__c);
					if(iterator.RecordType.Name == 'Prospecto') {	
						if(iterator.RFC__c == accountRecord.RFC__c || iterator.RFC1__c == accountRecord.RFC__c) {
							lstProspect2.add(iterator);		
							blnWithOnlyMSM = true;
							blnIsProspect = true;
						}else {
							lstProspect5.add(iterator);
						}
					}
					if(iterator.RecordType.Name == 'Cliente Cautivo') {
						if(iterator.RFC__c == accountRecord.RFC__c) {
							lstProspect3.add(iterator);		
						}else {
							lstProspect5.add(iterator);
						}
					}
				}
			}
		}
		System.debug(loggingLevel.Error, '*** lstProspect2: ' + lstProspect2);
		System.debug(loggingLevel.Error, '*** lstProspect3: ' + lstProspect3);
		System.debug(loggingLevel.Error, '*** lstProspect4: ' + lstProspect4);
		System.debug(loggingLevel.Error, '*** lstProspect5: ' + lstProspect5);
		System.debug(loggingLevel.Error, '*** blnIsProspect: ' + blnIsProspect);
		System.debug(loggingLevel.Error, '*** lstRegion2: ' + lstRegion2);
		System.debug(loggingLevel.Error, '*** lstAccs2: ' + lstAccs2);
		System.debug(loggingLevel.Error, '*** lstAccs3: ' + lstAccs3);
		System.debug(loggingLevel.Error, '*** lstAccs4: ' + lstAccs4);
		System.debug(loggingLevel.Error, '*** lstAccs5: ' + lstAccs5);
		if(blnIsProspect) {
			if(!lstAccs2.isEmpty()) {	
				for(Account iterator:lstAccs2){
					if(!mapAccsByName.containsKey(iterator.Name)){
						mapAccsByName.put(iterator.Name, new List<Account>());
					}
					mapAccsByName.get(iterator.Name).add(iterator);
					if(!String.isBlank(iterator.RFC__c)){
						if(!mapAccsByRFC.containsKey(iterator.RFC__c)){
							mapAccsByRFC.put(iterator.RFC__c, new List<Account>());
						}
						mapAccsByRFC.get(iterator.RFC__c).add(iterator);
					}
				}
			}	
			if(!lstRegion2.isEmpty()) {
				for(DCTRegion__c iterator:lstRegion2){
					System.debug(loggingLevel.Error, '*** iterator.EstatusCobranza__c: ' + iterator.EstatusCobranza__c);
					System.debug(loggingLevel.Error, '*** iterator.DCTBillingCycle__c: ' + iterator.DCTBillingCycle__c);
					System.debug(loggingLevel.Error, '*** setCsRejectCycles: ' + setCsRejectCycles);
					System.debug(loggingLevel.Error, '*** setCsRejectCycles.contains(iterator.DCTBillingCycle__c): ' + setCsRejectCycles.contains(iterator.DCTBillingCycle__c));
					if(setCsRejectCycles.contains(iterator.DCTBillingCycle__c)) {
					//if(iterator.DCTBillingCycle__c == '20' || iterator.DCTBillingCycle__c == '60' || iterator.DCTBillingCycle__c == '61' || iterator.DCTBillingCycle__c == '63' || iterator.DCTBillingCycle__c == '31' || iterator.DCTBillingCycle__c == '32' || iterator.DCTBillingCycle__c == '41' || iterator.DCTBillingCycle__c == '42') {
						if(!mapRegByName.containsKey(iterator.Name)){
							mapRegByName.put(iterator.Name, new List<DCTRegion__c>());
							System.debug(loggingLevel.Error, '===Control===');
						}
						mapRegByName.get(iterator.Name).add(iterator);
						if(!String.isBlank(iterator.RFC__c)){
							if(!mapRegByRFC.containsKey(iterator.RFC__c)){
								mapRegByRFC.put(iterator.RFC__c, new List<DCTRegion__c>());
								System.debug(loggingLevel.Error, '===Control2===');
							}
							mapRegByRFC.get(iterator.RFC__c).add(iterator);
						}
					}
				}
			}

			if(!lstProspect2.isEmpty()) {	
				for(Cliente__c iterator:lstProspect2){
					if(!mapProspByName.containsKey(iterator.Name)){
						mapProspByName.put(iterator.Name, new List<Cliente__c>());
					}
					mapProspByName.get(iterator.Name).add(iterator);
					if(!String.isBlank(iterator.RFC__c)){
						if(!mapProspByRFC.containsKey(iterator.RFC__c)){
							mapProspByRFC.put(iterator.RFC__c, new List<Cliente__c>());
						}
						mapProspByRFC.get(iterator.RFC__c).add(iterator);
					}
				}
			}
			System.debug(loggingLevel.Error, '*** mapAccsByName: ' + mapAccsByName);
			System.debug(loggingLevel.Error, '*** mapRegByName: ' + mapRegByName);
			System.debug(loggingLevel.Error, '*** mapAccsByRFC: ' + mapAccsByRFC);
			System.debug(loggingLevel.Error, '*** mapRegByRFC: ' + mapRegByRFC);
			System.debug(loggingLevel.Error, '*** mapProspByName: ' + mapProspByName);
			System.debug(loggingLevel.Error, '*** mapProspByRFC: ' + mapProspByRFC);
			Map<String,Map<String,RecordType>> mapRTsByDevName = TLCL_Utils_cls.getRecordTypes('DeveloperName');
			if(accountRecord.DTC_LegalEntity__c == 'Física' || accountRecord.DTC_LegalEntity__c == 'FÍsica con Actividad Empresarial.') {
				String strconcaName = accountRecord.DCTLastName__c+' '+accountRecord.DCTMotherLastName__c+' '+accountRecord.DCTName__c;
				if(mapAccsByName.containsKey(strconcaName.toUpperCase())|| mapRegByName.containsKey(strconcaName.toUpperCase())|| mapProspByName.containsKey(strconcaName.toUpperCase())){
					duplicateResultWrapperInstance.blnIsValid = false;
					duplicateResultWrapperInstance.lstDupAccs = (mapAccsByName.containsKey(strconcaName.toUpperCase()))?mapAccsByName.get(strconcaName.toUpperCase()):new List<Account>();
					duplicateResultWrapperInstance.lstDupRegs = (mapRegByName.containsKey(strconcaName.toUpperCase()))?mapRegByName.get(strconcaName.toUpperCase()):new List<DCTRegion__c>();
					duplicateResultWrapperInstance.lstDupProsp = (mapProspByName.containsKey(strconcaName.toUpperCase()))?mapProspByName.get(strconcaName.toUpperCase()):new List<Cliente__c>();
					lstErrorMsgs.add(System.Label.DCT_ErrorMessage_lbl);
				}else {
					if(mapAccsByRFC.containsKey(accountRecord.RFC__c.toUpperCase())|| mapRegByRFC.containsKey(accountRecord.RFC__c.toUpperCase())|| mapProspByRFC.containsKey(accountRecord.RFC__c.toUpperCase())){
						duplicateResultWrapperInstance.blnIsValid = false;
						duplicateResultWrapperInstance.lstDupAccs = (mapAccsByRFC.containsKey(accountRecord.RFC__c.toUpperCase()))?mapAccsByRFC.get(accountRecord.RFC__c.toUpperCase()):new List<Account>();
						duplicateResultWrapperInstance.lstDupRegs = (mapRegByRFC.containsKey(accountRecord.RFC__c.toUpperCase()))?mapRegByRFC.get(accountRecord.RFC__c.toUpperCase()):new List<DCTRegion__c>();
						duplicateResultWrapperInstance.lstDupProsp = (mapProspByRFC.containsKey(accountRecord.RFC__c.toUpperCase()))?mapProspByRFC.get(accountRecord.RFC__c.toUpperCase()):new List<Cliente__c>();
						lstErrorMsgs.add(System.Label.DCT_ErrorMessage_lbl);//La razón social ya se encuentra registrada.. Y ya se encuentra en lista de espera
					}
				}
			}
			if(accountRecord.DTC_LegalEntity__c == 'Moral' || accountRecord.DTC_LegalEntity__c == 'Gubernamental') {
				System.debug(loggingLevel.Error, '*** AQUI: ' );
				if(mapAccsByName.containsKey(accountRecord.DCTControlFieldName__c.toUpperCase())|| mapRegByName.containsKey(accountRecord.DCTControlFieldName__c.toUpperCase()) || mapProspByName.containsKey(accountRecord.DCTControlFieldName__c.toUpperCase())){
					duplicateResultWrapperInstance.blnIsValid = false;
					duplicateResultWrapperInstance.lstDupAccs = (mapAccsByName.containsKey(accountRecord.DCTControlFieldName__c.toUpperCase()))?mapAccsByName.get(accountRecord.DCTControlFieldName__c.toUpperCase()):new List<Account>();
					duplicateResultWrapperInstance.lstDupRegs = (mapRegByName.containsKey(accountRecord.DCTControlFieldName__c.toUpperCase()))?mapRegByName.get(accountRecord.DCTControlFieldName__c.toUpperCase()):new List<DCTRegion__c>();
					duplicateResultWrapperInstance.lstDupProsp = (mapProspByName.containsKey(accountRecord.DCTControlFieldName__c.toUpperCase()))?mapProspByName.get(accountRecord.DCTControlFieldName__c.toUpperCase()):new List<Cliente__c>();
					lstErrorMsgs.add(System.Label.DCT_ErrorMessage_lbl);
				}else {
					if(mapAccsByRFC.containsKey(accountRecord.RFC__c.toUpperCase())|| mapRegByRFC.containsKey(accountRecord.RFC__c.toUpperCase())|| mapProspByRFC.containsKey(accountRecord.RFC__c.toUpperCase())){
						duplicateResultWrapperInstance.blnIsValid = false;
						duplicateResultWrapperInstance.lstDupAccs = (mapAccsByRFC.containsKey(accountRecord.RFC__c.toUpperCase()))?mapAccsByRFC.get(accountRecord.RFC__c.toUpperCase()):new List<Account>();
						duplicateResultWrapperInstance.lstDupRegs = (mapRegByRFC.containsKey(accountRecord.RFC__c.toUpperCase()))?mapRegByRFC.get(accountRecord.RFC__c.toUpperCase()):new List<DCTRegion__c>();
						duplicateResultWrapperInstance.lstDupProsp = (mapProspByRFC.containsKey(accountRecord.RFC__c.toUpperCase()))?mapProspByRFC.get(accountRecord.RFC__c.toUpperCase()):new List<Cliente__c>();
						lstErrorMsgs.add(System.Label.DCT_ErrorMessage_lbl);
					}
				}
			}
		} else {
			if(!lstAccs3.isEmpty()) {	
				for(Account iterator:lstAccs3){
					if(!mapAccsByName.containsKey(iterator.Name)){
						mapAccsByName.put(iterator.Name, new List<Account>());
					}
					mapAccsByName.get(iterator.Name).add(iterator);
					if(!String.isBlank(iterator.RFC__c)){
						if(!mapAccsByRFC.containsKey(iterator.RFC__c)){
							mapAccsByRFC.put(iterator.RFC__c, new List<Account>());
						}
						mapAccsByRFC.get(iterator.RFC__c).add(iterator);
					}
				}
			}	
			if(!lstAccs4.isEmpty()) {	
				for(Account iterator:lstAccs4){
					if(!mapAccsByName.containsKey(iterator.Name)){
						mapAccsByName.put(iterator.Name, new List<Account>());
					}
					mapAccsByName.get(iterator.Name).add(iterator);
					if(!String.isBlank(iterator.RFC__c)){
						if(!mapAccsByRFC.containsKey(iterator.RFC__c)){
							mapAccsByRFC.put(iterator.RFC__c, new List<Account>());
						}
						mapAccsByRFC.get(iterator.RFC__c).add(iterator);
					}
				}
			}	
			if(!lstAccs5.isEmpty()) {	
				for(Account iterator:lstAccs5){
					if(!mapAccsByName.containsKey(iterator.Name)){
						mapAccsByName.put(iterator.Name, new List<Account>());
					}
					mapAccsByName.get(iterator.Name).add(iterator);
					if(!String.isBlank(iterator.RFC__c)){
						if(!mapAccsByRFC.containsKey(iterator.RFC__c)){
							mapAccsByRFC.put(iterator.RFC__c, new List<Account>());
						}
						mapAccsByRFC.get(iterator.RFC__c).add(iterator);
					}
				}
			}
			System.debug(loggingLevel.Error, '*** lstRegion2: ' + lstRegion2);	
			if(!lstRegion2.isEmpty()) {
				for(DCTRegion__c iterator:lstRegion2){
					System.debug(loggingLevel.Error, '*** iterator.EstatusCobranza__c: ' + iterator.EstatusCobranza__c);
					System.debug(loggingLevel.Error, '*** iterator.DCTBillingCycle__c: ' + iterator.DCTBillingCycle__c);
					System.debug(loggingLevel.Error, '*** setCsRejectCycles: ' + setCsRejectCycles);
					System.debug(loggingLevel.Error, '*** setCsRejectCycles.contains(iterator.DCTBillingCycle__c): ' + setCsRejectCycles.contains(iterator.DCTBillingCycle__c));
					if(setCsRejectCycles.contains(iterator.DCTBillingCycle__c)) {
					//if(iterator.DCTBillingCycle__c == '20' || iterator.DCTBillingCycle__c == '60' || iterator.DCTBillingCycle__c == '61' || iterator.DCTBillingCycle__c == '63' || iterator.DCTBillingCycle__c == '31' || iterator.DCTBillingCycle__c == '32' || iterator.DCTBillingCycle__c == '41' || iterator.DCTBillingCycle__c == '42') {
						if(!mapRegByName.containsKey(iterator.Name)){
							mapRegByName.put(iterator.Name, new List<DCTRegion__c>());
							System.debug(loggingLevel.Error, '===Control===');
						}
						mapRegByName.get(iterator.Name).add(iterator);
						if(!String.isBlank(iterator.RFC__c)){
							if(!mapRegByRFC.containsKey(iterator.RFC__c)){
								mapRegByRFC.put(iterator.RFC__c, new List<DCTRegion__c>());
								System.debug(loggingLevel.Error, '===Control2===');
							}
							mapRegByRFC.get(iterator.RFC__c).add(iterator);
						}
					}
				}
			}
			if(!lstProspect3.isEmpty()) {	
				for(Cliente__c iterator:lstProspect3){
					if(!mapProspByName.containsKey(iterator.Name)){
						mapProspByName.put(iterator.Name, new List<Cliente__c>());
					}
					mapProspByName.get(iterator.Name).add(iterator);
					if(!String.isBlank(iterator.RFC__c)){
						if(!mapProspByRFC.containsKey(iterator.RFC__c)){
							mapProspByRFC.put(iterator.RFC__c, new List<Cliente__c>());
						}
						mapProspByRFC.get(iterator.RFC__c).add(iterator);
					}
				}
			}
			if(!lstProspect4.isEmpty()) {	
				for(Cliente__c iterator:lstProspect4){
					if(!mapProspByName.containsKey(iterator.Name)){
						mapProspByName.put(iterator.Name, new List<Cliente__c>());
					}
					mapProspByName.get(iterator.Name).add(iterator);
					if(!String.isBlank(iterator.RFC__c)){
						if(!mapProspByRFC.containsKey(iterator.RFC__c)){
							mapProspByRFC.put(iterator.RFC__c, new List<Cliente__c>());
						}
						mapProspByRFC.get(iterator.RFC__c).add(iterator);
					}
				}
			}
			if(!lstProspect5.isEmpty()) {	
				for(Cliente__c iterator:lstProspect5){
					if(!mapProspByName.containsKey(iterator.Name)){
						mapProspByName.put(iterator.Name, new List<Cliente__c>());
					}
					mapProspByName.get(iterator.Name).add(iterator);
					if(!String.isBlank(iterator.RFC__c)){
						if(!mapProspByRFC.containsKey(iterator.RFC__c)){
							mapProspByRFC.put(iterator.RFC__c, new List<Cliente__c>());
						}
						mapProspByRFC.get(iterator.RFC__c).add(iterator);
					}
				}
			}
			System.debug(loggingLevel.Error, '*** mapRegByName: ' + mapRegByName);
			System.debug(loggingLevel.Error, '*** mapRegByRFC: ' + mapRegByRFC);
			System.debug(loggingLevel.Error, '*** accountRecord.DCTControlFieldName__c: ' + accountRecord.DCTControlFieldName__c);
			System.debug(loggingLevel.Error, '*** accountRecord.RFC__c: ' + accountRecord.RFC__c);
			Map<String,Map<String,RecordType>> mapRTsByDevName = TLCL_Utils_cls.getRecordTypes('DeveloperName');
			if(accountRecord.DTC_LegalEntity__c == 'Física' || accountRecord.DTC_LegalEntity__c == 'FÍsica con Actividad Empresarial.') {
				String strconcaName = accountRecord.DCTLastName__c+' '+accountRecord.DCTMotherLastName__c+' '+accountRecord.DCTName__c;
				if(mapAccsByName.containsKey(strconcaName.toUpperCase())|| mapRegByName.containsKey(strconcaName.toUpperCase())|| mapProspByName.containsKey(strconcaName.toUpperCase())){
					duplicateResultWrapperInstance.blnIsValid = false;
					duplicateResultWrapperInstance.lstDupAccs = (mapAccsByName.containsKey(strconcaName.toUpperCase()))?mapAccsByName.get(strconcaName.toUpperCase()):new List<Account>();
					duplicateResultWrapperInstance.lstDupRegs = (mapRegByName.containsKey(strconcaName.toUpperCase()))?mapRegByName.get(strconcaName.toUpperCase()):new List<DCTRegion__c>();
					duplicateResultWrapperInstance.lstDupProsp = (mapProspByName.containsKey(strconcaName.toUpperCase()))?mapProspByName.get(strconcaName.toUpperCase()):new List<Cliente__c>();
					lstErrorMsgs.add('La razón social ya se encuentra registrada.');
				}else {
					if(mapAccsByRFC.containsKey(accountRecord.RFC__c.toUpperCase())|| mapRegByRFC.containsKey(accountRecord.RFC__c.toUpperCase())|| mapProspByRFC.containsKey(accountRecord.RFC__c.toUpperCase())){
						duplicateResultWrapperInstance.blnIsValid = false;
						duplicateResultWrapperInstance.lstDupAccs = (mapAccsByRFC.containsKey(accountRecord.RFC__c.toUpperCase()))?mapAccsByRFC.get(accountRecord.RFC__c.toUpperCase()):new List<Account>();
						duplicateResultWrapperInstance.lstDupRegs = (mapRegByRFC.containsKey(accountRecord.RFC__c.toUpperCase()))?mapRegByRFC.get(accountRecord.RFC__c.toUpperCase()):new List<DCTRegion__c>();
						duplicateResultWrapperInstance.lstDupProsp = (mapProspByRFC.containsKey(accountRecord.RFC__c.toUpperCase()))?mapProspByRFC.get(accountRecord.RFC__c.toUpperCase()):new List<Cliente__c>();
						lstErrorMsgs.add('La razón social ya se encuentra registrada.');
					}
				}
			}
			if(accountRecord.DTC_LegalEntity__c == 'Moral' || accountRecord.DTC_LegalEntity__c == 'Gubernamental') {
				System.debug(loggingLevel.Error, '*** mapAccsByName.containsKey(accountRecord.DCTControlFieldName__c): ' + mapAccsByName.containsKey(accountRecord.DCTControlFieldName__c));
				System.debug(loggingLevel.Error, '*** mapRegByName.containsKey(accountRecord.DCTControlFieldName__c): ' + mapRegByName.containsKey(accountRecord.DCTControlFieldName__c));
				System.debug(loggingLevel.Error, '*** accountRecord.DCTControlFieldName__c: ' + accountRecord.DCTControlFieldName__c);
				if(mapAccsByName.containsKey(accountRecord.DCTControlFieldName__c.toUpperCase())|| mapRegByName.containsKey(accountRecord.DCTControlFieldName__c.toUpperCase())|| mapProspByName.containsKey(accountRecord.DCTControlFieldName__c.toUpperCase())){
					System.debug(loggingLevel.Error, '*** Bandera060460: ');
					duplicateResultWrapperInstance.blnIsValid = false;
					duplicateResultWrapperInstance.lstDupAccs = (mapAccsByName.containsKey(accountRecord.DCTControlFieldName__c.toUpperCase()))?mapAccsByName.get(accountRecord.DCTControlFieldName__c.toUpperCase()):new List<Account>();
					duplicateResultWrapperInstance.lstDupRegs = (mapRegByName.containsKey(accountRecord.DCTControlFieldName__c.toUpperCase()))?mapRegByName.get(accountRecord.DCTControlFieldName__c.toUpperCase()):new List<DCTRegion__c>();
					duplicateResultWrapperInstance.lstDupProsp = (mapProspByName.containsKey(accountRecord.DCTControlFieldName__c.toUpperCase()))?mapProspByName.get(accountRecord.DCTControlFieldName__c.toUpperCase()):new List<Cliente__c>();
					lstErrorMsgs.add('La razón social ya se encuentra registrada.');
				}else {
					if(mapAccsByRFC.containsKey(accountRecord.RFC__c.toUpperCase())|| mapRegByRFC.containsKey(accountRecord.RFC__c.toUpperCase())|| mapProspByRFC.containsKey(accountRecord.RFC__c.toUpperCase())){
						System.debug(loggingLevel.Error, '*** Bandera030299: ');
						duplicateResultWrapperInstance.blnIsValid = false;
						duplicateResultWrapperInstance.lstDupAccs = (mapAccsByRFC.containsKey(accountRecord.RFC__c.toUpperCase()))?mapAccsByRFC.get(accountRecord.RFC__c.toUpperCase()):new List<Account>();
						duplicateResultWrapperInstance.lstDupRegs = (mapRegByRFC.containsKey(accountRecord.RFC__c.toUpperCase()))?mapRegByRFC.get(accountRecord.RFC__c.toUpperCase()):new List<DCTRegion__c>();
						duplicateResultWrapperInstance.lstDupProsp = (mapProspByRFC.containsKey(accountRecord.RFC__c.toUpperCase()))?mapProspByRFC.get(accountRecord.RFC__c.toUpperCase()):new List<Cliente__c>();
						lstErrorMsgs.add('La razón social ya se encuentra registrada.');
					}
				}
			}
			System.debug(loggingLevel.Error, '*** lstErrorMsgs: ' + lstErrorMsgs);
		}

		return duplicateResultWrapperInstance;
	}

	public PageReference cancel(){
		PageReference pr = new PageReference('/a0D');
		return pr;
	}

	public class DuplicateValidationResultWrapper{
		public Boolean blnIsValid;
		public List<Account> lstDupAccs;
		public List<DCTRegion__c> lstDupRegs;
		public List<Cliente__c> lstDupProsp;
	}
}