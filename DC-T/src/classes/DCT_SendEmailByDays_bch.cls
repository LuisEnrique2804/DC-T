global class DCT_SendEmailByDays_bch implements Database.Batchable<sObject> {
	
	String query;
	
	global DCT_SendEmailByDays_bch(String qParam) {
		query=qParam;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug(loggingLevel.Error, '*** query: ' + query);
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		DCT_SendEmailByDays_cls.sendEmail(scope);
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}