trigger DCT_Region_tgr on DCTRegion__c (before insert) {
	
	/*Map<String, Account> mapPctUpd {get;set;}
	
	//Si se trata del evento before
	if (Trigger.isBefore){
		//Si se trata de insert
		if (Trigger.isInsert){
			
			mapPctUpd = new Map<String, Account>();
	        for(DCTRegion__c pct : Trigger.new) {
	        	//Ve si el canpo de Name esta vacio y concatena el resto de los campos
	        	if (pct.Name ==  NULL)
	        		pct.Name = pct.DCT_Name__c + ' ' + (pct.DCT_LastName__c == null ? '' : pct.DCT_LastName__c) + '' + (pct.DCT_MotherLastName__c == null ? '' : pct.DCT_MotherLastName__c);
				//Ve si no tiene nada el RFC
				if (pct.RFC__c == null)
					pct.RFC__c.addError('EL Campo del RFC es obligatorio.');
				
				//Si tiene algo el campo Name y RFC__c
				if(pct.Name !=  NULL && pct.RFC__c != null){
					System.debug('EN DCTRegion__c.beforeInsert Name: ' + pct.Name + ' RFC__c: ' + pct.RFC__c);				
					for (Account pctExis : [Select ID, Name, TipoCliente__c From Account Where RFC__c = :pct.RFC__c AND Name =:pct.Name  ]){
						pct.Name.addError('EL cliente con el nombre: ' + pct.Name + ' y el RFC: ' + pct.RFC__c + ' ya existe en el PCT.');				
					}
				}//Fin si pct.Name !=  NULL && pct.RFC__c != null
				System.debug('EN DCTRegion__c.beforeInsert...');
	        }
			
		}//Fin si Trigger.isInsert
	}//Fin si Trigger.isBefore*/

}