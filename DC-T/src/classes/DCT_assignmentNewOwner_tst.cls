@isTest
private class DCT_assignmentNewOwner_tst {
	
	@isTest static void test_method_one() {

		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('Eventos');
		
		String  profileName = Label.DCT_AdministratorProfile; //Administrador del sistema
		String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';
		String   username2 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';
		Map<String,Map<String,RecordType>> mapRTsByDevName = TLCL_Utils_cls.getRecordTypes('DeveloperName');
		System.debug(loggingLevel.Error, '*** mapRTsByDevName: ' + mapRTsByDevName);

		Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

        User usr = new User(
            Alias             = username.substringAfterLast('@'),
            Email             = username,
            EmailEncodingKey  = 'UTF-8',
            LastName          = username,
            FirstName         = username,
            LanguageLocaleKey = 'es_MX',
            LocaleSidKey      = 'es_MX',
            ProfileId         = p.Id,
            TimeZoneSidKey    = 'America/Mexico_City',
            UserName          = username
        );
        insert usr;

        User usr2 = new User(
            Alias             = username2.substringAfterLast('@'),
            Email             = username2,
            EmailEncodingKey  = 'UTF-8',
            LastName          = username2,
            FirstName         = username2,
            LanguageLocaleKey = 'es_MX',
            LocaleSidKey      = 'es_MX',
            ProfileId         = p.Id,
            TimeZoneSidKey    = 'America/Mexico_City',
            UserName          = username2
        );
        insert usr2;

		Account newLeadAcc = new Account(
			DTC_LegalEntity__c      = 'Moral',
			RFC__c                  = 'ABC123456EFJ',
			Name                    = 'Pruebas',
			Segmento__c             = 'Corporativo',
			DCT_TypeOfProcedure__c  = 'Lineas Nuevas',
			Sector__c               = 'Financiero',
			Subsector__c            = 'Afores',
			DCT_RegistrationDate__c = System.today(),
			OwnerId                 = usr.id
		);
		Insert newLeadAcc;

		Cliente__c prospect = new Cliente__c(
			OwnerId                 = usr.id,
			Name                    = 'Pruebas',
			RecordType              = mapRTsByDevName.get('Cliente__c').get('Lead'),
			DCTExtensionValidity__c = false,
			Cliente__c              = newLeadAcc.Id
			//DCTRegistrationDate__c = ,
		);
		insert prospect;


		BatchSendDays_cs__c testCS = new BatchSendDays_cs__c( 
			DCT_SendChange__c       = 0,
			DCT_sendNotification__c = 0
		);
		Insert testCS;

		DCTAssignmentDuplicateAccount__c dupAcc = new DCTAssignmentDuplicateAccount__c(
			Assigneduser__c     = false,
			ExistingCustomer__c = newLeadAcc.id,
			UsertobeAssigned__c = usr2.id
		);
		Insert dupAcc;

		Task task = new Task(
			OwnerId    = usr.Id, 
			Cliente__c = 'TELCEL',
			WhatID     = newLeadAcc.Id
		);
		insert task;

		Event event = new Event(
			OwnerId           = usr.Id, 
			Cliente__c        = 'TELCEL',
			DurationInMinutes = 60,
			ActivityDateTime  = system.today(),
			WhatID            = newLeadAcc.Id
		);
		insert event;


		Contact cont = new Contact(
			OwnerId   = usr.Id, 
			FirstName = 'test',
			LastName  = 'test',
			AccountId = newLeadAcc.Id,
			Directorio_Comercial__c = prospect.Id
		);
		insert cont;

		MapaCliente__c mc = new MapaCliente__c(
			PlanCliente__c = newLeadAcc.Id
		);
		insert mc;

		Task task2 = new Task(
			OwnerId    = usr.Id, 
			Cliente__c = 'TELCEL',
			WhatID     = mc.Id
		);
		insert task2;

		Event event2 = new Event(
			OwnerId           = usr.Id, 
			Cliente__c        = 'TELCEL',
			DurationInMinutes = 60,
			ActivityDateTime  = system.today(),
			WhatID            = mc.Id,
			Type              = 'PCT'
		);
		insert event2;

		Opportunity newOpp = new Opportunity(
			Name                    = 'Test',
			StageName               = 'Proyecto',
			Directorio_Comercial__c = prospect.Id,
			CloseDate               = System.today(),
			AccountId               = newLeadAcc.Id,
			RazonSocialGlobal__c    = newLeadAcc.Id,
			MapaCliente__c          = mc.Id
			//Directorio_Comercial__c = prospect.Id
		); 
		insert newOpp;

		ControlAlarmas__c alarm = new ControlAlarmas__c(
			OwnerId        = usr.Id, 
			Cuenta__c      = newLeadAcc.Id,
			MapaCliente__c = mc.Id,
			Embudo__c      = newOpp.id
		);
		insert alarm;

		Task task3 = new Task(
			OwnerId    = usr.Id, 
			Cliente__c = 'TELCEL',
			WhatID     = prospect.Id
		);
		insert task3;

		Event event3 = new Event(
			OwnerId           = usr.Id, 
			Cliente__c        = 'TELCEL',
			DurationInMinutes = 60,
			ActivityDateTime  = system.today(),
			WhatID            = prospect.Id,
			Type              = 'PCT'
		);
		insert event3;

		DCTDedicatedLinks__c dL = new DCTDedicatedLinks__c(
			OwnerId           = usr.Id, 
			Name = 'Test',
			DCTRegistrerDate__c  = system.today(),
			KeyCode__c = '1',
			ClientName__c = prospect.Id

		);
		insert dl;

		DCTProduct__c prod = new DCTProduct__c(
			Name = 'test',
			Product__c = prospect.Id
		);
		insert prod;

		Task task4 = new Task(
			OwnerId    = usr.Id, 
			Cliente__c = 'TELCEL',
			WhatID     = newOpp.Id,
			WhoID      = cont.Id
		);
		insert task4;

		Event event4 = new Event(
			OwnerId           = usr.Id, 
			Cliente__c        = 'TELCEL',
			DurationInMinutes = 60,
			ActivityDateTime  = system.today(),
			WhatID            = newOpp.Id,
			Type              = 'PCT',
			WhoID             = cont.Id
		);
		insert event4;

		SeguimientoOportunidades__c followOpp = new SeguimientoOportunidades__c(
			//CreatedById = usr.Id, 
			Name        = 'Test',
			Embudo__c   = newOpp.Id,
			PlanCliente__c = newLeadAcc.id
		);
		Insert followOpp;

		Task task5 = new Task(
			OwnerId    = usr.Id, 
			Cliente__c = 'TELCEL',
			WhatID     = followOpp.Id,
			WhoID      = cont.Id
		);
		insert task5;

		Event event5 = new Event(
			OwnerId           = usr.Id, 
			Cliente__c        = 'TELCEL',
			DurationInMinutes = 60,
			ActivityDateTime  = system.today(),
			WhatID            = followOpp.Id,
			Type              = 'PCT',
			WhoID             = cont.Id
		);
		insert event5;

		Competencia__c compe = new Competencia__c(
			PlanCliente__c  = newLeadAcc.id
		);
		insert compe;

		Task task6 = new Task(
			OwnerId    = usr.Id, 
			Cliente__c = 'TELCEL',
			WhatID     = compe.Id,
			WhoID      = cont.Id
		);
		insert task6;

		Event event6 = new Event(
			OwnerId           = usr.Id, 
			Cliente__c        = 'TELCEL',
			DurationInMinutes = 60,
			ActivityDateTime  = system.today(),
			WhatID            = compe.Id,
			Type              = 'PCT',
			WhoID             = cont.Id
		);
		insert event6;

		Opportunity newOpp2 = new Opportunity(
			Name                    = 'Test',
			StageName               = 'Proyecto',
			Directorio_Comercial__c = prospect.Id,
			CloseDate               = System.today(),
			AccountId               = newLeadAcc.Id,
			RazonSocialGlobal__c    = newLeadAcc.Id,
			MapaCliente__c          = mc.Id,
			OportunidadesCliente__c = newOpp.Id,
			Competidor__c           = compe.id
			//Directorio_Comercial__c = prospect.Id
		); 
		insert newOpp2;

		AnalisisRelaciones__c anaRel = new AnalisisRelaciones__c(
			MapaCliente__c = mc.Id,
			PlanCliente__c = newLeadAcc.id
		);
		insert anaRel;

		Task task7 = new Task(
			OwnerId    = usr.Id, 
			Cliente__c = 'TELCEL',
			WhatID     = anaRel.Id,
			WhoID      = cont.Id
		);
		insert task7;

		Event event7 = new Event(
			OwnerId           = usr.Id, 
			Cliente__c        = 'TELCEL',
			DurationInMinutes = 60,
			ActivityDateTime  = system.today(),
			WhatID            = anaRel.Id,
			Type              = 'PCT',
			WhoID             = cont.Id
		);
		insert event7;

		ConocimientoMercado__c conocimMerca = new ConocimientoMercado__c(
			PlanCliente__c = newLeadAcc.id
		);
		insert conocimMerca;

		Task task8 = new Task(
			OwnerId    = usr.Id, 
			Cliente__c = 'TELCEL',
			WhatID     = conocimMerca.Id,
			WhoID      = cont.Id
		);
		insert task8;

		Event event8 = new Event(
			OwnerId           = usr.Id, 
			Cliente__c        = 'TELCEL',
			DurationInMinutes = 60,
			ActivityDateTime  = system.today(),
			WhatID            = conocimMerca.Id,
			Type              = 'PCT',
			WhoID             = cont.Id
		);
		insert event8;

		Test.startTest();
			DCT_assignmentNewOwner_sch scheduleInstance = new DCT_assignmentNewOwner_sch();
			String strChronExpresion = '0 0 0 15 * ? ';
			System.schedule('AssignmentNewOwnerTest',
				strChronExpresion,
				scheduleInstance);
		Test.stopTest();
	}	

