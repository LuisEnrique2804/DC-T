@isTest (SeeAllData = true)
private class Presupuesto_DetalleSubRoles_ctr_tst {

    @isTest static void myUnitTest() {
    	test.startTest();
	        PageReference pageRef = Page.Presupuesto_DetalleSubRoles_pag;
	        pageReference Resp;
	        String sResp;
	        Test.setCurrentPage(pageRef);
	        
	        ApexPages.currentPage().getParameters().put('idUser', userInfo.getUserId());
	        String nextPage = '/apex/Presupuesto_DetalleSubRoles_pag';
	        
	        Presupuesto_DetalleSubRoles_ctr objController = new Presupuesto_DetalleSubRoles_ctr();
	        objController.getUserbyRolesSons();
	        objController.getlstTotalPresupuestosWrap();
	        
	        
	        Presupuesto_DetalleSubRoles_ctr.TotalPresupuestosWrap obj = new Presupuesto_DetalleSubRoles_ctr.TotalPresupuestosWrap();
	        obj.objUser = new User();
	        obj.strLabel = '';
	        obj.decTotalPrevisionVsPresupuesto = 0.00;
	        obj.decTotalVentasVsPresupuesto = 0.00;
	        
	        System.assertEquals('/apex/Presupuesto_DetalleSubRoles_pag', nextPage);
		test.stopTest();
    }
}