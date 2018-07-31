@isTest (SeeAllData = true)
private class batchCrearOportunidades_tst {

    @isTest static void myUnitTest() {
    	
    	Test.startTest();	
    	
	    	 set<Id> sID = new set<Id>();
	    	 sID.add(userInfo.getUserId());
	    	     	 
	    	 Account 								Cliente					= DataGenerator_cls.createAccount(true, 'Cliente Test', 'Corporativo', '');
	    	 Contact 								Contacto 				= DataGenerator_cls.createContacto(true, Cliente.Id, 'CC01', 'DD01');
	    	 Opportunity 							Opp 					= DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
	    	 
			 set<Id> sIdCuenta = new set<Id>();
			 sIdCuenta.add(Cliente.Id);
	    	 list<Account> lstAcc = new list<Account>();
	    	 lstAcc.add(Cliente);
	         /*batchCrearOportunidades obj = new batchCrearOportunidades(sID, sIdCuenta, 1, Opp,'Corporativo','Industria','Industria');
	
			 Database.BatchableContext BC;
		     obj.start(BC); 		     
		     obj.execute(BC, lstAcc);      
		     obj.finish(BC);  
             */
    	Test.stopTest();     
    }
}