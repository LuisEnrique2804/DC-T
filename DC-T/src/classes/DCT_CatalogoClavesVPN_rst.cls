public with sharing class DCT_CatalogoClavesVPN_rst {

 	public static Map<String, EndpointSetting__mdt> mapEndpointSettingMdt = DCT_Utils_cls.getEndpointSettingMdt();

	//Una clase para la la lista de productos y el error si es que existe
	public class classRespuestaTelcel{
		public List<listaProductosVPN> productoVPNListField {get;set;}
		public String Message {get;set;}		
		public String ExceptionMessage {get;set;}		
		public String ExceptionType {get;set;}		
		public String StackTrace {get;set;}
	}
 	
 	//Una clase intermedia para regresar el detalle del producto
	public class listaProductosVPN{
		public DTOProductoField productoField {get;set;}
	}	
	
	//La clase con el detalle del producto productoField
 	public class DTOProductoField{
 		public Decimal costoField {get;set;} 		
		public String descripcionField {get;set;} 		 		
		public String claveProductoField {get;set;}		
 	}
	
	//El metodo para obtener las claves VPN
	public static classRespuestaTelcel getCatalogoClavesVPN(String sBody){
		System.debug('EN DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN sBody: ' + sBody);
		
		//Un objeto del tipo classRespuestaTelcel para la respuesta
    	classRespuestaTelcel objDtRespuesta = new classRespuestaTelcel();
		
		//Obten el Token con el metodo de DCT_Utils_cls.LoginTelcel()
		DCT_Utils_cls.DtRespuestaTelcel objDtRespuestaTelcel;
		//Si no es una prueba
		if (!Test.isRunningTest())
			objDtRespuestaTelcel = DCT_Utils_cls.LoginTelcel();			
		if (Test.isRunningTest()){
			objDtRespuestaTelcel = new DCT_Utils_cls.DtRespuestaTelcel();
			objDtRespuestaTelcel.access_token = 'access_token';
			objDtRespuestaTelcel.token_type = 'token_type';
			objDtRespuestaTelcel.expires_in = 120;
		}//Fin si Test.isRunningTest()
		System.debug('EN DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN objDtRespuestaTelcel: ' + objDtRespuestaTelcel);
				
		//Ve si no hubo error a la hora de hacer el login a Telcel
		if (objDtRespuestaTelcel.error != null){
			//Ve si fue un error de Time Out
			if (objDtRespuestaTelcel.error_description.contains('Read timed out')){
				DCT_Utils_cls.DtRespuestaTelcel objDtRespuestaTelcel2 = DCT_Utils_cls.LoginTelcel();
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoClavesVPN objDtRespuestaTelcel2: ' + objDtRespuestaTelcel2);				
				if (objDtRespuestaTelcel2.error != null)
					objDtRespuestaTelcel.error_description = null;
			}//Fin si objDtRespuestaTelcel.error_description.contains('Read timed out')
		}//Fin si objDtRespuestaTelcel.error != null
		System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoClavesVPN objDtRespuestaTelcel.2: ' + objDtRespuestaTelcel);
						
		//No hubo error a la hora de hacer el login a Telcel
		if (objDtRespuestaTelcel.error == null){
	    	    	
	    	//Toma los datos para los parametros de la conexion a Telcel del mapa de mapEndpointSettingMdt
	    	EndpointSetting__mdt objEndpointSettingMdt = mapEndpointSettingMdt.get('CatalogoClavesVPN');
			System.debug('EN DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN objEndpointSettingMdt: ' + objEndpointSettingMdt);
						
			try{
	    	
				//Una prueba utilzando HTTP 
				HttpRequest request = new HttpRequest();
				request.setMethod(objEndpointSettingMdt.ServiceMethod__c); //'POST'
				request.setHeader('Content-Type', objEndpointSettingMdt.RequestBodyType__c);
				request.setHeader('Host', objEndpointSettingMdt.ServiceProvider__c);				
				request.setHeader('Authorization', 'Bearer ' + objDtRespuestaTelcel.access_token);				
				request.setHeader('Cache-Control', 'no-cache');  			
				request.setEndpoint(objEndpointSettingMdt.Endpoint__c);					
				request.setTimeout(Integer.valueOf(objEndpointSettingMdt.Timeout__c));
				request.setTimeout(120000);				
							
				//JSONBody = EncodingUtil.urlEncode(JSONBody, 'UTF-8');
				String JSONBody = sBody; //'["9","CC"]';
				//Incializa el Body con JSONBody						
				request.setBody(JSONBody);
	
				System.debug('EN DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN endpoint: ' + objEndpointSettingMdt.Endpoint__c);
				System.debug('EN DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN Accept: ' + request.getHeader('Accept'));			
				System.debug('EN DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN Content-Type: ' + request.getHeader('Content-Type'));
				System.debug('EN DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN Cache-Control: ' + request.getHeader('Cache-Control'));
				System.debug('EN DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN Authorization: ' + request.getHeader('Authorization'));										
				System.debug('EN DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN JSONBody: ' + JSONBody);
	
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
					sJasonRes = '{"productoVPNListField":[{"productoField":{"costoField":100.00,"descripcionField":"VCCA1 Red Privada CC","claveProductoField":"VCCA1"}},{"productoField":{"costoField":50.00,"descripcionField":"VCCA2 Red Privada CC","claveProductoField":"VCCA2"}}]}';										
				System.debug('EN getCatalogoClavesVPN HTTP: ' + res + ' sJasonRes: ' + sJasonRes);
	
				if (String.valueOf(res).contains('200') || Test.isRunningTest()){
					//Seriarliza la respuesta del servicio
					classRespuestaTelcel objDtRespuestaPaso = JSONParserRespTelcel(String.valueOf(sJasonRes));
					objDtRespuesta.productoVPNListField = objDtRespuestaPaso.productoVPNListField;								
					objDtRespuesta.Message = objDtRespuestaPaso.Message;
					objDtRespuesta.ExceptionMessage = objDtRespuestaPaso.ExceptionMessage;
					objDtRespuesta.ExceptionType = objDtRespuestaPaso.ExceptionType;
					objDtRespuesta.StackTrace = objDtRespuestaPaso.StackTrace;
					System.debug('ANTES DE SALIR DE getCatalogoClavesVPN objDtRespuesta: ' + objDtRespuesta);				
				}//Fin si String.valueOf(res).contains('200') || Test.isRunningTest()
				//Ve si el campo JsonRes tiene algo
				if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') || Test.isRunningTest()){
					if (Test.isRunningTest())					
						sJasonRes = '{"Message": "Error.","ExceptionMessage": "Error en consultar Informacion de Productos VPN","ExceptionType": "System.ApplicationException","StackTrace": "at Telcel.R9.CatalogoVPN.Negocio.ClaveVPN.ConsultarInformacion(String pRegion, String pTipoVPN)\r\n   at Telcel.R9.CatalogoVPN.Negocio.Servicios.Rest.Controllers.ClaveVPNController.ConsultarInformacion(List`1 pDatosVPN)"}';										
					classRespuestaTelcel objDtRespuestaPaso = JSONParserRespTelcel(String.valueOf(sJasonRes));
					objDtRespuesta.Message = objDtRespuestaPaso.Message;
					objDtRespuesta.ExceptionMessage = objDtRespuestaPaso.ExceptionMessage;
					objDtRespuesta.ExceptionType = objDtRespuestaPaso.ExceptionType;
					objDtRespuesta.StackTrace = objDtRespuestaPaso.StackTrace;
					System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO getCatalogoClavesVPN objDtRespuesta: ' + objDtRespuesta);
				}//Fin si sJasonRes != null && sJasonRes.length() == 0			
	
			}catch(Exception ex){
				System.debug('ERROR EN DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN AL HACER EL LLAMADO AL WS: ' + ex.getMessage());
				objDtRespuesta.Message = ex.getMessage();
				objDtRespuesta.ExceptionMessage = ex.getMessage();
				objDtRespuesta.ExceptionType = ex.getMessage();
			}
			
		}//Fin si objDtRespuestaTelcel.error == null

		//Regresa el objeto de objDtRespuesta     	
    	return objDtRespuesta;
		
	}

	//Regresa un objeto del tipo DtRespuestaTelcel si no hubo error a la hora de registrar el cliente		
	public static classRespuestaTelcel JSONParserRespTelcel(String sJsonResp){
		System.debug('EN DCT_CatalogoClavesVPN_rst.Login: sJsonResp: ' + sJsonResp);
		
		classRespuestaTelcel objAPPResp = new classRespuestaTelcel();		
	
		try{
            JSONParser parser = JSON.createParser(sJsonResp);
            //Ve si tiene algo el objeto de parser  
            while (parser.nextToken() != null) {//{"error": "invalid_client","error_description": "Las credenciales proporcionadas no son correctas."}
				//Inicia el detalle del objeto: sNombreObj
				if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
					//Inicia el arreglo
					objAPPResp = (classRespuestaTelcel)parser.readValueAs(classRespuestaTelcel.class);							
				}//Fin si parser.getCurrentToken() == JSONToken.START_OBJECT
            }//Fin mientras parser.nextToken() != null
		}catch(Exception ex){
			System.debug('ERROR EN DCT_CatalogoClavesVPN_rst.Login: sJsonResp: ' + ex.getMessage());
	 	}

		System.debug('ANTES DE SALIR DE DCT_CatalogoClavesVPN_rst.Login: objAPPResp: ' + objAPPResp);
			 	
		//Regresa el objeto objSignInClsPaso
		return objAPPResp;
	}
	
}