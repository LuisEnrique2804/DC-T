public class DCT_SISACactivaRestAux_ws {

	public static String strCodeNumber  = '';
	public static String strDescription = '';

	/**
	 * @description Método que regresa el resultado de la busqueda al servicio de SISACT
	 * @param method      Tipo de metodo que se va a utilizar en el servicio
	 * @param rfc         RFC con el que se realizara la consulta en SFDC
	 * @param legalName   Razón Social con el que se realizara la consulta en SFDC
	 * @param entityLegal Tipo de persona juridica con el que se realizara la consulta en SFDC
	 * @param nisi        Número de cliente deudor con el que se realizara la consulta en SFDC
	 * @return response   Wrapper que contiene la respuesta a la consulta realizada
	**/

	public static DCT_ResponseSISACactiva_cls sisact(String method, String rfc, String legalName, String entityLegal, String nisi){
		
		
		DCT_ResponseSISACactiva_cls               response         = new DCT_ResponseSISACactiva_cls();
		List<Cliente__c>                          lstClientRequest = new List<Cliente__c>();
		List<DCT_ResponseSISACactiva_cls>         lstResponse      = new List<DCT_ResponseSISACactiva_cls>();
		List<DCT_ResponseSISACactiva_cls.Info1y7> lstInfo17        = new List<DCT_ResponseSISACactiva_cls.Info1y7>();
		List<DCT_ResponseSISACactiva_cls.Info2y8> lstInfo28        = new List<DCT_ResponseSISACactiva_cls.Info2y8>();
		List<DCT_ResponseSISACactiva_cls.Info6y9> lstInfo69        = new List<DCT_ResponseSISACactiva_cls.Info6y9>();
		List<DCT_ResponseSISACactiva_cls.Info3>   lstInfo3         = new List<DCT_ResponseSISACactiva_cls.Info3>();
		List<DCT_ResponseSISACactiva_cls.Info4>   lstInfo4         = new List<DCT_ResponseSISACactiva_cls.Info4>();
		List<DCT_ResponseSISACactiva_cls.Info5>   lstInfo5         = new List<DCT_ResponseSISACactiva_cls.Info5>();
		List<DCT_ResponseSISACactiva_cls.Info10>  lstInfo10        = new List<DCT_ResponseSISACactiva_cls.Info10>();
		List<DCT_ResponseSISACactiva_cls.Info11>  lstInfo11        = new List<DCT_ResponseSISACactiva_cls.Info11>();

		if(entityLegal == '1') {
			entityLegal = 'Física';
		} else if (entityLegal == '2') {
			entityLegal = 'Moral';
		} else if (entityLegal == '3') {
			entityLegal = 'FÍsica con Actividad Empresarial.';
		} else if (entityLegal == '4') {
			entityLegal = 'Gubernamental';
		}
		
		Boolean blnEvrythingIsOK = validateMethod(method,rfc,legalName,entityLegal,nisi);

		System.debug(loggingLevel.Error, '*** entityLegal: ' + entityLegal);
		System.debug(loggingLevel.Error, '*** blnEvrythingIsOK(false): ' + blnEvrythingIsOK);
		
		if(blnEvrythingIsOK) {
			lstClientRequest = generateQuery(method,rfc,legalName,entityLegal,nisi);
			if(!lstClientRequest.isEmpty()) {
				for(Cliente__c clienteIterator: lstClientRequest) {
					response.esExitoso = true;
					if(method == '1' || method == '7') {
						//
						DCT_Investigaciones_ws.ResponseWrapper wsResponse = DCT_Investigaciones_ws.Investigaciones(clienteIterator.Name, clienteIterator.DCTInvestigation__c, clienteIterator.DCTCommentsInvestigation__c);
						System.debug(loggingLevel.Error, '*** wsResponse: ' + wsResponse);
						System.debug(loggingLevel.Error, '*** wsResponse.Estado: ' + wsResponse.Estado);
						//
						DCT_ResponseSISACactiva_cls.Info1y7 info = new DCT_ResponseSISACactiva_cls.Info1y7();
						info.LeyendaInvestigacion = wsResponse.Estado;
						info.RazonSocial = clienteIterator.Name; 
						info.FuerzaVentaAtiendenCliente = clienteIterator.Name != null ? clienteIterator.Name : null;
						info.FuerzaVentaEjecutivo = null;
						info.FuerzaVentaServicioVoz = null;
						info.FuerzaVentaServicioDatos = null;
						info.CicloFacturacion = clienteIterator.DCTBillingCycle__c != null ? clienteIterator.DCTBillingCycle__c : null;
						info.ClaseCredito = clienteIterator.DCTCreditClass__c != null ? clienteIterator.DCTCreditClass__c : null;
						info.TipoCuenta = clienteIterator.DCTAccountType__c != null ? clienteIterator.DCTAccountType__c : null;
						info.TarifasAutorizada = clienteIterator.DCTRates__c != null ? clienteIterator.DCTRates__c : null;
						info.GrupoPlan = clienteIterator.Grupo__r.Name != null ? clienteIterator.Grupo__r.Name : null;     
						info.FuerzaVentaPromocionVentaEmpleado = clienteIterator.DCTPowerSales2__c != null ? clienteIterator.DCTPowerSales2__c : null;
						info.FuerzaVentaRenovacionAdendum = null;
						info.FuerzaVentaCambioSim = null;
						info.AdendumAnticipado = clienteIterator.DCTAnticipatedAdendum__c != null ? clienteIterator.DCTAnticipatedAdendum__c : null;
						info.PlazoDiasAdendum = clienteIterator.DCTPlan__r.DCTTerm__c != null ? clienteIterator.DCTPlan__r.DCTTerm__c : null;
						info.BonificaPenalizacion = clienteIterator.DCTCollectionBonus__c != null ? clienteIterator.DCTCollectionBonus__c : null;
						info.UsuarioXO = clienteIterator.XO__c;
						info.PuedeActivarVPN = clienteIterator.DCTVPNActivation__c ? '1' : '0';
						info.FuerzadeVentaActivarVPN = null;
						lstInfo17.add(info);
						response.resultadoMetodo17 = lstInfo17;
						System.debug(loggingLevel.Error, '*** Lucho: '+response);
					}
					if(method == '2' || method == '8') {
						//
						DCT_Investigaciones_ws.ResponseWrapper wsResponse = DCT_Investigaciones_ws.Investigaciones(clienteIterator.Name, clienteIterator.DCTInvestigation__c, clienteIterator.DCTCommentsInvestigation__c);
						System.debug(loggingLevel.Error, '*** wsResponse: ' + wsResponse);
						System.debug(loggingLevel.Error, '*** wsResponse.Estado: ' + wsResponse.Estado);
						//
						DCT_ResponseSISACactiva_cls.Info2y8 info = new DCT_ResponseSISACactiva_cls.Info2y8();
						info.FuerzaVentaAtiendenCliente = clienteIterator.Name != null ? clienteIterator.Name : null;
						info.LeyendaInvestigacion = wsResponse.Estado;
						info.FuerzaVentaEjecutivo = null;
						info.FuerzaVentaServicioVoz = null;
						info.FuerzaVentaServicioDatos = null;
						info.CicloFacturacion = clienteIterator.DCTBillingCycle__c != null ? clienteIterator.DCTBillingCycle__c : null;
						info.ClaseCredito = clienteIterator.DCTCreditClass__c != null ? clienteIterator.DCTCreditClass__c : null;
						info.TipoCuenta = clienteIterator.DCTAccountType__c != null ? clienteIterator.DCTAccountType__c : null;
						info.TarifasAutorizada = clienteIterator.DCTRates__c != null ? clienteIterator.DCTRates__c : null;
						info.GrupoPlan = clienteIterator.Grupo__r.Name != null ? clienteIterator.Grupo__r.Name : null;     
						info.FuerzaVentaPromocionVentaEmpleado = clienteIterator.DCTPowerSales2__c != null ? clienteIterator.DCTPowerSales2__c : null;
						info.FuerzaVentaRenovacionAdendum =null;
						info.FuerzaVentaCambioSim = null;
						info.Rfc = clienteIterator.RFC__c != null ? clienteIterator.RFC__c : null;
						info.AdendumAnticipado = clienteIterator.DCTAnticipatedAdendum__c != null ? clienteIterator.DCTAnticipatedAdendum__c : null;
						info.PlazoDiasAdendum = clienteIterator.DCTPlan__r.DCTTerm__c != null ? clienteIterator.DCTPlan__r.DCTTerm__c : null;
						info.BonificaPenalizacion = clienteIterator.DCTCollectionBonus__c != null ? clienteIterator.DCTCollectionBonus__c : null;
						info.UsuarioXO = clienteIterator.XO__c;
						info.PuedeActivarVPN = clienteIterator.DCTVPNActivation__c ? '1' : '0';
						info.FuerzadeVentaActivarVPN = null;
						lstInfo28.add(info);
						response.resultadoMetodo28 = lstInfo28;
					}
					if(method == '6' || method == '9') {
						//
						DCT_Investigaciones_ws.ResponseWrapper wsResponse = DCT_Investigaciones_ws.Investigaciones(clienteIterator.Name, clienteIterator.DCTInvestigation__c, clienteIterator.DCTCommentsInvestigation__c);
						System.debug(loggingLevel.Error, '*** wsResponse: ' + wsResponse);
						System.debug(loggingLevel.Error, '*** wsResponse.Estado: ' + wsResponse.Estado);
						//
						DCT_ResponseSISACactiva_cls.Info6y9 info = new DCT_ResponseSISACactiva_cls.Info6y9();
						info.FuerzaVentaAtiendenCliente = clienteIterator.Name != null ? clienteIterator.Name : null;
						info.LeyendaInvestigacion = wsResponse.Estado;						
						info.FuerzaVentaEjecutivo = null;
						info.FuerzaVentaServicioVoz = null;
						info.FuerzaVentaServicioDatos = null;
						info.CicloFacturacion = clienteIterator.DCTBillingCycle__c != null ? clienteIterator.DCTBillingCycle__c : null;
						info.ClaseCredito = clienteIterator.DCTCreditClass__c != null ? clienteIterator.DCTCreditClass__c : null;
						info.TipoCuenta = clienteIterator.DCTAccountType__c != null ? clienteIterator.DCTAccountType__c : null;
						info.TarifasAutorizada = clienteIterator.DCTRates__c != null ? clienteIterator.DCTRates__c : null;
						info.GrupoPlan = clienteIterator.Grupo__r.Name != null ? clienteIterator.Grupo__r.Name : null;     
						info.FuerzaVentaPromocionVentaEmpleado = clienteIterator.DCTPowerSales2__c != null ? clienteIterator.DCTPowerSales2__c : null;
						info.FuerzaVentaRenovacionAdendum =null;
						info.FuerzaVentaCambioSim = null;
						info.AdendumAnticipado = clienteIterator.DCTAnticipatedAdendum__c != null ? clienteIterator.DCTAnticipatedAdendum__c : null;
						info.PlazoDiasAdendum = clienteIterator.DCTPlan__r.DCTTerm__c != null ? clienteIterator.DCTPlan__r.DCTTerm__c : null;
						info.BonificaPenalizacion = clienteIterator.DCTCollectionBonus__c != null ? clienteIterator.DCTCollectionBonus__c : null;
						info.UsuarioXOEjecutivo = clienteIterator.XO__c;
						info.PuedeActivarVPN = clienteIterator.DCTVPNActivation__c ? '1' : '0';
						info.FuerzadeVentaActivarVPN = null;
						lstInfo69.add(info);
						response.resultadoMetodo69 = lstInfo69;
					}    		
					if(method == '3') {
						DCT_ResponseSISACactiva_cls.Info3 info = new DCT_ResponseSISACactiva_cls.Info3();
						info.RazonSocial = clienteIterator.Name; 
						info.DireccionFiscal = clienteIterator.DCTFiscalAddress__c;
						info.DireccionCorrespondencia = clienteIterator.DCTCorrespondenceAddress__c	;
						info.Id = clienteIterator.DTCCustomerID__c;
						lstInfo3.add(info);
						response.resultadoMetodo3 = lstInfo3;
					}
					if(method == '4') {
						DCT_ResponseSISACactiva_cls.Info4 info = new DCT_ResponseSISACactiva_cls.Info4();
						info.RazonSocial = clienteIterator.Name; 
						info.UsuarioXO = clienteIterator.XO__c; 
						lstInfo4.add(info);
						response.resultadoMetodo4 = lstInfo4;
					}
					if(method == '5') {
						DCT_ResponseSISACactiva_cls.Info5 info = new DCT_ResponseSISACactiva_cls.Info5();
						info.RazonSocial = clienteIterator.Name; 
						info.Rfc = clienteIterator.RFC__c != null ? clienteIterator.RFC__c : null;
						lstInfo5.add(info);
						response.resultadoMetodo5 = lstInfo5;
					}
					if(method == '10') {
						DCT_ResponseSISACactiva_cls.Info10 info = new DCT_ResponseSISACactiva_cls.Info10();
						info.FuerzaVentaEjecutivo = null;
						info.UsuarioXO = clienteIterator.XO__c;
						lstInfo10.add(info);
						response.resultadoMetodo10 = lstInfo10;
					}
					if(method == '11') {
						DCT_ResponseSISACactiva_cls.Info11 info = new DCT_ResponseSISACactiva_cls.Info11();
						info.UsuarioXO = clienteIterator.XO__c;
						lstInfo11.add(info);
						response.resultadoMetodo11 = lstInfo11;
					}
				}
				lstResponse.add(response);
			} else {
				response.esExitoso = false;
				response.listaErrores = new List<DCT_ResponseSISACactiva_cls.Error>();
				DCT_ResponseSISACactiva_cls.Error errorInstance = new DCT_ResponseSISACactiva_cls.Error();
				errorInstance.codigo = '0';
				errorInstance.descripcion = 'No se encontro ningun cliente con esos criterios';
				response.listaErrores.add(errorInstance);
				lstResponse.add(response);
			}
		} else {
			response.esExitoso = false;
			response.listaErrores = new List<DCT_ResponseSISACactiva_cls.Error>();
			DCT_ResponseSISACactiva_cls.Error errorInstance = new DCT_ResponseSISACactiva_cls.Error();
			errorInstance.codigo = strCodeNumber;
			errorInstance.descripcion = strDescription;
			response.listaErrores.add(errorInstance);
			lstResponse.add(response);
		}

		return response;
	}

	/**
	 * @description Método que regresa el resultado de la busqueda en SFDC con los parametros enviados, 
	 *              armando la consulta de forma dinamica dependiendo del metodo.
	 * @param method      Tipo de metodo que se va a utilizar en el servicio.
	 * @param rfc         RFC con el que se realizara la consulta en SFDC.
	 * @param legalName   Razón Social con el que se realizara la consulta en SFDC.
	 * @param entityLegal Tipo de persona juridica con el que se realizara la consulta en SFDC.
	 * @param nisi        Número de cliente deudor con el que se realizara la consulta en SFDC.
	 * @return lstClientRequest Lista de tipo cliente con la información obtenida en la consulta.
	 **/

	public static List<Cliente__c> generateQuery(String method, String rfc, String legalName, String entityLegal, String nisi){
		String           strArgs          = '';
		List<String>     lstArgs          = new List<String>();
		List<Cliente__c> lstClientRequest = new List<Cliente__c>();
		
		if(method == '1') {
			lstArgs.add('RFC__c =\''+rfc+'\'');
		} else if (method == '2') {
			lstArgs.add('Name =\''+legalName+'\'');
		} else if (method == '3') {
			lstArgs.add('RFC__c =\''+rfc+'\'');
			lstArgs.add('Name =\''+legalName+'\'');
		} else if (method == '4') {
			lstArgs.add('RFC__c =\''+rfc+'\'');
		} else if (method == '5') {
			lstArgs.add('DCTKeyNISI__c =\''+nisi+'\'');
		} else if (method == '6') {
			lstArgs.add('RFC__c =\''+rfc+'\'');
			lstArgs.add('Name =\''+legalName+'\'');
		} else if (method == '7') {
			lstArgs.add('RFC__c =\''+rfc+'\'');
			lstArgs.add('DCT_LegalPerson__c =\''+entityLegal+'\'');
		} else if (method == '8') {
			lstArgs.add('Name =\''+legalName+'\'');
			lstArgs.add('DCT_LegalPerson__c =\''+entityLegal+'\'');
		} else if (method == '9') {
			lstArgs.add('RFC__c =\''+rfc+'\'');
			lstArgs.add('Name =\''+legalName+'\'');
			lstArgs.add('DCT_LegalPerson__c =\''+entityLegal+'\'');
		} else if (method == '10') {
			lstArgs.add('RFC__c =\''+rfc+'\'');
			lstArgs.add('Name =\''+legalName+'\'');
		} else if (method == '11') {
			lstArgs.add('RFC__c =\''+rfc+'\'');
			lstArgs.add('Name =\''+legalName+'\'');
		}
		
		strArgs += String.join(lstArgs,' AND ');
		String strQuerryCliente = 'SELECT '+String.join(new List<String>(SObjectType.Cliente__c.Fields.getMap().keySet()), ', ')+', Grupo__r.Name, Cliente__r.Estatus__c, DCTPlan__r.Clave__c, DCTPlan__r.DCTLineType__c, DCTPlan__r.DCTServicekey__c, DCTPlan__r.DCTAdditionalServices__c, DCTPlan__r.DCTBrand__c, DCTPlan__r.DCTModel__c, DCTPlan__r.DCTTerm__c FROM Cliente__c WHERE ('+strArgs+')';	    
		System.debug(loggingLevel.Error, '*** strQuerryCliente: ' + strQuerryCliente);
		try{lstClientRequest = Database.query(strQuerryCliente);}catch(QueryException qE){}catch(Exception gE){}
		return lstClientRequest;
	}

	/**
	 * @description Metodo que valida que dependiendo del metodo contenga los datos necesarios 
	 				y en caso de tenerlos, valida que cumplan con la estructura necesaria.
	 * @param method      Tipo de metodo que se va a utilizar en el servicio.
	 * @param rfc         RFC con el que se realizara la consulta en SFDC.
	 * @param legalName   Razón Social con el que se realizara la consulta en SFDC.
	 * @param entityLegal Tipo de persona juridica con el que se realizara la consulta en SFDC.
	 * @param nisi        Número de cliente deudor con el que se realizara la consulta en SFDC.
	 * @return blnEvrythingIsOK Boleano que indica si la informacion enviada esta completa y con la estructura necesaria.
	 **/
	
	public static Boolean validateMethod(String method, String rfc, String legalName, String entityLegal, String nisi){
		Boolean blnEvrythingIsOK = true;
		
		if(method == '1') {
			if(rfc == null) {
				strCodeNumber = method;
				strDescription = 'Favor de validar que se encuentre el RFC y/o tenga la estructura solicitada.';
				blnEvrythingIsOK = false;
			} else if (rfc != null) {
				if(rfc.length()<12 || rfc.length()>13) {
					strCodeNumber = method;
					strDescription = 'Favor de validar que se encuentre el RFC y/o tenga la estructura solicitada.';
					blnEvrythingIsOK = false;
				}
			}	
		} else if (method == '2') {
			if(legalName == null) {
				strCodeNumber = method;
				strDescription = 'Favor de validar que La Razón Social exista.';
				blnEvrythingIsOK = false;
			}
		} else if (method == '3') {
			if(rfc == null) {
				if(legalName == null) {
					strCodeNumber = method;
					strDescription = 'Favor de validar que este el RFC y/o tenga la estructura solicitada y exista la Razón Social.';
					blnEvrythingIsOK = false;
				}
			}	
		} else if (method == '4') {
			if(rfc == null) {
				strCodeNumber = method;
				strDescription = 'Favor de validar que este el RFC y/o tenga la estructura solicitada.';
				blnEvrythingIsOK = false;
			}	
		} else if (method == '5') {
			if(nisi == null) {
				strCodeNumber = method;
				strDescription = 'Favor de colocar una cuenta deudor existente.';
				blnEvrythingIsOK = false;
			}
		} else if (method == '6') {
			if(rfc == null) {
				if(legalName == null) {
					strCodeNumber = method;
					strDescription = 'Favor de validar que este el RFC y la Razón Social.';
					blnEvrythingIsOK = false;
				}
			}	
		} else if (method == '7') {
			if(rfc == null) {
				if(entityLegal == null) {
					strCodeNumber = method;
						strDescription = 'Favor de validar que este el RFC y el tipo de persona juridica';
					blnEvrythingIsOK = false;
				}
			}
		} else if (method == '8') {
			if(legalName == null) {
				if(entityLegal == null) {
					strCodeNumber = method;
					strDescription = 'Favor de validar que este el RFC y/o tenga la estructura solicitada.';
					blnEvrythingIsOK = false;
				}
			}
		} else if (method == '9') {
			if(rfc == null) {
				if(legalName == null) {
					if(entityLegal == null) {
						strCodeNumber = method;
						strDescription = 'Favor de validar que este el RFC, Razon social y tipo de persona juridica.';
						blnEvrythingIsOK = false;
					}
				}
			}
		}else if (method == '10') {
			if(rfc == null) {
				if(legalName == null) {
					strCodeNumber = method;
					strDescription = 'Favor de validar que este el RFC y Razon social.';
					blnEvrythingIsOK = false;
				}
			}
		}else if (method == '11') {
			if(rfc == null) {
				if(legalName == null) {
					strCodeNumber = method;
					strDescription = 'Favor de validar que este el RFC y Razon social.';
					blnEvrythingIsOK = false;
				}
			}
		}else {
			strCodeNumber = '0';
			strDescription = 'Favor de validar que sea el methodo correcto';
			blnEvrythingIsOK = false;
		}
		return blnEvrythingIsOK;
	}
}