@isTest (SeeAllData = true)
private class testAPEXCorporativoDBC_tst {

    @IsTest static void myUnitTest() {
        test.startTest();
			PageReference pageRef = Page.InformacionAnalisisEstrategico;
	        Test.setCurrentPage(pageRef);
	        
	        String nextPage = '/apex/';
	        Account 		Cliente		= DataGenerator_cls.createAccount(true, 'Cliente Test', 'Corporativo', '');
			Contact 		Contacto 	= DataGenerator_cls.createContacto(true, Cliente.Id, 'CC01', 'DD01');
	        //MapaCliente__c	Mapa 		= DataGenerator_cls.createMapaCliente(true, Cliente.Id, '');	
	        
	        //Opportunity 	Opp 		= DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
	        
	        ApexPages.Standardcontroller stdController;
	        stdController = new Apexpages.Standardcontroller(Cliente);
	        testAPEXCorporativoDatosBasicoCliente objController = new testAPEXCorporativoDatosBasicoCliente(stdController);
	        
	        objController.cambios();
	    	//objController.guardarCambios();
	    	
	    	objController.cambiarModoCampo1();
	        objController.cambiarModoCampo2();
	        objController.cambiarModoCampo3();
	        objController.cambiarModoCampo4();
	        objController.cambiarModoCampo5();
	        objController.cambiarModoCampo6();
	        
	        objController.siguienteConocimiento();
	        objController.anteriorConocimiento();
	        objController.siguienteCompetencia();
	        objController.anteriorCompetencia();
	        objController.siguienteOportunidades();
	        objController.anteriorOportunidades();
	        objController.siguienteInterlocutores();
	        objController.anteriorInterlocutores();
	        objController.siguienteDirectriz();
	        objController.anteriorDirectriz();
	        pageReference r = objController.reset(); 
	        
	        System.assertEquals('/apex/', nextPage);
        test.stopTest();
    }
}