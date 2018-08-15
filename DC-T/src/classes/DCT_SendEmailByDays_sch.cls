global class DCT_SendEmailByDays_sch implements Schedulable {
	global void execute(SchedulableContext sc) {
		Date dateValid = System.today();
		System.debug(loggingLevel.Error, '*** dateValid: ' + dateValid);
		String dateValid2 = String.valueof(dateValid);
		System.debug(loggingLevel.Error, '*** dateValid2: ' + dateValid2);
		String strQueryOverCases = 'SELECT Id, DCTDateBonus__c, OwnerId FROM Cliente__c WHERE DCTDateBonus__c > '+dateValid2+'';
		system.debug('***strQueryOverCases: '+strQueryOverCases);
		DCT_SendEmailByDays_bch bchInstace = new DCT_SendEmailByDays_bch(strQueryOverCases);
		//MyBatchClass b = new MyBatchClass();
		database.executebatch(bchInstace,200);
	}
}

/*
Date dateValid = System.today();
String dateValid2 = String.valueof(dateValid);
//dateValid2 = dateValid2 +'-';
//dateValid2 = dateValid2 + String.valueof(dateValid.month())< '10'?'0'+String.valueof(dateValid.month()):String.valueof(dateValid.month());
String strQueryOverCases = 'SELECT Id, DCTDateBonus__c FROM Cliente__c WHERE DCTDateBonus__c > :'+dateValid2+'';
system.debug('***strQueryOverCases: '+strQueryOverCases);
DCT_SendEmailByDays_bch bchInstance = new DCT_SendEmailByDays_bch(strQuery);
Id batchJobId = Database.executeBatch(bchInstance, 200);
system.debug('***batchJobId: '+batchJobId);
+'-'+dateValid.day()<=9?'0'+dateValid.day():dateValid.day()
*/