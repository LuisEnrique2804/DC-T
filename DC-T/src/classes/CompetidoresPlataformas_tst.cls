@isTest
private class CompetidoresPlataformas_tst {

    @isTest static void myUnitTest() {
         test.startTest();
	         Account objAccount = DataGenerator_cls.createAccount( true, 'Test Acount', 'Corporativo', '');
	         CatalogoServiciosTradicionales__c objCST = DataGenerator_cls.createCatalogoServicioTradicional(true,  true, 'Voz01');
	         CatalgoCompetidoresPlataformas__c objCCP = DataGenerator_cls.createCatalogoCopetidoresPlataformas(true, 'AVX', objCST);
         test.stopTest();
    }
}