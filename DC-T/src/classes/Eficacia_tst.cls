@isTest
private class Eficacia_tst {

    @isTest static void myUnitTest() {
        test.startTest();
	        Eficacia objEficacia = new Eficacia();
	        
	        objEficacia.objRango.fecha_inicio__c = Date.today().addMonths(-12);
	        objEficacia.objRango.fecha_fin__c = Date.today();
	        objEficacia.sDirector = UserInfo.getUserId();
	       	objEficacia.ObtenerSubDirectores();
	       	objEficacia.sSubDirector  = UserInfo.getUserId();
	       	objEficacia.ObtenerGerentes();
	       	objEficacia.sGerente = UserInfo.getUserId();
	       	objEficacia.ObtenerJECS();
	        objEficacia.getReport();
		test.stopTest();
    }
}