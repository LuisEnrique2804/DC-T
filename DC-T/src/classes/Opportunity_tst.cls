@IsTest (SeeAllData=true)
private class Opportunity_tst {

    @IsTest static void testCreateSeguimientoOportunidad()
    {
    	test.startTest();
	 		String					rtSO					= '';
			for(RecordType rt : [SELECT DeveloperName,Name,SobjectType FROM RecordType])
			{
				if (rt.SobjectType == 'SeguimientoOportunidades__c' && rt.developerName == 'Corporativo'){
					rtSO = rt.id;
				}
				
			}
	 
	        Account objAccount =
	        	DataGenerator_cls.createAccount( true, 'Test Acount', 'Corporativo','');
	        
	        Contact objContact =
	        	DataGenerator_cls.createContact( true, objAccount, 'LastName', 'FirstName' );
	
	        Opportunity objOpportunity =
	        	DataGenerator_cls.createOpportunity( true, 'Opportunity Test',
	        	objAccount, objContact, 'Oportunidad' );
	        	
	        SeguimientoOportunidades__c objSO2 = DataGenerator_cls.createSeguimientoOportunidad( true, objOpportunity, rtSO);
	        
	        list<SeguimientoOportunidades__c> lstSO =
	        [
	        	select Id
	        	from SeguimientoOportunidades__c
	        	where Embudo__c = :objOpportunity.Id
	        ];
	        
	        system.assertEquals( 1, lstSO.size() );
		test.stopTest();
    }
}