@isTest
private class DTC_NewCustomLead_tst {

	@TestSetup static void setup(){
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
			RFC__c = 'ABCD123456EFH',
			Name = 'Prueba1',
			DCTBillingCycle__c = '97',
			EstatusCobranza__c = 'HB'
		);
		insert reg2;
		lstregion.add(reg2);
		
		DCTRegion__c reg3 = new DCTRegion__c(
			RFC__c = 'ABCD123456EFI',
			Name = 'Prueba2',
			DCTBillingCycle__c = '01',
			EstatusCobranza__c = 'FP'
		);
		insert reg3;
		lstregion.add(reg3);

		//insert lstregion;
	}
	
	@isTest static void DCT_NewLeadFromCustomAccount_ctr() {
		Cliente__c newProspect = new Cliente__c();
		
		DCT_NewLeadFromCustomAccount_ctr newLead = new DCT_NewLeadFromCustomAccount_ctr(new ApexPages.StandardController(newProspect));
		Test.startTest();
			newLead.goToNewLeadCreationPage();
		Test.stopTest();
	}
	
	@isTest static void DCT_NewCustomLead_ext_NewProspect() {
		Account newLeadAcc = new Account(
			DTC_LegalEntity__c = 'Física',
			RFC__c = 'ABCD123456EFJ',
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

	@isTest static void DCT_NewCustomLead_ext_NewProspect_Region() {
		Account newLeadAcc = new Account(
			DTC_LegalEntity__c = 'Moral',
			RFC__c = 'ABC123456EFG',
			DCTControlFieldName__c = 'Prueba',
			Segmento__c = 'Corporatico',
			DCT_TypeOfProcedure__c = 'Lineas Nuevas',
			Sector__c = 'Financiero',
			Subsector__c = 'Afores'
		);

		DCTRegion__c reg = [SELECT Id, RFC__c, Name, DCTBillingCycle__c, EstatusCobranza__c FROM DCTRegion__c Limit 1];
		System.debug(loggingLevel.Error, '*** reg: ' + reg);
		DCT_NewCustomLead_ext newProspect = new DCT_NewCustomLead_ext(new ApexPages.StandardController(newLeadAcc));
		Test.startTest();
			newProspect.performSaving();
		Test.stopTest();
	}
	
}