@isTest
private class DCT_CustomerTechnicalToken_tst {
	
	@isTest static void test_method_one() {
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('Eventos');
		
		String  profileName = Label.DCT_AdministratorProfile; //Administrador del sistema
		String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';
		String   username2 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';
		Map<String,Map<String,RecordType>> mapRTsByDevName = TLCL_Utils_cls.getRecordTypes('DeveloperName');
		//System.debug(loggingLevel.Error, '*** mapRTsByDevName: ' + mapRTsByDevName);

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
			Cliente__c              = newLeadAcc.Id,
			DCTControlled__c        = 'EIN03;EIL00',
			DCTOpen__c              = 'EIL08;EIL00'
			//DCTRegistrationDate__c = ,
		);
		insert prospect;


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

		DCTPlan__c plan = new DCTPlan__c(
			ClaveFuerzaVenta__c = 'Test', 
			ClavePlan__c = 'Test', 
			ClaveDetallePlan__c = 'Test',
			DescripcionServcicio__c = 'Test'
		);
		insert plan;

		System.debug(loggingLevel.Error, '*** mapRTsByDevName.get(DCTAuthorizedLines__c).get(DCTPlan): ' + mapRTsByDevName.get('DCTAuthorizedLines__c').get('DCTPlan'));
		DCTAuthorizedLines__c newAuthLines = new DCTAuthorizedLines__c(
			Status__c = 'Pendiente',
			CommercialDirectory__c = prospect.id,
			RecordTypeid  = mapRTsByDevName.get('DCTAuthorizedLines__c').get('DCTPlan').Id,
			Clave__c = 'Test',
			Name = 'Test',
			DCTTerm__c = 'LIBRE',
			DCT_Tarifa__c = 'B',
			DCTHideAdditionalServices__c = true,
			Plan__c = plan.id
		);
		insert newAuthLines;

		ServiciosTradicionales__c servTrad = new ServiciosTradicionales__c(
			MapaCliente__c = mc.id
		);
		insert servTrad;

		DCTDedicatedLinks__c dL = new DCTDedicatedLinks__c(
			OwnerId           = usr.Id, 
			Name = 'Test',
			DCTRegistrerDate__c  = system.today(),
			KeyCode__c = '1',
			ClientName__c = prospect.Id

		);
		insert dl;	

		DCTCompetitors__c compe = new DCTCompetitors__c(
			Name ='Test',
			IsActive__c = true
		);
		insert compe; 

		CompetidoresPlataformas__c compePlata = new CompetidoresPlataformas__c(
			ServiciosTradicionales__c = servTrad.id,
			Directorio_Comercial__c = prospect.Id,
			DCTCompetitors__c = compe.id,
			DCTPortabilityType__c = 'Port In',
			DCTLines__c = 1,
			DCTBaselinesCompetence__c = 3
		);
		insert compePlata;
		System.debug(loggingLevel.Error, '*** compePlata: ' + compePlata);

		DCT_CustomerTechnicalToken_ext newTechnicalToken = new DCT_CustomerTechnicalToken_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			//newTechnicalToken.creaConsecutivoWebSer();
			//newTechnicalToken.DespliegaCamposNuevoPlan();
			//newTechnicalToken.actualizaGrupoPlan();
			newTechnicalToken.blnIsEmptyControlledVPNKeyMap = true;
			newTechnicalToken.blnIsEmptyOpenVPNKeyMap = true;
			newTechnicalToken.blnIsEmptyCompetitorMap= false;
			newTechnicalToken.validaTipoServ();
			newTechnicalToken.ActualizaDatosCatalogoVpnWebService('R09');
			newTechnicalToken.actualizaDatos();
			newTechnicalToken.returnToDirectory();
			newTechnicalToken.processCompetitors();
			newTechnicalToken.toggleNewCompetitor();
			ApexPages.currentPage().getParameters().put('competId',compePlata.id);
			//newTechnicalToken.strCompetitorId = String.valueOf(compePlata.id);
			newTechnicalToken.saveNewCompetitor();
			newTechnicalToken.newCompetitorInstance.DCTCompetitors__c = compe.id;
			newTechnicalToken.newCompetitorInstance.DCTPortabilityType__c = 'Port In';
			newTechnicalToken.newCompetitorInstance.DCTLines__c = 1;
			newTechnicalToken.newCompetitorInstance.DCTBaselinesCompetence__c = 3;
			newTechnicalToken.saveNewCompetitor();
			newTechnicalToken.eraseCompetitor();
			ApexPages.currentPage().getParameters().put('competGroupId',compePlata.id);
			newTechnicalToken.eraseCompetitorsGroup();
			newTechnicalToken.validateNewCompetitor();
			newTechnicalToken.processVPNKeys();
			newTechnicalToken.processAuthLines();
			newTechnicalToken.eraseVPNKey();
			ApexPages.currentPage().getParameters().put('VPNKeyTypeForAdd','Controlled');
			newTechnicalToken.strSelectedNewControlledVPNKey = 'EIN03';
			newTechnicalToken.addNewVPNKey();
			newTechnicalToken.validateNewVPNKey(1);

			ApexPages.currentPage().getParameters().put('VPNKeyTypeForAdd','Open');
			newTechnicalToken.strSelectedNewOpenVPNKey = 'EIL08';
			newTechnicalToken.validateNewVPNKey(2);
			newTechnicalToken.addNewVPNKey();
			newTechnicalToken.getControlledVPNKeysOptions();
			newTechnicalToken.getOpenVPNKeysOptions();
			newTechnicalToken.getRelatedAccs();
			newTechnicalToken.consultaProductos();
			newTechnicalToken.collapseExpandSection();
			ApexPages.currentPage().getParameters().put('provId',newAuthLines.id);
			newTechnicalToken.erasePrivisioning();
			newTechnicalToken.saveUpdateProvisioningItem();
			newTechnicalToken.changeblnNewProvisingItem();
			newTechnicalToken.selectedPlan = String.valueOf(newAuthLines.id);
			newTechnicalToken.toggleNewProvisioningItem();
			newTechnicalToken.changeblnNewProvisingItem();
			newTechnicalToken.selectedPlan = String.valueOf(newAuthLines.id);
			newTechnicalToken.toggleNewProvisioningItem();
			newTechnicalToken.saveVPNKeys();
			newTechnicalToken.saveNewProvisioningItem();
			newTechnicalToken.toggleNewDedicatedLinksUI();

			newTechnicalToken.getServiceKeyOptions();
			newTechnicalToken.validateNewPLink();
			ApexPages.currentPage().getParameters().put('dedLinkId',dl.id);
			newTechnicalToken.eraseDedidateLink();
			newTechnicalToken.saveChangesOnGeneralData();
			newTechnicalToken.refreshTable();
			newTechnicalToken.cancel();
		Test.stopTest();
	}
}