public with sharing class DCT_TelcelPlanesMetodos_ws { 

	/*//Metodo ConsultarMercados
	public static DCT_TelcelPlanesSoap_ws.getMercadosResponseDTO ConsultarMercados(String slConsecCons, String sFuerzaVentas){
		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados slConsecCons: ' + slConsecCons + ' sFuerzaVentas: ' + sFuerzaVentas);
		
		//Para el objeto de regreso
		DCT_TelcelPlanesSoap_ws.getMercadosResponseDTO MercadosResponseDTOResult = new DCT_TelcelPlanesSoap_ws.getMercadosResponseDTO();
		//Un objeto del tipo planesMercadoWSOUTDTO para los datos de los mercados y los estatus del llamado al WS
		DCT_TelcelPlanesSoap_ws.planesMercadoWSOUTDTO objplanesMercadoWSOUTDTO = new DCT_TelcelPlanesSoap_ws.planesMercadoWSOUTDTO();
		//Uns lista para los mercados
		List<DCT_TelcelPlanesSoap_ws.planMercado> lMercados = new List<DCT_TelcelPlanesSoap_ws.planMercado>();
		//Un objeto para la respuesta 
		DCT_TelcelPlanesSoapEsb_ws.detailResponse detailResponseResul = new DCT_TelcelPlanesSoapEsb_ws.detailResponse();
		
		try{
	    	
			//Una prueba utilzando HTTP 
			HttpRequest request = new HttpRequest();
			request.setMethod('POST'); //'POST'
			request.setHeader('Content-Type', 'text/xml; charset=utf-8;');
			request.setHeader('Host', 'www.region9.telcel.com');
			request.setHeader('Cache-Control', 'no-cache');  			
			request.setEndpoint('https://www.region9.telcel.com/smartdistribuidores/PORTALES/PreciosSOAP/Planes.asmx');					
			request.setTimeout(120000 );
						
			//JSONBody = EncodingUtil.urlEncode(JSONBody, 'UTF-8');
			String JSONBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">' +
   				' <soapenv:Header/> ' +
   				'	<soapenv:Body> ' +
      			'		<tem:ConsultarMercados> ' +
         		' 			<tem:pMensajeID>' + slConsecCons + '</tem:pMensajeID> ' +
         		' 			<tem:pFuerzaVentaM2K>'+sFuerzaVentas+'</tem:pFuerzaVentaM2K> ' + 
      			' 		</tem:ConsultarMercados> ' + 
   				' 	</soapenv:Body>' +
				' </soapenv:Envelope>';
					
			//Incializa el Body con JSONBody						
			request.setBody(JSONBody);

			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados endpoint: ' + request.getEndpoint());
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados Accept: ' + request.getHeader('Accept'));			
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados Content-Type: ' + request.getHeader('Content-Type'));
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados Cache-Control: ' + request.getHeader('Cache-Control'));
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados Authorization: ' + request.getHeader('Authorization'));										
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados JSONBody: ' + JSONBody);

			HTTPResponse res;
			res = new Http().send(request);
			String sXmlRes = res.getBody();
			System.debug('EN ConsultarMercados HTTP: ' + res + ' sXmlRes: ' + sXmlRes);
											
			if (String.valueOf(res).contains('200') ){

				//Procesa la salida 
				//String sXmlRes = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ConsultarMercadosResponse xmlns="http://tempuri.org/"><ConsultarMercadosResult><controlData xmlns=""><messageUUID xmlns="http://amx.com/mexico/telcel/esb/v1_1">32</messageUUID><responseDate xmlns="http://amx.com/mexico/telcel/esb/v1_1">2018-06-11T08:46:44.837-05:00</responseDate><sendBy xmlns="http://amx.com/mexico/telcel/esb/v1_1">Jarvis-SistemaPrecios</sendBy><latency xmlns="http://amx.com/mexico/telcel/esb/v1_1">447</latency><version xmlns="http://amx.com/mexico/telcel/esb/v1_1">1.0.0</version></controlData><detailResponse xmlns=""><code xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</code><severityLevel xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</severityLevel><description xmlns="http://amx.com/mexico/telcel/esb/v1_1">Consulta exitosa</description></detailResponse><listaMercados xmlns=""><Mercado><cveMercado>2</cveMercado><descripcionMercado>CORPORATIVO</descripcionMercado></Mercado><Mercado><cveMercado>1</cveMercado><descripcionMercado>MASIVO</descripcionMercado></Mercado><Mercado><cveMercado>3</cveMercado><descripcionMercado>PRECORPORATIVO</descripcionMercado></Mercado><movimientoWS>1209917</movimientoWS><estatusWS>0</estatusWS></listaMercados></ConsultarMercadosResult></ConsultarMercadosResponse></soap:Body></soap:Envelope>';
				String sDetailResponse = '';
				String slistaMercados = '';
	
				//El detalle de la respuesta						
				if (sXmlRes.contains('detailResponse')){
					sDetailResponse = sXmlRes.substring(sXmlRes.indexOf('<detailResponse xmlns="">'), sXmlRes.indexOf('</detailResponse>'));
					sDetailResponse += '</detailResponse>';
					//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados sDetailResponse: ' + sDetailResponse);
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
					System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados code: ' + code + ' ' + severityLevel + ' ' + description);					
				}//Fin si sXmlRes.contains('ConsultarMercadosResult')
				
				//El detalle de mercados
				if (sXmlRes.contains('listaMercados')){
					slistaMercados = sXmlRes.substring(sXmlRes.indexOf('<listaMercados xmlns="">'), sXmlRes.lastIndexOf('</listaMercados>'));
					slistaMercados += '</listaMercados>';
					//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados listaMercados: ' + slistaMercados);
					DOM.Document doc = new DOM.Document();
					doc.load(slistaMercados);
					DOM.XMLNode nodeLM = doc.getRootElement();
					//Recorre la lista de hijos de nodeLM
					for(Dom.XMLNode nodeLMHijo : nodeLM.getChildElements()) {
						if (nodeLMHijo.getNodeType() == DOM.XMLNodeType.ELEMENT){
	       					System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados nodeLMHijo.getName(): ' + nodeLMHijo.getName());
	       					//Ve si tiene atributos el 
	       					if (nodeLMHijo.getName() == 'Mercado'){
								String cveMercado = '';
								String descripcionMercado = '';       						       						
	       						//Toma los datos de sus atributos
								for(Dom.XMLNode nodeLMMercado : nodeLMHijo.getChildElements()) {
	       							System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados nodeLMMercado.getName(): ' + nodeLMMercado.getName() + ' ' + nodeLMMercado.getNamespace());
									if (nodeLMMercado.getName() == 'cveMercado')
										cveMercado = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'descripcionMercado')
										descripcionMercado = nodeLMMercado.getText();
	       						}//Fin dfel for para
								if (cveMercado != null && descripcionMercado != null){
			           				System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados cveMercado: ' + cveMercado + ' descripcionMercado: ' + descripcionMercado);									
									DCT_TelcelPlanesSoap_ws.planMercado objPlanMercado = new DCT_TelcelPlanesSoap_ws.planMercado();
									objPlanMercado.cveMercado = Integer.valueOf(cveMercado);
									objPlanMercado.descripcionMercado = descripcionMercado;
									lMercados.add(objPlanMercado);
								}//Fin si cveMercado != null && descripcionMercado != null       						 
	       					}//Fin si nodeLMHijo.getName() == 'Mercado'
	       					
	       					//Ve si se trata de elemento movimientoWS
	       					if (nodeLMHijo.getName() == 'movimientoWS')
								objplanesMercadoWSOUTDTO.movimientoWS = Integer.valueOf(nodeLMHijo.getText());
	       					//Ve si se trata de elemento estatusWS
	       					if (nodeLMHijo.getName() == 'estatusWS')
								objplanesMercadoWSOUTDTO.estatusWS = Integer.valueOf(nodeLMHijo.getText());
						}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT
	        		}//Foin del for para nodeLM.getChildElements()
				}//Fin si sXmlRes.contains('ConsultarMercadosResult')
	
				//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados lMercados: ' + lMercados);
				//Inicualiza la lista en el objeto de objplanesMercadoWSOUTDTO 
				objplanesMercadoWSOUTDTO.Mercado = lMercados;
				//Inicializa la lista en el objeto de MercadosResponseDTOResult 
				MercadosResponseDTOResult.listaMercados = objplanesMercadoWSOUTDTO;
				MercadosResponseDTOResult.detailResponse = detailResponseResul;

			}//Fin si String.valueOf(res).contains('200')
			 
			//Ve si el campo JsonRes tiene algo
			if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') ){
				System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO ConsultarMercados objDtRespuesta: ' + sXmlRes);
			}//Fin si sXmlRes != null && sXmlRes.length() == 0

		}catch(Exception ex){
			System.debug('ERROR EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados AL HACER EL LLAMADO AL WS: ' + ex.getMessage() + ' ' + ex.getLineNumber());
		}

		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarMercados MercadosResponseDTOResult: ' + MercadosResponseDTOResult);		
		return MercadosResponseDTOResult;
	}*/
	
	/*//Metodo ConsultarGruposPlan
	public static DCT_TelcelPlanesSoap_ws.getGruposPlanResponseDTO ConsultarGruposPlan(String slConsecCons, String sFuerzaVentas, String sMercadoClave){
		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan slConsecCons: ' + slConsecCons + ' sFuerzaVentas: ' + sFuerzaVentas + ' ' + sMercadoClave);
		
		//Para el objeto de regreso
		DCT_TelcelPlanesSoap_ws.getGruposPlanResponseDTO GruposPlanResponseDTOResult = new DCT_TelcelPlanesSoap_ws.getGruposPlanResponseDTO();
		//Un objeto del tipo planesMercadoWSOUTDTO para los datos de los mercados y los estatus del llamado al WS
		DCT_TelcelPlanesSoap_ws.grupoPlanesMercadoOUTDTO objgrupoPlanesMercadoOUTDTO = new DCT_TelcelPlanesSoap_ws.grupoPlanesMercadoOUTDTO();
		//Uns lista para los mercados
		List<DCT_TelcelPlanesSoap_ws.grupoPlanMercado> lGrupoPlanMercado = new List<DCT_TelcelPlanesSoap_ws.grupoPlanMercado>();
		//Un objeto para la respuesta 
		DCT_TelcelPlanesSoapEsb_ws.detailResponse detailResponseResul = new DCT_TelcelPlanesSoapEsb_ws.detailResponse();
		
		try{
	    	
			//Una prueba utilzando HTTP 
			HttpRequest request = new HttpRequest();
			request.setMethod('POST'); //'POST'
			request.setHeader('Content-Type', 'text/xml; charset=utf-8;');
			request.setHeader('Host', 'www.region9.telcel.com');
			request.setHeader('Cache-Control', 'no-cache');  			
			request.setEndpoint('https://www.region9.telcel.com/smartdistribuidores/PORTALES/PreciosSOAP/Planes.asmx');					
			request.setTimeout(120000 );
						
			//JSONBody = EncodingUtil.urlEncode(JSONBody, 'UTF-8');
			String JSONBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">' +
   				' <soapenv:Header/> ' +
   				'	<soapenv:Body> ' +
      			'		<tem:ConsultarGruposPlan> ' +
         		' 			<tem:pMensajeID>'+slConsecCons+'</tem:pMensajeID> ' +
         		' 			<tem:pFuerzaVentaM2K>'+sFuerzaVentas+'</tem:pFuerzaVentaM2K> ' +
         		' 			<tem:pMercadoClave>'+sMercadoClave+'</tem:pMercadoClave> ' +         		
      			' 		</tem:ConsultarGruposPlan> ' + 
   				' 	</soapenv:Body>' +
				' </soapenv:Envelope>';
					
			//Incializa el Body con JSONBody						
			request.setBody(JSONBody);

			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan endpoint: ' + request.getEndpoint());
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan Accept: ' + request.getHeader('Accept'));			
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan Content-Type: ' + request.getHeader('Content-Type'));
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan Cache-Control: ' + request.getHeader('Cache-Control'));
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan Authorization: ' + request.getHeader('Authorization'));										
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan JSONBody: ' + JSONBody);

			HTTPResponse res;
			res = new Http().send(request);
			String sXmlRes = res.getBody();
			System.debug('EN ConsultarGruposPlan HTTP: ' + res + ' sXmlRes: ' + sXmlRes);
											
			if (String.valueOf(res).contains('200') ){

				//Procesa la salida 
				//String sXmlRes = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ConsultarGruposPlanResponse xmlns="http://tempuri.org/"><ConsultarGruposPlanResult><controlData xmlns=""><messageUUID xmlns="http://amx.com/mexico/telcel/esb/v1_1">1</messageUUID><responseDate xmlns="http://amx.com/mexico/telcel/esb/v1_1">2018-06-11T12:44:27.177-05:00</responseDate><sendBy xmlns="http://amx.com/mexico/telcel/esb/v1_1">Jarvis-SistemaPrecios</sendBy><latency xmlns="http://amx.com/mexico/telcel/esb/v1_1">320</latency><version xmlns="http://amx.com/mexico/telcel/esb/v1_1">1.0.0</version></controlData><detailResponse xmlns=""><code xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</code><severityLevel xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</severityLevel><description xmlns="http://amx.com/mexico/telcel/esb/v1_1">OPERACION EXITOSA</description></detailResponse><listaGruposPlan xmlns=""><GrupoPlan><cveGrupoPlan>90</cveGrupoPlan><cveSubGrupoPlan>389</cveSubGrupoPlan><descripcionGrupoPlan>INTERNET TELCEL</descripcionGrupoPlan><descripcionSubGrupoPlan>EMPRESA AA TECHO ALTO</descripcionSubGrupoPlan><grupoPlanSubgrupoPlan>INTERNET TELCEL - EMPRESA AA TECHO ALTO</grupoPlanSubgrupoPlan></GrupoPlan><GrupoPlan><cveGrupoPlan>90</cveGrupoPlan><cveSubGrupoPlan>388</cveSubGrupoPlan><descripcionGrupoPlan>INTERNET TELCEL</descripcionGrupoPlan><descripcionSubGrupoPlan>EMPRESA AA TECHO BAJO</descripcionSubGrupoPlan><grupoPlanSubgrupoPlan>INTERNET TELCEL - EMPRESA AA TECHO BAJO</grupoPlanSubgrupoPlan></GrupoPlan><movimientoWS>1210188</movimientoWS><estatusWS>0</estatusWS></listaGruposPlan></ConsultarGruposPlanResult></ConsultarGruposPlanResponse></soap:Body></soap:Envelope>';
				String sDetailResponse = '';
				String slistaGruposPlan = '';
	
				//El detalle de la respuesta						
				if (sXmlRes.contains('detailResponse')){
					sDetailResponse = sXmlRes.substring(sXmlRes.indexOf('<detailResponse xmlns="">'), sXmlRes.indexOf('</detailResponse>'));
					sDetailResponse += '</detailResponse>';
					//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan sDetailResponse: ' + sDetailResponse);
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
					System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan code: ' + code + ' ' + severityLevel + ' ' + description);					
				}//Fin si sXmlRes.contains('ConsultarGruposPlanResult')
				
				//El detalle de mercados
				if (sXmlRes.contains('listaGruposPlan')){
					slistaGruposPlan = sXmlRes.substring(sXmlRes.indexOf('<listaGruposPlan xmlns="">'), sXmlRes.lastIndexOf('</listaGruposPlan>'));
					slistaGruposPlan += '</listaGruposPlan>';
					//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan listaGruposPlan: ' + slistaGruposPlan);
					DOM.Document doc = new DOM.Document();
					doc.load(slistaGruposPlan);
					DOM.XMLNode nodeLM = doc.getRootElement();
					//Recorre la lista de hijos de nodeLM
					for(Dom.XMLNode nodeLMHijo : nodeLM.getChildElements()) {
						if (nodeLMHijo.getNodeType() == DOM.XMLNodeType.ELEMENT){
	       					//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan nodeLMHijo.getName(): ' + nodeLMHijo.getName());
	       					//Ve si tiene atributos el 
	       					if (nodeLMHijo.getName() == 'GrupoPlan'){
								String cveGrupoPlan = '';
								String cveSubGrupoPlan = '';
								String descripcionGrupoPlan = '';
								String descripcionSubGrupoPlan = '';
								String grupoPlanSubgrupoPlan = '';       						       						
	       						//Toma los datos de sus atributos
								for(Dom.XMLNode nodeLMMercado : nodeLMHijo.getChildElements()) {
	       							//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan nodeLMMercado.getName(): ' + nodeLMMercado.getName() + ' ' + nodeLMMercado.getNamespace());
									if (nodeLMMercado.getName() == 'cveGrupoPlan')
										cveGrupoPlan = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'cveSubGrupoPlan')
										cveSubGrupoPlan = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'descripcionGrupoPlan')
										descripcionGrupoPlan = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'descripcionSubGrupoPlan')
										descripcionSubGrupoPlan = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'grupoPlanSubgrupoPlan')
										grupoPlanSubgrupoPlan = nodeLMMercado.getText();
	       						}//Fin dfel for para
								if (cveGrupoPlan != null && cveSubGrupoPlan != null){
			           				//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan cveGrupoPlan: ' + cveGrupoPlan + ' cveSubGrupoPlan: ' + cveSubGrupoPlan);									
									DCT_TelcelPlanesSoap_ws.grupoPlanMercado objPlanMercado = new DCT_TelcelPlanesSoap_ws.grupoPlanMercado();
									objPlanMercado.cveGrupoPlan = Integer.valueOf(cveGrupoPlan);
									objPlanMercado.cveSubGrupoPlan = Integer.valueOf(cveSubGrupoPlan);
									objPlanMercado.descripcionGrupoPlan = descripcionGrupoPlan;
									objPlanMercado.descripcionSubGrupoPlan = descripcionSubGrupoPlan;
									objPlanMercado.grupoPlanSubgrupoPlan = grupoPlanSubgrupoPlan;
									lGrupoPlanMercado.add(objPlanMercado);
								}//Fin si cveGrupoPlan != null && cveSubGrupoPlan != null       						 
	       					}//Fin si nodeLMHijo.getName() == 'Mercado'
	       					
	       					//Ve si se trata de elemento movimientoWS
	       					if (nodeLMHijo.getName() == 'movimientoWS')
								objgrupoPlanesMercadoOUTDTO.movimientoWS = Integer.valueOf(nodeLMHijo.getText());
	       					//Ve si se trata de elemento estatusWS
	       					if (nodeLMHijo.getName() == 'estatusWS')
								objgrupoPlanesMercadoOUTDTO.estatusWS = Integer.valueOf(nodeLMHijo.getText());
						}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT
	        		}//Foin del for para nodeLM.getChildElements()
				}//Fin si sXmlRes.contains('ConsultarGruposPlanResult')
	
				//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan lGrupoPlanMercado: ' + lGrupoPlanMercado);
				//Inicualiza la lista en el objeto de objgrupoPlanesMercadoOUTDTO 
				objgrupoPlanesMercadoOUTDTO.GrupoPlan = lGrupoPlanMercado;
				//Inicializa la lista en el objeto de GruposPlanResponseDTOResult 
				GruposPlanResponseDTOResult.listaGruposPlan = objgrupoPlanesMercadoOUTDTO;
				GruposPlanResponseDTOResult.detailResponse = detailResponseResul;

			}//Fin si String.valueOf(res).contains('200')
			 
			//Ve si el campo JsonRes tiene algo
			if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') ){
				System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO ConsultarGruposPlan objDtRespuesta: ' + sXmlRes);
			}//Fin si sXmlRes != null && sXmlRes.length() == 0

		}catch(Exception ex){
			System.debug('ERROR EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan AL HACER EL LLAMADO AL WS: ' + ex.getMessage() + ' ' + ex.getLineNumber());
		}

		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan GruposPlanResponseDTOResult: ' + GruposPlanResponseDTOResult);		
		return GruposPlanResponseDTOResult;
	}*/
	
	public class wrpGrupoPlan{
		public List<DCT_CorporativoPlanesWs.GrupoPlan> lGrupoPlan {get;set;}
        public String Estatus {get;set;}
        public String Descripcion {get;set;}
        
        public wrpGrupoPlan(){
        	this.lGrupoPlan = new List<DCT_CorporativoPlanesWs.GrupoPlan>();
        	this.Estatus = null;
        	this.Descripcion = null;        	
        }
        
        public wrpGrupoPlan(List<DCT_CorporativoPlanesWs.GrupoPlan> lGrupoPlan, String Estatus,
        	String Descripcion){
        	this.lGrupoPlan = lGrupoPlan;
        	this.Estatus = Estatus;
        	this.Descripcion = Descripcion;
        }
	}
	
	//Metodo ConsultarGruposPlanCorp
	public static wrpGrupoPlan ConsultarGruposPlanCorp(){
		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlanCorp...');
		
		wrpGrupoPlan wrpGrupoPlanResul;
		
		try{
	    
			//Un objeto del tipo DCT_CorporativoPlanesWs.Corporativo_WServiceSoap
			DCT_CorporativoPlanesWs.Corporativo_WServiceSoap objCorporativoWServiceSoap = new DCT_CorporativoPlanesWs.Corporativo_WServiceSoap();
			//objCorporativoWServiceSoap.timeout_x = 120;
			//Para el objeto de regreso
			DCT_CorporativoPlanesWs.GrupoPlanSalida GrupoPlanSalidaResult = objCorporativoWServiceSoap.ObtenerGrupoPlan();
			System.debug(loggingLevel.Error, '*** GrupoPlanSalidaResult: ' + GrupoPlanSalidaResult);
			//Ve si hubo error a la hora de mandar llamar los servicios
			if (GrupoPlanSalidaResult.Estatus == 'OK'){
				//Busca los datos del servicio
				DCT_CorporativoPlanesWs.ArrayOfGrupoPlan objArrayOfGrupoPlan = GrupoPlanSalidaResult.xmlRetornoDatosGrupoPlan;
				wrpGrupoPlanResul = new wrpGrupoPlan(objArrayOfGrupoPlan.GrupoPlan, GrupoPlanSalidaResult.Estatus, 
					GrupoPlanSalidaResult.Descripcion);
			}//Fin si GrupoPlanSalidaResult.Estatus == '0'
			if (GrupoPlanSalidaResult.Estatus != 'OK'){
				//Busca los datos del servicio
				DCT_CorporativoPlanesWs.ArrayOfGrupoPlan objArrayOfGrupoPlan = GrupoPlanSalidaResult.xmlRetornoDatosGrupoPlan;
				wrpGrupoPlanResul = new wrpGrupoPlan(new List<DCT_CorporativoPlanesWs.GrupoPlan>(), GrupoPlanSalidaResult.Estatus, 
					GrupoPlanSalidaResult.Descripcion);				
			}//Fin si GrupoPlanSalidaResult.Estatus == '0'
			
		}catch(Exception ex){
			System.debug('ERROR EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlanCorp AL HACER EL LLAMADO AL WS: ' + ex.getMessage() + ' ' + ex.getLineNumber());
			wrpGrupoPlanResul = new wrpGrupoPlan(new List<DCT_CorporativoPlanesWs.GrupoPlan>(), 'ERR', ex.getMessage());
		}

		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlanCorp wrpGrupoPlanResul: ' + wrpGrupoPlanResul);		
		return wrpGrupoPlanResul;
	}


	/*//Metodo ConsultarPlazos
	public static DCT_TelcelPlanesSoap_ws.getPlazosResponseDTO ConsultarPlazos(String slConsecCons, String sFuerzaVentas, String sMercadoClave
		, String sGrupoPlanClave, String sSubGrupoPlanClave){
		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos slConsecCons: ' + slConsecCons + ' sFuerzaVentas: ' + sFuerzaVentas);
		
		//Para el objeto de regreso
		DCT_TelcelPlanesSoap_ws.getPlazosResponseDTO PlazosResponseDTOResult = new DCT_TelcelPlanesSoap_ws.getPlazosResponseDTO();
		//Un objeto del tipo planesMercadoWSOUTDTO para los datos de los mercados y los estatus del llamado al WS
		DCT_TelcelPlanesSoap_ws.planPlazoFVMercadoOUTDTO objPlanPlazoFVMercadoOUTDTO = new DCT_TelcelPlanesSoap_ws.planPlazoFVMercadoOUTDTO();
		//Uns lista para los mercados
		List<DCT_TelcelPlanesSoap_ws.planPlazoMercado> lPlanPlazoMercado = new List<DCT_TelcelPlanesSoap_ws.planPlazoMercado>();
		//Un objeto para la respuesta 
		DCT_TelcelPlanesSoapEsb_ws.detailResponse detailResponseResul = new DCT_TelcelPlanesSoapEsb_ws.detailResponse();
		
		try{
	    	
			//Una prueba utilzando HTTP 
			HttpRequest request = new HttpRequest();
			request.setMethod('POST'); //'POST'
			request.setHeader('Content-Type', 'text/xml; charset=utf-8;');
			request.setHeader('Host', 'www.region9.telcel.com');
			request.setHeader('Cache-Control', 'no-cache');  			
			request.setEndpoint('https://www.region9.telcel.com/smartdistribuidores/PORTALES/PreciosSOAP/Planes.asmx');					
			request.setTimeout(120000 );
						
			//JSONBody = EncodingUtil.urlEncode(JSONBody, 'UTF-8');
			String JSONBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">' +
   				' <soapenv:Header/> ' +
   				'	<soapenv:Body> ' +
      			'		<tem:ConsultarPlazos> ' +
         		' 			<tem:pMensajeID>'+slConsecCons+'</tem:pMensajeID> ' +
         		' 			<tem:pFuerzaVentaM2K>'+sFuerzaVentas+'</tem:pFuerzaVentaM2K> ' +
         		' 			<tem:pMercadoClave>'+sMercadoClave+'</tem:pMercadoClave> ' +
         		' 			<tem:pGrupoPlanClave>'+sGrupoPlanClave+'</tem:pGrupoPlanClave> ' +         		
         		' 			<tem:pSubGrupoPlanClave>'+sSubGrupoPlanClave+'</tem:pSubGrupoPlanClave> ' +
      			' 		</tem:ConsultarPlazos> ' + 
   				' 	</soapenv:Body>' +
				' </soapenv:Envelope>';
					
			//Incializa el Body con JSONBody						
			request.setBody(JSONBody);

			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos endpoint: ' + request.getEndpoint());
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos Accept: ' + request.getHeader('Accept'));			
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos Content-Type: ' + request.getHeader('Content-Type'));
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos Cache-Control: ' + request.getHeader('Cache-Control'));
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos Authorization: ' + request.getHeader('Authorization'));									
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos JSONBody: ' + JSONBody);

			HTTPResponse res;
			res = new Http().send(request);
			String sXmlRes = res.getBody();
			System.debug('EN ConsultarPlazos HTTP: ' + res + ' sXmlRes: ' + sXmlRes);
											
			if (String.valueOf(res).contains('200') ){

				//Procesa la salida 
				//String sXmlRes = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ConsultarPlazosResponse xmlns="http://tempuri.org/"><ConsultarPlazosResult><controlData xmlns=""><messageUUID xmlns="http://amx.com/mexico/telcel/esb/v1_1">1</messageUUID><responseDate xmlns="http://amx.com/mexico/telcel/esb/v1_1">2018-06-11T13:35:51.847-05:00</responseDate><sendBy xmlns="http://amx.com/mexico/telcel/esb/v1_1">Jarvis-SistemaPrecios</sendBy><latency xmlns="http://amx.com/mexico/telcel/esb/v1_1">148</latency><version xmlns="http://amx.com/mexico/telcel/esb/v1_1">1.0.0</version></controlData><detailResponse xmlns=""><code xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</code><severityLevel xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</severityLevel><description xmlns="http://amx.com/mexico/telcel/esb/v1_1">OPERACION EXITOSA</description></detailResponse><listaPlazos xmlns=""><Plazo><cvePlazo>1</cvePlazo><descripcionPlazo>LIBRE</descripcionPlazo><meses>0</meses></Plazo><Plazo><cvePlazo>3</cvePlazo><descripcionPlazo>12 MESES</descripcionPlazo><meses>12</meses></Plazo><movimientoWS>1210254</movimientoWS><estatusWS>0</estatusWS></listaPlazos></ConsultarPlazosResult></ConsultarPlazosResponse></soap:Body></soap:Envelope>';
				String sDetailResponse = '';
				String slistaPlazos = '';
	
				//El detalle de la respuesta						
				if (sXmlRes.contains('detailResponse')){
					sDetailResponse = sXmlRes.substring(sXmlRes.indexOf('<detailResponse xmlns="">'), sXmlRes.indexOf('</detailResponse>'));
					sDetailResponse += '</detailResponse>';
					//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos sDetailResponse: ' + sDetailResponse);
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
					System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos code: ' + code + ' ' + severityLevel + ' ' + description);					
				}//Fin si sXmlRes.contains('ConsultarPlazosResult')
				
				//El detalle de mercados
				if (sXmlRes.contains('listaPlazos')){
					slistaPlazos = sXmlRes.substring(sXmlRes.indexOf('<listaPlazos xmlns="">'), sXmlRes.lastIndexOf('</listaPlazos>'));
					slistaPlazos += '</listaPlazos>';
					//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos listaPlazos: ' + slistaPlazos);
					DOM.Document doc = new DOM.Document();
					doc.load(slistaPlazos);
					DOM.XMLNode nodeLM = doc.getRootElement();
					//Recorre la lista de hijos de nodeLM
					for(Dom.XMLNode nodeLMHijo : nodeLM.getChildElements()) {
						if (nodeLMHijo.getNodeType() == DOM.XMLNodeType.ELEMENT){
	       					//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos nodeLMHijo.getName(): ' + nodeLMHijo.getName());
	       					//Ve si tiene atributos el 
	       					if (nodeLMHijo.getName() == 'Plazo'){
								String cvePlazo = '';
								String descripcionPlazo = '';
								String meses = '';       						       						
	       						//Toma los datos de sus atributos
								for(Dom.XMLNode nodeLMMercado : nodeLMHijo.getChildElements()) {
	       							//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos nodeLMMercado.getName(): ' + nodeLMMercado.getName() + ' ' + nodeLMMercado.getNamespace());
									if (nodeLMMercado.getName() == 'cvePlazo')
										cvePlazo = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'descripcionPlazo')
										descripcionPlazo = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'meses')
										meses = nodeLMMercado.getText();
	       						}//Fin dfel for para
								if (cvePlazo != null && meses != null){
			           				//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos cvePlazo: ' + cvePlazo + ' cveSubPlazo: ' + cveSubPlazo);									
									DCT_TelcelPlanesSoap_ws.planPlazoMercado objPlanMercado = new DCT_TelcelPlanesSoap_ws.planPlazoMercado();
									objPlanMercado.cvePlazo = Integer.valueOf(cvePlazo);
									objPlanMercado.descripcionPlazo = descripcionPlazo;
									objPlanMercado.meses = Integer.valueOf(meses);
									lPlanPlazoMercado.add(objPlanMercado);
								}//Fin si cvePlazo != null && cveSubPlazo != null       						 
	       					}//Fin si nodeLMHijo.getName() == 'Mercado'
	       					
	       					//Ve si se trata de elemento movimientoWS
	       					if (nodeLMHijo.getName() == 'movimientoWS')
								objPlanPlazoFVMercadoOUTDTO.movimientoWS = Integer.valueOf(nodeLMHijo.getText());
	       					//Ve si se trata de elemento estatusWS
	       					if (nodeLMHijo.getName() == 'estatusWS')
								objPlanPlazoFVMercadoOUTDTO.estatusWS = Integer.valueOf(nodeLMHijo.getText());
						}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT
	        		}//Foin del for para nodeLM.getChildElements()
				}//Fin si sXmlRes.contains('ConsultarPlazosResult')
	
				//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos lPlanPlazoMercado: ' + lPlanPlazoMercado);
				//Inicualiza la lista en el objeto de objPlanPlazoFVMercadoOUTDTO 
				objPlanPlazoFVMercadoOUTDTO.Plazo = lPlanPlazoMercado;
				//Inicializa la lista en el objeto de PlazosResponseDTOResult 
				PlazosResponseDTOResult.listaPlazos = objPlanPlazoFVMercadoOUTDTO;
				PlazosResponseDTOResult.detailResponse = detailResponseResul;

			}//Fin si String.valueOf(res).contains('200')
			 
			//Ve si el campo JsonRes tiene algo
			if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') ){
				System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO ConsultarPlazos objDtRespuesta: ' + sXmlRes);
			}//Fin si sXmlRes != null && sXmlRes.length() == 0

		}catch(Exception ex){
			System.debug('ERROR EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos AL HACER EL LLAMADO AL WS: ' + ex.getMessage() + ' ' + ex.getLineNumber());
		}

		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazos PlazosResponseDTOResult: ' + PlazosResponseDTOResult);		
		return PlazosResponseDTOResult;
	}*/

	//Una clase wrp wrpPlazoResul
	public class wrpPlazo{
		public List<DCT_CorporativoPlanesWs.Plazo> lPlazo {get;set;}
        public String Estatus {get;set;}
        public String Descripcion {get;set;}
        
        public wrpPlazo(){
        	this.lPlazo = new List<DCT_CorporativoPlanesWs.Plazo>();
        	this.Estatus = null;
        	this.Descripcion = null;        	
        }
        
        public wrpPlazo(List<DCT_CorporativoPlanesWs.Plazo> lPlazo, String Estatus,
        	String Descripcion){
        	this.lPlazo = lPlazo;
        	this.Estatus = Estatus;
        	this.Descripcion = Descripcion;
        }
	}
	
	//Metodo ConsultarPlazosCorp
	public static wrpPlazo ConsultarPlazosCorp(){
		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazosCorp...');
		
		wrpPlazo wrpPlazoResul;
		
		try{
	    
			//Un objeto del tipo DCT_CorporativoPlanesWs.Corporativo_WServiceSoap
			DCT_CorporativoPlanesWs.Corporativo_WServiceSoap objCorporativoWServiceSoap = new DCT_CorporativoPlanesWs.Corporativo_WServiceSoap();
			//objCorporativoWServiceSoap.timeout_x = 120;			
			//Para el objeto de regreso
			DCT_CorporativoPlanesWs.PlazoSalida PlazoSalidaResult = objCorporativoWServiceSoap.ObtenerPlazo();
			//Ve si hubo error a la hora de mandar llamar los servicios
			if (PlazoSalidaResult.Estatus == 'OK'){
				//Busca los datos del servicio
				DCT_CorporativoPlanesWs.ArrayOfPlazo objArrayOfPlazo = PlazoSalidaResult.xmlRetornoDatosPlazo;
				wrpPlazoResul = new wrpPlazo(objArrayOfPlazo.Plazo, PlazoSalidaResult.Estatus, 
					PlazoSalidaResult.Descripcion);
			}//Fin si PlazoSalidaResult.Estatus == '0'
			if (PlazoSalidaResult.Estatus != 'OK'){
				//Busca los datos del servicio
				DCT_CorporativoPlanesWs.ArrayOfPlazo objArrayOfPlazo = PlazoSalidaResult.xmlRetornoDatosPlazo;
				wrpPlazoResul = new wrpPlazo(new List<DCT_CorporativoPlanesWs.Plazo>(), PlazoSalidaResult.Estatus, 
					PlazoSalidaResult.Descripcion);				
			}//Fin si PlazoSalidaResult.Estatus == '0'
			
		}catch(Exception ex){
			System.debug('ERROR EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazosCorp AL HACER EL LLAMADO AL WS: ' + ex.getMessage() + ' ' + ex.getLineNumber());
			wrpPlazoResul = new wrpPlazo(new List<DCT_CorporativoPlanesWs.Plazo>(), 'ERR', ex.getMessage());			
		}

		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlazosCorp wrpPlazoResul: ' + wrpPlazoResul);		
		return wrpPlazoResul;
	}


	/*//Metodo ConsultarPlanes
	public static DCT_TelcelPlanesSoap_ws.getPlanesResponseDTO ConsultarPlanes(String slConsecCons, String sFuerzaVentas, String sMercadoClave
		, String sPlazoClave, String sGrupoPlanClave, String sSubGrupoPlanClave){
		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes slConsecCons: ' + slConsecCons + ' sFuerzaVentas: ' + sFuerzaVentas);
		
		//Para el objeto de regreso
		DCT_TelcelPlanesSoap_ws.getPlanesResponseDTO PlanesResponseDTOResult = new DCT_TelcelPlanesSoap_ws.getPlanesResponseDTO();
		//Un objeto del tipo planesMercadoWSOUTDTO para los datos de los mercados y los estatus del llamado al WS
		DCT_TelcelPlanesSoap_ws.getPlanesOUTDTO objPlanesOUTDTO = new DCT_TelcelPlanesSoap_ws.getPlanesOUTDTO();
		//Uns lista para los mercados
		List<DCT_TelcelPlanesSoap_ws.planPlazoM2K> lPlanPlazoM2K = new List<DCT_TelcelPlanesSoap_ws.planPlazoM2K>();
		//Un objeto para la respuesta 
		DCT_TelcelPlanesSoapEsb_ws.detailResponse detailResponseResul = new DCT_TelcelPlanesSoapEsb_ws.detailResponse();
		
		try{
	    	
			//Una prueba utilzando HTTP 
			HttpRequest request = new HttpRequest();
			request.setMethod('POST'); //'POST'
			request.setHeader('Content-Type', 'text/xml; charset=utf-8;');
			request.setHeader('Host', 'www.region9.telcel.com');
			request.setHeader('Cache-Control', 'no-cache');  			
			request.setEndpoint('https://www.region9.telcel.com/smartdistribuidores/PORTALES/PreciosSOAP/Planes.asmx');					
			request.setTimeout(120000 );
						
			//JSONBody = EncodingUtil.urlEncode(JSONBody, 'UTF-8');
			String JSONBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">' +
   				' <soapenv:Header/> ' +
   				'	<soapenv:Body> ' +
      			'		<tem:ConsultarPlanes> ' +
         		' 			<tem:pMensajeID>32</tem:pMensajeID> ' +
         		' 			<tem:pFuerzaVentaM2K>'+sFuerzaVentas+'</tem:pFuerzaVentaM2K> ' +
         		' 			<tem:pMercadoClave>'+sMercadoClave+'</tem:pMercadoClave> ' +
         		' 			<tem:pPlazoClave>'+sPlazoClave+'</tem:pPlazoClave> ' +         		
         		' 			<tem:pGrupoPlanClave>'+sGrupoPlanClave+'</tem:pGrupoPlanClave> ' +         		
         		' 			<tem:pSubGrupoPlanClave>'+sSubGrupoPlanClave+'</tem:pSubGrupoPlanClave> ' +
      			' 		</tem:ConsultarPlanes> ' + 
   				' 	</soapenv:Body>' +
				' </soapenv:Envelope>';
					
			//Incializa el Body con JSONBody						
			request.setBody(JSONBody);

			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes endpoint: ' + request.getEndpoint());
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes Accept: ' + request.getHeader('Accept'));			
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes Content-Type: ' + request.getHeader('Content-Type'));
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes Cache-Control: ' + request.getHeader('Cache-Control'));
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes Authorization: ' + request.getHeader('Authorization'));										
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes JSONBody: ' + JSONBody);

			HTTPResponse res;
			res = new Http().send(request);
			String sXmlRes = res.getBody();
			System.debug('EN ConsultarPlanes HTTP: ' + res + ' sXmlRes: ' + sXmlRes);
											
			if (String.valueOf(res).contains('200') ){

				//Procesa la salida 
				//String sXmlRes = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ConsultarPlazosResponse xmlns="http://tempuri.org/"><ConsultarPlazosResult><controlData xmlns=""><messageUUID xmlns="http://amx.com/mexico/telcel/esb/v1_1">1</messageUUID><responseDate xmlns="http://amx.com/mexico/telcel/esb/v1_1">2018-06-11T13:35:51.847-05:00</responseDate><sendBy xmlns="http://amx.com/mexico/telcel/esb/v1_1">Jarvis-SistemaPrecios</sendBy><latency xmlns="http://amx.com/mexico/telcel/esb/v1_1">148</latency><version xmlns="http://amx.com/mexico/telcel/esb/v1_1">1.0.0</version></controlData><detailResponse xmlns=""><code xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</code><severityLevel xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</severityLevel><description xmlns="http://amx.com/mexico/telcel/esb/v1_1">OPERACION EXITOSA</description></detailResponse><listaPlanes xmlns=""><plan><cvePlanM2k>DK148</cvePlanM2k><descripcionPlan>INTERNET TELCEL EMPRESA 500 MB AA TA PYME</descripcionPlan></plan><plan><cvePlanM2k>DK153</cvePlanM2k><descripcionPlan>INTERNET TELCEL EMPRESA 1000 AA TA PYME</descripcionPlan></plan><movimientoWS>1210304</movimientoWS><estatusWS>0</estatusWS></listaPlanes></ConsultarPlanesResult></ConsultarPlanesResponse></soap:Body></soap:Envelope>';
				String sDetailResponse = '';
				String slistaPlanes = '';
	
				//El detalle de la respuesta						
				if (sXmlRes.contains('detailResponse')){
					sDetailResponse = sXmlRes.substring(sXmlRes.indexOf('<detailResponse xmlns="">'), sXmlRes.indexOf('</detailResponse>'));
					sDetailResponse += '</detailResponse>';
					//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes sDetailResponse: ' + sDetailResponse);
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
					System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes code: ' + code + ' ' + severityLevel + ' ' + description);					
				}//Fin si sXmlRes.contains('ConsultarPlanesResult')
				
				//El detalle de mercados
				if (sXmlRes.contains('listaPlanes')){
					slistaPlanes = sXmlRes.substring(sXmlRes.indexOf('<listaPlanes xmlns="">'), sXmlRes.lastIndexOf('</listaPlanes>'));
					slistaPlanes += '</listaPlanes>';
					//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes listaPlanes: ' + slistaPlanes);
					DOM.Document doc = new DOM.Document();
					doc.load(slistaPlanes);
					DOM.XMLNode nodeLM = doc.getRootElement();
					//Recorre la lista de hijos de nodeLM
					for(Dom.XMLNode nodeLMHijo : nodeLM.getChildElements()) {
						if (nodeLMHijo.getNodeType() == DOM.XMLNodeType.ELEMENT){
	       					//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes nodeLMHijo.getName(): ' + nodeLMHijo.getName());
	       					//Ve si tiene atributos el 
	       					if (nodeLMHijo.getName() == 'plan'){
								String cvePlanM2k = '';
								String descripcionplan = '';       						       						
	       						//Toma los datos de sus atributos
								for(Dom.XMLNode nodeLMMercado : nodeLMHijo.getChildElements()) {
	       							//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes nodeLMMercado.getName(): ' + nodeLMMercado.getName() + ' ' + nodeLMMercado.getNamespace());
									if (nodeLMMercado.getName() == 'cvePlanM2k')
										cvePlanM2k = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'descripcionPlan')
										descripcionplan = nodeLMMercado.getText();
	       						}//Fin dfel for para
								if (cvePlanM2k != null){
			           				//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes cveplan: ' + cveplan + ' cveSubplan: ' + cveSubplan);									
									DCT_TelcelPlanesSoap_ws.planPlazoM2K objPlanMercado = new DCT_TelcelPlanesSoap_ws.planPlazoM2K();
									objPlanMercado.cvePlanM2k = cvePlanM2k;
									objPlanMercado.descripcionplan = descripcionplan;
									lPlanPlazoM2K.add(objPlanMercado);
								}//Fin si cvePlazo != null && cveSubPlazo != null       						 
	       					}//Fin si nodeLMHijo.getName() == 'Mercado'
	       					
	       					//Ve si se trata de elemento movimientoWS
	       					if (nodeLMHijo.getName() == 'movimientoWS')
								objPlanesOUTDTO.movimientoWS = Integer.valueOf(nodeLMHijo.getText());
	       					//Ve si se trata de elemento estatusWS
	       					if (nodeLMHijo.getName() == 'estatusWS')
								objPlanesOUTDTO.estatusWS = Integer.valueOf(nodeLMHijo.getText());
						}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT
	        		}//Foin del for para nodeLM.getChildElements()
				}//Fin si sXmlRes.contains('ConsultarPlanesResult')
	
				//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes lPlanPlazoM2K: ' + lPlanPlazoM2K);
				//Inicualiza la lista en el objeto de objPlanesOUTDTO 
				objPlanesOUTDTO.plan = lPlanPlazoM2K;
				//Inicializa la lista en el objeto de PlanesResponseDTOResult 
				PlanesResponseDTOResult.listaPlanes = objPlanesOUTDTO;
				PlanesResponseDTOResult.detailResponse = detailResponseResul;

			}//Fin si String.valueOf(res).contains('200')
			 
			//Ve si el campo JsonRes tiene algo
			if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') ){
				System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO ConsultarPlanes objDtRespuesta: ' + sXmlRes);
			}//Fin si sXmlRes != null && sXmlRes.length() == 0

		}catch(Exception ex){
			System.debug('ERROR EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes AL HACER EL LLAMADO AL WS: ' + ex.getMessage() + ' ' + ex.getLineNumber());
		}

		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanes PlanesResponseDTOResult: ' + PlanesResponseDTOResult);		
		return PlanesResponseDTOResult;
	}*/


	//Una clase wrp wrpPlazoResul
	public class wrpPlan{
		public List<DCT_CorporativoPlanesWs.Plan> lPlan {get;set;}
        public String Estatus {get;set;}
        public String Descripcion {get;set;}
        
        public wrpPlan(){
        	this.lPlan = new List<DCT_CorporativoPlanesWs.Plan>();
        	this.Estatus = null;
        	this.Descripcion = null;        	
        }
        
        public wrpPlan(List<DCT_CorporativoPlanesWs.Plan> lPlan, String Estatus,
        	String Descripcion){
        	this.lPlan = lPlan;
        	this.Estatus = Estatus;
        	this.Descripcion = Descripcion;
        }
	}

	//Metodo ConsultarPlanesCorp
	public static wrpPlan ConsultarPlanesCorp(Integer iIdGrupoPlan, Integer iIdPlazo){
		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanesCorp...');
		
		wrpPlan wrpPlanResul;
		
		try{
	    
			//Un objeto del tipo DCT_CorporativoPlanesWs.Corporativo_WServiceSoap
			DCT_CorporativoPlanesWs.Corporativo_WServiceSoap objCorporativoWServiceSoap = new DCT_CorporativoPlanesWs.Corporativo_WServiceSoap();
			//objCorporativoWServiceSoap.timeout_x = 120;			
			//Para el objeto de regreso
			DCT_CorporativoPlanesWs.PlanSalida PlanSalidaResult = objCorporativoWServiceSoap.ObtenerPlan(iIdGrupoPlan, iIdPlazo);
			//Ve si hubo error a la hora de mandar llamar los servicios
			if (PlanSalidaResult.Estatus == 'OK'){
				//Busca los datos del servicio
				DCT_CorporativoPlanesWs.ArrayOfPlan objArrayOfPlan = PlanSalidaResult.xmlRetornoDatosPlan;
				wrpPlanResul = new wrpPlan(objArrayOfPlan.Plan, PlanSalidaResult.Estatus, 
					PlanSalidaResult.Descripcion);
			}//Fin si PlanSalidaResult.Estatus == '0'
			if (PlanSalidaResult.Estatus != 'OK'){
				//Busca los datos del servicio
				DCT_CorporativoPlanesWs.ArrayOfPlan objArrayOfPlan = PlanSalidaResult.xmlRetornoDatosPlan;
				wrpPlanResul = new wrpPlan(new List<DCT_CorporativoPlanesWs.Plan>(), PlanSalidaResult.Estatus, 
					PlanSalidaResult.Descripcion);				
			}//Fin si PlanSalidaResult.Estatus == '0'
			
		}catch(Exception ex){
			System.debug('ERROR EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanesCorp AL HACER EL LLAMADO AL WS: ' + ex.getMessage() + ' ' + ex.getLineNumber());
			wrpPlanResul = new wrpPlan(new List<DCT_CorporativoPlanesWs.Plan>(), 'ERR', ex.getMessage());
		}

		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarPlanesCorp wrpPlanResul: ' + wrpPlanResul);		
		return wrpPlanResul;
	}

	/*//Metodo ConsultarGuiaPlanes
	public static DCT_TelcelPlanesSoap_ws.getGuiaPlanesResponseDTO ConsultarGuiaPlanes(String slConsecCons, String sFuerzaVentas, String sPlanClave){
		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes slConsecCons: ' + slConsecCons + ' sFuerzaVentas: ' + sFuerzaVentas);
		
		//Para el objeto de regreso
		DCT_TelcelPlanesSoap_ws.getGuiaPlanesResponseDTO GuiaPlanesResponseDTOResult = new DCT_TelcelPlanesSoap_ws.getGuiaPlanesResponseDTO();
		//Un objeto del tipo planesMercadoWSOUTDTO para los datos de los mercados y los estatus del llamado al WS
		DCT_TelcelPlanesSoap_ws.guiaPlanesOUTDTO objGuiaPlanesOUTDTO = new DCT_TelcelPlanesSoap_ws.guiaPlanesOUTDTO();
		//Un objeto del tipo DCT_TelcelPlanesSoap_ws.guiaPlanesCaracteristicasDTO
		DCT_TelcelPlanesSoap_ws.guiaPlanesCaracteristicasDTO objGuiaPlanesCaracteristicasDTO = new DCT_TelcelPlanesSoap_ws.guiaPlanesCaracteristicasDTO();
		//Un objeto del tipo DCT_TelcelPlanesSoap_ws.ArrayOfGuiaPlanesServiciosDTO
		List<DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO> lGuiaPlanesServiciosDTO  = new List<DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO>();
		//Un objeto del tipo DCT_TelcelPlanesSoap_ws.ArrayOfGuiaPlanesServiciosDTO
		DCT_TelcelPlanesSoap_ws.ArrayOfGuiaPlanesServiciosDTO objArrayOfGuiaPlanesServiciosDTO = new DCT_TelcelPlanesSoap_ws.ArrayOfGuiaPlanesServiciosDTO();
		//Un objeto para la respuesta 
		DCT_TelcelPlanesSoapEsb_ws.detailResponse detailResponseResul = new DCT_TelcelPlanesSoapEsb_ws.detailResponse();

		try{
	    	
			//Una prueba utilzando HTTP 
			HttpRequest request = new HttpRequest();
			request.setMethod('POST'); //'POST'
			request.setHeader('Content-Type', 'text/xml; charset=utf-8;');
			request.setHeader('Host', 'www.region9.telcel.com');
			request.setHeader('Cache-Control', 'no-cache');  			
			request.setEndpoint('https://www.region9.telcel.com/smartdistribuidores/PORTALES/PreciosSOAP/Planes.asmx');					
			request.setTimeout(120000 );
						
			//JSONBody = EncodingUtil.urlEncode(JSONBody, 'UTF-8');
			String JSONBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">' +
   				' <soapenv:Header/> ' +
   				'	<soapenv:Body> ' +
      			'		<tem:ConsultarGuiaPlanes> ' +
         		' 			<tem:pMensajeID>'+slConsecCons+'</tem:pMensajeID> ' +
         		' 			<tem:pFuerzaVentaM2K>'+sFuerzaVentas+'</tem:pFuerzaVentaM2K> ' +
         		' 			<tem:pPlanClave>'+sPlanClave+'</tem:pPlanClave> ' +
      			' 		</tem:ConsultarGuiaPlanes> ' + 
   				' 	</soapenv:Body>' +
				' </soapenv:Envelope>';
					
			//Incializa el Body con JSONBody						
			request.setBody(JSONBody);

			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes endpoint: ' + request.getEndpoint());
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes Accept: ' + request.getHeader('Accept'));			
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes Content-Type: ' + request.getHeader('Content-Type'));
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes Cache-Control: ' + request.getHeader('Cache-Control'));
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes Authorization: ' + request.getHeader('Authorization'));										
			//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes JSONBody: ' + JSONBody);

			HTTPResponse res;
			res = new Http().send(request);
			String sXmlRes = res.getBody().replaceAll('xsi:nil="true"', '');
			System.debug('EN ConsultarGuiaPlanes HTTP: ' + res + ' sXmlRes: ' + sXmlRes);
											
			if (String.valueOf(res).contains('200') ){

				//Procesa la salida 
				//String sXmlRes = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ConsultarPlazosResponse xmlns="http://tempuri.org/"><ConsultarPlazosResult><controlData xmlns=""><messageUUID xmlns="http://amx.com/mexico/telcel/esb/v1_1">1</messageUUID><responseDate xmlns="http://amx.com/mexico/telcel/esb/v1_1">2018-06-11T13:35:51.847-05:00</responseDate><sendBy xmlns="http://amx.com/mexico/telcel/esb/v1_1">Jarvis-SistemaPrecios</sendBy><latency xmlns="http://amx.com/mexico/telcel/esb/v1_1">148</latency><version xmlns="http://amx.com/mexico/telcel/esb/v1_1">1.0.0</version></controlData><detailResponse xmlns=""><code xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</code><severityLevel xmlns="http://amx.com/mexico/telcel/esb/v1_1">0</severityLevel><description xmlns="http://amx.com/mexico/telcel/esb/v1_1">OPERACION EXITOSA</description></detailResponse><listaPlanes xmlns=""><caracteristicas><cvePlanM2k>YU585</cvePlanM2k><nombrePlan>GVT AUTO-ADMINISTRADO</nombrePlan><plazo>18 MESES</plazo><cargoMensualServicio>329</cargoMensualServicio><cargoMensualEquipo>Dependiendo del Precio de la Marca y Modelo adquirido en la Contratación</cargoMensualEquipo><cargoMensualTotal>Cargo Mensual por Servicio + Cargo Mensual por Equip</cargoMensualTotal><minutosIndistintos>NO APLICA</minutosIndistintos><tipoMinutosIndistintos xsi:nil="true"/><comentarioMinutosIndistintos xsi:nil="true"/><minutos xsi:nil="true"/><tipoMinutos xsi:nil="true"/><numerosGratis xsi:nil="true"/><comentarioNumerosGratis xsi:nil="true"/><mensajesTextoIndistintos>NO APLICA</mensajesTextoIndistintos><tipoMensajesTextoIndistintos xsi:nil="true"/><comentarioMensajesTextoInd xsi:nil="true"/><costoMensajeTxtAdiNacionalInd xsi:nil="true"/><mensajesTexto xsi:nil="true"/><tipoMensajesTexto xsi:nil="true"/><costoMensajeTextoAdicional xsi:nil="true"/><comentarioMensajesTexto xsi:nil="true"/><costoMensajeMultaAdiNac xsi:nil="true"/><capacidadDatos>100 MB</capacidadDatos><descripcionTasacion>OTROS</descripcionTasacion><tipoDatos>SIN FRONTERA SOLO GVT</tipoDatos><costoKbTransmisionDatos>0.000244</costoKbTransmisionDatos><costoMbTransmisionDatos>0.25</costoMbTransmisionDatos><comentarioDatos xsi:nil="true"/><comentarioPenaCanceAnti xsi:nil="true"/><fianzaAnual>200</fianzaAnual></caracteristicas><promociones/><servicios><servicio><id>AVGV2</id><tipoProducto>SERVICIOS INCLUIDOS</tipoProducto><nombre>GVT Auto Administrado</nombre><descripcion>GVT Auto Administrado</descripcion><precio>0.0</precio><indicadorEquipo>TODOS</indicadorEquipo><tipoServicio>OTROS</tipoServicio><origen>MOBILE</origen></servicio><servicio><id>GI104</id><tipoProducto>SERVICIOS INCLUIDOS</tipoProducto><nombre>Internet 100 MB</nombre><descripcion>Internet 100 MB</descripcion><precio>0.0</precio><indicadorEquipo>TODOS</indicadorEquipo><tipoServicio>DATOS</tipoServicio><origen>MOBILE</origen></servicio></servicios><casosTrafico/><estatus>0</estatus><descEstatus>Consulta exitosa</descEstatus><movimiento>1212615</movimiento></listaPlanes></ConsultarGuiaPlanesResult></ConsultarGuiaPlanesResponse></soap:Body></soap:Envelope>';
				//sXmlRes = sXmlRes.replaceAll('xsi:nil="true"', '');
				String sDetailResponse = '';
				String slistaPlanes = '';
	
				//El detalle de la respuesta						
				if (sXmlRes.contains('detailResponse')){
					sDetailResponse = sXmlRes.substring(sXmlRes.indexOf('<detailResponse xmlns="">'), sXmlRes.indexOf('</detailResponse>'));
					sDetailResponse += '</detailResponse>';
					//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes sDetailResponse: ' + sDetailResponse);
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
					System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes code: ' + code + ' ' + severityLevel + ' ' + description);					
				}//Fin si sXmlRes.contains('ConsultarGuiaPlanesResult')
				
				//El detalle de mercados
				if (sXmlRes.contains('listaPlanes')){
					slistaPlanes = sXmlRes.substring(sXmlRes.indexOf('<listaPlanes xmlns="">'), sXmlRes.lastIndexOf('</listaPlanes>'));
					slistaPlanes += '</listaPlanes>';
					//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes listaPlanes: ' + slistaPlanes);
					DOM.Document doc = new DOM.Document();
					doc.load(slistaPlanes);
					DOM.XMLNode nodeLM = doc.getRootElement();
					//Recorre la lista de hijos de nodeLM
					for(Dom.XMLNode nodeLMHijo : nodeLM.getChildElements()) {
						if (nodeLMHijo.getNodeType() == DOM.XMLNodeType.ELEMENT){
	       					System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes nodeLMHijo.getName(): ' + nodeLMHijo.getName());
	       					if (nodeLMHijo.getName() == 'caracteristicas'){
									String capacidadDatos = '';
									String cargoMensualEquipo = '';
									String cargoMensualServicio = '';
									String cargoMensualTotal = '';
									String comentarioDatos = '';
									String comentarioMensajesTexto = '';
									String comentarioMensajesTextoInd = '';
									String comentarioMinutosIndistintos = '';
									String comentarioNumerosGratis = '';
									String comentarioPenaCanceAnti = '';
									String costoKbTransmisionDatos = '';
									String costoMbTransmisionDatos = '';
									String costoMensajeMultaAdiNac = '';
									String costoMensajeTextoAdicional = '';
									String costoMensajeTxtAdiNacionalInd = '';
									String cvePlanM2k = '';
									String descripcionTasacion = '';
									String fianzaAnual = '';
									String mensajesTexto = '';
									String mensajesTextoIndistintos = '';
									String minutos = '';
									String minutosIndistintos = '';
									String nombrePlan = '';
									String numerosGratis = '';
									String plazo = '';
									String tipoDatos = '';
									String tipoMensajesTexto = '';
									String tipoMensajesTextoIndistintos = '';
									String tipoMinutos = '';
									String tipoMinutosIndistintos = '';		
	       						//Toma los datos de sus atributos
								for(Dom.XMLNode nodeLMMercado : nodeLMHijo.getChildElements()) {
	       							//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes nodeLMMercado.getName(): ' + nodeLMMercado.getName() + ' ' + nodeLMMercado.getNamespace());
									if (nodeLMMercado.getName() == 'capacidadDatos')	       							
										capacidadDatos = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'cargoMensualEquipo')										
										cargoMensualEquipo = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'cargoMensualServicio')										
										cargoMensualServicio = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'cargoMensualTotal')										
										cargoMensualTotal = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'comentarioDatos')										
										comentarioDatos = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'comentarioMensajesTexto')										
										comentarioMensajesTexto = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'comentarioMensajesTextoInd')										
										comentarioMensajesTextoInd = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'comentarioMinutosIndistintos')										
										comentarioMinutosIndistintos = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'comentarioNumerosGratis')										
										comentarioNumerosGratis = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'comentarioPenaCanceAnti')										
										comentarioPenaCanceAnti = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'costoKbTransmisionDatos')										
										costoKbTransmisionDatos = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'costoMbTransmisionDatos')										
										costoMbTransmisionDatos = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'costoMensajeMultaAdiNac')										
										costoMensajeMultaAdiNac = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'costoMensajeTextoAdicional')										
										costoMensajeTextoAdicional = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'costoMensajeTxtAdiNacionalInd')										
										costoMensajeTxtAdiNacionalInd = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'cvePlanM2k')										
										cvePlanM2k = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'descripcionTasacion')										
										descripcionTasacion = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'fianzaAnual')										
										fianzaAnual = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'mensajesTexto')
										mensajesTexto = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'mensajesTextoIndistintos')										
										mensajesTextoIndistintos = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'minutos')										
										minutos = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'minutosIndistintos')										
										minutosIndistintos = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'nombrePlan')										
										nombrePlan = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'numerosGratis')										
										numerosGratis = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'plazo')										
										plazo = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'tipoDatos')										
										tipoDatos = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'tipoMensajesTexto')										
										tipoMensajesTexto = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'tipoMensajesTextoIndistintos')										
										tipoMensajesTextoIndistintos = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'tipoMinutos')										
										tipoMinutos = nodeLMMercado.getText();
									if (nodeLMMercado.getName() == 'tipoMinutosIndistintos')										
										tipoMinutosIndistintos = nodeLMMercado.getText();
	       						}//Fin dfel for para
								if (cvePlanM2k != null){
			           				//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes cveplan: ' + cveplan + ' cveSubplan: ' + cveSubplan);									
									objGuiaPlanesCaracteristicasDTO.capacidadDatos = capacidadDatos;
									objGuiaPlanesCaracteristicasDTO.cargoMensualEquipo = cargoMensualEquipo;
									objGuiaPlanesCaracteristicasDTO.cargoMensualServicio = cargoMensualServicio;
									objGuiaPlanesCaracteristicasDTO.cargoMensualTotal = cargoMensualTotal;
									objGuiaPlanesCaracteristicasDTO.comentarioDatos = comentarioDatos;
									objGuiaPlanesCaracteristicasDTO.comentarioMensajesTexto = comentarioMensajesTexto;
									objGuiaPlanesCaracteristicasDTO.comentarioMensajesTextoInd = comentarioMensajesTextoInd;
									objGuiaPlanesCaracteristicasDTO.comentarioMinutosIndistintos = comentarioMinutosIndistintos;
									objGuiaPlanesCaracteristicasDTO.comentarioNumerosGratis = comentarioNumerosGratis;
									objGuiaPlanesCaracteristicasDTO.comentarioPenaCanceAnti = comentarioPenaCanceAnti;
									objGuiaPlanesCaracteristicasDTO.costoKbTransmisionDatos = costoKbTransmisionDatos;
									objGuiaPlanesCaracteristicasDTO.costoMbTransmisionDatos = costoMbTransmisionDatos;
									objGuiaPlanesCaracteristicasDTO.costoMensajeMultaAdiNac = costoMensajeMultaAdiNac;
									objGuiaPlanesCaracteristicasDTO.costoMensajeTextoAdicional = costoMensajeTextoAdicional;
									objGuiaPlanesCaracteristicasDTO.costoMensajeTxtAdiNacionalInd = costoMensajeTxtAdiNacionalInd;
									objGuiaPlanesCaracteristicasDTO.cvePlanM2k = cvePlanM2k;
									objGuiaPlanesCaracteristicasDTO.descripcionTasacion = descripcionTasacion;
									objGuiaPlanesCaracteristicasDTO.fianzaAnual = fianzaAnual;
									objGuiaPlanesCaracteristicasDTO.mensajesTexto = mensajesTexto;
									objGuiaPlanesCaracteristicasDTO.mensajesTextoIndistintos = mensajesTextoIndistintos;
									objGuiaPlanesCaracteristicasDTO.minutos = minutos;
									objGuiaPlanesCaracteristicasDTO.minutosIndistintos = minutosIndistintos;
									objGuiaPlanesCaracteristicasDTO.nombrePlan = nombrePlan;
									objGuiaPlanesCaracteristicasDTO.numerosGratis = numerosGratis;
									objGuiaPlanesCaracteristicasDTO.plazo = plazo;
									objGuiaPlanesCaracteristicasDTO.tipoDatos = tipoDatos;
									objGuiaPlanesCaracteristicasDTO.tipoMensajesTexto = tipoMensajesTexto;
									objGuiaPlanesCaracteristicasDTO.tipoMensajesTextoIndistintos = tipoMensajesTextoIndistintos;
									objGuiaPlanesCaracteristicasDTO.tipoMinutos = tipoMinutos;
									objGuiaPlanesCaracteristicasDTO.tipoMinutosIndistintos = tipoMinutosIndistintos;	
								}//Fin si cvePlazo != null && cveSubPlazo != null       						 
	       					}//Fin si nodeLMHijo.getName() == 'Mercado'

	       					if (nodeLMHijo.getName() == 'servicios'){
	       						//Toma los datos de sus atributos
								for(Dom.XMLNode nodeLMServicios : nodeLMHijo.getChildElements()) {									
									if (nodeLMServicios.getNodeType() == DOM.XMLNodeType.ELEMENT){		
	       								System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes nodeLMServicios.getName(): ' + nodeLMServicios.getName());
		       							if (nodeLMServicios.getName() == 'servicio'){
											String id = '';
											String tipoProducto = '';
											String nombre = '';
											String descripcion = '';
											String precio = '';
											String indicadorEquipo = '';
											String tipoServicio = '';
											String origen = '';
				       						//Toma los datos de sus atributos
											for(Dom.XMLNode nodeLMServicio : nodeLMServicios.getChildElements()) {
												if (nodeLMServicio.getName() == 'id')	       							
													id = nodeLMServicio.getText();
												if (nodeLMServicio.getName() == 'tipoProducto')										
													tipoProducto = nodeLMServicio.getText();
												if (nodeLMServicio.getName() == 'nombre')										
													nombre = nodeLMServicio.getText();
												if (nodeLMServicio.getName() == 'descripcion')										
													descripcion = nodeLMServicio.getText();
												if (nodeLMServicio.getName() == 'precio')										
													precio = nodeLMServicio.getText();
												if (nodeLMServicio.getName() == 'indicadorEquipo')										
													indicadorEquipo = nodeLMServicio.getText();
												if (nodeLMServicio.getName() == 'tipoServicio')										
													tipoServicio = nodeLMServicio.getText();
												if (nodeLMServicio.getName() == 'origen')										
													origen = nodeLMServicio.getText();
				       						}//Fin dfel for para
											if (id != null){
												DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO objGuiaPlanesServiciosDTO = new DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO();
												objGuiaPlanesServiciosDTO.descripcion = descripcion;
												objGuiaPlanesServiciosDTO.id = id;
												objGuiaPlanesServiciosDTO.indicadorEquipo = indicadorEquipo;
												objGuiaPlanesServiciosDTO.nombre = nombre;
												objGuiaPlanesServiciosDTO.origen = origen;
												objGuiaPlanesServiciosDTO.precio = precio;
												objGuiaPlanesServiciosDTO.tipoProducto = tipoProducto;
												objGuiaPlanesServiciosDTO.tipoServicio = tipoServicio;
												//Agregalo a la lista
												lGuiaPlanesServiciosDTO.add(objGuiaPlanesServiciosDTO);
											}//Fin si cvePlazo != null && cveSubPlazo != null		       								
		       							}//Fin si nodeLMServicios.getName() == 'servicio'
									}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT	       							
	       						}//Fin dfel for para
	       					}//Fin si nodeLMHijo.getName() == 'Mercado'

	       					//Ve si se trata de elemento movimiento
	       					if (nodeLMHijo.getName() == 'movimiento')
								objGuiaPlanesOUTDTO.movimiento = Integer.valueOf(nodeLMHijo.getText());
	       					//Ve si se trata de elemento estatus
	       					if (nodeLMHijo.getName() == 'estatus')
								objGuiaPlanesOUTDTO.estatus = Integer.valueOf(nodeLMHijo.getText());
	       					//Ve si se trata de elemento descEstatus								
	       					if (nodeLMHijo.getName() == 'descEstatus')
								objGuiaPlanesOUTDTO.descEstatus = nodeLMHijo.getText();								
						}//Fin si child.getNodeType() == DOM.XMLNodeType.ELEMENT
	        		}//Foin del for para nodeLM.getChildElements()
				}//Fin si sXmlRes.contains('ConsultarGuiaPlanesResult')
	
				//System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes lPlanPlazoM2K: ' + lPlanPlazoM2K);
				objArrayOfGuiaPlanesServiciosDTO.servicio = lGuiaPlanesServiciosDTO;
				//Inicualiza la lista en el objeto de objGuiaPlanesOUTDTO 
				objGuiaPlanesOUTDTO.caracteristicas = objGuiaPlanesCaracteristicasDTO;
				objGuiaPlanesOUTDTO.servicios = objArrayOfGuiaPlanesServiciosDTO; 
				//Inicializa la lista en el objeto de GuiaPlanesResponseDTOResult 
				GuiaPlanesResponseDTOResult.listaPlanes = objGuiaPlanesOUTDTO;
				GuiaPlanesResponseDTOResult.detailResponse = detailResponseResul;

			}//Fin si String.valueOf(res).contains('200')
			 
			//Ve si el campo JsonRes tiene algo
			if (String.valueOf(res).contains('400') || String.valueOf(res).contains('404') || String.valueOf(res).contains('405') || String.valueOf(res).contains('500') ){
				System.debug('ERROR A LA HORA DE LLAMAR EL SERVICIO ConsultarGuiaPlanes objDtRespuesta: ' + sXmlRes);
			}//Fin si sXmlRes != null && sXmlRes.length() == 0

		}catch(Exception ex){
			System.debug('ERROR EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes AL HACER EL LLAMADO AL WS: ' + ex.getMessage() + ' ' + ex.getLineNumber());
		}

		System.debug('EN DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes GuiaPlanesResponseDTOResult: ' + GuiaPlanesResponseDTOResult);		
		return GuiaPlanesResponseDTOResult;
	}*/
	
}