public class DCT_AccountAproved_ctr {
	public String sIdApproveReject {get;set;}
	public List<DCTClientsProspectstoAssigned__c> lDCTClientsProspectstoAssigned {get;set;}
	//Prueba conceptual posible eliminacion de linea siguiente
	public List<DCTClientsProspectstoAssigned__c> lDCTClientsProspectstoAssignedRej {get;set;}
	public List<DCTClientsProspectstoAssigned__c> lDCTClientsProspectstoAssignedUpd {get;set;}
	public Map<String, String> mapParametros {get;set;}
	public List<String> SetErrores {get;set;}
	public Set<String> SetIdReg {get;set;}

	public void AccountAproved() {
		//Inicializa 
		List<DCTClientsProspectstoAssigned__c> accountList = [SELECT id, Status__c FROM DCTClientsProspectstoAssigned__c];
		ApexPages.StandardSetController ctrl = new ApexPages.StandardSetController(accountList);
		 lDCTClientsProspectstoAssigned = new List<DCTClientsProspectstoAssigned__c>();
		 lDCTClientsProspectstoAssignedRej = new List<DCTClientsProspectstoAssigned__c>();
		 lDCTClientsProspectstoAssignedUpd = new List<DCTClientsProspectstoAssigned__c>();
		 mapParametros = new Map<String, String>();
		 SetIdReg = new Set<String>();
		 
		 //Toma los parametros
		 //mapParametros = ApexPages.currentPage().getParameters().get('ApproveReject');
		 mapParametros = ApexPages.currentPage().getParameters();		 
		 
		 //Recorre la lista de ctrl.getRecords()
		 for (sObject objetoPaso : ctrl.getSelected()){
		 	DCTClientsProspectstoAssigned__c objDCTCtePaso = (DCTClientsProspectstoAssigned__c)objetoPaso;
		 	SetIdReg.add(objDCTCtePaso.id);
		 	lDCTClientsProspectstoAssigned.add((DCTClientsProspectstoAssigned__c) objetoPaso);
		 }
		 //Prueba conceptual posible eliminacion de lineas 
		 System.debug(loggingLevel.Error, '*** ctrl.getRecords(): ' + ctrl.getRecords());
		 System.debug(loggingLevel.Error, '*** ctrl.getRecord(): ' + ctrl.getRecord());
		 for(sObject sObj: ctrl.getRecords()) {
		 	System.debug(loggingLevel.Error, '*** (DCTClientsProspectstoAssigned__c) sObj: ' + (DCTClientsProspectstoAssigned__c) sObj);
		 	System.debug(loggingLevel.Error, '*** lDCTClientsProspectstoAssigned.contains((DCTClientsProspectstoAssigned__c) sObj): ' + lDCTClientsProspectstoAssigned.contains((DCTClientsProspectstoAssigned__c) sObj));
		 	if(!lDCTClientsProspectstoAssigned.contains((DCTClientsProspectstoAssigned__c) sObj)) {
		 		lDCTClientsProspectstoAssignedRej.add((DCTClientsProspectstoAssigned__c) sObj);
		 	}
		 }

		 //Consula los reg
		 for (DCTClientsProspectstoAssigned__c objPaso : [Select id, AssignmentNumber__c From DCTClientsProspectstoAssigned__c Where Id IN :SetIdReg lIMIT 1]){
		 	sIdApproveReject = objPaso.AssignmentNumber__c;		 	
		 }

		 ActualizaClientes();
	}

	// performs the keyword search
	public PageReference ActualizaClientes() {
		
		SetErrores = new List<String>();
		
		//Recorre la lista de lDCTClientsProspectstoAssigned y actualizalos
		for (DCTClientsProspectstoAssigned__c objDCTClientsProspectstoAssignedPaso : lDCTClientsProspectstoAssigned){
			lDCTClientsProspectstoAssignedUpd.add(new DCTClientsProspectstoAssigned__c(
					id = objDCTClientsProspectstoAssignedPaso.id,
					Status__c = 'Aprobado' 
				)
			);
		}
		//Prueba conceptual posible eliminacion de lineas 
		System.debug(loggingLevel.Error, '*** lDCTClientsProspectstoAssignedRej.size(): ' + lDCTClientsProspectstoAssignedRej);
		if(!lDCTClientsProspectstoAssignedRej.isEmpty()) {	
			for (DCTClientsProspectstoAssigned__c objDCTClientsProspectstoAssignedPaso : lDCTClientsProspectstoAssignedRej){
				lDCTClientsProspectstoAssignedUpd.add(new DCTClientsProspectstoAssigned__c(
						id = objDCTClientsProspectstoAssignedPaso.id,
						Status__c = 'Rechazado' 
					)
				);
			}
			}	

		//Despliega los datos 
		System.debug('***lDCTClientsProspectstoAssignedUpd: ' + lDCTClientsProspectstoAssignedUpd);
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
		//'https://cs18.lightning.force.com/one/one.app#/sObject/a0i11000006Y3KoAAK/rlName/NumeroAsignacion__r/view'				
        PageReference pr = new PageReference('https://cs18.lightning.force.com/' + sIdApproveReject);
        pr.setRedirect(true);
        return pr;
				
	}	
}