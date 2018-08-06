@isTest
private class DCT_assignmentNewOwner_tst {

	@TestSetup static void setup(){
		List<Cliente__c> lstNewProspect = new List<Cliente__c>();
		
		Cliente__c prospect = new Cliente__c(
			//OwnerId,
			//Name,
			//RecordType.DeveloperName,
			//DCTRegistrationDate__c,
			//CTExtensionValidity__c,
			//Cliente__r.DCT_RegistrationDate__c,
			//Cliente__c,
			//Cliente__r.OwnerId
		);
		lstNewProspect.add(prospect);
		Cliente__c prospect2 = new Cliente__c();
		lstNewProspect.add(prospect2);
		insert lstNewProspect;


	}
	
	@isTest static void test_method_one() {
		Test.startTest();
			DCT_assignmentNewOwner_sch scheduleInstance = new DCT_assignmentNewOwner_sch();
			String strChronExpresion = '0 0 0 15 * ? ';
			System.schedule('AssignmentNewOwnerTest',
				trChronExpresion,
				cheduleInstance);
		Test.stopTest();
	}	
}