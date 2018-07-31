public with sharing class DCT_AccountAprovedRejectedCtrl {
	
	public String sApproveReject {get;set;}
	public List<DCTClientsProspectstoAssigned__c> lDCTClientsProspectstoAssigned {get;set;}
	public List<DCTClientsProspectstoAssigned__c> lDCTClientsProspectstoAssignedUpd {get;set;}
	public Map<String, String> mapParametros {get;set;}
	
	public DCT_AccountAprovedRejectedCtrl(ApexPages.StandardSetController ctrl){
		//Inicializa 
		 lDCTClientsProspectstoAssigned = new List<DCTClientsProspectstoAssigned__c>();
		 lDCTClientsProspectstoAssignedUpd = new List<DCTClientsProspectstoAssigned__c>();
		 mapParametros = new Map<String, String>();
		 
		 //Toma los parametros
		 //mapParametros = ApexPages.currentPage().getParameters().get('ApproveReject');
		 mapParametros = ApexPages.currentPage().getParameters();		 
		 for (String sIdParam : mapParametros.KeySet()){
			 System.debug('EN DCT_AccountAprovedRejectedCtrl Llave: ' + sIdParam);
			 System.debug('EN DCT_AccountAprovedRejectedCtrl Valor: ' + mapParametros.get(sIdParam));
		 }
		 
		 //Recorre la lista de ctrl.getRecords()
		 for (sObject objetoPaso : ctrl.getSelected()){
		 	lDCTClientsProspectstoAssigned.add((DCTClientsProspectstoAssigned__c) objetoPaso);
		 }
		 
    }   

	// performs the keyword search
	public PageReference ActualizaClientes() {
		System.debug('EN DCT_AccountAprovedRejectedCtrl.ActualizaClientes...');
		
		//Recorre la lista de lDCTClientsProspectstoAssigned y actualizalos
		for (DCTClientsProspectstoAssigned__c objDCTClientsProspectstoAssignedPaso : lDCTClientsProspectstoAssigned){
			lDCTClientsProspectstoAssignedUpd.add(new DCTClientsProspectstoAssigned__c(
					id = objDCTClientsProspectstoAssignedPaso.id,
					Status__c = sApproveReject == 'Approved' ? 'Aprobado' : 'Rechazado' 
				)
			);
		}
		
		//Despliega los datos 
		System.debug('EN DCT_AccountAprovedRejectedCtrl.ActualizaClientes lDCTClientsProspectstoAssignedUpd: ' + lDCTClientsProspectstoAssignedUpd);
				
		return null;
	}

	
	
	

}