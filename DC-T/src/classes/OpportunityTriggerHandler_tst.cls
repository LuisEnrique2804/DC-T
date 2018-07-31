@isTest
private class OpportunityTriggerHandler_tst {

    @isTest static void myUnitTest() {
        test.startTest();
            Account                                 Cliente                 = DataGenerator_cls.createAccount(true, 'Cliente Test', 'Corporativo', '');
            Contact                                 Contacto                = DataGenerator_cls.createContacto(true, Cliente.Id, 'CC01', 'DD01');
            Opportunity                             OppRef                  = DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
            DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');
            Opportunity                             Opp                     = DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
    		Opp.LineaProducto__c = 'Línea';
            opp.TipoActivacion__c = 'Renovaciones';
            opp.PersonaRIP__c = Contacto.Id;
            opp.FechaRIP__c = Date.today();
            opp.P__c = Contacto.Id;
            opp.FechacontactoP__c = Date.today();
            opp.Fechapresentacionpropuesta__c = Date.today();
            opp.Fechafirma__c = Date.today();
    		update Opp; 
    		
			opp.DAT__c = DataGenerator_cls.createDAT(true).Id;
    		opp.PresupuestoR9__c = 100;
         	opp.PresupuestoR18__c = 100;
         	opp.PresupuestoDAT__c = 100;
			opp.Rentabilidad__c = 100;
			update opp;
			opp.FechacontactoP__c = date.today().addDays(1);
			opp.FechaRIP__c = date.today().addDays(1);
			opp.Fechafirma__c = date.today().addDays(1);
			opp.OportunidadlenguajeCliente__c = 'Negocios';
			opp.Proyectolisto__c = 'Fase terminal';
			opp.ValidaAprovIC__c = true;
			opp.PendienteAprobacionIC__c = false;
			opp.PendienteAprobacionRentabilidad__c = false;
			opp.LineaProducto__c = 'Línea';
        	opp.TipoActivacion__c = 'Nueva';
         	opp.TipoPlataforma__c = 'Voz';
         	opp.CompaniaOrigen__c = 'IUSACELL0';
         	opp.Importante__c = 'No'; 
         	opp.Riesgo__c = 'No';
         	update opp;
        	opp.StageName = 'Perdida';
        	opp.LineaProducto__c = 'Línea'; 
            opp.TipoActivacion__c = 'Nueva';
            opp.TipoRenta__c = 'Renta Alta';
        	update opp;
        test.stopTest();
    }
}