global class DCT_assignmentNewOwnerAux_bch implements Database.Batchable<sObject> {
	
	String query;
	
	global DCT_assignmentNewOwnerAux_bch(String qParam) {
		query=qParam;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {

		List<Id>                               lstEmailSend       = new List<Id>();
		List<Id>                               lstEmailSend90     = new List<Id>();

		System.debug(loggingLevel.Error, '*** scope: ' + scope);
		System.debug(loggingLevel.Error, '*** scope.size(): ' + scope.size());
		//if(!scope.isEmpty()) {
		//	System.debug(loggingLevel.Error, '*** Paso1: '+Date.today());
		//	for(Cliente__c iterator: scope) {
		//		if(iterator.DCTRegistrationDate__c == Date.today()) {
		//		//if(iterator.DCTRegistrationDate__c == Date.today().addDays(-90)) {
		//			lstEmailSend90.add(iterator.OwnerId);
		//		}
		//		//if(iterator.DCTRegistrationDate__c == Date.today().addDays(-87)) {
		//		if(iterator.DCTRegistrationDate__c == Date.today().addDays(-1)) {
		//			lstEmailSend.add(iterator.OwnerId);
		//		}
		//	}
		//}

		//if(!lstEmailSend90.isEmpty()) {
		//	System.debug(loggingLevel.Error, '*** Paso2: ');
		//	String strEmailTemplateName = system.Label.DCT_strEmailTemplateName_lbl;
		//	EmailTemplate et=[Select id from EmailTemplate WHERE name = 'DCT Advertencia - Notificación 90 Dias' limit 1];
		//	Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
		//	mail.setTargetObjectIds(lstEmailSend90);
		//	//mail.setSenderDisplayName('System Admin');
		//	mail.setSaveAsActivity(false);
		//	mail.setTemplateId(et.id);
		//	System.debug(loggingLevel.Error, '*** mail: ' + mail);
		//	Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
		//}

		//if(!lstEmailSend.isEmpty()) {
		//	System.debug(loggingLevel.Error, '*** Paso2: ');
		//	String strEmailTemplateName = system.Label.DCT_strEmailTemplateName_lbl;
		//	EmailTemplate et=[Select id from EmailTemplate WHERE name = 'DCT Vigencia - Advertencia de Vencimiento' limit 1];
		//	Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
		//	mail.setTargetObjectIds(lstEmailSend);
		//	//mail.setSenderDisplayName('System Admin');
		//	mail.setSaveAsActivity(false);
		//	mail.setTemplateId(et.id);
		//	System.debug(loggingLevel.Error, '*** mail: ' + mail);
		//	Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
		//}
		
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}