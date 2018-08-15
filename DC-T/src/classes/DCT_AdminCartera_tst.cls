@isTest
private class DCT_AdminCartera_tst {
	
	@isTest static void test_method_one() {
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');

		Map<String,Map<String,RecordType>> mapRTsByDevName = TLCL_Utils_cls.getRecordTypes('DeveloperName');
		System.debug(loggingLevel.Error, '*** mapRTsByDevName: ' + mapRTsByDevName);

		String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';

		String  profileName = Label.DCT_AdministratorProfile; //Administrador del sistema

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
		
		Cliente__c prospect = new Cliente__c(
			OwnerId                 = usr.id,
			Name                    = 'Pruebas',
			RecordType              = mapRTsByDevName.get('Cliente__c').get('Lead'),
			DCTExtensionValidity__c = false,
			DCTBonusinDays__c       = 5
			//DCTRegistrationDate__c = ,
		);
		insert prospect;

		Account acc = new Account(
			Name = 'Prueba2',
			RFC__c = 'ABC123456EFL',
			OwnerID = usr.Id,
			TipoCliente__c = 'Prospecto',
			DCTDateLastassignment__c = system.today()
		);
		insert acc;

		DCTAssignment__c assigment = new DCTAssignment__c(

		);
		insert assigment;

		DCTClientsProspectstoAssigned__c newClientAssigned = new DCTClientsProspectstoAssigned__c(
			UserReceiver__c = usr.id,
			IssuingUser__c = usr.id,
			AccountName__c = acc.id,
			Status__c = 'Aprobado',
			AssignmentNumber__c = assigment.id
		);
		insert newClientAssigned;

		Test.startTest();
			DCT_AdminCartera_sch scheduleInstance = new DCT_AdminCartera_sch();
			String strChronExpresion = '0 0 0 15 * ? ';
			System.schedule('AdminCarteraTest',
				strChronExpresion,
				scheduleInstance);
		Test.stopTest();
	}
}