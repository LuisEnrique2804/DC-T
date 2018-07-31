public class DCT_NewLeadFromCustomAccount_ctr {
	
	public DCT_NewLeadFromCustomAccount_ctr(ApexPages.StandardController stdCtrl) {
	}

	public PageReference goToNewLeadCreationPage(){
		PageReference pr = new PageReference('/apex/DCT_NewCustomLead_pag');
		pr.setRedirect(true);
		return pr;
	}

}