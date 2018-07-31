public with sharing class DCT_AprovalProcessDetail_ctrl {
	
	public Map<String, String> mapParam {get;set;}
	public String sIdProcessAproval {get;set;}
	public Boolean bAprovalProcessValid {get;set;} 

	public String sProcessInstanceId;
	public String sTargetObjectId;
	public String sProcessDefinitionId;
	public ProcessDefinition objProcessDefinition {get;set;}
	public Cliente__c DirectorioComercial {get;set;}
	public DCTAssignment__c DctEncabezado {get;set;}
	public List<DCTClientsProspectstoAssigned__c> lDctAccReasig {get;set;}
	public Integer pageNumber {get;set;}
	public Integer totalPages {get;set;}
	
	//Un controlador por default para DCT_AprovalProcessDetail_ctrl
	public DCT_AprovalProcessDetail_ctrl(){
		System.debug('EN DCT_AprovalProcessDetail_ctrl...');
		bAprovalProcessValid = false;
		DirectorioComercial = new Cliente__c();
		DctEncabezado = new DCTAssignment__c();
		lDctAccReasig = new List<DCTClientsProspectstoAssigned__c>();
		objProcessDefinition = new ProcessDefinition();
		pageNumber = 1;
		totalPages = 0;
				
		//Toma la lista de parametros que vienen en la pagina
		mapParam = ApexPages.currentPage().getParameters();
		System.debug('EN DCT_AprovalProcessDetail_ctrl mapParam: ' + mapParam);
		
		//Toma el ID de la lista de parametros
		sIdProcessAproval = mapParam.containsKey('id') ? mapParam.get('id') : null;
		System.debug('EN DCT_AprovalProcessDetail_ctrl sIdProcessAproval: ' + sIdProcessAproval);
				
		//Ve si tiene algo el parametro de sIdProcessAproval
		if (sIdProcessAproval != null){
			ConsultaDatosProceso(sIdProcessAproval);

			System.debug('EN DCT_AprovalProcessDetail_ctrl sTargetObjectId: ' + sTargetObjectId);
			if (sTargetObjectId != null){
				//Ve si se trata de un proceso para reasignar cuentas
				if (sTargetObjectId.startsWith('a0i')){
					bAprovalProcessValid = true;
					
					//Busca el detalle del proceso
					/*for (Cliente__c DirComercialPaso : [Select RFC__c, Name, DCTExtensionValidity__c, DCTRegistrationDate__c,
							OwnerId From Cliente__c Where id =: sTargetObjectId]){
						DirectorioComercial = DirComercialPaso; apex:outputLink
					}*/
					for (DCTAssignment__c encabezado : [Select d.TotalAccountstoApprove__c, d.Status__c, 
						d.PreviousManagement__c, d.Name, d.CreatedById, d.Aprobador__c, d.ApprovedAccounts__c, 
						d.OwnerId From DCTAssignment__c d Where ID =: sTargetObjectId]){
						DctEncabezado = encabezado;
					}
					//Consulta el detalle de las cuentas para el proceso
					for (DCTClientsProspectstoAssigned__c objAccAsign : [Select d.UserReceiver__c, d.Status__c, 
							d.Segmento__c, d.RecordTypeId, d.Name, d.IssuingUser__c, d.DCTPreviousManager__c, 
							d.DCTManager__c, d.AssignmentNumber__c, d.Approval__c, d.AccountName__c 
							From DCTClientsProspectstoAssigned__c d 
							Where d.AssignmentNumber__c =: sTargetObjectId]){
						lDctAccReasig.add(objAccAsign);
						//Obtiene el No de paginas dividiendo entre 10 el tot de reg de la consulta
						Integer iTotPag = lDctAccReasig.size() / 10;
						Integer iResiduo = 0;
						if (iTotPag > 1){
							iResiduo = math.mod(lDctAccReasig.size(), 10);
							totalPages = iTotPag; 
						}else
							totalPages = 1;	
						if (iResiduo > 0)
							iTotPag++;	
						
					}//Fin del for para DCTClientsProspectstoAssigned__c
				}//Fin si sTargetObjectId.startsWith('a0D')
			}//Fin si sTargetObjectId != null
			
		}//Fin si sIdProcessAproval != null
	}
	
	private void ConsultaDatosProceso(String sIdProceso){
		System.debug('EN DCT_AprovalProcessDetail_ctrl.ConsultaDatosProceso sIdProceso: ' + sIdProceso);
						
		//Ve a que tipo de objeto esta asociado el proceso
		for (ProcessInstanceWorkitem objProcInsWorkItm : [Select p.ProcessInstanceId, p.OriginalActorId, p.Id, p.ActorId 
				From ProcessInstanceWorkitem p where ID =: sIdProceso]){
			sProcessInstanceId = objProcInsWorkItm.ProcessInstanceId;
		}
		System.debug('EN DCT_AprovalProcessDetail_ctrl.ConsultaDatosProceso sProcessInstanceId: ' + sProcessInstanceId);
				
		//Consulta los datos del objeto ProcessInstance
		for (ProcessInstance objProcessInstance : [Select p.TargetObjectId, p.Status, p.ProcessDefinitionId, p.Id 
			From ProcessInstance p Where id =: sProcessInstanceId]){
			sTargetObjectId = objProcessInstance.TargetObjectId;
			sProcessDefinitionId = objProcessInstance.ProcessDefinitionId;
		}
		System.debug('EN DCT_AprovalProcessDetail_ctrl.ConsultaDatosProceso sTargetObjectId: ' + sTargetObjectId + ' sProcessDefinitionId: ' + sProcessDefinitionId);
				
		//Consulta el detalle del proceso
		for (ProcessDefinition objProcessDefinitionPaso : [Select p.Type, p.State, p.Name, p.LockType, p.DeveloperName, p.Description 
			From ProcessDefinition p Where id =: sProcessDefinitionId]){
			objProcessDefinition = objProcessDefinitionPaso;
		}
		System.debug('EN DCT_AprovalProcessDetail_ctrl.ConsultaDatosProceso objProcessDefinition: ' + objProcessDefinition);		
		
	}

}