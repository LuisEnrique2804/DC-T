/***************************************************************************************************************************
 * Desarrollado por:  Avanxo México                                                                                        *
 * Autor:             Luis Enrique Garcia Sanabria                                                                         *
 * Email:             legarcia@avanxo.com                                                                                  *
 * Fecha de creación: 18-04-2018                                                                                           *
 ***************************************************************************************************************************
 * Metadata:          DCT_assignmentNewOwner_bch                                                                           *
 ***************************************************************************************************************************
 * Descripción:       Clase que ejecuta por medio de un proceso batch para realizar el cambio del propietario del          *
 *                    DCT(Cuenta) y de todos los objetos relacionados con el, asi como los objetos que se relacionan con   *
 *                    los relacionados a estos y se va a seleccionar el usuario de uno de los siguientes objetos:          *
 *                    DCTListUsersAssignment__c y DCTAssignmentDuplicateAccount__c, validando sino existe registro de que  *
 *                    se intento duplicar una cuenta se usara el primer registro de  DCTListUsersAssignment__c y en caso   *
 *                    contrario se usara el usuario que intento registrar esa cuenta.                                      *
 *                                                                                                                         *
 ***************************************************************************************************************************
 *                                                Control de versiones                                                     *
 ***************************************************************************************************************************
 * No. |    Fecha   |             Autor            |        Email        |                 Descripción                     *
 ******|************|******************************|*********************|**************************************************
 * 1.0 | 18-04-2018 | Luis Enrique Garcia Sanabria | legarcia@avanxo.com | Creacion de la clase DCT_assignmentNewOwner_cls *
 ***************************************************************************************************************************/
public class DCT_assignmentNewOwner_cls {
	
	//public static void newOwner(List<Cliente__c> lstClient){
		
	//	List<Id>                               lstIdAcc           = new List<Id>();
	//	List<Id>                               lstIdAccproc       = new List<Id>();
	//	List<Id>                               lstIdNewOwner      = new List<Id>();
	//	List<Id>                               lstEmailSend       = new List<Id>();
	//	List<Id>                               lstEmailSend90     = new List<Id>();
	//	List<String>                           lstNNameAcc        = new List<String>();
	//	List<Account>                          lstAccUpdate       = new List<Account>();
	//	List<Account>                          lstClientProced    = new List<Account>();
	//	List<DCTListUsersAssignment__c>        lstAssigUser       = new List<DCTListUsersAssignment__c>();
	//	List<DCTListUsersAssignment__c>        lstAccDupProceced2 = new List<DCTListUsersAssignment__c>();
	//	List<DCTAssignmentDuplicateAccount__c> lstAccDup          = new List<DCTAssignmentDuplicateAccount__c>();
	//	List<DCTAssignmentDuplicateAccount__c> lstAccDupProceced  = new List<DCTAssignmentDuplicateAccount__c>();
	//	Map<Id, Id>                            mapAccNewOwner     = new Map<Id, Id>();

