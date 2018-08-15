public with sharing class DCT_TelcelEquiposMetodos_ws {

	/*//Metodo ConsultarMarcas
	public static DCT_TelcelEquiposSoap_ws.getMarcasResponseDTO ConsultarMarcas(String slConsecCons, String sFuerzaVentas){
		System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas slConsecCons: ' + slConsecCons + ' sFuerzaVentas: ' + sFuerzaVentas);
		
		//Para el objeto de regreso
		DCT_TelcelEquiposSoap_ws.getMarcasResponseDTO MarcasResponseDTOResult = new DCT_TelcelEquiposSoap_ws.getMarcasResponseDTO();
		//Un objeto del tipo planesMercadoWSOUTDTO para los datos de los mercados y los estatus del llamado al WS
		DCT_TelcelEquiposSoap_ws.marcasOUTDTO objMarcasOUTDTO = new DCT_TelcelEquiposSoap_ws.marcasOUTDTO();
		//Uns lista para los mercados
		List<DCT_TelcelEquiposSoap_ws.marca> lMarca = new List<DCT_TelcelEquiposSoap_ws.marca>();
		//Un objeto para la respuesta 
		DCT_TelcelEquiposSoapEsb_ws.detailResponse detailResponseResul = new DCT_TelcelEquiposSoapEsb_ws.detailResponse();
		
		try{
	    	
			//Una prueba utilzando HTTP 
			HttpRequest request = new HttpRequest();
			request.setMethod('POST'); //'POST'
			request.setHeader('Content-Type', 'text/xml; charset=utf-8;');
			request.setHeader('Host', 'www.region9.telcel.com');
			request.setHeader('Cache-Control', 'no-cache');  			
			request.setEndpoint('https://www.region9.telcel.com/smartdistribuidores/PORTALES/PreciosSOAP/Equipos.asmx');					
			request.setTimeout(120000 );
						
			//JSONBody = EncodingUtil.urlEncode(JSONBody, 'UTF-8');
			String JSONBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">' +
   				' <soapenv:Header/> ' +
   				'	<soapenv:Body> ' +
      			'		<tem:ConsultarMarcas> ' +
         		' 			<tem:pMensajeID>32</tem:pMensajeID> ' +
         		' 			<tem:pFuerzaVentaM2K>'+sFuerzaVentas+'</tem:pFuerzaVentaM2K> ' + 
      			' 		</tem:ConsultarMarcas> ' + 
   				' 	</soapenv:Body>' +
				' </soapenv:Envelope>';
					
			//Incializa el Body con JSONBody						
			request.setBody(JSONBody);

			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas endpoint: ' + request.getEndpoint());
			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas Accept: ' + request.getHeader('Accept'));			
			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas Content-Type: ' + request.getHeader('Content-Type'));
			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas Cache-Control: ' + request.getHeader('Cache-Control'));
			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas Authorization: ' + request.getHeader('Authorization'));
			System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas JSONBody: ' + JSONBody);

			HTTPResponse res;
			res = new Http().send(request);
			String sXmlRes = res.getBody();
			System.debug('EN ConsultarMarcas HTTP: ' + res + ' sXmlRes: ' + sXmlRes);
											
			if (String.valueOf(res).contains('200') ){

				//Procesa la salida 
				//String sXmlRes = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ConsultarPlazosResponse xmlns="http://tempuri.org/"><ConsultarPlazosResult><controlData xmlns=""><messageUUID xmlns="http://amx.com/mexico/telcel/esb/v1_1">1</messageUUID><responseDate xmlns="http://amx.com/mexico/telcel/esb/v1_1">2018-06-11T13:35:51.847-05:00</responseDate><sendBy xmlns="http://amx.com/mexico/telcel/esb/v1_1">Jarvis-SistemaPrecios</sendBy><latency xmlns="http://amx.com/mexico/telcel/esb/v1_1">148</latency><version xmlns="http://amx.com/mexico/telcel/esb/v1_1">1.0.0</version></controlData><detailResponse xmlns=""><code xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</code><severityLevel xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</severityLevel><description xmlns="http://amx.com/mexico/telcel/esb/v1_1">OPERACION EXITOSA</description></detailResponse><listaMarcas xmlns=""><Marca><cveMarca>186</cveMarca><descripcionMarca>3JTECH</descripcionMarca></Marca><Marca><cveMarca>69</cveMarca><descripcionMarca>ACER</descripcionMarca></Marca><movimientoWS>1210962</movimientoWS><estatusWS>0</estatusWS></listaMarcas></ConsultarMarcasResult></ConsultarMarcasResponse></soap:Body></soap:Envelope>';
				String sDetailResponse = '';
				String slistaMarcas = '';
	
				//El detalle de la respuesta						
				if (sXmlRes.contains('detailResponse')){
					sDetailResponse = sXmlRes.substring(sXmlRes.indexOf('<detailResponse xmlns="">'), sXmlRes.indexOf('</detailResponse>'));
					sDetailResponse += '</detailResponse>';
					//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas sDetailResponse: ' + sDetailResponse);
					DOM.Document doc = new DOM.Document();
					doc.load(sDetailResponse);
					DOM.XMLNode nodeDR = doc.getRootElement();
					String sNameSpaceDR = 'http://amx.com/mexico/telcel/esb/v1_1';
					String code = nodeDR.getChildElement('code', sNameSpaceDR).getText();
					String severityLevel = nodeDR.getChildElement('severityLevel', sNameSpaceDR).getText();				
					String description = nodeDR.getChildElement('description', sNameSpaceDR).getText();
					detailResponseResul.code = code;
					detailResponseResul.description = description;
					detailResponseResul.severityLevel = Integer.valueOf(severityLevel);						
					System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas code: ' + code + ' ' + severityLevel + ' ' + description);					
				}//Fin si sXmlRes.contains('ConsultarMarcasResult')
				
				//El detalle de mercados
				if (sXmlRes.contains('listaMarcas')){
					slistaMarcas = sXmlRes.substring(sXmlRes.indexOf('<listaMarcas xmlns="">'), sXmlRes.lastIndexOf('</listaMarcas>'));
					slistaMarcas += '</listaMarcas>';
					//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas listaMarcas: ' + slistaMarcas);
					DOM.Document doc = new DOM.Document();
					doc.load(slistaMarcas);
					DOM.XMLNode nodeLM = doc.getRootElement();
					//Recorre la lista de hijos de nodeLM
					for(Dom.XMLNode nodeLMHijo : nodeLM.getChildElements()) {
						if (nodeLMHijo.getNodeType() == DOM.XMLNodeType.ELEMENT){
	       					//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas nodeLMHijo.getName(): ' + nodeLMHijo.getName());
	       					//Ve si tiene atributos el 
	       					if (nodeLMHijo.getName() == 'Marca'){
								String cveMercado = '';
								String descripcionMercado = '';       						       						
	       						//Toma los datos de sus atributos
								for(Dom.XMLNode nodeLMMarca : nodeLMHijo.getChildElements()) {
	       							//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas nodeLMMarca.getName(): ' + nodeLMMarca.getName() + ' ' + nodeLMMarca.getNamespace());
									if (nodeLMMarca.getName() == 'cveMarca')
										cveMercado = nodeLMMarca.getText();
									if (nodeLMMarca.getName() == 'descripcionMarca')
										descripcionMercado = nodeLMMarca.getText();
	       						}//Fin dfel for para
								if (cveMercado != null && descripcionMercado != null){
			           				//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas cveMercado: ' + cveMercado + ' descripcionMercado: ' + descripcionMercado);									
									DCT_TelcelEquiposSoap_ws.marca objMarca = new DCT_TelcelEquiposSoap_ws.marca();
									objMarca.cveMarca = Integer.valueOf(cveMercado);
									objMarca.descripcionMarca = descripcionMercado;
									lMarca.add(objMarca);
								}//Fin si cveMercado != null && descripcionMercado != null       						 
	       					}//Fin si nodeLMHijo.getName() == 'Mercado'
	       					
	       					//Ve si se trata de elemento movimientoWS
	       					if (nodeLMHijo.getName() == 'movimientoWS')
								objMarcasOUTDTO.movimientoWS = Integer.valueOf(nodeLMHijo.getText());
	       					//Ve si se trata de elemento estatusWS
	       					if (nodeLMHijo.getName() == 'estatusWS')
								objMarcasOUTDTO.estatusWS = Integer.valueOf(nodeLMHijo.getText());
						}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT
	        		}//Foin del for para nodeLM.getChildElements()
				}//Fin si sXmlRes.contains('ConsultarMarcasResult')
	
				//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas lMarca: ' + lMarca);
				//Inicualiza la lista en el objeto de objMarcasOUTDTO 
				objMarcasOUTDTO.Marca= lMarca;
				//Inicializa la lista en el objeto de MarcasResponseDTOResult 
				MarcasResponseDTOResult.listaMarcas = objMarcasOUTDTO;
				MarcasResponseDTOResult.detailResponse = detailResponseResul;

			}//Fin si String.valueOf(res).contains('200')
			 
			//Ve si el campo JsonRes tiene algo
			if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') ){
				System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO ConsultarMarcas objDtRespuesta: ' + sXmlRes);
			}//Fin si sXmlRes != null && sXmlRes.length() == 0

		}catch(Exception ex){
			System.debug('ERROR EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas AL HACER EL LLAMADO AL WS: ' + ex.getMessage() + ' ' + ex.getLineNumber());
		}

		System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarMarcas MarcasResponseDTOResult: ' + MarcasResponseDTOResult);		
		return MarcasResponseDTOResult;
	}*/


	/*//Metodo ConsultarModelos
	public static DCT_TelcelEquiposSoap_ws.getModelosResponseDTO ConsultarModelos(String slConsecCons, String sFuerzaVentas, String sMarcaClave){
		System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos slConsecCons: ' + slConsecCons + ' sFuerzaVentas: ' + sFuerzaVentas + ' sMarcaClave: ' + sMarcaClave);
		
		//Para el objeto de regreso
		DCT_TelcelEquiposSoap_ws.getModelosResponseDTO ModelosResponseDTOResult = new DCT_TelcelEquiposSoap_ws.getModelosResponseDTO();
		//Un objeto del tipo planesMercadoWSOUTDTO para los datos de los mercados y los estatus del llamado al WS
		DCT_TelcelEquiposSoap_ws.modelosOUTDTO objModelosOUTDTO = new DCT_TelcelEquiposSoap_ws.modelosOUTDTO();
		//Uns lista para los mercados
		List<DCT_TelcelEquiposSoap_ws.modelo> lModelo = new List<DCT_TelcelEquiposSoap_ws.modelo>();
		//Un objeto para la respuesta 
		DCT_TelcelEquiposSoapEsb_ws.detailResponse detailResponseResul = new DCT_TelcelEquiposSoapEsb_ws.detailResponse();
		
		try{
	    	
			//Una prueba utilzando HTTP 
			HttpRequest request = new HttpRequest();
			request.setMethod('POST'); //'POST'
			request.setHeader('Content-Type', 'text/xml; charset=utf-8;');
			request.setHeader('Host', 'www.region9.telcel.com');
			request.setHeader('Cache-Control', 'no-cache');  			
			request.setEndpoint('https://www.region9.telcel.com/smartdistribuidores/PORTALES/PreciosSOAP/Equipos.asmx');					
			request.setTimeout(120000 );
						
			//JSONBody = EncodingUtil.urlEncode(JSONBody, 'UTF-8');
			String JSONBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">' +
   				' <soapenv:Header/> ' +
   				'	<soapenv:Body> ' +
      			'		<tem:ConsultarModelos> ' +
         		' 			<tem:pMensajeID>32</tem:pMensajeID> ' +
         		' 			<tem:pFuerzaVentaM2K>'+sFuerzaVentas+'</tem:pFuerzaVentaM2K> ' +
         		' 			<tem:pMarcaClave>'+sMarcaClave+'</tem:pMarcaClave> ' +
      			' 		</tem:ConsultarModelos> ' + 
   				' 	</soapenv:Body>' +
				' </soapenv:Envelope>';
					
			//Incializa el Body con JSONBody						
			request.setBody(JSONBody);

			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos endpoint: ' + request.getEndpoint());
			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos Accept: ' + request.getHeader('Accept'));			
			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos Content-Type: ' + request.getHeader('Content-Type'));
			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos Cache-Control: ' + request.getHeader('Cache-Control'));
			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos Authorization: ' + request.getHeader('Authorization'));
			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos JSONBody: ' + JSONBody);

			HTTPResponse res;
			res = new Http().send(request);
			String sXmlRes = res.getBody();
			System.debug('EN ConsultarModelos HTTP: ' + res + ' sXmlRes: ' + sXmlRes);
											
			if (String.valueOf(res).contains('200') ){

				//Procesa la salida 
				//String sXmlRes = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ConsultarPlazosResponse xmlns="http://tempuri.org/"><ConsultarPlazosResult><controlData xmlns=""><messageUUID xmlns="http://amx.com/mexico/telcel/esb/v1_1">1</messageUUID><responseDate xmlns="http://amx.com/mexico/telcel/esb/v1_1">2018-06-11T13:35:51.847-05:00</responseDate><sendBy xmlns="http://amx.com/mexico/telcel/esb/v1_1">Jarvis-SistemaPrecios</sendBy><latency xmlns="http://amx.com/mexico/telcel/esb/v1_1">148</latency><version xmlns="http://amx.com/mexico/telcel/esb/v1_1">1.0.0</version></controlData><detailResponse xmlns=""><code xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</code><severityLevel xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</severityLevel><description xmlns="http://amx.com/mexico/telcel/esb/v1_1">OPERACION EXITOSA</description></detailResponse><listaMarcas xmlns=""><Marca><cveMarca>186</cveMarca><descripcionMarca>3JTECH</descripcionMarca></Marca><Marca><cveMarca>69</cveMarca><descripcionMarca>ACER</descripcionMarca></Marca><movimientoWS>1210962</movimientoWS><estatusWS>0</estatusWS></listaMarcas></ConsultarModelosResult></ConsultarModelosResponse></soap:Body></soap:Envelope>';
				String sDetailResponse = '';
				String slistaModelos = '';
	
				//El detalle de la respuesta						
				if (sXmlRes.contains('detailResponse')){
					sDetailResponse = sXmlRes.substring(sXmlRes.indexOf('<detailResponse xmlns="">'), sXmlRes.indexOf('</detailResponse>'));
					sDetailResponse += '</detailResponse>';
					//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos sDetailResponse: ' + sDetailResponse);
					DOM.Document doc = new DOM.Document();
					doc.load(sDetailResponse);
					DOM.XMLNode nodeDR = doc.getRootElement();
					String sNameSpaceDR = 'http://amx.com/mexico/telcel/esb/v1_1';
					String code = nodeDR.getChildElement('code', sNameSpaceDR).getText();
					String severityLevel = nodeDR.getChildElement('severityLevel', sNameSpaceDR).getText();				
					String description = nodeDR.getChildElement('description', sNameSpaceDR).getText();
					detailResponseResul.code = code;
					detailResponseResul.description = description;
					detailResponseResul.severityLevel = Integer.valueOf(severityLevel);						
					System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos code: ' + code + ' ' + severityLevel + ' ' + description);					
				}//Fin si sXmlRes.contains('ConsultarModelosResult')
				
				//El detalle de mercados
				if (sXmlRes.contains('listaModelos')){
					slistaModelos = sXmlRes.substring(sXmlRes.indexOf('<listaModelos xmlns="">'), sXmlRes.lastIndexOf('</listaModelos>'));
					slistaModelos += '</listaModelos>';
					//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos listaModelos: ' + slistaModelos);
					DOM.Document doc = new DOM.Document();
					doc.load(slistaModelos);
					DOM.XMLNode nodeLM = doc.getRootElement();
					//Recorre la lista de hijos de nodeLM
					for(Dom.XMLNode nodeLMHijo : nodeLM.getChildElements()) {
						if (nodeLMHijo.getNodeType() == DOM.XMLNodeType.ELEMENT){
	       					//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos nodeLMHijo.getName(): ' + nodeLMHijo.getName());
	       					//Ve si tiene atributos el 
	       					if (nodeLMHijo.getName() == 'Modelo'){
								String cveModeloM2k = '';
								String descripcionModelo = '';
								String nombreComercial = '';
	       						//Toma los datos de sus atributos
								for(Dom.XMLNode nodeLMMarca : nodeLMHijo.getChildElements()) {
	       							//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos nodeLMMarca.getName(): ' + nodeLMMarca.getName() + ' ' + nodeLMMarca.getNamespace());
									if (nodeLMMarca.getName() == 'cveModeloM2k')
										cveModeloM2k = nodeLMMarca.getText();
									if (nodeLMMarca.getName() == 'descripcionModelo')
										descripcionModelo = nodeLMMarca.getText();
									if (nodeLMMarca.getName() == 'nombreComercial')
										nombreComercial = nodeLMMarca.getText();										
	       						}//Fin dfel for para
								if (cveModeloM2k != null && descripcionModelo != null){
			           				//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos cveMercado: ' + cveMercado + ' descripcionModelo: ' + descripcionModelo);									
									DCT_TelcelEquiposSoap_ws.Modelo objModelo = new DCT_TelcelEquiposSoap_ws.Modelo();
									objModelo.cveModeloM2k = cveModeloM2k;
									objModelo.descripcionModelo = descripcionModelo;
									objModelo.nombreComercial = nombreComercial;
									lModelo.add(objModelo);
								}//Fin si cveMercado != null && descripcionMercado != null       						 
	       					}//Fin si nodeLMHijo.getName() == 'Mercado'
	       					
	       					//Ve si se trata de elemento movimientoWS
	       					if (nodeLMHijo.getName() == 'movimientoWS')
								objModelosOUTDTO.movimientoWS = Integer.valueOf(nodeLMHijo.getText());
	       					//Ve si se trata de elemento estatusWS
	       					if (nodeLMHijo.getName() == 'estatusWS')
								objModelosOUTDTO.estatusWS = Integer.valueOf(nodeLMHijo.getText());
						}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT
	        		}//Foin del for para nodeLM.getChildElements()
				}//Fin si sXmlRes.contains('ConsultarModelosResult')
	
				//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos lModelo: ' + lModelo);
				//Inicualiza la lista en el objeto de objModelosOUTDTO 
				objModelosOUTDTO.Modelo= lModelo;
				//Inicializa la lista en el objeto de ModelosResponseDTOResult 
				ModelosResponseDTOResult.listaModelos = objModelosOUTDTO;
				ModelosResponseDTOResult.detailResponse = detailResponseResul;

			}//Fin si String.valueOf(res).contains('200')
			 
			//Ve si el campo JsonRes tiene algo
			if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') ){
				System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO ConsultarModelos objDtRespuesta: ' + sXmlRes);
			}//Fin si sXmlRes != null && sXmlRes.length() == 0

		}catch(Exception ex){
			System.debug('ERROR EN DCT_TelcelEquiposSoap_ws.ConsultarModelos AL HACER EL LLAMADO AL WS: ' + ex.getMessage() + ' ' + ex.getLineNumber());
		}

		System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarModelos ModelosResponseDTOResult: ' + ModelosResponseDTOResult);		
		return ModelosResponseDTOResult;
	}*/

	/*//Metodo ConsultarInformacionModelo
	public static DCT_TelcelEquiposSoap_ws.getInformacionModeloResponseDTO ConsultarInformacionModelo(String slConsecCons, String sFuerzaVentas, String sMarcaClave){
		System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo slConsecCons: ' + slConsecCons + ' sFuerzaVentas: ' + sFuerzaVentas + ' sMarcaClave: ' + sMarcaClave);
		
		//Para el objeto de regreso
		DCT_TelcelEquiposSoap_ws.getInformacionModeloResponseDTO InformacionModeloResponseDTOResult = new DCT_TelcelEquiposSoap_ws.getInformacionModeloResponseDTO();
		//Un objeto del tipo planesMercadoWSOUTDTO para los datos de los mercados y los estatus del llamado al WS
		DCT_TelcelEquiposSoap_ws.informacionModeloOUTDTO objInformacionModeloOUTDTO = new DCT_TelcelEquiposSoap_ws.informacionModeloOUTDTO();
		//Un objeto del tipo DCT_TelcelEquiposSoap_ws.informacionModelo
		DCT_TelcelEquiposSoap_ws.informacionModelo objInformacionModelo = new DCT_TelcelEquiposSoap_ws.informacionModelo();
		//Un objeto del tipo DCT_TelcelEquiposSoap_ws.caracteristicasVO
		DCT_TelcelEquiposSoap_ws.caracteristicasVO objCaracteristicasVO = new DCT_TelcelEquiposSoap_ws.caracteristicasVO();
		//Un objeto del tipo CT_TelcelEquiposSoap_ws.simCardCaracteristicasVO
		DCT_TelcelEquiposSoap_ws.simCardCaracteristicasVO objSimCardCaracteristicasVO = new DCT_TelcelEquiposSoap_ws.simCardCaracteristicasVO();
		//Una lista del tipo List<DCT_TelcelEquiposSoap_ws.versionSim>
		List<DCT_TelcelEquiposSoap_ws.versionSim> lVersionSim = new List<DCT_TelcelEquiposSoap_ws.versionSim>();
		//Una lita del tipo DCT_TelcelEquiposSoap_ws.ArrayOfVersionSim
		DCT_TelcelEquiposSoap_ws.ArrayOfVersionSim objArrayOfVersionSim = new DCT_TelcelEquiposSoap_ws.ArrayOfVersionSim();
		//Una lista del tipo DCT_TelcelEquiposSoap_ws.materialSapSim
		List<DCT_TelcelEquiposSoap_ws.materialSapSim> lMaterialSapSim = new List<DCT_TelcelEquiposSoap_ws.materialSapSim>();
		//Un objeto del tipo DCT_TelcelEquiposSoap_ws.ArrayOfColorCaracteristicasVO
		DCT_TelcelEquiposSoap_ws.ArrayOfColorCaracteristicasVO objArrayOfColorCaracteristicasVO = new DCT_TelcelEquiposSoap_ws.ArrayOfColorCaracteristicasVO();
		//Una lista del tipo DCT_TelcelEquiposSoap_ws.colorCaracteristicasVO
		List<DCT_TelcelEquiposSoap_ws.colorCaracteristicasVO> lCcolorCaracteristicasVO = new List<DCT_TelcelEquiposSoap_ws.colorCaracteristicasVO>();
		//Un objeto del tipo DCT_TelcelEquiposSoap_ws.ArrayOfModeloMaterialSap
		DCT_TelcelEquiposSoap_ws.ArrayOfModeloMaterialSap objArrayOfModeloMaterialSap = new DCT_TelcelEquiposSoap_ws.ArrayOfModeloMaterialSap();
		
		//Una lista del tipo List<ListDCT_TelcelEquiposSoap_ws.modeloMaterialSap>
		List<DCT_TelcelEquiposSoap_ws.modeloMaterialSap> lModeloMaterialSap = new List<DCT_TelcelEquiposSoap_ws.modeloMaterialSap>();
		//Uns lista para los mercados
		List<DCT_TelcelEquiposSoap_ws.informacionModelo> lInformacionModelo = new List<DCT_TelcelEquiposSoap_ws.informacionModelo>();
		//Un objeto para la respuesta 
		DCT_TelcelEquiposSoapEsb_ws.detailResponse detailResponseResul = new DCT_TelcelEquiposSoapEsb_ws.detailResponse();
		
		try{
	    	
			//Una prueba utilzando HTTP 
			HttpRequest request = new HttpRequest();
			request.setMethod('POST'); //'POST'
			request.setHeader('Content-Type', 'text/xml; charset=utf-8;');
			request.setHeader('Host', 'www.region9.telcel.com');
			request.setHeader('Cache-Control', 'no-cache');  			
			request.setEndpoint('https://www.region9.telcel.com/smartdistribuidores/PORTALES/PreciosSOAP/Equipos.asmx');					
			request.setTimeout(120000);
						
			//JSONBody = EncodingUtil.urlEncode(JSONBody, 'UTF-8');
			String JSONBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">' +
   				' <soapenv:Header/> ' +
   				'	<soapenv:Body> ' +
      			'		<tem:ConsultarInformacionModelo> ' +
         		' 			<tem:pMensajeID>32</tem:pMensajeID> ' +
         		' 			<tem:pFuerzaVentaM2K>'+sFuerzaVentas+'</tem:pFuerzaVentaM2K> ' +
         		' 			<tem:pMarcaClave>'+sMarcaClave+'</tem:pMarcaClave> ' +
      			' 		</tem:ConsultarInformacionModelo> ' + 
   				' 	</soapenv:Body>' +
				' </soapenv:Envelope>';
					
			//Incializa el Body con JSONBody						
			request.setBody(JSONBody);

			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo endpoint: ' + request.getEndpoint());
			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo Accept: ' + request.getHeader('Accept'));			
			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo Content-Type: ' + request.getHeader('Content-Type'));
			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo Cache-Control: ' + request.getHeader('Cache-Control'));
			//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo Authorization: ' + request.getHeader('Authorization'));
			System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo JSONBody: ' + JSONBody);

			//HTTPResponse res;
			//res = new Http().send(request);
			//String sXmlRes = res.getBody().replaceAll('xsi:nil="true"', '');
			//System.debug('EN ConsultarInformacionModelo HTTP: ' + res + ' sXmlRes: ' + sXmlRes);
											
			//if (String.valueOf(res).contains('200') ){

				//Procesa la salida 
				String sXmlRes = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ConsultarPlazosResponse xmlns="http://tempuri.org/"><ConsultarPlazosResult><controlData xmlns=""><messageUUID xmlns="http://amx.com/mexico/telcel/esb/v1_1">1</messageUUID><responseDate xmlns="http://amx.com/mexico/telcel/esb/v1_1">2018-06-11T13:35:51.847-05:00</responseDate><sendBy xmlns="http://amx.com/mexico/telcel/esb/v1_1">Jarvis-SistemaPrecios</sendBy><latency xmlns="http://amx.com/mexico/telcel/esb/v1_1">148</latency><version xmlns="http://amx.com/mexico/telcel/esb/v1_1">1.0.0</version></controlData><detailResponse xmlns=""><code xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</code><severityLevel xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</severityLevel><description xmlns="http://amx.com/mexico/telcel/esb/v1_1">OPERACION EXITOSA</description></detailResponse><InformacionModelo xmlns=""><Modelo><descripcionModelo>3JTECH 3-G MODEM ROUTER ON LINE MF226</descripcionModelo><nombreComercial>3JTECH 3G MODEM ROUTER ON LINE MF226</nombreComercial><caracteristicas><tamanoPantalla/><nfc xsi:nil="true"/><simCard><tipoSim>SIM</tipoSim><tecnologiaSim>3G</tecnologiaSim><tipoSimCaract xsi:nil="true"/><versionesSim><versionSim><version>5.0 (SIM 3G)</version><listaMaterialSapSim><numeroMaterialSapSim>7000518</numeroMaterialSapSim></listaMaterialSapSim></versionSim></versionesSim></simCard><dimensiones xsi:nil="true"/><camaraFrontal/><camaraTrasera/><memoriaInterna/><memoriaLibre/><memoriaRam xsi:nil="true"/><sistemaOperativo>WCDMA/HSDPA 2100/1900/850(900)MHz</sistemaOperativo><duracionBateriaSb/><duracionBateriaLlamada/><tecnologiaPantalla/><procesador/><categoria>TRONCALES</categoria></caracteristicas><colores><color><nombre>GENERICO</nombre><listaMaterialesSap><materialSap><descripcion>3JTECH 3-G MODEM ROUTER ON LINE MF226</descripcion><tipoMaterialSap>MATERIALES POSPAGO</tipoMaterialSap><cveTipoMaterialSap>2</cveTipoMaterialSap><numMaterial>70008697</numMaterial></materialSap></listaMaterialesSap></color></colores></Modelo><movimientoWS>1211013</movimientoWS><estatusWS>0</estatusWS></InformacionModelo></ConsultarInformacionModeloResult></ConsultarInformacionModeloResponse></soap:Body></soap:Envelope>';
				sXmlRes = sXmlRes.replaceAll('xsi:nil="true"', '');
				System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo sXmlRes: ' + sXmlRes);				
				String sDetailResponse = '';
				String sInformacionModelo = '';
	
				//El detalle de la respuesta						
				if (sXmlRes.contains('detailResponse')){
					sDetailResponse = sXmlRes.substring(sXmlRes.indexOf('<detailResponse xmlns="">'), sXmlRes.indexOf('</detailResponse>'));
					sDetailResponse += '</detailResponse>';
					//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo sDetailResponse: ' + sDetailResponse);
					DOM.Document doc = new DOM.Document();
					doc.load(sDetailResponse);
					DOM.XMLNode nodeDR = doc.getRootElement();
					String sNameSpaceDR = 'http://amx.com/mexico/telcel/esb/v1_1';
					String code = nodeDR.getChildElement('code', sNameSpaceDR).getText();
					String severityLevel = nodeDR.getChildElement('severityLevel', sNameSpaceDR).getText();				
					String description = nodeDR.getChildElement('description', sNameSpaceDR).getText();
					detailResponseResul.code = code;
					detailResponseResul.description = description;
					detailResponseResul.severityLevel = Integer.valueOf(severityLevel);						
					System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo code: ' + code + ' ' + severityLevel + ' ' + description);					
				}//Fin si sXmlRes.contains('ConsultarInformacionModeloResult')
				
				//El detalle de mercados
				if (sXmlRes.contains('InformacionModelo')){
					sInformacionModelo = sXmlRes.substring(sXmlRes.indexOf('<InformacionModelo xmlns="">'), sXmlRes.lastIndexOf('</InformacionModelo>'));
					sInformacionModelo += '</InformacionModelo>';
					//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo InformacionModelo: ' + sInformacionModelo);
					DOM.Document doc = new DOM.Document();
					doc.load(sInformacionModelo);
					DOM.XMLNode nodeLM = doc.getRootElement();
					//Recorre la lista de hijos de nodeLM
					for(Dom.XMLNode nodeLMHijo : nodeLM.getChildElements()) {
						if (nodeLMHijo.getNodeType() == DOM.XMLNodeType.ELEMENT){
	       					System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo nodeLMHijo.getName(): ' + nodeLMHijo.getName());
	       					//Ve si tiene atributos el 
	       					if (nodeLMHijo.getName() == 'Modelo'){
								String descripcionModelo = '';
								String nombreComercial = '';
	       						//Toma los datos de sus atributos
								for(Dom.XMLNode nodeLMModelo : nodeLMHijo.getChildElements()) {
	       							System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo nodeLMModelo.getName(): ' + nodeLMModelo.getName() + ' ' + nodeLMModelo.getNamespace());
									if (nodeLMModelo.getName() == 'descripcionModelo')
										descripcionModelo = nodeLMModelo.getText();
									if (nodeLMModelo.getName() == 'nombreComercial')
										nombreComercial = nodeLMModelo.getText();
										
									//Para las caracteristicas
									if (nodeLMModelo.getName() == 'caracteristicas'){
										String tamanoPantalla = '';
										String nfc = '';
										String dimensiones = '';
										String camaraFrontal = '';
										String camaraTrasera = '';
										String memoriaInterna = '';
										String memoriaLibre = '';
										String memoriaRam = '';
										String sistemaOperativo = '';
										String duracionBateriaSb = '';
										String duracionBateriaLlamada = '';
										String tecnologiaPantalla = '';
										String procesador = '';
										String categoria = '';										
										//Recorre las caracteristicas
										for(Dom.XMLNode nodeLMCaracter : nodeLMModelo.getChildElements()) {									
											if (nodeLMCaracter.getNodeType() == DOM.XMLNodeType.ELEMENT){		
			       								System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes nodeLMCaracter.getName(): ' + nodeLMCaracter.getName());
												if (nodeLMCaracter.getName() == 'tamanoPantalla')
													tamanoPantalla = nodeLMCaracter.getText();
												if (nodeLMCaracter.getName() == 'nfc')
													nfc = nodeLMCaracter.getText();
												if (nodeLMCaracter.getName() == 'dimensiones')
													dimensiones = nodeLMCaracter.getText();
												if (nodeLMCaracter.getName() == 'camaraFrontal')
													camaraFrontal = nodeLMCaracter.getText();
												if (nodeLMCaracter.getName() == 'camaraTrasera')
													camaraTrasera = nodeLMCaracter.getText();
												if (nodeLMCaracter.getName() == 'memoriaInterna')
													memoriaInterna = nodeLMCaracter.getText();
												if (nodeLMCaracter.getName() == 'memoriaLibre')
													memoriaLibre = nodeLMCaracter.getText();
												if (nodeLMCaracter.getName() == 'memoriaRam')
													memoriaRam = nodeLMCaracter.getText();
												if (nodeLMCaracter.getName() == 'sistemaOperativo')
													sistemaOperativo = nodeLMCaracter.getText();
												if (nodeLMCaracter.getName() == 'duracionBateriaSb')
													duracionBateriaSb = nodeLMCaracter.getText();
												if (nodeLMCaracter.getName() == 'duracionBateriaLlamada')
													duracionBateriaLlamada = nodeLMCaracter.getText();
												if (nodeLMCaracter.getName() == 'tecnologiaPantalla')
													tecnologiaPantalla = nodeLMCaracter.getText();
												if (nodeLMCaracter.getName() == 'procesador')
													procesador = nodeLMCaracter.getText();
												if (nodeLMCaracter.getName() == 'categoria')
													categoria = nodeLMCaracter.getText();
													
			       								//Toma los datos del simCard
				       							if (nodeLMCaracter.getName() == 'simCard'){
													String tipoSim = '';
													String tecnologiaSim = '';
													String tipoSimCaract = '';
				       								
													//Recorre las simCard
													for(Dom.XMLNode nodeLMSimCard : nodeLMCaracter.getChildElements()) {									
														if (nodeLMSimCard.getNodeType() == DOM.XMLNodeType.ELEMENT){
			       											System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes nodeLMSimCard.getName(): ' + nodeLMSimCard.getName());																	
															if (nodeLMSimCard.getName() == 'tipoSim')
																tipoSim = nodeLMSimCard.getText();
															if (nodeLMSimCard.getName() == 'tecnologiaSim')
																tecnologiaSim = nodeLMSimCard.getText();
															if (nodeLMSimCard.getName() == 'tipoSimCaract')
																tipoSimCaract = nodeLMSimCard.getText();
															
															//la parte de la versiones de Sim
															if (nodeLMSimCard.getName() == 'versionesSim'){
																
																//Recorre las versionesSim
																for(Dom.XMLNode nodeLMVersSim : nodeLMSimCard.getChildElements()) {									
																	if (nodeLMVersSim.getNodeType() == DOM.XMLNodeType.ELEMENT){		
			       														System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes nodeLMVersSim.getName(): ' + nodeLMVersSim.getName());
																		if (nodeLMVersSim.getName() == 'versionSim'){
																			String version = '';
																																						
																			//Recorre las versionSim
																			for(Dom.XMLNode nodeLMVerSim : nodeLMVersSim.getChildElements()) {									
																				if (nodeLMVerSim.getNodeType() == DOM.XMLNodeType.ELEMENT){		
						       														System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes nodeLMVerSim.getName(): ' + nodeLMVerSim.getName());																			
																					if (nodeLMVerSim.getName() == 'version')
																						version = nodeLMVerSim.getText();
																						
																					if (nodeLMVerSim.getName() == 'listaMaterialSapSim'){
																						String numeroMaterialSapSim = '';
																						for(Dom.XMLNode nodeListMatSapSin : nodeLMVerSim.getChildElements()) {									
																							if (nodeListMatSapSin.getNodeType() == DOM.XMLNodeType.ELEMENT){		
																								
									       														System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes nodeListMatSapSin.getName(): ' + nodeListMatSapSin.getName());
																								if (nodeListMatSapSin.getName() == 'numeroMaterialSapSim')
																									numeroMaterialSapSim = nodeListMatSapSin.getText();

																							}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT	       							
															       						}//Fin dfel for para

																						//Crea los objetos del tipo DCT_TelcelEquiposSoap_ws.materialSapSim
																						DCT_TelcelEquiposSoap_ws.materialSapSim objMaterialSapSim = new DCT_TelcelEquiposSoap_ws.materialSapSim();
																						objMaterialSapSim.numeroMaterialSapSim = numeroMaterialSapSim;
																						lMaterialSapSim.add(objMaterialSapSim);
							       														System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes lMaterialSapSim: ' + lMaterialSapSim);
							       														
																					}//Fin nodeLMSimCard.getName() == 'listaMaterialSapSim'
																					 
																				}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT	       							
																				
												       						}//Fin dfel for para
																			
																			//Crea del objeto drl tipo DCT_TelcelEquiposSoap_ws.versionSim objVersionSim
																			DCT_TelcelEquiposSoap_ws.versionSim objVersionSim = new DCT_TelcelEquiposSoap_ws.versionSim();
																			objVersionSim.version = version;
																			objVersionSim.listaMaterialSapSim = lMaterialSapSim;
																			//Agregarlo a la lista de lArrayOfVersionSim
																			lVersionSim.add(objVersionSim);
				       														System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes lVersionSim: ' + lVersionSim);
																			//Muy bien iniciliza el campo de versionSim con lVersionSim
																			objArrayOfVersionSim.versionSim = lVersionSim;
				       														System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes objArrayOfVersionSim: ' + objArrayOfVersionSim);																			
																			
																		}//Fin de nodeLMCaracter.getName() == 'versionSim'

																	}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT
																		       							
									       						}//Fin dfel for para

															}//Fin si nodeLMCaracter.getName() == 'versionesSim'
															
														}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT
															       							
						       						}//Fin dfel for para
													
													//****Crea el objeto que va a guardar la info de simCard
													objSimCardCaracteristicasVO.tecnologiaSim = tecnologiaSim;
													objSimCardCaracteristicasVO.tipoSim = tipoSim;
													objSimCardCaracteristicasVO.tipoSimCaract = tipoSimCaract;
													objSimCardCaracteristicasVO.versionesSim = objArrayOfVersionSim;
													System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes objSimCardCaracteristicasVO: ' + objSimCardCaracteristicasVO);
													
				       							}//Fin si nodeLMSimCard.getName() == 'servicio'
				       							
											}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT
												       							
			       						}//Fin fel for para las caracteristicas
										
										//****Crea el objeto que va a guardar la info de caracteristicas
										objCaracteristicasVO.camaraFrontal = camaraFrontal;
										objCaracteristicasVO.camaraTrasera = camaraTrasera;
										objCaracteristicasVO.categoria = categoria;
										objCaracteristicasVO.dimensiones = dimensiones;
										objCaracteristicasVO.duracionBateriaLlamada = duracionBateriaLlamada;
										objCaracteristicasVO.duracionBateriaSb = duracionBateriaSb;
										objCaracteristicasVO.memoriaInterna = memoriaInterna;
										objCaracteristicasVO.memoriaLibre = memoriaLibre;
										objCaracteristicasVO.memoriaRam = memoriaRam;
										objCaracteristicasVO.nfc = 	nfc;
										objCaracteristicasVO.procesador = procesador;									 
										objCaracteristicasVO.sistemaOperativo = sistemaOperativo;
										objCaracteristicasVO.tamanoPantalla = tamanoPantalla;
										objCaracteristicasVO.tecnologiaPantalla = tecnologiaPantalla;
										System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes objCaracteristicasVO: ' + objCaracteristicasVO);
													
									}//nodeLMModelo.getName() == 'caracteristicas'
									
									//Sigue con los colores
									if (nodeLMModelo.getName() == 'colores'){
										//Ve por los hijos de los colores
										for(Dom.XMLNode nodeColores : nodeLMModelo.getChildElements()) {									
											if (nodeColores.getNodeType() == DOM.XMLNodeType.ELEMENT){		
												System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes nodeColores.getName(): ' + nodeColores.getName());
												//Los datos del color																			
												if (nodeColores.getName() == 'color'){
													String nombre = '';
													
													//Ve por los hijos de los color
													for(Dom.XMLNode nodeColor : nodeColores.getChildElements()) {									
														if (nodeColor.getNodeType() == DOM.XMLNodeType.ELEMENT){
															System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes nodeColor.getName(): ' + nodeColor.getName());

															//El detalle del material SAP																																
															if (nodeColor.getName() == 'nombre')
																nombre = nodeColor.getText();
																
															System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes EN LISTA MAT SAP VAL1: ' + nodeColor.getName() + ' ' + (nodeColor.getName() == 'listaMaterialesSap'));															
															//El detalle del material SAP																																
															if (nodeColor.getName() == 'listaMaterialesSap'){
																
																//Ve por los hijos de los listaMaterialesSap
																for(Dom.XMLNode nodeListMatSap : nodeColor.getChildElements()) {																										
																	if (nodeListMatSap.getNodeType() == DOM.XMLNodeType.ELEMENT){
																		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes nodeListMatSap.getName(): ' + nodeListMatSap.getName());
																																		
																		//El detalle del material SAP																																
																		if (nodeListMatSap.getName() == 'materialSap'){
																			
																			String descripcion = '';
																			String tipoMaterialSap = '';
																			String cveTipoMaterialSap = '';
																			String numMaterial = '';
																			
																			//Ve por los hijos del materialSap
																			for(Dom.XMLNode nodeMaterialSap : nodeListMatSap.getChildElements()) {									
																				if (nodeMaterialSap.getNodeType() == DOM.XMLNodeType.ELEMENT){
																					System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes nodeMaterialSap.getName(): ' + nodeMaterialSap.getName());
																																
																					if (nodeMaterialSap.getName() == 'descripcion')
																						descripcion = nodeMaterialSap.getText();
																					if (nodeMaterialSap.getName() == 'tipoMaterialSap')
																						tipoMaterialSap = nodeMaterialSap.getText();
																					if (nodeMaterialSap.getName() == 'cveTipoMaterialSap')
																						cveTipoMaterialSap = nodeMaterialSap.getText();
																					if (nodeMaterialSap.getName() == 'numMaterial')
																						numMaterial = nodeMaterialSap.getText();

																				}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT	       							
												       						}//Fin dfel for para
																			
																			//Crea el objeto del tipo DCT_TelcelEquiposSoap_ws.modeloMaterialSap
																			DCT_TelcelEquiposSoap_ws.modeloMaterialSap objModeloMaterialSap = new DCT_TelcelEquiposSoap_ws.modeloMaterialSap();
																			objModeloMaterialSap.descripcion = descripcion;
																			objModeloMaterialSap.tipoMaterialSap = tipoMaterialSap;
																			objModeloMaterialSap.cveTipoMaterialSap = Integer.valueOf(cveTipoMaterialSap);
																			objModeloMaterialSap.numMaterial = numMaterial;
																			System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes objModeloMaterialSap: ' + objModeloMaterialSap);																			
																			//Agregarlo a la lista de lModeloMaterialSap
																			lModeloMaterialSap.add(objModeloMaterialSap);
																			System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes lModeloMaterialSap: ' + lModeloMaterialSap);
																			//Inicializa el objeto de objArrayOfModeloMaterialSap.materialSap
																			objArrayOfModeloMaterialSap.materialSap = lModeloMaterialSap;
																			
																		}//Fin nodeListMatSap.getName() == 'materialSap'
																
																	}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT	       							
									       						}//Fin dfel for para
																
															}//Fin nodeColor.getName() == 'listaMaterialesSap'
																																														
														}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT	       							
						       						}//Fin dfel for para

													//La lista para el color
													DCT_TelcelEquiposSoap_ws.colorCaracteristicasVO objColorCaracteristicasVO = new DCT_TelcelEquiposSoap_ws.colorCaracteristicasVO ();
													objColorCaracteristicasVO.nombre = nombre;
													objColorCaracteristicasVO.listaMaterialesSap = objArrayOfModeloMaterialSap;													
													System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes objColorCaracteristicasVO: ' + objColorCaracteristicasVO);													
													lCcolorCaracteristicasVO.add(objColorCaracteristicasVO);
													System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes lCcolorCaracteristicasVO: ' + lCcolorCaracteristicasVO);													
													//Inicializa el arreglo de lCcolorCaracteristicasVO.color
													objArrayOfColorCaracteristicasVO.color = lCcolorCaracteristicasVO;
													System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes lModeloMaterialSap: ' + lModeloMaterialSap);
													
												}//Fin nodeColores.getName() == 'color'
												
											}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT	       							
			       						}//Fin dfel for para										
										
									}//Fin nodeLMModelo.getName() == 'colores'
									
	       						}//Fin dfel for para
	       						
	       						//Ve si tienen datos los campor para modelo
								if (descripcionModelo != null && nombreComercial != null){									
									objInformacionModelo = new DCT_TelcelEquiposSoap_ws.informacionModelo();
									objInformacionModelo.descripcionModelo = descripcionModelo;
									objInformacionModelo.nombreComercial = nombreComercial;
									lInformacionModelo.add(objInformacionModelo);
								}//Fin si cveMercado != null && descripcionMercado != null
								       						 
	       					}//Fin si nodeLMHijo.getName() == 'Mercado'
	       					
	       					//Ve si se trata de elemento movimientoWS
	       					if (nodeLMHijo.getName() == 'movimientoWS')
								objInformacionModeloOUTDTO.movimientoWS = Integer.valueOf(nodeLMHijo.getText());
	       					//Ve si se trata de elemento estatusWS
	       					if (nodeLMHijo.getName() == 'estatusWS')
								objInformacionModeloOUTDTO.estatusWS = Integer.valueOf(nodeLMHijo.getText());
								
						}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT
	        		}//Foin del for para nodeLM.getChildElements()
				}//Fin si sXmlRes.contains('ConsultarInformacionModeloResult')
	
				//System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo lInformacionModelo: ' + lInformacionModelo);
				//Inicializa el canpo de simCard con objSimCardCaracteristicasVO
				objCaracteristicasVO.simCard = objSimCardCaracteristicasVO;	
				//Inicializa el campo caracteristicas con objCaracteristicasVO
				objInformacionModelo.caracteristicas = objCaracteristicasVO; 
				//Inicializa los datos del color
				objInformacionModelo.colores = objArrayOfColorCaracteristicasVO;
				//Inicualiza la lista en el objeto de objInformacionModeloOUTDTO 
				objInformacionModeloOUTDTO.Modelo= lInformacionModelo;
				//Inicializa la lista en el objeto de InformacionModeloResponseDTOResult 
				InformacionModeloResponseDTOResult.InformacionModelo = objInformacionModeloOUTDTO;
				InformacionModeloResponseDTOResult.detailResponse = detailResponseResul;

			//}//Fin si String.valueOf(res).contains('200')
			 
		}catch(Exception ex){
			System.debug('ERROR EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo AL HACER EL LLAMADO AL WS: ' + ex.getMessage() + ' ' + ex.getLineNumber());
		}

		System.debug('EN DCT_TelcelEquiposSoap_ws.ConsultarInformacionModelo InformacionModeloResponseDTOResult: ' + InformacionModeloResponseDTOResult);		
		return InformacionModeloResponseDTOResult;
	}*/

}