global class EvaluarAlarmasSegOportunidadBtch implements Database.Batchable<SObject> {
	 
	String query;
	
	global EvaluarAlarmasSegOportunidadBtch() {
		query = 'SELECT '+String.join(new List<String>(SObjectType.SeguimientoOportunidades__c.Fields.getMap().keySet()),', ')+' FROM SeguimientoOportunidades__c'; 
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query); 
	}

   	global void execute(Database.BatchableContext BC, List<SeguimientoOportunidades__c> scope) {
		if (!Test.isRunningTest()) update scope;
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}