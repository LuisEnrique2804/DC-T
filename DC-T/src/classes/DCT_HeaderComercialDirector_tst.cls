@isTest
private class DCT_HeaderComercialDirector_tst {
	
	@TestSetup static void setup(){
			
	}

	@isTest static void test_method_one() {
		
		Cliente__c newClient = new Cliente__c(
			Name = 'Pruebas Ejemplo TestS',
			RFC1__c = 'ABCD123456EFM',
			DCTStatus__c = 'Activo'
		);
		insert newClient;
		Test.startTest();
			DCT_HeaderComercialDirector_ctr newLead = new DCT_HeaderComercialDirector_ctr(new ApexPages.StandardController(newClient));
			newLead.submitForApproval();
		Test.stopTest();
	}
	
}