public with sharing class DCT_CatalogoFuerzasVenta_rst {
 	public static Map<String, EndpointSetting__mdt> mapEndpointSettingMdt = DCT_Utils_cls.getEndpointSettingMdt();

	//Una clase para la respuesta de Telcel al llamado del servicio
	public class classRespuestaTelcel{
		public String ErrorID {get;set;}		
		public String ErrorDescripcion {get;set;}
		public List<listaFuerzaVentaDist> FuerzaVentaDistribuidor {get;set;}
	}
 	
 	//Una clase intermedia para regresar la lista de la fuerza de venta
	public class listaFuerzaVentaDist{
 		public Integer PrepagoSiapID {get;set;} 		
		public String RazonSocial {get;set;} 		 		
		public Integer EstatusID {get;set;}		
		public String ClavePPAS {get;set;}		
	}

	public class classRespuestaTelcelTodo{
		public String ErrorID {get;set;}		
		public String ErrorDescripcion {get;set;}
		public List<listaFuerzaVentaDistTodo> FuerzaVentaDistribuidor {get;set;}
	}

	public class listaFuerzaVentaDistTodo{
		public String ErrorID {get;set;}		
		public String ErrorDescripcion {get;set;}
		public String RazonSocial {get;set;}
		public String Clave {get;set;}				
	}

	//El metodo para obtener el catalogo de la fuerza de venta Completa sin parametros SI APLICA METODO DE PRUEBA
	public static classRespuestaTelcelTodo getCatalogoFuerzasVenta(){
		
		//Un objeto del tipo classRespuestaTelcel para la respuesta
    	classRespuestaTelcelTodo objDtRespuesta = new classRespuestaTelcelTodo();
    			
		//Obten el Token con el metodo de DCT_Utils_cls.LoginTelcel()
		DCT_Utils_cls.DtRespuestaTelcel objDtRespuestaTelcel = DCT_Utils_cls.LoginTelcel();
		System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVenta objDtRespuestaTelcel: ' + objDtRespuestaTelcel);
				
		//Ve si no hubo error a la hora de hacer el login a Telcel
		if (objDtRespuestaTelcel.error != null){
			objDtRespuesta.ErrorID = objDtRespuestaTelcel.error;
			objDtRespuesta.ErrorDescripcion = objDtRespuestaTelcel.error_description;
		}//Fin si objDtRespuestaTelcel.error != null
		
		//No hubo error a la hora de hacer el login a Telcel
		if (objDtRespuestaTelcel.error == null){
	    	    	
	    	//Toma los datos para los parametros de la conexion a Telcel del mapa de mapEndpointSettingMdt
	    	EndpointSetting__mdt objEndpointSettingMdt = mapEndpointSettingMdt.get('CatalogoFuerzasVenta');
			System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVenta objEndpointSettingMdt: ' + objEndpointSettingMdt);
						
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
				
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVenta endpoint: ' + objEndpointSettingMdt.Endpoint__c);
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVenta Accept: ' + request.getHeader('Accept'));			
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVenta Content-Type: ' + request.getHeader('Content-Type'));
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVenta Host: ' + request.getHeader('Host'));				
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVenta Cache-Control: ' + request.getHeader('Cache-Control'));
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVenta Authorization: ' + request.getHeader('Authorization'));
	
				HTTPResponse res;
				res = new Http().send(request);
				String sJasonRes = res.getBody();
				System.debug('EN getCatalogoFuerzasVenta HTTP: ' + res + ' sJasonRes: ' + sJasonRes);
	
				if (String.valueOf(res).contains('200') ){
					sJasonRes = '{"FuerzaVentaDistribuidor":' + sJasonRes + '}';
					//Seriarliza la respuesta del servicio
					classRespuestaTelcelTodo objDtRespuestaPaso = JSONParserRespTelcelTodo(String.valueOf(sJasonRes));
					objDtRespuesta.FuerzaVentaDistribuidor = objDtRespuestaPaso.FuerzaVentaDistribuidor;
					//Ve si tiene algo la lista de FuerzaVentaDistribuidor
					if(!objDtRespuesta.FuerzaVentaDistribuidor.isEmpty()){
						objDtRespuesta.ErrorID = objDtRespuesta.FuerzaVentaDistribuidor.get(0).ErrorID;
						objDtRespuesta.ErrorDescripcion = objDtRespuesta.FuerzaVentaDistribuidor.get(0).ErrorDescripcion;
					}//Fin si !objDtRespuesta.FuerzaVentaDistribuidor.isEmpty()
					System.debug('ANTES DE SALIR DE getCatalogoFuerzasVenta objDtRespuesta: ' + objDtRespuesta);				
				}
				//Ve si el campo JsonRes tiene algo
				if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') ){
					classRespuestaTelcelTodo objDtRespuestaPaso = JSONParserRespTelcelTodo(String.valueOf(sJasonRes));
					objDtRespuesta.FuerzaVentaDistribuidor = objDtRespuestaPaso.FuerzaVentaDistribuidor;
					//Ve si tiene algo la lista de FuerzaVentaDistribuidor
					if(!objDtRespuesta.FuerzaVentaDistribuidor.isEmpty()){
						objDtRespuesta.ErrorID = objDtRespuesta.FuerzaVentaDistribuidor.get(0).ErrorID;
						objDtRespuesta.ErrorDescripcion = objDtRespuesta.FuerzaVentaDistribuidor.get(0).ErrorDescripcion;
					}//Fin si !objDtRespuesta.FuerzaVentaDistribuidor.isEmpty()
					System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO getCatalogoFuerzasVenta objDtRespuesta: ' + objDtRespuesta);
				}//Fin si sJasonRes != null && sJasonRes.length() == 0			
	
			}catch(Exception ex){
				System.debug('ERROR EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVenta AL HACER EL LLAMADO AL WS: ' + ex.getMessage());
				objDtRespuestaTelcel.error = 'Error a la hora de llamar el servicio de Login';
				objDtRespuestaTelcel.error_description = ex.getMessage();
			}
			
		}//Fin si objDtRespuestaTelcel.error == null

		//Regresa el objeto de objDtRespuesta     	
    	return objDtRespuesta;
		
	}

	/*//El metodo para obtener el catalogo de la fuerza de venta por No de Empleado **** NO APLICA METODO DE PRUEBA
	public static classRespuestaTelcelTodo getCatalogoFuerzasVentaNoEmpleado(String sNoEmpleado){
		
		//Un objeto del tipo classRespuestaTelcel para la respuesta
    	classRespuestaTelcelTodo objDtRespuesta = new classRespuestaTelcelTodo();
    			
		//Obten el Token con el metodo de DCT_Utils_cls.LoginTelcel()
		DCT_Utils_cls.DtRespuestaTelcel objDtRespuestaTelcel = DCT_Utils_cls.LoginTelcel();
		System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaNoEmpleado objDtRespuestaTelcel: ' + objDtRespuestaTelcel);
				
		//Ve si no hubo error a la hora de hacer el login a Telcel
		if (objDtRespuestaTelcel.error != null){
			objDtRespuesta.ErrorID = objDtRespuestaTelcel.error;
			objDtRespuesta.ErrorDescripcion = objDtRespuestaTelcel.error_description;
		}//Fin si objDtRespuestaTelcel.error != null
		
		//No hubo error a la hora de hacer el login a Telcel
		if (objDtRespuestaTelcel.error == null){
	    	    	
	    	//Toma los datos para los parametros de la conexion a Telcel del mapa de mapEndpointSettingMdt
	    	EndpointSetting__mdt objEndpointSettingMdt = mapEndpointSettingMdt.get('CatalogoFuerzasVentaNoEmp');
			System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaNoEmpleado objEndpointSettingMdt: ' + objEndpointSettingMdt);
						
			try{
	    	
				//Una prueba utilzando HTTP 
				HttpRequest request = new HttpRequest();
				request.setMethod(objEndpointSettingMdt.ServiceMethod__c); //'GET'
				request.setHeader('Content-Type', objEndpointSettingMdt.RequestBodyType__c);
				request.setHeader('Host', objEndpointSettingMdt.ServiceProvider__c);				
				request.setHeader('Authorization', 'Bearer ' + objDtRespuestaTelcel.access_token);				
				request.setHeader('Cache-Control', 'no-cache');
				String sEndPoint = objEndpointSettingMdt.Endpoint__c + '' + sNoEmpleado;   			
				request.setEndpoint(sEndPoint);					
				request.setTimeout(Integer.valueOf(objEndpointSettingMdt.Timeout__c));
								
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaNoEmpleado endpoint: ' + objEndpointSettingMdt.Endpoint__c);
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaNoEmpleado Accept: ' + request.getHeader('Accept'));			
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaNoEmpleado Content-Type: ' + request.getHeader('Content-Type'));
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaNoEmpleado Host: ' + request.getHeader('Host'));				
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaNoEmpleado Cache-Control: ' + request.getHeader('Cache-Control'));
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaNoEmpleado Authorization: ' + request.getHeader('Authorization'));
	
				HTTPResponse res;
				res = new Http().send(request);
				String sJasonRes = res.getBody();
				System.debug('EN getCatalogoFuerzasVentaNoEmpleado HTTP: ' + res + ' sJasonRes: ' + sJasonRes);
	
				if (String.valueOf(res).contains('200') ){
					//Ve si contiene un '[';
					if (sJasonRes.contains('['))
						sJasonRes = '{"FuerzaVentaDistribuidor":' + sJasonRes + '}';
					if (!sJasonRes.contains('['))
						sJasonRes = '{"FuerzaVentaDistribuidor":[' + sJasonRes + ']}';						
					//Seriarliza la respuesta del servicio
					classRespuestaTelcelTodo objDtRespuestaPaso = JSONParserRespTelcelTodo(String.valueOf(sJasonRes));
					objDtRespuesta.FuerzaVentaDistribuidor = objDtRespuestaPaso.FuerzaVentaDistribuidor;
					//Ve si tiene algo la lista de FuerzaVentaDistribuidor
					if(!objDtRespuesta.FuerzaVentaDistribuidor.isEmpty()){
						objDtRespuesta.ErrorID = objDtRespuesta.FuerzaVentaDistribuidor.get(0).ErrorID;
						objDtRespuesta.ErrorDescripcion = objDtRespuesta.FuerzaVentaDistribuidor.get(0).ErrorDescripcion;
					}//Fin si !objDtRespuesta.FuerzaVentaDistribuidor.isEmpty()
					System.debug('ANTES DE SALIR DE getCatalogoFuerzasVentaNoEmpleado objDtRespuesta: ' + objDtRespuesta);				
				}
				//Ve si el campo JsonRes tiene algo
				if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') ){
					classRespuestaTelcelTodo objDtRespuestaPaso = JSONParserRespTelcelTodo(String.valueOf(sJasonRes));
					objDtRespuesta.FuerzaVentaDistribuidor = objDtRespuestaPaso.FuerzaVentaDistribuidor;
					//Ve si tiene algo la lista de FuerzaVentaDistribuidor
					if(!objDtRespuesta.FuerzaVentaDistribuidor.isEmpty()){
						objDtRespuesta.ErrorID = objDtRespuesta.FuerzaVentaDistribuidor.get(0).ErrorID;
						objDtRespuesta.ErrorDescripcion = objDtRespuesta.FuerzaVentaDistribuidor.get(0).ErrorDescripcion;
					}//Fin si !objDtRespuesta.FuerzaVentaDistribuidor.isEmpty()
					System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO getCatalogoFuerzasVentaNoEmpleado objDtRespuesta: ' + objDtRespuesta);
				}//Fin si sJasonRes != null && sJasonRes.length() == 0			
	
			}catch(Exception ex){
				System.debug('ERROR EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaNoEmpleado AL HACER EL LLAMADO AL WS: ' + ex.getMessage());
				objDtRespuestaTelcel.error = 'Error a la hora de llamar el servicio de Login';
				objDtRespuestaTelcel.error_description = ex.getMessage();
			}
			
		}//Fin si objDtRespuestaTelcel.error == null

		//Regresa el objeto de objDtRespuesta     	
    	return objDtRespuesta;
		
	}*/
	
	/*//El metodo para obtener el catalogo de la fuerza de venta por Estatus **** NO APLICA METODO DE PRUEBA
	public static classRespuestaTelcel getCatalogoFuerzasVentaPorEstatus(String sEstatus){
		
		//Un objeto del tipo classRespuestaTelcel para la respuesta
    	classRespuestaTelcel objDtRespuesta = new classRespuestaTelcel();
    			
		//Obten el Token con el metodo de DCT_Utils_cls.LoginTelcel()
		DCT_Utils_cls.DtRespuestaTelcel objDtRespuestaTelcel = DCT_Utils_cls.LoginTelcel();
		System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorEstatus objDtRespuestaTelcel: ' + objDtRespuestaTelcel);
				
		//Ve si no hubo error a la hora de hacer el login a Telcel
		if (objDtRespuestaTelcel.error != null){
			objDtRespuesta.ErrorID = objDtRespuestaTelcel.error;
			objDtRespuesta.ErrorDescripcion = objDtRespuestaTelcel.error_description;
		}//Fin si objDtRespuestaTelcel.error != null
		
		//No hubo error a la hora de hacer el login a Telcel
		if (objDtRespuestaTelcel.error == null){
	    	    	
	    	//Toma los datos para los parametros de la conexion a Telcel del mapa de mapEndpointSettingMdt
	    	EndpointSetting__mdt objEndpointSettingMdt = mapEndpointSettingMdt.get('CatalogoFuerzasVentaEstatus');
			System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorEstatus objEndpointSettingMdt: ' + objEndpointSettingMdt);
						
			try{
	    	
				//Una prueba utilzando HTTP 
				HttpRequest request = new HttpRequest();
				request.setMethod(objEndpointSettingMdt.ServiceMethod__c); //'GET'
				request.setHeader('Content-Type', objEndpointSettingMdt.RequestBodyType__c);
				request.setHeader('Host', objEndpointSettingMdt.ServiceProvider__c);				
				request.setHeader('Authorization', 'Bearer ' + objDtRespuestaTelcel.access_token);				
				request.setHeader('Cache-Control', 'no-cache');
				String sEndPoint = objEndpointSettingMdt.Endpoint__c + '' + sEstatus;   			
				request.setEndpoint(sEndPoint);					
				request.setTimeout(Integer.valueOf(objEndpointSettingMdt.Timeout__c));
								
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorEstatus endpoint: ' + objEndpointSettingMdt.Endpoint__c);
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorEstatus Accept: ' + request.getHeader('Accept'));			
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorEstatus Content-Type: ' + request.getHeader('Content-Type'));
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorEstatus Host: ' + request.getHeader('Host'));				
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorEstatus Cache-Control: ' + request.getHeader('Cache-Control'));
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorEstatus Authorization: ' + request.getHeader('Authorization'));
	
				HTTPResponse res;
				res = new Http().send(request);
				String sJasonRes = res.getBody();
				System.debug('EN getCatalogoFuerzasVentaPorEstatus HTTP: ' + res + ' sJasonRes: ' + sJasonRes);
	
				if (String.valueOf(res).contains('200') ){
					//Seriarliza la respuesta del servicio
					classRespuestaTelcel objDtRespuestaPaso = JSONParserRespTelcel(String.valueOf(sJasonRes));
					objDtRespuesta.FuerzaVentaDistribuidor = objDtRespuestaPaso.FuerzaVentaDistribuidor;								
					objDtRespuesta.ErrorID = objDtRespuestaPaso.ErrorID;
					objDtRespuesta.ErrorDescripcion = objDtRespuestaPaso.ErrorDescripcion;
					System.debug('ANTES DE SALIR DE getCatalogoFuerzasVentaPorEstatus objDtRespuesta: ' + objDtRespuesta);				
				}
				//Ve si el campo JsonRes tiene algo
				if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') ){
					classRespuestaTelcel objDtRespuestaPaso = JSONParserRespTelcel(String.valueOf(sJasonRes));
					objDtRespuesta.ErrorID = objDtRespuestaPaso.ErrorID;
					objDtRespuesta.ErrorDescripcion = objDtRespuestaPaso.ErrorDescripcion;
					System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO getCatalogoFuerzasVentaPorEstatus objDtRespuesta: ' + objDtRespuesta);
				}//Fin si sJasonRes != null && sJasonRes.length() == 0			
	
			}catch(Exception ex){
				System.debug('ERROR EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorEstatus AL HACER EL LLAMADO AL WS: ' + ex.getMessage());
				objDtRespuestaTelcel.error = 'Error a la hora de llamar el servicio de Login';
				objDtRespuestaTelcel.error_description = ex.getMessage();
			}
			
		}//Fin si objDtRespuestaTelcel.error == null

		//Regresa el objeto de objDtRespuesta     	
    	return objDtRespuesta;
		
	}*/

	/*//El metodo para obtener el catalogo de la fuerza de venta por ID **** NO APLICA METODO DE PRUEBA
	public static classRespuestaTelcel getCatalogoFuerzasVentaPorID(String sId){
		
		//Un objeto del tipo classRespuestaTelcel para la respuesta
    	classRespuestaTelcel objDtRespuesta = new classRespuestaTelcel();
    			
		//Obten el Token con el metodo de DCT_Utils_cls.LoginTelcel()
		DCT_Utils_cls.DtRespuestaTelcel objDtRespuestaTelcel = DCT_Utils_cls.LoginTelcel();
		System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorID objDtRespuestaTelcel: ' + objDtRespuestaTelcel);
				
		//Ve si no hubo error a la hora de hacer el login a Telcel
		if (objDtRespuestaTelcel.error != null){
			objDtRespuesta.ErrorID = objDtRespuestaTelcel.error;
			objDtRespuesta.ErrorDescripcion = objDtRespuestaTelcel.error_description;
		}//Fin si objDtRespuestaTelcel.error != null
		
		//No hubo error a la hora de hacer el login a Telcel
		if (objDtRespuestaTelcel.error == null){
	    	    	
	    	//Toma los datos para los parametros de la conexion a Telcel del mapa de mapEndpointSettingMdt
	    	EndpointSetting__mdt objEndpointSettingMdt = mapEndpointSettingMdt.get('CatalogoFuerzasVentaID');
			System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorID objEndpointSettingMdt: ' + objEndpointSettingMdt);
						
			try{
	    	
				//Una prueba utilzando HTTP 
				HttpRequest request = new HttpRequest();
				request.setMethod(objEndpointSettingMdt.ServiceMethod__c); //'GET'
				request.setHeader('Content-Type', objEndpointSettingMdt.RequestBodyType__c);
				request.setHeader('Host', objEndpointSettingMdt.ServiceProvider__c);				
				request.setHeader('Authorization', 'Bearer ' + objDtRespuestaTelcel.access_token);				
				request.setHeader('Cache-Control', 'no-cache');
				String sEndPoint = objEndpointSettingMdt.Endpoint__c + '' + sId;   			
				request.setEndpoint(sEndPoint);					
				request.setTimeout(Integer.valueOf(objEndpointSettingMdt.Timeout__c));
								
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorID endpoint: ' + objEndpointSettingMdt.Endpoint__c);
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorID Accept: ' + request.getHeader('Accept'));			
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorID Content-Type: ' + request.getHeader('Content-Type'));
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorID Host: ' + request.getHeader('Host'));				
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorID Cache-Control: ' + request.getHeader('Cache-Control'));
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorID Authorization: ' + request.getHeader('Authorization'));
	
				HTTPResponse res;
				res = new Http().send(request);
				String sJasonRes = res.getBody();
				System.debug('EN getCatalogoFuerzasVentaPorID HTTP: ' + res + ' sJasonRes: ' + sJasonRes);
	
				if (String.valueOf(res).contains('200') ){
					//Seriarliza la respuesta del servicio
					classRespuestaTelcel objDtRespuestaPaso = JSONParserRespTelcel(String.valueOf(sJasonRes));
					objDtRespuesta.FuerzaVentaDistribuidor = objDtRespuestaPaso.FuerzaVentaDistribuidor;								
					objDtRespuesta.ErrorID = objDtRespuestaPaso.ErrorID;
					objDtRespuesta.ErrorDescripcion = objDtRespuestaPaso.ErrorDescripcion;
					System.debug('ANTES DE SALIR DE getCatalogoFuerzasVentaPorID objDtRespuesta: ' + objDtRespuesta);				
				}
				//Ve si el campo JsonRes tiene algo
				if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') ){
					classRespuestaTelcel objDtRespuestaPaso = JSONParserRespTelcel(String.valueOf(sJasonRes));
					objDtRespuesta.ErrorID = objDtRespuestaPaso.ErrorID;
					objDtRespuesta.ErrorDescripcion = objDtRespuestaPaso.ErrorDescripcion;
					System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO getCatalogoFuerzasVentaPorID objDtRespuesta: ' + objDtRespuesta);
				}//Fin si sJasonRes != null && sJasonRes.length() == 0			
	
			}catch(Exception ex){
				System.debug('ERROR EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorID AL HACER EL LLAMADO AL WS: ' + ex.getMessage());
				objDtRespuestaTelcel.error = 'Error a la hora de llamar el servicio de Login';
				objDtRespuestaTelcel.error_description = ex.getMessage();
			}
			
		}//Fin si objDtRespuestaTelcel.error == null

		//Regresa el objeto de objDtRespuesta     	
    	return objDtRespuesta;
		
	}*/

	/*//El metodo para obtener el catalogo de la fuerza de venta por razón social **** NO APLICA METODO DE PRUEBA
	public static classRespuestaTelcel getCatalogoFuerzasVentaPorRazonSocial(String sRazonSocial){
		
		//Un objeto del tipo classRespuestaTelcel para la respuesta
    	classRespuestaTelcel objDtRespuesta = new classRespuestaTelcel();
    			
		//Obten el Token con el metodo de DCT_Utils_cls.LoginTelcel()
		DCT_Utils_cls.DtRespuestaTelcel objDtRespuestaTelcel = DCT_Utils_cls.LoginTelcel();
		System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorRazonSocial objDtRespuestaTelcel: ' + objDtRespuestaTelcel);
				
		//Ve si no hubo error a la hora de hacer el login a Telcel
		if (objDtRespuestaTelcel.error != null){
			objDtRespuesta.ErrorID = objDtRespuestaTelcel.error;
			objDtRespuesta.ErrorDescripcion = objDtRespuestaTelcel.error_description;
		}//Fin si objDtRespuestaTelcel.error != null
		
		//No hubo error a la hora de hacer el login a Telcel
		if (objDtRespuestaTelcel.error == null){
	    	    	
	    	//Toma los datos para los parametros de la conexion a Telcel del mapa de mapEndpointSettingMdt
	    	EndpointSetting__mdt objEndpointSettingMdt = mapEndpointSettingMdt.get('CatalogoFuerzasVentaRazonSocial');
			System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorRazonSocial objEndpointSettingMdt: ' + objEndpointSettingMdt);
						
			try{
	    	
				//Una prueba utilzando HTTP 
				HttpRequest request = new HttpRequest();
				request.setMethod(objEndpointSettingMdt.ServiceMethod__c); //'GET'
				request.setHeader('Content-Type', objEndpointSettingMdt.RequestBodyType__c);
				request.setHeader('Host', objEndpointSettingMdt.ServiceProvider__c);				
				request.setHeader('Authorization', 'Bearer ' + objDtRespuestaTelcel.access_token);				
				request.setHeader('Cache-Control', 'no-cache');
				String sEndPoint = objEndpointSettingMdt.Endpoint__c + '?pRazonSocial=' + EncodingUtil.urlEncode(sRazonSocial, 'UTF-8');
				request.setEndpoint(sEndPoint);					
				request.setTimeout(120000);
								
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorRazonSocial endpoint: ' + objEndpointSettingMdt.Endpoint__c);
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorRazonSocial Accept: ' + request.getHeader('Accept'));			
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorRazonSocial Content-Type: ' + request.getHeader('Content-Type'));
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorRazonSocial Host: ' + request.getHeader('Host'));				
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorRazonSocial Cache-Control: ' + request.getHeader('Cache-Control'));
				System.debug('EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorRazonSocial Authorization: ' + request.getHeader('Authorization'));
	
				HTTPResponse res;
				res = new Http().send(request);
				String sJasonRes = res.getBody();
				System.debug('EN getCatalogoFuerzasVentaPorRazonSocial HTTP: ' + res + ' sJasonRes: ' + sJasonRes);
	
				if (String.valueOf(res).contains('200') ){
					//Seriarliza la respuesta del servicio
					classRespuestaTelcel objDtRespuestaPaso = JSONParserRespTelcel(String.valueOf(sJasonRes));
					objDtRespuesta.FuerzaVentaDistribuidor = objDtRespuestaPaso.FuerzaVentaDistribuidor;								
					objDtRespuesta.ErrorID = objDtRespuestaPaso.ErrorID;
					objDtRespuesta.ErrorDescripcion = objDtRespuestaPaso.ErrorDescripcion;
					System.debug('ANTES DE SALIR DE getCatalogoFuerzasVentaPorRazonSocial objDtRespuesta: ' + objDtRespuesta);				
				}
				//Ve si el campo JsonRes tiene algo
				if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') ){
					classRespuestaTelcel objDtRespuestaPaso = JSONParserRespTelcel(String.valueOf(sJasonRes));
					objDtRespuesta.ErrorID = objDtRespuestaPaso.ErrorID;
					objDtRespuesta.ErrorDescripcion = objDtRespuestaPaso.ErrorDescripcion;
					System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO getCatalogoFuerzasVentaPorRazonSocial objDtRespuesta: ' + objDtRespuesta);
				}//Fin si sJasonRes != null && sJasonRes.length() == 0			
	
			}catch(Exception ex){
				System.debug('ERROR EN DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorRazonSocial AL HACER EL LLAMADO AL WS: ' + ex.getMessage());
				objDtRespuestaTelcel.error = 'Error a la hora de llamar el servicio de Login';
				objDtRespuestaTelcel.error_description = ex.getMessage();
			}
			
		}//Fin si objDtRespuestaTelcel.error == null

		//Regresa el objeto de objDtRespuesta     	
    	return objDtRespuesta;
		
	}*/

	//Regresa un objeto del tipo DtRespuestaTelcel si no hubo error a la hora de registrar el cliente		
	public static classRespuestaTelcel JSONParserRespTelcel(String sJsonResp){
		System.debug('EN DTC_CatalogoFuerzasVenta_rst.JSONParserRespTelcel: sJsonResp: ' + sJsonResp);
		
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
			System.debug('ERROR EN DTC_CatalogoFuerzasVenta_rst.JSONParserRespTelcel: sJsonResp: ' + ex.getMessage());
	 	}

		System.debug('ANTES DE SALIR DE DTC_CatalogoFuerzasVenta_rst.JSONParserRespTelcel: objAPPResp: ' + objAPPResp);
			 	
		//Regresa el objeto objSignInClsPaso
		return objAPPResp;
	}

	//Regresa un objeto del tipo DtRespuestaTelcel si no hubo error a la hora de registrar el cliente		
	public static classRespuestaTelcelTodo JSONParserRespTelcelTodo(String sJsonResp){
		System.debug('EN DTC_CatalogoFuerzasVenta_rst.JSONParserRespTelcelTodo: sJsonResp: ' + sJsonResp);
		
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
			System.debug('ERROR EN DTC_CatalogoFuerzasVenta_rst.JSONParserRespTelcelTodo: sJsonResp: ' + ex.getMessage());
	 	}

		System.debug('ANTES DE SALIR DE DTC_CatalogoFuerzasVenta_rst.JSONParserRespTelcelTodo: objAPPResp: ' + objAPPResp);
			 	
		//Regresa el objeto objSignInClsPaso
		return objAPPResp;
	}
}