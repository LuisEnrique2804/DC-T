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
public class DCT_ReferenciaRAP_ws {
	private static final String strEndpointName = System.Label.DCT_ReferenciaRAP;
	public static  AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();	
	
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
	}
	
	public static String ReferenciaRAP(String rfc){
		System.debug('ENTRO A DCT_ReferenciaRAP_ws.ReferenciaRAP rfc: ' + rfc);
		
		String              strRequest         = '';
		String              strResponse        = '';
		Boolean             blnServiceHadError = false;
		string              stgMessage         = '';
		String 				sParametros		   = '';
		String 				sUser			   = '';
		String 				sContrasena        = '';
		
		//rfc = 'BBM061031RY6'; //Para pruebas nada nas	    
		System.debug('ENTRO A DCT_ReferenciaRAP_ws.ReferenciaRAP strEndpointName: ' + strEndpointName + ' rfc: ' + rfc);
		
		EndpointSetting__mdt objEndpointSettingMdt = TLCL_Utils_cls.getEndpointSetting(strEndpointName);
		sUser = objEndpointSettingMdt.Usuario__c;
		sContrasena = objEndpointSettingMdt.Contrasenia__c;
		
		//cadenaConsulta=A&B0609046F3&usuario=SmartRefRapWs&contrasena=SmartPassRefRap
		sParametros = '?cadenaConsulta=' + rfc + '&usuario=' + sUser + '&contrasena=' + sContrasena;
		System.debug('ENTRO A DCT_ReferenciaRAP_ws.ReferenciaRAP sParametros: ' + sParametros);		
				
		try{
			strResponse = DCT_GenericCallout_cls.fn_runCallout(strRequest, strEndpointName, null, sParametros);
		}catch(Exception gE){blnServiceHadError = true;stgMessage = gE.getMessage();}
		System.debug(loggingLevel.Error, 'ENTRO A DCT_ReferenciaRAP_ws.ReferenciaRAP strResponse: ' + strResponse);
		
		//Regresa la respuesta en el objeto que se llama
		return strResponse;
	}

}