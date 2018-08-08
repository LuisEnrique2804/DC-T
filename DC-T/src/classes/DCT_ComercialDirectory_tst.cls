@isTest
private class DCT_ComercialDirectory_tst {	
	@isTest static void ComercialDirectoryWithOutRelationship() {
		
		String  profileName = Label.DCT_AdministratorProfile; //Administrador del sistema
		String   username2 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';          
		Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];
		User usr1 = new User(
            Alias             = username2.substringAfterLast('@'),
            Email             = username2,
            EmailEncodingKey  = 'UTF-8',
            LastName          = username2,
            LanguageLocaleKey = 'es_MX',
            LocaleSidKey      = 'es_MX',
            ProfileId         = p.Id,
            TimeZoneSidKey    = 'America/Mexico_City',
            UserName          = username2

        );
        insert usr1;

		Cliente__c newClient = new Cliente__c(
			Name = 'Pruebas Ejemplo TestS',
			RFC1__c = 'ABCD123456EFM',
			//RecordType.Name
			OwnerId = usr1.Id,
			DCTStatus__c = 'Activo'
		);
		insert newClient;

		Product2 newProduct = new Product2(
			Name = 'Test'
		);
		insert newProduct;

		DCTDirectoryProductRelationship__c newDirecProd = new DCTDirectoryProductRelationship__c(
			DCTCommercialDirectory__c = newClient.id,
			DCTProduct__c = newProduct.id
		);
		insert newDirecProd;


		DCT_ComercialDirectory_ctr newProd = new DCT_ComercialDirectory_ctr(new ApexPages.StandardController(newProduct));
		Test.startTest();
			newProd.refreshTable();
			newProd.watchField2();
			newProd.saveProduct();
		Test.stopTest();
	}

	@isTest static void ComercialDirectoryWithRelationship() {
		String  profileName = Label.DCT_AdministratorProfile; //Administrador del sistema
		String   username2 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';          
		Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];
		User usr1 = new User(
            Alias             = username2.substringAfterLast('@'),
            Email             = username2,
            EmailEncodingKey  = 'UTF-8',
            LastName          = username2,
            LanguageLocaleKey = 'es_MX',
            LocaleSidKey      = 'es_MX',
            ProfileId         = p.Id,
            TimeZoneSidKey    = 'America/Mexico_City',
            UserName          = username2

        );
        insert usr1;

		Cliente__c newClient = new Cliente__c(
			Name = 'Pruebas Ejemplo TestS',
			RFC1__c = 'ABCD123456EFM',
			//RecordType.Name
			OwnerId = usr1.Id,
			DCTStatus__c = 'Activo'
		);
		insert newClient;

		Product2 newProduct = new Product2(
			Name = 'Test',
			DCT_IsSpecialProduct__c = true
		);
		insert newProduct;

		DCT_ComercialDirectory_ctr newProd = new DCT_ComercialDirectory_ctr(new ApexPages.StandardController(newProduct));
		Test.startTest();
			newProd.refreshTable();
			newProd.watchField2();
			newProd.DCTnewProduct.DCTCommercialDirectory__c = newClient.Id;
			newProd.saveProduct();
		Test.stopTest();
	}
	
}