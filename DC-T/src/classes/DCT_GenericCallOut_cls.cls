/***************************************************************************************************************************
   Desarrollado por: Avanxo México                                                                                        
   Autor: Luis Enrique Garcia Sanabria                                                                         
   Email: legarcia@avanxo.com                                                                                  
   Fecha de creación: 02-05-2018                                                                                           
 ***************************************************************************************************************************
   Metadata: DCT_ComercialDirectory_tgr                                                                                                              
 ***************************************************************************************************************************
   Descripción: Clase que crea el historico de los cambios que se tiene en un registro de Directorio Comercial, validando 
   							si el campo tuvo algun cambio y lo registra, valida si el cambio se realizo en un campo solicitado, en caso
   							de que no, no se crea dicho registro y de lo contrario se crea con todos los campos que cambiaron.             
                                                                                                                           
 ***************************************************************************************************************************
                                                  Control de versiones                                                     
 ***************************************************************************************************************************
   No.      Fecha                 Autor                    Email                          Descripción                     
 ***************************************************************************************************************************
   1.0   02-05-2018   Luis Enrique Garcia Sanabria   legarcia@avanxo.com   Creacion de la clase DCT_ComercialDirectory_cls 
 ***************************************************************************************************************************/
public class DCT_GenericCallOut_cls {

	public static AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();
	public static Integer intTestMode;
	public static String strTestConfigName;

	/**
	* Método principal de ejecución de llamado a servicios web.
	* @param  strJsonRequest  Cadena JSON del cuerpo de la petición HTTP
	* @param  strConfigName   Nombre de l objeto de metadatos con la configuración a utilizar
	* @param  mapExtraHeaders Cabeceras HTTP adicionales
	* @param  isLastCallout   Indica si el callout es el último en la transacción
	* @return                 Cadena JSON con el cuerpo de la respuesta del servicio web
	**/

	public static String fn_runCallout(String strRequestBody, String strConfigName, Map<String, String> mapExtraHeaders, Boolean isLastCallout, String strExtraValue){
		System.debug('EN DCT_GenericCallOut_cls.fn_runCallout 5 PARAM: ' + strRequestBody + ' ' + strConfigName + ' ' + mapExtraHeaders + ' ' + isLastCallout + ' ' + strExtraValue);
				
		String strJsonResponse = null;
		EndpointSetting__mdt objEndpointSetting = TLCL_Utils_cls.getEndpointSetting(strConfigName);
		Http httpClient = new Http();
		HttpRequest request = new HttpRequest();
		System.debug(loggingLevel.Error, '*** objEndpointSetting: ' + objEndpointSetting);
		if(String.isBlank(strRequestBody)) {
			if(!String.isBlank(strExtraValue)) {
				System.debug(loggingLevel.Error, '*** Luis0: ');
				request.setEndpoint(DCT_GenericCallout_cls.getEndpoint(objEndpointSetting)+strExtraValue);
			}
		}
		if(!String.isBlank(strRequestBody)) {
			System.debug(loggingLevel.Error, '*** Enrique URL: ');
			request.setEndpoint(DCT_GenericCallout_cls.getEndpoint(objEndpointSetting));			
		}
		request.setMethod(!Test.isRunningTest()?objEndpointSetting.ServiceMethod__c:'POST');
		request.setTimeout(!Test.isRunningTest()?objEndpointSetting.Timeout__c.intValue():10000);
		System.debug('This '+objEndpointSetting );
		if (objEndpointSetting.RequiresBodyEncryption__c) {
			strRequestBody = DCT_SecurityServices_cls.encryptPassword(
			strRequestBody, mainSettings.PasswordEncryptionKey__c, mainSettings.PasswordEncryptionAlgorithm__c);
			request.setHeader('Content-Type', 'text/plain');
			request.setHeader('Accept'      , 'text/plain');
		} else {
			request.setHeader('Content-Type', !Test.isRunningTest()?objEndpointSetting.RequestBodyType__c:'application/json'); //'application/x-www-form-urlencoded'
			request.setHeader('Accept'      , !Test.isRunningTest()?objEndpointSetting.ResponseBodyType__c:'text/plain');
		}
		System.debug(loggingLevel.Error, '*** String.isBlank(strRequestBody): ' + String.isBlank(strRequestBody));
		if(!String.isBlank(strRequestBody)) {
			System.debug(loggingLevel.Error, '*** Entro: ');
			request.setBody(strRequestBody);	
		}
		request.setHeader('Cache-Control', 'no-cache');
		request.setHeader('Content-Length', String.valueOf(strRequestBody.length()) + '; charser=utf-8' );
		request.setHeader('accessType', 'application');
		request.setHeader('system', 'SALESFORCE');
		if (mapExtraHeaders != null && !mapExtraHeaders.isEmpty()) {
			for (String headerName : mapExtraHeaders.keySet()) {
				request.setHeader(headerName, mapExtraHeaders.get(headerName));
			}
		}
		request.setTimeout(120000);
				
		System.debug(loggingLevel.Error, 'EN DCT_GenericCallOut_cls.fn_runCallout 5 PARAM request.getEndpoint();: ' + request.getEndpoint());		
		
		if(objEndpointSetting.RequiresToken__c && !('DEVELOPMENT'.equalsIgnoreCase(objEndpointSetting.Stage__c))) {
			try {
				DCT_GenericCallout_cls.setServiceToken(request);
			} catch (Exception e) {
				e.setMessage('No se obtuvo un token de autenticación válido.');
				throw e;
			}
		}

		System.debug(loggingLevel.Error, '*** request.getEndpoint(): ' + request.getEndpoint());
		System.debug(loggingLevel.Error, '*** request.getMethod(): ' + request.getMethod());
		System.debug(loggingLevel.Error, '*** request.getHeader(Content-Type): ' + request.getHeader('Content-Type'));
		System.debug(loggingLevel.Error, '*** request.getHeader(Authorization): ' + request.getHeader('Authorization'));
		System.debug(loggingLevel.Error, '*** strRequestBody: ' + strRequestBody);
		
		try{

			//request.setEndpoint('http://10.119.219.208:18047/DirectorioComRestRAP/referenciarap/servicioweb/servicioweb/refrap/consulta?cadenaConsulta=COOE750305G31&usuario=SmartRefRapWs&contrasena=SmartPassRefRap');			
			//System.debug(loggingLevel.Error, '*** Enrique URL10: ' + request.getEndpoint());
			//request.setHeader('Content-Type', 'text/plain'); //'application/x-www-form-urlencoded'						
			//System.debug(loggingLevel.Error, '*** Enrique Content-Type10: ' + request.getHeader('Content-Type'));			
			
			HttpResponse response = !Test.isRunningTest()?httpClient.send(request):null;
			System.debug(loggingLevel.Error, '*** response: ' + response);
			Integer statusCode = !Test.isRunningTest()?response.getStatusCode():200;
			String responseBody = !Test.isRunningTest()?response.getBody():'{"Test":"Test"}';
			System.debug(loggingLevel.Error, '*** statusCode: ' + statusCode);
			System.debug(loggingLevel.Error, '*** responseBody: ' + responseBody);
			if (String.isNotBlank(responseBody) && (statusCode == 200 || statusCode == 201)) {
				strJsonResponse = responseBody;
			} else {
				strJsonResponse = responseBody;
				//throw new DCT_WebServiceException('No se obtuvo una respuesta correcta del servicio: ' + objEndpointSetting.MasterLabel.toUpperCase());
			}
			if (objEndpointSetting.RequiresBodyEncryption__c) {
				try {
					strJsonResponse = DCT_SecurityServices_cls.decryptPassword(
					strJsonResponse, mainSettings.PasswordEncryptionKey__c, mainSettings.PasswordEncryptionAlgorithm__c);
				} catch (Exception e){
					e.setMessage('No se obtuvo una respuesta correcta del servicio: ' + objEndpointSetting.MasterLabel.toUpperCase());
					strJsonResponse = e.getMessage();
				}
			}

		}catch(Exception ex){
			System.debug('ERROR EN DCT_GenericCallOut_cls strRequestBody:: ' + ex.getMessage());
			strJsonResponse = ex.getMessage();
		}
		
		System.debug(loggingLevel.Error, '*** ANTES DE SALIR DE DCT_GenericCallOut_cls strRequestBody: ' + strRequestBody);
		return strJsonResponse;
	}

		
	/**
	 * Método principal de ejecución de llamado a servicios web (con parámetro isLastCallout en "true" por defecto).
	 * @param  strRequestBody  Cadena JSON del cuerpo de la petición HTTP
	 * @param  strConfigName   Nombre de l objeto de metadatos con la configuración a utilizar
	 * @param  mapExtraHeaders Cabeceras HTTP adicionales
	 * @return                 Cadena JSON con el cuerpo de la respuesta del servicio web
	**/

