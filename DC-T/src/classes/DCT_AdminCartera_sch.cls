global class DCT_AdminCartera_sch implements Schedulable {

	global String sQuery {get;set;}
		
    global void execute(SchedulableContext ctx){
		System.debug('EN DCT_AdminCartera_sch.execute...');

		this.sQuery = 'Select UserReceiver__r.DCTXO__c, IssuingUser__r.DCTXO__c, AccountName__r.RFC__c, AccountName__r.Owner.DCTVT__c,';
		this.sQuery += ' UserReceiver__c, IssuingUser__c';		
		this.sQuery += ' From DCTClientsProspectstoAssigned__c d';		

		//No es una prueba
		//if (!Test.isRunningTest()){
			this.sQuery += ' Where AccountName__r.DCTDateLastassignment__c != NULL';
			this.sQuery += ' And Status__c = \'Aprobado\' And AccountName__r.DCTDateLastassignment__c = TODAY';			
			this.sQuery += ' Order by AccountName__r.DCTDateLastassignment__c ';			
		//}
		
		//Si es una prueba
		//if (Test.isRunningTest())
		//	this.sQuery += ' Where AccountName__r.DCTDateLastassignment__c != NULL Limit 1';

		System.debug('EN DCT_AdminCartera_sch.execute sQuery: ' + sQuery);
		
		//Crea el objeto de  DCT_AdminCartera_bch   	
        DCT_AdminCartera_bch objDepRegCls = new DCT_AdminCartera_bch(sQuery);
        
        //No es una prueba entonces procesa de 1 en 1
       	Id batchInstanceId = Database.executeBatch(objDepRegCls, 25);
			    	 
    }

}