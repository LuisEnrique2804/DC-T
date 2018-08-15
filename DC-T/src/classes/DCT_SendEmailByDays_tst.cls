@isTest
private class DCT_SendEmailByDays_tst {
	
	@isTest static void test_method_one() {

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

		Test.startTest();
			DCT_SendEmailByDays_sch scheduleInstance = new DCT_SendEmailByDays_sch();
			String strChronExpresion = '0 0 0 15 * ? ';
			System.schedule('SendEmailByDaysTest',
				strChronExpresion,
				scheduleInstance);
		Test.stopTest();
	}	
}