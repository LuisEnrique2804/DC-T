public with sharing class DCT_ApprovalProcessReassignCtrl {
	
	public ProcessInstanceWorkitem objPasoCtrl {get;set;}
	public String idRecord {get;set;}
    public DCT_ApprovalProcessReassignCtrl(ApexPages.StandardController stdCtr){
        objPasoCtrl = (ProcessInstanceWorkitem)stdCtr.getRecord();
        idRecord = stdCtr.getid();
    }

    public PageReference regresa(){
    	System.debug('EN regresa...');
        ProcessInstanceWorkitem procesoActual = new ProcessInstanceWorkitem(id = idRecord);
        PageReference pr = new ApexPages.StandardController(procesoActual).view();  
        pr.setRedirect(true);
        return pr;	        
    }

}