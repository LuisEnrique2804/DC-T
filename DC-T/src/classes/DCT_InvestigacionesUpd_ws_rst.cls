@RestResource(urlMapping='/SFDC_UpdDatosInvestigacion_ws_rst/*')
global with sharing class DCT_InvestigacionesUpd_ws_rst {

	@HttpPost  
	global static void DCT_Nisi_Upd(){
		RestRequest req = RestContext.request;
		Blob bBody = req.requestBody;
		String sBody =  bBody.toString();
		
		//Manda llamar la clase que se llama SFDC_UpdDatosInvestigacion_ws_rst y el metodo updInvestigaciones
		String sResUpdInves = DCT_InvestigacionesUpd_ctrl_rst.updInvestigaciones(sBody);
		System.debug('EN DCT_InvestigacionesUpd_ws_rst sResUpdInves: ' + sResUpdInves);

		RestContext.response.addHeader('Content-Type', 'application/json');
		RestContext.response.responseBody = Blob.valueOf(sResUpdInves);
	}
	
}