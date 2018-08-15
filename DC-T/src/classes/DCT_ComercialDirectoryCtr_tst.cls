@isTest
private class DCT_ComercialDirectoryCtr_tst {
	
	@isTest static void test_method_one() {

		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');
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
            DTC_CanalAtencion__c = 'Corporativo',
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
            DTC_CanalAtencion__c = 'Empresarial',
            UserName          = username2,
            ManagerId         = usr.id
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
			OwnerId                 = usr.id,
			Estatus__c              = 'Activo',
			DCTDateOut__c           = System.today().addDays(-1)
		);
		Insert newLeadAcc;

		Account newLeadAcc2 = new Account(
			DTC_LegalEntity__c      = 'Gubernamental',
			RFC__c                  = 'ABC123456EFJ',
			Name                    = 'Pruebas',
			Segmento__c             = 'Empresarial',
			DCT_TypeOfProcedure__c  = 'Lineas Nuevas',
			Sector__c               = 'Financiero',
			Subsector__c            = 'Afores',
			DCT_RegistrationDate__c = System.today().addDays(1),
			OwnerId                 = usr2.id,
			Estatus__c              = 'Inactivo',
			DCTDateOut__c           = System.today().addDays(1)
		);
		Insert newLeadAcc2;

		MapaCliente__c mc = new MapaCliente__c(
			PlanCliente__c = newLeadAcc.Id
		);
		insert mc;

		DCTSalesForceCatalog__c fzaVenta = new DCTSalesForceCatalog__c(
			Name = 'Test'
		);
		insert fzaVenta;

		ServiciosTradicionales__c servTrad1 = new ServiciosTradicionales__c(
			MapaCliente__c = mc.id
		);
		insert servTrad1;

		ServiciosTradicionales__c servTrad2 = new ServiciosTradicionales__c(
			MapaCliente__c = mc.id
		);
		insert servTrad2;

		DCTGruop__c group1 = new DCTGruop__c(Name = 'Test');
		insert group1;

		DCTGruop__c group2 = new DCTGruop__c(Name = 'Test2');
		insert group2;

		DCTRegion__c reg = new DCTRegion__c(
			RFC__c = 'ABC123456EFJ',
			Name = 'Pruebas Ejemplo TestS',
			DCTBillingCycle__c = '20',
			EstatusCobranza__c = 'HB'
		);
		insert reg;

		Cliente__c newClient = new Cliente__c(
			Name = 'Pruebas Ejemplo TestS',
			Cliente__c = newLeadAcc.id,
			//RecordType.Name
			OwnerId = usr.Id,
			DCTSharedTreatment__c = true,
			DCT_CatalogoFuerzaVenta__c = fzaVenta.id,
			DCTStatus__c = 'Activo',
			DCTBank__c = 'Bancomer',
			DCTBenefits__c = 'Ejemplo',
			DCTBonusCustomization__c = false,
			DCTCollectionBonus__c = false,
			DCTKeyNISI__c = '123456789',
			DCTAnticipatedAdendum__c = 'Si',
			DCTCustomerFrom__c = System.today(),
			DCTComments__c = 'Test',
			Competidores__c = servTrad1.id,
			//Cuentaprincipal__c,
			DCTCorrespondenceStreet__c = 'Manuel Avila Camacho',
			DCTCorrespondenceColony__c = 'Reforma Social',
			DCTDelMpiocorrespondence__c = 'Benito Juarez',
			DCTCodePostcorrespondence__c = '12345',
			DCTFiscalStreet__c= 'Manuel Avila Camacho',
			DCTColonyFiscal__c= 'Reforma Social',
			DCTDelMpiofiscal__c= 'Benito Juarez',
			DCTCodePostfiscal__c= '12345',
			DCTCreditBureau__c = true,
			DCTExemptBail__c = true,
			DCTDateRegistrationAdjudication__c = system.today(),
			DCTMethodOfPayment__c = 'Cheque',
			DCTCategoryData__c = 'PRO EMPRESA1000 BBCB',
			Grupo__c = group1.id,
			DCTReasonRejection__c = 'Test',
			DCT_NombreComercial__c = 'Cuenta Prueba',
			//DCT_LegalPerson__c,
			//DCTPlan__c,
			DCTTermDays__c = '30',
			DCTOtherRegions__c = 'R1',
			DCTOtherCountries__c = 'Argentina',
			//OwnerId,
			DCTFullCompanyName__c= 'Cuenta Naacional de Prueba',
			DCTSocialReasonModified__c = 'Adjudicación',
			DCTRapReference__c = '12545',
			DCTLegalRepresentative__c = 'Luis Enrique Garcia Sanabria',
			RFC1__c = 'ABC123456DEF',
			//Segmento__c,
			DCTRates__c = 'AA',
			//Tipocliente__c,
			DCTAccountType__c = 'MG',
			DCTCompanyType__c = 'Test',
			DCTUseTaxAddress__c = true,
			DCTVPNActivation__c = true,
			DCTVIP__c = true,
			DCTAVL__c = true,
			DCTInplantName1__c = 'Test',
			DCTInplantName2__c = 'Test',
			DCTInplantPhone1__c = '12345678',
			DCTInplantPhone2__c = '12345678',
			DCTExt1__c = '1245',
			DCTExt2__c = '2356',
			DCTInplantmobile1__c = '5512345678',
			DCTInplantmobile2__c = '5512345678',
			DCTInplantEmail1__c = 'test@test.com',
			DCTInplantEmail2__c = 'test@test.com',
			DCTInplantDate1__c = system.today(),
			DCTInplantDate2__c = system.today(),
			DCTDistributor1__c = 'Test',
			DCTDistributor2__c = 'Test',
			DCTResultVerification__c = 'Test',
			DCTResearchLegend__c = 'Test',
			DCTInvestigation__c = 'BH',
			DCTCommentsInvestigation__c = 'Test',
			DCTApprovalProcess__c = true,
			DCTAskAuthorization__c = true,
			DCTTypeAuthorization__c = 'Positiva',
			DCTTotLineasAutorInvest__c = 'test',
			DCTConductResearch__c = true
			//DCTCareChannel__c 
		);
		insert newClient;

