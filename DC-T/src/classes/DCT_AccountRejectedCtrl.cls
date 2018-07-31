public with sharing class DCT_AccountRejectedCtrl {

	public String sIdApproveReject {get;set;}
	public List<DCTClientsProspectstoAssigned__c> lDCTClientsProspectstoAssigned {get;set;}
	public List<DCTClientsProspectstoAssigned__c> lDCTClientsProspectstoAssignedUpd {get;set;}
	public Map<String, String> mapParametros {get;set;}
	public List<String> SetErrores {get;set;}
	public Set<String> SetIdReg {get;set;}
		
	public DCT_AccountRejectedCtrl(ApexPages.StandardSetController ctrl){
		//Inicializa 
		 lDCTClientsProspectstoAssigned = new List<DCTClientsProspectstoAssigned__c>();
		 lDCTClientsProspectstoAssignedUpd = new List<DCTClientsProspectstoAssigned__c>();
		 mapParametros = new Map<String, String>();
		 SetIdReg = new Set<String>();
		 
		 //Toma los parametros
		 //mapParametros = ApexPages.currentPage().getParameters().get('ApproveReject');
		 mapParametros = ApexPages.currentPage().getParameters();		 
		 for (String sIdParam : mapParametros.KeySet()){
			 System.debug('EN DCT_AccountAprovedRejectedCtrl Llave: ' + sIdParam);
			 System.debug('EN DCT_AccountAprovedRejectedCtrl Valor: ' + mapParametros.get(sIdParam));
		 }
		 
		 //Recorre la lista de ctrl.getRecords()
		 for (sObject objetoPaso : ctrl.getSelected()){
		 	DCTClientsProspectstoAssigned__c objDCTCtePaso = (DCTClientsProspectstoAssigned__c)objetoPaso;
		 	SetIdReg.add(objDCTCtePaso.id);
		 	lDCTClientsProspectstoAssigned.add((DCTClientsProspectstoAssigned__c) objetoPaso);
		 }
		 //Consula los reg
		 for (DCTClientsProspectstoAssigned__c objPaso : [Select id, AssignmentNumber__c From DCTClientsProspectstoAssigned__c Where Id IN :SetIdReg lIMIT 1]){
		 	sIdApproveReject = objPaso.AssignmentNumber__c;		 	
		 }
		 System.debug('EN DCT_AccountAprovedRejectedCtrl sIdApproveReject: ' + sIdApproveReject);		 
		 
    }   

	// performs the keyword search
	public PageReference ActualizaClientes() {
		System.debug('EN DCT_AccountAprovedRejectedCtrl.ActualizaClientes...');
		
		SetErrores = new List<String>();
		
		//Recorre la lista de lDCTClientsProspectstoAssigned y actualizalos
		for (DCTClientsProspectstoAssigned__c objDCTClientsProspectstoAssignedPaso : lDCTClientsProspectstoAssigned){
			lDCTClientsProspectstoAssignedUpd.add(new DCTClientsProspectstoAssigned__c(
					id = objDCTClientsProspectstoAssignedPaso.id,
					Status__c = 'Rechazado' 
				)
			);
		}
		//Despliega los datos 
		System.debug('EN DCT_AccountAprovedRejectedCtrl.ActualizaClientes lDCTClientsProspectstoAssignedUpd: ' + lDCTClientsProspectstoAssignedUpd);
		//Actualiza los datos
		List<Database.Upsertresult> lDtbUpsRes = Database.upsert(lDCTClientsProspectstoAssignedUpd, DCTClientsProspectstoAssigned__c.id, false);
		//Ve si hubo error
		for (Database.Upsertresult objDtbUpsRes : lDtbUpsRes){
			if (!objDtbUpsRes.isSuccess())
				setErrores.add(objDtbUpsRes.getErrors()[0].getMessage());
		}//Fin del for para lDtbUpsRes

		//Regresa solo null
		return null;
	}

	// performs the keyword search
	public PageReference regresar() {
		System.debug('EN DCT_AccountAprovedRejectedCtrl.regresar...');
		//'https://cs18.lightning.force.com/one/one.app#/sObject/a0i11000006Y3KoAAK/rlName/NumeroAsignacion__r/view'				
        PageReference pr = new PageReference('https://cs18.lightning.force.com/' + sIdApproveReject);
        pr.setRedirect(true);
        return pr;
				
	}	

}