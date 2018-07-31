@IsTest
private class TelcelTest {
	
	static void GenerarCatalogoTIC(){
		DataGenerator_cls.createPlataformaTic(true, 'Servicios en la nubeProductividad', 'Servicios en la nube', 'Productividad');
		DataGenerator_cls.createPlataformaTic(true, 'Otros', 'Otros', '');
		DataGenerator_cls.createPlataformaTic(true, 'ComunicaciónComunicación', 'Comunicación', 'Comunicación');
		DataGenerator_cls.createPlataformaTic(true, 'BigData', 'BigData', '');
		DataGenerator_cls.createPlataformaTic(true, 'MovilidadProductividad', 'Movilidad', 'Productividad');
		DataGenerator_cls.createPlataformaTic(true, 'Aplicaciones EmpresarialesProductividad', 'Aplicaciones Empresariales', 'Productividad');
		DataGenerator_cls.createPlataformaTic(true, 'MovilidadInternet', 'Movilidad', 'Internet');
		DataGenerator_cls.createPlataformaTic(true, 'MovilidadComunicación', 'Movilidad', 'Comunicación');
		DataGenerator_cls.createPlataformaTic(true, 'TelemetríaM2M', 'Telemetría', 'M2M');
		DataGenerator_cls.createPlataformaTic(true, 'SeguridadSeguridad', 'Seguridad', 'Seguridad');
		DataGenerator_cls.createPlataformaTic(true, 'ComunicaciónInternet', 'Comunicación', 'Internet');
		DataGenerator_cls.createPlataformaTic(true, 'TelemetríaInternet', 'Telemetría', 'Internet');
		DataGenerator_cls.createPlataformaTic(true, 'Internet de las CosasM2M', 'Internet de las Cosas', 'M2M');
		DataGenerator_cls.createPlataformaTic(true, 'LocalizaciónLocalización', 'Localización', 'Localización');
		try{
			CatalogoPlataformaTIC__c obj = DataGenerator_cls.createPlataformaTic(true, 'Test', 'test', 'test');	
			obj.Activo__c = false;
			update obj;	
			//obj.PlataformaTIC__c = 'Seguridad';
			obj.Activo__c = true;
			update obj;
		}catch (exception ex){}
	}
	
	static void GenerarCatalogoServiciosTradicionales(){
		CatalogoServiciosTradicionales__c obj;
		try {
			obj = DataGenerator_cls.createCatalogoServicioTradicional(true, false, 'Voz01');
			obj.Activo__c = true;
			update obj;
		}catch(exception ex) { }
		try{
			obj = DataGenerator_cls.createCatalogoServicioTradicional(true, true, 'Datos01');
		}catch (exception ex) { }
	}
	
	@IsTest static void createEvent()
    {
    	test.startTest();
    	
    		String					rtSO					= '';
			for(RecordType rt : [SELECT DeveloperName,Name,SobjectType FROM RecordType])
			{
				if (rt.SobjectType == 'SeguimientoOportunidades__c' && rt.developerName == 'Corporativo'){
					rtSO = rt.id;
				}
				
			}
    	
	        Account objAccount =
	        	DataGenerator_cls.createAccount( true, 'Test Acount', 'Corporativo', '');
	        
	        Contact objContact =
	        	DataGenerator_cls.createContact( true, objAccount, 'LastName', 'FirstName' );
	
	        Opportunity objOpportunity =
	        	DataGenerator_cls.createOpportunity( true, 'Opportunity Test',
	        	objAccount, objContact, 'Oportunidad' );
	        
	        SeguimientoOportunidades__c objSO =
	        	DataGenerator_cls.createSeguimientoOportunidad( false, objOpportunity,rtSO);
	        	
	        objSO.Fechaproximaaccion__c = Date.today().addDays( 3 );
	        objSO.Proximaaccion__c = 'Test 1';
	        
	        insert objSO;
	        
	        SeguimientoOportunidades__c objSO2 =
	        	DataGenerator_cls.createSeguimientoOportunidad( true, objOpportunity,rtSO);
	        	
	        objSO2.Fechaproximaaccion__c = Date.today().addDays( 3 );
	        objSO2.Proximaaccion__c = 'Test 1';
	        
	        update objSO2;
	        
	        list<Event> lstEvent =
	        [
	        	select id
	        	from Event 
	        ];
	        
	        //system.assertEquals( 2, lstEvent.size() );
        test.stopTest();
    }

