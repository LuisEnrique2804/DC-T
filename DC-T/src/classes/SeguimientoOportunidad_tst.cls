@isTest
private class SeguimientoOportunidad_tst
{

    @IsTest static void createEvent()
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
	        	DataGenerator_cls.createAccount( true, 'Test Acount', 'Corporativo', '');
	        
	        Contact objContact =
	        	DataGenerator_cls.createContact( true, objAccount, 'LastName', 'FirstName' );
	
	        Opportunity objOpportunity =
	        	DataGenerator_cls.createOpportunity( true, 'Opportunity Test',
	        	objAccount, objContact, 'Oportunidad' );
	        
	        SeguimientoOportunidades__c objSO =
	        	DataGenerator_cls.createSeguimientoOportunidad( false, objOpportunity, rtSO);
	        	
	        objSO.Fechaproximaaccion__c = Date.today().addDays( 3 );
	        objSO.Proximaaccion__c = 'Test 1';
	        
	        insert objSO;
	        
	        SeguimientoOportunidades__c objSO2 =
	        	DataGenerator_cls.createSeguimientoOportunidad( true, objOpportunity, rtSO);
	        	 
	        objSO2.Fechaproximaaccion__c = Date.today().addDays( 3 );
	        objSO2.Proximaaccion__c = 'Test 1';
	        
	        update objSO2;
	        
	        list<Event> lstEvent =
	        [
	        	select id
	        	from Event 
	        ];
	        
	        //system.assertEquals( 2, lstEvent.size() );
        test.stopTest();
    }
}