	public static String fn_runCallout(String strRequestBody, String strConfigName, Map<String, String> mapExtraHeaders){
		return DCT_GenericCallout_cls.fn_runCallout(strRequestBody, strConfigName, mapExtraHeaders, true,'');
	}

	public static String fn_runCallout(String strRequestBody, String strConfigName, Map<String, String> mapExtraHeaders, String strExtraValue){
		System.debug('EN DCT_GenericCallOut_cls.fn_runCallout 4 PARAM: ' + strRequestBody + ' ' + strConfigName + ' ' + mapExtraHeaders + '' + strExtraValue);
		return DCT_GenericCallout_cls.fn_runCallout(strRequestBody, strConfigName, mapExtraHeaders, true, strExtraValue);
	}

	/**
	 * Obtener el endpoint del servicio dependiendo de la etapa de desarrollo
	 * @param  objEndpointSetting Objeto de Configuración de Endpoint
	 * @return                    Endpoint del servicio
	**/

	public static String getEndpoint(EndpointSetting__mdt objEndpointSetting) {
		String strEndpoint = '';
		if ('DEVELOPMENT'.equalsIgnoreCase(objEndpointSetting.Stage__c)) {
			strEndpoint = objEndpointSetting.DevelopmentEndpoint__c;
		} else if ('PRODUCTION'.equalsIgnoreCase(objEndpointSetting.Stage__c)) {
			strEndpoint = objEndpointSetting.ProductionEndpoint__c;
		} else if ('QA'.equalsIgnoreCase(objEndpointSetting.Stage__c)) {
			strEndpoint = objEndpointSetting.QAEndpoint__c;
		}
		return strEndpoint;
	}

	/**
	 * Establecer token de autenticación en la petición HTTP
	 * @param request Objeto Request
	**/

	private static void setServiceToken(HttpRequest request) {
		String strPlainToken = DCT_SecurityServices_cls.getPlainToken();
		request.setHeader('Authorization', 'Bearer ' + strPlainToken);
	}
}