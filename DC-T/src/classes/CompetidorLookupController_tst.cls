@isTest (SeeAllData = true)
private class CompetidorLookupController_tst {

    @IsTest static void myUnitTest() {
    	test.startTest();  
	    	Account 	Cliente		= DataGenerator_cls.createAccount(true, 'Cliente Test', 'Corporativo', '');
			Contact 	Contacto 	= DataGenerator_cls.createContacto(true, Cliente.Id, 'CC01', 'DD01');      	  
	    	Opportunity Opp 		= DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
	    	
	    	//ApexPages.Standardcontroller stdController;
	        //stdController = new Apexpages.Standardcontroller(Opp);
	        ApexPages.currentPage().getParameters().put('lksrch', 'CC01');
	        ApexPages.currentPage().getParameters().put('frm', '');
	        ApexPages.currentPage().getParameters().put('txt', '');
	    	
	    	//PageReference pageRef = Page.CompetidorLookup;
	        //Test.setCurrentPage(pageRef);
	        String nextPage = '/apex/CompetidorLookup';
	        
	        
	        CompetidorLookupController objController = new CompetidorLookupController();
	        objController.account = Cliente;
	        objController.contact = Contacto;
	        objController.opportunity = Opp;
	        
	        String sForm = objController.getFormTag();
	        String sTxt = objController.getTextBox();
	   
	   		objController.search();
	   		objController.saveAccount();
	   		objController.saveContact();
	   		
	        System.assertEquals('/apex/CompetidorLookup', nextPage);
    	test.stopTest();
    }
    
}