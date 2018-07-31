public with sharing class DCT_ComercialDirectory_ctr {

	public DCTDirectoryProductRelationship__c       DCTnewProduct {get; set;}
	public List<DCTDirectoryProductRelationship__c> lstDirProd    {get; set;}
	public List<DCTAuthorizedLines__c>              lstDCTPlan    {get; set;}
	public String                                   idRecord      {get; set;}
	public Boolean                                  blnIsOnclick  {get; set;}
	public Boolean                                  blnIsOnclick2 {get; set;}
	public SObject                                  recordDC      {get; set;}
	public Set<String> setIdProdExist {get;set;}

	public DCT_ComercialDirectory_ctr(ApexPages.StandardController stdController) {
		System.debug('EN EL CONSTRUCTOR DE DCT_ComercialDirectory_ctr...');
		
		lstDirProd = new List<DCTDirectoryProductRelationship__c>();	
		setIdProdExist = new Set<String>();
		
		idRecord = stdController.getid();
		recordDC = stdController.getRecord();
		for (DCTDirectoryProductRelationship__c objPaso : [
				SELECT id, DCTCommercialDirectory__c,
					DCTCommercialDirectory__r.RFC__c, 
					DCTCommercialDirectory__r.DCT_LegalPerson__c, 
					DCTCommercialDirectory__r.Name, 
					DCTProduct__c,
					Name
				FROM DCTDirectoryProductRelationship__c 
				WHERE DCTProduct__c =:idRecord And DCTCommercialDirectory__c != null
				ORDER BY Name
			]){
			//Agrega los reg a lstDirProd
			lstDirProd.add(objPaso);
			setIdProdExist.add(objPaso.DCTCommercialDirectory__c);
		}
		System.debug('EN EL CONSTRUCTOR DE DCT_ComercialDirectory_ctr lstDirProd: ' + lstDirProd);	
		System.debug('EN EL CONSTRUCTOR DE DCT_ComercialDirectory_ctr setIdProdExist: ' + setIdProdExist);		
		System.debug('lstDirProd: ' + lstDirProd);
		
		DCTnewProduct = new DCTDirectoryProductRelationship__c(
			DCTProduct__c = stdController.getid()
		);
		System.debug(loggingLevel.Error, '*** Control: ');
		blnIsOnclick = false;
	} 

	public PageReference refreshTable(){
		System.debug('EN DCT_ComercialDirectory_ctr.refreshTable');
		Product2 newClient = new Product2(id = idRecord);
		PageReference pr = new ApexPages.StandardController(newClient).view();  
		pr.setRedirect(true);
		System.debug(loggingLevel.Error, '*** pr: ' + pr);
		return pr;
	}
	
	public void saveProduct(){
		
		System.debug('EN DCT_ComercialDirectory_ctr.saveProduct...' + DCTnewProduct);
		if (DCTnewProduct.DCTCommercialDirectory__c == null){
			System.debug('EN DCT_ComercialDirectory_ctr.saveProduct GENERANDO EL ERROR.');			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Debes seleccionar almenos un Producto.'));			
			blnIsOnclick2= true;
		}//Fin si DCTnewProduct.DCTCommercialDirectory__c == null		
		//Ve si asocio el producto como debe ser
		if (DCTnewProduct.DCTCommercialDirectory__c != null){
			
			Product2 productUpd1 = [SELECT DCT_IsSpecialProduct__c FROM Product2 WHERE id = :idRecord];
			System.debug(loggingLevel.Error, '*** productUpd1.DCT_IsSpecialProduct__c: ' + productUpd1.DCT_IsSpecialProduct__c);
			if(productUpd1.DCT_IsSpecialProduct__c) {
				productUpd1.DCT_IsSpecialProduct__c = false;
			}
			System.debug(loggingLevel.Error, '*** productUpd1.DCT_IsSpecialProduct__c: ' + productUpd1.DCT_IsSpecialProduct__c);
			Database.SaveResult sr3 = Database.update(productUpd1, true);
			System.debug(loggingLevel.Error, '*** sr3: ' + sr3);
			if(sr3.isSuccess()) {
				System.debug('EN DCT_ComercialDirectory_ctr.saveProduct INSERTANDO EL PRODUCTO: ' + DCTnewProduct);
				//Ve si ya esta asociado al cliente este producto
				if (setIdProdExist.contains(DCTnewProduct.DCTCommercialDirectory__c))
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'El producto ya esta asociado el cliente.'));										
				//Busca el producot en setIdProdExist
				if (!setIdProdExist.contains(DCTnewProduct.DCTCommercialDirectory__c)){
					Database.SaveResult sr = Database.insert(DCTnewProduct, true);
					if(sr.isSuccess()){
						//Agrega el producto a la lista
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
							//Agrega los reg a lstDirProd
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
					}//Fin si sr.isSuccess()
					if(!sr.isSuccess()){
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error a la hora de asocuiar el cliente con el producto, ERROR:' + sr.getErrors()[0].getMessage()));
						blnIsOnclick2 = true;
					}//Fin si !sr.isSuccess()
				}//!setIdProdExist.contains(DCTnewProduct.DCTCommercialDirectory__c)
			} else {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error a la hora de asocuiar el cliente con el producto, ERROR:' + sr3.getErrors()[0].getMessage()));
				blnIsOnclick2 = true;
			}

		}//Fin si DCTnewProduct.DCTCommercialDirectory__c !== null
	}

	public void watchField2(){
		System.debug(loggingLevel.Error, '*** Paso 1: ');
		blnIsOnclick2= true;
		System.debug(loggingLevel.Error, '*** Paso 2: ');
	}
}