		Opportunity newOpp = new Opportunity(
			Name                    = 'Test',
			StageName               = 'Proyecto',
			Directorio_Comercial__c = newClient.Id,
			CloseDate               = System.today(),
			AccountId               = newLeadAcc.Id,
			RazonSocialGlobal__c    = newLeadAcc.Id,
			MapaCliente__c          = mc.Id
			//Directorio_Comercial__c = prospect.Id
		); 
		insert newOpp;

		newClient.Cliente__c = newLeadAcc2.id;
		newClient.DCTBank__c = 'Banamex';
		newClient.DCTBenefits__c = 'Ejemplo2';
		newClient.DCTBonusCustomization__c = true;
		newClient.DCTCollectionBonus__c = true;
		newClient.DCTDays__c = 5;
		newClient.DCTKeyNISI__c = '123456780';
		newClient.DCTCustomerFrom__c = System.today().addDays(2);
		newClient.DCTComments__c = 'Prueba';
		newClient.Competidores__c = servTrad2.id;
		//newClient.Cuentaprincipal__c = ;
		newClient.DCTCorrespondenceStreet__c = 'Lago Zurich';
		newClient.DCTCorrespondenceColony__c = 'Ampliacion Granada';
		newClient.DCTDelMpiocorrespondence__c = 'Miguel Hidalgo';
		newClient.DCTCodePostcorrespondence__c = '54321';
		newClient.DCTFiscalStreet__c = 'Lago Zurich';
		newClient.DCTColonyFiscal__c = 'Ampliacion Granada';
		newClient.DCTDelMpiofiscal__c = 'Miguel Hidalgo';
		newClient.DCTCodePostfiscal__c = '54321';
		newClient.DCTCreditBureau__c = false;
		newClient.DCTExemptBail__c = false;
		newClient.DCTDateRegistrationAdjudication__c = System.today().addDays(2);
		newClient.DCTMethodOfPayment__c = 'Efectivo';
		newClient.DCTCategoryData__c = 'PRO EMPRESA1000 CCCB';
		newClient.Grupo__c = group2.id;
		newClient.DCTReasonRejection__c = 'Prueba';
		newClient.DCT_NombreComercial__c = 'Cuenta Prueba 2 ';
		//newClient.DCT_LegalPerson__c = ;
		//newClient.DCTPlan__c = ;
		newClient.DCTTermDays__c = '60';
		newClient.DCTOtherRegions__c = 'R2';
		newClient.DCTOtherCountries__c = 'Bolivia';
		newClient.OwnerId = usr2.id;
		newClient.DCTFullCompanyName__c = 'Cuenta Naacional de Prueba2' ;
		newClient.DCTSocialReasonModified__c = 'Adjudicación';
		newClient.DCTRapReference__c = '12546';
		newClient.DCTLegalRepresentative__c = 'Luis Garcia Sanabria';
		//newClient.RFC1__c = 'ABC123456DEG';
		//newClient.Segmento__c = ;
		newClient.DCTRates__c = 'A';
		//newClient.Tipocliente__c = ;
		newClient.DCTAccountType__c = 'CO';
		newClient.DCTCompanyType__c = 'Prueba';
		newClient.DCTUseTaxAddress__c = false;
		newClient.DCTVPNActivation__c = false;
		newClient.DCTVIP__c = false;
		newClient.DCTAVL__c = false;
		newClient.DCTInplantName1__c = 'Prueba';
		newClient.DCTInplantName2__c = 'Prueba';
		newClient.DCTInplantPhone1__c = '87654321';
		newClient.DCTInplantPhone2__c = '87654321';
		newClient.DCTExt1__c = '54321';
		newClient.DCTExt2__c = '54321';
		newClient.DCTInplantmobile1__c = '5587654321';
		newClient.DCTInplantmobile2__c = '5587654321';
		newClient.DCTInplantEmail1__c = 'Prueba@prueba.com';
		newClient.DCTInplantEmail2__c = 'Prueba@prueba.com';
		newClient.DCTInplantDate1__c = System.today().addDays(2);
		newClient.DCTInplantDate2__c = System.today().addDays(2);
		newClient.DCTDistributor1__c = 'Prueba';
		newClient.DCTDistributor2__c = 'Prueba';
		newClient.DCTResultVerification__c = 'Prueba';
		newClient.DCTResearchLegend__c = 'Prueba';
		newClient.DCTInvestigation__c = 'AG';
		newClient.DCTCommentsInvestigation__c = 'Prueba';
		newClient.DCTApprovalProcess__c = false;
		newClient.DCTAskAuthorization__c = false;
		newClient.DCTTypeAuthorization__c = 'Vo. Bo. Gerente';
		newClient.DCTTotLineasAutorInvest__c = 'Prueba';
		newClient.DCTConductResearch__c = true;
		newClient.DCTDuplicateRegistrationAcceptance__c = true;
		newClient.FechaAmpliacionVigencia__c = System.today();
		newClient.DCTExtensionValidity__c = true;
		//DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
		update newClient;
	}
	
}