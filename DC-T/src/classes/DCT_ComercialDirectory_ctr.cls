public with sharing class DCT_ComercialDirectory_ctr {
	
	public DCTDirectoryProductRelationship__c       DCTnewProduct {get;set;}
	public List<DCTDirectoryProductRelationship__c> lstDirProd    {get;set;}
	public String                                   idRecord      {get;set;}
	public Boolean                                  blnIsOnclick  {get;set;}
	public Boolean                                  blnIsOnclick2 {get;set;}
	public SObject                                  recordDC      {get;set;}
	public Set<String>                              setIdProdExist{get;set;}
	
	public DCT_ComercialDirectory_ctr(ApexPages.StandardController stdController) {		
		lstDirProd = new List<DCTDirectoryProductRelationship__c>();	
		setIdProdExist = new Set<String>();	
		idRecord = stdController.getid();
		recordDC = stdController.getRecord();
		
		for (DCTDirectoryProductRelationship__c objPaso : [
				SELECT 
					id, 
					DCTCommercialDirectory__c,
					DCTCommercialDirectory__r.RFC__c, 
					DCTCommercialDirectory__r.DCT_LegalPerson__c, 
					DCTCommercialDirectory__r.Name, 
					DCTProduct__c,
					Name
				FROM DCTDirectoryProductRelationship__c 
				WHERE DCTProduct__c =:idRecord 
				And DCTCommercialDirectory__c != null
				ORDER BY Name]){
			System.debug(loggingLevel.Error, '*** Luis: ');
			lstDirProd.add(objPaso);
			setIdProdExist.add(objPaso.DCTCommercialDirectory__c);
		}	
		
		DCTnewProduct = new DCTDirectoryProductRelationship__c(
			DCTProduct__c = stdController.getid()
		);
		blnIsOnclick = false;
	} 

	public PageReference refreshTable(){
		Product2 newClient = new Product2(id = idRecord);
		PageReference pr = new ApexPages.StandardController(newClient).view();  
		pr.setRedirect(true);
		return pr;
	}

	public void saveProduct(){
		System.debug(loggingLevel.Error, '*** DCTnewProduct.DCTCommercialDirectory__c: ' + DCTnewProduct.DCTCommercialDirectory__c);
		if (DCTnewProduct.DCTCommercialDirectory__c == null){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Debes seleccionar almenos un Producto.'));			
			blnIsOnclick2= true;
		}

		if (DCTnewProduct.DCTCommercialDirectory__c != null){
			Product2 productUpd1 = [SELECT DCT_IsSpecialProduct__c FROM Product2 WHERE id = :idRecord];
			
			if(productUpd1.DCT_IsSpecialProduct__c) {
				productUpd1.DCT_IsSpecialProduct__c = false;
			}
			
			Database.SaveResult sr3 = Database.update(productUpd1, true);
			
			if(sr3.isSuccess()) {
				System.debug(loggingLevel.Error, '*** DCTnewProduct.DCTCommercialDirectory__c: ' + DCTnewProduct.DCTCommercialDirectory__c);
				System.debug(loggingLevel.Error, '*** setIdProdExist: ' + setIdProdExist);
				if (setIdProdExist.contains(DCTnewProduct.DCTCommercialDirectory__c))
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'El producto ya esta asociado el cliente.'));										
				if (!setIdProdExist.contains(DCTnewProduct.DCTCommercialDirectory__c)){
					Database.SaveResult sr = Database.insert(DCTnewProduct, true);
					if(sr.isSuccess()){
						for (DCTDirectoryProductRelationship__c objPaso : [
								SELECT id, DCTCommercialDirectory__c,
									DCTCommercialDirectory__r.RFC__c, 
									DCTCommercialDirectory__r.DCT_LegalPerson__c, 
									DCTCommercialDirectory__r.Name, 
									DCTProduct__c,
									Name
								FROM DCTDirectoryProductRelationship__c 
								WHERE id =:sr.getId()  
								ORDER BY Name
							]){
							lstDirProd.add(objPaso);
							setIdProdExist.add(objPaso.DCTCommercialDirectory__c);
						}
						Product2 productUpd = new Product2(
							id = idRecord,
							DCT_IsSpecialProduct__c = true
						);
						Database.SaveResult sr2 = Database.update(productUpd, true);
						if(sr2.isSuccess()) {
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'El producto se asocio correctamente al cliente.'));						
							blnIsOnclick2 = false;
						}	
					}
					if(!sr.isSuccess()){
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error a la hora de asocuiar el cliente con el producto, ERROR:' + sr.getErrors()[0].getMessage()));
						blnIsOnclick2 = true;
					}
				}
			} else {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error a la hora de asocuiar el cliente con el producto, ERROR:' + sr3.getErrors()[0].getMessage()));
				blnIsOnclick2 = true;
			}
		}
	}

	public void watchField2(){
		blnIsOnclick2= true;
	}

}