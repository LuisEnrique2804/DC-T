public with sharing class DCT_HeaderPendingProcess_ctr {

	public Boolean blnClickBotton {get;set;}
    public Boolean blnClickBottonReject {get;set;}
    public ProcessInstanceStep lstProcessInstance {get;set;}
    public ProcessInstanceWorkitem strProcessInstanceWorkitem {get;set;}
    public Boolean blnNewStatusApprove {set;get;}
    public String strComment {get;set;}
    public string strid{get;set;}
    public List<String> lstErrorMsgs {set;get;}
    public List<String> lstSuccessMsgs {set;get;}
	public Boolean bTipoCambioCuenta {get;set;}
	public Boolean bDctExemptBail {get;set;}
	
    public void initOrCleanUpMsg(){
        lstErrorMsgs = new List<String>();
        lstSuccessMsgs = new List<String>();
    }

    public DCT_HeaderPendingProcess_ctr(ApexPages.StandardController stdController) {
    	System.debug('EN DCT_HeaderPendingProcess_ctr...' );
    	
        blnClickBotton = false;
        lstProcessInstance = new ProcessInstanceStep();
        strProcessInstanceWorkitem = new ProcessInstanceWorkitem();
        bTipoCambioCuenta = false;
        bDctExemptBail = false;
        
        //blnNewStatusApprove = false;
        strid = stdController.getId();
    	System.debug('EN DCT_HeaderPendingProcess_ctr strid: '  + strid);
    	for (ProcessInstanceWorkitem objPIW : [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId, 
    		ActorId, ProcessInstance.ProcessDefinition.Name
    		FROM ProcessInstanceWorkitem WHERE id =: strid Limit 1]){
    		strProcessInstanceWorkitem = objPIW;
    		System.debug('EN DCT_HeaderPendingProcess_ctr ProcessInstance.ProcessDefinition.Name: ' + objPIW.ProcessInstance.ProcessDefinition.Name );    		
    	}
    	for (ProcessInstanceStep objPIS : [ SELECT Id, StepStatus, Comments, ProcessInstance.Status 
    		FROM ProcessInstanceStep WHERE ProcessInstanceId =: strProcessInstanceWorkitem.ProcessInstanceId Limit 1]){
    		lstProcessInstance = objPIS;
    	}
        System.debug(loggingLevel.Error, '*** lstProcessInstance: ' + lstProcessInstance);
        initOrCleanUpMsg();
    }

    public void changeStatusToApprove(){
        blnClickBotton = true;
        blnClickBottonReject = false;
        System.debug(loggingLevel.Error, '*** blnClickBotton: ' + blnClickBotton);
    }    

    public void changeStatusToReject(){
        blnClickBotton = false;
        blnClickBottonReject = true;
        System.debug(loggingLevel.Error, '*** blnClickBotton: ' + blnClickBotton);
    }    

    public void changeToApprove(){
        System.debug(loggingLevel.Error, '*** EN changeToApprove strComment: ' + strComment);
        System.debug(loggingLevel.Error, '*** EN changeToApprove TargetObjectId: ' + strProcessInstanceWorkitem.ProcessInstance.TargetObjectId);

    	//Ve si se trata de un proceso del tipo DCT Cambio Tipo de Cuenta a CO
    	if (strProcessInstanceWorkitem.ProcessInstance.ProcessDefinition.Name == 'DCT Cambio Tipo de Cuenta a CO')
    		bTipoCambioCuenta = true;
	    System.debug(loggingLevel.Error, '*** EN changeToReject bTipoCambioCuenta: ' + bTipoCambioCuenta);
                
        String sIdDirCom = strProcessInstanceWorkitem.ProcessInstance.TargetObjectId;
        Cliente__c DirCom;
       	if (sIdDirCom.startsWith('a0D')){
       		DirCom = new Cliente__c();
       		for (Cliente__c DirComCons : [Select Name, DCTExemptBail__c 
       			From Cliente__c Where ID =: sIdDirCom]){
       			DirCom = DirComCons;
       			if (DirComCons.DCTExemptBail__c)
       				bDctExemptBail = true;
	    		System.debug(loggingLevel.Error, '*** EN changeToApprove DirComCons: ' + DirComCons);       			
       		}
       	}//Fin si sIdDirCom.startsWith('a0D')
        
        //Toma los comentarios y ponlos en el objeto de paso DCT_ComentariosProceso__c
        DCT_ComentariosProceso__c objDCTComentariosProcesoUps = new DCT_ComentariosProceso__c(
        	DCT_IdRegProcesoAproba__c = strProcessInstanceWorkitem.ProcessInstance.TargetObjectId,
        	Name = DirCom != null ? DirCom.Name : strProcessInstanceWorkitem.ProcessInstance.TargetObjectId,
        	DCT_Comentario__c = strComment != null ? strComment : null
        );
	    System.debug(loggingLevel.Error, '*** EN changeToApprove objDCTComentariosProcesoUps: ' + objDCTComentariosProcesoUps);        
        //Actualiza el reg de  objDCTComentariosProcesoUps
        upsert objDCTComentariosProcesoUps DCT_ComentariosProceso__c.DCT_IdRegProcesoAproba__c;
	    System.debug(loggingLevel.Error, '*** EN changeToApprove objDCTComentariosProcesoUps2: ' + objDCTComentariosProcesoUps);
	            
        //Crea el objeto del tipo Approval.ProcessWorkitemRequest
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setWorkitemId(strProcessInstanceWorkitem.id);//
        System.debug(loggingLevel.Error, '*** La lista contiene estatus Aprobado: ');
        req2.setComments(strComment);
        req2.setAction('Approve');
        System.debug(loggingLevel.Error, '*** req2.getComments(): ' + req2.getComments());
        System.debug(loggingLevel.Error, '*** req2: ' + req2);
		
		//Actualiza el proceso de aprobación
        //DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
        Approval.ProcessResult result2 =  Approval.process(req2);
        System.debug(loggingLevel.Error, '*** result2.isSuccess(): ' + result2.isSuccess());
        if(result2.isSuccess()) {
            lstSuccessMsgs.add('Su Proceso ha sido aprobado con exito.');
            lstProcessInstance = [ SELECT Id, StepStatus, Comments, ProcessInstance.Status FROM ProcessInstanceStep WHERE ProcessInstanceId =: strProcessInstanceWorkitem.ProcessInstanceId AND StepStatus = 'Approved' Limit 1];
        }
		
		/*//Si excenta fianza        
       	if (bDctExemptBail){//Si tiene que mandar a aprobar la fianza
            DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');	
			Cliente__c ClienteUpd = new Cliente__c(id = sIdDirCom, DCTCommentsInvestigation__c = strComment != null ? strComment : null);
		    System.debug(loggingLevel.Error, '*** EN changeToReject ClienteUpd1: ' + ClienteUpd);
			DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');		    		
			//update ClienteUpd;       		
       	}*/
        
    }

    public void changeToReject(){
    	
	    System.debug(loggingLevel.Error, '*** EN changeToReject strComment: ' + strComment);
        System.debug(loggingLevel.Error, '*** EN changeToReject TargetObjectId: ' + strProcessInstanceWorkitem.ProcessInstance.TargetObjectId);

    	//Ve si se trata de un proceso del tipo DCT Cambio Tipo de Cuenta a CO
    	if (strProcessInstanceWorkitem.ProcessInstance.ProcessDefinition.Name == 'DCT Cambio Tipo de Cuenta a CO')
    		bTipoCambioCuenta = true;
	    System.debug(loggingLevel.Error, '*** EN changeToReject bTipoCambioCuenta: ' + bTipoCambioCuenta);

        String sIdDirCom = strProcessInstanceWorkitem.ProcessInstance.TargetObjectId;	            
        Cliente__c DirCom;
       	if (sIdDirCom.startsWith('a0D')){
       		DirCom = new Cliente__c();
       		for (Cliente__c DirComCons : [Select id, Name, DCTExemptBail__c From Cliente__c Where ID =: sIdDirCom]){
       			DirCom = DirComCons;
       			if (DirComCons.DCTExemptBail__c)
       				bDctExemptBail = true;
	    		System.debug(loggingLevel.Error, '*** EN changeToReject DirComCons: ' + DirComCons);       					       			
       		}
       	}
	    System.debug(loggingLevel.Error, '*** EN changeToReject bDctExemptBail: ' + bDctExemptBail);
	           	
        //Toma los comentarios y ponlos en el objeto de paso DCT_ComentariosProceso__c
        DCT_ComentariosProceso__c objDCTComentariosProcesoUps = new DCT_ComentariosProceso__c(
        	DCT_IdRegProcesoAproba__c = strProcessInstanceWorkitem.ProcessInstance.TargetObjectId,
        	Name = DirCom != null ? DirCom.Name : strProcessInstanceWorkitem.ProcessInstance.TargetObjectId,
        	DCT_Comentario__c = strComment != null ? strComment : null
        );
	    System.debug(loggingLevel.Error, '*** EN changeToReject objDCTComentariosProcesoUps: ' + objDCTComentariosProcesoUps);
        //Actualiza el reg de  objDCTComentariosProcesoUps
        upsert objDCTComentariosProcesoUps DCT_ComentariosProceso__c.DCT_IdRegProcesoAproba__c;		
	    
        //Crea el objeto del tipo Approval.ProcessWorkitemRequest
	    Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
	    req2.setWorkitemId(strProcessInstanceWorkitem.id);//
	    System.debug(loggingLevel.Error, '*** La lista contiene estatus Aprobado: ');
	    req2.setComments(strComment);
	    req2.setAction('Reject');
	    System.debug(loggingLevel.Error, '*** req2.getComments(): ' + req2.getComments());
	    System.debug(loggingLevel.Error, '*** req2: ' + req2);

		//Actualiza el proceso de aprobación	    
        DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
        Approval.ProcessResult result2 =  Approval.process(req2);
        System.debug(loggingLevel.Error, '*** result2.isSuccess(): ' + result2.isSuccess());
        if(result2.isSuccess()) {
            lstSuccessMsgs.add('Su Proceso ha sido rechazado con exito.');
            lstProcessInstance = [ SELECT Id, StepStatus, Comments, ProcessInstance.Status FROM ProcessInstanceStep WHERE ProcessInstanceId =: strProcessInstanceWorkitem.ProcessInstanceId AND StepStatus = 'Rejected' Limit 1];
        }
        System.debug(loggingLevel.Error, '*** sIdDirCom: ' + sIdDirCom);
        
		//Actualiza el dir asociado el cliente y ponle los comentarios
       	if (sIdDirCom.startsWith('a0D') && !procesoPendiente(sIdDirCom)){	
            DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');	
			Cliente__c ClienteUpd = new Cliente__c(id = sIdDirCom, DCTCommentsInvestigation__c = strComment != null ? strComment : null);
		    System.debug(loggingLevel.Error, '*** EN changeToReject ClienteUpd1: ' + ClienteUpd);
			DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');		    		
			update ClienteUpd;
       	}
       	
		/*//Si excenta fianza
       	if (bDctExemptBail){//Si tiene que mandar a aprobar la fianza
            DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');	
			Cliente__c ClienteUpd = new Cliente__c(id = sIdDirCom, DCTCommentsInvestigation__c = strComment != null ? strComment : null);
		    System.debug(loggingLevel.Error, '*** EN changeToReject ClienteUpd1: ' + ClienteUpd);
			DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
       	}*/
        
    }

    @future(callout=true) 
	public static void ActualizaDirectorio(String sIdDir){
		System.debug('ENTRO A DCT_HeaderPendingProcess_ctr.ActualizaDirectorio: ' + sIdDir);
		Cliente__c ClienteUpd = new Cliente__c(id = sIdDir, DCTExemptBail__c = true);
	    System.debug(loggingLevel.Error, '*** EN DCT_HeaderPendingProcess_ctr.ActualizaDirectorio cuando excenta fianza: ' + ClienteUpd);
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');		    		
		update ClienteUpd;
	}	

	public Boolean procesoPendiente(String sIdReg){
		System.debug('EN DCT_InvestigacionesCtrl.procesoPendiente...');

		Boolean bProcesoPendiente = false;
		//Ve si tiene un proceso pendiente este reg
		for (ProcessInstance objProcessInstance : [Select p.Status, p.ProcessDefinitionId, 
			p.ProcessDefinition.LockType From ProcessInstance p Where p.TargetObjectId =: sIdReg
			And (p.Status ='Pending' OR p.Status ='Rejected') Order by LastModifiedDate DESC
			LIMIT 1]){
			System.debug(loggingLevel.Error, '*** objProcessInstance: ' + objProcessInstance);
            System.debug('EN DCT_InvestigacionesCtrl.procesoPendiente Status: ' + objProcessInstance.Status + ' LockType: ' + objProcessInstance.ProcessDefinition.LockType);
			//Ve si tiene un proceso rejected y sigue bloqueado
			if (objProcessInstance.Status == 'Pending') 
				bProcesoPendiente = true;
			else if (objProcessInstance.Status == 'Rejected' && objProcessInstance.ProcessDefinition.LockType != 'none') 
				bProcesoPendiente = true;
		}
		
		System.debug('EN DCT_InvestigacionesCtrl.procesoPendiente bProcesoPendiente: ' + bProcesoPendiente);		
		return bProcesoPendiente;
	}

    public PageReference regresar() {
        System.debug(loggingLevel.Error, 'https://telcel-dev--dc.lightning.force.com/lightning/page/home');
        //'https://telcel-dev--dc.lightning.force.com/lightning/r/DCTAssignment__c'  https://telcel-dev--dc.lightning.force.com/                
        PageReference pr = new PageReference('https://telcel-dev--dc.lightning.force.com/lightning/r/ProcessInstanceStep/'+lstProcessInstance.id+'/view');
        System.debug(loggingLevel.Error, '*** pr: ' + pr);
        pr.setRedirect(true);
        return pr;
    }
    
}