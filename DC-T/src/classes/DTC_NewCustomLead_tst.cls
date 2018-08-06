@isTest
private class DTC_NewCustomLead_tst {

	@TestSetup static void setup(){
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
		Map<String,Map<String,RecordType>> mapRTsByDevName = TLCL_Utils_cls.getRecordTypes('DeveloperName');
		System.debug(loggingLevel.Error, '*** mapRTsByDevName: ' + mapRTsByDevName);

		List<DCTRegion__c> lstregion = new List<DCTRegion__c>();
		DCTRegion__c reg = new DCTRegion__c(
			RFC__c = 'ABC123456EFG',
			Name = 'Prueba',
			DCTBillingCycle__c = '20',
			EstatusCobranza__c = 'HB'
		);
		insert reg;
		lstregion.add(reg);
		
		DCTRegion__c reg2 = new DCTRegion__c(
			RFC__c = 'ABC123456EFH',
			Name = 'Prueba1',
			DCTBillingCycle__c = '97',
			EstatusCobranza__c = 'HB'
		);
		insert reg2;
		lstregion.add(reg2);
		
		DCTRegion__c reg3 = new DCTRegion__c(
			RFC__c = 'ABC123456EFI',
			Name = 'Prueba2',
			DCTBillingCycle__c = '01',
			EstatusCobranza__c = 'FP'
		);
		insert reg3;
		lstregion.add(reg3);

		DCT_CycleApproveProcess_cs__c clok = new DCT_CycleApproveProcess_cs__c(Name = '97');
		insert clok;

		DCT_CycleReject_cs__c clNotok = new DCT_CycleReject_cs__c(Name = '20');
		insert clNotok;

		DCT_PayStatus_cs__c clPayStatus = new DCT_PayStatus_cs__c(Name = 'FP');
		insert clPayStatus;
		//insert lstregion;

		String  profileName = Label.DCT_AdministratorProfile; //Administrador del sistema
		String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';
		String   username2 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';          

		Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

        User usr = new User(
            Alias             = username.substringAfterLast('@'),
            Email             = username,
            EmailEncodingKey  = 'UTF-8',
            LastName          = username,
            LanguageLocaleKey = 'es_MX',
            LocaleSidKey      = 'es_MX',
            ProfileId         = p.Id,
            TimeZoneSidKey    = 'America/Mexico_City',
            UserName          = username

        );
        insert usr;

        User usr1 = new User(
            Alias             = username2.substringAfterLast('@'),
            Email             = username2,
            EmailEncodingKey  = 'UTF-8',
            LastName          = username2,
            LanguageLocaleKey = 'es_MX',
            LocaleSidKey      = 'es_MX',
            ProfileId         = p.Id,
            TimeZoneSidKey    = 'America/Mexico_City',
            UserName          = username2,
            ManagerId         = usr.Id

        );
        insert usr1;


		Account acc = new Account(
			Name = 'Prueba2',
			RFC__c = 'ABC123456EFL',
			OwnerID = usr1.Id,
			TipoCliente__c = 'Prospecto'
		);
		insert acc;

		Account acc2 = new Account(
			Name = 'Pruebas Ejemplo TestS',
			RFC__c = 'ABCD123456EFM',
			OwnerID = usr1.Id,
			TipoCliente__c = 'Prospecto'
		);
		insert acc2;

		Cliente__c newClient = new Cliente__c(
			Name = 'Pruebas Ejemplo TestS',
			RFC1__c = 'ABCD123456EFM',
			//RecordType.Name
			OwnerId = usr1.Id,
			DCTStatus__c = 'Activo'
		);
		insert newClient;

		DCTRegion__c regPros = new DCTRegion__c(
			RFC__c = 'ABCD123456EF3',
			Name = 'Pruebas Ejemplo TestS',
			DCTBillingCycle__c = '20',
			EstatusCobranza__c = 'FP',
			OwnerId = usr1.Id
		);
		insert regPros;
		


		Account acc3 = new Account(
			Name = 'Pruebas5',
			RFC__c = 'ABC123456EFN',
			OwnerID = usr1.Id,
			TipoCliente__c = 'Prospecto'
		);
		insert acc3;

		Cliente__c newClient3 = new Cliente__c(
			Name = 'Pruebas5',
			RFC1__c = 'ABC123456EFN',
			//RecordType.Name
			OwnerId = usr1.Id,
			DCTStatus__c = 'Activo'
		);
		insert newClient3;

		DCTRegion__c regPros3 = new DCTRegion__c(
			RFC__c = 'ABC123456EF4',
			Name = 'Pruebas5',
			DCTBillingCycle__c = '20',
			EstatusCobranza__c = 'FP',
			OwnerId = usr1.Id
		);
		insert regPros3;


		Account acc4 = new Account(
			Name = 'Pruebas6',
			RFC__c = 'ABC123456EFO',
			OwnerID = usr1.Id,
			TipoCliente__c = 'Prospecto'
		);
		insert acc4;

		//Cliente__c newClient4 = new Cliente__c(
		//	Name = 'Pruebas6',
		//	RFC1__c = 'ABC123456EFO',
		//	//RecordType.Name
		//	OwnerId = usr1.Id,
		//	DCTStatus__c = 'Activo'
		//);
		//insert newClient4;

		DCTRegion__c regPros4 = new DCTRegion__c(
			RFC__c = 'ABC123456EFO',
			Name = 'Pruebas6',
			DCTBillingCycle__c = '97',
			EstatusCobranza__c = 'FP',
			OwnerId = usr1.Id
		);
		insert regPros4;

		Account acc5 = new Account(
			Name = 'Pruebas7',
			RFC__c = 'ABC123456EFP',
			OwnerID = usr1.Id,
			TipoCliente__c = 'Cliente Cautivo'
		);
		insert acc5;

		Cliente__c newClient5 = new Cliente__c(
			Name = 'Pruebas7',
			RFC1__c = 'ABC123456EFP',
			RecordTypeId = mapRTsByDevName.get('Cliente__c').get('Cliente_Cautivo').Id,
			OwnerId = usr1.Id,
			DCTStatus__c = 'Activo'
		);
		insert newClient5;

		//DCTRegion__c regPros5 = new DCTRegion__c(
		//	RFC__c = 'ABC123456EFP',
		//	Name = 'Pruebas7',
		//	DCTBillingCycle__c = '20',
		//	EstatusCobranza__c = 'FP',
		//	OwnerId = usr1.Id
		//);
		//insert regPros5;
	}
	
