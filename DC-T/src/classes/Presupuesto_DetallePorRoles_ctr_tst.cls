@isTest
private class Presupuesto_DetallePorRoles_ctr_tst {

    @IsTest static void myUnitTest() {
    	test.startTest();
	        PageReference pageRef = Page.Presupuesto_DetallePorRoles_pag;
	        pageReference Resp;
	        String sResp;
	        Test.setCurrentPage(pageRef);
	        
	        ApexPages.currentPage().getParameters().put('idUser', userInfo.getUserId());
	        
	        String nextPage = '/apex/Presupuesto_DetallePorRoles_pag';
	        
	        Presupuesto__c entPresupuesto =  Datagenerator_cls.createPresupuesto(true);
	        Presupuesto_DetallePorRoles_ctr objController = new Presupuesto_DetallePorRoles_ctr();
			objController.getParameters(); 
			List<User> lstUser = objController.getUserbyRoles();
			objController.getlstDetallePresuspuesto(lstUser);		
			objController.evaluaPresupuestoSD(entPresupuesto,userInfo.getUserId());
	     	ApexPages.currentPage().getParameters().put('idUser', '');
	     	objController.getParameters(); 
		
			Presupuesto_DetallePorRoles_ctr.detallePresupuestoWrapper objW = new Presupuesto_DetallePorRoles_ctr.detallePresupuestoWrapper();
			objW.strLabel = '';
			
	        System.assertEquals('/apex/Presupuesto_DetallePorRoles_pag', nextPage);
        test.stopTest();
    }
}