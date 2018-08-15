@RestResource(urlMapping='/DirectorioComercial/*')
global with sharing class DCT_SISACactivaRest_ws  {
	
	@HttpGet
	global static void SISAC() {

    	String method	   = RestContext.request.params.get('Metodo');
		String rfc	       = RestContext.request.params.get('RFC');
		String legalName   = RestContext.request.params.get('RazonSocial');
		String entityLegal = RestContext.request.params.get('TipoPersona');
		String nisi	       = RestContext.request.params.get('NISI');
		String identifier  = RestContext.request.params.get('Identificador');

		System.debug(loggingLevel.Error, '*** method: ' + method);	
		System.debug(loggingLevel.Error, '*** rfc: ' + rfc);	
		System.debug(loggingLevel.Error, '*** legalName: ' + legalName);	
		System.debug(loggingLevel.Error, '*** entityLegal: ' + entityLegal);	
		System.debug(loggingLevel.Error, '*** nisi: ' + nisi);	
		System.debug(loggingLevel.Error, '*** identifier: ' + identifier);	
		
    	DCT_ResponseSISACactiva_cls response = DCT_SISACactivaRestAux_ws.sisact(method,rfc,legalName,entityLegal,nisi,identifier);
    	System.debug(loggingLevel.Error, '******************************************');
		System.debug(loggingLevel.Error, '*** response: ' + response);
		String strResponseString = JSON.serialize(response);
		System.debug(loggingLevel.Error, '*** strResponseString: ' + strResponseString);
		RestContext.response.addHeader('Content-Type', 'application/json');
		RestContext.response.responseBody = Blob.valueOf(strResponseString);
	}	
}