	@isTest static void DCT_NewLeadFromCustomAccount_ctr() {
		Cliente__c newProspect = new Cliente__c();
		
		DCT_NewLeadFromCustomAccount_ctr newLead = new DCT_NewLeadFromCustomAccount_ctr(new ApexPages.StandardController(newProspect));
		Test.startTest();
			newLead.goToNewLeadCreationPage();
		Test.stopTest();
	}
	
	@isTest static void DCT_NewCustomLead_ext_NewProspect_Fisica() {
		Account newLeadAcc = new Account(
			DTC_LegalEntity__c = 'Física',
			RFC__c = 'ABCD123456EFI',
			DCTLastName__c = 'Pruebas',
			DCTMotherLastName__c = 'Ejemplo',
			DCTName__c = 'Test',
			Segmento__c = 'Corporativo',
			DCT_TypeOfProcedure__c = 'Lineas Nuevas',
			Sector__c = 'Financiero',
			Subsector__c = 'Afores'
		);

		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			newProspect.performSaving();
			newProspect.changeStatus();
			newProspect.redirectToDC();
			newProspect.cancel();

		Test.stopTest();
	}

	@isTest static void DCT_NewCustomLead_ext_NewProspect_Moral() {
		Account newLeadAcc = new Account(
			DTC_LegalEntity__c = 'Moral',
			RFC__c = 'ABC123456EFJ',
			DCTControlFieldName__c = 'Pruebas',
			Segmento__c = 'Corporativo',
			DCT_TypeOfProcedure__c = 'Lineas Nuevas',
			Sector__c = 'Financiero',
			Subsector__c = 'Afores'
		);

		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			newProspect.performSaving();
			newProspect.changeStatus();
			newProspect.redirectToDC();
		Test.stopTest();
	}

	@isTest static void DCT_NewCustomLead_ext_NewProspectWithOutInputs() {
		Account newLeadAcc = new Account();

		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			newProspect.performSaving();
		Test.stopTest();
	}

	@isTest static void DCT_NewCustomLead_ext_NewProspectWithOutInputs2() {
		Account newLeadAcc = new Account(
			RFC__c = 'ABCD123456EF',
			DTC_LegalEntity__c = 'Física'
		);

		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			newProspect.performSaving();
		Test.stopTest();
	}

	@isTest static void DCT_NewCustomLead_ext_NewProspectWithOutInputs3() {

		Account newLeadAcc = new Account(
			RFC__c = 'ABC123456EF',
			DTC_LegalEntity__c = 'Moral'
		);

		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			newProspect.performSaving();
		Test.stopTest();
	}

	@isTest static void DCT_NewCustomLead_ext_NewProspect_Region20() {
		Account newLeadAcc = new Account(
			DTC_LegalEntity__c = 'Moral',
			RFC__c = 'ABC123456EFG',
			DCTControlFieldName__c = 'Prueba',
			Segmento__c = 'Corporatico',
			DCT_TypeOfProcedure__c = 'Lineas Nuevas',
			Sector__c = 'Financiero',
			Subsector__c = 'Afores'
		);

		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			newProspect.performSaving();
		Test.stopTest();
	}

