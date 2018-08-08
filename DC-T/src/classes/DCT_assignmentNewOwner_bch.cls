/***************************************************************************************************************************
 * Desarrollado por:  Avanxo México                                                                                        *
 * Autor:             Luis Enrique Garcia Sanabria                                                                         *
 * Email:             legarcia@avanxo.com                                                                                  *
 * Fecha de creación: 18-04-2018                                                                                           *
 ***************************************************************************************************************************
 * Metadata:          DCT_assignmentNewOwner_sch                                                                           *
 ***************************************************************************************************************************
 * Descripción:       Clase batch para realizar el cambio del propietario del DCT(Cuenta) y de y de sus hijos.             *
 *                                                                                                                         *
 ***************************************************************************************************************************
 *                                                Control de versiones                                                     *
 ***************************************************************************************************************************
 * No. |    Fecha   |             Autor            |        Email        |                 Descripción                     *
 ******|************|******************************|*********************|**************************************************
 * 1.0 | 18-04-2018 | Luis Enrique Garcia Sanabria | legarcia@avanxo.com | Creacion de la clase DCT_assignmentNewOwner_bch *
 ***************************************************************************************************************************/

global class DCT_assignmentNewOwner_bch implements Database.Batchable<sObject>, Database.Stateful {	
	
	String query;
	global static BatchSendDays_cs__c mainSettings = BatchSendDays_cs__c.getOrgDefaults();
	global Map<String, String> mapEmailSend90 {get;set;}
	global Map<String, String> mapEmailSend {get;set;}	
	global List<id> lstGloballstEmailSend = new List<id>();
	global DCT_assignmentNewOwner_bch(String qParam) {
		query=qParam;
	}
	global Database.QueryLocator start(Database.BatchableContext BC) {
		 mapEmailSend90 = new Map<String, String>();
		 mapEmailSend = new Map<String, String>();
		 System.debug(loggingLevel.Error, '*** Database.getQueryLocator(query): ' + Database.getQueryLocator(query));
		return Database.getQueryLocator(query);		
	}
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		
		List<Id>                               lstIdAcc           = new List<Id>();
		List<Id>                               lstIdAccproc       = new List<Id>();
		List<Id>                               lstIdNewOwner      = new List<Id>();
		List<String>                           lstNNameAcc        = new List<String>();
		List<Account>                          lstAccUpdate       = new List<Account>();
		List<Account>                          lstClientProced    = new List<Account>();
		List<DCTListUsersAssignment__c>        lstAssigUser       = new List<DCTListUsersAssignment__c>();
		List<DCTListUsersAssignment__c>        lstAccDupProceced2 = new List<DCTListUsersAssignment__c>();
		List<DCTAssignmentDuplicateAccount__c> lstAccDup          = new List<DCTAssignmentDuplicateAccount__c>();
		List<DCTAssignmentDuplicateAccount__c> lstAccDupProceced  = new List<DCTAssignmentDuplicateAccount__c>();
		Map<Id, Id>                            mapAccNewOwner     = new Map<Id, Id>();
		System.debug(loggingLevel.Error, '*** scope.size(): ' + scope.size());
		System.debug(loggingLevel.Error, '*** scope: ' + scope);
		if(!scope.isEmpty()) {
			System.debug(loggingLevel.Error, '*** Date.today().addDays(mainSettings.DCT_SendChange__c): ' + Date.today().addDays(Integer.valueOf(mainSettings.DCT_SendChange__c)));
			System.debug(loggingLevel.Error, '*** Date.today().addDays(mainSettings.DCT_sendNotification__c): ' + Date.today().addDays(Integer.valueOf(mainSettings.DCT_sendNotification__c)));
			for(sObject iterator: scope) {
				Cliente__c clientePaso = (Cliente__c)iterator;
				System.debug(loggingLevel.Error, '*** clientePaso.DCTRegistrationDate__c: ' + clientePaso.DCTRegistrationDate__c);
				if(clientePaso.DCTRegistrationDate__c == Date.today().addDays(Integer.valueOf(mainSettings.DCT_SendChange__c))) {
					lstNNameAcc.add(clientePaso.Name);
					lstIdAcc.add(clientePaso.Cliente__c);
					mapEmailSend90.put(clientePaso.id, clientePaso.OwnerId);
				}
				if(clientePaso.DCTRegistrationDate__c == Date.today().addDays(Integer.valueOf(mainSettings.DCT_sendNotification__c))) {
					mapEmailSend.put(clientePaso.id, clientePaso.OwnerId);
				}
			}
			System.debug(loggingLevel.Error, '*** lstNNameAcc.size(): ' + lstNNameAcc);
			System.debug(loggingLevel.Error, '*** lstIdAcc.size(): ' + lstIdAcc.size());
			System.debug(loggingLevel.Error, '*** mapEmailSend90.size(): ' + mapEmailSend90.size());
			System.debug(loggingLevel.Error, '*** mapEmailSend.size(): ' + mapEmailSend.size());
			if(!lstNNameAcc.isEmpty() || !lstIdAcc.isEmpty()) {	
				lstAccDup =[
					SELECT Assigneduser__c, ExistingCustomer__c, UsertobeAssigned__c 
					FROM DCTAssignmentDuplicateAccount__c 
					WHERE ExistingCustomer__r.Name IN: lstNNameAcc 
					AND Assigneduser__c = false
				];
				lstAccUpdate = [
					SELECT DCT_RegistrationDate__c, Id, OwnerId 
					FROM Account 
					WHERE id IN :lstIdAcc 
				];
				System.debug(loggingLevel.Error, '*** lstAccDup: ' + lstAccDup.size());
				System.debug(loggingLevel.Error, '*** lstAccUpdate: ' + lstAccUpdate.size());
				if(!lstAccDup.isEmpty()) {
					for(DCTAssignmentDuplicateAccount__c iterator: lstAccDup) {
						iterator.Assigneduser__c = true;
						lstIdNewOwner.add(iterator.UsertobeAssigned__c);
						lstAccDupProceced.add(iterator);
						lstIdAccproc.add(iterator.ExistingCustomer__c);
					}
					for(Id iteratorAcc: lstIdAccproc) {
						for(Id iteratorOwner: lstIdNewOwner) {
							mapAccNewOwner.put(iteratorAcc, iteratorOwner);
						}
					}
					if(!mapAccNewOwner.isEmpty()) {
						DCT_assignmentNewOwnerAux_cls.changeOwners(mapAccNewOwner);
					}
					for(Account iterator: lstAccUpdate) {
						if(mapAccNewOwner.containsKey(iterator.id)) {
							iterator.DCT_RegistrationDate__c = System.today();
							iterator.OwnerId = mapAccNewOwner.get(iterator.id);
							lstClientProced.add(iterator);
						}

					}
					Database.SaveResult[] srAcc = Database.update(lstClientProced,true);
					for(Database.SaveResult iteratorSR: srAcc) {
						if(iteratorSR.isSuccess()) {
							System.debug(loggingLevel.Error, '*** EXITO: ');
							Database.SaveResult[] srAccDup = Database.update(lstAccDupProceced,true);
							for(Database.SaveResult iteratorSRAccDup: srAccDup) {
								if(iteratorSRAccDup.isSuccess()) {
									System.debug(loggingLevel.Error, '*** EXITO2: ');
								}
							}
						}
					}
				}else {
					lstAssigUser = [
						SELECT LastModifiedDate, ManagerBatch__c, Name, User__c
						FROM DCTListUsersAssignment__c 
						ORDER BY LastModifiedDate 
						LIMIT 1
					];
					System.debug(loggingLevel.Error, '*** lstAssigUser: ' + lstAssigUser);
					for(DCTListUsersAssignment__c iterator: lstAssigUser) {
						iterator.ManagerBatch__c = 'Usuario Utilizado';
						lstIdNewOwner.add(iterator.User__c);
						lstAccDupProceced2.add(iterator);
					}
					for(Id iteratorAcc: lstIdAcc) {
						for(Id iteratorOwner: lstIdNewOwner) {
							mapAccNewOwner.put(iteratorAcc, iteratorOwner);
						}
					}
					if(!mapAccNewOwner.isEmpty()) {
						DCT_assignmentNewOwnerAux_cls.changeOwners(mapAccNewOwner);
					}
					for(Account iterator: lstAccUpdate) {
						if(mapAccNewOwner.containsKey(iterator.id)) {
							iterator.DCT_RegistrationDate__c = System.today();
							iterator.OwnerId = mapAccNewOwner.get(iterator.id);
							lstClientProced.add(iterator);
						}
					}
					Database.SaveResult[] srAcc = Database.update(lstClientProced,true);
					for(Database.SaveResult iteratorSR: srAcc) {
						if(iteratorSR.isSuccess()) {
							System.debug(loggingLevel.Error, '*** EXITO3: ');
							Database.Saveresult[] srAccDup = Database.update(lstAccDupProceced2,true);
							for(Database.SaveResult iteratorSRAccDup: srAccDup) {
								if(iteratorSRAccDup.isSuccess()) {
									System.debug(loggingLevel.Error, '*** EXITO4: ');
								}
							}
						}
					}
				}
			}	
		}
		
	}
	
	global void finish(Database.BatchableContext BC) {	
		System.debug('mapEmailSend90: ' + mapEmailSend90.size());		
		System.debug('mapEmailSend: ' + mapEmailSend.size());		
		Map<String, String> mapIdUsrEmail = new Map<String, String>();
		Map<String, String> mapIdUsrEmail2 = new Map<String, String>();
		Map<String, List<User>> mapEmailDatosUsr = new Map<String, List<User>>();  	
		Map<String, List<User>> mapEmailDatosUsr2 = new Map<String, List<User>>();  		
		Map<String, String> mapContactEmail = new Map<String, String>();
		Map<String, String> mapContactEmail2 = new Map<String, String>();
		Map<String, Contact> mapContactUps = new Map<String, Contact>();
		Map<String, Contact> mapContactUps2 = new Map<String, Contact>();
		Set<String> setIdContaUps = new Set<String>();
		Set<String> setIdContaUps2 = new Set<String>();
		List<Messaging.SendEmailResult> lRepuestaReceiver = new List<Messaging.SendEmailResult>();
		List<Messaging.singleemailMessage> lSingleemailMessage = new List<Messaging.singleemailMessage>();
		List<Messaging.singleemailMessage> lSingleemailMessage2 = new List<Messaging.singleemailMessage>();
		id idSend = '0031100001PWgdI';
		System.debug(loggingLevel.Error, '*** idSend: ' + idSend);
		
		if (!mapEmailSend90.isEmpty()){
			//Los datos del usuario
			for (User usuario : [SELECT id, Email, Name, LastName, FirstName 
				FROM User WHERE ID IN: mapEmailSend90.values()]){
				System.debug(loggingLevel.Error, '*** usuario: ' + usuario);
				if (usuario.Email != NULL){
					mapIdUsrEmail.put(usuario.id, usuario.Email);
					if (mapEmailDatosUsr.containsKey(usuario.Email))
						mapEmailDatosUsr.get(usuario.Email).Add(usuario);
					if (!mapEmailDatosUsr.containsKey(usuario.Email))							
						mapEmailDatosUsr.put(usuario.Email, new List<User>{usuario});
				}//Fin si usuario.Email != NULL
			}			
								
			//Los datos de los contactos asociados a los usuarios
			for (Contact contacto : [SELECT id, Email FROM Contact WHERE Email IN: mapIdUsrEmail.values()]){
				mapContactEmail.put(contacto.Email, contacto.id);
			}
			System.debug(loggingLevel.Error, '*** mapIdUsrEmail: ' + mapIdUsrEmail);
			System.debug(loggingLevel.Error, '*** mapContactEmail: ' + mapContactEmail);
			System.debug(loggingLevel.Error, '*** mapEmailDatosUsr: ' + mapEmailDatosUsr);
			//Ve si existen todos los contactos asociados a los usuarios y si no crealos
			for (String sEmailUsr : mapIdUsrEmail.values()){
				//Crea el nuevo contacto apartir de los datos del usuario si no existe en mapContactEmail
				if (!mapContactEmail.containsKey(sEmailUsr)){
					mapContactUps.put(sEmailUsr, new Contact(
							FirstName = mapEmailDatosUsr.get(sEmailUsr).get(0).FirstName,
							LastName = mapEmailDatosUsr.get(sEmailUsr).get(0).LastName,
							Email = sEmailUsr
						)
					);
				}///Fin si !mapContactEmail.contaisnKey(sEmailUsr)
			}//Fin del for para mapIdUsrEmail.values()
			//Ve si hay nuevos contacto que agregar
			System.debug(loggingLevel.Error, '*** mapContactUps: ' + mapContactUps);
			if (!mapContactUps.isEmpty()){
				List<Database.Upsertresult> lDtupr = Database.upsert(mapContactUps.values(), Contact.id, false);
				for (Database.Upsertresult dtupr : lDtupr){
					if (dtupr.isSuccess()) 
						setIdContaUps.add(dtupr.getId());
					if (!dtupr.isSuccess())
						System.debug('*** ERROR al crear el contacto: ' + dtupr.getErrors()[0].getMessage());
				}//Fin del for para lDtupr
			}//Fin si !mapContactUps.isEmpty()
			//Consulta los contactos recien creados
			for(Contact NvoContc : [Select id, Email From Contact Where id IN:setIdContaUps
				And Email != null]){
				mapContactEmail.put(NvoContc.Email, NvoContc.id);					
			}
		}

		if (!mapEmailSend.isEmpty()){
			//Los datos del usuario
			for (User usuario : [SELECT id, Email, Name, LastName, FirstName 
				FROM User WHERE ID IN: mapEmailSend.values()]){
				if (usuario.Email != NULL){
					mapIdUsrEmail2.put(usuario.id, usuario.Email);
					if (mapEmailDatosUsr2.containsKey(usuario.Email))
						mapEmailDatosUsr2.get(usuario.Email).Add(usuario);
					if (!mapEmailDatosUsr2.containsKey(usuario.Email))							
						mapEmailDatosUsr2.put(usuario.Email, new List<User>{usuario});
				}
			}			
								
			for (Contact contacto : [SELECT id, Email FROM Contact WHERE Email IN: mapIdUsrEmail2.values()]){
				mapContactEmail2.put(contacto.Email, contacto.id);
			}
			System.debug(loggingLevel.Error, '*** mapContactEmail2: ' + mapContactEmail2);
			for (String sEmailUsr : mapIdUsrEmail2.values()){
				System.debug(loggingLevel.Error, '*** sEmailUsr: ' + sEmailUsr);
				if (!mapContactEmail2.containsKey(sEmailUsr)){
					mapContactUps2.put(sEmailUsr, new Contact(
							FirstName = mapEmailDatosUsr2.get(sEmailUsr).get(0).FirstName,
							LastName = mapEmailDatosUsr2.get(sEmailUsr).get(0).LastName,
							Email = sEmailUsr
						)
					);
				}
			}

			if (!mapContactUps2.isEmpty()){
				List<Database.Upsertresult> lDtupr = Database.upsert(mapContactUps2.values(), Contact.id, false);
				for (Database.Upsertresult dtupr : lDtupr){
					if (dtupr.isSuccess()) 
						setIdContaUps2.add(dtupr.getId());
					if (!dtupr.isSuccess())
						System.debug('*** ERROR al crear el contacto: ' + dtupr.getErrors()[0].getMessage());
				}
			}
			for(Contact NvoContc : [Select id, Email From Contact Where id IN :setIdContaUps2 And Email != null]){
				mapContactEmail2.put(NvoContc.Email, NvoContc.id);					
			}
		}

		if(!mapEmailSend90.isEmpty()) {
			Integer cNoReg = 0;
			String strEmailTemplateName = system.Label.DCT_strEmailTemplateName_lbl;
			EmailTemplate et=[Select id from EmailTemplate WHERE name = 'DCT Advertencia - Notificación 90 Dias' limit 1];
			for (String sIdClientePaso : mapEmailSend90.KeySet()){
				System.debug('*** sIdClientePaso: ' + sIdClientePaso + ' Contacto: ' + mapContactEmail.get(mapIdUsrEmail.get(mapEmailSend90.get(sIdClientePaso))));					
				//Crea el mensaje
				Messaging.SingleEmailMessage mailUsrReceiver = new Messaging.SingleEmailMessage();
				mailUsrReceiver.setSenderDisplayName('Telcel-90'); 
				mailUsrReceiver.setUseSignature(false);  
				mailUsrReceiver.setSaveAsActivity(false); 
				mailUsrReceiver.setTargetObjectId( mapContactEmail.get(mapIdUsrEmail.get(mapEmailSend90.get(sIdClientePaso))) );			        
				//mailUsrReceiver.setTargetObjectId(idSend);			        
				mailUsrReceiver.setWhatId(sIdClientePaso);					
				mailUsrReceiver.setTemplateId(et.id);		
				mailUsrReceiver.setCcAddresses(new List<String>{'legarcia@avanxo.com'});			        
				//Metelo a la lista	
				if(mailUsrReceiver.getTargetObjectId() != null ) {
					lSingleemailMessage.add(mailUsrReceiver);				
				}			
				cNoReg++;				    
			}
			System.debug(loggingLevel.Error, '*** lSingleemailMessage: ' + lSingleemailMessage);
			Messaging.SendEmailResult[] repuestaReceiver = Messaging.sendEmail(lSingleemailMessage);	        
			System.debug(loggingLevel.Error, '*** repuestaReceiver: ' + repuestaReceiver);
			//Ve si hubo error
			if (repuestaReceiver[0].success)
				System.debug('El correo para el usuario. ');
			else
				System.debug('Hubo error a la hora del enviar el correo al usuario Error: ' + repuestaReceiver[0].errors[0].message);			
		}

		if(!mapEmailSend.isEmpty()) {
			Integer cNoReg = 0;
			String strEmailTemplateName = system.Label.DCT_strEmailTemplateName_lbl;
			EmailTemplate et=[Select id from EmailTemplate WHERE name = 'DCT Vigencia - Advertencia de Vencimiento' limit 1];
			for (String sIdClientePaso : mapEmailSend.KeySet()){
				System.debug(loggingLevel.Error, '******************************************************************************');
				System.debug(loggingLevel.Error, '*** sIdClientePaso: ' + sIdClientePaso);
				System.debug(loggingLevel.Error, '*** mapEmailSend: ' + mapEmailSend);
				System.debug(loggingLevel.Error, '*** mapIdUsrEmail2: ' + mapIdUsrEmail2);
				System.debug(loggingLevel.Error, '*** mapContactEmail2: ' + mapContactEmail2);
				System.debug(loggingLevel.Error, '******************************************************************************');
				System.debug(loggingLevel.Error, '*** mapEmailSend.get(sIdClientePaso): ' + mapEmailSend.get(sIdClientePaso));
				System.debug(loggingLevel.Error, '*** mapIdUsrEmail2.get(mapEmailSend.get(sIdClientePaso)): ' + mapIdUsrEmail2.get(mapEmailSend.get(sIdClientePaso)));
				System.debug(loggingLevel.Error, '*** Contacto: ' + mapContactEmail2.get(mapIdUsrEmail2.get(mapEmailSend.get(sIdClientePaso))));					
				System.debug(loggingLevel.Error, '******************************************************************************');
				if(mapContactEmail2.get(mapIdUsrEmail2.get(mapEmailSend.get(sIdClientePaso))) != null) {
					Messaging.SingleEmailMessage mailUsrReceiver = new Messaging.SingleEmailMessage();
					mailUsrReceiver.setSenderDisplayName('Telcel-87'); 
					mailUsrReceiver.setUseSignature(false);  
					mailUsrReceiver.setSaveAsActivity(false); 
					//mailUsrReceiver.setTargetObjectId(idSend);	
					mailUsrReceiver.setTargetObjectId( mapContactEmail2.get(mapIdUsrEmail2.get(mapEmailSend.get(sIdClientePaso))) );			        
					mailUsrReceiver.setWhatId(sIdClientePaso);					
					mailUsrReceiver.setTemplateId(et.id);
					mailUsrReceiver.setCcAddresses(new List<String>{'legarcia@avanxo.com'});			 	        
					lSingleemailMessage2.add(mailUsrReceiver);				
				}
				cNoReg++;				    
			}
			System.debug(loggingLevel.Error, '*** lSingleemailMessage2: ' + lSingleemailMessage2);
			if(lSingleemailMessage2.size()>0) {
				Messaging.SendEmailResult[] repuestaReceiver = Messaging.sendEmail(lSingleemailMessage2);	        
				if (repuestaReceiver[0].success)
					System.debug('El correo para el usuario. ');
				else
					System.debug('Hubo error a la hora del enviar el correo al usuario Error: ' + repuestaReceiver[0].errors[0].message);			
			}
			
		}	
	}
}