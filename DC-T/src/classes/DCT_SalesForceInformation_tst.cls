@isTest
private class DCT_SalesForceInformation_tst {
	
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
            UserName          = username,
            DCTXO__c          = 'XON0837',
            DCTVT__c          = 'VTOSVIRE'
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

		Contact cont = new Contact(
			OwnerId   = usr.Id, 
			FirstName = 'test',
			LastName  = 'test',
			AccountId = newLeadAcc.Id,
			Directorio_Comercial__c = prospect.Id
		);
		insert cont; 

		DCT_SalesForceInformation_ctr newProspect = new DCT_SalesForceInformation_ctr(new ApexPages.StandardController(prospect));
		Test.startTest();
			newProspect.ActualizaFuerzaVetaWs();
		Test.stopTest();
		//{"DirectorioEmpleados":[{"mClaveArea":90040101,"mDescripcionArea":"DEPTO CLIENTES CORPORATIVOS I","mDescripcionPuesto":"JEFE DE CLIENTES CORPORATIVOS","mNumeroEmpleado":"2103","mNombreEmpleado":"OSCAR","mApellidoPaterno":"VIVERO","mApellidoMaterno":"REYES","mExtension":"4866","mCelular":"5510101164","mDescripcionTipoEmpleado":"INTERNO","mPerfilID":3,"mDescripcionPerfil":"JEFE","mEsResponsableEquipoTrabajo":true,"mPosicionPadreID":162},{"mClaveArea":90040101,"mDescripcionArea":"DEPTO CLIENTES CORPORATIVOS I","mDescripcionPuesto":"ESPECIALISTA DE CLIENTES CORPORATIVOS EXTERNO","mNumeroEmpleado":"EXE119215","mNombreEmpleado":"JULIO CESAR","mApellidoPaterno":"SANCHEZ","mApellidoMaterno":"OLVERA","mExtension":"7968","mCelular":"0","mDescripcionTipoEmpleado":"EXTERNO","mPerfilID":6,"mDescripcionPerfil":"ANALISTA","mEsResponsableEquipoTrabajo":false,"mPosicionPadreID":164},{"mClaveArea":90040101,"mDescripcionArea":"DEPTO CLIENTES CORPORATIVOS I","mDescripcionPuesto":"ESPECIALISTA DE CLIENTES CORPORATIVOS EXTERNO","mNumeroEmpleado":"EX251493","mNombreEmpleado":"DIANA KAREN","mApellidoPaterno":"UGALDE","mApellidoMaterno":"GONZALEZ","mExtension":"6247","mCelular":"0","mDescripcionTipoEmpleado":"EXTERNO","mPerfilID":6,"mDescripcionPerfil":"ANALISTA","mEsResponsableEquipoTrabajo":false,"mPosicionPadreID":164}]}
	}
	
}