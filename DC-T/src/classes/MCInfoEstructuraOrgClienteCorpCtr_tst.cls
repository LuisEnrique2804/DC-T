@isTest (SeeAllData = true)
private class MCInfoEstructuraOrgClienteCorpCtr_tst {
	
	 @IsTest static void myUnitTest() {
	 	test.startTest();
		 	PageReference pageRef = Page.InformacionAnalisisEstrategico;
	        Test.setCurrentPage(pageRef);
	        
	        String nextPage = '/apex/';
	        Account 		Cliente		= DataGenerator_cls.createAccount(true, 'Cliente Test', 'Corporativo', '');
			Contact 		Contacto 	= DataGenerator_cls.createContacto(true, Cliente.Id, 'CC01', 'DD01');
	        MapaCliente__c	Mapa 		= DataGenerator_cls.createMapaCliente(true, Cliente.Id, '');	
	        
	        //Opportunity 	Opp 		= DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
	        
	        ApexPages.Standardcontroller stdController;
	        stdController = new Apexpages.Standardcontroller(Mapa);
	        MCInfoEstructuraOrgClienteCorpCtr objController = new MCInfoEstructuraOrgClienteCorpCtr(stdController);	
	        
	        
	        objController.siguienteContactos();
	        objController.anteriorContactos();
	        objController.siguienteAnalisis();
	        objController.anteriorAnalisis();
	        MCInfoEstructuraOrgClienteCorpCtr.Linea objLinea = new MCInfoEstructuraOrgClienteCorpCtr.Linea();
	        objLinea.nivel = 'Staff';
	        
	        MCInfoEstructuraOrgClienteCorpCtr.nodeArbolContactos objNodo = new MCInfoEstructuraOrgClienteCorpCtr.nodeArbolContactos();
	        objNodo.nivel = 'Staff';
	        objNodo.conta = Contacto;
	        objController.getuserdata();
        test.stopTest();
        
	 }
	 
}