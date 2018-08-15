/***************************************************************************************************************************
   Desarrollado por: Avanxo México                                                                                        
   Autor: Luis Enrique Garcia Sanabria                                                                         
   Email: legarcia@avanxo.com                                                                                  
   Fecha de creación: 18-04-2018                                                                                           
 ***************************************************************************************************************************
   Metadata:                                                                                                               
 ***************************************************************************************************************************
   Descripción: Clase batch para realizar el cambio del propietario del DCT(Cuenta) y de y de sus hijos.             
                                                                                                                           
 ***************************************************************************************************************************
                                                  Control de versiones                                                     
 ***************************************************************************************************************************
   No.      Fecha                 Autor                    Email                          Descripción                     
 ***************************************************************************************************************************
   1.0   18-04-2018   Luis Enrique Garcia Sanabria   legarcia@avanxo.com   Creacion de la clase DCT_assignmentNewOwner_cls 
 ***************************************************************************************************************************/
public class DCT_Investigaciones_ws {
	
	private static final String strEndpointName = System.Label.DCT_Investigaciones;
	public static  AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();

	public class ResponseWrapper {
		public String Leyenda;
		public string Estado;
		public Integer EstatusConsulta;
		public string Descripcion;		
		public string Message;		
		public string ExceptionMessage;
		public string ExceptionType;
	}

	public static ResponseWrapper Investigaciones(String strRazonSocial, String strInvRef, String strComentario){
		String              strRequest         = '';
		String              strResponse        = '';
		Boolean             blnServiceHadError = false;
		string              stgMessage         = '';
		ResponseWrapper     responseWp  = new ResponseWrapper();

		strRequest = JSON.serializePretty(
            new Map<String,Object>{
                'RazonSocial' => strRazonSocial,
                'Investigacion'=> strInvRef,
                'Comentario'=> strComentario != null ? strComentario : ''
            }
        );
        
        System.debug(loggingLevel.Error, '*** EN DCT_Investigaciones_ws.Investigaciones strRequest: ' + strRequest);
		try{
			if (!Test.isRunningTest())
				strResponse = DCT_GenericCallout_cls.fn_runCallout(strRequest, strEndpointName, null, '');
			if (Test.isRunningTest())
				strResponse = 'Read timed out';
	        System.debug(loggingLevel.Error, '*** EN DCT_Investigaciones_ws.Investigaciones strResponse: ' + strResponse);
			if (strResponse.contains('Read timed out')){
				strResponse = DCT_GenericCallout_cls.fn_runCallout(strRequest, strEndpointName, null, '');				
		        System.debug(loggingLevel.Error, '*** EN DCT_Investigaciones_ws.Investigaciones strResponse2: ' + strResponse);				
			}//Fin si strResponse.contains('Read timed out')
			if (strResponse.contains('Read timed out')){
				strResponse = DCT_GenericCallout_cls.fn_runCallout(strRequest, strEndpointName, null, '');			
		        System.debug(loggingLevel.Error, '*** EN DCT_Investigaciones_ws.Investigaciones strResponse3: ' + strResponse);				
			}//Fin si strResponse.contains('Read timed out')
			if (strResponse.contains('Read timed out')){
				strResponse = DCT_GenericCallout_cls.fn_runCallout(strRequest, strEndpointName, null, '');			
		        System.debug(loggingLevel.Error, '*** EN DCT_Investigaciones_ws.Investigaciones strResponse4: ' + strResponse);				
			}//Fin si strResponse.contains('Read timed out')
		}catch(CalloutException cE){blnServiceHadError = true;stgMessage = cE.getMessage();}catch(UnexpectedException uE){	blnServiceHadError = true;stgMessage = uE.getMessage();}catch(Exception gE){blnServiceHadError = true;stgMessage = gE.getMessage();}
		System.debug(loggingLevel.Error, '*** EN DCT_Investigaciones_ws.strResponse: ' + strResponse);
		if (String.isNotBlank(strResponse) && strResponse != null) {
			try {
				responseWp = (ResponseWrapper)JSON.deserialize(strResponse, ResponseWrapper.class);
			} catch(Exception e) {System.debug( '*** e: ' + e);}
            System.debug(loggingLevel.Error, '*** EN DCT_Investigaciones_ws.responseWp: ' + responseWp);
		}//Fin si String.isNotBlank(strResponse) && strResponse != null
		
		System.debug(loggingLevel.Error, 'ANTES DE SALIR DE DCT_Investigaciones_ws.responseWp: ' + responseWp);		
		return responseWp;
	}
	
}