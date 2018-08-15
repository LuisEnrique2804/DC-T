@isTest
private class DCT_RelatedListAssigment_tst {
	
	@isTest static void test_method_one() {
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');
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

		Account acc1 = new Account(
			Name = 'Prueba2',
			RFC__c = 'ABC123456EFL',
			OwnerID = usr1.Id,
			TipoCliente__c = 'Prospecto'
		);
		insert acc1;

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


		DCTAssignment__c assigment = new DCTAssignment__c(
			Aprobador__c = usr.id,
			Status__c = 'Rechazado'
		);
		insert assigment;

		DCTClientsProspectstoAssigned__c newProsAssigment = new DCTClientsProspectstoAssigned__c(
			Name            = 'Test',
			Approval__c     = true,
			AccountName__c  = acc.id,
			IssuingUser__c  = usr.id,
			UserReceiver__c = usr1.id,
			Status__c       = 'Aprobado',
			AssignmentNumber__c = assigment.id
		);
		insert newProsAssigment;

		DCTClientsProspectstoAssigned__c newProsAssigment1 = new DCTClientsProspectstoAssigned__c(
			Name            = 'Test',
			Approval__c     = true,
			AccountName__c  = acc1.id,
			IssuingUser__c  = usr.id,
			UserReceiver__c = usr1.id,
			Status__c       = 'Rechazado',
			AssignmentNumber__c = assigment.id
		);
		insert newProsAssigment1;

		DCT_RelatedListAssigment_ctr newAssigment = new DCT_RelatedListAssigment_ctr(new ApexPages.StandardController(assigment));
		Test.startTest();
			newAssigment.validateSatus();
			newAssigment.getDCTAssigment();
			newAssigment.regresar();
			newAssigment.reject();
			newAssigment.save();
			newAssigment.getMyCommandButtons();
			newAssigment.refreshGrid();
			newAssigment.Previous();
			newAssigment.Next();
			newAssigment.End();
			newAssigment.getDisablePrevious();
			newAssigment.getDisableFirst();
			newAssigment.getDisableNext();
			newAssigment.getTotal_size();
			newAssigment.getPageNumber();
			newAssigment.getTotalPages();
		Test.stopTest();
	}
	
}