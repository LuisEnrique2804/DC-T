trigger DCT_Region_tgr on DCTRegion__c (before insert) {
	
	Map<String, Account> mapPctUpd {get;set;}
	Map<String, String> mapIdMetodPagoDesc {get;set;}
	Map<String, String> mapIdNoCteIdSFDC {get;set;}	
	Set<String> setIdCtaPadre {get;set;}
	Map<String, Cliente__c> mapDirComerUpd {get;set;}
	Map<String, String> mapDirComerError {get;set;}
					
	//Si se trata del evento before
	if (Trigger.isAfter){
		//Si se trata de insert
		if (Trigger.isInsert || Trigger.isUpdate){
			
			mapPctUpd = new Map<String, Account>();
			mapIdMetodPagoDesc = new Map<String, String>{'EF' => 'Efectivo', 'TC' => 'Tarjeta de Crédito','CH' => 'Cheque','TD' => 'Tarjeta de Débito','TB' => 'Transferencia Bancaria'};
			mapIdNoCteIdSFDC = new Map<String, String>();
			setIdCtaPadre = new Set<String> ();
			mapDirComerUpd = new Map<String, Cliente__c>();
			mapDirComerError = new Map<String, String>();
			
	        for(DCTRegion__c pct : Trigger.new) {
				System.debug('ERROR EN DCTRegionVal_tgr pct: ' + pct);	        	
	        	//Ve si tiene algo del campo de pct.FatherAccount__c,
	        	if (pct.FatherAccount__c != null)
	        		setIdCtaPadre.add(pct.FatherAccount__c);
	        }//Fin del for para los reg nuevos

	        //Consulta los datos de las cuentas padres
	        for (Account PctCTPadre : [Select ID, Name, DCTCustomerID__c From Account Where DCTCustomerID__c IN : setIdCtaPadre]){
	        	mapIdNoCteIdSFDC.put(PctCTPadre.DCTCustomerID__c, PctCTPadre.id);
	        }
			System.debug('ERROR EN DCTRegionVal_tgr mapIdNoCteIdSFDC: ' + mapIdNoCteIdSFDC);

			//Recorre de nuevo los reg de DCTRegion__c
	        for(DCTRegion__c pct : Trigger.new) {
	        	
        		//Ve si se trata de la region R09 entonces actualiza sus datos 
        		if ( pct.Region__c == 'R09'){
					System.debug('ANTES DE CONSULTAR EL DIR COM: ' + pct.RFC__c + ' ' + pct.LegalEntity__c + ' ' + pct.Region__c);	        			
	        		//Busca el cliente en base a RFC, Razon Social y Region
	        		for (Cliente__c dirComrPaso : [Select ID From Cliente__c Where RFC__c =: pct.RFC__c
	        			And Name =: pct.LegalEntity__c 
	        			//And DCTRegion__c =: pct.Region__c
	        			]){
	        				
	        			//Crea el objeto para el directorio
		        		Cliente__c DirecComer = new Cliente__c(id = dirComrPaso.id);
    	    			DirecComer.DCTAccountType__c = pct.AccountType__c;
    	    			DirecComer.DCTCorrespondenceAddress__c = pct.AddressCorrespondence__c;
    	    			DirecComer.DCTFiscalAddress__c = pct.TaxResidence__c;
    	    			DirecComer.DCTCreditClass__c = pct.CreditClass__c;
    	    			DirecComer.DCTBillingCycle__c = pct.DCTBillingCycle__c;
    	    			DirecComer.DCTEstatusCobranza__c = pct.EstatusCobranza__c;
    	    			DirecComer.DCTExemptBail__c = !pct.ExemptBail__c ? false : true;
    	    			DirecComer.DCTLegalRepresentative__c = pct.LegalRepresentative__c;
    	    			DirecComer.DCTMethodOfPayment__c =	mapIdMetodPagoDesc.containsKey(pct.MethodOfPayment__c)
    	    				? mapIdMetodPagoDesc.get(pct.MethodOfPayment__c) : null; //Validar Catalogo
    	    			DirecComer.Grupo__c = mapIdNoCteIdSFDC.containsKey(pct.FatherAccount__c) 
    	    				? mapIdNoCteIdSFDC.get(pct.FatherAccount__c) : null;
						// pct.NationalAccount__c  es la misma cuenta que se esta validando LegalEntity__c			
						DirecComer.DCTRegion__c = pct.Region__c;
						
						//Toma el campo de la dirección y destripalo para que lo actualices en los campos
						//correspondientes a la dirección del cliente__c
						if (DirecComer.DCTCorrespondenceAddress__c != null && DirecComer.DCTCorrespondenceAddress__c != ''){
							//Ve si contiene comas el texto en DCTCorrespondenceAddress__c
							if  (DirecComer.DCTCorrespondenceAddress__c.contains(',')){
								//String sDirPasoPrueba = 'LAGO ZURICH, 340, AMP. GRANADA, MIGUEL HIDALGO, 11529, CDMX';
								//List<String> lDatosDir = sDirPasoPrueba.split(',');
								List<String> lDatosDir = DirecComer.DCTCorrespondenceAddress__c.split(',');
								//Inicializa los procesos
								DirecComer.DCTFiscalStreet__c = lDatosDir.get(0); //CALLE
								if (lDatosDir.size() > 0){
									String sDCTNoIntFiscal = lDatosDir.get(1) != null ? lDatosDir.get(1) : null;
									if (sDCTNoIntFiscal != null)
										if (sDCTNoIntFiscal.isNumeric())									
											DirecComer.DCTNoIntFiscal__c = lDatosDir.get(1) != null ? Decimal.valueOf(lDatosDir.get(1)) : 0; //NUMEROL
								}//Fin si lDatosDir.size() > 0
								if (lDatosDir.size() > 1)
									DirecComer.DCTNoExtFiscal__c = 0; //COMPLNUM
								if (lDatosDir.size() > 2)
									DirecComer.DCTColonyFiscal__c = lDatosDir.get(2); //COLONIA}									
								if (lDatosDir.size() > 3)
									DirecComer.DCTDelMpiofiscal__c = lDatosDir.get(3); //DELMUN									
								if (lDatosDir.size() > 4)
									DirecComer.DCTCodePostfiscal__c = lDatosDir.get(4);  //CODPOSTAL
								if (lDatosDir.size() > 5)
									DirecComer.FiscalFederalEntity__c = lDatosDir.get(5); //ESTADO
							}//Fin si DirecComer.DCTCorrespondenceAddress__c.contains(',')
						}//Fin si DirecComer.DCTCorrespondenceAddress__c != null && DirecComer.DCTCorrespondenceAddress__c != ''
						
						//Mete los datos al mapa de mapDirComerUpd
						mapDirComerUpd.put(dirComrPaso.id, DirecComer);
	        			
	        		}//Fin del for para la consulta del cliente
        		}//Fin si  pct.Region__c == 'R09'
        	
	        }//Fin del for para Trigger.new

			//Ve si tiene algo mapDirComerUpd
			if (!mapDirComerUpd.isEmpty()){
				Integer iCntReg = 0;
				List<Cliente__c> lCliente = mapDirComerUpd.Values();
				//Actualiza a traves del campo de IdExterno__c
				List<Database.Saveresult> lDtur = Database.update(lCliente, false);
				for (Database.Saveresult objDtur : lDtur){
					if(!objDtur.isSuccess()){
						System.debug('ERROR EN DCTRegionVal_tgr ' + objDtur.getErrors()[0].getMessage());
		        		String sIdExterna = lCliente.get(iCntReg).RFC__c + '-' +  lCliente.get(iCntReg).Name + '-' +  lCliente.get(iCntReg).DCTRegion__c;						
						mapDirComerError.put(sIdExterna, objDtur.getErrors()[0].getMessage());
					}
					iCntReg++;						
				}//Fin del for para lDtur				
			}//Fin si !mapDirComerUpd.isEmpty()

		}//Fin si Trigger.isInsert
	}//Fin si Trigger.isBefore

}