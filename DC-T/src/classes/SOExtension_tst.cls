@isTest (SeeAllData = true)
private class SOExtension_tst {

    @isTest static void myUnitTest() {
        test.startTest();
        	String					rtSO					= '';
			for(RecordType rt : [SELECT DeveloperName,Name,SobjectType FROM RecordType])
			{
				if (rt.SobjectType == 'SeguimientoOportunidades__c' && rt.developerName == 'Corporativo'){
					rtSO = rt.id;
				}
				
			}
        
        	Account 		Cliente		= DataGenerator_cls.createAccount(true, 'Cliente Test', 'Corporativo', '');
			Contact 		Contacto 	= DataGenerator_cls.createContacto(true, Cliente.Id, 'CC01', 'DD01');
	        Opportunity 	Opp 		= DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
	        SeguimientoOportunidades__c objSO = DataGenerator_cls.createSeguimientoOportunidad( false, Opp, rtSO);
	        
	        ApexPages.Standardcontroller stdController;
	        stdController = new Apexpages.Standardcontroller(objSO);
	        SOExtension objController = new SOExtension(stdController);
	        
	        objController.sigAtt();
	        objController.antAtt();
	        
        test.stopTest();
    }
}