	//	System.debug(loggingLevel.Error, '*** lstClient: ' + lstClient);
	//	System.debug(loggingLevel.Error, '*** lstClient.size(): ' + lstClient.size());
	//	if(!lstClient.isEmpty()) {
	//		System.debug(loggingLevel.Error, '*** Paso1: '+Date.today());
	//		for(Cliente__c iterator: lstClient) {
	//			if(iterator.DCTRegistrationDate__c == Date.today()) {
	//			//if(iterator.DCTRegistrationDate__c == Date.today().addDays(-90)) {
	//				lstNNameAcc.add(iterator.Name);
	//				lstIdAcc.add(iterator.Cliente__c);
	//				lstEmailSend90.add(iterator.OwnerId);
	//			}
	//			//if(iterator.DCTRegistrationDate__c == Date.today().addDays(-87)) {
	//			if(iterator.DCTRegistrationDate__c == Date.today().addDays(-1)) {
	//				lstEmailSend.add(iterator.OwnerId);
	//			}
	//		}
	//		System.debug(loggingLevel.Error, '*** lstNNameAcc.size(): ' + lstNNameAcc.size());
	//		System.debug(loggingLevel.Error, '*** lstIdAcc.size(): ' + lstIdAcc.size());
	//		System.debug(loggingLevel.Error, '*** lstNNameAcc: ' + lstNNameAcc);
	//		System.debug(loggingLevel.Error, '*** lstIdAcc: ' + lstIdAcc);
	//		if(!lstNNameAcc.isEmpty() && !lstIdAcc.isEmpty()) {	
	//			lstAccDup =[
	//				SELECT Assigneduser__c, ExistingCustomer__c, UsertobeAssigned__c 
	//				FROM DCTAssignmentDuplicateAccount__c 
	//				WHERE ExistingCustomer__r.Name IN: lstNNameAcc 
	//				AND Assigneduser__c = false
	//			];
	//			lstAccUpdate = [
	//				SELECT DCT_RegistrationDate__c, Id, OwnerId 
	//				FROM Account 
	//				WHERE id IN :lstIdAcc 
	//			];
	//			System.debug(loggingLevel.Error, '*** lstAccDup: ' + lstAccDup);
	//			System.debug(loggingLevel.Error, '*** lstAccUpdate: ' + lstAccUpdate);
	//			if(!lstAccDup.isEmpty()) {
	//				for(DCTAssignmentDuplicateAccount__c iterator: lstAccDup) {
	//					iterator.Assigneduser__c = true;
	//					lstIdNewOwner.add(iterator.UsertobeAssigned__c);
	//					lstAccDupProceced.add(iterator);
	//					lstIdAccproc.add(iterator.ExistingCustomer__c);
	//				}
	//				for(Id iteratorAcc: lstIdAccproc) {
	//					for(Id iteratorOwner: lstIdNewOwner) {
	//						mapAccNewOwner.put(iteratorAcc, iteratorOwner);
	//					}
	//				}
	//				System.debug(loggingLevel.Error, '*** mapAccNewOwner: ' + mapAccNewOwner);
	//				if(!mapAccNewOwner.isEmpty()) {
	//					DCT_assignmentNewOwnerAux_cls.changeOwners(mapAccNewOwner);
	//				}
	//				for(Account iterator: lstAccUpdate) {
	//					if(mapAccNewOwner.containsKey(iterator.id)) {
	//						iterator.DCT_RegistrationDate__c = System.today();
	//						iterator.OwnerId = mapAccNewOwner.get(iterator.id);
	//						lstClientProced.add(iterator);
	//					}

