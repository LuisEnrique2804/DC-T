@isTest (SeeAllData = true)
private class MapaClienteExtension_tst {

    @IsTest static void myUnitTest() {
        test.startTest();
            //PageReference pageRef = Page.LookupPersonaRIP;
            //Test.setCurrentPage(pageRef);
            
            String nextPage = '/apex/';
            Account         Cliente     = DataGenerator_cls.createAccount(true, 'Cliente Test', 'Corporativo', '');
            Contact         Contacto    = DataGenerator_cls.createContacto(true, Cliente.Id, 'CC01', 'DD01');
            MapaCliente__c  Mapa        = DataGenerator_cls.createMapaCliente(true, Cliente.Id, '');    
            
            //Opportunity   Opp         = DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
            
            ApexPages.Standardcontroller stdController;
            stdController = new Apexpages.Standardcontroller(Mapa);
            MapaClienteExtension objController = new MapaClienteExtension(stdController);
            
            
            objController.cambios();
            objController.guardarCambios();
            objController.cambiarModoCampo1();
            objController.cambiarModoCampo2();
            objController.cambiarModoCampo3();
            objController.cambiarModoCampo4();
            
            objController.siguienteClientes();
            objController.anteriorClientes();
            objController.siguienteProveedores();
            objController.anteriorProveedores();
            objController.siguienteInversionTIC();
            objController.anteriorInversionTIC();
            objController.siguienteInversionTradicional();
            objController.anteriorInversionTradicional();
            objController.siguienteContrataciones();
            objController.anteriorContrataciones();
            objController.siguienteCentros();
            objController.anteriorCentros();
            objController.siguienteIncidencias();
            objController.anteriorIncidencias();
            objController.siguienteDeteccion();
            objController.anteriorDeteccion();
            objController.siguienteConectores();
            objController.anteriorConectores();
            objController.siguienteValoracion();
            objController.anteriorValoracion();
            objController.siguienteCompetidores();
            objController.anteriorCompetidores();
            //pageReference r = objController.reset();
            //System.assertEquals('/apex/', nextPage);
        test.stopTest();
    }
}