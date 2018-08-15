public with sharing class DCT_CustomerTechnicalToken_ext {

	public Boolean blnIsItValidToStart{set;get;}
	public List<DCTRegion__c> lstRegion {set;get;}
	public List<String> lstErrorMsgs{set;get;}
	public List<String> lstSuccessMsgs{set;get;}
	public String strDedLinkId {set;get;}
	public Map<String,Boolean> mapSectionSwitches{set;get;}
	public String strSectionId{set;get;}

	public Cliente__c telcelComertialDirectory{set;get;}
	public Account accountInstance{set;get;}

	public List<Account> lstAssociatedAccs{set;get;}
	//public Map<String,Account> mapAccsById{set;get;}
	public Boolean blnAreThereRelAccs{set;get;}
		
	public Boolean blnAreThereProvisioningRecords{set;get;}
	public Map<String,List<DCTAuthorizedLines__c>> mapALByKey{set;get;}
	public Map<String,Integer> mapAuthLinesRowsPans{set;get;}
	public Map<String, DCTAuthorizedLines__c> mapALById{set;get;}
	public Map<String, DCTPlan__c> mapAutLinPlan{set;get;}	
	public Boolean blnNewProvisioningItem{set;get;}
	public DCTAuthorizedLines__c newProvisioningInstance{set;get;}
	public String strPlanConcat{set;get;}
	public List<String> lstServicesKeys{set;get;}

	public Boolean blnAreThereDedicatedLinks{set;get;}
	public Map<String,DCTDedicatedLinks__c> mapDedicatedLinksById{set;get;}
	public Boolean blnNewDedicatedLink{set;get;}
	public DCTDedicatedLinks__c dedicatedLinkInstance{set;get;}

	public Boolean blnIsEmptyControlledVPNKeyMap {set; get {return mapControlledVPNKeys.isEmpty();}}
	public Boolean blnIsEmptyOpenVPNKeyMap {set; get {return mapOpenVPNKeys.isEmpty();}}
	public Map<String,String> mapControlledVPNKeys{set;get;}
	public Map<String,String> mapOpenVPNKeys{set;get;}
	public String strSelectedNewControlledVPNKey{set;get;}
	public String strSelectedNewOpenVPNKey{set;get;}

	public Boolean blnIsEmptyCompetitorMap {set;get {return mapCompByName.isEmpty();}}
	public Map<String, CompetidoresPlataformas__c> mapCompById;
	public Map<String, List<CompetidoresPlataformas__c>> mapCompByName{set;get;}
	public CompetidoresPlataformas__c newCompetitorInstance{set;get;}
	public Boolean blnNewCompetitor{set;get;}
	public Boolean blnIsThereATraditionalService{set;get;}
	public ServiciosTradicionales__c traditionalServiceInstance{set;get;}
	public id cliente_id {get;set;}
		
	public Map<String, DCT_CatalogoClavesVPN_rst.DTOProductoField> mapIdClaveVpnAbiertaDesc {get;set;} 
	public Map<String, DCT_CatalogoClavesVPN_rst.DTOProductoField> mapIdClaveVpnControlDesc {get;set;}    

	//public Boolean                                  blnIsOnclick  {get; set;}
	//public Boolean                                  blnIsOnclick2 {get; set;}
	//public SObject                                  recordDC      {get; set;}

	//Para el nuevo aprovisionamiento
	public String slConsecCons {get;set;}
		
	public List<SelectOption> slTipoMercado {get;set;} 
	public String sTipoMercado {get;set;}
	public Map<String, DCT_TelcelPlanesSoap_ws.planMercado> mapTipoMercado {get;set;}
				
	public List<SelectOption> slGrupoPlan {get;set;} 
	public String sGrupoPlan {get;set;}
	public Map<String, DCT_TelcelPlanesSoap_ws.grupoPlanMercado> mapGruposPlanes {get;set;}

	public List<SelectOption> selPlazos {get;set;} 
	public String sPlazos {get;set;}
	public Map<String, DCT_TelcelPlanesSoap_ws.planPlazoMercado> mapPlazos {get;set;}

	public List<SelectOption> selPlanes {get;set;} 
	public String sPlanes {get;set;}
	public Map<String, DCT_TelcelPlanesSoap_ws.planPlazoM2K> mapPlanes {get;set;}

	public List<SelectOption> selGuiaPlanes {get;set;} 
	public String sGuiaPlanes {get;set;}
	public Map<String, DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO> mapGuiaPlanes {get;set;}
		
	public String sError {get;set;}
	public Boolean bErrorIns {get;set;}    
	
	public String sSelectedNewService {get;Set;}
	public List<SelectOption> slSelectedNewService {get;set;}	
	
	public List<wrpServicios> lWrpServicios {get;Set;}
	public Map<String, Boolean> mapIdProcesAproba {get;set;}
	public List<String> lExito {get;set;}
	public List<String> lErrores {get;set;}	
	
	//Fin nuevo aprovisionamiento

	//Productos
	public Boolean blnAreThereProductosRecords {get;set;}
    public List<DirectorioProducosSeleccionados__c> lstProdSelecc    {get; set;}    
	//Productos
	
	public List<DCTAuthorizedLines__c> lstAuthLines {get;set;}
	public List<DCTAuthorizedLines__c> lstAuthLines2{get;set;}
	public Boolean blnIsUpdateOK {get;set;}
	public String selectedPlan {get;set;}
	public List<SelectOption> selectPlan{get;set;}
	
	public void initOrCleanUpMsg(){
		System.debug(loggingLevel.Error, '*** 020258: ');
		lstErrorMsgs = new List<String>();
		lstSuccessMsgs = new List<String>();
		lWrpServicios = new List<wrpServicios>();
	}

	public void initVarsAndCollection(){
		initOrCleanUpMsg();
		blnIsUpdateOK = true;
		accountInstance = new Account();
		mapControlledVPNKeys = new Map<String,String>();
		mapOpenVPNKeys = new Map<String,String>();        
		mapDedicatedLinksById = new Map<String,DCTDedicatedLinks__c>();
		mapALById = new Map<String,DCTAuthorizedLines__c>();
		mapAutLinPlan = new Map<String, DCTPlan__c>();
		mapALByKey = new Map<String,List<DCTAuthorizedLines__c>>();
		mapAuthLinesRowsPans = new Map<String,Integer>();
		lstServicesKeys = new List<String>();
		telcelComertialDirectory = new Cliente__c();
		lstAssociatedAccs = new List<Account>();
		dedicatedLinkInstance = new DCTDedicatedLinks__c();
		mapCompById = new Map<String, CompetidoresPlataformas__c>();
		mapCompByName = new Map<String, List<CompetidoresPlataformas__c>>();
		traditionalServiceInstance = new ServiciosTradicionales__c();
		strSelectedNewControlledVPNKey = '';
		strPlanConcat = '';
		blnNewCompetitor = false;
		blnIsThereATraditionalService = false;
		blnAreThereRelAccs = false;
		blnAreThereProvisioningRecords = false;
		blnNewDedicatedLink = false;
		blnNewProvisioningItem = false;
		blnAreThereDedicatedLinks = false;
		blnIsItValidToStart = false;
		mapSectionSwitches = new Map<String,Boolean>{
			'GeneralData' => true,
			'PlanesVozDatos' => false,
			'CtaNacionalYPadre' => false,
			'Aprovisionamiento' => false,
			'ClavesVPN' => false,
			'EnlacesDedicados' => false,
			'Inplant' => false,
			'Competitors' => false,
			'Productos' => false						
		};
		
		mapIdClaveVpnAbiertaDesc = new Map<String, DCT_CatalogoClavesVPN_rst.DTOProductoField>();
		mapIdClaveVpnControlDesc = new Map<String, DCT_CatalogoClavesVPN_rst.DTOProductoField>();		

		//Inicializa las variables para el nuevo plan
		slTipoMercado = new List<SelectOption>();
		mapTipoMercado = new Map<String, DCT_TelcelPlanesSoap_ws.planMercado>();
		//slTipoMercado.add(new SelectOption('' , '--Ninguno--'));

		slGrupoPlan = new List<SelectOption>();
		mapGruposPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.grupoPlanMercado>();
		slGrupoPlan.add(new SelectOption('' , '--Ninguno--'));
				
		selPlazos = new List<SelectOption>();
		mapPlazos = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoMercado>();
		selPlazos.add(new SelectOption('' , '--Ninguno--'));

		selPlanes = new List<SelectOption>();
		mapPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoM2K>();
		selPlanes.add(new SelectOption('' , '--Ninguno--'));

		selGuiaPlanes = new List<SelectOption>();
		mapGuiaPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO>();
		selGuiaPlanes.add(new SelectOption('' , '--Ninguno--'));        
		
		lWrpServicios = new List<wrpServicios>();
		mapIdProcesAproba = new Map<String, Boolean>();
		lExito = new List<String>();
		lErrores = new List<String>();
				
		blnAreThereProductosRecords = false;
		lstProdSelecc = new List<DirectorioProducosSeleccionados__c>();
    		
	}

	//public PageReference creaConsecutivoWebSer(){
	//		System.debug('EN creaConsecutivoWebSer....');
			
	//		//Crea el consecutivo para el llamado
	//		//slConsecCons = String.valueOf(DCT_Utils_cls.consectivoPlanesYEquipos());

	//		System.debug('ANTES DE SALIR DE creaConsecutivoWebSer: ' + slConsecCons);
	//		//Solo null
	//		return null;
	//}   

	//public void DespliegaCamposNuevoPlan(){
	//		System.debug('EN DCT_Product_ctr.DespliegaCamposNuevoPlan slConsecCons: ' + slConsecCons + ' ' + (slTipoMercado.size() > 0));
	//		blnIsOnclick = true;
	//		bErrorIns = false;
	//		String sTipoMercadoPaso = '';
			
	//		//Ve si tiene algo la lista de slTipoMercado
	//		if (slConsecCons != null){
														
	//		}//Fin si slTipoMercado.isEmpty()

	//		System.debug('EN DCT_Product_ctr.DespliegaCamposNuevoPlan sTipoMercado: ' + sTipoMercado);        
	//		if (sTipoMercadoPaso == 'CORPORATIVO'){
	//			actualizaGrupoPlan();
	//		}
			
	//}

	//public PageReference actualizaGrupoPlan(){
	//		System.debug('ENTRO A actualizaGrupoPlan...');
	//		System.debug('EN DCT_Product_ctr.actualizaGrupoPlan slConsecCons: ' + slConsecCons + ' ' + sTipoMercado);       
	//		bErrorIns = false;
			
	//		//Ve si tiene algo la lista de slTipoMercado
	//		if (slGrupoPlan.size() == 1 && slConsecCons != null && sTipoMercado != null){
										
	//		}//Fin si slGrupoPlan.isEmpty() && slConsecCons != null && sTipoMercado != null
							
	//		//Solo regresa null
	//		return null;
	//}


	public PageReference validaTipoServ(){
		System.debug('EN validaTipoServ: ');
		bErrorIns = false;		
		return null;
	}

	public void ActualizaDatosCatalogoVpnWebService(String sRegion){
		System.debug('EN DCT_CustomerTechnicalToken_ext ActualizaDatosCatalogoVpnWebService sRegion: ' + sRegion);
		Integer iRegionNum = (sRegion != null && sRegion != '') ? Integer.valueOf(sRegion.substring(1)) : 0;
		System.debug('EN DCT_CustomerTechnicalToken_ext ActualizaDatosCatalogoVpnWebService iRegionNum: ' + iRegionNum);
		//Integer  = 9;		
		//Si la region es mayoe a 0 entonces consulta los datos de las VPN
		if(iRegionNum > 0){		
			//Busca las claves de VPN para el cliente que esta entrando desde el llamado del servicio
			String sBodyAbiertas = '["'+ iRegionNum +'","CC"]'; 
			DCT_CatalogoClavesVPN_rst.classRespuestaTelcel objClsResTelAbi = DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN(sBodyAbiertas); 
			System.debug(loggingLevel.Error, '*** objClsResTelAbi: ' + objClsResTelAbi);
			//Ve si no hubo error a la hora de tomar las claves
			if(objClsResTelAbi.ExceptionType == NULL){
				if(objClsResTelAbi.productoVPNListField != NULL){			
					//Recorre la lista de las claves y metelas el mapa de mapIdClaveVpnAbiertaDesc
					for (DCT_CatalogoClavesVPN_rst.listaProductosVPN objProdVpnAbr : objClsResTelAbi.productoVPNListField){
						//Toma el producto asociado a objProdVpnAbr.productoField y metelo al mapa de mapIdClaveVpnAbiertaDesc			
						mapIdClaveVpnAbiertaDesc.put(objProdVpnAbr.productoField.claveProductoField, objProdVpnAbr.productoField);
					}//Fin del for par a productoVPNListField
				}//Fin si objClsResTelAbi.productoVPNListField != NULL
			}//Fin  si objClsResTelAbi.ExceptionType == NULL
			//Marco error de time aout llama al ws de nuevi
			if(objClsResTelAbi.ExceptionType != NULL){ 
				if(objClsResTelAbi.ExceptionType.contains('Read timed out')){
					String sBodyAbiertas2 = '["'+ iRegionNum +'","CC"]'; 
					DCT_CatalogoClavesVPN_rst.classRespuestaTelcel objClsResTelAbi2 = DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN(sBodyAbiertas2); 
					if(objClsResTelAbi2.ExceptionType == NULL){
						if(objClsResTelAbi2.productoVPNListField != NULL){			
							//Recorre la lista de las claves y metelas el mapa de mapIdClaveVpnAbiertaDesc
							for (DCT_CatalogoClavesVPN_rst.listaProductosVPN objProdVpnAbr : objClsResTelAbi2.productoVPNListField){
								//Toma el producto asociado a objProdVpnAbr.productoField y metelo al mapa de mapIdClaveVpnAbiertaDesc			
								mapIdClaveVpnAbiertaDesc.put(objProdVpnAbr.productoField.claveProductoField, objProdVpnAbr.productoField);
							}//Fin del for par a productoVPNListField
						}//Fin si objClsResTelAbi2.productoVPNListField != NULL
					}//Fin  si objClsResTelAbi2.ExceptionType == NULL
				}//Fin si objClsResTelAbi.ExceptionType.contains('Read timed out')
			}//Fin si objClsResTelAbi.ExceptionType != NULL
			System.debug('EN DCT_CustomerTechnicalToken_ext ActualizaDatosCatalogoVpnWebService mapIdClaveVpnAbiertaDesc.KeySet(): ' + mapIdClaveVpnAbiertaDesc.KeySet());

			
			String sBodyControl = '["'+ iRegionNum +'","PP"]'; 
			DCT_CatalogoClavesVPN_rst.classRespuestaTelcel objClsResTelCerr = DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN(sBodyControl);
			//Ve si no hubo error a la hora de tomar las claves
			if(objClsResTelCerr.ExceptionType == NULL){
				if(objClsResTelCerr.productoVPNListField != NULL){			
					//Recorre la lista de las claves y metelas el mapa de mapIdClaveVpnAbiertaDesc
					for (DCT_CatalogoClavesVPN_rst.listaProductosVPN objProdVpnAbr : objClsResTelCerr.productoVPNListField){
						//Toma el producto asociado a objProdVpnAbr.productoField y metelo al mapa de mapIdClaveVpnAbiertaDesc			
						mapIdClaveVpnControlDesc.put(objProdVpnAbr.productoField.claveProductoField, objProdVpnAbr.productoField);
					}//Fin del for para productoVPNListField
				}//Fin si objClsResTelCerr.productoVPNListField != NULL
			}//Fin  si objClsResTelCerr.ExceptionType == NULL
			if(objClsResTelCerr.ExceptionType != NULL){			
				if(objClsResTelCerr.ExceptionType.contains('Read timed out')){
					String sBodyControl2 = '["'+ iRegionNum +'","PP"]'; 
					DCT_CatalogoClavesVPN_rst.classRespuestaTelcel objClsResTelCerr2 = DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN(sBodyControl2); 
					if(objClsResTelCerr2.ExceptionType == NULL){
						if(objClsResTelCerr2.productoVPNListField != NULL){			
							//Recorre la lista de las claves y metelas el mapa de mapIdClaveVpnAbiertaDesc
							for (DCT_CatalogoClavesVPN_rst.listaProductosVPN objProdVpnAbr : objClsResTelCerr2.productoVPNListField){
								//Toma el producto asociado a objProdVpnAbr.productoField y metelo al mapa de mapIdClaveVpnAbiertaDesc			
								mapIdClaveVpnAbiertaDesc.put(objProdVpnAbr.productoField.claveProductoField, objProdVpnAbr.productoField);
							}//Fin del for par a productoVPNListField
						}//Fin si objClsResTelCerr2.productoVPNListField != NULL
					}//Fin  si objClsResTelCerr2.ExceptionType == NULL
				}//Fin si objClsResTelCerr.ExceptionType.contains('Read timed out')
			}//Fin si objClsResTelCerr.ExceptionType != NULL			
			System.debug('EN DCT_CustomerTechnicalToken_ext ActualizaDatosCatalogoVpnWebService mapIdClaveVpnControlDesc: ' + mapIdClaveVpnControlDesc.KeySet());
			
		}//Fin si iRegionNum > 0
		
	}
	
	public DCT_CustomerTechnicalToken_ext(ApexPages.StandardController stdCtrl){
			System.debug('EN DCT_CustomerTechnicalToken_ext...');
			selectPlan = new List<SelectOption>();
				initVarsAndCollection();
				lstAuthLines= new List<DCTAuthorizedLines__c>();
				lstAuthLines2 = new List<DCTAuthorizedLines__c>();
				cliente_id = stdCtrl.getId();
				
				String strStatus = 'Rechazado';
				String strRecordType = Schema.SObjectType.DCTAuthorizedLines__c.getRecordTypeInfosByName().get('Plan').getRecordTypeId();
				
				System.debug('EN DCT_CustomerTechnicalToken_ext cliente_id: ' + cliente_id);				
				if(stdCtrl.getId() != null){
						String strQueryOverAuthLines = (!Test.isRunningTest())?'SELECT '+String.join(new List<String>(SObjectType.DCTAuthorizedLines__c.Fields.getMap().keySet()),', ')+', CreatedBy.Manager.Name FROM DCTAuthorizedLines__c WHERE Status__c != \''+strStatus+'\' AND CommercialDirectory__c = \''+stdCtrl.getId()+'\' AND RecordTypeId = \''+strRecordType+'\'ORDER BY Clave__c, Name':'SELECT '+String.join(new List<String>(SObjectType.DCTAuthorizedLines__c.Fields.getMap().keySet()),', ')+', CreatedBy.Manager.Name FROM DCTAuthorizedLines__c';   
						System.debug(loggingLevel.Error, '*** strQueryOverAuthLines: ' + strQueryOverAuthLines);
						lstAuthLines = Database.query(strQueryOverAuthLines);
						System.debug(loggingLevel.Error, '*** lstAuthLines: ' + lstAuthLines);
						if(lstAuthLines.size()>0) {
							for(DCTAuthorizedLines__c iterator: lstAuthLines) {
								if(iterator.DCTTerm__c != '12 MESES') {
									lstAuthLines2.add(iterator);
								} else if (iterator.DCTTerm__c == '12 MESES') {
									if(iterator.DCTAuthorizationDate__c != null) {
										lstAuthLines2.add(iterator);
									}
								}
							}
						}

						selectPlan.add(new SelectOption('---NINGUNO---','---NINGUNO---')); 
						if(lstAuthLines2.size()>0) {
							for(DCTAuthorizedLines__c iterator: lstAuthLines2) {
								selectPlan.add(new SelectOption(iterator.id, iterator.Name)); 
							}
						}
						String strQueryOverDC = (!Test.isRunningTest())?'SELECT '+String.join(new List<String>(SObjectType.Cliente__c.Fields.getMap().keySet()),', ')+', (SELECT '+String.join(new List<String>(SObjectType.DCTAuthorizedLines__c.Fields.getMap().keySet()),', ')+' FROM Lineas_Autorizadas__r), (SELECT '+String.join(new List<String>(SObjectType.DCTDedicatedLinks__c.Fields.getMap().keySet()),', ')+' FROM NombreCliente__r ORDER BY CreatedDate), (SELECT '+String.join(new List<String>(SObjectType.CompetidoresPlataformas__c.Fields.getMap().keySet()),', ')+' FROM DirectorioComercialCompetidores__r) FROM Cliente__c WHERE Id = \''+stdCtrl.getId()+'\' limit 1':'SELECT '+String.join(new List<String>(SObjectType.Cliente__c.Fields.getMap().keySet()),', ')+', (SELECT '+String.join(new List<String>(SObjectType.DCTAuthorizedLines__c.Fields.getMap().keySet()),', ')+' FROM Lineas_Autorizadas__r), (SELECT '+String.join(new List<String>(SObjectType.DCTDedicatedLinks__c.Fields.getMap().keySet()),', ')+' FROM NombreCliente__r ORDER BY CreatedDate), (SELECT '+String.join(new List<String>(SObjectType.CompetidoresPlataformas__c.Fields.getMap().keySet()),', ')+' FROM DirectorioComercialCompetidores__r) FROM Cliente__c limit 1';   
						System.debug(loggingLevel.Error, '*** strQueryOverDC: ' + strQueryOverDC);
						//Recorre las lineas autorizadas y metelas en el mapa de mapIdProcesAproba
						for (DCTAuthorizedLines__c objLinAut : lstAuthLines){
							mapIdProcesAproba.put(objLinAut.id, false);
						}
						Set<String> setIdLinAut = new Set<String>();
						//Ve si tienen un proceso de aprobación pendiente
						for (Approval ProscApruba : [Select a.Status, a.ParentId, a.ApproveComment From Approval a
								where a.Status = 'Pendiente' And a.ParentId IN :mapIdProcesAproba.KeySet()]){
							setIdLinAut.add(ProscApruba.ParentId);
						}
						//Recorre la lista de reg del mapa mapIdProcesAproba
						for(String sIdLinea : setIdLinAut){
							mapIdProcesAproba.put(sIdLinea, true);
						}
						//Sigue las consultas						
						try{telcelComertialDirectory = Database.query(strQueryOverDC);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
						System.debug(loggingLevel.Error, '*** telcelComertialDirectory: ' + telcelComertialDirectory);
						if(telcelComertialDirectory.Id != null){
							if(telcelComertialDirectory.Cliente__c != null){
									String strQueryOverAccSttmnt = 'SELECT '+String.join(new List<String>(SObjectType.Account.Fields.getMap().keySet()),', ')+', Parent.Name, Parent.DCTRegion__c FROM Account WHERE Id = \''+telcelComertialDirectory.Cliente__c+'\' limit 1';   
									try{accountInstance = Database.query(strQueryOverAccSttmnt); }catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
							}
							System.debug(loggingLevel.Error, '*** accountInstance: ' + accountInstance);                        
						}//Fin si telcelComertialDirectory.Id != null
						if(accountInstance.Id != null){
								if(telcelComertialDirectory.Id != null){
										blnIsItValidToStart = true;
										System.debug(loggingLevel.Error, '*** telcelComertialDirectory.Lineas_Autorizadas__r: ' + telcelComertialDirectory.Lineas_Autorizadas__r);
										if(telcelComertialDirectory.Lineas_Autorizadas__r != null){
												if(!telcelComertialDirectory.Lineas_Autorizadas__r.isEmpty()){
														for(DCTAuthorizedLines__c iterator : telcelComertialDirectory.Lineas_Autorizadas__r){
															System.debug(loggingLevel.Error, '*** iterator: ' + iterator);
															if(iterator.DCTHideAdditionalServices__c) {
																System.debug(loggingLevel.Error, '*** Luis: ');
																//Consulta los datos de las lineas en el objeto de Plan
																for (DCTPlan__c plan : [Select id, ClaveFuerzaVenta__c, ClavePlan__c, ClaveDetallePlan__c,
																	DescripcionServcicio__c	From DCTPlan__c Where id =:iterator.Plan__c]){
																	mapAutLinPlan.put(iterator.Id, plan);
																	System.debug('EN DCT_CustomerTechnicalToken_ext EN LA CONSULTA DE LOS SERVICIOS iterator.DCTAdditionalServices__c: ' + iterator.DCTAdditionalServices__c);
																	System.debug('EN DCT_CustomerTechnicalToken_ext EN LA CONSULTA DE LOS SERVICIOS plan.ClaveDetallePlan__c: ' + plan.ClaveDetallePlan__c);
																	//Ve si el servicio no esta asociado en DCTAdditionalServices__c
																	if (iterator.DCTAdditionalServices__c != null && plan.ClaveDetallePlan__c != null){
																		if (!iterator.DCTAdditionalServices__c.contains(plan.ClaveDetallePlan__c)){
																			iterator.DCTAdditionalServices__c += plan.ClaveDetallePlan__c + ';';
																			iterator.DCTAdditionalProductService__c += plan.DescripcionServcicio__c + ';';
																		}//Fin si !iterator.DCTAdditionalServices__c.contains(plan.ClaveDetallePlan__c)
																	}//Fin si iterator.DCTAdditionalServices__c != null
																	if (iterator.DCTAdditionalServices__c == null && plan.ClaveDetallePlan__c != null){
																		iterator.DCTAdditionalServices__c = plan.ClaveDetallePlan__c + ';';
																		iterator.DCTAdditionalProductService__c = plan.DescripcionServcicio__c + ';';
																	}//Fin si iterator.DCTAdditionalServices__c != null																	
																}
																//Ve si lo debe de ver en aprovisionamiento
																mapALById.put(iterator.Id,iterator);																
															}//Fin si !iterator.DCTHideAdditionalServices__c
														}
												}
										}
										System.debug(loggingLevel.Error, '*** telcelComertialDirectory.NombreCliente__r: ' + telcelComertialDirectory.NombreCliente__r);
										if(telcelComertialDirectory.NombreCliente__r != null){
												if(!telcelComertialDirectory.NombreCliente__r.isEmpty()){
														for(DCTDedicatedLinks__c iterator:telcelComertialDirectory.NombreCliente__r){
																mapDedicatedLinksById.put(iterator.Id,iterator);
														}
												}
										}
										System.debug(loggingLevel.Error, '*** telcelComertialDirectory.DirectorioComercialCompetidores__r: ' + telcelComertialDirectory.DirectorioComercialCompetidores__r);
										if(telcelComertialDirectory.DirectorioComercialCompetidores__r != null){
												if(!telcelComertialDirectory.DirectorioComercialCompetidores__r.isEmpty()){
														for(CompetidoresPlataformas__c iterator:telcelComertialDirectory.DirectorioComercialCompetidores__r){
																mapCompById.put(iterator.Id,iterator);
														}
												}
										}
										try{traditionalServiceInstance = [SELECT Id FROM ServiciosTradicionales__c WHERE MapaCliente__r.PlanCliente__c =: accountInstance.Id limit 1];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
										if(traditionalServiceInstance.Id != null){
												blnIsThereATraditionalService = true;
										}
										blnAreThereDedicatedLinks = (mapDedicatedLinksById.isEmpty())?false:true;
										processCompetitors();
										processAuthLines();
										getRelatedAccs();
										processVPNKeys();
										consultaProductos();
								}                        
						}//Fin si accountInstance.Id != null
				}
	}

	public PageReference actualizaDatos(){
		System.debug('EN DCT_CustomerTechnicalToken_ext.actualizaDatos...');
		
		lstAuthLines= new List<DCTAuthorizedLines__c>();
		System.debug('EN DCT_CustomerTechnicalToken_ext.actualizaDatos cliente_id: ' + cliente_id);				
		if(cliente_id != null){
			String strQueryOverAuthLines = (!Test.isRunningTest())?'SELECT '+String.join(new List<String>(SObjectType.DCTAuthorizedLines__c.Fields.getMap().keySet()),', ')+', CreatedBy.Manager.Name FROM DCTAuthorizedLines__c WHERE CommercialDirectory__c = \''+cliente_id+'\' ORDER BY Clave__c, Name':'SELECT '+String.join(new List<String>(SObjectType.DCTAuthorizedLines__c.Fields.getMap().keySet()),', ')+', CreatedBy.Manager.Name FROM DCTAuthorizedLines__c ORDER BY Clave__c, Name';
			lstAuthLines = Database.query(strQueryOverAuthLines);
			System.debug(loggingLevel.Error, '*** lstAuthLines: ' + lstAuthLines);
			String strQueryOverDC = 'SELECT '+String.join(new List<String>(SObjectType.Cliente__c.Fields.getMap().keySet()),', ')+', (SELECT '+String.join(new List<String>(SObjectType.DCTAuthorizedLines__c.Fields.getMap().keySet()),', ')+' FROM Lineas_Autorizadas__r), (SELECT '+String.join(new List<String>(SObjectType.DCTDedicatedLinks__c.Fields.getMap().keySet()),', ')+' FROM NombreCliente__r ORDER BY CreatedDate), (SELECT '+String.join(new List<String>(SObjectType.CompetidoresPlataformas__c.Fields.getMap().keySet()),', ')+' FROM DirectorioComercialCompetidores__r) FROM Cliente__c WHERE Id = \''+cliente_id+'\' limit 1';   
			System.debug(loggingLevel.Error, '*** strQueryOverDC: ' + strQueryOverDC);
			//Recorre las lineas autorizadas y metelas en el mapa de mapIdProcesAproba
			for (DCTAuthorizedLines__c objLinAut : lstAuthLines){
				mapIdProcesAproba.put(objLinAut.id, false);
			}
			Set<String> setIdLinAut = new Set<String>();
			//Ve si tienen un proceso de aprobación pendiente
			for (Approval ProscApruba : [Select a.Status, a.ParentId, a.ApproveComment From Approval a
					where a.Status = 'Pendiente' And a.ParentId IN :mapIdProcesAproba.KeySet()]){
				setIdLinAut.add(ProscApruba.ParentId);
			}
			//Recorre la lista de reg del mapa mapIdProcesAproba
			for(String sIdLinea : setIdLinAut){
				mapIdProcesAproba.put(sIdLinea, true);
			}
			//Sigue las consultas						
			try{telcelComertialDirectory = Database.query(strQueryOverDC);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
			if(telcelComertialDirectory.Id != null){
					if(telcelComertialDirectory.Cliente__c != null){
							String strQueryOverAccSttmnt = 'SELECT '+String.join(new List<String>(SObjectType.Account.Fields.getMap().keySet()),', ')+', Parent.Name, Parent.DCTRegion__c FROM Account WHERE Id = \''+telcelComertialDirectory.Cliente__c+'\' limit 1';   
							try{accountInstance = Database.query(strQueryOverAccSttmnt); }catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
					}
				System.debug('EN DCT_CustomerTechnicalToken_ext.actualizaDatos ANTES DE LLAMAR AL WS DE VPN cliente_id: ' + cliente_id);                            
			}//Fin si telcelComertialDirectory.Id != null
			if(accountInstance.Id != null){
				if(telcelComertialDirectory.Id != null){
					blnIsItValidToStart = true;
					if(telcelComertialDirectory.Lineas_Autorizadas__r != null){
						if(!telcelComertialDirectory.Lineas_Autorizadas__r.isEmpty()){
							for(DCTAuthorizedLines__c iterator : telcelComertialDirectory.Lineas_Autorizadas__r){
								if(iterator.DCTHideAdditionalServices__c) {
									System.debug('EN DCT_CustomerTechnicalToken_ext.actualizaDatos EN LA CONSULTA DE LOS SERVICIOS iterator.DCTAdditionalServices__c: ' + iterator.DCTAdditionalServices__c);									
									//Consulta los datos de las lineas en el objeto de Plan
									for (DCTPlan__c plan : [Select id, ClaveFuerzaVenta__c, ClavePlan__c, ClaveDetallePlan__c,
										DescripcionServcicio__c	From DCTPlan__c Where id =:iterator.Plan__c]){
										mapAutLinPlan.put(iterator.Id, plan);
										System.debug('EN DCT_CustomerTechnicalToken_ext.actualizaDatos EN LA CONSULTA DE LOS SERVICIOS iterator.DCTAdditionalServices__c: ' + iterator.DCTAdditionalServices__c);
										System.debug('EN DCT_CustomerTechnicalToken_ext.actualizaDatos EN LA CONSULTA DE LOS SERVICIOS plan.ClaveDetallePlan__c: ' + plan.ClaveDetallePlan__c);
										//Ve si el servicio no esta asociado en DCTAdditionalServices__c
										if (iterator.DCTAdditionalServices__c != null && plan.ClaveDetallePlan__c != null){
											if (!iterator.DCTAdditionalServices__c.contains(plan.ClaveDetallePlan__c)){
												iterator.DCTAdditionalServices__c += plan.ClaveDetallePlan__c + ';';
												iterator.DCTAdditionalProductService__c += plan.DescripcionServcicio__c + ';';
											}//Fin si !iterator.DCTAdditionalServices__c.contains(plan.ClaveDetallePlan__c)
										}//Fin si iterator.DCTAdditionalServices__c != null
										if (iterator.DCTAdditionalServices__c == null && plan.ClaveDetallePlan__c != null){
											iterator.DCTAdditionalServices__c = plan.ClaveDetallePlan__c + ';';
											iterator.DCTAdditionalProductService__c = plan.DescripcionServcicio__c + ';';
										}//Fin si iterator.DCTAdditionalServices__c != null																	
									}
									//Ve si lo debe de ver en aprovisionamiento
									mapALById.put(iterator.Id,iterator);																
								}//Fin si !iterator.DCTHideAdditionalServices__c
							}
						}
					}
					System.debug('EN DCT_CustomerTechnicalToken_ext.actualizaDatos EN LA CONSULTA DE LOS SERVICIOS mapALById: ' + mapALById.KeySet());
					System.debug('EN DCT_CustomerTechnicalToken_ext.actualizaDatos EN LA CONSULTA DE LOS SERVICIOS mapALById: ' + mapALById.Values());
					if(telcelComertialDirectory.NombreCliente__r != null){
						if(!telcelComertialDirectory.NombreCliente__r.isEmpty()){
							for(DCTDedicatedLinks__c iterator:telcelComertialDirectory.NombreCliente__r){
								mapDedicatedLinksById.put(iterator.Id,iterator);
							}
						}
					}
					if(telcelComertialDirectory.DirectorioComercialCompetidores__r != null){
						if(!telcelComertialDirectory.DirectorioComercialCompetidores__r.isEmpty()){
							for(CompetidoresPlataformas__c iterator:telcelComertialDirectory.DirectorioComercialCompetidores__r){
								mapCompById.put(iterator.Id,iterator);
							}
						}
					}
					try{traditionalServiceInstance = [SELECT Id FROM ServiciosTradicionales__c WHERE MapaCliente__r.PlanCliente__c =: accountInstance.Id limit 1];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
					if(traditionalServiceInstance.Id != null){
						blnIsThereATraditionalService = true;
					}
					blnAreThereDedicatedLinks = (mapDedicatedLinksById.isEmpty()) ? false : true;
				}                        
			}//Fin si accountInstance.Id != null
		}
		return null;
	}	

	public PageReference returnToDirectory(){
		PageReference pr = new PageReference('/'+telcelComertialDirectory.Id);
		pr.setRedirect(true);
		return pr;
	}

	public void processCompetitors(){
		mapCompByName = new Map<String, List<CompetidoresPlataformas__c>>();
		for(String iterator:mapCompById.keySet()){
			if(!mapCompByName.containsKey(mapCompById.get(iterator).Name)){
				mapCompByName.put(mapCompById.get(iterator).Name, new List<CompetidoresPlataformas__c>());
			}
			mapCompByName.get(mapCompById.get(iterator).Name).add(mapCompById.get(iterator));
		}
	}

	public void toggleNewCompetitor(){
			System.debug(loggingLevel.Error, '*** 280492: ');
			initOrCleanUpMsg();
			System.debug(loggingLevel.Error, '*** 030299: ');
			blnNewCompetitor = !blnNewCompetitor;
			System.debug(loggingLevel.Error, '*** blnNewCompetitor: ' + blnNewCompetitor);
			if(blnNewCompetitor){
					System.debug(loggingLevel.Error, '*** accountInstance.Id: ' + accountInstance.Id);
					newCompetitorInstance = new CompetidoresPlataformas__c();
					newCompetitorInstance.Directorio_Comercial__c = telcelComertialDirectory.Id;
					newCompetitorInstance.ServiciosTradicionales__c = traditionalServiceInstance.Id; 
					newCompetitorInstance.PCTCompetidores__c = accountInstance.Id;
			}
			System.debug(loggingLevel.Error, '*** 060460: ');
	}

	public void eraseCompetitor(){
			initOrCleanUpMsg();
			String strCompetitorId = ApexPages.currentPage().getParameters().get('competId');
			if(strCompetitorId != null){
					if(!String.isBlank(strCompetitorId)){
							Database.DeleteResult dR = Database.delete(new CompetidoresPlataformas__c(
									Id = strCompetitorId
							),false);
							if(dR.isSuccess()){
									if(mapCompById.containskey(strCompetitorId)){
											lstSuccessMsgs.add('Se eliminó -exitosamente- el competidor seleccionado');
											mapCompById.remove(strCompetitorId);
											processCompetitors();
									}
							}else{
									lstErrorMsgs.add('Hubo un error al intentar eliminar al competidor seleccionado. Detalles : '+dR.getErrors()[0].getMessage());
							}
					}
			}
	}

	public void eraseCompetitorsGroup(){
			initOrCleanUpMsg();
			String strCompetitorGroupId = ApexPages.currentPage().getParameters().get('competGroupId');
			if(strCompetitorGroupId != null){
					if(!String.isBlank(strCompetitorGroupId)){
						System.debug(loggingLevel.Error, '*** mapCompByName: ' + mapCompByName);
						System.debug(loggingLevel.Error, '*** strCompetitorGroupId: ' + strCompetitorGroupId);
							if(mapCompByName.containskey(strCompetitorGroupId) || Test.isRunningTest()){
									Boolean blnWasThereAnException = false;
									String strExceptionMsg = '';
									try{Database.delete(mapCompByName.get(strCompetitorGroupId),true);}catch(DMLException dE){blnWasThereAnException = true; strExceptionMsg+= dE.getMessage();}catch(UnexpectedException uE){blnWasThereAnException = true; strExceptionMsg+= uE.getMessage();}catch(Exception gE){blnWasThereAnException = true; strExceptionMsg+= gE.getMessage();}  
									if(!blnWasThereAnException){
											for(CompetidoresPlataformas__c iterator:mapCompByName.get(strCompetitorGroupId)){
													if(mapCompById.containskey(iterator.Id)){
															mapCompById.remove(iterator.Id);
													}
											}
											lstSuccessMsgs.add('El grupo de competidores ha sido eliminado exitosamente.');
											processCompetitors();
									}else{
											lstErrorMsgs.add('Hubo un error al intentar eliminar al grupo de competidores. Detalles : '+strExceptionMsg);
									}
							}               
					}
			}
	}

	public void saveNewCompetitor(){
			initOrCleanUpMsg();
			if(validateNewCompetitor()){
					String strNameCompetidor = [SELECT Name FROM DCTCompetitors__c WHERE id =: newCompetitorInstance.DCTCompetitors__c LIMIT 1].Name;
					System.debug(loggingLevel.Error, '*** strNameCompetidor: ' + strNameCompetidor);
					newCompetitorInstance.name = strNameCompetidor;
					List<CompetidoresPlataformas__c> strNEwSUM = [SELECT DCTsummary__c FROM CompetidoresPlataformas__c where PCTCompetidores__c  = :accountInstance.Id AND DCTCompetitors__c = :newCompetitorInstance.DCTCompetitors__c ORDER BY createdDate DESC LIMIT 1];
					newCompetitorInstance.LineasCompetidor__c = (strNEwSUM.size()>0)?strNEwSUM[0].DCTsummary__c:0;
					//newCompetitorInstance.DCTDateCreate__c = System.today();
					if(newCompetitorInstance.DCTPortabilityType__c == 'Port In') {
							newCompetitorInstance.DCTsummary__c = newCompetitorInstance.LineasCompetidor__c  + newCompetitorInstance.DCTLines__c;    
					}else if (newCompetitorInstance.DCTPortabilityType__c == 'Port Out') {
							newCompetitorInstance.DCTsummary__c = newCompetitorInstance.LineasCompetidor__c  - newCompetitorInstance.DCTLines__c; 
					}
					System.debug(loggingLevel.Error, '***  newCompetitorInstance.name: ' +  newCompetitorInstance.name);
					if(newCompetitorInstance.name != null || !String.isBlank(newCompetitorInstance.name)) {   
							Database.SaveResult sr = Database.insert(newCompetitorInstance,false);
							if(sr.isSuccess()){
									lstSuccessMsgs.add('El nuevo competidor fue registrado de manera exitosa.');
									mapCompById.put(newCompetitorInstance.Id,newCompetitorInstance);
									processCompetitors();
									toggleNewCompetitor();
							}else{
									lstErrorMsgs.add('Hubo un error al intentar registrar al nuevo competidor. Detalles : '+sr.getErrors()[0].getMessage());
							}
					}
					
					
			}
	}

	public Boolean validateNewCompetitor(){
			Boolean blnIsEverythingOk = true;
			System.debug(loggingLevel.Error, '*** newCompetitorInstance: ' + newCompetitorInstance);
			System.debug(loggingLevel.Error, '*** newCompetitorInstance.DCTCompetitors__c: ' + newCompetitorInstance.DCTCompetitors__c);
			if(newCompetitorInstance.DCTCompetitors__c == null || String.isBlank(newCompetitorInstance.DCTCompetitors__c)){
					blnIsEverythingOk = false;
					lstErrorMsgs.add('Debe indicar el nombre del competidor.');
			}
			//if(newCompetitorInstance.LineasCompetidor__c == null){
			//    blnIsEverythingOk = false;
			//    lstErrorMsgs.add('Debe indicar las líneas con competencia.');
			//}
			if(newCompetitorInstance.DCTPortabilityType__c == null || String.isBlank(newCompetitorInstance.DCTPortabilityType__c)){
					blnIsEverythingOk = false;
					lstErrorMsgs.add('Debe indicar el tipo de portación.');
			}
			if(newCompetitorInstance.DCTLines__c == null){
					blnIsEverythingOk = false;
					lstErrorMsgs.add('Debe indicar el número de líneas.');
			}
			if(newCompetitorInstance.DCTBaselinesCompetence__c == null){
					blnIsEverythingOk = false;
					lstErrorMsgs.add('Debe indicar las base instalada de líneas con la competencia.');
			}
			System.debug(loggingLevel.Error, '*** blnIsEverythingOk: ' + blnIsEverythingOk);
			return blnIsEverythingOk;
	}

	public void processVPNKeys(){
			mapControlledVPNKeys = new Map<String,String>();
			mapOpenVPNKeys = new Map<String,String>();
			System.debug(loggingLevel.Error, '*** telcelComertialDirectory.DCTControlled__c: ' + telcelComertialDirectory.DCTControlled__c);
			System.debug(loggingLevel.Error, '*** telcelComertialDirectory.DCTOpen__c: ' + telcelComertialDirectory.DCTOpen__c);
			if(telcelComertialDirectory.DCTControlled__c != null){
					if(!String.isBlank(telcelComertialDirectory.DCTControlled__c)){
							List<String> lstControlledVPNKeys = new List<String>();
							lstControlledVPNKeys = telcelComertialDirectory.DCTControlled__c.split(';');
							for(String iterator:lstControlledVPNKeys){
									mapControlledVPNKeys.put(iterator,iterator);
							}
					}
			}
			if(telcelComertialDirectory.DCTOpen__c != null){
					if(!String.isBlank(telcelComertialDirectory.DCTOpen__c)){
							List<String> lstOpenVPNKeys = new List<String>();
							lstOpenVPNKeys = telcelComertialDirectory.DCTOpen__c.split(';');
							for(String iterator:lstOpenVPNKeys){
									mapOpenVPNKeys.put(iterator,iterator);
							}
					}
			}
	}

	public void processAuthLines(){
		System.debug('EN processAuthLines...');
		blnAreThereProvisioningRecords = false;
		mapALByKey = new Map<String,List<DCTAuthorizedLines__c>>();
		mapAuthLinesRowsPans = new Map<String,Integer>(); 
		for(String iterator:mapALById.keySet()){
			if(!mapALByKey.containsKey(mapALById.get(iterator).Clave__c)){
				mapALByKey.put(mapALById.get(iterator).Clave__c, new List<DCTAuthorizedLines__c>());
			}
			mapALByKey.get(mapALById.get(iterator).Clave__c).add(mapALById.get(iterator));
		}
		for(String iterator:mapALByKey.keySet()){
			mapAuthLinesRowsPans.put(iterator,mapALByKey.get(iterator).size());
		}
		if(!mapALByKey.isEmpty()){
			blnAreThereProvisioningRecords = true;
		}
		System.debug('EN processAuthLines mapALByKey: ' + mapALByKey);
	}

	public void eraseVPNKey(){
			String strVPNKeyType = ApexPages.currentPage().getParameters().get('VPNkeyType');
			String strVPNKeyName = ApexPages.currentPage().getParameters().get('VPNkeyName');
			if(strVPNKeyType == 'Controlled'){
					if(mapControlledVPNKeys.containsKey(strVPNKeyName)){
							mapControlledVPNKeys.remove(strVPNKeyName);
					}
			}else if(strVPNKeyType == 'Open'){
					if(mapOpenVPNKeys.containsKey(strVPNKeyName)){
							mapOpenVPNKeys.remove(strVPNKeyName);
					}
			}
	}

	public void addNewVPNKey(){
			initOrCleanUpMsg();
			String strKeyType = ApexPages.currentPage().getParameters().get('VPNKeyTypeForAdd');
			if(strKeyType.equalsIgnoreCase('Controlled')){
					if(validateNewVPNKey(1)){
							mapControlledVPNKeys.put(strSelectedNewControlledVPNKey,strSelectedNewControlledVPNKey);
					}
			}else if(strKeyType.equalsIgnoreCase('Open')){
					if(validateNewVPNKey(2)){
							mapOpenVPNKeys.put(strSelectedNewOpenVPNKey,strSelectedNewOpenVPNKey);
					}
			}
	}

	public List<SelectOption> getControlledVPNKeysOptions(){
			List<SelectOption> lstOptions = new List<SelectOption>();
			
			//Ve si tiene algo el mapa de mapIdClaveVpnControlDesc, toma las lleves y metelas a lstOptions
			if (!mapIdClaveVpnControlDesc.isEmpty()){
				for (String sClaveVpn : mapIdClaveVpnControlDesc.KeySet()){
						lstOptions.add(new SelectOption(sClaveVpn, sClaveVpn + ' ' + mapIdClaveVpnControlDesc.get(sClaveVpn).descripcionField));
				}
			}//Fin si !mapIdClaveVpnControlDesc.isEmpty()
						
			return lstOptions;
	}

	public List<SelectOption> getOpenVPNKeysOptions(){
			List<SelectOption> lstOptions = new List<SelectOption>();

			//Ve si tiene algo el mapa de mapIdClaveVpnAbiertaDesc, toma las lleves y metelas a lstOptions
			if (!mapIdClaveVpnAbiertaDesc.isEmpty()){
				for (String sClaveVpn : mapIdClaveVpnAbiertaDesc.KeySet()){
						lstOptions.add(new SelectOption(sClaveVpn, sClaveVpn  + ' ' + mapIdClaveVpnAbiertaDesc.get(sClaveVpn).descripcionField));        		
				}
			}//Fin si !mapIdClaveVpnAbiertaDesc.isEmpty()
			
			return lstOptions;
	}

	public Boolean validateNewVPNKey(Integer intVPNType){
			Boolean blnIsEverythingOk = true;
			System.debug(loggingLevel.Error, '*** strSelectedNewControlledVPNKey: ' + strSelectedNewControlledVPNKey);
			System.debug(loggingLevel.Error, '*** strSelectedNewOpenVPNKey: ' + strSelectedNewOpenVPNKey);
			if(intVPNType == 1){
					if(strSelectedNewControlledVPNKey != null){
							if(!String.isBlank(strSelectedNewControlledVPNKey)){
									if(mapControlledVPNKeys.containsKey(strSelectedNewControlledVPNKey)){
											blnIsEverythingOk = false;
											lstErrorMsgs.add('La clave VPN seleccionada ya existe en el listado de claves VPN controladas o ya ha sido agregada.');
									}
							}
					}
			}
			if(intVPNType == 2){
					if(strSelectedNewOpenVPNKey != null){
							if(!String.isBlank(strSelectedNewOpenVPNKey)){
									if(mapOpenVPNKeys.containsKey(strSelectedNewOpenVPNKey)){
											blnIsEverythingOk = false;
											lstErrorMsgs.add('La clave VPN seleccionada ya existe en el listado de claves VPN abiertas o ya ha sido agregada.');
									}
							}
					}
			}
			return blnIsEverythingOk;
	}

	public void getRelatedAccs(){
		System.debug('EN getRelatedAccs...');
		
			blnAreThereRelAccs = false;
			lstAssociatedAccs = new List<Account>();
			List<string> myArray = new List<string>();
			List<String> lstArgs = new List<String>();
			lstRegion = [
			SELECT 
					FatherAccount__c,
					NationalAccount__c, 
					Region__c 
			FROM DCTRegion__c 
			WHERE
					RFC__c = : accountInstance.RFC__c
					AND Name =: accountInstance.Name
					AND Region__c = : telcelComertialDirectory.DCTRegion__c 
			];
			
			System.debug(loggingLevel.Error, '*** RFC__c = : ' + accountInstance.RFC__c +' AND Name = :' + accountInstance.Name+'AND Region__c = : ' + telcelComertialDirectory.DCTRegion__c );
			System.debug(loggingLevel.Error, '*** lstRegion: ' + lstRegion);
			System.debug('EN getRelatedAccs...');
			
			if(lstRegion.size()>0) {
					blnAreThereRelAccs = true;
			}
	}

	public void consultaProductos(){
		System.debug('EN consultaProductos cliente_id: ' + cliente_id);

		//Ve por los productos asociados al directorio
		for (DirectorioProducosSeleccionados__c objPaso : [SELECT id, Producto__c, Producto__r.Name, 
				Producto__r.Family, Producto__r.Description, Producto__r.DCT_IsSpecialProduct__c,
				Producto__r.DCTKey__c  
				From DirectorioProducosSeleccionados__c p Where Producto__r.isActive = true
				And Prospecto__c =: cliente_id And Producto__c != null 
				ORDER BY Name
			]){
			//Agrega los reg a lstProdSelecc
			lstProdSelecc.add(objPaso);
			blnAreThereProductosRecords = true;
		}
        System.debug('EN consultaProductos lstProdSelecc: ' + lstProdSelecc);
		
	}

	//Muestra u oculta las secciones según sea su clave de sección.
	public void collapseExpandSection(){
		System.debug('EN collapseExpandSection strSectionId: ' + strSectionId);
		if(mapSectionSwitches.containsKey(strSectionId))
			mapSectionSwitches.put(strSectionId,!mapSectionSwitches.get(strSectionId));
		System.debug('EN collapseExpandSection mapSectionSwitches.get(strSectionId): ' + mapSectionSwitches.get(strSectionId));
		
		//Ve si se trata de Aprovisionamiento manda llamas 
		//if (strSectionId == 'Aprovisionamiento')
		//	creaConsecutivoWebSer();
		
		//Manda a actualizar las claves de VPN	
		if (strSectionId == 'ClavesVPN'){
			System.debug('EN collapseExpandSection telcelComertialDirectory.DCTRegion__c: ' + telcelComertialDirectory.DCTRegion__c);				
			//if (telcelComertialDirectory.DCTRegion__c != null && mapIdClaveVpnAbiertaDesc.isEmpty() && mapIdClaveVpnControlDesc.isEmpty())
				ActualizaDatosCatalogoVpnWebService('R09');
		}//Fin si strSectionId == 'ClavesVPN'
	}

	public void erasePrivisioning(){
				Boolean blnWasThereanException = false;
				String strErrorMsg = '';
				initOrCleanUpMsg();
				String strProvisioningId = ApexPages.currentPage().getParameters().get('provId');
				if(strProvisioningId != null){
						if(!String.isBlank(strProvisioningId)){
								//Database.DeleteResult dR = Database.delete(new DCTAuthorizedLines__c(
								//		Id = strProvisioningId
								//),false);
								DCTAuthorizedLines__c authLines = new DCTAuthorizedLines__c();
								String strQueryOverAuthLines = 'SELECT '+String.join(new List<String>(SObjectType.DCTAuthorizedLines__c.Fields.getMap().keySet()),', ')+', CreatedBy.Manager.Name FROM DCTAuthorizedLines__c WHERE id = \''+strProvisioningId+'\' ORDER BY Clave__c, Name LIMIT 1';   
								authLines = Database.query(strQueryOverAuthLines);
								System.debug(loggingLevel.Error, '*** authLines: ' + authLines);
								if(authLines.DCTHideAdditionalServices__c) {
									authLines.DCTHideAdditionalServices__c = false;
									authLines.DCTAdditionalServices__c = '';
								}
								System.debug(loggingLevel.Error, '*** authLines: ' + authLines);
								//Savepoint sp = Database.setSavepoint();
								try {Database.SaveResult sr = Database.update(authLines, true);	} catch(DmlException e) {blnWasThereanException = true; strErrorMsg += e.getMessage();}catch(UnexpectedException uE){blnWasThereanException = true; strErrorMsg += uE.getMessage();}catch(Exception gE){blnWasThereanException = true; strErrorMsg += gE.getMessage();}       
								
								if(!blnWasThereanException){
										lstSuccessMsgs.add('Se eliminó -exitosamente- el servicio asociado al plan');
										System.debug(loggingLevel.Error, '*** lstSuccessMsgs: '+ lstSuccessMsgs);
								}else{
									blnIsUpdateOK = false;
									lstErrorMsgs.add('Hubo un error al intentar eliminar el aprovisionamiento seleccionado.Favor de contactar a su administrador.');
									System.debug(loggingLevel.Error, '*** strErrorMsg: ' + strErrorMsg);
								}
						}
				}
	}

	public void saveUpdateProvisioningItem(){
		System.debug('EN saveUpdateProvisioningItem....');
		Boolean bError = false;
		System.debug(loggingLevel.Error, '*** lstAuthLines: ' + lstAuthLines);
		//Recorre la lista de lstAuthLines y catualiza los reg que tengas que actualiza
		if (!lstAuthLines.isEmpty()){
			List<Database.Saveresult> lDtupr = Database.update(lstAuthLines, false);
			for(Database.Saveresult objDtupr : lDtupr){
				if(!objDtupr.isSuccess()){
					blnIsUpdateOK = false;
					System.debug('EN saveUpdateProvisioningItem ERROR: ' + objDtupr.getErrors()[0].getMessage());
					lErrores.add(objDtupr.getErrors()[0].getMessage());
					bError = true;
				}//Fin si !objDtupr.isSuccess()
			}//Fin del for para lDtupr
			if (!bError){
				lExito.add('Los datos se actualizarón con éxito');
				System.debug('EN saveUpdateProvisioningItem ANTES DE ACTUALIZAR LOS DATOS...');				
				actualizaDatos();
			}
			System.debug('EN saveUpdateProvisioningItem lstAuthLines: ' + lstAuthLines);			
		}//Fin si !lstAuthLines.isEmpty()
	}

	public void changeblnNewProvisingItem(){
		System.debug(loggingLevel.Error, '*** blnNewProvisioningItem: ' + blnNewProvisioningItem);
		blnNewProvisioningItem = !blnNewProvisioningItem;
		System.debug(loggingLevel.Error, '*** blnNewProvisioningItem: ' + blnNewProvisioningItem);
	}

	public void toggleNewProvisioningItem(){
		System.debug('ENTRO A toggleNewProvisioningItem blnNewProvisioningItem: ' + blnNewProvisioningItem);
		System.debug(loggingLevel.Error, '*** selectedPlan: ' + selectedPlan);
		initOrCleanUpMsg();
		String strProvisioningId = ApexPages.currentPage().getParameters().get('provId');
		System.debug('ENTRO A toggleNewProvisioningItem strProvisioningId: ' + strProvisioningId + ' newProvisioningInstance: ' + newProvisioningInstance);
		System.debug(loggingLevel.Error, '*** blnNewProvisioningItem: ' + blnNewProvisioningItem);
		if(blnNewProvisioningItem){
			if(selectedPlan != null){
				newProvisioningInstance = [SELECT id, Plan__r.ClaveFuerzaVenta__c,
					Plan__r.ClavePlan__c, Plan__r.ClaveDetallePlan__c, Plan__r.DescripcionServcicio__c,
					DCTAdditionalServices__c, DCTAdditionalProductService__c
					FROM DCTAuthorizedLines__c WHERE id = :selectedPlan LIMIT 1] ;
				//Consulta los datos de los servicios asociados strProvisioningId
				System.debug('ENTRO A toggleNewProvisioningItem newProvisioningInstance: ' + newProvisioningInstance);				
				
				//Manda llamar el WS de 
				lWrpServicios = new List<wrpServicios>();
				String sConsecutivo = slConsecCons;
				String sFuerzaVenta = newProvisioningInstance.Plan__r.ClaveFuerzaVenta__c;
				String sPlanes = newProvisioningInstance.Plan__r.ClavePlan__c;
				String sServicio = newProvisioningInstance.Plan__r.ClaveDetallePlan__c;
				
				System.debug('ENTRO A toggleNewProvisioningItem ANTES DE LLAMAR sConsecutivo: ' + sConsecutivo + ' sFuerzaVenta: ' + sFuerzaVenta + ' sPlanes: ' + sPlanes);
				
				/*//Llama el servicio de actualizaGuiaPlanes
 				actualizaGuiaPlanes(sConsecutivo, sFuerzaVenta, sPlanes);
				System.debug('ENTRO A toggleNewProvisioningItem selGuiaPlanes: ' + selGuiaPlanes);
				System.debug('ENTRO A toggleNewProvisioningItem mapGuiaPlanes: ' + mapGuiaPlanes);
				slSelectedNewService = selGuiaPlanes;
				
				//Crea los reg del tipo lWrpServicios
				for (String sCveSer : mapGuiaPlanes.KeySet()){
					String sDescrip = mapGuiaPlanes.get(sCveSer).tipoServicio + ' - '  + mapGuiaPlanes.get(sCveSer).descripcion;
					System.debug('ENTRO A toggleNewProvisioningItem sServicio: ' + sServicio + ' el que tiene en el servicio id: ' + mapGuiaPlanes.get(sCveSer).id);
					//Ve si selecciono alguin servicio
					if (sServicio == mapGuiaPlanes.get(sCveSer).id){
						System.debug('ENTRO A toggleNewProvisioningItem DCTAdditionalServices__c: ' + newProvisioningInstance.DCTAdditionalServices__c);						
						System.debug('ENTRO A toggleNewProvisioningItem sServicio: ' + sServicio);
						if (newProvisioningInstance.DCTAdditionalServices__c != null){
							if (!newProvisioningInstance.DCTAdditionalServices__c.contains(sServicio)){
								newProvisioningInstance.DCTAdditionalServices__c += sCveSer + ';';
								newProvisioningInstance.DCTAdditionalProductService__c += sDescrip + ';';
								System.debug('ENTRO A toggleNewProvisioningItem VAL 1: ' + sServicio);
							}//Fin si !newProvisioningInstance.DCTAdditionalServices__c.contains(sServicio)
						}//Fin si newProvisioningInstance.DCTAdditionalServices__c != null
						if (newProvisioningInstance.DCTAdditionalServices__c == null){
							newProvisioningInstance.DCTAdditionalServices__c = sCveSer + ';';
							newProvisioningInstance.DCTAdditionalProductService__c = sDescrip + ';';								
							System.debug('ENTRO A toggleNewProvisioningItem VAL 2: ' + sServicio);
						}//Fin si newProvisioningInstance.DCTAdditionalServices__c == null
					}//Fin si sServicio == mapGuiaPlanes.get(sCveSer).id && !newProvisioningInstance.DCTAdditionalServices__c.contains(sServicio)
					if (sServicio != mapGuiaPlanes.get(sCveSer).id)
						lWrpServicios.add(new wrpServicios(false, sCveSer, sDescrip, null));
				}//Fin del for para las mapGuiaPlanes
				
				//Recorre los servicios que vienen en  DCTAdditionalServices__c
				if (newProvisioningInstance.DCTAdditionalServices__c != null){
					Integer iCnt = 0;
					List<String> lDCTAdditionalServices = newProvisioningInstance.DCTAdditionalServices__c.split(';');
					System.debug('ENTRO A toggleNewProvisioningItem lDCTAdditionalServices: ' + lDCTAdditionalServices);					
					List<String> lDCTAdditionalProductService = newProvisioningInstance.DCTAdditionalProductService__c.split(';');
					System.debug('ENTRO A toggleNewProvisioningItem lDCTAdditionalProductService: ' + lDCTAdditionalProductService);
					for (String sCveSer : lDCTAdditionalServices){
						Boolean bExiste = false;
						//Recorre la lista de lWrpServicios y ve si ya exste
						for (wrpServicios objWrpServicios : lWrpServicios){
							if (objWrpServicios.sIdServicios == sCveSer){
								objWrpServicios.bSelected = true;
								bExiste = true;
								break;
							}
						}
						//Crea el objeto del tipo wrpServicios y metelo a lWrpServicios						
						if (!bExiste)
							lWrpServicios.add(new wrpServicios(true, sCveSer, lDCTAdditionalProductService.get(iCnt), null));
					}
				}//Fin si newProvisioningInstance.DCTAdditionalServices__c
				System.debug('ENTRO A toggleNewProvisioningItem lWrpServicios: ' + lWrpServicios);*/
				
			}
			if(selectedPlan == null) {
				newProvisioningInstance = new DCTAuthorizedLines__c();
				newProvisioningInstance.CommercialDirectory__c = telcelComertialDirectory.Id;
			}
			strPlanConcat = '';
			lstServicesKeys = new List<String>();
		}
		
		if(!blnNewProvisioningItem){
			System.debug('ENTRO A toggleNewProvisioningItem mapALByKey: ' + mapALByKey.KeySet());			
			for (String sIdKey : mapALByKey.KeySet()){
				System.debug('ENTRO A toggleNewProvisioningItem sIdKey: ' + sIdKey);				
				for (DCTAuthorizedLines__c objLinAut : mapALByKey.get(sIdKey)){
					System.debug('ENTRO A toggleNewProvisioningItem objLinAut: ' + objLinAut.id + ' ' + newProvisioningInstance.id);					
					//Ve si se trara del mismo
					if (objLinAut.id == newProvisioningInstance.id){
						objLinAut.DCTAdditionalServices__c = newProvisioningInstance.DCTAdditionalServices__c;
						objLinAut.DCTAdditionalProductService__c = newProvisioningInstance.DCTAdditionalProductService__c;
					}//Fin si objLinAut.id == newProvisioningInstance.id
				}//Fin si mapALByKey.get(sIdKey)
			}//Fin si mapALByKey.KeySet()
		}//Fin si !blnNewProvisioningItem
		
	}

	public class wrpServicios {
		public Boolean bSelected {get;set;}
		public String sIdServicios {get;set;}		
		public String sDescripcion {get;set;}
		public DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO guiaPlanesServiciosDTO {get;set;}
		
		//Un constructor por default
		public 	wrpServicios(){
			this.bSelected = false;
			this.sIdServicios = null;
			this.sDescripcion = null;
			this.guiaPlanesServiciosDTO = new DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO();
		}
		
		//Un constructor con parametros
		public 	wrpServicios(Boolean bSelected, String sIdServicios, String sDescripcion,
			DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO guiaPlanesServiciosDTO){
			this.bSelected = bSelected;
			this.sIdServicios = sIdServicios;
			this.sDescripcion = sDescripcion;
			this.guiaPlanesServiciosDTO = guiaPlanesServiciosDTO;
		}
	}

	public void saveVPNKeys(){
				initOrCleanUpMsg();
				String strPreviosControllerVPNKeysValue = telcelComertialDirectory.DCTControlled__c;
				String strPreviosOpenVPNKeysValue = telcelComertialDirectory.DCTOpen__c;
				telcelComertialDirectory.DCTControlled__c = String.join(mapControlledVPNKeys.values(),';');
				telcelComertialDirectory.DCTOpen__c = String.join(mapOpenVPNKeys.values(),';');
				Database.SaveResult sr = Database.update(telcelComertialDirectory,false);
				if(sr.isSuccess()){
						lstSuccessMsgs.add('Las claves se registraron exitosamente');
						processVPNKeys();
				}else{
					blnIsUpdateOK = false;
						lstErrorMsgs.add('Hubo un error al intentar aplicar los ajustes. Detalles : '+sr.getErrors()[0].getMessage());
						telcelComertialDirectory.DCTControlled__c = strPreviosControllerVPNKeysValue;
						telcelComertialDirectory.DCTOpen__c = strPreviosOpenVPNKeysValue;
				}
	}

	public void saveNewProvisioningItem(){
		System.debug('ENRON A saveNewProvisioningItem...');
		System.debug(loggingLevel.Error, '*** selectedPlan: ' + selectedPlan);
		initOrCleanUpMsg();
		Boolean blnWasThereanException = false;    	
		String strErrorMsg = ''; 
		
		System.debug('ENRON A saveNewProvisioningItem newProvisioningInstance: ' + newProvisioningInstance);		
		//System.debug('ENRON A saveNewProvisioningItem lWrpServicios.isEmpty(): ' + lWrpServicios.isEmpty());		
		//Ve si tiene algo el objeto de newProvisioningInstance
		//if (newProvisioningInstance != null && !lWrpServicios.isEmpty() ){
		//	Boolean bActServ = false;
		//	String sDCTAdditionalServices = '';
		//	String sDCTAdditionalProductService = '';			
		//	//Recorre la lista de los  servicios adicionales y ve si seleeciono algo
		//	System.debug(loggingLevel.Error, '*** lWrpServicios: ' + lWrpServicios);
		//	for (wrpServicios objWrpServicios : lWrpServicios){
		//		System.debug(loggingLevel.Error, '*** objWrpServicios.bSelected: ' + objWrpServicios.bSelected);
		//		if (objWrpServicios.bSelected){
		//			sDCTAdditionalServices += objWrpServicios.sIdServicios +';';
		//			sDCTAdditionalProductService += objWrpServicios.sDescripcion + ';';
		//			bActServ = true;
		//		}//Fin si objWrpServicios.bSelected
		//	}
		//	System.debug(loggingLevel.Error, '*** bActServ: ' + bActServ);
		//	System.debug(loggingLevel.Error, '*** sDCTAdditionalServices: ' + sDCTAdditionalServices);
		//	System.debug(loggingLevel.Error, '*** sDCTAdditionalProductService: ' + sDCTAdditionalProductService);
		//	if (bActServ){
		//		newProvisioningInstance.Id = selectedPlan;
		//		newProvisioningInstance.DCTAdditionalServices__c = sDCTAdditionalServices;
		//		newProvisioningInstance.DCTAdditionalProductService__c = sDCTAdditionalProductService;
		//	}//Fin si bActServ
		//	if (!bActServ){
		//		newProvisioningInstance.DCTAdditionalServices__c = null;
		//		newProvisioningInstance.DCTAdditionalProductService__c = null;				
		//	}//Fin si 	!bActServ	
		//	//Actualiza el reg de newProvisioningInstance
		//	System.debug(loggingLevel.Error, '*** newProvisioningInstance: ' + newProvisioningInstance);
		//	Database.Saveresult objDbsv = Database.update(newProvisioningInstance, false);
		//	if (!objDbsv.isSuccess())
		//		System.debug('ENRON A saveNewProvisioningItem objDbsv:' + objDbsv.getErrors()[0].getMessage());
		//	if (objDbsv.isSuccess()){
		//		System.debug('ENRON A saveNewProvisioningItem objDbsv.getId:' + objDbsv.getId());
		//		System.debug('ENRON A saveNewProvisioningItem newProvisioningInstance:' + newProvisioningInstance);				
		//		toggleNewProvisioningItem();
		//	}//Fin si objDbsv.isSuccess()
		//}//newProvisioningInstance != null && !lWrpServicios.isEmpty()
		if(selectedPlan != null || !String.isBlank(selectedPlan)) {
			DCTAuthorizedLines__c planToAprov = new DCTAuthorizedLines__c(id = selectedPlan);
			planToAprov.DCTHideAdditionalServices__c = true;
			blnWasThereAnException = false;
			String strExceptionMsg = '';
			System.debug(loggingLevel.Error, '*** planToAprov: ' + planToAprov);
			try{Database.SaveResult sr = Database.update(planToAprov, true);}catch(DMLException dE){blnWasThereAnException = true; strExceptionMsg+= dE.getMessage();}catch(UnexpectedException uE){blnWasThereAnException = true; strExceptionMsg+= uE.getMessage();}catch(Exception gE){blnWasThereAnException = true; strExceptionMsg+= gE.getMessage();}

			if(blnWasThereAnException) {
				lstErrorMsgs.add(strExceptionMsg);
			} else {
				lstSuccessMsgs.add('El plan se agregó exitosamente a la lista de servicios asociados.');
			}
		}		
						
	}

	public void toggleNewDedicatedLinksUI(){
				initOrCleanUpMsg();
				strDedLinkId = ApexPages.currentPage().getParameters().get('dedLinkId');
				blnNewDedicatedLink = !blnNewDedicatedLink;
				if(blnNewDedicatedLink){
						if(strDedLinkId != null) {
							dedicatedLinkInstance=[SELECT Name, KeyCode__c, CreatedDate, DCTRegistrerDate__c FROM DCTDedicatedLinks__c WHERE id = :strDedLinkId LIMIT 1] ;
						} else {
							dedicatedLinkInstance = new DCTDedicatedLinks__c();
							dedicatedLinkInstance.ClientName__c = telcelComertialDirectory.Id;
							dedicatedLinkInstance.DCTRegistrerDate__c = System.Today();
						}
				}
				System.debug(loggingLevel.Error, '*** dedicatedLinkInstance: ' + dedicatedLinkInstance);
	}

	public void saveNewPLink(){
			initOrCleanUpMsg();
			if(validateNewPLink()){
					Database.UpsertResult sr = Database.upsert(dedicatedLinkInstance);
					if(sr.isSuccess()){
							lstSuccessMsgs.add('El enlace fue registrado de manera exitosa.');
							mapDedicatedLinksById.put(dedicatedLinkInstance.Id,dedicatedLinkInstance);
							toggleNewDedicatedLinksUI();
					}else{
							lstErrorMsgs.add('Hubo un error al intentar registrar el nuevo enlace. Detalles : '+sr.getErrors()[0].getMessage());
					}
			}
	}

	//public Boolean validateNewPI(){
	//		Boolean blnEverythingIsOk = true;
	//		System.debug(loggingLevel.Error, '*** strPlanConcat: ' + strPlanConcat);
	//		if(strPlanConcat == null || String.isBlank(strPlanConcat)){
	//				blnEverythingIsOk = false;
	//				lstErrorMsgs.add('Debe indicar el plan.');
	//		}else{
	//				List<String> lstSubstrings = new List<String>();
	//				lstSubstrings = strPlanConcat.split('-');
	//				if(lstSubstrings.size() < 2){
	//						blnEverythingIsOk = false;
	//						lstErrorMsgs.add('El formato del campo "plan" debe ser "ClavePlan - NombrePlan".');
	//				}
	//		}
	//		if(lstServicesKeys == null || lstServicesKeys.isEmpty()){
	//				blnEverythingIsOk = false;
	//				lstErrorMsgs.add('Debe indicar la clave del servicio.');
	//		}
	//		return blnEverythingIsOk;
	//}

	public List<SelectOption> getServiceKeyOptions(){
			return new List<SelectOption>{
					new SelectOption('152910','Multiconferencia'),
					new SelectOption('165692','Buzón de Voz'),
					new SelectOption('123675','Contestón'),
					new SelectOption('023687','Rescatel Plus'),
					new SelectOption('022287','Llamada Tripartita')
			};
	}

	public Boolean validateNewPLink(){
			Boolean blnEverythingIsOk = true;
			if(dedicatedLinkInstance.Name == null || String.isBlank(dedicatedLinkInstance.Name)){
					blnEverythingIsOk = false;
					lstErrorMsgs.add('Debe indicar el tipo de enlace.');
			}
			if(dedicatedLinkInstance.KeyCode__c == null || String.isBlank(dedicatedLinkInstance.KeyCode__c)){
					blnEverythingIsOk = false;
					lstErrorMsgs.add('Debe indicar la clave.');
			}
			return blnEverythingIsOk;
	}

	public void eraseDedidateLink(){
			initOrCleanUpMsg();
			String strDedLinkId = ApexPages.currentPage().getParameters().get('dedLinkId');
			if(strDedLinkId != null){
					if(!String.isBlank(strDedLinkId)){
							Database.DeleteResult dR = Database.delete(new DCTDedicatedLinks__c(
									Id = strDedLinkId
							),false);
							if(dR.isSuccess()){
									if(mapDedicatedLinksById.containskey(strDedLinkId)){
											lstSuccessMsgs.add('Se eliminó -exitosamente- el aprovisionamiento seleccionado');
											mapDedicatedLinksById.remove(strDedLinkId);
											blnAreThereDedicatedLinks = (mapDedicatedLinksById.isEmpty())?false:true;
									}
							}else{
									lstErrorMsgs.add('Hubo un error al intentar eliminar el enlace dedicado seleccionado. Detalles : '+dR.getErrors()[0].getMessage());
							}
					}
			}
	}

	public void saveChangesOnGeneralData(){
		initOrCleanUpMsg();
		blnIsUpdateOK = true;
		Database.SaveResult sr = Database.update(telcelComertialDirectory,false);
		if(sr.isSuccess()){
			lstSuccessMsgs.add('Los ajustes han sido guardados con éxito.');
		}else{
			blnIsUpdateOK = false;
			System.debug(loggingLevel.Error, '*** sr.getErrors().get(0).getMessage(): ' + sr.getErrors().get(0).getMessage());
			lstErrorMsgs.add(sr.getErrors().get(0).getMessage());
		}
	}
	
	public PageReference refreshTable(){
			PageReference pr = new PageReference('https://telcel-dev--dc--c.cs18.visual.force.com/apex/DCT_CustomerTechnicalToken_pag?Id='+cliente_id);
			pr.setRedirect(true);
			return pr;
	}

	public void cancel(){
			blnNewCompetitor = false;
			blnNewProvisioningItem = false;
			blnNewDedicatedLink = false;
	}

}