	@isTest static void AccountCreacionAlarmas() {
		
		Test.startTest();
			DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');
			String 					rtCliente 				= '';
			String 					rtMapa					= '';
			String					rtSO					= '';
			for(RecordType rt : [SELECT DeveloperName,Name,SobjectType FROM RecordType])
			{
				if (rt.SobjectType == 'Account' && rt.developerName == 'PlanClienteTelcelCorporativo'){
					rtCliente = rt.id;
				}
				if (rt.SobjectType == 'MapaCliente__c' && rt.developerName == 'Corporativo'){
					rtMapa = rt.id;
				}
				if (rt.SobjectType == 'SeguimientoOportunidades__c' && rt.developerName == 'Corporativo'){
					rtSO = rt.id;
				}
				
			}
			
			
       		set<Id>									setCliente				= new set<Id>();
       		set<Id>									setMapa  				= new set<Id>();
       		Account 								Cliente					= DataGenerator_cls.createAccount(true, 'Cliente Test', 'Corporativo', rtCliente);
			Contact 								Contacto 				= DataGenerator_cls.createContacto(true, Cliente.Id, 'CC01', 'DD01');
			Contact 								Contacto02 				= DataGenerator_cls.createContacto(true, Cliente.Id, 'CC01', 'DD01');
			Interlocutor__c 						Interlocutor01 			= DataGenerator_cls.createInterlocutor(true, 'Crecimiento', Contacto.Id, Cliente.Id);
			ConocimientoMercado__c					ConocimientoMercado		= DataGenerator_cls.createConocimientoMercado(true, 'NO', 34, 'SI', 'SI', 'Comunicaciones', 'SI', Cliente.Id);
   			Competencia__c							Competencia 			= DataGenerator_cls.createCompetencia(true, 'Activo', 'Mi Competencia', Cliente.Id);
			MapaCliente__c							Mapa 					= DataGenerator_cls.createMapaCliente(true, Cliente.Id, rtMapa);																  
			InversionServicioTICFacturacion__c		Inversion				= DataGenerator_cls.createInversionServiciosTICFacturacion(true, Competencia.Id, Mapa.Id);

			InversionServicioTICFacturacionFuture.Estatus = 0;
			Inversion.InversionCliente__c = 1000.00;
			update Inversion; 

	 		Rentabilidad__c 						Rentabilidad 			= DataGenerator_cls.createRentabilidad(true, Label.Organizacion);
	 		InversionServicioTICFacturacionFuture.Estatus = 1;
	 		
	 		setCliente.add(Cliente.Id);
	 		setMapa.add(Mapa.Id);
	 		
			Interlocutor01.Interlocutor__c = Contacto02.Id;
			update Interlocutor01;
	 		
	 		Cliente.GastoMovilidad__c = 1000;
	 		Cliente.GastoTIC__c = 100;
			//Cliente.Segmento__c = '';
			Cliente.DeTelcelCliente__c = 'Test';
			Cliente.DelClienteTelcel__c = 'Test';
			Cliente.InterlocutorAlineamiento__c = Contacto.Id;
			update Cliente; 
			
			GenerarCatalogoTIC();
			GenerarCatalogoServiciosTradicionales();													
	        
	        Opportunity 							Opp 					= DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
			SeguimientoOportunidades__c objSO = DataGenerator_cls.createSeguimientoOportunidad( true, Opp, rtSO);
        	
        	list<ControlAlarmas__c> lstCA = new list<ControlAlarmas__c>();
            ControlAlarmas__c objControl = new ControlAlarmas__c();
            objControl.SeguimientoOportunidades__c = objSO.Id;
            objControl.OwnerId = userInfo.getUserId();
            objControl.Estatus__c = 'Activa';
            objControl.Fase__c = 'Oportunidad';
            objControl.Motivo__c = 'Próxima Acción';
            objControl.Objeto__c = 'Seguimiento de Oportunidades';
            objControl.Posicion__c = '0'; 
            objControl.Descripcion__c = 'Test';
            lstCA.add(objControl);
            
            objControl = new ControlAlarmas__c();
            objControl.SeguimientoOportunidades__c = objSO.Id;
            objControl.OwnerId = userInfo.getUserId();
            objControl.Estatus__c = 'Activa';
            objControl.Fase__c = 'Oportunidad';
            objControl.Motivo__c = 'Rentabilidad';
            objControl.Objeto__c = 'Seguimiento de Oportunidades';
            objControl.Posicion__c = '0'; 
            objControl.Descripcion__c = 'Test';
            lstCA.add(objControl);
            
            objControl = new ControlAlarmas__c();
            objControl.SeguimientoOportunidades__c = objSO.Id;
            objControl.OwnerId = userInfo.getUserId();
            objControl.Estatus__c = 'Activa';
            objControl.Fase__c = 'Oportunidad';
            objControl.Motivo__c = 'Fase';
            objControl.Objeto__c = 'Seguimiento de Oportunidades';
            objControl.Posicion__c = '0'; 
            objControl.Descripcion__c = 'Test';
            lstCA.add(objControl);
            
            objControl = new ControlAlarmas__c();
            objControl.SeguimientoOportunidades__c = objSO.Id;
            objControl.OwnerId = userInfo.getUserId();
            objControl.Estatus__c = 'Activa';
            objControl.Fase__c = 'Oportunidad';
            objControl.Motivo__c = 'Oportunidad';
            objControl.Objeto__c = 'Seguimiento de Oportunidades';
            objControl.Posicion__c = '0'; 
            objControl.Descripcion__c = 'Test';
            lstCA.add(objControl);
            
            insert lstCA;
            
            objSO.Proximaaccion__c = 'Test';
            objSO.Fechaproximaaccion__c = Date.today().addDays( 3 );
            update objSO;
        	
	        
			SeguimientoOportunidades__c objSO2 = DataGenerator_cls.createSeguimientoOportunidad( true, Opp, rtSO);
			objSO2.Fechaproximaaccion__c = Date.today().addDays( 3 );
	        objSO2.Proximaaccion__c = 'Test 1';
	        update objSO2;
	        list<SeguimientoOportunidades__c> lstSO = new list<SeguimientoOportunidades__c>();
	        lstSO.add(objSO);
	        SeguimientoOportunidad_cls.blnCreateAlarmas = true;
	        SeguimientoOportunidad_cls.createControlAlarma(lstSO);
	        
	        
	        DirectrizTelcel__c		DirectrizTelcel			= DataGenerator_cls.createDirectriz(true, Cliente.Id, objSO.Id);
	 		Directriz_Telcel__c		Directriz_Telcel		= DataGenerator_cls.createDirectriz2(true, Cliente.Id);
	        
	        Event 	Evento		= DataGenerator_cls.createEventRIP(true, Opp, Cliente, 'Embudo');  
			Event 	Evento1		= DataGenerator_cls.createEventRIP(true, Opp, Cliente, 'Embudo');		
			Event 	Evento2		= DataGenerator_cls.createEventRIP(true, Opp, Cliente, 'PCTPruebaAvxAdm');		
			Event 	Evento3		= DataGenerator_cls.createEventRIP(true, Opp, Cliente, 'SeguimientoOportunidades__c');	

        	Evento.Subject = 'Cita Persona RIP';
			DateTime Fecha = DateTime.now().addDays(10);
			Evento.StartDateTime = Fecha;
			Evento.EndDateTime = Fecha.addMinutes(30);
			Evento.DurationInMinutes = 30;
			update Evento;	
        
        	Evento1.Subject = 'Cita P';
			DateTime Fecha1 = DateTime.now().addDays(10);
			Evento1.StartDateTime = Fecha1;
			Evento1.EndDateTime = Fecha1.addMinutes(30);
			Evento1.DurationInMinutes = 30;
			update Evento1;
			
			Evento2.Subject = 'Revisión de contrato';
			DateTime Fecha2 = DateTime.now().addDays(10);
			Evento2.StartDateTime = Fecha2; 
			Evento2.EndDateTime = Fecha2.addMinutes(30);
			Evento2.DurationInMinutes = 30;
			update Evento2;
			
			Evento3.Subject = 'Firma';
			DateTime Fecha3 = DateTime.now().addDays(10);
			Evento3.StartDateTime = Fecha3; 
			Evento3.EndDateTime = Fecha3.addMinutes(30);
			Evento3.DurationInMinutes = 30;
			update Evento3;
	        
		Test.stopTest();
		
	}
	
}