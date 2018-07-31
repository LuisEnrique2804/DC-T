@isTest (SeeAllData = true)
private class Presupuesto_ArbolDeDecision_ctr_tst {

    @IsTest static void myUnitTest() {
    	test.startTest();
	        PageReference pageRef = Page.Presupuesto_ArbolDeDecision_pag;
	        pageReference Resp;
	        String sResp;
	        Test.setCurrentPage(pageRef);
	        
	        String nextPage = '/apex/Presupuesto_ArbolDeDecision_pag';
	        Account 								Cliente					= DataGenerator_cls.createAccount(true, 'Cliente Test', 'Corporativo', '');
			Contact 								Contacto 				= DataGenerator_cls.createContacto(true, Cliente.Id, 'CC01', 'DD01');
	        Opportunity 							Opp 					= DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
	        
	        Presupuesto_ArbolDeDecision_ctr objController = new Presupuesto_ArbolDeDecision_ctr();
			Resp = objController.ejecutarConsulta();       
		    objController.lstMeses = objController.getFiltroMes();
		    objController.sFiltroMes = DateTime.Now().Month() +'-'+DateTime.Now().Year(); 
		
	    	List<User> lstUsers = objController.getUsers();
	    	objController.sFiltroMes = '1-2016';
	    	objController.ejecutarConsulta();
	    	objController.sFiltroMes = '2-2016';
	    	objController.ejecutarConsulta();
	    	objController.sFiltroMes = '3-2016';
	    	objController.ejecutarConsulta();
	    	objController.sFiltroMes = '4-2016';
	    	objController.ejecutarConsulta();
	    	for (Integer i = 1; i <13; i++){
	    		objController.valMes(i);
	    	}
			
	        System.assertEquals('/apex/Presupuesto_ArbolDeDecision_pag', nextPage);
		test.stopTest();
    }
}