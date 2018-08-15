@isTest
private class DCT_Distributor_tst {

	@TestSetup static void setup(){
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
		Map<String,Map<String,RecordType>> mapRTsByDevName = TLCL_Utils_cls.getRecordTypes('DeveloperName');
		System.debug(loggingLevel.Error, '*** mapRTsByDevName: ' + mapRTsByDevName);		
	}
	
	@isTest static void DCT_Distributor_ctr() {

		Cliente__c newClient = new Cliente__c(
			Name = 'Pruebas Ejemplo TestS',
			RFC1__c = 'ABCD123456EFM',
			//RecordType.Name
			//OwnerId = usr1.Id,
			DCTStatus__c = 'Activo'
		);
		insert newClient;

		DCT_Distributor_ctr newLead = new DCT_Distributor_ctr(new ApexPages.StandardController(newClient));
		Test.startTest();
			newLead.ActualizaDistribuidoresWs();
			newLead.fuerzaVentaChange();
		Test.stopTest();
	}
	
}