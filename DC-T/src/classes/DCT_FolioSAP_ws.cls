public with sharing class DCT_FolioSAP_ws {

	public class respSalesforce{
		public Boolean error {get;set;}
		public String mensaje {get;set;}		
		public String folio {get;set;}
	}

	//Metodo getFolioSAP
	public static respSalesforce getFolioSAP(String sDatosParaFolioSAP, String sUsuario, String sPwd, String sTipoCliente){
		System.debug('EN DCT_FolioSAP_ws.getFolioSAP sDatosParaFolioSAP: ' + sDatosParaFolioSAP + ' sUsuario: ' + sUsuario + ' sPwd: ' + sPwd + ' sTipoCliente: ' + sTipoCliente);
		String sRespuestaSap;		
		respSalesforce objRespSalesforce = new respSalesforce();
		List<String> slDatosParaFolioSAP = new List<String>();
		//<![CDATA[<?xml version="1.0" encoding="UTF-8"?><DATOS><DEUDORES><DEUDOR id='1'><ERROR><IDERROR>18001344</IDERROR><MSGERROR>S - Cuenta de Deudor creada exitosamente</MSGERROR></ERROR></DEUDOR></DEUDORES><ERROR><IDERROR>0</IDERROR><MSGERROR>Proceso Exitoso</MSGERROR></ERROR></DATOS>]]></return>
				
		try{

			//Destripa lo que tenga sDatosParaFolioSAP
			if (sDatosParaFolioSAP != null && sDatosParaFolioSAP != '')
				slDatosParaFolioSAP = sDatosParaFolioSAP.split(',');
			System.debug('EN DCT_FolioSAP_ws.getFolioSAP slDatosParaFolioSAP: ' + slDatosParaFolioSAP.size());
			Integer iCntReg = 0;
			for (String sDato : slDatosParaFolioSAP){
				System.debug('EN DCT_FolioSAP_ws.getFolioSAP iCntReg: ' + iCntReg + ' sDato: ' + sDato);
				iCntReg++;				
			}				

			sUsuario = 'STC_MANDAT';
			sPwd = 'SALEFORCE';
	    	String sXmlEnt = '<?xml version="1.0" encoding="UTF-8"?><DATOS><DEUDORES><DEUDOR id=\'1\'>'+
	    	'<NEMPLEADO>' + slDatosParaFolioSAP.get(0) + '</NEMPLEADO>' + // 14556
	    	'<GPOCTA>DT03</GPOCTA>'+
	    	'<RAMO>D002</RAMO>'+
	    	'<REGION>'+ slDatosParaFolioSAP.get(1) +'</REGION>'+ //MR01
	    	'<AREASVTA><AREAVTA>'+
	    	'<SOCIEDAD>MX01</SOCIEDAD>'+
	    	'<CANALDIST>10</CANALDIST>'+
	    	'<SECTOR>10</SECTOR>'+
	    	'<GPOCTE>18</GPOCTE>'+
	    	'</AREAVTA></AREASVTA>';

			//Se trata de una persona Moral 
			if (sTipoCliente == 'Moral' || sTipoCliente == 'Gubernamental'){
		    	sXmlEnt += '<PERSONAMORAL>'+
		    	'<RFC>'+ slDatosParaFolioSAP.get(2) +'</RFC>'+ //MEAI5207091U1
		    	'<CONCEPTOBUSQ>'+ slDatosParaFolioSAP.get(3) +'</CONCEPTOBUSQ>'+ //MEAI
		    	'<NOM1PM>'+ slDatosParaFolioSAP.get(4) +'</NOM1PM>'+ //MENDOZA AGUILAR IGNACIO
		    	'<NOM2PM>'+ slDatosParaFolioSAP.get(5) +'</NOM2PM>'+
		    	'<NOM3PM>'+ slDatosParaFolioSAP.get(6) +'</NOM3PM>'+ //ALFARO
		    	'<NOM4PM>'+ slDatosParaFolioSAP.get(7) +'</NOM4PM>'+ //OCHOA
		    	'</PERSONAMORAL>';

		    	sXmlEnt += '<DIRECCION>'+
		    	'<CALLE>'+ slDatosParaFolioSAP.get(8) +'</CALLE>'+ //LAS FLORES
		    	'<NUMEROL>' + (slDatosParaFolioSAP.get(9) != null && slDatosParaFolioSAP.get(9) != '' ? slDatosParaFolioSAP.get(9) : '1') + '</NUMEROL>'+ //476 slDatosParaFolioSAP.get(9)
		    	'<COMPLNUM>'+ slDatosParaFolioSAP.get(10) +'</COMPLNUM>'+ //3
		    	'<CODPOSTAL>'+ slDatosParaFolioSAP.get(11) +'</CODPOSTAL>'+ //22476
		    	'<DELMUN>'+ slDatosParaFolioSAP.get(12) +'</DELMUN>'+ //TIJUANA
		    	'<COLONIA>'+ slDatosParaFolioSAP.get(13) +'</COLONIA>'+ //10 DE MAYO
		    	'<CIUDAD>'+ slDatosParaFolioSAP.get(14) +'</CIUDAD>'+ //TIJUANA
		    	'<PAIS>'+ slDatosParaFolioSAP.get(15) +'</PAIS>'+ //MX
		    	'<ESTADO>'+ (slDatosParaFolioSAP.size() > 16 ? slDatosParaFolioSAP.get(16) : 'CDMX') +'</ESTADO>'+ //BC
		    	'</DIRECCION>'+
		    	'<DATFINANZAS><CTAASOCIADA>1102010005</CTAASOCIADA><GPOTESORERIA>D003</GPOTESORERIA></DATFINANZAS><DATVENTAS><ZONAVTA>MX0002</ZONAVTA><LISTAPRECIO>11</LISTAPRECIO><MONEDA>MXN</MONEDA><TIPOIVA>1</TIPOIVA></DATVENTAS></DEUDOR></DEUDORES></DATOS>';
		    	
			}//Fin si sTipoCliente == 'Moral' || sTipoCliente == 'Gubernamental'

			if (sTipoCliente == 'Física' || sTipoCliente == 'Física con Actividad Empresarial'){
		    	sXmlEnt += '<PERSONAFISICA>'+
		    	'<RFC>'+ slDatosParaFolioSAP.get(2) +'</RFC>'+ //MEAI5207091U1
		    	'<CONCEPTOBUSQ>'+ slDatosParaFolioSAP.get(3) +'</CONCEPTOBUSQ>'+ //MEAI
		    	'<NOM1PF>'+ slDatosParaFolioSAP.get(4) +'</NOM1PF>'+ //MENDOZA AGUILAR IGNACIO
		    	'<NOM2PF>'+ slDatosParaFolioSAP.get(5) +'</NOM2PF>'+
		    	'<APPAT>'+ slDatosParaFolioSAP.get(6) +'</APPAT>'+ //ALFARO
		    	'<APMAT>'+ slDatosParaFolioSAP.get(7) +'</APMAT>'+ //OCHOA
		    	'</PERSONAFISICA>';

		    	sXmlEnt += '<DIRECCION>'+
		    	'<CALLE>'+ slDatosParaFolioSAP.get(8) +'</CALLE>'+ //LAS FLORES
		    	'<NUMEROL>'+ + (slDatosParaFolioSAP.get(9) != null && slDatosParaFolioSAP.get(9) != '' ? slDatosParaFolioSAP.get(9) : '1') +'</NUMEROL>'+ //476
		    	'<COMPLNUM>'+ slDatosParaFolioSAP.get(10) +'</COMPLNUM>'+ //3
		    	'<CODPOSTAL>'+ slDatosParaFolioSAP.get(11) +'</CODPOSTAL>'+ //22476
		    	'<DELMUN>'+ slDatosParaFolioSAP.get(12) +'</DELMUN>'+ //TIJUANA
		    	'<COLONIA>'+ slDatosParaFolioSAP.get(13) +'</COLONIA>'+ //10 DE MAYO
		    	'<CIUDAD>'+ slDatosParaFolioSAP.get(14) +'</CIUDAD>'+ //TIJUANA
		    	'<PAIS>'+ slDatosParaFolioSAP.get(15) +'</PAIS>'+ //MX
		    	'<ESTADO>'+ (slDatosParaFolioSAP.size() > 16 ? slDatosParaFolioSAP.get(16) : 'CDMX') +'</ESTADO>'+ //BC
		    	'</DIRECCION>'+
		    	'<DATFINANZAS><CTAASOCIADA>1102010005</CTAASOCIADA><GPOTESORERIA>D003</GPOTESORERIA></DATFINANZAS><DATVENTAS><ZONAVTA>MX0002</ZONAVTA><LISTAPRECIO>11</LISTAPRECIO><MONEDA>MXN</MONEDA><TIPOIVA>1</TIPOIVA></DATVENTAS></DEUDOR></DEUDORES></DATOS>';
				
			}//Fin si sTipoCliente == 'Física' || sTipoCliente == 'Física con Actividad Empresarial'
				    	
			System.debug('EN DCT_FolioSAP_ws.getFolioSAP sXmlEnt: ' + sXmlEnt);
						
			//Crea un objeto del tipo FolioCuentaDeudoraSoap
			DCT_FolioCuentaDeudoraSAP.FolioCuentaDeudoraSoap objFolioCuentaDeudoraSoap = new DCT_FolioCuentaDeudoraSAP.FolioCuentaDeudoraSoap();
			//Crea un objeto del tipo RegistraCuentaDeudora_element Para enviar los 			
			DCT_FolioCuentaDeudoraSAP.RegistraCuentaDeudora_element objRegistraCuentaDeudora = new DCT_FolioCuentaDeudoraSAP.RegistraCuentaDeudora_element();
			//Inicializa los datos del objeto objRegistraCuentaDeudora
			objRegistraCuentaDeudora.pUsuario = sUsuario;
			objRegistraCuentaDeudora.pContrasenia = sPwd;
			objRegistraCuentaDeudora.pXmlConsulta = sXmlEnt;
			objFolioCuentaDeudoraSoap.timeout_x = 120000;
			
			sRespuestaSap = objFolioCuentaDeudoraSoap.RegistraCuentaDeudora(objRegistraCuentaDeudora.pUsuario, objRegistraCuentaDeudora.pContrasenia, 
				objRegistraCuentaDeudora.pXmlConsulta); 
			System.debug('EN DCT_FolioSAP_ws.getFolioSAP sRespuestaSap: ' + sRespuestaSap);
			
			//Inicializa el campo de sXmlRes con el de sResultFcdSap
			String sXmlRes = sRespuestaSap;
			if (Test.isRunningTest())
				sXmlRes = '<?xml version="1.0" encoding="UTF-8"?><DATOS><DEUDORES><DEUDOR id=\'1\'><ERROR><IDERROR>18001370</IDERROR><MSGERROR>S - Cuenta de Deudor creada exitosamente</MSGERROR></ERROR></DEUDOR></DEUDORES><ERROR><IDERROR>0</IDERROR><MSGERROR>Proceso Exitoso</MSGERROR></ERROR></DATOS>';
 			sXmlRes = sXmlRes.replace(' id=\'1\'', '');
 				
			if (sXmlRes != null && sXmlRes != ''){								
			//if (String.valueOf(res).contains('200') ){

				//Procesa la salida 
				//String sXmlRes = '<![CDATA[<?xml version="1.0" encoding="UTF-8"?><DATOS><DEUDORES><DEUDOR id=\'1\'><ERROR><IDERROR>18001344</IDERROR><MSGERROR>S - Cuenta de Deudor creada exitosamente</MSGERROR></ERROR></DEUDOR></DEUDORES><ERROR><IDERROR>0</IDERROR><MSGERROR>Proceso Exitoso</MSGERROR></ERROR></DATOS>]]></return>';
				//String sXmlRes = '<![CDATA[<?xml version="1.0" encoding="UTF-8"?><DATOS><DEUDORES></DEUDORES><ERROR><IDERROR>-1</IDERROR><MSGERROR>E-No se permite el acceso a la dirección IP</MSGERROR></ERROR></DATOS>]]></return>';				
				//sXmlRes = sXmlRes.replace(' id=\'1\'', '');
				System.debug('EN DCT_FolioSAP_ws.getFolioSAP sXmlRes: ' + sXmlRes);				
				String sERROR = '';
				String sDEUDORES = '';
				String sIdErrorEjecServ = '';
				String sMgErrorEjecServ = '';
				
				String sIdFolio = '';
				String sMgCuenta = '';
	
				//El detalle de la respuesta						
				if (sXmlRes.contains('<ERROR>')){
					sERROR = sXmlRes.substring(sXmlRes.lastIndexOf('<ERROR>'), sXmlRes.lastIndexOf('</ERROR>'));
					sERROR += '</ERROR>';
					//System.debug('EN DCT_FolioSAP_ws.getFolioSAP sERROR: ' + sERROR);
					DOM.Document doc = new DOM.Document();
					doc.load(sERROR);
					DOM.XMLNode nodeError = doc.getRootElement();
					//Recorre la lista de hijos de nodeError
					for(Dom.XMLNode nodeErrorHijos : nodeError.getChildElements()) {
       					System.debug('EN DCT_FolioSAP_ws.getFolioSAP nodeErrorHijos.getName()1: ' + nodeErrorHijos.getName());						
						if (nodeErrorHijos.getNodeType() == DOM.XMLNodeType.ELEMENT){
							if (nodeErrorHijos.getName() == 'IDERROR')
								sIdErrorEjecServ = nodeErrorHijos.getText();
							if (nodeErrorHijos.getName() == 'MSGERROR')
								sMgErrorEjecServ = nodeErrorHijos.getText();
						}//Fin si nodeErrorHijos.getNodeType() == DOM.XMLNodeType.ELEMENT
	        		}//Foin del for para nodeLM.getChildElements()
   					System.debug('EN DCT_FolioSAP_ws.getFolioSAP sIdErrorEjecServ1: ' + sIdErrorEjecServ + ' sMgErrorEjecServ1: ' + sMgErrorEjecServ);	        		
				}//Fin si sXmlRes.contains('getFolioSAPResult')
				
				//El detalle de mercados
				if (sXmlRes.contains('DEUDORES')){
					sDEUDORES = sXmlRes.substring(sXmlRes.indexOf('<DEUDORES>'), sXmlRes.lastIndexOf('</DEUDORES>'));
					sDEUDORES += '</DEUDORES>';
					//System.debug('EN DCT_FolioSAP_ws.getFolioSAP DEUDORES: ' + sDEUDORES);
					DOM.Document doc = new DOM.Document();
					doc.load(sDEUDORES);
					DOM.XMLNode nodeDeudores = doc.getRootElement();
					//Recorre la lista de hijos de nodeDeudores
					for(Dom.XMLNode nodeDeudor : nodeDeudores.getChildElements()) {
						if (nodeDeudor.getNodeType() == DOM.XMLNodeType.ELEMENT){
	       					System.debug('EN DCT_FolioSAP_ws.getFolioSAP nodeDeudor.getName()2: ' + nodeDeudor.getName());
	       					//Ve si tiene atributos el 
	       					if (nodeDeudor.getName() == 'DEUDOR'){
	       						//Toma los datos de sus atributos
								for(Dom.XMLNode nodeDeudorError : nodeDeudor.getChildElements()) {
	       							System.debug('EN DCT_FolioSAP_ws.getFolioSAP nodeDeudorError.getName()2: ' + nodeDeudorError.getName());									
									if (nodeDeudorError.getNodeType() == DOM.XMLNodeType.ELEMENT){
				       					if (nodeDeudorError.getName() == 'ERROR'){										
											//Redcorre los hijos del error
											for(Dom.XMLNode nodeError : nodeDeudorError.getChildElements()) {
				       							System.debug('EN DCT_FolioSAP_ws.getFolioSAP nodeError.getName()2: ' + nodeError.getName());											
												if (nodeError.getNodeType() == DOM.XMLNodeType.ELEMENT){
													if (nodeError.getName() == 'IDERROR')
														sIdFolio = nodeError.getText();
													if (nodeError.getName() == 'MSGERROR')
														sMgCuenta = nodeError.getText();
												}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT
							        		}//Fin del for para nodeDeudores.getChildElements()
			       							System.debug('EN DCT_FolioSAP_ws.getFolioSAP sIdFolio: ' + sIdFolio + ' sMgCuenta: ' + sMgCuenta);							        		
						        		}//Foin del for para nodeDeudores.getChildElements()						        		
									}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT										
	       						}//Fin dfel for para       						 
	       					}//Fin si nodeDeudor.getName() == 'Mercado'
						}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT
	        		}//Foin del for para nodeDeudores.getChildElements()
				}//Fin si sXmlRes.contains('getFolioSAPResult')
				
				//Ve si hugo no hubo error a la hora de llamar el WS
				if (sIdErrorEjecServ == '0'){
					objRespSalesforce.error = false;
					objRespSalesforce.folio = sIdFolio;
					objRespSalesforce.mensaje = sMgCuenta;
				}//Fin si sIdErrorEjecServ == '0'

				if (sIdErrorEjecServ == '-1'){
					objRespSalesforce.error = true;
					objRespSalesforce.folio = '';
					objRespSalesforce.mensaje = sMgErrorEjecServ;
				}//Fin si sIdErrorEjecServ == '0'
				
			//}//Fin si String.valueOf(res).contains('200')
			}//Fin si sXmlRes != null && sXmlRes != '' 
			 
		}catch(Exception ex){
			System.debug('ERROR EN DCT_FolioSAP_ws.getFolioSAP AL HACER EL LLAMADO AL WS: ' + ex.getMessage() + ' ' + ex.getLineNumber());
		}

		System.debug('EN DCT_FolioSAP_ws.getFolioSAP MercadosResponseDTOResult: ' + sRespuestaSap);		
		return objRespSalesforce;
	}


}