	@isTest static void test_method_two() {

		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
		
		String  profileName = Label.DCT_AdministratorProfile; //Administrador del sistema
		String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';
		String   username2 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';
		Map<String,Map<String,RecordType>> mapRTsByDevName = TLCL_Utils_cls.getRecordTypes('DeveloperName');
		System.debug(loggingLevel.Error, '*** mapRTsByDevName: ' + mapRTsByDevName);

		Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

        User usr = new User(
            Alias             = username.substringAfterLast('@'),
            Email             = username,
            EmailEncodingKey  = 'UTF-8',
            LastName          = username,
            FirstName         = username,
            LanguageLocaleKey = 'es_MX',
            LocaleSidKey      = 'es_MX',
            ProfileId         = p.Id,
            TimeZoneSidKey    = 'America/Mexico_City',
            UserName          = username
        );
        insert usr;

        User usr2 = new User(
            Alias             = username2.substringAfterLast('@'),
            Email             = username2,
            EmailEncodingKey  = 'UTF-8',
            LastName          = username2,
            FirstName         = username2,
            LanguageLocaleKey = 'es_MX',
            LocaleSidKey      = 'es_MX',
            ProfileId         = p.Id,
            TimeZoneSidKey    = 'America/Mexico_City',
            UserName          = username2
        );
        insert usr2;

		Account newLeadAcc = new Account(
			DTC_LegalEntity__c      = 'Moral',
			RFC__c                  = 'ABC123456EFJ',
			Name                    = 'Pruebas',
			Segmento__c             = 'Corporativo',
			DCT_TypeOfProcedure__c  = 'Lineas Nuevas',
			Sector__c               = 'Financiero',
			Subsector__c            = 'Afores',
			DCT_RegistrationDate__c = System.today(),
			OwnerId                 = usr.id
		);
		Insert newLeadAcc;

		Cliente__c prospect = new Cliente__c(
			OwnerId                 = usr.id,
			Name                    = 'Pruebas',
			RecordType              = mapRTsByDevName.get('Cliente__c').get('Lead'),
			DCTExtensionValidity__c = false,
			Cliente__c              = newLeadAcc.Id
			//DCTRegistrationDate__c = ,
		);
		insert prospect;

		Opportunity newOpp = new Opportunity(
			Name                    = 'Test',
			StageName               = 'Proyecto',
			Directorio_Comercial__c = prospect.Id,
			CloseDate               = System.today(),
			AccountId               = newLeadAcc.Id
		); 
		insert newOpp;

		BatchSendDays_cs__c testCS = new BatchSendDays_cs__c( 
			DCT_SendChange__c       = 0,
			DCT_sendNotification__c = 0
		);
		Insert testCS;

		DCTListUsersAssignment__c userToAssign = new DCTListUsersAssignment__c( User__c = usr2.id );
		insert userToAssign;

		Test.startTest();
			DCT_assignmentNewOwner_sch scheduleInstance = new DCT_assignmentNewOwner_sch();
			String strChronExpresion = '0 0 0 15 * ? ';
			System.schedule('AssignmentNewOwnerTest',
				strChronExpresion,
				scheduleInstance);
		Test.stopTest();
	}	
}