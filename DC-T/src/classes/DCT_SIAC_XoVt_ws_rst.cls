@RestResource(urlMapping='/SFDC_SIAC_XoVt_ws_rst/*')
global with sharing class DCT_SIAC_XoVt_ws_rst {

	@HttpPost  
	global static void DCT_Nisi_Upd(){
		RestRequest req = RestContext.request;
		Blob bBody = req.requestBody;
		String sBody =  bBody.toString();
		
		//Manda llamar la clase que se llama DCT_SIAC_XoVt_ctrl_rst y el metodo redireccionaConsulta
		String sResUpdNisi = DCT_SIAC_XoVt_ctrl_rst.redireccionaConsulta(sBody);
		System.debug('EN DCT_Nisi_ws_rst sResUpdNisi: ' + sResUpdNisi);
			
		RestContext.response.addHeader('Content-Type', 'application/json');
		RestContext.response.responseBody = Blob.valueOf(sResUpdNisi);
	}

}