	@isTest static void DCT_NewCustomLead_ext_NewProspect_Region97() {
		Account newLeadAcc = new Account(
			DTC_LegalEntity__c = 'Moral',
			RFC__c = 'ABC123456EFH',
			DCTControlFieldName__c = 'Prueba1',
			Segmento__c = 'Corporatico',
			DCT_TypeOfProcedure__c = 'Lineas Nuevas',
			Sector__c = 'Financiero',
			Subsector__c = 'Afores'
		);

		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
			newProspect.performSaving();
		Test.stopTest();
	}
	
	@isTest static void DCT_NewCustomLead_ext_NewProspect_RegionFP() {
		Account newLeadAcc = new Account(
			DTC_LegalEntity__c = 'Moral',
			RFC__c = 'ABC123456EFI',
			DCTControlFieldName__c = 'Prueba2',
			Segmento__c = 'Corporatico',
			DCT_TypeOfProcedure__c = 'Lineas Nuevas',
			Sector__c = 'Financiero',
			Subsector__c = 'Afores'
		);

		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
			newProspect.performSaving();
		Test.stopTest();
	}

	@isTest static void DCT_NewCustomLead_ext_NewProspect_ProspectDuplicate() {
		Account newLeadAcc = new Account(
			DTC_LegalEntity__c = 'Física',
			RFC__c = 'ABCD123456EFM',
			DCTLastName__c = 'Pruebas',
			DCTMotherLastName__c = 'Ejemplo',
			DCTName__c = 'TestS',
			Segmento__c = 'Corporativo',
			DCT_TypeOfProcedure__c = 'Lineas Nuevas',
			Sector__c = 'Financiero',
			Subsector__c = 'Afores'
		);

		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			newProspect.performSaving();
		Test.stopTest();
	}

	@isTest static void DCT_NewCustomLead_ext_NewProspect_ProspectDuplicate2() {
		Account newLeadAcc = new Account(
			DTC_LegalEntity__c = 'Moral',
			RFC__c = 'ABC123456EFN',
			DCTControlFieldName__c = 'Pruebas5',
			Segmento__c = 'Corporativo',
			DCT_TypeOfProcedure__c = 'Lineas Nuevas',
			Sector__c = 'Financiero',
			Subsector__c = 'Afores'
		);

		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			newProspect.performSaving();
			newProspect.changeStatus();
			newProspect.redirectToDC();
		Test.stopTest();
	}

	@isTest static void DCT_NewCustomLead_ext_NewProspect_ProspectDuplicate3() {
		Account newLeadAcc = new Account(
			DTC_LegalEntity__c = 'Moral',
			RFC__c = 'ABC123456EFO',
			DCTControlFieldName__c = 'Pruebas6',
			Segmento__c = 'Corporativo',
			DCT_TypeOfProcedure__c = 'Lineas Nuevas',
			Sector__c = 'Financiero',
			Subsector__c = 'Afores'
		);

		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
			newProspect.performSaving();
			newProspect.changeStatus();
			newProspect.redirectToDC();
		Test.stopTest();
	}

	@isTest static void DCT_NewCustomLead_ext_NewProspect_ProspectDuplicate4() {
		Account newLeadAcc = new Account(
			DTC_LegalEntity__c = 'Moral',
			RFC__c = 'ABC123456EFP',
			DCTControlFieldName__c = 'Pruebas7',
			Segmento__c = 'Corporativo',
			DCT_TypeOfProcedure__c = 'Lineas Nuevas',
			Sector__c = 'Financiero',
			Subsector__c = 'Afores'
		);

		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			newProspect.performSaving();
			newProspect.changeStatus();
			newProspect.redirectToDC();
		Test.stopTest();
	}

	@isTest static void DCT_NewCustomLead_ext_NewProspect_ProspectDuplicate5() {
		Account newLeadAcc = new Account(
			DTC_LegalEntity__c = 'Moral',
			RFC__c = 'ABC123456EFQ',
			DCTControlFieldName__c = 'Pruebas7',
			Segmento__c = 'Corporativo',
			DCT_TypeOfProcedure__c = 'Lineas Nuevas',
			Sector__c = 'Financiero',
			Subsector__c = 'Afores'
		);

		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			newProspect.performSaving();
			newProspect.changeStatus();
			newProspect.redirectToDC();
		Test.stopTest();
	}

	@isTest static void DCT_NewCustomLead_ext_NewProspect_ProspectDuplicate6() {
		Account newLeadAcc = new Account(
			DTC_LegalEntity__c = 'Física',
			RFC__c = 'ABCD123456EFR',
			DCTLastName__c = 'Pruebas',
			DCTMotherLastName__c = 'Ejemplo',
			DCTName__c = 'TestS',
			Segmento__c = 'Corporativo',
			DCT_TypeOfProcedure__c = 'Lineas Nuevas',
			Sector__c = 'Financiero',
			Subsector__c = 'Afores'
		);

		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			newProspect.performSaving();
		Test.stopTest();
	}
}