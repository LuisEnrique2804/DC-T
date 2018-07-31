@isTest 
private class Account_CreacionAlarmas_tst {

    @isTest static void myUnitTest() {
        test.startTest();
        	
        	String					rtSO					= '';
			for(RecordType rt : [SELECT DeveloperName,Name,SobjectType FROM RecordType])
			{
				if (rt.SobjectType == 'SeguimientoOportunidades__c' && rt.developerName == 'Corporativo'){
					rtSO = rt.id;
				}
				
			}
        	
        	
        	
        	
        	map<String, String> mRT = new map<String,String>();
			
			for(RecordType rt : [SELECT DeveloperName,Name,SobjectType FROM RecordType])
			{
				if (rt.SobjectType == 'Account' && rt.developerName == 'PlanClienteTelcelCorporativo'){
					mRT.put(rt.developerName,rt.id);
				}
				if (rt.SobjectType == 'Account' && rt.developerName == 'PlanClienteTelcelEmpresarial'){
					mRT.put(rt.developerName,rt.id);
				}
				if (rt.SobjectType == 'Account' && rt.developerName == 'PlanClienteTelcelPyME'){
					mRT.put(rt.developerName,rt.id);
				}
			}
			
        	List<Account> lstAccount = new List<Account>();
        	map<Id,Account> mapIdXAccountOld = new map<Id,Account>();
        	DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');
        
            Account Cliente = DataGenerator_cls.createAccount(true, 'Cliente Test', 'Corporativo', mRT.get('PlanClienteTelcelCorporativo'));
            Contact Contacto = DataGenerator_cls.createContacto(true, Cliente.Id, 'CC01', 'DD01');
            Opportunity Opp = DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
            SeguimientoOportunidades__c objSO = DataGenerator_cls.createSeguimientoOportunidad( true, Opp, rtSO);
            
            DataGenerator_cls.createDirectriz(true, Cliente.Id, objSO.Id);
            DataGenerator_cls.createConocimientoMercado(true, 'NO', 34, 'SI', 'SI', 'Comunicaciones', 'SI', Cliente.Id);
            DataGenerator_cls.createCompetencia(true, 'Activo', 'Mi Competencia', Cliente.Id);
            DataGenerator_cls.createInterlocutor(true, 'Crecimiento', Contacto.Id, Cliente.Id);
            lstAccount.add(Cliente);
            mapIdXAccountOld.put(Cliente.Id, Cliente);
            
            Cliente = DataGenerator_cls.createAccount(true, 'Cliente Test01', 'Empresarial', mRT.get('PlanClienteTelcelEmpresarial'));
            Contacto = DataGenerator_cls.createContacto(true, Cliente.Id, 'CC02', 'DD01');
            Opp = DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
            objSO = DataGenerator_cls.createSeguimientoOportunidad( false, Opp, rtSO);
            DataGenerator_cls.createConocimientoMercado(true, 'NO', 34, 'SI', 'SI', 'Comunicaciones', 'SI', Cliente.Id);
            DataGenerator_cls.createCompetencia(true, 'Activo', 'Mi Competencia', Cliente.Id);
            DataGenerator_cls.createInterlocutor(true, 'Crecimiento', Contacto.Id, Cliente.Id);
            lstAccount.add(Cliente);
            mapIdXAccountOld.put(Cliente.Id, Cliente);
            
            Cliente = DataGenerator_cls.createAccount(true, 'Cliente Test03', 'PyME', mRT.get('PlanClienteTelcelPyME'));
            Contacto = DataGenerator_cls.createContacto(true, Cliente.Id, 'CC03', 'DD01');
            Opp = DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
            objSO = DataGenerator_cls.createSeguimientoOportunidad( false, Opp, rtSO);
            lstAccount.add(Cliente);
            mapIdXAccountOld.put(Cliente.Id, Cliente);
        	Account_CreacionAlarmas_cls.crearAlarmas(lstAccount, mapIdXAccountOld);
        	
        test.stopTest();
    }
}