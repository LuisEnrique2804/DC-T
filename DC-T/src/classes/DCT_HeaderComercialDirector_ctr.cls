public class DCT_HeaderComercialDirector_ctr {

	public Cliente__c clienteRecord {get;set;}
	public Boolean bTieneProcesoPendiente {get;set;}
	
	public DCT_HeaderComercialDirector_ctr(ApexPages.StandardController stdController) {
		bTieneProcesoPendiente = false;
		clienteRecord = (Cliente__c)stdController.getRecord();
		
		//Valida si ya tiene un proceso pendiente
		ValidaProceso();
	}
	
	public PageReference ValidaProceso(){
		System.debug('ENTRO A DCT_HeaderComercialDirector_ctr.ValidaProceso...');
		//Ve si ya tiene un proceso de aprovación ese registro.
		for (ProcessInstance proceso : [Select p.TargetObjectId, p.Status, p.ProcessDefinitionId From ProcessInstance p
			where p.TargetObjectId = :clienteRecord.Id And  p.Status = 'Pending']){
			bTieneProcesoPendiente = true;
		}
		System.debug('ENTRO A DCT_HeaderComercialDirector_ctr.ValidaProceso bTieneProcesoPendiente: ' + bTieneProcesoPendiente);
		//Solo null
		return null;
	}
	
	public PageReference submitForApproval(){
		System.debug('ENTRO A DCT_HeaderComercialDirector_ctr.submitForApproval...');
		
		String strErrorMsg = '';   
		System.debug(loggingLevel.Error, '*** 280492: ');
		Boolean blnWasThereAnException = false;
		bTieneProcesoPendiente = false;
		
		try{ 
			//Ve si ya tiene un proceso de aprovación ese registro.
			for (ProcessInstance proceso : [Select p.TargetObjectId, p.Status, p.ProcessDefinitionId From ProcessInstance p
				where p.TargetObjectId = :clienteRecord.Id And  p.Status = 'Pending']){
				bTieneProcesoPendiente = true;
			}
			if (!bTieneProcesoPendiente){
				Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
				req.setObjectId(clienteRecord.Id);
				Approval.ProcessResult result = Approval.process(req);
			}
		} catch(DMLException dE){blnWasThereanException = true; strErrorMsg += dE.getMessage();}catch(UnexpectedException uE){blnWasThereanException = true; strErrorMsg += uE.getMessage();}catch(Exception gE){blnWasThereanException = true; strErrorMsg += gE.getMessage();}       
		System.debug(loggingLevel.Error, '*** strErrorMsg: ' + strErrorMsg);
		return null;
	}
}