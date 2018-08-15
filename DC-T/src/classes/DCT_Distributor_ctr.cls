public class DCT_Distributor_ctr {
	public String strName {get;set;}
	public List<SelectOption> options {set;get;}
	public id idObject {set;get;}
	public DCT_Distributor_ctr(ApexPages.StandardController stdCtrl){
		idObject = stdCtrl.getId();
	}


	public void ActualizaDistribuidoresWs() {
		List<DCTSalesForceCatalog__c> lstCatalgFuerzaVta = new List<DCTSalesForceCatalog__c>();
		DCT_CatalogoFuerzasVenta_rst.classRespuestaTelcelTodo respService =  DCT_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVenta();
		List<SelectOption> options = new List<SelectOption>();
		System.debug(loggingLevel.Error, '*** respService: ' + respService);
		//System.debug(loggingLevel.Error, '*** respService.FuerzaVentaDistribuidor.size(): ' + respService.FuerzaVentaDistribuidor.size());
		if(respService.FuerzaVentaDistribuidor.size()>0) {
			for(DCT_CatalogoFuerzasVenta_rst.listaFuerzaVentaDistTodo iterator: respService.FuerzaVentaDistribuidor) {
				DCTSalesForceCatalog__c catalgFuerzaVta = new DCTSalesForceCatalog__c(
					Name = iterator.Clave,
					DCTCode__c = iterator.RazonSocial
				);
				lstCatalgFuerzaVta.add(catalgFuerzaVta);
			}
			System.debug(loggingLevel.Error, '*** lstCatalgFuerzaVta.size(): ' + lstCatalgFuerzaVta.size());
			SObjectField f = DCTSalesForceCatalog__c.Field.DCTCode__c;
			//if(lstCatalgFuerzaVta.size()>0) {
			//	for(DCTSalesForceCatalog__c iterator: lstCatalgFuerzaVta) {
			//		options.add(new SelectOption(iterator.Name,iterator.DCTCode__c));
			//	}
			//	System.debug(loggingLevel.Error, '*** options: ' + options);
			//}
			List<Database.UpsertResult> uR = Database.upsert(lstCatalgFuerzaVta, f, true);
		//}else {
		//	lstCatalgFuerzaVta = [SELECT Name, DCTCode__c FROM DCTSalesForceCatalog__c];
		//	if(lstCatalgFuerzaVta.size()>0) {
		//		for(DCTSalesForceCatalog__c iterator: lstCatalgFuerzaVta) {
		//			options.add(new SelectOption(iterator.Name,iterator.DCTCode__c));
		//		}
		//		System.debug(loggingLevel.Error, '*** options: ' + options);
		//	}
		}
	}

	//String[] FzaVenta = new String[]{};
        //If multiselect is false, FzaVenta must be of type String
    String FzaVenta;
            

        
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
    	List<DCTSalesForceCatalog__c> lstCatalgFuerzaVta = [SELECT Name, DCTCode__c FROM DCTSalesForceCatalog__c];
    	if(lstCatalgFuerzaVta.size()>0) {
    		for(DCTSalesForceCatalog__c iterator: lstCatalgFuerzaVta) {
        		options.add(new SelectOption(iterator.DCTCode__c,iterator.DCTCode__c));
    		}
    	}
        return options;
    }
        
    public String getFzaVenta() {
        //If multiselect is false, FzaVenta must be of type String
        return FzaVenta;
    }
        
    public void setFzaVenta(String FzaVenta) {
        //If multiselect is false, FzaVenta must be of type String
        this.FzaVenta = FzaVenta;
    }

    public void fuerzaVentaChange(){
    	System.debug(loggingLevel.Error, '*** Lo estas haciendo bien: ');
    	System.debug(loggingLevel.Error, '*** FzaVenta: ' + FzaVenta);
    	String lstSalesCalaog = [SELECT Name, DCTCode__c FROM DCTSalesForceCatalog__c WHERE DCTCode__c = :FzaVenta LIMIT 1].Name;
    	System.debug(loggingLevel.Error, '*** lstSalesCalaog: ' + lstSalesCalaog);
    	Cliente__c clienteProcedure = new Cliente__c(
    		id = idObject,
    		DCTPowerSales__c = FzaVenta,
    		DCTDistributor1__c = lstSalesCalaog
    	);
    	System.debug(loggingLevel.Error, '*** clienteProcedure: ' + clienteProcedure);
    	Database.SaveResult sr = Database.update(clienteProcedure, true);
    }
}