	//				}
	//				Database.SaveResult[] srAcc = Database.update(lstClientProced,true);
	//				for(Database.SaveResult iteratorSR: srAcc) {
	//					if(iteratorSR.isSuccess()) {
	//						System.debug(loggingLevel.Error, '*** EXITO: ');
	//						Database.SaveResult[] srAccDup = Database.update(lstAccDupProceced,true);
	//						for(Database.SaveResult iteratorSRAccDup: srAccDup) {
	//							if(iteratorSRAccDup.isSuccess()) {
	//								System.debug(loggingLevel.Error, '*** EXITO2: ');
	//							}
	//						}
	//					}
	//				}
	//			}else {
	//				lstAssigUser = [
	//					SELECT LastModifiedDate, ManagerBatch__c, Name, User__c
	//					FROM DCTListUsersAssignment__c 
	//					ORDER BY LastModifiedDate 
	//					LIMIT 1
	//				];
	//				System.debug(loggingLevel.Error, '*** lstAssigUser: ' + lstAssigUser);
	//				for(DCTListUsersAssignment__c iterator: lstAssigUser) {
	//					iterator.ManagerBatch__c = 'Usuario Utilizado';
	//					lstIdNewOwner.add(iterator.User__c);
	//					lstAccDupProceced2.add(iterator);
	//				}
	//				for(Id iteratorAcc: lstIdAcc) {
	//					for(Id iteratorOwner: lstIdNewOwner) {
	//						mapAccNewOwner.put(iteratorAcc, iteratorOwner);
	//					}
	//				}
	//				System.debug(loggingLevel.Error, '*** mapAccNewOwner: ' + mapAccNewOwner);
	//				if(!mapAccNewOwner.isEmpty()) {
	//					DCT_assignmentNewOwnerAux_cls.changeOwners(mapAccNewOwner);
	//				}
	//				for(Account iterator: lstAccUpdate) {
	//					if(mapAccNewOwner.containsKey(iterator.id)) {
	//						iterator.DCT_RegistrationDate__c = System.today();
	//						iterator.OwnerId = mapAccNewOwner.get(iterator.id);
	//						lstClientProced.add(iterator);
	//					}
	//				}
	//				Database.SaveResult[] srAcc = Database.update(lstClientProced,true);
	//				for(Database.SaveResult iteratorSR: srAcc) {
	//					if(iteratorSR.isSuccess()) {
	//						System.debug(loggingLevel.Error, '*** EXITO3: ');
	//						Database.SaveResult[] srAccDup = Database.update(lstAccDupProceced2,true);
	//						for(Database.SaveResult iteratorSRAccDup: srAccDup) {
	//							if(iteratorSRAccDup.isSuccess()) {
	//								System.debug(loggingLevel.Error, '*** EXITO4: ');
	//							}
	//						}
	//					}
	//				}
	//			}
	//		}	
	//		//if(!lstEmailSend90.isEmpty()) {
	//		//	System.debug(loggingLevel.Error, '*** Paso2: ');
	//		//	String strEmailTemplateName = system.Label.DCT_strEmailTemplateName_lbl;
	//		//	EmailTemplate et=[Select id from EmailTemplate WHERE name = 'DCT Advertencia - Notificación 90 Dias' limit 1];
	//		//	Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
	//		//	mail.setTargetObjectIds(lstEmailSend90);
	//		//	//mail.setSenderDisplayName('System Admin');
	//		//	mail.setSaveAsActivity(false);
	//		//	mail.setTemplateId(et.id);
	//		//	System.debug(loggingLevel.Error, '*** mail: ' + mail);
	//		//	Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
	//		//}

	//		//if(!lstEmailSend.isEmpty()) {
	//		//	System.debug(loggingLevel.Error, '*** Paso2: ');
	//		//	String strEmailTemplateName = system.Label.DCT_strEmailTemplateName_lbl;
	//		//	EmailTemplate et=[Select id from EmailTemplate WHERE name = 'DCT Vigencia - Advertencia de Vencimiento' limit 1];
	//		//	Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
	//		//	mail.setTargetObjectIds(lstEmailSend);
	//		//	//mail.setSenderDisplayName('System Admin');
	//		//	mail.setSaveAsActivity(false);
	//		//	mail.setTemplateId(et.id);
	//		//	System.debug(loggingLevel.Error, '*** mail: ' + mail);
	//		//	Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
	//		//}
	//	}
	
		
	//}

	//@future(callout=true)
 //   public static void approvalClass(List<id> lstIds) {
	//    System.debug(loggingLevel.Error, '*** Paso2: ');
	//	String strEmailTemplateName = system.Label.DCT_strEmailTemplateName_lbl;
	//	EmailTemplate et=[Select id from EmailTemplate WHERE name = 'DCT Vigencia - Advertencia de Vencimiento' limit 1];
	//	Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
	//	mail.setTargetObjectIds(lstIds);
	//	//mail.setSenderDisplayName('System Admin');
	//	mail.setSaveAsActivity(false);
	//	mail.setTemplateId(et.id);
	//	System.debug(loggingLevel.Error, '*** mail: ' + mail);
	//	Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
 //   }
}