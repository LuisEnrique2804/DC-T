@isTest (SeeAllData = true)
private class SeguimientoOpp_tst {

    @isTest static void myUnitTest() {
    	test.startTest();
    		String					rtSO					= '';
			for(RecordType rt : [SELECT DeveloperName,Name,SobjectType FROM RecordType])
			{
				if (rt.SobjectType == 'SeguimientoOportunidades__c' && rt.developerName == 'Corporativo'){
					rtSO = rt.id;
				}
				
			}
    	
	        PageReference pageRef = Page.InformacionAnalisisEstrategico;
	        Test.setCurrentPage(pageRef);
	        
	        String nextPage = '/apex/';
	        Account 		Cliente		= DataGenerator_cls.createAccount(true, 'TELCEL', 'Corporativo', '');
			Contact 		Contacto 	= DataGenerator_cls.createContacto(true, Cliente.Id, 'CC01', 'DD01');
	        //MapaCliente__c	Mapa 		= DataGenerator_cls.createMapaCliente(true, Cliente.Id, '');	
	        Opportunity 	Opp 		= DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
	        SeguimientoOportunidades__c objSO = DataGenerator_cls.createSeguimientoOportunidad( true, Opp, rtSO);
	        SoportedentroTelcel__c SDT  = DataGenerator_cls.createSoporteDentroTelcel(true, Contacto, objSO);
	        
	        
	        ApexPages.Standardcontroller stdController;
	        stdController = new Apexpages.Standardcontroller(SDT);
	        SeguimientoOportunidadListasExtension objController = new SeguimientoOportunidadListasExtension(stdController);	
	        
	        
	        objController.siguienteSoportes();
	        objController.anteriorSoportes();
	        objController.siguienteDirectrices();
	        objController.anteriorDirectrices();
	   
    	test.stopTest();
      
    }
}