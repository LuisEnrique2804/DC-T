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

	public static DCT_ResponseSISACactiva_cls sisact(String method, String rfc, String legalName, String entityLegal, String nisi, String identifier){
		
		String strGroup             = '';
		String strTarifas           = '';
		String strClavePlan         = '';
		String strNombrePlan        = '';
		String strPlazo             = '';
		String strGerente           = '';
		String strFechaAutorizacion = '';

		List<String> lstGroup             = new List<String>();
		List<String> lstTarifas           = new List<String>();
		List<String> lstClavePlan         = new List<String>();
		List<String> lstNombrePlan        = new List<String>();
		List<String> lstPlazo             = new List<String>();
		List<String> lstGerente           = new List<String>();
		List<String> lstFechaAutorizacion = new List<String>();

		String strLineasActivas            = '';
		String strLineasSolicitadas        = '';
		String strEstatusLineasSolicitadas = '';
		String strFechaSolicitud           = '';
		String strAutorizadoPor            = '';
		String strLineasAutorizadas        = '';
		
		List<String> lstLineasActivas            = new List<String>();
		List<String> lstLineasSolicitadas        = new List<String>();
		List<String> lstEstatusLineasSolicitadas = new List<String>();
		List<String> lstFechaSolicitud           = new List<String>();
		List<String> lstAutorizadoPor            = new List<String>();
		List<String> lstLineasAutorizadas        = new List<String>();

		String strNombreContacto            = '';
		String strPuestoContacto            = '';
		String strTipoContacto              = '';
		String strTelefonoContacto          = '';
		String strNipContacto               = '';
		String strCorreoElectronicoContacto = '';
		String strAutorizaRecibirInfo       = '';
		String strNotas                     = '';
		String strJefeDatos                 = '';
		String strXODatos                   = '';
		 
		List<String> lstNombreContacto            = new List<String>();
		List<String> lstPuestoContacto            = new List<String>();
		List<String> lstTipoContacto              = new List<String>();
		List<String> lstTelefonoContacto          = new List<String>();
		List<String> lstNipContacto               = new List<String>();
		List<String> lstCorreoElectronicoContacto = new List<String>();
		List<String> lstAutorizaRecibirInfo       = new List<String>();
		List<String> lstNotas                     = new List<String>();
		List<String> lstJefeDatos                 = new List<String>();
		List<String> lstXODatos                   = new List<String>();

		DCT_ResponseSISACactiva_cls                   response         = new DCT_ResponseSISACactiva_cls();
		List<Cliente__c>                              lstClientRequest = new List<Cliente__c>();
		List<DCTAuthorizedLines__c>                   lstPlan          = new List<DCTAuthorizedLines__c>();
		List<DCTAuthorizedLines__c>                   lstLinea         = new List<DCTAuthorizedLines__c>();
		List<DCT_ResponseSISACactiva_cls>             lstResponse      = new List<DCT_ResponseSISACactiva_cls>();
		List<DCT_ResponseSISACactiva_cls.Info1y7>     lstInfo17        = new List<DCT_ResponseSISACactiva_cls.Info1y7>();
		List<DCT_ResponseSISACactiva_cls.Info2y8>     lstInfo28        = new List<DCT_ResponseSISACactiva_cls.Info2y8>();
		List<DCT_ResponseSISACactiva_cls.Info6y9>     lstInfo69        = new List<DCT_ResponseSISACactiva_cls.Info6y9>();
		List<DCT_ResponseSISACactiva_cls.Info3>       lstInfo3         = new List<DCT_ResponseSISACactiva_cls.Info3>();
		List<DCT_ResponseSISACactiva_cls.Info4>       lstInfo4         = new List<DCT_ResponseSISACactiva_cls.Info4>();
		List<DCT_ResponseSISACactiva_cls.Info5>       lstInfo5         = new List<DCT_ResponseSISACactiva_cls.Info5>();
		List<DCT_ResponseSISACactiva_cls.Info10>      lstInfo10        = new List<DCT_ResponseSISACactiva_cls.Info10>();
		List<DCT_ResponseSISACactiva_cls.Info11>      lstInfo11        = new List<DCT_ResponseSISACactiva_cls.Info11>();
		List<DCT_ResponseSISACactiva_cls.Info12>      lstInfo12        = new List<DCT_ResponseSISACactiva_cls.Info12>();
		List<DCT_ResponseSISACactiva_cls.Info1314y15> lstInfo131415    = new List<DCT_ResponseSISACactiva_cls.Info1314y15>();
		
		List<String>        lstDCTServices1 = new List<String>();
		List<String>        lstDCTServices2 = new List<String>();
		Map<String, String> mapService1     = new Map<String, String>();

		Integer intLineasActivas = 0;
		Decimal intTotalLieasAutorizadas = 0;

		if(entityLegal == '1') {
			entityLegal = 'Física';
		} else if (entityLegal == '2') {
			entityLegal = 'Moral';
		} else if (entityLegal == '3') {
			entityLegal = 'FÍsica con Actividad Empresarial.';
		} else if (entityLegal == '4') {
			entityLegal = 'Gubernamental';
		}
		
		Boolean blnEvrythingIsOK = validateMethod(method,rfc,legalName,entityLegal,nisi, identifier);
		System.debug(loggingLevel.Error, '***************************************************');
		System.debug(loggingLevel.Error, '*** entityLegal: ' + entityLegal);
		System.debug(loggingLevel.Error, '*** blnEvrythingIsOK(false): ' + blnEvrythingIsOK);
		System.debug(loggingLevel.Error, '************************************************** ');
		if(blnEvrythingIsOK) {
			lstClientRequest = generateQuery(method,rfc,legalName,entityLegal,nisi, identifier);
			System.debug(loggingLevel.Error, '*** lstClientRequest: ' + lstClientRequest);
			if(!lstClientRequest.isEmpty()) {
				System.debug(loggingLevel.Error, '*** lstClientRequest: ' + lstClientRequest);
				for(Cliente__c clienteIterator: lstClientRequest) {
					System.debug(loggingLevel.Error, '*** clienteIterator.Lineas_Autorizadas__r: ' + clienteIterator.Lineas_Autorizadas__r);
					System.debug(loggingLevel.Error, '*** clienteIterator.DirectorioComercial_Contactos__r: ' + clienteIterator.DirectorioComercial_Contactos__r);
					if(!clienteIterator.Lineas_Autorizadas__r.isEmpty()) {
						for(DCTAuthorizedLines__c iterator: clienteIterator.Lineas_Autorizadas__r) {
							if(iterator.Status__c != 'Rechazado') {
								if(iterator.RecordType.Name == 'Plan') {
									lstPlan.add(iterator);
								}
							}	
								if(iterator.RecordType.Name == 'Lineas Autorizadas') {
									lstLinea.add(iterator);
								}	
						}
					}
					if(!clienteIterator.DirectorioComercial_Contactos__r.isEmpty()) {
						for(Contact iteratorContact: clienteIterator.DirectorioComercial_Contactos__r) {
							if(iteratorContact.DCT_ContactoDirectorio__c) {
								lstNombreContacto.add(iteratorContact.Name);
								lstPuestoContacto.add(iteratorContact.Posicion__c);
								lstTipoContacto.add(iteratorContact.DCTTypeContact__c);
								lstTelefonoContacto.add(iteratorContact.MobilePhone);
								lstNipContacto.add(iteratorContact.DCTNIP__c);
								lstCorreoElectronicoContacto.add(iteratorContact.Email);
								lstAutorizaRecibirInfo.add(String.valueOf(iteratorContact.DCTReceiveInformation__c));
								lstNotas.add(iteratorContact.Description);
							}else {
								lstJefeDatos.add(iteratorContact.DTC_DataChief__c);
								lstXODatos.add(iteratorContact.DCT_XOData__c);
							}
						}
						if(!lstNombreContacto.isEmpty()) {
							strNombreContacto = String.join(lstNombreContacto, ',');
						}
						if(!lstPuestoContacto.isEmpty()) {
							strPuestoContacto = String.join(lstPuestoContacto, ',');
						}
						if(!lstTipoContacto.isEmpty()) {
							strTipoContacto = String.join(lstTipoContacto, ',');
						}
						if(!lstTelefonoContacto.isEmpty()) {
							strTelefonoContacto = String.join(lstTelefonoContacto, ',');
						}
						if(!lstNipContacto.isEmpty()) {
							strNipContacto = String.join(lstNipContacto, ',');
						}
						if(!lstCorreoElectronicoContacto.isEmpty()) {
							strCorreoElectronicoContacto = String.join(lstCorreoElectronicoContacto, ',');
						}
						if(!lstAutorizaRecibirInfo.isEmpty()) {
							strAutorizaRecibirInfo = String.join(lstAutorizaRecibirInfo, ',');
						}
						if(!lstNotas.isEmpty()) {
							strNotas = String.join(lstNotas, ',');
						}
						if(!lstNotas.isEmpty()) {
							strJefeDatos = String.join(lstJefeDatos, ',');
						}
						if(!lstNotas.isEmpty()) {
							strXODatos = String.join(lstXODatos, ',');
						}
					}
					response.esExitoso = true;
					
					lstDCTServices1 = clienteIterator.DCTServices1__c != null?clienteIterator.DCTServices1__c.split(';'): new List<String>();
					lstDCTServices2 = clienteIterator.DCTServices2__c != null?clienteIterator.DCTServices2__c.split(';') : new List<String>();
					System.debug(loggingLevel.Error, '*** lstPlan: ' + lstPlan);
					System.debug(loggingLevel.Error, '*** lstLinea: ' + lstLinea);
					if(!lstPlan.isEmpty()) {
						for(DCTAuthorizedLines__c planIterator: lstPlan) {
							//System.debug(loggingLevel.Error, '*** planIterator.Plan__r.DescripcionGrupoPlan__c: ' + planIterator.Plan__r.DescripcionGrupoPlan__c);
							if(planIterator.Plan__r.DescripcionGrupoPlan__c != null) {
								lstGroup.add(planIterator.Plan__r.DescripcionGrupoPlan__c);
							}
							if(planIterator.DCT_Tarifa__c != '' || planIterator.DCT_Tarifa__c != null) {
								lstTarifas.add(planIterator.DCT_Tarifa__c);
							}
							
							if(planIterator.Clave__c != null) {
								lstClavePlan.add(planIterator.Clave__c);
							}
							if(planIterator.Plan__r.Name != '' || planIterator.Plan__r.Name != null) {
								lstNombrePlan.add(planIterator.Plan__r.Name);
							}
							if(planIterator.Plan__r.DCTTerm__c != '' || planIterator.Plan__r.DCTTerm__c != null) {
								lstPlazo.add(planIterator.Plan__r.DCTTerm__c );
							}
							if(planIterator.Plan__r.DCTTerm__c == '12' && planIterator.DCTAuthorizationDate__c != null) {
								lstGerente.add(planIterator.CreatedBy.Manager.Name);
							} else {
								lstGerente.add('');
							}
							lstFechaAutorizacion.add(String.valueOf(planIterator.DCTAuthorizationDate__c));

						}
						if(!lstGroup.isEmpty()) {
							strGroup = String.join(lstGroup, ',');
						}
						if(!lstTarifas.isEmpty()) {
							strTarifas = String.join(lstTarifas, ',');
						}
						if(!lstClavePlan.isEmpty()) {
							strClavePlan = String.join(lstClavePlan, ',');
						}
						if(!lstNombrePlan.isEmpty()) {
							strNombrePlan = String.join(lstNombrePlan, ',');
						}
						if(!lstPlazo.isEmpty()) {
							strPlazo = String.join(lstPlazo, ',');
						}
						if(!lstGerente.isEmpty()) {
							strGerente = String.join(lstGerente, ',');
						}
						if(!lstFechaAutorizacion.isEmpty()) {
							strFechaAutorizacion = String.join(lstFechaAutorizacion, ',');
						}
					}
					if(!lstLinea.isEmpty()) {
						for(DCTAuthorizedLines__c lineaIterator: lstLinea) {
							//lineaIterator.DCTActiveLines__c = intLineasActivas;
							if (lineaIterator.Status__c == 'AUTORIZADO'){
								intLineasActivas = (lineaIterator.DCTActiveLines__c != null ? Integer.valueOf(lineaIterator.DCTActiveLines__c) : intLineasActivas) + (lineaIterator.DCTAuthorizedLines__c != null ? Integer.valueOf(lineaIterator.DCTAuthorizedLines__c) : 0);
							}
							else{
								intLineasActivas = (lineaIterator.DCTActiveLines__c != null ? Integer.valueOf(lineaIterator.DCTActiveLines__c) : intLineasActivas);
							}
							System.debug(loggingLevel.Error, '*** intLineasActivas: ' + intLineasActivas);
							lstLineasActivas.add(String.valueOf(intLineasActivas));

							lstLineasSolicitadas.add(String.valueOf(lineaIterator.DCTAuthorizedLines__c));
							lstEstatusLineasSolicitadas.add(lineaIterator.Status__c);
							lstFechaSolicitud.add(String.valueOf(lineaIterator.DCTAuthorizationDate__c));
							lstAutorizadoPor.add(lineaIterator.Aprobador__r.Name);
							lstLineasAutorizadas.add(String.valueOf(lineaIterator.DCTTotalAuthorizedLines__c));
							intTotalLieasAutorizadas += lineaIterator.DCTTotalAuthorizedLines__c;
							System.debug(loggingLevel.Error, '*** intTotalLieasAutorizadas: ' + intTotalLieasAutorizadas);
						}
						if(!lstLineasActivas.isEmpty()) {
							strLineasActivas = String.join(lstLineasActivas, ',');
						}
						if(!lstLineasSolicitadas.isEmpty()) {
							strLineasSolicitadas = String.join(lstLineasSolicitadas, ',');
						}
						if(!lstEstatusLineasSolicitadas.isEmpty()) {
							strEstatusLineasSolicitadas = String.join(lstEstatusLineasSolicitadas, ',');
						}
						if(!lstFechaSolicitud.isEmpty()) {
							strFechaSolicitud = String.join(lstFechaSolicitud, ',');
						}
						if(!lstAutorizadoPor.isEmpty()) {
							strAutorizadoPor = String.join(lstAutorizadoPor, ',');
						}
						if(!lstLineasAutorizadas.isEmpty()) {
							strLineasAutorizadas = String.join(lstLineasAutorizadas, ',');
						}
					}

					if(lstDCTServices1.size()>0) {
						for(String strIterator: lstDCTServices1) {
							if(!mapService1.containsKey(strIterator)) {
								mapService1.put(strIterator, clienteIterator.DCT_CatalogoFuerzaVenta__r.Name);
							}
						}
					}
					if(lstDCTServices2.size()>0) {
						for(String strIterator: lstDCTServices2) {
							if(!mapService1.containsKey(strIterator)) {
								mapService1.put(strIterator, clienteIterator.DCTCatalogoFuerzaVenta2__r.Name);
							}
						}
					}
					System.debug(loggingLevel.Error, '*************************************************' );
					System.debug(loggingLevel.Error, '*** mapService1: ' + mapService1);
					System.debug(loggingLevel.Error, '*** strGroup: ' + strGroup);
					System.debug(loggingLevel.Error, '*** strTarifas: ' + strTarifas);
					System.debug(loggingLevel.Error, '*** strClavePlan: ' + strClavePlan);
					System.debug(loggingLevel.Error, '*** strNombrePlan: ' + strNombrePlan);
					System.debug(loggingLevel.Error, '*** strPlazo: ' + strPlazo);
					System.debug(loggingLevel.Error, '*** strGerente: ' + strGerente);
					System.debug(loggingLevel.Error, '*** strFechaAutorizacion: ' + strFechaAutorizacion);
					System.debug(loggingLevel.Error, '*************************************************' );
					System.debug(loggingLevel.Error, '*** strLineasActivas: ' + strLineasActivas);
					System.debug(loggingLevel.Error, '*** strLineasSolicitadas: ' + strLineasSolicitadas);
					System.debug(loggingLevel.Error, '*** strEstatusLineasSolicitadas: ' + strEstatusLineasSolicitadas);
					System.debug(loggingLevel.Error, '*** strFechaSolicitud: ' + strFechaSolicitud);
					System.debug(loggingLevel.Error, '*** strAutorizadoPor: ' + strAutorizadoPor);
					System.debug(loggingLevel.Error, '*** strLineasAutorizadas: ' + strLineasAutorizadas);
					System.debug(loggingLevel.Error, '*** intTotalLieasAutorizadas: ' + intTotalLieasAutorizadas);
					System.debug(loggingLevel.Error, '*************************************************' );
					System.debug(loggingLevel.Error, '*** strNombreContacto: ' + strNombreContacto);
					System.debug(loggingLevel.Error, '*** strPuestoContacto: ' + strPuestoContacto);
					System.debug(loggingLevel.Error, '*** strTipoContacto: ' + strTipoContacto);
					System.debug(loggingLevel.Error, '*** strTelefonoContacto: ' + strTelefonoContacto);
					System.debug(loggingLevel.Error, '*** strNipContacto: ' + strNipContacto);
					System.debug(loggingLevel.Error, '*** strCorreoElectronicoContacto: ' + strCorreoElectronicoContacto);
					System.debug(loggingLevel.Error, '*** strAutorizaRecibirInfo: ' + strAutorizaRecibirInfo);
					System.debug(loggingLevel.Error, '*** strNotas: ' + strNotas);
					System.debug(loggingLevel.Error, '*** strJefeDatos: ' + strJefeDatos);
					System.debug(loggingLevel.Error, '*** strXODatos: ' + strXODatos);
					
					if(method == '1' || method == '7') {////Ok
						
						DCT_ResponseSISACactiva_cls.Info1y7 info = new DCT_ResponseSISACactiva_cls.Info1y7();
						
						info.RazonSocial = clienteIterator.Name; 
						info.FuerzaVentaAtiendenCliente = clienteIterator.DCT_CatalogoFuerzaVenta__r.Name +','+clienteIterator.DCTCatalogoFuerzaVenta2__r.Name;
						info.FuerzaVentaEjecutivo = clienteIterator.VT__c != null ? clienteIterator.VT__c : null; //DCTVT
						info.FuerzaVentaServicioVoz = mapService1.containsKey('Para Voz - Datos')?mapService1.get('Para Voz - Datos'):null;
						info.FuerzaVentaServicioDatos = mapService1.containsKey('Para Voz - Datos')?mapService1.get('Para Voz - Datos'):null;
						info.CicloFacturacion = clienteIterator.DCTBillingCycle__c != null ? clienteIterator.DCTBillingCycle__c : null;
						//info.Integrador = null;
						info.ClaseCredito = clienteIterator.DCTCreditClass__c != null ? clienteIterator.DCTCreditClass__c : null;
						info.TipoCuenta = clienteIterator.DCTAccountType__c != null ? clienteIterator.DCTAccountType__c : null;
						info.TarifasAutorizada = strTarifas != ''?strTarifas:null;
						info.GrupoPlan = strGroup != ''?strGroup:null;
						info.FuerzaVentaPromocionVentaEmpleado = info.FuerzaVentaPromocionVentaEmpleado = mapService1.containsKey('Promoción Venta Empleado')?mapService1.get('Promoción Venta Empleado'):null;
						info.FuerzaVentaRenovacionAdendum = mapService1.containsKey('Renovación de Adendum')?mapService1.get('Renovación de Adendum'):null;
						//info.FuerzaVentaCambioSim = mapService1.containsKey('Cambio de SIM')?mapService1.get('Cambio de SIM'):null;
						info.FuerzaVentaCambioSim = mapService1.containsKey('Cambio de SIM')?true:false;
						info.Rfc = clienteIterator.RFC__c != null ? clienteIterator.RFC__c : null;
						info.LeyendaInvestigacion = clienteIterator.DCTResearchLegend__c;
						info.AdendumAnticipado = clienteIterator.DCTAnticipatedAdendum__c == 'Si' ? true : false;
						info.PlazoDiasAdendum = clienteIterator.DCTTermDays__c != null ? clienteIterator.DCTTermDays__c : null;
						info.BonificaPenalizacion = clienteIterator.DCTBonusCustomization__c ? true : false;
						info.UsuarioXO = clienteIterator.XO__c;
						info.PuedeActivarVPN = clienteIterator.DCTVPNActivation__c ? true : false;
						info.FuerzadeVentaActivarVPN = mapService1.containsKey('Activación VPN')?mapService1.get('Activación VPN'):null;
						
						
						lstInfo17.add(info);
						response.resultadoMetodo17 = lstInfo17;/////Ok///OK
					}
					if(method == '2' || method == '8') {/// Ok
						
						DCT_ResponseSISACactiva_cls.Info2y8 info = new DCT_ResponseSISACactiva_cls.Info2y8();
						
						info.RazonSocial = clienteIterator.Name; 
						info.FuerzaVentaAtiendenCliente = clienteIterator.DCT_CatalogoFuerzaVenta__r.Name +','+clienteIterator.DCTCatalogoFuerzaVenta2__r.Name;
						info.FuerzaVentaEjecutivo = clienteIterator.VT__c != null ? clienteIterator.VT__c : null; //DCTVT
						info.FuerzaVentaServicioVoz = mapService1.containsKey('Para Voz - Datos')?mapService1.get('Para Voz - Datos'):null;
						info.FuerzaVentaServicioDatos = mapService1.containsKey('Para Voz - Datos')?mapService1.get('Para Voz - Datos'):null;
						//info.Integrador = null;
						info.CicloFacturacion = clienteIterator.DCTBillingCycle__c != null ? clienteIterator.DCTBillingCycle__c : null;
						info.ClaseCredito = clienteIterator.DCTCreditClass__c != null ? clienteIterator.DCTCreditClass__c : null;
						info.TipoCuenta = clienteIterator.DCTAccountType__c != null ? clienteIterator.DCTAccountType__c : null;
						info.TarifasAutorizada = strTarifas != ''?strTarifas:null;
						info.GrupoPlan = strGroup != ''?strGroup:null;
						info.FuerzaVentaPromocionVentaEmpleado = mapService1.containsKey('Promoción Venta Empleado')?mapService1.get('Promoción Venta Empleado'):null;
						info.FuerzaVentaRenovacionAdendum = mapService1.containsKey('Renovación de Adendum')?mapService1.get('Renovación de Adendum'):null;
						//info.FuerzaVentaCambioSim = mapService1.containsKey('Cambio de SIM')?mapService1.get('Cambio de SIM'):null;
						info.FuerzaVentaCambioSim = mapService1.containsKey('Cambio de SIM')?true:false;
						info.Rfc = clienteIterator.RFC__c != null ? clienteIterator.RFC__c : null;
						info.LeyendaInvestigacion = clienteIterator.DCTResearchLegend__c;
						info.AdendumAnticipado = clienteIterator.DCTAnticipatedAdendum__c == 'Si' ? true : false;
						info.PlazoDiasAdendum = clienteIterator.DCTTermDays__c != null ? clienteIterator.DCTTermDays__c : null;
						info.BonificaPenalizacion = clienteIterator.DCTBonusCustomization__c ? true : false;
						info.UsuarioXO = clienteIterator.XO__c;
						info.PuedeActivarVPN = clienteIterator.DCTVPNActivation__c ? true : false;
						info.FuerzadeVentaActivarVPN = mapService1.containsKey('Activación VPN')?mapService1.get('Activación VPN'):null;
						
						lstInfo28.add(info);
						response.resultadoMetodo28 = lstInfo28;////OK
					}
					if(method == '6' || method == '9') {  ////OK

						DCT_ResponseSISACactiva_cls.Info6y9 info = new DCT_ResponseSISACactiva_cls.Info6y9();
						
						info.FuerzaVentaAtiendenCliente = clienteIterator.DCT_CatalogoFuerzaVenta__r.Name +','+clienteIterator.DCTCatalogoFuerzaVenta2__r.Name;
						info.FuerzaVentaEjecutivo = clienteIterator.VT__c != null ? clienteIterator.VT__c : null; //DCTVT
						info.FuerzaVentaServicioVoz = mapService1.containsKey('Para Voz - Datos')?mapService1.get('Para Voz - Datos'):null;
						info.FuerzaVentaServicioDatos = mapService1.containsKey('Para Voz - Datos')?mapService1.get('Para Voz - Datos'):null;
						info.CicloFacturacion = clienteIterator.DCTBillingCycle__c != null ? clienteIterator.DCTBillingCycle__c : null;
						info.ClaseCredito = clienteIterator.DCTCreditClass__c != null ? clienteIterator.DCTCreditClass__c : null;
						info.TipoCuenta = clienteIterator.DCTAccountType__c != null ? clienteIterator.DCTAccountType__c : null;
						info.TarifasAutorizada = strTarifas != ''?strTarifas:null;
						info.GrupoPlan = strGroup != ''?strGroup:null;
						info.FuerzaVentaPromocionVentaEmpleado = info.FuerzaVentaPromocionVentaEmpleado = mapService1.containsKey('Promoción Venta Empleado')?mapService1.get('Promoción Venta Empleado'):null;
						info.FuerzaVentaRenovacionAdendum = mapService1.containsKey('Renovación de Adendum')?mapService1.get('Renovación de Adendum'):null;
						//info.FuerzaVentaCambioSim = mapService1.containsKey('Cambio de SIM')?mapService1.get('Cambio de SIM'):null;
						info.FuerzaVentaCambioSim = mapService1.containsKey('Cambio de SIM')?true:false;
						info.LeyendaInvestigacion = clienteIterator.DCTResearchLegend__c;
						info.AdendumAnticipado = clienteIterator.DCTAnticipatedAdendum__c == 'Si' ? true : false;
						info.PlazoDiasAdendum = clienteIterator.DCTTermDays__c != null ? clienteIterator.DCTTermDays__c : null;
						info.BonificaPenalizacion = clienteIterator.DCTBonusCustomization__c ? true : false;
						info.UsuarioXO = clienteIterator.XO__c;
						info.PuedeActivarVPN = clienteIterator.DCTVPNActivation__c ? true : false;
						info.FuerzadeVentaActivarVPN = mapService1.containsKey('Activación VPN')?mapService1.get('Activación VPN'):null;
						
						
						lstInfo69.add(info);
						response.resultadoMetodo69 = lstInfo69;
					}    		
					if(method == '3') {////OK
						DCT_ResponseSISACactiva_cls.Info3 info = new DCT_ResponseSISACactiva_cls.Info3();
						info.RazonSocial = clienteIterator.Name; 
						info.DireccionFiscal = clienteIterator.DCTFiscalAddress__c;
						info.DireccionCorrespondencia = clienteIterator.DCTCorrespondenceAddress__c	;
						info.Id = clienteIterator.DTCCustomerID__c;// DTCCustomerID__c
						lstInfo3.add(info);
						response.resultadoMetodo3 = lstInfo3;
					}
					if(method == '4') {//Ok pero con un detalle a validar
						DCT_ResponseSISACactiva_cls.Info4 info = new DCT_ResponseSISACactiva_cls.Info4();
						info.RazonSocial = clienteIterator.Name; 
						info.UsuarioXO = clienteIterator.XO__c; 
						lstInfo4.add(info);
						response.resultadoMetodo4 = lstInfo4;
					}
					if(method == '5') { ////OK
						DCT_ResponseSISACactiva_cls.Info5 info = new DCT_ResponseSISACactiva_cls.Info5();
						info.RazonSocial = clienteIterator.Name; 
						info.Rfc = clienteIterator.RFC__c != null ? clienteIterator.RFC__c : null;
						lstInfo5.add(info);
						response.resultadoMetodo5 = lstInfo5;
					}
					if(method == '10') {  //////OK
						DCT_ResponseSISACactiva_cls.Info10 info = new DCT_ResponseSISACactiva_cls.Info10();
						info.FuerzaVentaEjecutivo = clienteIterator.VT__c != null ? clienteIterator.VT__c : null; //DCTVT
						info.UsuarioXO = clienteIterator.XO__c;
						lstInfo10.add(info);
						response.resultadoMetodo10 = lstInfo10;
					}
					if(method == '11') {//////OK
						DCT_ResponseSISACactiva_cls.Info11 info = new DCT_ResponseSISACactiva_cls.Info11();
						info.UsuarioXO = clienteIterator.XO__c;
						lstInfo11.add(info);
						response.resultadoMetodo11 = lstInfo11;
					}
					if(method == '12') {
						DCT_ResponseSISACactiva_cls.Info12 info = new DCT_ResponseSISACactiva_cls.Info12();
						info.RazonSocial = clienteIterator.Name; 
						info.UsuarioXO = clienteIterator.XO__c;
						info.Id = clienteIterator.DTCCustomerID__c;// DTCCustomerID__c
						lstInfo12.add(info);
						response.resultadoMetodo12 = lstInfo12;
					}
					if(method == '13' || method == '14' || method == '15') {
						DCT_ResponseSISACactiva_cls.Info1314y15 info = new DCT_ResponseSISACactiva_cls.Info1314y15();
						info.Id = clienteIterator.DTCCustomerID__c;// DTCCustomerID__c
						info.Rfc = clienteIterator.RFC__c != null ? clienteIterator.RFC__c : null;
						info.RazonSocial = clienteIterator.Name;
						info.Grupo = clienteIterator.Grupo__r.Name;
						info.Segmento = clienteIterator.Segmento__c;
						info.Sector = clienteIterator.Sector__c;
						info.Subsector = clienteIterator.Subsector__c;
						info.ClaveNisi =clienteIterator.DCTKeyNISI__c;
						info.NombreComercial =clienteIterator.DCT_NombreComercial__c;
						info.DireccionFiscal =clienteIterator.DCTFiscalAddress__c;
						info.DireccionCorrespondencia =clienteIterator.DCTCorrespondenceAddress__c;
						info.AdendumAnticipado =clienteIterator.DCTAnticipatedAdendum__c == 'Si' ? true : false;
						info.PlazoDiasAdendum =clienteIterator.DCTTermDays__c != null ? clienteIterator.DCTTermDays__c : null;
						info.BonificaPenalizacion =clienteIterator.DCTBonusCustomization__c ? true : false;
						info.ClienteTelcelDesde =clienteIterator.DCTCustomerFrom__c;
						info.Antiguedad =clienteIterator.DCTAntiquity__c;
						info.FormaPago =clienteIterator.DCTMethodOfPayment__c;
						info.ReferenciaRAP =clienteIterator.DCTRapReference__c;
						info.TipoCliente =clienteIterator.Tipocliente__c;
						info.Estatus =clienteIterator.DCTStatus__c;
						info.PersonaJuridica =clienteIterator.DCT_LegalPerson__c;
						info.RazonSocialModificadaPor =clienteIterator.DCTSocialReasonModified__c;
						info.FechaModificacionRS =clienteIterator.DCTDateRegistrationAdjudication__c;
						info.EstaBuro =clienteIterator.DCTCreditBureau__c; 
						info.EsVIP =clienteIterator.DCTVIP__c; 
						info.TieneAVL =clienteIterator.DCTAVL__c; 
						info.RepersentanteLegal =clienteIterator.DCTLegalRepresentative__c;
						info.Beneficios =clienteIterator.DCTBenefits__c;
						info.FechaRegistro =clienteIterator.DCTRegistrationDate__c;
						info.FechaModificacion =Date.valueOf(clienteIterator.LastModifiedDate);
						info.UltimoUsuarioModificar =clienteIterator.LastModifiedBy.Name;
						info.XOUltimoUsuarioModificar =clienteIterator.LastModifiedBy.DCTXO__c;
						info.FechaBaja =clienteIterator.DCTLowDate__c; 
						info.PuedeActivarVPN =clienteIterator.DCTVPNActivation__c ? true : false;
						info.CicloFacturacion =clienteIterator.DCTBillingCycle__c != null ? clienteIterator.DCTBillingCycle__c : null;
						info.ClaseCredito =clienteIterator.DCTCreditClass__c != null ? clienteIterator.DCTCreditClass__c : null;
						info.TipoCuenta =clienteIterator.DCTAccountType__c != null ? clienteIterator.DCTAccountType__c : null;
						info.ExcentaFianza =clienteIterator.DCTExemptBail__c; 
						info.Comentario =clienteIterator.DCTComments__c;
						
						info.GrupoPlan =strGroup != ''?strGroup:null;
						info.TarifasAutorizada =strTarifas != ''?strTarifas:null;
						info.ClavePlan =strClavePlan != ''?strClavePlan:null;
						info.NombrePlan =strNombrePlan != ''?strNombrePlan:null;
						info.Plazo =strPlazo != ''?strPlazo:null;
						info.Gerente =strGerente != ''?strGerente:null;
						info.FechaAutorizacion =strFechaAutorizacion != ''?strFechaAutorizacion:null;
						info.TratoCompartido =clienteIterator.DCTSharedTreatment__c;

						info.IdentificadorDistribuidor =clienteIterator.DCT_CatalogoFuerzaVenta__r.DCT_PrepagoSiapID__c +','+clienteIterator.DCTCatalogoFuerzaVenta2__r.DCT_PrepagoSiapID__c;
						info.FuerzaVentaAtiendenCliente =clienteIterator.DCT_CatalogoFuerzaVenta__r.Name +','+clienteIterator.DCTCatalogoFuerzaVenta2__r.Name;
						info.NombreDAT =clienteIterator.DCTDistribuidorPrincipal__c + ','+ clienteIterator.DCTDistribuidorSecundario__c;
						info.Servicios =clienteIterator.DCTServices1__c+';'+clienteIterator.DCTServices2__c;
						info.NombreImplant =clienteIterator.DCTInplantName1__c +','+clienteIterator.DCTInplantName2__c;
						info.TelefonoImplant =clienteIterator.DCTInplantPhone1__c +','+clienteIterator.DCTInplantPhone2__c;
						info.ExtensionImplant =clienteIterator.DCTExt1__c +','+clienteIterator.DCTExt2__c;
						info.CelularImplant =clienteIterator.DCTInplantmobile1__c +','+clienteIterator.DCTInplantmobile2__c;
						info.CorreoElectronicoImplant =clienteIterator.DCTInplantEmail1__c +','+clienteIterator.DCTInplantEmail2__c;
						info.DistribuidorImplant =clienteIterator.DCTDistributor1__c +','+clienteIterator.DCTDistributor2__c;
						info.FechaRegistroImplant =String.valueOf(Date.valueOf(clienteIterator.DCTInplantDate1__c))+','+String.valueOf(Date.valueOf(clienteIterator.DCTInplantDate2__c));
						info.LeyendaInvestigacion = clienteIterator.DCTResearchLegend__c;
						info.ResultadoVerificacion =clienteIterator.DCTResultVerification__c;
						info.Investigacion =clienteIterator.DCTInvestigation__c;
						info.Comentarios =clienteIterator.DCTCommentsInvestigation__c;
						info.TotalLineasActivas =clienteIterator.DCTTotalAuthorizedLines__c;
						info.TipoAutorizacion =clienteIterator.DCTTypeAuthorization__c;
						info.FechaAutorizacionLineas =clienteIterator.DCTAuthorizationDateVoBoManagement__c;
						
						info.LineasActivas =strLineasActivas != ''?strLineasActivas:null;
						info.LineasSolicitadas =strLineasSolicitadas != ''?strLineasSolicitadas:null;
						info.EstatusLineasSolicitadas =strEstatusLineasSolicitadas != ''?strEstatusLineasSolicitadas:null;
						info.FechaSolicitud =strFechaSolicitud != ''?strFechaSolicitud:null;
						info.AutorizadoPor =strAutorizadoPor != ''?strAutorizadoPor:null;
						info.LineasAutorizadas =strLineasAutorizadas != ''?strLineasAutorizadas:null;
						info.TotalLineasAutorizadas =intTotalLieasAutorizadas;
						
						info.NombrePropietario =clienteIterator.Owner.Name;
						info.UsuarioXO = clienteIterator.XO__c;
						info.FuerzaVentaEjecutivo = clienteIterator.VT__c != null ? clienteIterator.VT__c : null; //DCTVT
						info.JefeDatos =strJefeDatos != ''?strJefeDatos:null;
						info.FuerzaVentaJefeDatos =strXODatos != ''?strXODatos:null;
						
						info.NombreContacto =strNombreContacto != ''?strNombreContacto:null;
						info.PuestoContacto =strPuestoContacto != ''?strPuestoContacto:null;
						info.TipoContacto =strTipoContacto != ''?strTipoContacto:null;
						info.TelefonoContacto =strTelefonoContacto != ''?strTelefonoContacto:null;
						info.NipContacto =strNipContacto != ''?strNipContacto:null;
						info.CorreoElectronicoContacto =strCorreoElectronicoContacto != ''?strCorreoElectronicoContacto:null;
						info.AutorizaRecibirInfo =strAutorizaRecibirInfo != ''?strAutorizaRecibirInfo:null;
						info.Notas =strNotas != ''?strNotas:null;
						
						lstInfo131415.add(info);
						response.resultadoMetodo131415 = lstInfo131415;
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

	public static List<Cliente__c> generateQuery(String method, String rfc, String legalName, String entityLegal, String nisi, String identifier){
		String           strArgs          = '';
		List<String>     lstArgs          = new List<String>();
		List<Cliente__c> lstClientRequest = new List<Cliente__c>();
		
		if(method == '1') {
			lstArgs.add('RFC__c =\''+rfc+'\'');
		} else if (method == '2') {
			lstArgs.add('Name =\''+legalName+'\'');
		} else if (method == '3') {
			lstArgs.add('RFC__c =\''+rfc+'\'');
			//lstArgs.add('Name =\''+legalName+'\'');
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
		} else if (method == '12') {
			lstArgs.add('RFC__c =\''+rfc+'\'');
		}else if (method == '13') {
			lstArgs.add('DTCCustomerID__c =\''+identifier+'\'');
		}else if (method == '14') {
			lstArgs.add('RFC__c =\''+rfc+'\'');
		}else if (method == '15') {
			lstArgs.add('Name =\''+legalName+'\'');
		}
		
		strArgs += String.join(lstArgs,' AND ');
		String strQuerryCliente = 'SELECT '+String.join(new List<String>(SObjectType.Cliente__c.Fields.getMap().keySet()), ', ')+
			', Grupo__r.Name, Cliente__r.Estatus__c, DCTPlan__r.Clave__c, DCTPlan__r.DCTLineType__c, DCTPlan__r.DCTServicekey__c,'+
			' DCTPlan__r.DCTAdditionalServices__c, DCTPlan__r.DCTBrand__c, DCTPlan__r.DCTModel__c, DCTPlan__r.DCTTerm__c,'+
			' DCT_CatalogoFuerzaVenta__r.Name, DCTCatalogoFuerzaVenta2__r.Name, LastModifiedBy.Name, LastModifiedBy.DCTXO__c, DCT_CatalogoFuerzaVenta__r.DCT_PrepagoSiapID__c,'+
			' DCTCatalogoFuerzaVenta2__r.DCT_PrepagoSiapID__c, Owner.Name, '+
			'(SELECT DCT_ConsecutivoLineasAutorizadas__c, Name,Clave__c,DCT_Tarifa__c,Plan__r.DescripcionGrupoPlan__c,Plan__r.DCTCode__c,Plan__r.Name,Plan__r.DCTTerm__c,'+
				'CreatedBy.Manager.Name,DCTAuthorizationDate__c,DCTActiveLines__c,DCTAuthorizedLines__c,Status__c,Aprobador__r.Name,'+
				'DCTTotalAuthorizedLines__c,RecordType.Name FROM Lineas_Autorizadas__r ORDER BY DCT_ConsecutivoLineasAutorizadas__c),'+
			' (SELECT Name, Posicion__c, DCTTypeContact__c, MobilePhone, DCTNIP__c, Email, DCTReceiveInformation__c, DCT_ContactoDirectorio__c, Description, DTC_DataChief__c, DCT_XOData__c '+
				' From DirectorioComercial_Contactos__r) ';
			if(!Test.isRunningTest()) {	
				strQuerryCliente = strQuerryCliente+'FROM Cliente__c WHERE ('+strArgs+')';	    
			} else {
				strQuerryCliente = strQuerryCliente+'FROM Cliente__c';	   
			}
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
	
	public static Boolean validateMethod(String method, String rfc, String legalName, String entityLegal, String nisi, String identifier){
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
					strDescription = 'Favor de validar que este el RFC y Razón social.';
					blnEvrythingIsOK = false;
				}
			}
		}else if (method == '12') {
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
		}else if (method == '13') {
			if(identifier == null) {
				strCodeNumber = method;
				strDescription = 'Favor de validar que el Identificador exista.';
				blnEvrythingIsOK = false;
			}
		}else if (method == '14') {
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
		}else if (method == '15') {
			if(legalName == null) {
				strCodeNumber = method;
				strDescription = 'Favor de validar que La Razón Social exista.';
				blnEvrythingIsOK = false;
			}
		}else {
			strCodeNumber = '0';
			strDescription = 'Favor de validar que sea el methodo correcto';
			blnEvrythingIsOK = false;
		}
		return blnEvrythingIsOK;
	}
}