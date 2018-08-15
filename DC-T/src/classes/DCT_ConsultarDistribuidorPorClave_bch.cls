global class DCT_ConsultarDistribuidorPorClave_bch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{

 	public static Map<String, EndpointSetting__mdt> mapEndpointSettingMdt = DCT_Utils_cls.getEndpointSettingMdt();
    global string query;
    
    //Un constructor por default
    global DCT_ConsultarDistribuidorPorClave_bch(string query){
        this.query = query;
    }
    
    //Start
    global Database.querylocator start(Database.BatchableContext BC){
        System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.start query: ' + this.query);
        return Database.getQueryLocator(this.query);
    }
    
    //Execute
    global void execute(Database.BatchableContext BC, List<User> scope){
        System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.');

    	//Para el servicio de CatalogoFuerzasVenta Sin parametros
    	classRespuestaTelcelTodo objproductosVPNList = getCatalogoFuerzasVenta();
    	//Ve si marco error de time out
    	if (objproductosVPNList.ErrorDescripcion != null){
	    	if (objproductosVPNList.ErrorDescripcion.contains('Read timed out')){
		    	classRespuestaTelcelTodo objproductosVPNList2 = getCatalogoFuerzasVenta();
		        System.debug('EN DCT_ConsultarDistribuidorPorClave_bch objproductosVPNList2: ' + objproductosVPNList2);	    	
	    	}//Fin si objproductosVPNList.ErrorDescripcion.contains('Read timed out')
    	}//Fin si objproductosVPNList.ErrorDescripcion != null
    	
		System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.execute objproductosVPNList: ' + objproductosVPNList);
    	if (objproductosVPNList.ErrorID == null || objproductosVPNList.ErrorID == '0'){ //No hubo error
    		Map<String, DCTSalesForceCatalog__c> mapDATUps = new Map<String, DCTSalesForceCatalog__c>();
    		//Toma la lista de reg que regreso y actualiza el objeto que se llama DCTSalesForceCatalog__c (DAT)
    		if (!objproductosVPNList.FuerzaVentaDistribuidor.isEmpty()){
	    		for (listaFuerzaVentaDistTodo objFerzaVtas : objproductosVPNList.FuerzaVentaDistribuidor){
	    			//Cre los objetos del tipo 
	    			mapDATUps.put(objFerzaVtas.ClavePPAS, new DCTSalesForceCatalog__c(Name = objFerzaVtas.ClavePPAS
	    				, DCTCode__c = objFerzaVtas.ClavePPAS
	    				, DCT_PrepagoSiapID__c = String.valueOf(objFerzaVtas.PrepagoSiapID)
	    				, DCT_EstatusID__c = String.valueOf(objFerzaVtas.EstatusID)
	    				)
	    			);
	    		}//Fin del for para la FuerzaVentaDistribuidor
    		}//Fin si !objproductosVPNList.FuerzaVentaDistribuidor.isEmpty()
    		
    		//Ya tienes los reg que vas a actualizar ejecuta el UPSERT
			List<Database.Upsertresult> lDtbUpsRes = Database.upsert(mapDATUps.Values(), DCTSalesForceCatalog__c.DCTCode__c, false);
			//Ve si hubo error
			for (Database.Upsertresult objDtbUpsRes : lDtbUpsRes){
				if (!objDtbUpsRes.isSuccess())
					System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.execute ERROR : ' + objDtbUpsRes.getErrors()[0].getMessage());				
			}//Fin del for para lDtbUpsRes
			System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.execute objproductosVPNList: ' + objproductosVPNList.ErrorID);    		
			System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.execute objproductosVPNList: ' + objproductosVPNList.ErrorDescripcion);			
    	}
        
    }
    
    //Finish
    global void finish(Database.BatchableContext BC){
        System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.finish Hora: ' + DateTime.now());      
    }

	public class classRespuestaTelcelTodo{
		public String ErrorID {get;set;}		
		public String ErrorDescripcion {get;set;}
		public List<listaFuerzaVentaDistTodo> FuerzaVentaDistribuidor {get;set;}
	}

	public class listaFuerzaVentaDistTodo{
		public String ErrorID {get;set;}
		public String ErrorDescripcion {get;set;}
		public Integer PrepagoSiapID {get;set;}
		public Integer EstatusID {get;set;}
		public String RazonSocial {get;set;}
		public String ClavePPAS {get;set;}
	}

	//El metodo para obtener el catalogo de la fuerza de venta Completa sin parametros
	public static classRespuestaTelcelTodo getCatalogoFuerzasVenta(){
		
		//Un objeto del tipo classRespuestaTelcel para la respuesta
    	classRespuestaTelcelTodo objDtRespuesta = new classRespuestaTelcelTodo();
    			
		//Obten el Token con el metodo de DCT_Utils_cls.LoginTelcel()
		DCT_Utils_cls.DtRespuestaTelcel objDtRespuestaTelcel;
		//Si no es una prueba
		if (!Test.isRunningTest()){
			objDtRespuestaTelcel = DCT_Utils_cls.LoginTelcel();			
			System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.getCatalogoFuerzasVenta objDtRespuestaTelcel: ' + objDtRespuestaTelcel);
			//Ve si no hubo error a la hora de hacer el login a Telcel
			if (objDtRespuestaTelcel.error != null){
				objDtRespuesta.ErrorID = objDtRespuestaTelcel.error;
				objDtRespuesta.ErrorDescripcion = objDtRespuestaTelcel.error_description;
			}//Fin si objDtRespuestaTelcel.error != null
		}//Fin si !Test.isRunningTest()
		
		//Es una prueba
		if (Test.isRunningTest()){
			objDtRespuestaTelcel = new DCT_Utils_cls.DtRespuestaTelcel();
			objDtRespuestaTelcel.access_token = 'access_token';
			objDtRespuestaTelcel.token_type = 'token_type';
			objDtRespuestaTelcel.expires_in = 120;
		}//Fin si Test.isRunningTest()
		System.debug('EN DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN objDtRespuestaTelcel: ' + objDtRespuestaTelcel);
				
		//No hubo error a la hora de hacer el login a Telcel
		if (objDtRespuestaTelcel.error == null){
	    	    	
	    	//Toma los datos para los parametros de la conexion a Telcel del mapa de mapEndpointSettingMdt
	    	EndpointSetting__mdt objEndpointSettingMdt = mapEndpointSettingMdt.get('CatalogoFuerzasVenta');
			System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.getCatalogoFuerzasVenta objEndpointSettingMdt: ' + objEndpointSettingMdt);
						
			try{
	    	
				//Una prueba utilzando HTTP 
				HttpRequest request = new HttpRequest();
				request.setMethod(objEndpointSettingMdt.ServiceMethod__c); //'GET'
				request.setHeader('Content-Type', objEndpointSettingMdt.RequestBodyType__c);
				request.setHeader('Host', objEndpointSettingMdt.ServiceProvider__c);				
				request.setHeader('Authorization', 'Bearer ' + objDtRespuestaTelcel.access_token);				
				request.setHeader('Cache-Control', 'no-cache');
				String sEndPoint = objEndpointSettingMdt.Endpoint__c;   			
				request.setEndpoint(sEndPoint);
				request.setTimeout(120000);
												
				System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.getCatalogoFuerzasVenta endpoint: ' + objEndpointSettingMdt.Endpoint__c);
				System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.getCatalogoFuerzasVenta Accept: ' + request.getHeader('Accept'));			
				System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.getCatalogoFuerzasVenta Content-Type: ' + request.getHeader('Content-Type'));
				System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.getCatalogoFuerzasVenta Host: ' + request.getHeader('Host'));				
				System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.getCatalogoFuerzasVenta Cache-Control: ' + request.getHeader('Cache-Control'));
				System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.getCatalogoFuerzasVenta Authorization: ' + request.getHeader('Authorization'));
	
				HTTPResponse res;
				if (!Test.isRunningTest())				
					res = new Http().send(request);
				if (Test.isRunningTest()){
					res = new HTTPResponse();				
					res.setBody('200');
				}
				String sJasonRes;
				if (!Test.isRunningTest())
					sJasonRes = res.getBody();
				if (Test.isRunningTest())					
					sJasonRes = '{"ErrorID": 0,"ErrorDescripcion": "Consulta Exitosa.","FuerzaVentaDistribuidor": [{"PrepagoSiapID": 17,"RazonSocial": "ASISTENCIA EN TELEFONIA CELULAR, S.A DE C.V","EstatusID": 1,"ClavePPAS": "ASIST"},{"PrepagoSiapID": 20,"RazonSocial": "ATRACCION CELULAR. S. A.DE C.V.","EstatusID": 1,"ClavePPAS": "ATCEL"}]}';										
				System.debug('EN DCT_ConsultarDistribuidorPorClave_bch HTTP: ' + res + ' sJasonRes: ' + sJasonRes);
	
				if (String.valueOf(res).contains('200') || Test.isRunningTest()){
					//Seriarliza la respuesta del servicio
					classRespuestaTelcelTodo objDtRespuestaPaso = JSONParserRespTelcelTodo(String.valueOf(sJasonRes));
					objDtRespuesta.FuerzaVentaDistribuidor = objDtRespuestaPaso.FuerzaVentaDistribuidor;
					//Ve si tiene algo la lista de FuerzaVentaDistribuidor
					if(!objDtRespuesta.FuerzaVentaDistribuidor.isEmpty()){
						objDtRespuesta.ErrorID = objDtRespuesta.FuerzaVentaDistribuidor.get(0).ErrorID;
						objDtRespuesta.ErrorDescripcion = objDtRespuesta.FuerzaVentaDistribuidor.get(0).ErrorDescripcion;
					}//Fin si !objDtRespuesta.FuerzaVentaDistribuidor.isEmpty()
					System.debug('ANTES DE SALIR DE getCatalogoFuerzasVenta NO HUBO ERROR objDtRespuesta: ' + objDtRespuesta);				
				}
				//Ve si el campo JsonRes tiene algo
				if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') || Test.isRunningTest()){
					//Es una prueba
					if(Test.isRunningTest())
						sJasonRes = '{"ErrorID": 1,"ErrorDescripcion": "ERROR","FuerzaVentaDistribuidor": []}';
					classRespuestaTelcelTodo objDtRespuestaPaso = JSONParserRespTelcelTodo(String.valueOf(sJasonRes));
					objDtRespuesta.FuerzaVentaDistribuidor = objDtRespuestaPaso.FuerzaVentaDistribuidor;
					//Ve si tiene algo la lista de FuerzaVentaDistribuidor
					if(!objDtRespuesta.FuerzaVentaDistribuidor.isEmpty()){
						objDtRespuesta.ErrorID = objDtRespuesta.FuerzaVentaDistribuidor.get(0).ErrorID;
						objDtRespuesta.ErrorDescripcion = objDtRespuesta.FuerzaVentaDistribuidor.get(0).ErrorDescripcion;
					}//Fin si !objDtRespuesta.FuerzaVentaDistribuidor.isEmpty()
					System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO getCatalogoFuerzasVenta objDtRespuesta: ' + objDtRespuesta);
				}//Fin si sJasonRes != null && sJasonRes.length() == 0			
				
				//Es una prueba
				if(Test.isRunningTest()){
					sJasonRes = '{"ErrorID": 0,"ErrorDescripcion": "Consulta Exitosa.","FuerzaVentaDistribuidor": [{"PrepagoSiapID": 17,"RazonSocial": "ASISTENCIA EN TELEFONIA CELULAR, S.A DE C.V","EstatusID": 1,"ClavePPAS": "ASIST"},{"PrepagoSiapID": 20,"RazonSocial": "ATRACCION CELULAR. S. A.DE C.V.","EstatusID": 1,"ClavePPAS": "ATCEL"}]}';					
					classRespuestaTelcelTodo objDtRespuestaPaso = JSONParserRespTelcelTodo(String.valueOf(sJasonRes));					
					objDtRespuesta.FuerzaVentaDistribuidor = objDtRespuestaPaso.FuerzaVentaDistribuidor;
					//Ve si tiene algo la lista de FuerzaVentaDistribuidor
					if(!objDtRespuesta.FuerzaVentaDistribuidor.isEmpty()){
						objDtRespuesta.ErrorID = objDtRespuesta.FuerzaVentaDistribuidor.get(0).ErrorID;
						objDtRespuesta.ErrorDescripcion = objDtRespuesta.FuerzaVentaDistribuidor.get(0).ErrorDescripcion;
					}//Fin si !objDtRespuesta.FuerzaVentaDistribuidor.isEmpty()					
				}//Fin si Test.isRunningTest()
				
			}catch(Exception ex){
				System.debug('ERROR EN DCT_ConsultarDistribuidorPorClave_bch.getCatalogoFuerzasVenta AL HACER EL LLAMADO AL WS: ' + ex.getMessage());
				objDtRespuesta.ErrorID = ex.getMessage();
				objDtRespuesta.ErrorDescripcion = ex.getMessage();
			}
			
		}//Fin si objDtRespuestaTelcel.error == null

		System.debug('ANTES DE SALIR DE getCatalogoFuerzasVenta objDtRespuesta: ' + objDtRespuesta);
		//Regresa el objeto de objDtRespuesta     	
    	return objDtRespuesta;
		
	}

	//Regresa un objeto del tipo DtRespuestaTelcel si no hubo error a la hora de registrar el cliente		
	public static classRespuestaTelcelTodo JSONParserRespTelcelTodo(String sJsonResp){
		System.debug('EN DCT_ConsultarDistribuidorPorClave_bch.JSONParserRespTelcelTodo: sJsonResp: ' + sJsonResp);
		
		classRespuestaTelcelTodo objAPPResp = new classRespuestaTelcelTodo();		
	
		try{
            JSONParser parser = JSON.createParser(sJsonResp);
            //Ve si tiene algo el objeto de parser  
            while (parser.nextToken() != null) {//{"error": "invalid_client","error_description": "Las credenciales proporcionadas no son correctas."}
				//Inicia el detalle del objeto: sNombreObj
				if (parser.getCurrentToken() == JSONToken.START_OBJECT) { // 
					//Inicia el arreglo
					objAPPResp = (classRespuestaTelcelTodo)parser.readValueAs(classRespuestaTelcelTodo.class);							
				}//Fin si parser.getCurrentToken() == JSONToken.START_OBJECT
            }//Fin mientras parser.nextToken() != null
		}catch(Exception ex){
			System.debug('ERROR EN DCT_ConsultarDistribuidorPorClave_bch.JSONParserRespTelcelTodo: sJsonResp: ' + ex.getMessage());
	 	}

		System.debug('ANTES DE SALIR DE DCT_ConsultarDistribuidorPorClave_bch.JSONParserRespTelcelTodo: objAPPResp: ' + objAPPResp);
			 	
		//Regresa el objeto objSignInClsPaso
		return objAPPResp;
	}
	
}