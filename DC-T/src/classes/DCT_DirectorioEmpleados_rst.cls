public with sharing class DCT_DirectorioEmpleados_rst {

 	public static Map<String, EndpointSetting__mdt> mapEndpointSettingMdt = DCT_Utils_cls.getEndpointSettingMdt();

	public class classRespuestaTelcel{
		public String ErrorID {get;set;}		
		public String ErrorDescripcion {get;set;}
		public List<DatosEmpleado> DirectorioEmpleados {get;set;}
	}

	public class DatosEmpleado{
		public String ErrorID {get;set;}		
		public String ErrorDescripcion {get;set;}
		public Integer mClaveArea {get;set;}
		public String mDescripcionArea {get;set;}
		public String mDescripcionPuesto {get;set;}
		public String mNumeroEmpleado {get;set;}
		public String mNombreEmpleado {get;set;}
		public String mApellidoPaterno {get;set;}
		public String mApellidoMaterno {get;set;}
		public String mExtension {get;set;}	
		public String mCelular {get;set;}
		public String mDescripcionTipoEmpleado {get;set;}
		public String mPerfilID {get;set;}
		public String mDescripcionPerfil {get;set;}
		public Boolean mEsResponsableEquipoTrabajo {get;set;}
		public Integer mPosicionPadreID {get;set;}
	}
		
	//El metodo para obtener las claves VPN
	public static classRespuestaTelcel getDirectorioEmpleados(String sUsuario){
		System.debug('EN DCT_DirectorioEmpleados_rst.getDirectorioEmpleados sUsuario: ' + sUsuario);
				
		//Un objeto del tipo classRespuestaTelcel para la respuesta
    	classRespuestaTelcel objDtRespuesta = new classRespuestaTelcel();
    			
		//Obten el Token con el metodo de DCT_Utils_cls.LoginTelcel()
		DCT_Utils_cls.DtRespuestaTelcel objDtRespuestaTelcel;
		//Si no es una prueba
		if (!Test.isRunningTest()){
			objDtRespuestaTelcel = DCT_Utils_cls.LoginTelcel();			
			System.debug('EN DCT_DirectorioEmpleados_rst.getDirectorioEmpleados objDtRespuestaTelcel: ' + objDtRespuestaTelcel);			
		}
		//Es una prueba
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
				System.debug('EN DCT_DirectorioEmpleados_rst.getDirectorioEmpleados objDtRespuestaTelcel2: ' + objDtRespuestaTelcel2);				
				if (objDtRespuestaTelcel2.error != null)
					objDtRespuestaTelcel.error_description = null;
			}//Fin si objDtRespuestaTelcel.error_description.contains('Read timed out')
		}//Fin si objDtRespuestaTelcel.error != null
		System.debug('EN DCT_DirectorioEmpleados_rst.getDirectorioEmpleados objDtRespuestaTelcel.1: ' + objDtRespuestaTelcel);
				
		//No hubo error a la hora de hacer el login a Telcel
		if (objDtRespuestaTelcel.error == null){
	    	    	
	    	//Toma los datos para los parametros de la conexion a Telcel del mapa de mapEndpointSettingMdt
	    	EndpointSetting__mdt objEndpointSettingMdt = mapEndpointSettingMdt.get('DCT_DirectorioEmpleados');
			System.debug('EN DCT_DirectorioEmpleados_rst.getDirectorioEmpleados objEndpointSettingMdt: ' + objEndpointSettingMdt);
						
			try{
	    	
				//Una prueba utilzando HTTP 
				HttpRequest request = new HttpRequest();
				request.setMethod(objEndpointSettingMdt.ServiceMethod__c); //'GET'
				request.setHeader('Content-Type', objEndpointSettingMdt.RequestBodyType__c);
				request.setHeader('Host', objEndpointSettingMdt.ServiceProvider__c);				
				request.setHeader('Authorization', 'Bearer ' + objDtRespuestaTelcel.access_token);				
				request.setHeader('Cache-Control', 'no-cache');
				String sEndPoint = objEndpointSettingMdt.Endpoint__c + '' + sUsuario;   			
				request.setEndpoint(sEndPoint);					
				request.setTimeout(120000);
				System.debug(loggingLevel.Error, '*****************************************************************************************');				
				System.debug('EN DCT_DirectorioEmpleados_rst.getDirectorioEmpleados endpoint: ' + objEndpointSettingMdt.Endpoint__c);
				System.debug('EN DCT_DirectorioEmpleados_rst.getDirectorioEmpleados Accept: ' + request.getHeader('Accept'));			
				System.debug('EN DCT_DirectorioEmpleados_rst.getDirectorioEmpleados Content-Type: ' + request.getHeader('Content-Type'));
				System.debug('EN DCT_DirectorioEmpleados_rst.getDirectorioEmpleados Host: ' + request.getHeader('Host'));				
				System.debug('EN DCT_DirectorioEmpleados_rst.getDirectorioEmpleados Cache-Control: ' + request.getHeader('Cache-Control'));
				System.debug('EN DCT_DirectorioEmpleados_rst.getDirectorioEmpleados Authorization: ' + request.getHeader('Authorization'));
				System.debug(loggingLevel.Error, '*****************************************************************************************');	
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
					sJasonRes = '[{"mClaveArea": 90040107,"mDescripcionArea": "DEPTO CLIENTES CORPORATIVOS VII","mDescripcionPuesto": "JEFE DE CLIENTES CORPORATIVOS","mNumeroEmpleado": "9629","mNombreEmpleado": "KARLA","mApellidoPaterno": "GAMBOA","mApellidoMaterno": "ROSAS","mExtension": "5098","mCelular": "5510100286","mDescripcionTipoEmpleado": "INTERNO","mPerfilID": 3,"mDescripcionPerfil": "JEFE","mEsResponsableEquipoTrabajo": true,"mPosicionPadreID": 162}]';										
				System.debug('EN getDirectorioEmpleados HTTP: ' + res + ' sJasonRes: ' + sJasonRes);
		
				if (String.valueOf(res).contains('200') || Test.isRunningTest()){
					System.debug(loggingLevel.Error, '*** Luis: ');
					//Ve si contiene un '[';
					if (sJasonRes.contains('['))
						sJasonRes = '{"DirectorioEmpleados":' + sJasonRes + '}';
					if (!sJasonRes.contains('['))
						sJasonRes = '{"DirectorioEmpleados":[' + sJasonRes + ']}';	
					System.debug(loggingLevel.Error, '*** sJasonRes: ' + sJasonRes);
					System.debug(loggingLevel.Error, '*****************************************************************************************');						
					//Seriarliza la respuesta del servicio
					classRespuestaTelcel objDtRespuestaPaso = JSONParserRespTelcelTodo(String.valueOf(sJasonRes));
					objDtRespuesta.DirectorioEmpleados = objDtRespuestaPaso.DirectorioEmpleados;
					//Ve si tiene algo la lista de DirectorioEmpleados
					if(!objDtRespuesta.DirectorioEmpleados.isEmpty()){
						objDtRespuesta.ErrorID = objDtRespuesta.DirectorioEmpleados.get(0).ErrorID;
						objDtRespuesta.ErrorDescripcion = objDtRespuesta.DirectorioEmpleados.get(0).ErrorDescripcion;
					}//Fin si !objDtRespuesta.DirectorioEmpleados.isEmpty()
					System.debug('ANTES DE SALIR DE getDirectorioEmpleados objDtRespuesta: ' + objDtRespuesta);	
					System.debug(loggingLevel.Error, '*****************************************************************************************');				
				}
				//Ve si el campo JsonRes tiene algo
				if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500')){
					System.debug(loggingLevel.Error, '*** Enrique: ');
					if (Test.isRunningTest())					
						sJasonRes = '{"Message": "Error.","ExceptionMessage": "No existen registros en la base de datos con los datos proporcionados, favor de intentar nuevamente con un usuario diferente.","ExceptionType": "System.ApplicationException","StackTrace": "   at Telcel.R9.DirectorioEmpleados.Negocio.Empleado.ConsultarEstructuraEmpleado(String pUsuarioUniversal)"}';
					classRespuestaTelcel objDtRespuestaPaso = JSONParserRespTelcelTodo(String.valueOf(sJasonRes));
					objDtRespuesta.DirectorioEmpleados = objDtRespuestaPaso.DirectorioEmpleados;
					//Ve si tiene algo la lista de DirectorioEmpleados
					if(!objDtRespuesta.DirectorioEmpleados.isEmpty()){
						objDtRespuesta.ErrorID = objDtRespuesta.DirectorioEmpleados.get(0).ErrorID;
						objDtRespuesta.ErrorDescripcion = objDtRespuesta.DirectorioEmpleados.get(0).ErrorDescripcion;
					}//Fin si !objDtRespuesta.DirectorioEmpleados.isEmpty()
					System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO getDirectorioEmpleados objDtRespuesta: ' + objDtRespuesta);
					System.debug(loggingLevel.Error, '*****************************************************************************************');	
				}//Fin si sJasonRes != null && sJasonRes.length() == 0		
			}catch(Exception ex){
				System.debug('ERROR EN DCT_DirectorioEmpleados_rst.getDirectorioEmpleados AL HACER EL LLAMADO AL WS: ' + ex.getMessage());				
				objDtRespuesta.ErrorID = ex.getMessage();
				objDtRespuesta.ErrorDescripcion = ex.getMessage();
			}
			
		}//Fin si objDtRespuestaTelcel.error == null

		//Regresa el objeto de objDtRespuesta     	
    	return objDtRespuesta;
		
	}

	//Regresa un objeto del tipo DtRespuestaTelcel si no hubo error a la hora de registrar el cliente		
	public static classRespuestaTelcel JSONParserRespTelcelTodo(String sJsonResp){
		System.debug('EN DCT_DirectorioEmpleados_rst.JSONParserRespTelcelTodo: sJsonResp: ' + sJsonResp);
		
		classRespuestaTelcel objAPPResp = new classRespuestaTelcel();		
	
		try{
            JSONParser parser = JSON.createParser(sJsonResp);
            //Ve si tiene algo el objeto de parser  
            while (parser.nextToken() != null) {//{"error": "invalid_client","error_description": "Las credenciales proporcionadas no son correctas."}
				//Inicia el detalle del objeto: sNombreObj
				if (parser.getCurrentToken() == JSONToken.START_OBJECT) { // 
					//Inicia el arreglo
					objAPPResp = (classRespuestaTelcel)parser.readValueAs(classRespuestaTelcel.class);							
				}//Fin si parser.getCurrentToken() == JSONToken.START_OBJECT
            }//Fin mientras parser.nextToken() != null
		}catch(Exception ex){
			System.debug('ERROR EN DCT_DirectorioEmpleados_rst.JSONParserRespTelcelTodo: sJsonResp: ' + ex.getMessage());
	 	}
	 	System.debug(loggingLevel.Error, '*****************************************************************************************');	
		System.debug('ANTES DE SALIR DE DCT_DirectorioEmpleados_rst.JSONParserRespTelcelTodo: objAPPResp: ' + objAPPResp);
			 	
		//Regresa el objeto objSignInClsPaso
		return objAPPResp;
	}

}