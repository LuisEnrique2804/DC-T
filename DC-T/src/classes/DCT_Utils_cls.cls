public with sharing class DCT_Utils_cls {  
 	
 	public static Map<String, EndpointSetting__mdt> mapEndpointSettingMdt = getEndpointSettingMdt();
 	public static respuestaTelcel objRespRefRap {get;set;}
	public static String sNoLineasAprobadas {get;set;}
	public static DCT_FolioSAP_ws.respSalesforce objRespSalesforce {get;set;}
	
	public class respuestaTelcel{
		public referenciaWSRap referenciaWSRap {get;set;}
	}
	
	public class referenciaWSRap{
		public Integer idEstatus {get;set;}		
		public String nombreCliente {get;set;}		
		public String referencia {get;set;}
		public String rfc {get;set;}
		public String Message {get;set;}		
		public String MessageDetail {get;set;}
		public String descEstatus {get;set;}
	}
 	 	
 	public class DtRespuestaTelcel{
 		public String access_token {get;set;}
 		public String token_type {get;set;} 		
 		public Integer expires_in {get;set;}
 		public String error {get;set;} 		
		public String error_description {get;set;} 		 		
 	}
    
    //Crea el metodo de Login para Telcel
    public static DtRespuestaTelcel LoginTelcel(){
    	DtRespuestaTelcel objDtRespuestaTelcel = new DtRespuestaTelcel();
    	    	
    	//Toma los datos para los parametros de la conexion a Telcel del mapa de mapEndpointSettingMdt
    	EndpointSetting__mdt objEndpointSettingMdt = mapEndpointSettingMdt.get('Login');
		
		try{
    	
			//Una prueba utilzando HTTP 
			HttpRequest request = new HttpRequest();
			request.setMethod(objEndpointSettingMdt.ServiceMethod__c); //'POST'
			request.setHeader('Content-Type', objEndpointSettingMdt.RequestBodyType__c); //'application/x-www-form-urlencoded' 
			request.setHeader('Host', objEndpointSettingMdt.ServiceProvider__c);
			request.setHeader('Cache-Control', 'no-cache');  			
			request.setEndpoint(objEndpointSettingMdt.Endpoint__c);
			request.setTimeout(120000);
						
			//JSONBody = EncodingUtil.urlEncode(JSONBody, 'UTF-8');
			String JSONBody = 'grant_type=' + objEndpointSettingMdt.grant_type__c + '&client_id=' + objEndpointSettingMdt.client_id__c + '&client_secret=' + objEndpointSettingMdt.client_secret__c;
			//Incializa el Body con JSONBody						
			request.setBody(JSONBody);
										
			HTTPResponse res;
			String sJasonRes;
			
			//No es una prueba
			if  (!Test.isRunningTest()){
				res = new Http().send(request);
				sJasonRes = res.getBody();
			}//Fin si !Test.isRunningTest()
			
			//Si es una prueba
			if  (Test.isRunningTest()){
				res = new HTTPResponse();				
				res.setBody('200');
				sJasonRes = '{"access_token":"aTGaMkfsDBK8a4TMi6kzo1ZJbchVsWZNNKb1ljoY3EKl2pBGlSrxFL-sG8x9sLwbsFuzKJgSt_M-Ye1OYdhM4mvEmYB7bMzLfC87FJk4TysuAqCo2f0AyjTPyf-f-xVSjhEHcG2sSnXlX61kULLh1HX-VUjWik1Q7rmpFhvYRqtzfu0pUaNp34YH8pi5PVRWZZni4GR853nX5udraAr69q1KbhKu99cy88GXuCeZQLFeiV98FzA_sP0Ev2plW-pCVtQWhwH5Uu__AM69X8zw2CFr3jB02cDXqDqUei5g6GdLZP-aclKiQ_q3oYw0T9RlNZSEq3j1Z33MmAE4Zbv_dKsmjpE48VcQVLa-ohGmdav7-k3Z","token_type":"bearer","expires_in":1799}';				
			}//Fin si Test.isRunningTest()
			System.debug('EN Login HTTP: ' + res + ' sJasonRes: ' + sJasonRes);

			if (String.valueOf(res).contains('200') || Test.isRunningTest()){
				//Seriarliza la respuesta del servicio
				DtRespuestaTelcel objDtRespuestaTelcelPaso = JSONParserRespTelcel(String.valueOf(sJasonRes));			
				objDtRespuestaTelcel.access_token = objDtRespuestaTelcelPaso.access_token;
				objDtRespuestaTelcel.token_type = objDtRespuestaTelcelPaso.token_type;
				objDtRespuestaTelcel.expires_in = objDtRespuestaTelcelPaso.expires_in;
				objDtRespuestaTelcel.error = objDtRespuestaTelcelPaso.error;
				objDtRespuestaTelcel.error_description = objDtRespuestaTelcelPaso.error_description;
			}
			//Ve si el campo JsonRes tiene algo
			if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') || Test.isRunningTest()){
				if (Test.isRunningTest())
					sJasonRes = '{"error": "invalid_client","error_description": "Las credenciales proporcionadas no son correctas."}';
				objDtRespuestaTelcel.error = 'Error a la hora de llamar el servicio de Login';
				objDtRespuestaTelcel.error_description = String.valueOf(sJasonRes);
			}//Fin si sJasonRes != null && sJasonRes.length() == 0			

		}catch(Exception ex){
			objDtRespuestaTelcel.error = 'Error a la hora de llamar el servicio de Login';
			objDtRespuestaTelcel.error_description = ex.getMessage();
		}
				
		System.debug(loggingLevel.Error, '*** objDtRespuestaTelcel: ' + objDtRespuestaTelcel);		
		//Regresa el objeto de objDtRespuestaTelcel     	
    	return objDtRespuestaTelcel;
    } 
 
 
 	public static Map<String, EndpointSetting__mdt> getEndpointSettingMdt(){
 		Map<String, EndpointSetting__mdt> mapEndpointSettingMdtPaso = new Map<String, EndpointSetting__mdt>();
 		
 		for (EndpointSetting__mdt objEndpointSettingMdt : [Select e.Timeout__c, e.ServiceProvider__c, e.ResponseBodyType__c, 
 			e.RequestBodyType__c, e.IsActive__c, e.Endpoint__c, e.DevelopmentEndpoint__c, e.DeveloperName, e.Description__c,
 			e.grant_type__c, e.client_id__c, e.client_secret__c, ServiceMethod__c
 			From EndpointSetting__mdt e Where IsActive__c = true ]){
 			//Metelo al mapa de mapEndpointSettingMdtPaso
 			mapEndpointSettingMdtPaso.put(objEndpointSettingMdt.DeveloperName, objEndpointSettingMdt);	
 		}
 		
 		//Regresa el mapa
 		return mapEndpointSettingMdtPaso;
 	}
 

	//Regresa un objeto del tipo DtRespuestaTelcel si no hubo error a la hora de registrar el cliente		
	public static DtRespuestaTelcel JSONParserRespTelcel(String sJsonResp){
		System.debug('EN DCT_Utils_cls.Login: sJsonResp: ' + sJsonResp);
		
		DtRespuestaTelcel objAPPResp = new DtRespuestaTelcel();
				
		try{
            JSONParser parser = JSON.createParser(sJsonResp);
            //Ve si tiene algo el objeto de parser  
            while (parser.nextToken() != null) {//{"error": "invalid_client","error_description": "Las credenciales proporcionadas no son correctas."}
				//Inicia el detalle del objeto: sNombreObj
				if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
					//Toma el contenido del Json y conviertelo a SignInCls.class 
					objAPPResp = (DtRespuestaTelcel)parser.readValueAs(DtRespuestaTelcel.class);
				}//Fin si parser.getCurrentToken() == JSONToken.START_OBJECT
            }//Fin mientras parser.nextToken() != null			
		}catch(Exception ex){
			System.debug('ERROR EN DCT_Utils_cls.Login: sJsonResp: ' + ex.getMessage());
	 	}
			 	
		//Regresa el objeto objSignInClsPaso
		return objAPPResp;
	}

    @future(callout=true)
	public static void ActualizaFolioSAPDirCom(String sIdEambudos){
		System.debug('ENTRO A Utils.ActualizaFolioSAPDirCom: ' + sIdEambudos);
		
		String sRespWs = '';
		String sDatos = '';
		String sUsuario = '';
		String sPwd = '';
		Map<String, Cliente__c> mapDirComUpd = new Map<String, Cliente__c>();
		
		//Crea la lista para los id de los Embudos que se estan actualizando
		List<String> lIdEmbudosPaso = sIdEambudos.split(',');
		Set<String> setEmbRefAct = new Set<String>();
		Set<String> setEmbRefNoAct = new Set<String>();		
		System.debug('ENTRO A Utils.ActualizaFolioSAPDirCom lIdEmbudosPaso: ' + lIdEmbudosPaso);
		
		//Ve si ya tienen folio los embudos
		for(Cliente__c DirCom : [Select id, DCTFolio__c From Cliente__c Where ID IN : lIdEmbudosPaso
			And (DCTFolio__c = null or DCTFolio__c = '0')]){
			setEmbRefNoAct.add(DirCom.id);			
		}		
		System.debug('ENTRO A Utils.ActualizaFolioSAPDirCom setEmbRefNoAct: ' + setEmbRefNoAct);
				
		//Recorre la lista de lIdEmbudosPaso y envia los datos a Telcel
		for (String sIdDirCom : setEmbRefNoAct){
			
			//Busca los datos de sIdDirCom 
			for (Cliente__c DirCom : [Select id, Name,
						Cliente__c,
						Cliente__r.Owner.EmployeeNumber, //NEMPLEADO						
						Cliente__r.DTC_LegalEntity__c, //Tipo de Persona: Física, Moral, Física con Actividad Empresarial, Gubernamental
						RFC1__c, //RFC
						RFC__c, //RFC						
						Cliente__r.DCTName__c, //NOM1PF
						Cliente__r.DCTLastName__c, //APPAT
						Cliente__r.DCTMotherLastName__c, //APMAT*/
						Cliente__r.Name, //NOM1PM
						//Datos de la dirección
						DCTFiscalStreet__c, //CALLE
						DCTNoIntFiscal__c, //NUMEROL
						DCTNoExtFiscal__c, //COMPLNUM
						DCTCodePostfiscal__c, //CODPOSTAL
						DCTDelMpiofiscal__c, //DELMUN
						DCTColonyFiscal__c, //COLONIA
						//CIUDAD PENDIENTE
						//PAIS 'MX' DEF						
						FiscalFederalEntity__c	//ESTADO						 
					From Cliente__c Where ID = :sIdDirCom]){

				//Concatena los datos en la variable de sDatos
				//NEMPLEADO
				sDatos += DirCom.Cliente__r.Owner.EmployeeNumber != null ? DirCom.Cliente__r.Owner.EmployeeNumber + ',' : ','; 
				//REGION
				sDatos += 'MR09,';
				//RFC
				if (DirCom.RFC1__c != null)
					sDatos += DirCom.RFC1__c != null ? DirCom.RFC1__c + ',' : ',';
				else if (DirCom.RFC__c != null)	
					sDatos += DirCom.RFC__c != null ? DirCom.RFC__c + ',' : ',';				
				System.debug('ANTES DE LLAMAR A Utils.ActualizaFolioSAPDirCom sDatos1: ' + sDatos);
				
				//Se trata de una persona fisica
				if (DirCom.Cliente__r.DTC_LegalEntity__c == 'Física' || DirCom.Cliente__r.DTC_LegalEntity__c == 'Física con Actividad Empresarial'){
					String sConBus = DirCom.Cliente__r.DCTName__c != null ? DirCom.Cliente__r.DCTName__c.substring(0,1) : '';
					sConBus += DirCom.Cliente__r.DCTLastName__c != null ? DirCom.Cliente__r.DCTLastName__c.substring(0,1) : '';
					sConBus += DirCom.Cliente__r.DCTLastName__c != null ? DirCom.Cliente__r.DCTLastName__c.substring(0,1) : '';
					//CONCEPTOBUSQ
					sDatos += sConBus + ',';								
					//NOM1PF
					sDatos += DirCom.Cliente__r.DCTName__c != null ? DirCom.Cliente__r.DCTName__c + ',' : ',';
					//NOM2PF
					sDatos += ',';
					//APPAT
					sDatos += DirCom.Cliente__r.DCTLastName__c != null ? DirCom.Cliente__r.DCTLastName__c + ',' : ',';				
					//APMAT
					sDatos += DirCom.Cliente__r.DCTMotherLastName__c != null ? DirCom.Cliente__r.DCTMotherLastName__c + ',' : ',';				
				}//Fin si DirCom.Cliente__r.DTC_LegalEntity__c == 'Física' || DirCom.Cliente__r.DTC_LegalEntity__c == 'Física con Actividad Empresarial'

				//Se trata de una persona Moral 
				if (DirCom.Cliente__r.DTC_LegalEntity__c == 'Moral' || DirCom.Cliente__r.DTC_LegalEntity__c == 'Gubernamental'){
					//CONCEPTOBUSQ
					sDatos += DirCom.Cliente__r.Name != null ? DirCom.Cliente__r.Name + ',' : ',';
					//NOM1PM
					sDatos += DirCom.Cliente__r.Name != null ? DirCom.Cliente__r.Name + ',' : ',';
					//NOM2PM
					sDatos += ',';
					//NOM3PM
					sDatos += ',';
					//NOM4PM
					sDatos += ',';					
				}//Fin si DirCom.Cliente__r.DTC_LegalEntity__c == 'Física' || DirCom.Cliente__r.DTC_LegalEntity__c == 'Física con Actividad Empresarial'
				System.debug('ANTES DE LLAMAR A Utils.ActualizaFolioSAPDirCom sDatos2: ' + sDatos);
				
				//Por aqui los datos de la dirección
				//CALLE
				sDatos += DirCom.DCTFiscalStreet__c != null ? DirCom.DCTFiscalStreet__c + ',' : ',';
				//NUMEROL
				sDatos += DirCom.DCTNoIntFiscal__c != null ? DirCom.DCTNoIntFiscal__c + ',' : ',';
				//COMPLNUM
				sDatos += DirCom.DCTNoExtFiscal__c != null ? DirCom.DCTNoExtFiscal__c + ',' : ',';
				//CODPOSTAL
				sDatos += DirCom.DCTCodePostfiscal__c != null ? DirCom.DCTCodePostfiscal__c + ',' : ',';
				//DELMUN
				sDatos += DirCom.DCTDelMpiofiscal__c != null ? DirCom.DCTDelMpiofiscal__c + ',' : ',';
				//COLONIA
				sDatos += DirCom.DCTColonyFiscal__c != null ? DirCom.DCTColonyFiscal__c + ',' : ',';
				//CIUDAD
				sDatos += ',';
				//PAIS
				sDatos += 'MX,';
				//ESTADO
				sDatos += DirCom.FiscalFederalEntity__c != null ? DirCom.FiscalFederalEntity__c + ',' : ',';
				System.debug('ANTES DE LLAMAR A Utils.ActualizaFolioSAPDirCom sDatos3: ' + sDatos + ' ' + DirCom.Cliente__r.DTC_LegalEntity__c + ' ' + DirCom.RFC1__c + ' ' + DirCom.RFC__c);

				//Crea el llamado al Ws de referencia rap
				if ((DirCom.RFC1__c != null || DirCom.RFC__c != null) && DirCom.Cliente__r.DTC_LegalEntity__c != null) {
					System.debug('ANTES DE LLAMAR A Utils.ActualizaFolioSAPDirCom sDatos: ' + sDatos);
					System.debug('ANTES DE LLAMAR A Utils.ActualizaFolioSAPDirCom objRespRefRap: ' + DirCom.RFC1__c + ' RFC__c: ' + DirCom.RFC__c);					
					
					if (!Test.isRunningTest())					
						objRespSalesforce = DCT_FolioSAP_ws.getFolioSAP(sDatos, sUsuario, sPwd, DirCom.Cliente__r.DTC_LegalEntity__c);
										
					System.debug('ENTRO A Utils.ActualizaFolioSAPDirCom objRespSalesforce: ' + objRespSalesforce);
					//Ve si no hubo error a la hora de consultar la referencia SAP
					if (objRespSalesforce.error != null){
						//No hubo error
						if (!objRespSalesforce.error){
							mapDirComUpd.put(dirCom.id, new Cliente__c(id = dirCom.id,
									DCTFolio__c = objRespSalesforce.folio
								)
							);
						}//Fin si objRespSalesforce.idEstatus == '0'
						//hubo error a la hora
						if (objRespSalesforce.error){
							mapDirComUpd.put(DirCom.id, new Cliente__c(id = DirCom.id,
									DCT_DetalleErrorFolioSAP__c = objRespSalesforce.mensaje
								)
							);												
						}//Fin si objRespSalesforce.error
					}//Fin si objRespSalesforce.error != null
				}//Fin si DirCom.Account.RFC1__c != null

			}//Fin del for para los datos del Dir Com
			
		}//Fin del for para los dir com que no tienen folio

		//Ya tienes los dir comer que se van a actualizar
		if (!mapDirComUpd.isEmpty()){
			System.debug('ANTES DE LLAMAR A Utils.ActualizaFolioSAPDirCom mapDirComUpd: ' + mapDirComUpd);
			DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');						
	        List<Database.SaveResult> lDtbup = Database.update(mapDirComUpd.values(), false);
	        for (Database.SaveResult objDtbup : lDtbup){
	        	if(!objDtbup.isSuccess())
					System.debug('EN Utils.ActualizaFolioSAPDirCom ERROR A LA HORA DE ACT LA REFERENCIA SAP: ' + objDtbup.getErrors()[0].getMessage());	        	
	        	if(objDtbup.isSuccess())
					System.debug('EN Utils.ActualizaFolioSAPDirCom SE ACT EL DIR COM CON EXITO ID: ' + objDtbup.getId());	        			        	
	        }//Fin del for para lDtbup
		}//Fin si !mapDirComUpd.isEmpty()
			
	}

	//Función que permite calcular la dedad de una persona
    @future(callout=true)
	public static void ActualizaReferenciaRAPDirCom(String sIdEambudos){
		System.debug('ENTRO A Utils.ActualizaReferenciaRAP: ' + sIdEambudos);
		
		String sRespWs = '';
		Map<String, Cliente__c> mapDirComUpd = new Map<String, Cliente__c>();
		
		//Crea la lista para los id de los Embudos que se estan actualizando
		List<String> lIdEmbudosPaso = sIdEambudos.split(',');
		Set<String> setEmbRefAct = new Set<String>();
		Set<String> setEmbRefNoAct = new Set<String>();		
		System.debug('ENTRO A Utils.ActualizaReferenciaRAP lIdEmbudosPaso: ' + lIdEmbudosPaso);

		//Ve si ya tienen folio los embudos
		for(Cliente__c DirCom : [Select id, DCTRapReference__c From Cliente__c Where ID IN : lIdEmbudosPaso
			And DCTRapReference__c = null]){
			setEmbRefNoAct.add(DirCom.id);			
		}		

		//Recorre la lista de lIdEmbudosPaso y envia los datos a Telcel
		for (String sIdDirCom : setEmbRefNoAct){

			//Busca los datos de sIdDirCom 
			for (Cliente__c DirCom : [Select id, Name, Cliente__c,	Cliente__r.RFC__c 
					From Cliente__c Where ID = :sIdDirCom]){

				//Crea el llamado al Ws de referencia rap
				if (DirCom.Cliente__r.RFC__c != null) {
					System.debug('ANTES DE LLAMAR A Utils.ActualizaReferenciaRAP objRespRefRap: ' + DirCom.Cliente__r.RFC__c);
					
					//No es una prueba
					if (!Test.isRunningTest())
						sRespWs = DCT_ReferenciaRAP_ws.ReferenciaRAP(DirCom.Cliente__r.RFC__c);
						
					//Es una prueba	
					if (Test.isRunningTest())
						sRespWs = '{"referenciaWSRap": {"idEstatus": 0,"nombreCliente": "BIOGENESIS BAGO DE MEXICO SA DE CV","referencia": "FA6935C6767802455","rfc": "BBM061031RY6"}}';

					System.debug('ENTRO A Utils.ActualizaReferenciaRAP sRespWs: ' + sRespWs);
					respuestaTelcel objRespRefRap = (respuestaTelcel) JSON.deserialize(sRespWs, respuestaTelcel.class);					
					System.debug('ENTRO A Utils.ActualizaReferenciaRAP objRespRefRap: ' + objRespRefRap);
					
					//Ve si no hubo error a la hora de consultar la referencia SAP
					if (objRespRefRap.referenciaWSRap != null){					
						if (objRespRefRap.referenciaWSRap.idEstatus == 0){
							mapDirComUpd.put(dirCom.id, new Cliente__c(id = dirCom.id,
									DCTRapReference__c = objRespRefRap.referenciaWSRap.referencia
								)
							);
						}//Fin si objRespRefRap.idEstatus == '0'
						//Ve si no hubo error a la hora de consultar la referencia SAP
						if (objRespRefRap.referenciaWSRap.idEstatus == 2){
							//Tiene un dir asociado esta opp
							mapDirComUpd.put(dirCom.id, new Cliente__c(id = dirCom.id,
									DCT_DetalleErrorReferenciaRAP__c = objRespRefRap.referenciaWSRap.descEstatus
								)
							);						
						}//Fin si objRespRefRap.referenciaWSRap.idEstatus == 2
					}//Fin si objRespRefRap.referenciaWSRap != null
										
				}//Fin si DirCom.Cliente__r.RFC__c != null
			
			}//Fin del for para los datos del cliente
			
		}//Fin del for para la lista de setEmbRefNoAct
		
		//Ya tienes los dir comer que se van a actualizar
		if (!mapDirComUpd.isEmpty()){
			System.debug('ANTES DE LLAMAR A Utils.ActualizaReferenciaRAP mapDirComUpd: ' + mapDirComUpd);
			DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');						
	        List<Database.SaveResult> lDtbup = Database.update(mapDirComUpd.values(), false);
	        for (Database.SaveResult objDtbup : lDtbup){
	        	if(!objDtbup.isSuccess())
					System.debug('EN Utils.ActualizaReferenciaRAP ERROR A LA HORA DE ACT LA REFERENCIA SAP: ' + objDtbup.getErrors()[0].getMessage());	        	
	        	if(objDtbup.isSuccess())
					System.debug('EN Utils.ActualizaReferenciaRAP SE ACT EL DIR COM CON EXITO ID: ' + objDtbup.getId());	        			        	
	        }//Fin del for para lDtbup
		}//Fin si !mapDirComUpd.isEmpty()
			
	}

	/*public static Long consectivoPlanesYEquipos(){
		System.debug('EN consectivoPlanesYEquipos...');
		Long lConsecutivo = 0;

		ConsWsPlanesEquipos__c consePlanesEquipos = new ConsWsPlanesEquipos__c();
		Insert consePlanesEquipos;
		//Crea el consecutivo
		String sConsec = [Select Name From ConsWsPlanesEquipos__c Where id =: consePlanesEquipos.id].Name;
		//Elimina el reg creado 
		delete consePlanesEquipos;
		
		System.debug('EN consectivoPlanesYEquipos sConsec: ' + sConsec);		
		//Regresa el consecutivo
		return Long.valueOf(sConsec);
	}*/
	
	//******YA NO SE SE ESTAN USUANDO ACTUALMENTE EN LA CLASE DE DCT_ComercialDirectory_cls ****//
	/*//Función que permite calcular la dedad de una persona
    @future(callout=true)
	public static void ActualizaInvestigacionesEsc1Pos(String sIdEambudos, Boolean bLimpiaCampos){
		System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc1Pos: ' + sIdEambudos + ' bLimpiaCampos: ' + bLimpiaCampos);
		
		String sRespWs = '';
		String sMsgFinal = '';
		Boolean bMsgFinalSuccess = false;
		Boolean bMsgFinalError = false;
		Map<String, Cliente__c> mapDirComUpd = new Map<String, Cliente__c>();
		Cliente__c DatosDirComercialUps = new Cliente__c();
		
		//Crea la lista para los id de los Embudos que se estan actualizando
		List<String> lIdEmbudosPaso = sIdEambudos.split(',');
		Set<String> setEmbRefAct = new Set<String>();
		Set<String> setEmbRefNoAct = new Set<String>();		
		System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc1Pos lIdEmbudosPaso: ' + lIdEmbudosPaso);

		//Ve si ya tienen folio los embudos
		for(Cliente__c DirCom : [Select id, DCTRapReference__c From Cliente__c Where ID IN : lIdEmbudosPaso]){
			setEmbRefNoAct.add(DirCom.id);			
		}		

		//Recorre la lista de lIdEmbudosPaso y envia los datos a Telcel
		for (String sIdDirCom : setEmbRefNoAct){

			//Busca los datos de sIdDirCom 
			for (Cliente__c DirCom : [Select id, Name, Cliente__r.RFC__c, DCTInvestigation__c,
					DCTCommentsInvestigation__c, DCTResultVerification__c, DCTTypeAuthorization__c
					From Cliente__c Where ID = :sIdDirCom]){
					System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc1Pos DirCom: ' + DirCom);
				    DatosDirComercialUps = new Cliente__c(id = DirCom.id);
				    
				//Crea el llamado al Ws de referencia rap
				if (DirCom.Name != null && DirCom.DCTResultVerification__c != null) {
			    	
			    	String sCommInvestigaPaso = '';
			    	if (DirCom.DCTResultVerification__c == 'POSITIVA'){			    		
				    	DirCom.DCTInvestigation__c = 'BH'; //''
			    		sCommInvestigaPaso = DirCom.DCTResultVerification__c;
				    	if (!bLimpiaCampos)			    		
			    			sCommInvestigaPaso += DirCom.DCTCommentsInvestigation__c != null ? ' - ' + DirCom.DCTCommentsInvestigation__c : ' - ';
				    	if (bLimpiaCampos)			    		
			    			sCommInvestigaPaso += ' - ';			    			
			    	}//Fin si DirCom.DCTResultVerification__c == 'POSITIVA'
			    	
			    	try{
				    	System.debug('EN Utils.ActualizaFuerzaVetaWs DirCom.Name: ' + DirCom.Name + ' DirCom.DCTResultVerification__c: ' + DirCom.DCTInvestigation__c + ' sCommInvestigaPaso: ' + sCommInvestigaPaso);
			    		
						//Por aqui mandamos llamar el WebService de directorioEmpleados/ConsultarEmpleado/			
					    DCT_Investigaciones_ws.ResponseWrapper objClsInvest = DCT_Investigaciones_ws.Investigaciones(DirCom.Name, 
					    	DirCom.DCTInvestigation__c, sCommInvestigaPaso); 
						System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc1Pos objClsInvest: ' + objClsInvest);
						System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc1Pos bLimpiaCampos: ' + bLimpiaCampos);
													    	
					    //Ve si no hubo error a la hora de responder del servicio
					    if (objClsInvest.EstatusConsulta == 0 || objClsInvest.EstatusConsulta == 2){
				    		DatosDirComercialUps.DCTResearchLegend__c = objClsInvest.Leyenda;
				    		DatosDirComercialUps.DCTResultVerification__c = objClsInvest.Estado;
					    	DatosDirComercialUps.DCTTypeAuthorization__c = DirCom.DCTResultVerification__c;		    	
					    	DatosDirComercialUps.DCTInvestigation__c = DirCom.DCTInvestigation__c;
					    	if (bLimpiaCampos){
					    		DatosDirComercialUps.DCTCommentsInvestigation__c = null;
					    		DatosDirComercialUps.DCTAuthorizationDateVoBoManagement__c = null;
					    		DatosDirComercialUps.DCTAskAuthorization__c = false;
					    		DatosDirComercialUps.DCTComentariosAutorizacion__c = null;
					    	}//Fin si bActCampos

							System.debug('EN Utils.ActualizaImvestigacionesWs el DatosDirComercialUps: ' + DatosDirComercialUps);
					    	//Actualiza el reg y actualiza la pagina
							DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');					    	
							Database.Saveresult Dtupr = Database.update(DatosDirComercialUps, false);
							//No hubo error
				   			if (Dtupr.isSuccess())
				   				System.debug('EN Utils.ActualizaImvestigacionesWs el ID: ' + Dtupr.getId());
				   			//Hubo error
				   			if (!Dtupr.isSuccess()){
				   				DatosDirComercialUps.DCT_DetalleErrorInvest__c = Dtupr.getErrors()[0].getMessage();   				
				   				System.debug('EN Utils.ActualizaImvestigacionesWs ERROR aL ACTUALIZAR: ' + Dtupr.getErrors()[0].getMessage());
				   			}//Fin si !Dtupr.isSuccess()
						    if (objClsInvest.EstatusConsulta == 2){
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = objClsInvest.Descripcion;
						    }//Fin si objClsInvest.EstatusConsulta == 2
	
					    }//Fin si objClsInvest.ErrorID == NULL    	
			
						//Si hay error
					    if (objClsInvest.EstatusConsulta != 0 && objClsInvest.EstatusConsulta != 2){
							bMsgFinalError = true;
							if (objClsInvest.Message == null && objClsInvest.ExceptionMessage == null)
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = 'Time Out';				
							else	
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = objClsInvest.Message + ' ' + objClsInvest.ExceptionMessage;
					    }//Fin si objClsInvest.EstatusConsulta != 0 && objClsInvest.EstatusConsulta != 2
					
			    	}Catch(Exception ex){
						DatosDirComercialUps.DCT_DetalleErrorInvest__c = 'Time Out';			    		
			    	}
										
				}//Fin si DirCom.Cliente__r.RFC__c != null
			
			}//Fin del for para los datos del cliente
			
		}//Fin del for para la lista de setEmbRefNoAct		
			
	}*/


	//SE ESTA USUANDO ACTUALMENTE EN LA CLASE DE DCT_ComercialDirectory_cls
	public static void ActualizaInvestigacionesEsc5VI(String sIdEambudos, Boolean bLimpiaCampos){
		//Consulta el catalogo que se va a crear para ese proposito
	}	

	/*//Función que permite calcular la dedad de una persona
    @future(callout=true)
	public static void ActualizaInvestigacionesEsc5VI(String sIdEambudos, Boolean bLimpiaCampos){
		System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc5VI: ' + sIdEambudos);
		
		String sRespWs = '';
		String sMsgFinal = '';
		Boolean bMsgFinalSuccess = false;
		Boolean bMsgFinalError = false;
		Map<String, Cliente__c> mapDirComUpd = new Map<String, Cliente__c>();
		Cliente__c DatosDirComercialUps = new Cliente__c();
		
		//Crea la lista para los id de los Embudos que se estan actualizando
		List<String> lIdEmbudosPaso = sIdEambudos.split(',');
		Set<String> setEmbRefAct = new Set<String>();
		Set<String> setEmbRefNoAct = new Set<String>();		
		System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc5VI lIdEmbudosPaso: ' + lIdEmbudosPaso);

		//Ve si ya tienen folio los embudos
		for(Cliente__c DirCom : [Select id, DCTRapReference__c From Cliente__c Where ID IN : lIdEmbudosPaso]){
			setEmbRefNoAct.add(DirCom.id);			
		}		

		//Recorre la lista de lIdEmbudosPaso y envia los datos a Telcel
		for (String sIdDirCom : setEmbRefNoAct){

			//Busca los datos de sIdDirCom 
			for (Cliente__c DirCom : [Select id, Name, Cliente__r.RFC__c, DCTInvestigation__c,
					DCTCommentsInvestigation__c, DCTResultVerification__c, DCTTypeAuthorization__c
					From Cliente__c Where ID = :sIdDirCom]){
					System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc5VI DirCom: ' + DirCom);
				    DatosDirComercialUps = new Cliente__c(id = DirCom.id);
				    
				//Crea el llamado al Ws de referencia rap
				if (DirCom.Name != null) {
			    	
			    	String sCommInvestigaPaso = '';
			    	if (DirCom.DCTInvestigation__c == 'VI'){
			    		sCommInvestigaPaso = '';
			    	}//Fin si DirCom.DCTResultVerification__c == 'POSITIVA'
			    	
			    	try{
				    	System.debug('EN Utils.ActualizaFuerzaVetaWs DirCom.Name: ' + DirCom.Name + ' DirCom.DCTResultVerification__c: ' + DirCom.DCTInvestigation__c + ' sCommInvestigaPaso: ' + sCommInvestigaPaso);
			    		
						//Por aqui mandamos llamar el WebService de directorioEmpleados/ConsultarEmpleado/			
					    DCT_Investigaciones_ws.ResponseWrapper objClsInvest = DCT_Investigaciones_ws.Investigaciones(DirCom.Name, 
					    	DirCom.DCTInvestigation__c, sCommInvestigaPaso); 
						System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc5VI objClsInvest: ' + objClsInvest);
							    	
					    //Ve si no hubo error a la hora de responder del servicio
					    if (objClsInvest.EstatusConsulta == 0 || objClsInvest.EstatusConsulta == 2){
				    		DatosDirComercialUps.DCTResearchLegend__c = objClsInvest.Leyenda;
				    		DatosDirComercialUps.DCTResultVerification__c = objClsInvest.Estado;
					    	DatosDirComercialUps.DCTTypeAuthorization__c = DirCom.DCTResultVerification__c;		    	
					    	DatosDirComercialUps.DCTInvestigation__c = DirCom.DCTInvestigation__c;
					    	//Ve si actualiza campos
					    	if (bLimpiaCampos){
					    		DatosDirComercialUps.DCTCommentsInvestigation__c = null;
					    		DatosDirComercialUps.DCTTypeAuthorization__c = null;
					    		DatosDirComercialUps.DCTAuthorizationDateVoBoManagement__c = null;
					    		DatosDirComercialUps.DCTAskAuthorization__c = false;
					    		DatosDirComercialUps.DCTComentariosAutorizacion__c = null;
					    	}//Fin si bActCampos
							System.debug('EN Utils.ActualizaImvestigacionesWs el DatosDirComercialUps: ' + DatosDirComercialUps);

							DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');																
					    	//Actualiza el reg y actualiza la pagina
							Database.Saveresult Dtupr = Database.update(DatosDirComercialUps, false);
							
							//No hubo error
				   			if (Dtupr.isSuccess())
				   				System.debug('EN Utils.ActualizaImvestigacionesWs el ID: ' + Dtupr.getId());
				   			//Hubo error
				   			if (!Dtupr.isSuccess()){
				   				DatosDirComercialUps.DCT_DetalleErrorInvest__c = Dtupr.getErrors()[0].getMessage();   				
				   				System.debug('EN Utils.ActualizaImvestigacionesWs ERROR aL ACTUALIZAR: ' + Dtupr.getErrors()[0].getMessage());
				   			}//Fin si !Dtupr.isSuccess()
						    if (objClsInvest.EstatusConsulta == 2){
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = objClsInvest.Descripcion;
						    }//Fin si objClsInvest.EstatusConsulta == 2
	
					    }//Fin si objClsInvest.ErrorID == NULL    	
			
						//Si hay error
					    if (objClsInvest.EstatusConsulta != 0 && objClsInvest.EstatusConsulta != 2){
							bMsgFinalError = true;
							if (objClsInvest.Message == null && objClsInvest.ExceptionMessage == null)
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = 'Time Out';				
							else	
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = objClsInvest.Message + ' ' + objClsInvest.ExceptionMessage;
					    }//Fin si objClsInvest.EstatusConsulta != 0 && objClsInvest.EstatusConsulta != 2
					
			    	}Catch(Exception ex){
						DatosDirComercialUps.DCT_DetalleErrorInvest__c = 'Time Out';			    		
			    	}
										
				}//Fin si DirCom.Cliente__r.RFC__c != null
			
			}//Fin del for para los datos del cliente
			
		}//Fin del for para la lista de setEmbRefNoAct		
		
	}*/

	//SE ESTA USUANDO ACTUALMENTE EN LA CLASE DE DCT_ComercialDirectory_cls
	public static void ActualizaInvestigacionesEsc12Pos(String sIdEambudos, Boolean bActCampos){
		//Consulta el catalogo que se va a crear para ese proposito
	}
		
	/*//Función que permite calcular la dedad de una persona
    @future(callout=true)
	public static void ActualizaInvestigacionesEsc12Pos(String sIdEambudos, Boolean bActCampos){
		System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc12Pos: ' + sIdEambudos + ' bActCampos: ' + bActCampos);
		
		String sRespWs = '';
		String sMsgFinal = '';
		Boolean bMsgFinalSuccess = false;
		Boolean bMsgFinalError = false;
		Map<String, Cliente__c> mapDirComUpd = new Map<String, Cliente__c>();
		Cliente__c DatosDirComercialUps = new Cliente__c();
		
		//Crea la lista para los id de los Embudos que se estan actualizando
		List<String> lIdEmbudosPaso = sIdEambudos.split(',');
		Set<String> setEmbRefAct = new Set<String>();
		Set<String> setEmbRefNoAct = new Set<String>();		
		System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc12Pos lIdEmbudosPaso: ' + lIdEmbudosPaso);

		//Ve si ya tienen folio los embudos
		for(Cliente__c DirCom : [Select id, DCTRapReference__c From Cliente__c Where ID IN : lIdEmbudosPaso]){
			setEmbRefNoAct.add(DirCom.id);			
		}		

		//Recorre la lista de lIdEmbudosPaso y envia los datos a Telcel
		for (String sIdDirCom : setEmbRefNoAct){
			String sComentariosProceso;
			
			//Busca los datos de sIdDirCom 
			for (Cliente__c DirCom : [Select id, Name, Cliente__r.RFC__c, DCTInvestigation__c,
					DCTCommentsInvestigation__c, DCTResultVerification__c, DCTTypeAuthorization__c,
					 DCTResultVerificationEsp__c
					From Cliente__c Where ID = :sIdDirCom]){
					System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc12Pos DirCom: ' + DirCom);
				    DatosDirComercialUps = new Cliente__c(id = DirCom.id);
				    
				//Crea el llamado al Ws de referencia rap
				if (DirCom.Name != null && (DirCom.DCTResultVerification__c != null || DirCom.DCTResultVerificationEsp__c == 'NEGATIVA')) {
			    	
			    	String sCommInvestigaPaso = '';
					//Busca los comentarios del proceso de aprobación asociado a este reg			    	
			    	if (DirCom.DCTResultVerification__c == 'NEGATIVA' || DirCom.DCTResultVerificationEsp__c == 'NEGATIVA'){
				    	DirCom.DCTInvestigation__c = DirCom.DCTInvestigation__c;
						System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc12Pos ANTES DE EN TRAR A buscaComentariosProceso...');
						sComentariosProceso = ''; //buscaComentariosProceso(DirCom.id);
			    	}//Fin si DirCom.DCTResultVerification__c == 'NEGATIVA'
			    	
			    	try{
				    	System.debug('EN Utils.ActualizaFuerzaVetaWs DirCom.Name: ' + DirCom.Name + ' DirCom.DCTResultVerification__c: ' + DirCom.DCTInvestigation__c + ' sCommInvestigaPaso: ' + sCommInvestigaPaso);
			    		
						//Por aqui mandamos llamar el WebService de directorioEmpleados/ConsultarEmpleado/			
					    DCT_Investigaciones_ws.ResponseWrapper objClsInvest = DCT_Investigaciones_ws.Investigaciones(DirCom.Name, 
					    	DirCom.DCTInvestigation__c, sCommInvestigaPaso); 
						System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc12Pos objClsInvest: ' + objClsInvest);
						System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc12Pos bActCampos: ' + bActCampos);
													    	
					    //Ve si no hubo error a la hora de responder del servicio
					    if (objClsInvest.EstatusConsulta == 0 || objClsInvest.EstatusConsulta == 2){
				    		DatosDirComercialUps.DCTResearchLegend__c = objClsInvest.Leyenda;
				    		DatosDirComercialUps.DCTResultVerification__c = objClsInvest.Estado;					    			    	
					    	DatosDirComercialUps.DCTCommentsInvestigation__c = sComentariosProceso;
					    	//Ve si actualiza campos
					    	if (bActCampos){
					    		DatosDirComercialUps.DCTCommentsInvestigation__c = null;
					    		DatosDirComercialUps.DCTTypeAuthorization__c = null;
					    		DatosDirComercialUps.DCTAuthorizationDateVoBoManagement__c = null;
					    		DatosDirComercialUps.DCTAskAuthorization__c = false;
					    		DatosDirComercialUps.DCTResultVerificationEsp__c = null;
					    		DatosDirComercialUps.DCTComentariosAutorizacion__c = null;					    		
					    	}//Fin si bActCampos
							System.debug('EN Utils.ActualizaImvestigacionesWs el DatosDirComercialUps: ' + DatosDirComercialUps);

							DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');																
					    	//Actualiza el reg y actualiza la pagina
							Database.Saveresult Dtupr = Database.update(DatosDirComercialUps, false);
							//No hubo error
				   			if (Dtupr.isSuccess())
				   				System.debug('EN Utils.ActualizaImvestigacionesWs el ID: ' + Dtupr.getId());
				   			//Hubo error
				   			if (!Dtupr.isSuccess()){
				   				DatosDirComercialUps.DCT_DetalleErrorInvest__c = Dtupr.getErrors()[0].getMessage();   				
				   				System.debug('EN Utils.ActualizaImvestigacionesWs ERROR aL ACTUALIZAR: ' + Dtupr.getErrors()[0].getMessage());
				   			}//Fin si !Dtupr.isSuccess()
						    if (objClsInvest.EstatusConsulta == 2){
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = objClsInvest.Descripcion;
						    }//Fin si objClsInvest.EstatusConsulta == 2
	
					    }//Fin si objClsInvest.ErrorID == NULL    	
			
						//Si hay error
					    if (objClsInvest.EstatusConsulta != 0 && objClsInvest.EstatusConsulta != 2){
							bMsgFinalError = true;
							if (objClsInvest.Message == null && objClsInvest.ExceptionMessage == null)
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = 'Time Out';				
							else	
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = objClsInvest.Message + ' ' + objClsInvest.ExceptionMessage;
					    }//Fin si objClsInvest.EstatusConsulta != 0 && objClsInvest.EstatusConsulta != 2
					
			    	}Catch(Exception ex){
						DatosDirComercialUps.DCT_DetalleErrorInvest__c = 'Time Out';			    		
			    	}
										
				}//Fin si DirCom.Cliente__r.RFC__c != null
			
			}//Fin del for para los datos del cliente
			
		}//Fin del for para la lista de setEmbRefNoAct		
			
	}*/

	//SE ESTA USUANDO ACTUALMENTE EN LA CLASE DE DCT_ComercialDirectory_cls
	public static void ActualizaInvestigacionesEsc1PosSI(String sIdEambudos, Boolean bLimpiaCampos){
		//Consulta el catalogo que se va a crear para ese proposito
	}
		
	/*//Función que permite calcular la dedad de una persona
    @future(callout=true)
	public static void ActualizaInvestigacionesEsc1PosSI(String sIdEambudos, Boolean bLimpiaCampos){
		System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc1PosSI: ' + sIdEambudos + ' bLimpiaCampos: ' + bLimpiaCampos);
		
		String sRespWs = '';
		String sMsgFinal = '';
		Boolean bMsgFinalSuccess = false;
		Boolean bMsgFinalError = false;
		Map<String, Cliente__c> mapDirComUpd = new Map<String, Cliente__c>();
		Cliente__c DatosDirComercialUps = new Cliente__c();
		
		//Crea la lista para los id de los Embudos que se estan actualizando
		List<String> lIdEmbudosPaso = sIdEambudos.split(',');
		Set<String> setEmbRefAct = new Set<String>();
		Set<String> setEmbRefNoAct = new Set<String>();		
		System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc1PosSI lIdEmbudosPaso: ' + lIdEmbudosPaso);

		//Ve si ya tienen folio los embudos
		for(Cliente__c DirCom : [Select id, DCTRapReference__c From Cliente__c Where ID IN : lIdEmbudosPaso]){
			setEmbRefNoAct.add(DirCom.id);			
		}		

		//Recorre la lista de lIdEmbudosPaso y envia los datos a Telcel
		for (String sIdDirCom : setEmbRefNoAct){

			//Busca los datos de sIdDirCom 
			for (Cliente__c DirCom : [Select id, Name, Cliente__r.RFC__c, DCTInvestigation__c,
					DCTCommentsInvestigation__c, DCTResultVerification__c, DCTTypeAuthorization__c
					From Cliente__c Where ID = :sIdDirCom]){
					System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc1PosSI DirCom: ' + DirCom);
				    DatosDirComercialUps = new Cliente__c(id = DirCom.id);
				    
				//Crea el llamado al Ws de referencia rap
				if (DirCom.Name != null) {
			    	
			    	String sCommInvestigaPaso = '';
	    			sCommInvestigaPaso += DirCom.DCTCommentsInvestigation__c != null ?  DirCom.DCTCommentsInvestigation__c : ' - ';
			    	
			    	try{
				    	System.debug('EN Utils.ActualizaFuerzaVetaWs DirCom.Name: ' + DirCom.Name + ' DirCom.DCTResultVerification__c: ' + DirCom.DCTInvestigation__c + ' sCommInvestigaPaso: ' + sCommInvestigaPaso);
			    		
						//Por aqui mandamos llamar el WebService de directorioEmpleados/ConsultarEmpleado/			
					    DCT_Investigaciones_ws.ResponseWrapper objClsInvest = DCT_Investigaciones_ws.Investigaciones(DirCom.Name, 
					    	DirCom.DCTInvestigation__c, sCommInvestigaPaso); 
						System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc1PosSI objClsInvest: ' + objClsInvest);
						System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc1PosSI bLimpiaCampos: ' + bLimpiaCampos);
													    	
					    //Ve si no hubo error a la hora de responder del servicio
					    if (objClsInvest.EstatusConsulta == 0 || objClsInvest.EstatusConsulta == 2){
				    		DatosDirComercialUps.DCTResearchLegend__c = objClsInvest.Leyenda;
				    		DatosDirComercialUps.DCTResultVerification__c = objClsInvest.Estado;
					    	DatosDirComercialUps.DCTTypeAuthorization__c = DirCom.DCTResultVerification__c;		    	
					    	DatosDirComercialUps.DCTInvestigation__c = DirCom.DCTInvestigation__c;
					    	if (bLimpiaCampos){
						    	DatosDirComercialUps.DCTTypeAuthorization__c = null;
					    		DatosDirComercialUps.DCTAuthorizationDateVoBoManagement__c = null;
					    		DatosDirComercialUps.DCTAskAuthorization__c = false;					    		
					    		DatosDirComercialUps.DCTResultVerificationEsp__c = null;
					    		DatosDirComercialUps.DCTComentariosAutorizacion__c = null;					    		
					    	}//Fin si bActCampos

							System.debug('EN Utils.ActualizaImvestigacionesWs el DatosDirComercialUps: ' + DatosDirComercialUps);
					    	//Actualiza el reg y actualiza la pagina
							DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');					    	
							Database.Saveresult Dtupr = Database.update(DatosDirComercialUps, false);
							//No hubo error
				   			if (Dtupr.isSuccess())
				   				System.debug('EN Utils.ActualizaImvestigacionesWs el ID: ' + Dtupr.getId());
				   			//Hubo error
				   			if (!Dtupr.isSuccess()){
				   				DatosDirComercialUps.DCT_DetalleErrorInvest__c = Dtupr.getErrors()[0].getMessage();   				
				   				System.debug('EN Utils.ActualizaImvestigacionesWs ERROR aL ACTUALIZAR: ' + Dtupr.getErrors()[0].getMessage());
				   			}//Fin si !Dtupr.isSuccess()
						    if (objClsInvest.EstatusConsulta == 2){
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = objClsInvest.Descripcion;
						    }//Fin si objClsInvest.EstatusConsulta == 2
	
					    }//Fin si objClsInvest.ErrorID == NULL    	
			
						//Si hay error
					    if (objClsInvest.EstatusConsulta != 0 && objClsInvest.EstatusConsulta != 2){
							bMsgFinalError = true;
							if (objClsInvest.Message == null && objClsInvest.ExceptionMessage == null)
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = 'Time Out';				
							else	
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = objClsInvest.Message + ' ' + objClsInvest.ExceptionMessage;
					    }//Fin si objClsInvest.EstatusConsulta != 0 && objClsInvest.EstatusConsulta != 2
					
			    	}Catch(Exception ex){
						DatosDirComercialUps.DCT_DetalleErrorInvest__c = 'Time Out';			    		
			    	}
										
				}//Fin si DirCom.Cliente__r.RFC__c != null
			
			}//Fin del for para los datos del cliente
			
		}//Fin del for para la lista de setEmbRefNoAct		
			
	}*/
	
	
	//SE ESTA USUANDO ACTUALMENTE EN LA CLASE DE DCT_ComercialDirectory_cls
	public static void ActualizaInvestigacionesEsc2NegCAprob(String sIdEambudos){
		//Consulta el catalogo que se va a crear para ese proposito
	}
		
	/*//Función que permite calcular la dedad de una persona
    @future(callout=true)
	public static void ActualizaInvestigacionesEsc2NegCAprob(String sIdEambudos){
		System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc2NegCAprob: ' + sIdEambudos);
		
		String sRespWs = '';
		String sMsgFinal = '';
		Boolean bMsgFinalSuccess = false;
		Boolean bMsgFinalError = false;
		Map<String, Cliente__c> mapDirComUpd = new Map<String, Cliente__c>();
		Cliente__c DatosDirComercialUps = new Cliente__c();
		
		//Crea la lista para los id de los Embudos que se estan actualizando
		List<String> lIdEmbudosPaso = sIdEambudos.split(',');
		Set<String> setEmbRefAct = new Set<String>();
		Set<String> setEmbRefNoAct = new Set<String>();		
		System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc2NegCAprob lIdEmbudosPaso: ' + lIdEmbudosPaso);

		//Ve si ya tienen folio los embudos
		for(Cliente__c DirCom : [Select id, DCTRapReference__c From Cliente__c Where ID IN : lIdEmbudosPaso]){
			setEmbRefNoAct.add(DirCom.id);			
		}		

		//Recorre la lista de lIdEmbudosPaso y envia los datos a Telcel
		for (String sIdDirCom : setEmbRefNoAct){
			String sComentariosProceso;
			
			//Busca los datos de sIdDirCom 
			for (Cliente__c DirCom : [Select id, Name, Cliente__r.RFC__c, DCTInvestigation__c,
					DCTCommentsInvestigation__c, DCTResultVerification__c, DCTTypeAuthorization__c
					From Cliente__c Where ID = :sIdDirCom]){
					System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc2NegCAprob DirCom: ' + DirCom);
				    DatosDirComercialUps = new Cliente__c(id = DirCom.id);
				    
				//Crea el llamado al Ws de referencia rap
				if (DirCom.Name != null && DirCom.DCTResultVerification__c != null) {
			    	
			    	String sCommInvestigaPaso = '';
					//Busca los comentarios del proceso de aprobación asociado a este reg			    	
			    	if (DirCom.DCTResultVerification__c == 'NEGATIVA'){
				    	DirCom.DCTInvestigation__c = DirCom.DCTInvestigation__c;
						System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc2NegCAprob ANTES DE EN TRAR A buscaComentariosProceso...');
						sComentariosProceso = buscaComentariosProceso(DirCom.id);
			    		sCommInvestigaPaso = DirCom.DCTTypeAuthorization__c; //'Vo. Bo. Subdirector';
			    		sCommInvestigaPaso += sComentariosProceso != null ? ' - ' + sComentariosProceso : ' - ';			    		
			    	}//Fin si DirCom.DCTResultVerification__c == 'NEGATIVA'
			    	
			    	try{
				    	System.debug('EN Utils.ActualizaFuerzaVetaWs DirCom.Name: ' + DirCom.Name + ' DirCom.DCTResultVerification__c: ' + DirCom.DCTInvestigation__c + ' sCommInvestigaPaso: ' + sCommInvestigaPaso);
			    		
						//Por aqui mandamos llamar el WebService de directorioEmpleados/ConsultarEmpleado/			
					    DCT_Investigaciones_ws.ResponseWrapper objClsInvest = DCT_Investigaciones_ws.Investigaciones(DirCom.Name, 
					    	DirCom.DCTInvestigation__c, sCommInvestigaPaso); 
						System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc2NegCAprob objClsInvest: ' + objClsInvest);
							    	
					    //Ve si no hubo error a la hora de responder del servicio
					    if (objClsInvest.EstatusConsulta == 0 || objClsInvest.EstatusConsulta == 2){
				    		DatosDirComercialUps.DCTResearchLegend__c = objClsInvest.Leyenda;
				    		DatosDirComercialUps.DCTResultVerification__c = objClsInvest.Estado;
					    	DatosDirComercialUps.DCTTypeAuthorization__c = DirCom.DCTTypeAuthorization__c; //'Vo.Bo. Subdirector';		    	
					    	DatosDirComercialUps.DCTInvestigation__c = DirCom.DCTInvestigation__c;					    			    	
					    	DatosDirComercialUps.DCTCommentsInvestigation__c = sComentariosProceso;
							System.debug('EN Utils.ActualizaImvestigacionesWs el DatosDirComercialUps: ' + DatosDirComercialUps);

							DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');																
					    	//Actualiza el reg y actualiza la pagina
							Database.Saveresult Dtupr = Database.update(DatosDirComercialUps, false);
							
							//No hubo error
				   			if (Dtupr.isSuccess())
				   				System.debug('EN Utils.ActualizaImvestigacionesWs el ID: ' + Dtupr.getId());
				   			//Hubo error
				   			if (!Dtupr.isSuccess()){
				   				DatosDirComercialUps.DCT_DetalleErrorInvest__c = Dtupr.getErrors()[0].getMessage();   				
				   				System.debug('EN Utils.ActualizaImvestigacionesWs ERROR aL ACTUALIZAR: ' + Dtupr.getErrors()[0].getMessage());
				   			}//Fin si !Dtupr.isSuccess()
						    if (objClsInvest.EstatusConsulta == 2){
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = objClsInvest.Descripcion;
						    }//Fin si objClsInvest.EstatusConsulta == 2
	
					    }//Fin si objClsInvest.ErrorID == NULL    	
			
						//Si hay error
					    if (objClsInvest.EstatusConsulta != 0 && objClsInvest.EstatusConsulta != 2){
							bMsgFinalError = true;
							if (objClsInvest.Message == null && objClsInvest.ExceptionMessage == null)
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = 'Time Out';				
							else	
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = objClsInvest.Message + ' ' + objClsInvest.ExceptionMessage;
					    }//Fin si objClsInvest.EstatusConsulta != 0 && objClsInvest.EstatusConsulta != 2
					
			    	}Catch(Exception ex){
						DatosDirComercialUps.DCT_DetalleErrorInvest__c = 'Time Out';			    		
			    	}
										
				}//Fin si DirCom.Cliente__r.RFC__c != null
			
			}//Fin del for para los datos del cliente
			
		}//Fin del for para la lista de setEmbRefNoAct		
			
	}*/

	//SE ESTA USUANDO ACTUALMENTE EN LA CLASE DE DCT_ComercialDirectory_cls
	public static void ActualizaInvestigacionesEsc3SinInvestiga(String sIdEambudos){
		//Consulta el catalogo que se va a crear para ese proposito
	}
		
	/*//Función que permite calcular la dedad de una persona
    @future(callout=true)
	public static void ActualizaInvestigacionesEsc3SinInvestiga(String sIdEambudos){
		System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc3SinInvestiga: ' + sIdEambudos);
		
		String sRespWs = '';
		String sMsgFinal = '';
		Boolean bMsgFinalSuccess = false;
		Boolean bMsgFinalError = false;
		Map<String, Cliente__c> mapDirComUpd = new Map<String, Cliente__c>();
		Cliente__c DatosDirComercialUps = new Cliente__c();
		
		//Crea la lista para los id de los Embudos que se estan actualizando
		List<String> lIdEmbudosPaso = sIdEambudos.split(',');
		Set<String> setEmbRefAct = new Set<String>();
		Set<String> setEmbRefNoAct = new Set<String>();		
		System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc3SinInvestiga lIdEmbudosPaso: ' + lIdEmbudosPaso);

		//Ve si ya tienen folio los embudos
		for(Cliente__c DirCom : [Select id, DCTRapReference__c From Cliente__c Where ID IN : lIdEmbudosPaso]){
			setEmbRefNoAct.add(DirCom.id);			
		}		

		//Recorre la lista de lIdEmbudosPaso y envia los datos a Telcel
		for (String sIdDirCom : setEmbRefNoAct){
			String sComentariosProceso;
			
			//Busca los datos de sIdDirCom 
			for (Cliente__c DirCom : [Select id, Name, Cliente__r.RFC__c, DCTInvestigation__c,
					DCTCommentsInvestigation__c, DCTResultVerification__c, DCTTypeAuthorization__c
					From Cliente__c Where ID = :sIdDirCom]){
					System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc3SinInvestiga DirCom: ' + DirCom);
				    DatosDirComercialUps = new Cliente__c(id = DirCom.id);
				    
				//Crea el llamado al Ws de referencia rap
				if (DirCom.Name != null) {
			    	
			    	String sCommInvestigaPaso = '';
					//Busca los comentarios del proceso de aprobación asociado a este reg			    	
			    	DirCom.DCTInvestigation__c = 'SI';
					System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc3SinInvestiga ANTES DE EN TRAR A buscaComentariosProceso...');
					sComentariosProceso = buscaComentariosProceso(DirCom.id);
		    		sCommInvestigaPaso = DirCom.DCTTypeAuthorization__c; //'Vo. Bo. Subdirector';
		    		sCommInvestigaPaso += sComentariosProceso != null ? ' - ' + sComentariosProceso : ' - ';
			    	
			    	try{
				    	System.debug('EN Utils.ActualizaFuerzaVetaWs DirCom.Name: ' + DirCom.Name + ' DirCom.DCTResultVerification__c: ' + DirCom.DCTInvestigation__c + ' sCommInvestigaPaso: ' + sCommInvestigaPaso);
			    		
						//Por aqui mandamos llamar el WebService de directorioEmpleados/ConsultarEmpleado/			
					    DCT_Investigaciones_ws.ResponseWrapper objClsInvest = DCT_Investigaciones_ws.Investigaciones(DirCom.Name, 
					    	DirCom.DCTInvestigation__c, sCommInvestigaPaso); 
						System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc3SinInvestiga objClsInvest: ' + objClsInvest);
							    	
					    //Ve si no hubo error a la hora de responder del servicio
					    if (objClsInvest.EstatusConsulta == 0 || objClsInvest.EstatusConsulta == 2){
				    		DatosDirComercialUps.DCTResearchLegend__c = objClsInvest.Leyenda;
				    		DatosDirComercialUps.DCTResultVerification__c = objClsInvest.Estado;
					    	DatosDirComercialUps.DCTTypeAuthorization__c = DirCom.DCTTypeAuthorization__c; //'Vo.Bo. Subdirector';		    	
					    	DatosDirComercialUps.DCTInvestigation__c = DirCom.DCTInvestigation__c;					    			    	
					    	DatosDirComercialUps.DCTCommentsInvestigation__c = sComentariosProceso;
					    	//Si se requiere poner las lineas que esta autorizando.
					    	//DatosDirComercialUps.DCTTotLineasAutorInvest__c = sNoLineasAprobadas;
							System.debug('EN Utils.ActualizaImvestigacionesWs el DatosDirComercialUps: ' + DatosDirComercialUps);

							DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');																
					    	//Actualiza el reg y actualiza la pagina
							Database.Saveresult Dtupr = Database.update(DatosDirComercialUps, false);
							
							//No hubo error
				   			if (Dtupr.isSuccess())
				   				System.debug('EN Utils.ActualizaImvestigacionesWs el ID: ' + Dtupr.getId());
				   			//Hubo error
				   			if (!Dtupr.isSuccess()){
				   				DatosDirComercialUps.DCT_DetalleErrorInvest__c = Dtupr.getErrors()[0].getMessage();   				
				   				System.debug('EN Utils.ActualizaImvestigacionesWs ERROR aL ACTUALIZAR: ' + Dtupr.getErrors()[0].getMessage());
				   			}//Fin si !Dtupr.isSuccess()
						    if (objClsInvest.EstatusConsulta == 2){
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = objClsInvest.Descripcion;
						    }//Fin si objClsInvest.EstatusConsulta == 2
	
					    }//Fin si objClsInvest.ErrorID == NULL    	
			
						//Si hay error
					    if (objClsInvest.EstatusConsulta != 0 && objClsInvest.EstatusConsulta != 2){
							bMsgFinalError = true;
							if (objClsInvest.Message == null && objClsInvest.ExceptionMessage == null)
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = 'Time Out';				
							else	
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = objClsInvest.Message + ' ' + objClsInvest.ExceptionMessage;
					    }//Fin si objClsInvest.EstatusConsulta != 0 && objClsInvest.EstatusConsulta != 2
					
			    	}Catch(Exception ex){
						DatosDirComercialUps.DCT_DetalleErrorInvest__c = 'Time Out';			    		
			    	}
										
				}//Fin si DirCom.Cliente__r.RFC__c != null
			
			}//Fin del for para los datos del cliente
			
		}//Fin del for para la lista de setEmbRefNoAct		
			
	}*/
	
	//SE ESTA USUANDO ACTUALMENTE EN LA CLASE DE DCT_ComercialDirectory_cls
	public static void ActualizaInvestigacionesEsc4IT(String sIdEambudos){
		//Consulta el catalogo que se va a crear para ese proposito
	}

	/*//Función que permite calcular la dedad de una persona
    @future(callout=true)
	public static void ActualizaInvestigacionesEsc4IT(String sIdEambudos){
		System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc4IT: ' + sIdEambudos);
		
		String sRespWs = '';
		String sMsgFinal = '';
		Boolean bMsgFinalSuccess = false;
		Boolean bMsgFinalError = false;
		Map<String, Cliente__c> mapDirComUpd = new Map<String, Cliente__c>();
		Cliente__c DatosDirComercialUps = new Cliente__c();
		
		//Crea la lista para los id de los Embudos que se estan actualizando
		List<String> lIdEmbudosPaso = sIdEambudos.split(',');
		Set<String> setEmbRefAct = new Set<String>();
		Set<String> setEmbRefNoAct = new Set<String>();		
		System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc4IT lIdEmbudosPaso: ' + lIdEmbudosPaso);

		//Ve si ya tienen folio los embudos
		for(Cliente__c DirCom : [Select id, DCTRapReference__c From Cliente__c Where ID IN : lIdEmbudosPaso]){
			setEmbRefNoAct.add(DirCom.id);			
		}		

		//Recorre la lista de lIdEmbudosPaso y envia los datos a Telcel
		for (String sIdDirCom : setEmbRefNoAct){
			String sComentariosProceso;
			
			//Busca los datos de sIdDirCom 
			for (Cliente__c DirCom : [Select id, Name, Cliente__r.RFC__c, DCTInvestigation__c,
					DCTCommentsInvestigation__c, DCTResultVerification__c, DCTTypeAuthorization__c
					From Cliente__c Where ID = :sIdDirCom]){
					System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc4IT DirCom: ' + DirCom);
				    DatosDirComercialUps = new Cliente__c(id = DirCom.id);
				    
				//Crea el llamado al Ws de referencia rap
				if (DirCom.Name != null) {
			    	
			    	String sCommInvestigaPaso = '';
					//Busca los comentarios del proceso de aprobación asociado a este reg			    	
			    	if (DirCom.DCTResultVerification__c != null || DirCom.DCTResultVerification__c == null){
				    	DirCom.DCTInvestigation__c = 'IT';
						System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc4IT ANTES DE EN TRAR A buscaComentariosProceso...');
						sComentariosProceso = buscaComentariosProceso(DirCom.id);
			    		sCommInvestigaPaso = DirCom.DCTTypeAuthorization__c; //'Vo. Bo. Subdirector';
			    		sCommInvestigaPaso += sComentariosProceso != null ? ' - ' + sComentariosProceso : ' - ';
			    	}//Fin si DirCom.DCTResultVerification__c == 'NEGATIVA'
			    	
			    	try{
				    	System.debug('EN Utils.ActualizaFuerzaVetaWs DirCom.Name: ' + DirCom.Name + ' DirCom.DCTResultVerification__c: ' + DirCom.DCTInvestigation__c + ' sCommInvestigaPaso: ' + sCommInvestigaPaso);
			    		
						//Por aqui mandamos llamar el WebService de directorioEmpleados/ConsultarEmpleado/			
					    DCT_Investigaciones_ws.ResponseWrapper objClsInvest = DCT_Investigaciones_ws.Investigaciones(DirCom.Name, 
					    	DirCom.DCTInvestigation__c, sCommInvestigaPaso); 
						System.debug('ENTRO A Utils.ActualizaInvestigacionesEsc4IT objClsInvest: ' + objClsInvest);
							    	
					    //Ve si no hubo error a la hora de responder del servicio
					    if (objClsInvest.EstatusConsulta == 0 || objClsInvest.EstatusConsulta == 2){
				    		DatosDirComercialUps.DCTResearchLegend__c = objClsInvest.Leyenda;
				    		DatosDirComercialUps.DCTResultVerification__c = objClsInvest.Estado;
					    	DatosDirComercialUps.DCTTypeAuthorization__c = DirCom.DCTTypeAuthorization__c; //'Vo.Bo. Subdirector';		    	
					    	DatosDirComercialUps.DCTInvestigation__c = DirCom.DCTInvestigation__c;					    			    	
					    	DatosDirComercialUps.DCTCommentsInvestigation__c = sComentariosProceso;
					    	//DatosDirComercialUps.DCTTotLineasAutorInvest__c = '0';
							System.debug('EN Utils.ActualizaInvestigacionesEsc4SinInvestiga el DatosDirComercialUps: ' + DatosDirComercialUps);

							DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');																
					    	//Actualiza el reg y actualiza la pagina
							Database.Saveresult Dtupr = Database.update(DatosDirComercialUps, false);
							
							//No hubo error
				   			if (Dtupr.isSuccess())
				   				System.debug('EN Utils.ActualizaInvestigacionesEsc4SinInvestiga el ID: ' + Dtupr.getId());
				   			//Hubo error
				   			if (!Dtupr.isSuccess()){
				   				DatosDirComercialUps.DCT_DetalleErrorInvest__c = Dtupr.getErrors()[0].getMessage();   				
				   				System.debug('EN Utils.ActualizaInvestigacionesEsc4SinInvestiga ERROR aL ACTUALIZAR: ' + Dtupr.getErrors()[0].getMessage());
				   			}//Fin si !Dtupr.isSuccess()
						    if (objClsInvest.EstatusConsulta == 2){
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = objClsInvest.Descripcion;
						    }//Fin si objClsInvest.EstatusConsulta == 2
	
					    }//Fin si objClsInvest.ErrorID == NULL    	
			
						//Si hay error
					    if (objClsInvest.EstatusConsulta != 0 && objClsInvest.EstatusConsulta != 2){
							bMsgFinalError = true;
							if (objClsInvest.Message == null && objClsInvest.ExceptionMessage == null)
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = 'Time Out';				
							else	
								DatosDirComercialUps.DCT_DetalleErrorInvest__c = objClsInvest.Message + ' ' + objClsInvest.ExceptionMessage;
					    }//Fin si objClsInvest.EstatusConsulta != 0 && objClsInvest.EstatusConsulta != 2
					
			    	}Catch(Exception ex){
						DatosDirComercialUps.DCT_DetalleErrorInvest__c = 'Time Out';			    		
			    	}
										
				}//Fin si DirCom.Cliente__r.RFC__c != null
			
			}//Fin del for para los datos del cliente
			
		}//Fin del for para la lista de setEmbRefNoAct		
			
	} */
		
	public static String buscaComentariosProceso(String sIdReg){
		System.debug('EN buscaComentariosProceso sIdReg: ' + sIdReg);
		String sComentarios;
		
		//Consulta los comentarios en el objeto de paso 
		for (DCT_ComentariosProceso__c objComProc : [Select DCT_Comentario__c , DCT_NoLineasAprobadas__c
			From DCT_ComentariosProceso__c
			Where DCT_IdRegProcesoAproba__c =:sIdReg]){
			sComentarios = objComProc.DCT_Comentario__c;
			sNoLineasAprobadas = objComProc.DCT_NoLineasAprobadas__c;
		}

		//for (ProcessInstance objProcessInstance : [Select p.Status, p.ProcessDefinitionId,
		//		(Select StepStatus, Comments, StepNodeId From Steps  ORDER BY CreatedDate DESC LIMIT 1 ) 
		//	From ProcessInstance p Where p.TargetObjectId =: sIdReg
		//	And p.ProcessDefinition.DeveloperName = 'DCTResearchResults1a3']){
			//Ve si tiene reg asocjiados del tipo Steps
		//	if (!objProcessInstance.Steps.isEmpty()){				
		//		for(ProcessInstanceStep paso : objProcessInstance.Steps){
		//			System.debug('EN buscaComentariosProceso paso: ' + paso);					
		//			//Toma los comentarios
		//			sComentarios = paso.Comments;
		//		}
		//	}//Fin si objProcessInstance.Steps.isEmpty()
		//}
		
		//Consulta los datos de paso que sele correspinde al proceso
		System.debug('EN buscaComentariosProceso sComentarios: ' + sComentarios);
		
		//Regresa los comentarios
		return sComentarios; 
	}

    
}