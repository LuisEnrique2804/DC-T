trigger DCTClienteUnicoPaso_tgr on DCTClienteUnicoPaso__c (before insert) {

    String VaRtCteCautivo = Schema.SObjectType.Cliente__c.getRecordTypeInfosByName().get('Cliente Cautivo').getRecordTypeId();
	Map<String, Account> mapPctUpd {get;set;}
	Map<String, Cliente__c> mapDirUpdRt {get;set;}	
		
	//Si se trata del evento before
	if (Trigger.isBefore){
		//Si se trata de insert
		if (Trigger.isInsert){

			mapPctUpd = new Map<String, Account>();
			mapDirUpdRt = new Map<String, Cliente__c>();
						
			//Recorre la lista de registros de DCTClienteUnicoPaso__c
	        for(DCTClienteUnicoPaso__c pct : Trigger.new) {
				System.debug('EN DCTClienteUnicoPaso__c.beforeInsert Name: ' + pct.Name + ' pct: ' + pct);	        	
	        	//Ve si el canpo de Name esta vacio y concatena el resto de los campos
	        	if (pct.Name ==  NULL)
	        		pct.Name = pct.DCT_Name__c + ' ' + (pct.DCT_LastName__c == null ? ' ' : pct.DCT_LastName__c) + '' + (pct.DCT_MotherLastName__c == null ? ' ' : pct.DCT_MotherLastName__c);
				//Ve si no tiene nada el RFC
				if (pct.DCT_RFC__c == null)
					pct.DCT_RFC__c.addError('EL Campo del RFC es obligatorio.');
				
				//Si tiene algo el campo Name y DCT_RFC__c
				if(pct.Name !=  NULL && pct.DCT_RFC__c != null){
					Boolean bExiste = false;
					System.debug('EN DCTClienteUnicoPaso__c.beforeInsert Name: ' + pct.Name + ' DCT_RFC__c: ' + pct.DCT_RFC__c);				
					for (Account pctExis : [Select ID, Name, TipoCliente__c From Account Where RFC__c = :pct.DCT_RFC__c 
						//AND Name =:pct.Name
						]){
						bExiste = true;			
						mapPctUpd.put(pctExis.id, new Account(
								id = pctExis.id,
								TipoCliente__c = 'Cliente Cautivo'
							)
						);
					}
					if (!bExiste)
						pct.Name.addError('EL cliente con el nombre: ' + pct.Name + ' y el RFC: ' + pct.DCT_RFC__c + ' no existe en el PCT.');
					//Ve si existe ese cliente en PCT	
					if (bExiste){
						List<Database.Saveresult> lObjDbur = DataBase.update(mapPctUpd.values());
						for (Database.Saveresult objDbur : lObjDbur){
							if (!objDbur.isSuccess())
								pct.Name.addError('Error al actualizar el PCT: ' + pct.Name + ' ERROR: ' + objDbur.getErrors()[0].getMessage());
						}
						
						//Busca el reg del cliente dir comercial
						for (Cliente__c dircom : [Select id From Cliente__c Where RFC__c =:pct.DCT_RFC__c]){
							mapDirUpdRt.put(dircom.id, new Cliente__c(
									id = dircom.id,
									RecordTypeId = VaRtCteCautivo
								)
							);
						}

						List<Database.Saveresult> lObjDburDc = DataBase.update(mapDirUpdRt.values());
						for (Database.Saveresult objDbur : lObjDburDc){
							if (!objDbur.isSuccess())
								pct.Name.addError('Error al actualizar el Dir. Com.: ' + pct.Name + ' ERROR: ' + objDbur.getErrors()[0].getMessage());
						}

					}//Fin si bExiste
				}//Fin si pct.Name !=  NULL && pct.DCT_RFC__c != null
				System.debug('EN DCTClienteUnicoPaso__c.beforeInsert...');
	        }//Fin del for para Trigger.new
		}//Fin si Trigger.isInsert
	}//Fin si Trigger.isBefore

}