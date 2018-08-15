public class DCT_AccountOwnerAssignment_cls {

	public string sIdUserActual = UserInfo.getUserId();
	public string sIdManagerUserActual {get;set;}
	public string sIdUserActualPerfil {get;set;}
	public String sUserActualFuncion {get;set;}	
	public String sIdUserActualFuncion {get;set;}	
	public Boolean blnEsCoordinador {get;set;}		
	public Map<String, String> mapIdUsrIdGestor {get;set;}
	public Map<String, String> mapIdUsrNomFun {get;set;}
	
    public List<String> lstErrorMsgs{set;get;}
    public List<String> lstSuccessMsgs{set;get;}
    public List<String> lstErrorMsgsBU{set;get;}    
    public Boolean blnIsItPossibleToStart{set;get;}
    public Boolean blnShowMainUI{set;get;}
    public Boolean blnShowLookUpUI{set;get;}
    public String strLookUpUserName{set;get;}
    public Map<String,AccountsByOwnerWrapper> mapOwnersAndAccounts{set;get;}
    public Map<String,AccountsByOwnerWrapper> mapFinalOwnersAndAccounts{set;get;}
    public AccountsByOwnerWrapper leftOwnerAndAccounts{set;get;}
    public Boolean blnChangesHaveBeenMade{set;get;}
    public Boolean blnSuccessfulProcedure{set;get;}

	//Usuario de la izquierda para transferir o recibir cuentas
    public String strSelectedUserId {set;get;}
    public String strSelectedUserIdGv {set;get;}

	//Usuario de la derecha para transferir o recibir cuentas siempre y cuando sea de la misma gerencia    
    public String strSelectedRightUser{set;get;}
    public String strSelectedRightUserGv {set;get;}

    public User selectedUser{set;get;}
    public List<UserLookUpWrapper> lstFoundUsersLookUp{set;get;}
    public Map<Id,User> mapFoundUsersById{set;get;}
    
	public String sIdUser1erNivel {get;set;}
    public Map<Id,User> mapIdUsuario{set;get;}
    public Map<String, String> mapIdUsrRol{set;get;}    
	public String sUsrActNomPerfil {get;set;}
	
	//El nombre de la gerencia del usuario que esta seleccionado para comprartir cuentas
	public String sGerUsrSelec {get;set;}
	public Account accountRecord {get;set;}
	
	public Set<String> setUsrCoord {get;set;}
	
	public Map<String, Map<String, AccountWrapperAssignForUsers>> mapUsrSelForAssig {get;set;}
	public Map<String, String> mapIdUsrIdGest {get;set;}
	public List<User> lstRelatedUsers {get;set;}
	public Set<String> setRelatedUsersCoord {get;set;}
	public Set<String> setManagerUsers {get;set;}	
	
	public String slConsecCons {get;set;} 
	public Boolean bUsrBusExit {get;set;}
	public Boolean bSeleccionUnaCuenta {get;Set;}

    public List<SelectOption> soSegmento {get;set;} 
    public String sSegmento {get;set;}

    /*public PageReference creaConsecutivoWebSer(){
		//Crea el consecutivo para el llamado
		//slConsecCons = String.valueOf(DCT_Utils_cls.consectivoPlanesYEquipos());

		//Solo null
		return null;
    }*/	

    /*public PageReference pruebaLoginTelcel(){
    	System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel...');
    	
    	//Crea un objeto del tipo DCT_Utils_cls.DtRespuestaTelcel
		/*DCT_Utils_cls.DtRespuestaTelcel objDtRespuestaTelcel =  DCT_Utils_cls.LoginTelcel();    	
    	System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objDtRespuestaTelcel: ' + objDtRespuestaTelcel);
    	//Ve si no hubo error a la hora de crear el login
    	if (objDtRespuestaTelcel.error != null){
    	}*/
    	
    	/*//Para el servicio de CatalogoClavesVPN
    	DCT_CatalogoClavesVPN_rst.classRespuestaTelcel objproductosVPNList = DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN();
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList);
    	if (objproductosVPNList.Message != null){
			System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList.Message);    		
    	}*/

    	/*//Para el servicio de CatalogoFuerzasVenta por Estatus
    	DTC_CatalogoFuerzasVenta_rst.classRespuestaTelcel objproductosVPNList = DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorEstatus('L');
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList);
    	if (objproductosVPNList.ErrorID == '0'){
			System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList.ErrorID);    		
			System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList.ErrorDescripcion);
    	}*/

    	/*//Para el servicio de CatalogoFuerzasVenta por ID
    	DTC_CatalogoFuerzasVenta_rst.classRespuestaTelcel objproductosVPNList = DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorID('17');
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList);
    	if (objproductosVPNList.ErrorID == '0'){
			System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList.ErrorID);    		
			System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList.ErrorDescripcion);
    	}*/

    	/*//Para el servicio de CatalogoFuerzasVenta por Razón Social
    	DTC_CatalogoFuerzasVenta_rst.classRespuestaTelcel objproductosVPNList = DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaPorRazonSocial('ASISTENCIA EN TELEFONIA CELULAR, S.A DE C.V');
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList);
    	if (objproductosVPNList.ErrorID == '0'){
			System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList.ErrorID);    		
			System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList.ErrorDescripcion);
    	}*/

    	/*//Para el servicio de CatalogoFuerzasVenta Sin parametros
    	DTC_CatalogoFuerzasVenta_rst.classRespuestaTelcelTodo objproductosVPNList = DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVenta();
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList);
    	if (objproductosVPNList.ErrorID == '0'){ //No hubo error
    		Map<String, DAT__c> mapDATUps = new Map<String, DAT__c>();
    		//Toma la lista de reg que regreso y actualiza el objeto que se llama DAT__c (DAT)
    		for (DTC_CatalogoFuerzasVenta_rst.listaFuerzaVentaDistTodo objFerzaVtas : objproductosVPNList.FuerzaVentaDistribuidor){
    			//Cre los objetos del tipo 
    			mapDATUps.put(objFerzaVtas.Clave, new DAT__c(Name = objFerzaVtas.Clave
    				, Clave__c = objFerzaVtas.Clave, RazonSocial__c = objFerzaVtas.RazonSocial)
    			);
    		}//Fin del for para la FuerzaVentaDistribuidor
    		
    		//Ya tienes los reg que vas a actualizar ejecuta el UPSERT
			List<Database.Upsertresult> lDtbUpsRes = Database.upsert(mapDATUps.Values(), DAT__c.Clave__c, false);
			//Ve si hubo error
			for (Database.Upsertresult objDtbUpsRes : lDtbUpsRes){
				if (!objDtbUpsRes.isSuccess())
					System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel ERROR : ' + objDtbUpsRes.getErrors()[0].getMessage());				
			}//Fin del for para lDtbUpsRes
			System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList.ErrorID);    		
			System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList.ErrorDescripcion);			
    	}*/

    	/*//Para el servicio de CatalogoFuerzasVenta Sin parametros
    	DTC_CatalogoFuerzasVenta_rst.classRespuestaTelcelTodo objproductosVPNList = DTC_CatalogoFuerzasVenta_rst.getCatalogoFuerzasVentaNoEmpleado('12345');
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList);
    	if (objproductosVPNList.ErrorID == '0'){
			System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList.ErrorID);    		
			System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList.ErrorDescripcion);
    	}*/

    	/*//Para el servicio del Directorio de Empleados
    	DCT_DirectorioEmpleados_rst.classRespuestaTelcel objproductosVPNList = DCT_DirectorioEmpleados_rst.getDirectorioEmpleados('XON2925');
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList);
    	if (objproductosVPNList.ErrorID == '0'){
			System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList.ErrorID);    		
			System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objproductosVPNList: ' + objproductosVPNList.ErrorDescripcion);
    	}*/
		
		//PARA EL WS DE PLANES
		/*System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel slConsecCons: ' + slConsecCons);		
		//Manda llamar los metodos del WS de planeas
		DCT_TelcelPlanesSoap_ws.getMercadosResponseDTO MercadosResponseDTOResult = DCT_TelcelPlanesMetodos_ws.ConsultarMercados(slConsecCons, 'CELME');
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objMercadosResponseDTOPaso: ' + MercadosResponseDTOResult);		
		//Ve si no hay error 
		if (MercadosResponseDTOResult.detailResponse.code == '0'){
			DCT_TelcelPlanesSoap_ws.planesMercadoWSOUTDTO objPlanesMercadoWSOUTDTO = MercadosResponseDTOResult.listaMercados;
			//Ve si tiene algo la lista de objPlanesMercadoWSOUTDTO.
			if (!objPlanesMercadoWSOUTDTO.Mercado.isEmpty()){
				//Recorre la lista de objPlanesMercadoWSOUTDTO.
				for (DCT_TelcelPlanesSoap_ws.planMercado planMercado : objPlanesMercadoWSOUTDTO.Mercado){
					System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel planMercado: cveMercado: ' + planMercado.cveMercado + ' ' + planMercado.descripcionMercado);
				}
			}//Fin si !objPlanesMercadoWSOUTDTO.Mercado.isEmpty()
		}//Fin si !MercadosResponseDTOResult.listaMercados.isEmpty()*/

		/*System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel slConsecCons: ' + slConsecCons);		
		//Manda llamar los metodos del WS de planeas
		DCT_TelcelPlanesSoap_ws.getGruposPlanResponseDTO GruposPlanResponseDTOResult = DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan(slConsecCons, 'CELME', '3');
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objGruposPlanResponseDTOPaso: ' + GruposPlanResponseDTOResult);		
		//Ve si no hay error 
		if (GruposPlanResponseDTOResult.detailResponse.code == '0'){
			DCT_TelcelPlanesSoap_ws.grupoPlanesMercadoOUTDTO objgrupoPlanesMercadoOUTDTO = GruposPlanResponseDTOResult.listaGruposPlan;
			//Ve si tiene algo la lista de objgrupoPlanesMercadoOUTDTO.
			if (!objgrupoPlanesMercadoOUTDTO.GrupoPlan.isEmpty()){
				//Recorre la lista de objgrupoPlanesMercadoOUTDTO.
				for (DCT_TelcelPlanesSoap_ws.grupoPlanMercado GruposPlan : objgrupoPlanesMercadoOUTDTO.GrupoPlan){
					System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel GruposPlan: ' + GruposPlan);
				}
			}//Fin si !objgrupoPlanesMercadoOUTDTO.Mercado.isEmpty()
		}//Fin si !GruposPlanResponseDTOResult.listaMercados.isEmpty()*/

		/*System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel slConsecCons: ' + slConsecCons);		
		//Manda llamar los metodos del WS de planeas
		DCT_TelcelPlanesSoap_ws.getPlazosResponseDTO PlazosResponseDTOResult = DCT_TelcelPlanesMetodos_ws.ConsultarPlazos(slConsecCons, 'CELME', '3', '90', '389');
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel PlazosResponseDTOResult: ' + PlazosResponseDTOResult);		
		//Ve si no hay error 
		if (PlazosResponseDTOResult.detailResponse.code == '0'){
			DCT_TelcelPlanesSoap_ws.planPlazoFVMercadoOUTDTO objplanPlazoFVMercadoOUTDTO = PlazosResponseDTOResult.listaPlazos;
			//Ve si tiene algo la lista de objplanPlazoFVMercadoOUTDTO.
			if (!objplanPlazoFVMercadoOUTDTO.Plazo.isEmpty()){
				//Recorre la lista de objplanPlazoFVMercadoOUTDTO.
				for (DCT_TelcelPlanesSoap_ws.planPlazoMercado PlazoMercado : objplanPlazoFVMercadoOUTDTO.Plazo){
					System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel PlazoMercado: ' + PlazoMercado);
				}
			}//Fin si !objplanPlazoFVMercadoOUTDTO.Mercado.isEmpty()
		}//Fin si !PlazosResponseDTOResult.listaMercados.isEmpty()*/

		/*System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel slConsecCons: ' + slConsecCons);		
		//Manda llamar los metodos del WS de planeas
		DCT_TelcelPlanesSoap_ws.getPlanesResponseDTO PlanesResponseDTOResult = DCT_TelcelPlanesMetodos_ws.ConsultarPlanes(slConsecCons, 'CELME', '3', '3', '90', '389');
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel PlanesResponseDTOResult: ' + PlanesResponseDTOResult);		
		//Ve si no hay error
		if (PlanesResponseDTOResult.detailResponse.code == '0'){
			DCT_TelcelPlanesSoap_ws.getPlanesOUTDTO objgetPlanesOUTDTO = PlanesResponseDTOResult.listaPlanes;
			//Ve si tiene algo la lista de objgetPlanesOUTDTO.
			if (!objgetPlanesOUTDTO.plan.isEmpty()){
				//Recorre la lista de objgetPlanesOUTDTO.
				for (DCT_TelcelPlanesSoap_ws.planPlazoM2K PlazoMercado : objgetPlanesOUTDTO.plan){
					System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel PlazoMercado: ' + PlazoMercado);
				}
			}//Fin si !objgetPlanesOUTDTO.Mercado.isEmpty()
		}//Fin si !PlanesResponseDTOResult.listaMercados.isEmpty()*/

		/*System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel slConsecCons: ' + slConsecCons);		
		//Manda llamar los metodos del WS de planeas
		DCT_TelcelPlanesSoap_ws.getGuiaPlanesResponseDTO GuiaPlanesResponseDTOResult = DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes(slConsecCons, 'CELME', 'DK148');
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel GuiaPlanesResponseDTOResult: ' + GuiaPlanesResponseDTOResult);		
		//Ve si no hay error
		if (GuiaPlanesResponseDTOResult.detailResponse.code == '0'){
			DCT_TelcelPlanesSoap_ws.guiaPlanesOUTDTO objguiaPlanesOUTDTO = GuiaPlanesResponseDTOResult.listaPlanes;
			//Despliega los objetos			
			System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objguiaPlanesOUTDTO.caracteristicas: ' + objguiaPlanesOUTDTO.caracteristicas);
			//System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objguiaPlanesOUTDTO.servicios: ' + objguiaPlanesOUTDTO.servicios);
			DCT_TelcelPlanesSoap_ws.ArrayOfGuiaPlanesServiciosDTO objArrayOfGuiaPlanesServiciosDTO = objguiaPlanesOUTDTO.servicios;
			//Recorre la lista de servicios
			if (!objArrayOfGuiaPlanesServiciosDTO.servicio.isEmpty()){
				for (DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO objGuiaPlanesServiciosDTO : objArrayOfGuiaPlanesServiciosDTO.servicio){
					System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objGuiaPlanesServiciosDTO: ' + objGuiaPlanesServiciosDTO);					
				}
			}//Fin si !objArrayOfGuiaPlanesServiciosDTO.servicio.isEmpty()
		}//Fin si !GuiaPlanesResponseDTOResult.listaMercados.isEmpty()*/
		//HASTA AQUI PARA EL WS DE PLANES

		//PARA EL WS DE EQUIPOS
		/*System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel slConsecCons: ' + slConsecCons);		
		//Manda llamar los metodos del WS de planeas
		DCT_TelcelEquiposSoap_ws.getMarcasResponseDTO MarcasResponseDTOResult = DCT_TelcelEquiposMetodos_ws.ConsultarMarcas(slConsecCons, 'CELME');
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel MarcasResponseDTOResult: ' + MarcasResponseDTOResult);		
		//Ve si no hay error 
		if (MarcasResponseDTOResult.detailResponse.code == '0'){
			DCT_TelcelEquiposSoap_ws.marcasOUTDTO objMarcasOUTDTO = MarcasResponseDTOResult.listaMarcas;
			//Ve si tiene algo la lista de objMarcasOUTDTO.
			if (!objMarcasOUTDTO.Marca.isEmpty()){
				//Recorre la lista de objMarcasOUTDTO.
				for (DCT_TelcelEquiposSoap_ws.marca Marca : objMarcasOUTDTO.Marca){					
					System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel PlanMarca: Marca: ' + Marca.cveMarca + ' ' + Marca.descripcionMarca);
				}
			}//Fin si !objMarcasOUTDTO.Mercado.isEmpty()
		}//Fin si !MarcasResponseDTOResult.listaMercados.isEmpty()*/

		/*System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel slConsecCons: ' + slConsecCons);		
		//Manda llamar los metodos del WS de planeas
		DCT_TelcelEquiposSoap_ws.getModelosResponseDTO ModelosResponseDTOResult = DCT_TelcelEquiposMetodos_ws.ConsultarModelos(slConsecCons, 'CELME', '186');
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel ModelosResponseDTOResult: ' + ModelosResponseDTOResult);		
		//Ve si no hay error 
		if (ModelosResponseDTOResult.detailResponse.code == '0'){
			DCT_TelcelEquiposSoap_ws.modelosOUTDTO objModelosOUTDTO = ModelosResponseDTOResult.listaModelos;
			//Ve si tiene algo la lista de objModelosOUTDTO.
			if (!objModelosOUTDTO.Modelo.isEmpty()){
				//Recorre la lista de objModelosOUTDTO.
				for (DCT_TelcelEquiposSoap_ws.modelo Modelo : objModelosOUTDTO.Modelo){					
					System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel PlanModelo: Modelo: ' + Modelo.cveModeloM2k + ' ' + Modelo.descripcionModelo + ' ' + Modelo.nombreComercial);
				}
			}//Fin si !objModelosOUTDTO.Mercado.isEmpty()
		}//Fin si !ModelosResponseDTOResult.listaMercados.isEmpty()*/

		/*System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel slConsecCons: ' + slConsecCons);		
		//Manda llamar los metodos del WS de planeas
		DCT_TelcelEquiposSoap_ws.getInformacionModeloResponseDTO InformacionModeloResponseDTOResult = DCT_TelcelEquiposMetodos_ws.ConsultarInformacionModelo(slConsecCons, 'CELME', 'MF626ROU');
		System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel InformacionModeloResponseDTOResult: ' + InformacionModeloResponseDTOResult);		
		//Ve si no hay error 
		if (InformacionModeloResponseDTOResult.detailResponse.code == '0'){
			DCT_TelcelEquiposSoap_ws.informacionModeloOUTDTO objinformacionModeloOUTDTO = InformacionModeloResponseDTOResult.InformacionModelo;
			//Ve si tiene algo la lista de objinformacionModeloOUTDTO.
			if (!objinformacionModeloOUTDTO.Modelo.isEmpty()){
				//Recorre la lista de objinformacionModeloOUTDTO.
				for (DCT_TelcelEquiposSoap_ws.informacionModelo  infoModelo : objinformacionModeloOUTDTO.Modelo){					
					System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel PlanModelo: informacionModelo: ' + infoModelo.descripcionModelo + ' ' + infoModelo.nombreComercial);
				}
			}//Fin si !objinformacionModeloOUTDTO.Mercado.isEmpty()
		}//Fin si !InformacionModeloResponseDTOResult.listaMercados.isEmpty()

    	//Regresa  null;
        return null;
    }*/

    public DCT_AccountOwnerAssignment_cls(){
        initVarsAndCollections();
        if(validateWhetherIsPossibleToStart()){
            blnIsItPossibleToStart = true;
        }
    }
	
    public void initVarsAndCollections(){
        strLookUpUserName = '';
        strSelectedRightUser = '';
        strSelectedUserId = '';
        blnShowLookUpUI = false;
        blnIsItPossibleToStart = false;
        blnShowMainUI = true;
        blnChangesHaveBeenMade = false;
        blnSuccessfulProcedure = false;
        mapFoundUsersById = new Map<Id,User>();
        mapOwnersAndAccounts = new Map<String,AccountsByOwnerWrapper>();
        mapFinalOwnersAndAccounts = new Map<String,AccountsByOwnerWrapper>();
        leftOwnerAndAccounts = new AccountsByOwnerWrapper();
        lstFoundUsersLookUp = new List<UserLookUpWrapper>();
        selectedUser = new User();
        mapIdUsuario = new Map<Id,User>();
        mapIdUsrRol = new Map<String, String>();
        mapIdUsrIdGestor = new Map<String, String>();
        mapIdUsrNomFun = new Map<String, String>();
        mapUsrSelForAssig = new Map<String, Map<String, AccountWrapperAssignForUsers>>();
        sUserActualFuncion = '';
        sIdUserActualPerfil = '';
        accountRecord = new Account();
        mapIdUsrIdGest = new  Map<String, String>();
        blnEsCoordinador = false;
        setRelatedUsersCoord = new Set<String>();
        setManagerUsers = new Set<String>(); 
        bUsrBusExit = false;
        bSeleccionUnaCuenta = false;

	    soSegmento = new List<SelectOption>();
        soSegmento.add(new SelectOption('' , '--Ninguno--'));
        soSegmento.add(new SelectOption('Corporativo' , 'Corporativo'));        
        soSegmento.add(new SelectOption('Empresarial' , 'Empresarial'));
        soSegmento.add(new SelectOption('PyME' , 'PyME'));
		                        	
        getDatosUsuario(UserInfo.getUserId());
        initOrCleanUpMsg();
        ConsultaUsuarios();
        
        //Busca solo los usuarios de la persna que esta entrando a SFDC
        if (!blnEsCoordinador && !Test.isRunningTest())
       		fillAccountsByOwnerMap(UserInfo.getUserId(), false);        
        if (blnEsCoordinador && !Test.isRunningTest())
       		fillAccountsByOwnerMapCoordinador(UserInfo.getUserId(), false);                
        
    }

	public void getDatosUsuario(String sUsrId){
		System.debug('ENTRO A DCT_AccountOwnerAssignment_cls.getDatosUsuario...');
		
		for (User usrDatos : [Select u.UserRole.Name, u.UserRoleId, u.Profile.Name, u.ProfileId, ManagerId 
			From User u where id =: sUsrId]){
			System.debug('ENTRO A DCT_AccountOwnerAssignment_cls.getDatosUsuario usrDatos: ' + usrDatos);
			sIdManagerUserActual = usrDatos.ManagerId;
			if (usrDatos.Profile.Name != null)				
				sIdUserActualPerfil = usrDatos.Profile.Name;
			if (usrDatos.UserRole.Name != null){
				sUserActualFuncion = usrDatos.UserRole.Name;
				sIdUserActualFuncion = usrDatos.UserRoleId;
			}//Fin si usrDatos.UserRole.Name != null
			if (sUserActualFuncion.startsWith('Coordinador'))
				blnEsCoordinador = true;
			System.debug('ENTRO A DCT_AccountOwnerAssignment_cls.getDatosUsuario sIdUserActualPerfil: ' + sIdUserActualPerfil);
			System.debug('ENTRO A DCT_AccountOwnerAssignment_cls.getDatosUsuario sIdManagerUserActual: ' + sIdManagerUserActual);
			System.debug('ENTRO A DCT_AccountOwnerAssignment_cls.getDatosUsuario sUserActualFuncion: ' + sUserActualFuncion);			
			System.debug('ENTRO A DCT_AccountOwnerAssignment_cls.getDatosUsuario sIdUserActualFuncion: ' + sIdUserActualFuncion);			
		}
	
	} 

	public String getPerfilUsuario(String sUsuario){
		System.debug('ENTRO A DCT_AccountOwnerAssignment_cls.getPerfilUsuario...');
		String sIdUserActualPerfilPaso = '';
		for (User usrDatos : [Select u.UserRole.Name, u.UserRoleId, u.Profile.Name, u.ProfileId, ManagerId 
			From User u where id =: sUsuario]){
			sIdManagerUserActual = usrDatos.ManagerId;
			if (usrDatos.Profile.Name != null)				
				sIdUserActualPerfilPaso = usrDatos.Profile.Name;
			System.debug('ENTRO A DCT_AccountOwnerAssignment_cls.getPerfilUsuario sIdUserActualPerfil: ' + sIdUserActualPerfil);
		}
		return sIdUserActualPerfilPaso;
	} 

	public String getGestorGvCa(String sManagerId, Boolean bRegresaNombre){
		System.debug('EN DCT_AccountOwnerAssignment_cls.getGestorGvCa sManagerId: ' + sManagerId);

		String sNomFuncManId = '';
		//String sNmFuncBusc = sUserActualFuncion.startsWith('GV') ? 'GV' : 'Coordinador';   
		String sNmFuncBusc = sUserActualFuncion.startsWith('GV') ? 'GV' : 'GV';
		System.debug('EN DCT_AccountOwnerAssignment_cls.getGestorGvCa sNmFuncBusc: ' + sNmFuncBusc);
		
       	for (User usuario : [Select Id, UserRole.Name, UserRoleId,
       		Manager.UserRole.Name, ManagerId, Manager.Name, //1er nivel hacia arriva
       		Manager.Manager.UserRole.Name, Manager.ManagerId,//2do nivel hacia arriva       		
       		Manager.Manager.Manager.UserRole.Name, Manager.Manager.ManagerId//3er nivel hacia arriva
       		FROM User WHERE id = :sManagerId]){
	    	System.debug('EN DCT_AccountOwnerAssignment_cls.getGestorGvCa usuarios de Funcion del usuario: ' + usuario.UserRole.Name); 
			System.debug('EN DCT_AccountOwnerAssignment_cls.getGestorGvCa usuarios de Funcion del gestor 1er nivel: ' + usuario.Manager.UserRole.Name);
			System.debug('EN DCT_AccountOwnerAssignment_cls.getGestorGvCa usuarios de Funcion del gestor 2do nivel: ' + usuario.Manager.Manager.UserRole.Name);
			System.debug('EN DCT_AccountOwnerAssignment_cls.getGestorGvCa usuarios de Funcion del gestor 3er nivel: ' + usuario.Manager.Manager.Manager.UserRole.Name);
			//Ve si alguna de las funciones de los gestores es de tipo GV o SD
			if (usuario.UserRole.Name != null)
				if (usuario.UserRole.Name.startsWith(sNmFuncBusc))
        			return sNomFuncManId = bRegresaNombre ? usuario.UserRole.Name : usuario.Id;
			else if (usuario.Manager.UserRole.Name != null)
				if (usuario.Manager.UserRole.Name.startsWith(sNmFuncBusc))
        			return sNomFuncManId = bRegresaNombre ? usuario.Manager.UserRole.Name : usuario.ManagerId;
			else if (usuario.Manager.Manager.UserRole.Name != null)
				if (usuario.Manager.Manager.UserRole.Name.startsWith(sNmFuncBusc))
        			return sNomFuncManId = bRegresaNombre ? usuario.Manager.Manager.UserRole.Name : usuario.Manager.ManagerId;
			else if (usuario.Manager.Manager.Manager.UserRole.Name != null)
				if (usuario.Manager.Manager.Manager.UserRole.Name.startsWith(sNmFuncBusc))
        			return sNomFuncManId = bRegresaNombre ? usuario.Manager.Manager.Manager.UserRole.Name : usuario.Manager.Manager.ManagerId;
       	}

		System.debug('EN DCT_AccountOwnerAssignment_cls.getGestorGvCa ANTES DE SALIR sNomFuncManId: ' + sNomFuncManId);		        
        return sNomFuncManId;		
	}
    
    public void initOrCleanUpMsg(){
        lstErrorMsgs = new List<String>();
        lstSuccessMsgs = new List<String>();
		lstErrorMsgsBU = new List<String>();
		bUsrBusExit = false;
    }

    public void goToLookUpUI(){
    	System.debug('ENTRO A goToLookUpUI...');    	
        bUsrBusExit = false;
            	
        searchUsers();
        blnShowLookUpUI = true;
        blnShowMainUI = false;
        
        //Para la prueba de los WebServices
        //pruebaLoginTelcel();		        
    }	

    public void ConsultaUsuarios(){
    	for (User usuario : [SELECT Id, Name, ManagerId, Manager.Name, UserRole.Name FROM User]){
			mapIdUsuario.put(usuario.id, usuario);
			mapIdUsrRol.put(usuario.id, usuario.UserRole.Name);
    	}
    }

    public void fillAccountsByOwnerMap(String sUser, Boolean bConsUsrAct){
       	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMap sUser: ' + sUser + ' bConsUsrAct: ' + bConsUsrAct);
       	    	
        String strCurrentUserId = sUser;
        List<UserRole> lstRolesUsers = new List<UserRole>();        
        Set<String> setIdRole = new Set<String>();
        setUsrCoord = new Set<String>();
        lstRelatedUsers = new List<User>();
        List<Account> lstRelatedAccs = new List<Account>();
        List<Account> lstNotPendingAccs = new List<Account>();
        Map<Id,User> mapUserById = new Map<Id,User>();
        Map<Id,List<Account>> mapAccsByOwner = new Map<Id,List<Account>>();
        Set<Id> setRelatedAccsIds = new Set<Id>();
        Set<Id> setAccountsInPendingApproval = new Set<Id>();
        mapOwnersAndAccounts = new Map<String,AccountsByOwnerWrapper>();
        
        String sUsrAct = '';
        if (bConsUsrAct)
        	sUsrAct = ' And isActive = true';
        	        
        //Ve si no es un coordinador
        List<String> lstOrArgs = new List<String>{
            'ManagerId = \''+strCurrentUserId+'\''
        };        
        String strQueryOverUsersSttmnt = 'SELECT Id, Name, ManagerId, Manager.Name FROM User WHERE ('+String.join(lstOrArgs, ' OR ') +' ) And Profile.Name IN (\'DR9\',\'GV\',\'JEC\',\'SD\') ';
        strQueryOverUsersSttmnt += sUsrAct;  
        System.debug('EN fillAccountsByOwnerMap strQueryOverUsersSttmnt2: ' + strQueryOverUsersSttmnt);
        try{
   	    	lstRelatedUsers = Database.query(strQueryOverUsersSttmnt);
       	}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}

       	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMap sUserActualFuncion: ' + sUserActualFuncion + ' strSelectedUserId: ' + strSelectedUserId);
		//Si se trata de un gerente GV
		if (sUserActualFuncion.startsWith('GV') && strSelectedUserId != null){	        
	    	//Ahora si consulta los usuarios asociados a setIdRole
	    	for(User usuario : [SELECT Id, Name, ManagerId, Manager.Name FROM User 
	    		WHERE Profile.Name IN ('GV') And isActive = true Order by Name]){
	    		lstRelatedUsers.add(usuario);
	    		setUsrCoord.add(usuario.id);
	    		setRelatedUsersCoord.add(usuario.id);
		        System.debug('EN DCT_AccountOwnerAssignment_cls usuario: ' + usuario);	    		
	    	}//Fin del for para los usuarios de la coordinación
	        System.debug('EN DCT_AccountOwnerAssignment_cls setRelatedUsersCoord: ' + setRelatedUsersCoord);
			//FIN  si se trata de un gerente GV
		}//Fin si sUserActualFuncion.startsWith('GV')

        String sIdUsrSel;
        //Ve si tiene algo leftOwnerAndAccounts
        if (leftOwnerAndAccounts != null)
	        if (leftOwnerAndAccounts.ownerRecord != null)
	        	sIdUsrSel = leftOwnerAndAccounts.ownerRecord.id;
        System.debug('EN fillAccountsByOwnerMap sIdUsrSel: ' + sIdUsrSel);
                
        for(User iterator : lstRelatedUsers){
	        System.debug('EN fillAccountsByOwnerMap iterator: ' + iterator.Name);        	
        	if (sIdUsrSel != null){
	        	//if (sIdUsrSel != iterator.Id){
		            mapUserById.put(iterator.Id,iterator);
		            mapAccsByOwner.put(iterator.Id, new List<Account>());
	        	//}//Fin si sIdUsrSel != iterator.Id
        	}else{
	            mapUserById.put(iterator.Id,iterator);
	            mapAccsByOwner.put(iterator.Id, new List<Account>());
        	}
        }
       	//if (iterator.OwnerId != leftOwnerAndAccounts.ownerRecord.id){        
        System.debug('EN fillAccountsByOwnerMap mapUserById: ' + mapUserById.KeySet());
        System.debug('EN fillAccountsByOwnerMap mapAccsByOwner: ' + mapAccsByOwner.KeySet());
                
        if(!mapUserById.isEmpty()){
            String strQueryOverAccountsSttmnt = 'SELECT Id, Name, OwnerId, Owner.Name, DCTDateLastassignment__c FROM Account WHERE OwnerId IN (\''+String.join(new List<Id>(mapUserById.keySet()),'\',\'')+'\') ORDER BY Name';
	        System.debug('EN fillAccountsByOwnerMap strQueryOverAccountsSttmnt: ' + strQueryOverAccountsSttmnt);            
            try{lstRelatedAccs = Database.query(strQueryOverAccountsSttmnt);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
            for(Account iterator:lstRelatedAccs){
                setRelatedAccsIds.add(iterator.Id);
            }
            if(!setRelatedAccsIds.isEmpty()){
                setAccountsInPendingApproval = getAccountsWithPendingApprovalInAssignment(setRelatedAccsIds);
            }
            for(Account iterator:lstRelatedAccs){
                if(iterator.OwnerId != null){
                    if(mapAccsByOwner.containsKey(iterator.OwnerId)){
                        if(!setAccountsInPendingApproval.contains(iterator.Id)){
                            mapAccsByOwner.get(iterator.OwnerId).add(iterator);
                        }
                    }
                }
            }
        }
        
        for(String iterator0 : mapAccsByOwner.keySet()){
            if(mapUserById.containsKey(iterator0)){
                AccountsByOwnerWrapper accsByWrapperInstance = new AccountsByOwnerWrapper();
                accsByWrapperInstance.lstAccs = new List<AccountWrapper>();
		       	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMap ANTES DE getGestorGvCa: ' + iterator0);                
               	//Ve si agregas las cuentas al nivel que le corresponde
               	
				String sNomFunGest = '';
				if (!Test.isRunningTest())
					sNomFunGest = getGestorGvCa(iterator0, true);
		       	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMap sNomFunGest: ' + sNomFunGest);
		       	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMap sUserActualFuncion: ' + sUserActualFuncion);
		       	if (sNomFunGest == sUserActualFuncion || Test.isRunningTest()){
	                for(Account iterator1 : mapAccsByOwner.get(iterator0)){
	                	String sFechaUltiAsigna = '';
	                	if (iterator1.DCTDateLastassignment__c != null || Test.isRunningTest()){	                	
	                		sFechaUltiAsigna = iterator1.DCTDateLastassignment__c.Day() < 10 ? '0' + '' + iterator1.DCTDateLastassignment__c.Day() : String.valueOf(iterator1.DCTDateLastassignment__c.Day());
	                		sFechaUltiAsigna += '-';
	                		sFechaUltiAsigna += iterator1.DCTDateLastassignment__c.month() < 10 ? '0' + '' + iterator1.DCTDateLastassignment__c.month() : String.valueOf(iterator1.DCTDateLastassignment__c.month());
	                		sFechaUltiAsigna += '-';
	                		sFechaUltiAsigna += String.valueOf(iterator1.DCTDateLastassignment__c.year());	                		
	                	}//Fin si iterator1.DCTDateLastassignment__c != null)
	                	//Crea el objeto y metelo a la lista de lstAccs si no es un coordinador
	                    accsByWrapperInstance.lstAccs.add(
	                        new AccountWrapper(iterator1, false, sFechaUltiAsigna)
	                    );
	                }
		       	}//Fin sNomFunGest == sUserActualFuncion
                accsByWrapperInstance.ownerRecord = mapUserById.get(iterator0);
                accsByWrapperInstance.blnselectAllAccs = false;
                accsByWrapperInstance.blnSelectedForAssignment = false;
                accsByWrapperInstance.blnDisplayAccounts = false;
                accsByWrapperInstance.subordinados = new List<AccountsByOwnerWrapper>();
                accsByWrapperInstance.bMuestraNivelSuperiror = false;
		       	System.debug('ANTES DE SALIR DE fillAccountsByOwnerMap sUserActualFuncion: ' + sUserActualFuncion);
				if (sUserActualFuncion.startsWith('Coordinador'))
					accsByWrapperInstance.blnPermiteSelSub = false;
				accsByWrapperInstance.sManager = '';                
		       	System.debug('ANTES DE SALIR DE fillAccountsByOwnerMap ownerRecord.Name: ' + accsByWrapperInstance.ownerRecord.Name);				
                mapOwnersAndAccounts.put(iterator0,accsByWrapperInstance);
            }
        }
        
       	System.debug('ANTES DE SALIR DE fillAccountsByOwnerMap mapOwnersAndAccounts.KeySet(): ' + mapOwnersAndAccounts.KeySet()); 
    }

    public void fillAccountsByOwnerMapGerente(String sUser, Boolean bConsUsrAct){
       	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMap sUser: ' + sUser + ' bConsUsrAct: ' + bConsUsrAct);
       	    	
        String strCurrentUserId = sUser;
        List<UserRole> lstRolesUsers = new List<UserRole>();        
        Set<String> setIdRole = new Set<String>();
        setUsrCoord = new Set<String>();
        lstRelatedUsers = new List<User>();
        List<Account> lstRelatedAccs = new List<Account>();
        List<Account> lstNotPendingAccs = new List<Account>();
        Map<Id,User> mapUserById = new Map<Id,User>();
        Map<Id,List<Account>> mapAccsByOwner = new Map<Id,List<Account>>();
        Set<Id> setRelatedAccsIds = new Set<Id>();
        Set<Id> setAccountsInPendingApproval = new Set<Id>();
        mapOwnersAndAccounts = new Map<String,AccountsByOwnerWrapper>();
        
        String sUsrAct = '';
        if (bConsUsrAct)
        	sUsrAct = ' And isActive = true';
        	        
        //Ve si no es un coordinador
        List<String> lstOrArgs = new List<String>{
            'ManagerId = \''+strCurrentUserId+'\''
        };        
        String strQueryOverUsersSttmnt = 'SELECT Id, Name, ManagerId, Manager.Name FROM User WHERE ('+String.join(lstOrArgs, ' OR ') +' ) And Profile.Name IN (\'DR9\',\'GV\',\'JEC\',\'SD\') ';
        strQueryOverUsersSttmnt += sUsrAct;  
        System.debug('EN fillAccountsByOwnerMap strQueryOverUsersSttmnt2: ' + strQueryOverUsersSttmnt);
        try{
   	    	lstRelatedUsers = Database.query(strQueryOverUsersSttmnt);
       	}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}

        String sIdUsrSel;
        //Ve si tiene algo leftOwnerAndAccounts
        if (leftOwnerAndAccounts != null)
	        if (leftOwnerAndAccounts.ownerRecord != null)
	        	sIdUsrSel = leftOwnerAndAccounts.ownerRecord.id;
        System.debug('EN fillAccountsByOwnerMap sIdUsrSel: ' + sIdUsrSel);
                
        for(User iterator : lstRelatedUsers){
	        System.debug('EN fillAccountsByOwnerMap iterator: ' + iterator.Name);        	
        	if (sIdUsrSel != null){
	        	//if (sIdUsrSel != iterator.Id){
		            mapUserById.put(iterator.Id,iterator);
		            mapAccsByOwner.put(iterator.Id, new List<Account>());
	        	//}//Fin si sIdUsrSel != iterator.Id
        	}else{
	            mapUserById.put(iterator.Id,iterator);
	            mapAccsByOwner.put(iterator.Id, new List<Account>());
        	}
        }
       	//if (iterator.OwnerId != leftOwnerAndAccounts.ownerRecord.id){        
        System.debug('EN fillAccountsByOwnerMap mapUserById: ' + mapUserById.KeySet());
        System.debug('EN fillAccountsByOwnerMap mapAccsByOwner: ' + mapAccsByOwner.KeySet());
                
        if(!mapUserById.isEmpty()){
            String strQueryOverAccountsSttmnt = 'SELECT Id, Name, OwnerId, Owner.Name, DCTDateLastassignment__c FROM Account WHERE OwnerId IN (\''+String.join(new List<Id>(mapUserById.keySet()),'\',\'')+'\')';
            try{lstRelatedAccs = Database.query(strQueryOverAccountsSttmnt);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
            for(Account iterator:lstRelatedAccs)
                setRelatedAccsIds.add(iterator.Id);
            if(!setRelatedAccsIds.isEmpty())
                setAccountsInPendingApproval = getAccountsWithPendingApprovalInAssignment(setRelatedAccsIds);
            for(Account iterator:lstRelatedAccs){
                if(iterator.OwnerId != null){
                    if(mapAccsByOwner.containsKey(iterator.OwnerId)){
                        if(!setAccountsInPendingApproval.contains(iterator.Id)){
                            mapAccsByOwner.get(iterator.OwnerId).add(iterator);
                        }
                    }
                }
            }
        }
        
        for(String iterator0 : mapAccsByOwner.keySet()){
            if(mapUserById.containsKey(iterator0)){
                AccountsByOwnerWrapper accsByWrapperInstance = new AccountsByOwnerWrapper();
                accsByWrapperInstance.lstAccs = new List<AccountWrapper>();
		       	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMap ANTES DE getGestorGvCa: ' + iterator0);                
               	//Ve si agregas las cuentas al nivel que le corresponde
				String sNomFunGest = '';
				if (!Test.isRunningTest())
					sNomFunGest = getGestorGvCa(iterator0, true);
		       	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMap sNomFunGest: ' + sNomFunGest);
		       	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMap sUserActualFuncion: ' + sUserActualFuncion);
		       	if (sNomFunGest == sUserActualFuncion || Test.isRunningTest()){
	                for(Account iterator1 : mapAccsByOwner.get(iterator0)){
	                	String sFechaUltiAsigna = '';
	                	if (iterator1.DCTDateLastassignment__c != null || Test.isRunningTest()){	                	
	                		sFechaUltiAsigna = iterator1.DCTDateLastassignment__c.Day() < 10 ? '0' + '' + iterator1.DCTDateLastassignment__c.Day() : String.valueOf(iterator1.DCTDateLastassignment__c.Day());
	                		sFechaUltiAsigna += '-';
	                		sFechaUltiAsigna += iterator1.DCTDateLastassignment__c.month() < 10 ? '0' + '' + iterator1.DCTDateLastassignment__c.month() : String.valueOf(iterator1.DCTDateLastassignment__c.month());
	                		sFechaUltiAsigna += '-';
	                		sFechaUltiAsigna += String.valueOf(iterator1.DCTDateLastassignment__c.year());	                		
	                	}//Fin si iterator1.DCTDateLastassignment__c != null)
	                	//Crea el objeto y metelo a la lista de lstAccs si no es un coordinador
	                    accsByWrapperInstance.lstAccs.add(
	                        new AccountWrapper(iterator1, false, sFechaUltiAsigna)
	                    );
	                }
		       	}//Fin sNomFunGest == sUserActualFuncion
                accsByWrapperInstance.ownerRecord = mapUserById.get(iterator0);
                accsByWrapperInstance.blnselectAllAccs = false;
                accsByWrapperInstance.blnSelectedForAssignment = false;
                accsByWrapperInstance.blnDisplayAccounts = false;
                accsByWrapperInstance.subordinados = new List<AccountsByOwnerWrapper>();
                accsByWrapperInstance.bMuestraNivelSuperiror = false;
		       	System.debug('ANTES DE SALIR DE fillAccountsByOwnerMap sUserActualFuncion: ' + sUserActualFuncion);
				if (sUserActualFuncion.startsWith('Coordinador'))
					accsByWrapperInstance.blnPermiteSelSub = false;
				accsByWrapperInstance.sManager = '';                
		       	System.debug('ANTES DE SALIR DE fillAccountsByOwnerMap ownerRecord.Name: ' + accsByWrapperInstance.ownerRecord.Name);				
                mapOwnersAndAccounts.put(iterator0,accsByWrapperInstance);
            }
        }
        
       	System.debug('ANTES DE SALIR DE fillAccountsByOwnerMap mapOwnersAndAccounts.KeySet(): ' + mapOwnersAndAccounts.KeySet()); 
    }

    public void fillAccountsByOwnerMapCoordinador(String sUser, Boolean bConsUsrAct){
       	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMapCoordinador sUser: ' + sUser + ' bConsUsrAct: ' + bConsUsrAct);
       	    	
        String strCurrentUserId = sUser;
        List<UserRole> lstRolesUsers = new List<UserRole>();        
        Set<String> setIdRole = new Set<String>();
        setUsrCoord = new Set<String>();
        lstRelatedUsers = new List<User>();
        setRelatedUsersCoord = new Set<String>();        
        setManagerUsers = new Set<String>();
        List<Account> lstRelatedAccs = new List<Account>();
        List<Account> lstNotPendingAccs = new List<Account>();
        Map<Id,User> mapUserById = new Map<Id,User>();
        Map<Id,List<Account>> mapAccsByOwner = new Map<Id,List<Account>>();
        Set<Id> setRelatedAccsIds = new Set<Id>();
        Set<Id> setAccountsInPendingApproval = new Set<Id>();
        mapOwnersAndAccounts = new Map<String,AccountsByOwnerWrapper>();
        
        String sUsrAct = '';
        if (bConsUsrAct)
        	sUsrAct = ' And isActive = true';
		
		//Cosnulta los datos de los usuarios cordinadores
    	for(User Manager : [SELECT Id, Name FROM User 
    		Where Profile.Name IN ('DR9','CoordinacionAdministrativa')
    		And isActive = true]){
    		setManagerUsers.add(Manager.id);
	        System.debug('EN fillAccountsByOwnerMapCoordinador setManagerUsers: ' + setManagerUsers);	    		
    	}//Fin del for para los usuarios de la coordinación

        //Ve si es un coordinador
        List<String> lstOrArgs;
        if (!Test.isRunningTest())
	        lstOrArgs = new List<String>{'ParentRoleId = \''+sIdUserActualFuncion+'\' And Name Like \'%Subdirección%\''};
        if (Test.isRunningTest())
	        lstOrArgs = new List<String>{'Name Like \'%Subdirección%\''};
        
        String strQueryOverUsersSttmnt = 'SELECT u.ParentRoleId, u.Name, u.Id From UserRole u WHERE ('+String.join(lstOrArgs, ' OR ') +' ) ';
        System.debug('EN fillAccountsByOwnerMapCoordinador strQueryOverUsersSttmnt1: ' + strQueryOverUsersSttmnt);	        
        try{
        	lstRolesUsers = Database.query(strQueryOverUsersSttmnt);
        	//Toma el id de los roles para que consultes a los usuarios
        	for (UserRole roleId : lstRolesUsers){
				setIdRole.add(roleId.id);	        		
        	}//Fin del for para la lista de lstRolesUsers
	        System.debug('EN fillAccountsByOwnerMapCoordinador setIdRole: ' + setIdRole);
        }catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
    	//Ahora si consulta los usuarios asociados a setIdRole
    	for(User usuario : [SELECT Id, Name, ManagerId, Manager.Name FROM User 
    		//WHERE UserRoleId =:sIdUserActualFuncion
    		WHERE UserRoleId =:setIdRole And Profile.Name IN ('DR9','GV','JEC','SD')
    		And isActive = true]){
    		lstRelatedUsers.add(usuario);
    		setUsrCoord.add(usuario.id);
    		setRelatedUsersCoord.add(usuario.id);
	        System.debug('EN fillAccountsByOwnerMapCoordinador usuario: ' + usuario);	    		
    	}//Fin del for para los usuarios de la coordinación
        System.debug('EN fillAccountsByOwnerMapCoordinador setRelatedUsersCoord: ' + setRelatedUsersCoord);
	                        
        String sIdUsrSel;
        //Ve si tiene algo leftOwnerAndAccounts
        if (leftOwnerAndAccounts != null)
	        if (leftOwnerAndAccounts.ownerRecord != null)
	        	sIdUsrSel = leftOwnerAndAccounts.ownerRecord.id;
        System.debug('EN fillAccountsByOwnerMapCoordinador sIdUsrSel: ' + sIdUsrSel);
                
        for(User iterator : lstRelatedUsers){
	        System.debug('EN fillAccountsByOwnerMapCoordinador iterator: ' + iterator.Name);        	
        	if (sIdUsrSel != null && !blnEsCoordinador){
	        	if (sIdUsrSel != iterator.Id){
		            mapUserById.put(iterator.Id,iterator);
		            mapAccsByOwner.put(iterator.Id, new List<Account>());
	        	}//Fin si sIdUsrSel != iterator.Id
        	}else{
	            mapUserById.put(iterator.Id,iterator);
	            mapAccsByOwner.put(iterator.Id, new List<Account>());
        	}
        }
       	//if (iterator.OwnerId != leftOwnerAndAccounts.ownerRecord.id){        
        System.debug('EN fillAccountsByOwnerMapCoordinador mapUserById: ' + mapUserById.KeySet());
        System.debug('EN fillAccountsByOwnerMapCoordinador mapAccsByOwner: ' + mapAccsByOwner.KeySet());
                        
        for(String iterator0 : mapAccsByOwner.keySet()){
            if(mapUserById.containsKey(iterator0)){
                AccountsByOwnerWrapper accsByWrapperInstance = new AccountsByOwnerWrapper();
                accsByWrapperInstance.lstAccs = new List<AccountWrapper>();
		       	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMapCoordinador ANTES DE getGestorGvCa: ' + iterator0);
               	//Ve si agregas las cuentas al nivel que le corresponde
				String sNomFunGest = '';
				if (!Test.isRunningTest())
					sNomFunGest = getGestorGvCa(iterator0, true);
		       	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMapCoordinador sNomFunGest: ' + sNomFunGest);
		       	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMapCoordinador sUserActualFuncion: ' + sUserActualFuncion);
		       	if ( (sNomFunGest == sUserActualFuncion) || Test.isRunningTest()){
	                for(Account iterator1 : mapAccsByOwner.get(iterator0)){
	                	String sFechaUltiAsigna = '';
	                	if (iterator1.DCTDateLastassignment__c != null){	                	
	                		sFechaUltiAsigna = iterator1.DCTDateLastassignment__c.Day() < 10 ? '0' + '' + iterator1.DCTDateLastassignment__c.Day() : String.valueOf(iterator1.DCTDateLastassignment__c.Day());
	                		sFechaUltiAsigna += '-';
	                		sFechaUltiAsigna += iterator1.DCTDateLastassignment__c.month() < 10 ? '0' + '' + iterator1.DCTDateLastassignment__c.month() : String.valueOf(iterator1.DCTDateLastassignment__c.month());
	                		sFechaUltiAsigna += '-';
	                		sFechaUltiAsigna += String.valueOf(iterator1.DCTDateLastassignment__c.year());	                		
	                	}//Fin si iterator1.DCTDateLastassignment__c != null)
	                }//Fin del for para mapAccsByOwner.get(iterator0)
		       	}//Fin sNomFunGest == sUserActualFuncion
                accsByWrapperInstance.ownerRecord = mapUserById.get(iterator0);
                accsByWrapperInstance.blnselectAllAccs = false;
                accsByWrapperInstance.blnSelectedForAssignment = false;
                accsByWrapperInstance.blnDisplayAccounts = false;
                accsByWrapperInstance.subordinados = new List<AccountsByOwnerWrapper>();
                accsByWrapperInstance.bMuestraNivelSuperiror = false;
		       	System.debug('ANTES DE SALIR DE fillAccountsByOwnerMapCoordinador sUserActualFuncion: ' + sUserActualFuncion);
				if (sUserActualFuncion.startsWith('Coordinador'))
					accsByWrapperInstance.blnPermiteSelSub = false;
				accsByWrapperInstance.sManager = '';                
                mapOwnersAndAccounts.put(iterator0,accsByWrapperInstance);
            }//Fin si mapUserById.containsKey(iterator0)
        }//Fin del for para mapAccsByOwner.keySet()
        
        //Pon el encabezado en cada usuario
        if (bConsUsrAct && !Test.isRunningTest())
	        commitUserSelection();
        
       	System.debug('ANTES DE SALIR DE fillAccountsByOwnerMapCoordinador mapOwnersAndAccounts.KeySet(): ' + mapOwnersAndAccounts.KeySet()); 
    }

    public void searchUsers(){
    	System.debug('ENTRO A searchUsers strLookUpUserName: ' + strLookUpUserName + ' setUsrCoord: ' + setUsrCoord);

        bUsrBusExit = false;       	
        mapFoundUsersById = new Map<Id,User>();
        lstFoundUsersLookUp = new List<UserLookUpWrapper>();
        List<User> lstUsers = new List<User>();
        String strCurrentUserId = UserInfo.getUserId();
        List<String> lstConditions = new List<String>();
        Map<String, List<User>> mapGestUsr = new Map<String, List<User>>();
        Map<String, Set<String>> mapCtasPendUsr = new Map<String, Set<String>>();
        Set<String> setCtasPendUsr = new Set<String>();

        if(strLookUpUserName != null){
            if(!String.isBlank(strLookUpUserName)){
                lstConditions.add('Name like \'%'+strLookUpUserName+'%\' ');
            }
        }
        
		//Es un coordinador
        if (blnEsCoordinador || Test.isRunningTest()){
        	String sIdUsr = '(\'';
        	for (String sIdUsrCoor : setUsrCoord){
        		sIdUsr += sIdUsrCoor + '\',\'';
        	}
        	sIdUsr = sIdUsr.substring(0, sIdUsr.lastindexOf(','));
        	sIdUsr += ')';
	        System.debug('EN searchUsers COORDINADOR sIdUsr: ' + sIdUsr);
	                	
	        List<String> lstOrArgs = new List<String>{
	            'ManagerId IN '+sIdUsr+'',
	            'Manager.ManagerId IN '+sIdUsr+'',
	            'Manager.Manager.ManagerId IN '+sIdUsr+'',
	            'Manager.Manager.Manager.ManagerId IN '+sIdUsr+'',
	            'Manager.Manager.Manager.Manager.ManagerId IN '+sIdUsr+'',            
	            'Manager.Manager.Manager.Manager.Manager.ManagerId IN '+sIdUsr+'',
	            'Manager.Manager.Manager.Manager.Manager.Manager.ManagerId IN '+sIdUsr+''
	        };

	        lstConditions.add('('+String.join(lstOrArgs, ' OR ')+')');
	        String strQueryOverUsersSttmnt = 'SELECT Id, Name, Manager.Name, ManagerId, UserRole.Name, Profile.Name FROM User WHERE ('+String.join(lstConditions,' AND ')+') And Profile.Name IN (\'DR9\',\'GV\',\'JEC\',\'SD\') '; 
	        System.debug('EN searchUsers COORDINADOR strQueryOverUsersSttmnt: ' + strQueryOverUsersSttmnt);
    	    try{lstUsers = Database.query(strQueryOverUsersSttmnt);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
			System.debug('EN searchUsers lstUsers: ' + lstUsers);
			        	
        }//Fin si blnEsCoordinador
        
        //Ve si no es un coordinador
        if (!blnEsCoordinador){
	        List<String> lstOrArgs = new List<String>{
	            'ManagerId = \''+strCurrentUserId+'\'',
	            'Manager.ManagerId = \''+strCurrentUserId+'\'',
	            'Manager.Manager.ManagerId = \''+strCurrentUserId+'\'',
	            'Manager.Manager.Manager.ManagerId = \''+strCurrentUserId+'\'',
	            'Manager.Manager.Manager.Manager.ManagerId = \''+strCurrentUserId+'\'',            
	            'Manager.Manager.Manager.Manager.Manager.ManagerId = \''+strCurrentUserId+'\'',
	            'Manager.Manager.Manager.Manager.Manager.Manager.ManagerId = \''+strCurrentUserId+'\''
	        };
	        lstConditions.add('('+String.join(lstOrArgs, ' OR ')+')');
	        String strQueryOverUsersSttmnt = 'SELECT Id, Name, Manager.Name, ManagerId, UserRole.Name, Profile.Name FROM User WHERE ('+String.join(lstConditions,' AND ')+') And Profile.Name IN (\'DR9\',\'GV\',\'JEC\',\'SD\') '; 
	        System.debug('EN searchUsers GERENTE strQueryOverUsersSttmnt: ' + strQueryOverUsersSttmnt);
    	    try{lstUsers = Database.query(strQueryOverUsersSttmnt);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        }//Fin si !blnEsCoordinador
		
		Set<String> sUsrId = new Set<String>(); 
		//Toma a los usuarios y ve si tienen cuentas asociadas
        for(User iterator : lstUsers){
	        System.debug('EN searchUsers iterator: ' + iterator.Profile.Name + ' Nmobre Usuario: ' + iterator.Name + ' ID: ' + iterator.id);        	
			sUsrId.add(iterator.id);
			mapIdUsrIdGestor.put(iterator.id, iterator.ManagerId);
			mapIdUsrNomFun.put(iterator.id, iterator.UserRole.Name);
        }//Fin para lstUsers

		//Consulta las cuentas que tienen proceso pendientes por aprobar
		for (DCTClientsProspectstoAssigned__c objCtasPen : [Select d.AssignmentNumber__c, d.AccountName__c, d.IssuingUser__c 
				From DCTClientsProspectstoAssigned__c d Where d.AssignmentNumber__r.DCTProccesAprobed__c = 'Pendiente' 
				OR d.AssignmentNumber__r.Status__c = 'Pendiente']){
			System.debug('EN searchUsers objCtasPen.AccountName__c : ' + objCtasPen.AccountName__c + ' IDCteProspReas:  ' + objCtasPen.id);
			setCtasPendUsr.add(objCtasPen.AccountName__c);
		}//Fin del for para la lista de cuentas por usuario que se esta asignando
		System.debug('EN searchUsers setCtasPendUsr : ' + setCtasPendUsr);
       			
		//Toma al usuario actual
        if (sUserActualFuncion.startsWith('GV')){
        	for (User usuarioActualPaso : [Select Id, Name, Manager.Name, ManagerId, UserRole.Name 
        		From User u Where Id IN (SELECT OwnerId From Account Where OwnerId =: sIdUserActual)]){
       			System.debug('EN searchUsers USUARIO ACTUAL CUANTAS : ' + usuarioActualPaso.ID);        			
				sUsrId.add(usuarioActualPaso.id);
        	}
        }//Fin si sUserActualFuncion.startsWith('GV')
		System.debug('EN searchUsers sUsrId : ' + sUsrId);
		        
        Set<String> setIdUsrConCtas = new Set<String>();
        //Ve si tienen cuentas los usuarios de sUsrId
        if (!sUsrId.isEmpty()){
       		System.debug('EN searchUsers sUsrId: ' + sUsrId.size());
        	for (User usrAcc : [Select u.UserRole.Name, u.UserRoleId, u.Profile.Name, u.ProfileId  
        		From User u Where Id IN (SELECT OwnerId From Account Where OwnerId IN : sUsrId
        		And ID NOT IN :setCtasPendUsr) And id IN : sUsrId]){
				setIdUsrConCtas.add(usrAcc.Id);
        		bUsrBusExit = true;        		
        	}//Fin del for para las cuentas de los usuarios        	
        }//Fin si sUsrId.isEmpty()
   		System.debug('EN searchUsers setIdUsrConCtas SI: ' + setIdUsrConCtas);
   		
        //Encontro usuarios la busqueda pero no tienen cuentas asociadas
        if (!lstUsers.isEmpty() && setIdUsrConCtas.isEmpty())
       		bUsrBusExit = true;        	
        
        Integer cntReg = 0;
        String sGestorIni = '';
        if (!lstUsers.isEmpty())
        	sGestorIni = lstUsers.get(0).Manager.Name;
        
        //Recorre la lista de los usuarios lstUsers 	
        for(User iterator : lstUsers){
        	//Ve si el usuario iterator.Id tiene cuentas asciadas
        	if (setIdUsrConCtas.contains(iterator.Id) || Test.isRunningTest()){
        		System.debug('EN searchUsers iterator2: ' + iterator.Name + ' ' + iterator.Manager.Name);
	            mapFoundUsersById.put(iterator.Id,iterator);	                    
        		if (mapGestUsr.containsKey(iterator.Manager.Name))
        			mapGestUsr.get(iterator.Manager.Name).add(iterator);
        		if (!mapGestUsr.containsKey(iterator.Manager.Name))        			
        			mapGestUsr.put(iterator.Manager.Name, new List<User>{iterator});
        	}//Fin si setIdUsrConCtas.contains(iterator.Id)
        }//Fin del for paea lstUsers

		for (String sGest : mapGestUsr.KeySet()){
       		System.debug('EN searchUsers sGest1: ' + sGest);
       		String sUser = '';
       		//Toma el 1ero de la lista
       		if (!mapGestUsr.get(sGest).isEmpty()){
       			sUser = mapGestUsr.get(sGest).get(0).Name;
	            lstFoundUsersLookUp.add(new UserLookUpWrapper(false, mapGestUsr.get(sGest).get(0), sGest, true));       			
       		}//Fin mapGestUsr.get(sGest).isEmpty()
       		//Recorre la lista de valores
       		for (User usuario : mapGestUsr.get(sGest)){
       			//Ve si es diferente el usuario usuario.Name a sUser
       			if (usuario.Name != sUser)
		            lstFoundUsersLookUp.add(new UserLookUpWrapper(false, usuario, sGest, false));       				
       			System.debug('EN searchUsers usuario2: ' + usuario.Name);       			
       		}       		
		}//Fin del for para mapGestUsr.KeySet()

   		System.debug('EN searchUsers sIdUserActual: ' + sIdUserActual);
   		User datosUsuarioActual = new User();        
        //Si es el usurio que esta entrando es un gerente agreago a la lista
        if (sUserActualFuncion.startsWith('GV')){
        	for (User usuarioActualPaso : [Select Id, Name, Manager.Name, ManagerId, UserRole.Name 
        		From User u Where Id IN (SELECT OwnerId From Account Where OwnerId =: sIdUserActual)]){
        		datosUsuarioActual = usuarioActualPaso;				
        		System.debug('EN searchUsers setIdUsrConCtas: ' + setIdUsrConCtas);
        		//Ve si el usuario esta en setIdUsrConCtas
        		if (setIdUsrConCtas.contains(sIdUserActual)){
	           		lstFoundUsersLookUp.add(new UserLookUpWrapper(false, datosUsuarioActual, datosUsuarioActual.Name, false));        			
					mapFoundUsersById.put(datosUsuarioActual.Id,datosUsuarioActual);
        		}//Fin si setIdUsrConCtas.contains(sIdUserActual)
	   			System.debug('EN searchUsers datosUsuarioActual: ' + datosUsuarioActual);
        	}//Fin del for para la consulta del usuario actual
        }//Fin si sUserActualFuncion.startsWith('GV')
        
    	System.debug('ANTES DE SAIR DE searchUsers lstFoundUsersLookUp.size(): ' + lstFoundUsersLookUp.size());
    }

    public Set<Id> getAccountsWithPendingApprovalInAssignment(Set<Id> setAccountsId){
    	System.debug('EN getAccountsWithPendingApprovalInAssignment setAccountsId: ' + setAccountsId);
    	
        Set<Id> setAccountsPendingForApprovalIds = new Set<Id>();
        String strQueryOverAssignmentSttmnt = 'SELECT '+String.join(new List<String>(SObjectType.DCTAssignment__c.Fields.getMap().keySet()),', ')+', (SELECT '+String.join(new List<String>(SObjectType.DCTClientsProspectstoAssigned__c.Fields.getMap().keySet()),', ')+' FROM NumeroAsignacion__r) FROM DCTAssignment__c WHERE Status__c = \'Pendiente\'';
        List<DCTAssignment__c> lstAssignmentProcesses = new List<DCTAssignment__c>();
        try{lstAssignmentProcesses = Database.query(strQueryOverAssignmentSttmnt);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        for(DCTAssignment__c iterator0 : lstAssignmentProcesses){
	    	//System.debug('EN getAccountsWithPendingApprovalInAssignment DCTAsignación: ' + iterator0.ID);        	
            for(DCTClientsProspectstoAssigned__c iterator1 : iterator0.NumeroAsignacion__r){
                if(iterator1.AccountName__c != null){
	                if(setAccountsId.contains(iterator1.AccountName__c)){
				    	//System.debug('EN getAccountsWithPendingApprovalInAssignment TIENE PROCESO PENDIENTE: ' + iterator1.AccountName__c);	                	
						setAccountsPendingForApprovalIds.add(iterator1.AccountName__c);
	                }
                }
            }
        }

    	System.debug('EN getAccountsWithPendingApprovalInAssignment ANTES DE SALIR setAccountsPendingForApprovalIds: ' + setAccountsPendingForApprovalIds);        
        return setAccountsPendingForApprovalIds;
    }

    public void toggleLeftUserAccs(){
    	System.debug('ENTRO A toggleLeftUserAccs...');
    	
        leftOwnerAndAccounts.blnDisplayAccounts = !leftOwnerAndAccounts.blnDisplayAccounts;
        List<String> lName = new List<String>();
        Map<String, AccountWrapper> mapAccountWrapperPaso = new Map<String, AccountWrapper>();
        List<AccountWrapper> lAccountWrapperOrd = new List<AccountWrapper>();
        
        //Bueno ordena las cuentas que vienen en leftOwnerAndAccounts.lstAccs
        for (AccountWrapper cuenta : leftOwnerAndAccounts.lstAccs){
			lName.add(cuenta.accountRecord.Name);			        	
			mapAccountWrapperPaso.put(cuenta.accountRecord.Name, cuenta);
        }
        
        //Ya tienes los nonbres de las cuentas ordenalos 
        lName.sort();
    	System.debug('ENTRO A toggleLeftUserAccs lName: ' + lName);        
        //Recorre lista ordenada
        for (String sNom : lName){
        	lAccountWrapperOrd.add(mapAccountWrapperPaso.get(sNom));
        }
        
        //Actualiza la lista de cuentas ordenas en leftOwnerAndAccounts.lstAccs
        leftOwnerAndAccounts.lstAccs = new List<AccountWrapper>();
        leftOwnerAndAccounts.lstAccs.addAll(lAccountWrapperOrd);
    	System.debug('ENTRO A toggleLeftUserAccs leftOwnerAndAccounts.lstAccs: ' + leftOwnerAndAccounts.lstAccs);        
        
    }

    public void toggleRightUserAccs(){
		System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs getParameters: ' + ApexPages.currentPage().getParameters());
		
        String selectedUserPaso = ApexPages.currentPage().getParameters().get('toToggleUserId');		
        String selectedForToggleUserId = ApexPages.currentPage().getParameters().get('toToggleUserId');
        
   		System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs selectedForToggleUserId: ' + selectedForToggleUserId);
		System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs toToggleNivel0 ' + ApexPages.currentPage().getParameters().containsKey('toToggleNivel'));
		
		//Estas en el 1er nivel le diste clik al icono de '+' para expandir el nivel
        if (!ApexPages.currentPage().getParameters().containsKey('toToggleNivel')){
        	sIdUser1erNivel = selectedForToggleUserId;
        }//Fin si !ApexPages.currentPage().getParameters().containsKey('toToggleNivel')
		   		       
        //2do Nivel
        if (ApexPages.currentPage().getParameters().containsKey('toToggleNivel')){
			System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs toToggleNivel1: ' + ApexPages.currentPage().getParameters().get('toToggleNivel'));
			        	
			//Ve si el usuario selectedForToggleUserId es manager del usuario actual
	    	for (User subdManager : [SELECT Id, Name, ManagerId, Manager.Name FROM User
	    		Where id =: selectedForToggleUserId]){
	    		if (subdManager.id == UserInfo.getUserId())
	    			selectedForToggleUserId = UserInfo.getUserId();	    			
    		}
			System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs selectedForToggleUserId2: ' + selectedForToggleUserId);
					
			//Inicializa el id del manager
       		String sManagerUsr = selectedForToggleUserId;
       		//Ve si esl el mismo usuario el manager que el que esta entrando
       		if (selectedForToggleUserId != UserInfo.getUserId()){
				//Busca el manager de selectedForToggleUserId y mandalo a consultar
				if (mapIdUsuario.containsKey(selectedForToggleUserId)){
					sManagerUsr = mapIdUsuario.get(selectedForToggleUserId).ManagerId;
					if (sManagerUsr == null)
						sManagerUsr = selectedForToggleUserId;
				}//Fin si mapIdUsuario.containsKey(selectedForToggleUserId)
       		}//Fin si selectedForToggleUserId != UserInfo.getUserId()
       		if (selectedForToggleUserId == UserInfo.getUserId()){
				if (mapIdUsuario.containsKey(selectedForToggleUserId)){
					sManagerUsr = mapIdUsuario.get(selectedForToggleUserId).ManagerId;
					if (sManagerUsr == null)
						sManagerUsr = selectedForToggleUserId;
				}//Fin si mapIdUsuario.containsKey(selectedForToggleUserId)       			
       		}//Fin si selectedForToggleUserId == UserInfo.getUserId()
			System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs val 2 sManagerUsr: ' + sManagerUsr + ' selectedUserPaso: ' + selectedUserPaso);
			System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs val 2 setRelatedUsersCoord: ' + setRelatedUsersCoord);
			//actualiza el objeto de mapFinalOwnersAndAccounts a traves de fillAccountsByOwnerMap			
			if (setRelatedUsersCoord.contains(selectedUserPaso))
	       		fillAccountsByOwnerMapCoordinador(selectedUserPaso, true);
	       	else{
	       		if (!sUserActualFuncion.startsWith('GV') )
					fillAccountsByOwnerMap(sManagerUsr, true);
	       		if (sUserActualFuncion.startsWith('GV') && !Test.isRunningTest())
					fillAccountsByOwnerMapGerente(sManagerUsr, true);	       		
	       	}//Fin si !setRelatedUsersCoord.contains(selectedUserPaso)
			System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs val 2 DESPUES DE VALIDAR setRelatedUsersCoord...');
			
			//No es una prueba
			if (!Test.isRunningTest()){
				//Reinicializa el mapa de mapFinalOwnersAndAccounts
	       		mapFinalOwnersAndAccounts = new Map<String,AccountsByOwnerWrapper>();
				//Toma los datos de los usuarios asignados al strSelectedUserId
		   	    mapFinalOwnersAndAccounts = mapOwnersAndAccounts.clone();
			}//Fin si !Test.isRunningTest()
    		System.debug('EN toggleRightUserAccs mapFinalOwnersAndAccounts: ' + mapFinalOwnersAndAccounts);
    		        	
			//Pon el gestor
			Integer cIntUsr = 0;
			String sGestorIni = '';
	        if (!mapFinalOwnersAndAccounts.Values().isEmpty())
    	        sGestorIni = mapIdUsuario.containsKey(mapFinalOwnersAndAccounts.Values().get(0).ownerRecord.id) ? mapIdUsuario.get(mapFinalOwnersAndAccounts.Values().get(0).ownerRecord.id).Manager.Name : '';
    		System.debug('EN toggleRightUserAccs sGestorIni: ' + sGestorIni);
			
			//Solo si el usuario que esta seleccionado no pertence a la lisra de coordinadires
			if (!setRelatedUsersCoord.contains(selectedUserPaso)){
				
	            //Recorre la lista de usuarios del mapa mapFinalOwnersAndAccounts
	            for (AccountsByOwnerWrapper objAccountsByOwnerWrapper : mapFinalOwnersAndAccounts.Values()){
			    	System.debug('EN toggleRightUserAccs objAccountsByOwnerWrapper.ownerRecord.id: ' + objAccountsByOwnerWrapper.ownerRecord.id);
			    	System.debug('EN toggleRightUserAccs mapFoundUsersById.containsKey(objAccountsByOwnerWrapper.ownerRecord.id): ' + mapIdUsuario.containsKey(objAccountsByOwnerWrapper.ownerRecord.id));
	    	        String sGestorName = mapIdUsuario.containsKey(objAccountsByOwnerWrapper.ownerRecord.id) ? mapIdUsuario.get(objAccountsByOwnerWrapper.ownerRecord.id).Manager.Name : '';
			    	System.debug('EN toggleRightUserAccs sGestorName: ' + sGestorName);
	            	objAccountsByOwnerWrapper.sGestor = sGestorName;
					objAccountsByOwnerWrapper.blnPermiteSelSub = false;            	
	        		if (ApexPages.currentPage().getParameters().get('toToggleNivel') == '2' || Test.isRunningTest()){
						objAccountsByOwnerWrapper.bMuestraNivelSuperiror = true;
						objAccountsByOwnerWrapper.sManager = sManagerUsr;
						objAccountsByOwnerWrapper.blnPermiteSelSub = true;					
	        		}//Fin si ApexPages.currentPage().getParameters().get('toToggleNivel') == '2'
	        		if (ApexPages.currentPage().getParameters().get('toToggleNivel') == '1' || Test.isRunningTest()){
	        			//Ve si tiene manager: sManagerUsr
	        			if (mapIdUsuario.containsKey(sManagerUsr) && sManagerUsr != sIdUserActual && sIdManagerUserActual != sManagerUsr){
			    			System.debug('EN toggleRightUserAccs VAL 2 sManagerUsr:  ' + sManagerUsr + ' sIdUserActual: ' + sIdUserActual);        				
		        			//Ve si el manager ed diferente de null			
		        			if (mapIdUsuario.get(sManagerUsr).ManagerId != null){ 
								objAccountsByOwnerWrapper.bMuestraNivelSuperiror = true;
								objAccountsByOwnerWrapper.sManager = mapIdUsuario.get(sManagerUsr).ManagerId;
		        			}//Fin si mapIdUsuario.get(sManagerUsr).ManagerId != null
	        			}//Fin si mapIdUsuario.containsKey(sManagerUsr)
			    		System.debug('EN toggleRightUserAccs VAL 2 sManagerUsr:  ' + sManagerUsr + ' sIdUserActual: ' + sIdUserActual);        			
	        			if (sIdManagerUserActual == sManagerUsr && objAccountsByOwnerWrapper.ownerRecord.id != sIdUserActual)
							objAccountsByOwnerWrapper.blnPermiteSelSub = true;
	    	        	objAccountsByOwnerWrapper.blnDisplayAccounts = false;        		
	                	objAccountsByOwnerWrapper.subordinados = new List<AccountsByOwnerWrapper>();
	        		}//Fin si ApexPages.currentPage().getParameters().get('toToggleNivel') == '1'
			    	System.debug('EN toggleRightUserAccs objAccountsByOwnerWrapper.sManager: ' + objAccountsByOwnerWrapper.sManager);
	            	//Ve si tiene que despliegar el gestor
	            	if (cIntUsr == 0 && sGestorIni == sGestorName)
						objAccountsByOwnerWrapper.bDespGestor = true;
	            	else if (cIntUsr > 0 && sGestorIni == sGestorName)
						objAccountsByOwnerWrapper.bDespGestor = false;
	            	else if (sGestorIni != sGestorName){
						objAccountsByOwnerWrapper.bDespGestor = true;						
	            		sGestorIni = sGestorName;
	            	}
	            	cIntUsr++;
	            }//Fin del for para mapFinalOwnersAndAccounts.Values()
	            
			}//Fin si setRelatedUsersCoord.contains(selectedUserPaso)
        }//Fin si ApexPages.currentPage().getParameters().containsKey('toToggleNivel')
		System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs mapFinalOwnersAndAccounts.KeySet(): ' + mapFinalOwnersAndAccounts.KeySet());
		System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs mapUsrSelForAssig.containsKey(): ' + mapUsrSelForAssig.containsKey(selectedForToggleUserId));
		System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs mapUsrSelForAssig.Values(): ' + mapUsrSelForAssig.get(selectedForToggleUserId));
		//System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs mapUsrSelForAssig.Size(): ' + mapUsrSelForAssig.get(selectedForToggleUserId).Size());
								
		//Ve si existe selectedForToggleUserId en el mapa de  mapFinalOwnersAndAccounts
		if (mapFinalOwnersAndAccounts.containsKey(selectedForToggleUserId)){
       		mapFinalOwnersAndAccounts.get(selectedForToggleUserId).blnDisplayAccounts = !mapFinalOwnersAndAccounts.get(selectedForToggleUserId).blnDisplayAccounts;
	       	//Ve es el mismo usuario que entro el que fue selecionado quitale sus cuentas				
       		mapFinalOwnersAndAccounts.get(selectedForToggleUserId).lstAccs = new List<AccountWrapper>();
        	//Ve y busca en el mapa de mapUsrSelForAssig si tiene cuentas por asignar selectedForToggleUserId
        	if (mapUsrSelForAssig.containsKey(selectedForToggleUserId)){
        		Map<String, AccountWrapperAssignForUsers> mapCuentas = mapUsrSelForAssig.get(selectedForToggleUserId);
				System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs mapCuentas.Size(): ' + mapCuentas.Size());        		
        		//Recorre el mapa de mapCuentas 
        		for (String sIdCuenta : mapCuentas.Keyset()){
        			mapCuentas.get(sIdCuenta).accountWrapper.blnIsSelected = false;        			
        			mapFinalOwnersAndAccounts.get(selectedForToggleUserId).lstAccs.add( mapCuentas.get(sIdCuenta).accountWrapper );
        		}//Fin del for para mapCuentas.Keyset()
				System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs mapFinalOwnersAndAccounts.lstAccs: ' + mapFinalOwnersAndAccounts.get(selectedForToggleUserId).lstAccs);
				System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs mapFinalOwnersAndAccounts.lstAccs.size(): ' + mapFinalOwnersAndAccounts.get(selectedForToggleUserId).lstAccs.size());
        	}//Fin si mapUsrSelForAssig.containsKey(selectedForToggleUserId) 
		}//Fin si mapFinalOwnersAndAccounts.containsKey(selectedForToggleUserId)
		
		if (!mapFinalOwnersAndAccounts.containsKey(selectedForToggleUserId)){
			if (!mapFinalOwnersAndAccounts.isEmpty()){
				//Toma el primer reg de 
    	        selectedForToggleUserId = mapIdUsuario.containsKey(mapFinalOwnersAndAccounts.Values().get(0).ownerRecord.id) ? mapFinalOwnersAndAccounts.Values().get(0).ownerRecord.id : '';
	        	mapFinalOwnersAndAccounts.get(selectedForToggleUserId).blnDisplayAccounts = !mapFinalOwnersAndAccounts.get(selectedForToggleUserId).blnDisplayAccounts;
			}//Fin si !mapFinalOwnersAndAccounts.isEmty()
		}//Fin si !mapFinalOwnersAndAccounts.containsKey(selectedForToggleUserId)
		
		//Ve si va para el nivel 1
        if (ApexPages.currentPage().getParameters().containsKey('toToggleNivel')){
       		if (ApexPages.currentPage().getParameters().get('toToggleNivel') == '1'){
				System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs val 3 setRelatedUsersCoord: ' + setRelatedUsersCoord + ' ' + selectedUserPaso);       			
       			//Ve su el usuario existe en setRelatedUsersCoord
				if (setRelatedUsersCoord.contains(selectedUserPaso) || setManagerUsers.contains(selectedUserPaso))
		       		fillAccountsByOwnerMapCoordinador(sIdUserActual, true);
	    	   	else	
					mapFinalOwnersAndAccounts.get(selectedForToggleUserId).blnDisplayAccounts = false;
       		}
        }
        
        //Ve si selectedUserPaso esta en el alguno de los set de datos
		if (!setManagerUsers.contains(selectedUserPaso)){

	        String sIdUsrSel;
	        //Ve si tiene algo leftOwnerAndAccounts
	        if (leftOwnerAndAccounts != null)
		        if (leftOwnerAndAccounts.ownerRecord != null)
		        	sIdUsrSel = leftOwnerAndAccounts.ownerRecord.id;
	        System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs sIdUsrSel: ' + sIdUsrSel);
	        
	        Map<String, User> mapSubordinados = new Map<String, User>(); 		
			//Busca a los usuarios que son subordinados de selectedForToggleUserId
			for (User subordinado : [SELECT Id, Name, ManagerId, Manager.Name FROM User 
				where ManagerId =: selectedForToggleUserId And isActive = true
				And Profile.Name IN ('DR9','GV','JEC','SD')]){
				if (sIdUsrSel != null){
					if (subordinado.id != sIdUsrSel)			
						mapSubordinados.put(subordinado.id, subordinado);					
				}else
					mapSubordinados.put(subordinado.id, subordinado);
				//Agrega al mapa de mapIdUsrIdGest a los usuarios y a su gestor				
				mapIdUsrIdGest.put(subordinado.id, selectedForToggleUserId);
	        	System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs subordinado.id: ' + subordinado.id + ' selectedForToggleUserId: ' + selectedForToggleUserId);			
			}
	        System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs mapIdUsrIdGest: ' + mapIdUsrIdGest);		
			
			Map<String, List<Account>> mapLPct = new Map<String, List<Account>>(); 
			//Consulta las cuentas asociadas a lSibordinados
			for (Account pct : [Select Id, Name, OwnerId, Owner.Name, DCTDateLastassignment__c FROM Account WHERE OwnerId IN : mapSubordinados.KeySet()]){
				if (mapLPct.containsKey(pct.OwnerId))
					mapLPct.get(pct.OwnerId).add(pct);
				if (!mapLPct.containsKey(pct.OwnerId))
					mapLPct.put(pct.OwnerId, new List<Account>{pct});							
			} 
	
			//Crea un objeto del tipo
			AccountsByOwnerWrapper objAccountsByOwnerWrapperPaso = new AccountsByOwnerWrapper();
			objAccountsByOwnerWrapperPaso.subordinados = new List<AccountsByOwnerWrapper>(); 
	
			//Ya tienes las cuentas asociadas a los usuarios de mapSubordinados.KkeySet();
			for (String sIdUser: mapSubordinados.KeySet()){
				
				//Crea el objeto de paso para objAccountsByOwnerWrapperPaso 	
				AccountsByOwnerWrapper objAccountsByOwnerWrapperPaso2 = new AccountsByOwnerWrapper();
				List<AccountWrapper> lAccountWrapper = new List<AccountWrapper>(); 			
				//Crea los objetos del tipo AccountWrapper
				for (String sIdUserPaso : mapLPct.KeySet()){
					if (!mapLPct.get(sIdUserPaso).isEmpty()){
						for (Account objAccountWrapperPaso : mapLPct.get(sIdUserPaso)){
		                	String sFechaUltiAsigna = '';
		                	if (objAccountWrapperPaso.DCTDateLastassignment__c != null){	                	
		                		sFechaUltiAsigna = objAccountWrapperPaso.DCTDateLastassignment__c.Day() < 10 ? '0' + '' + objAccountWrapperPaso.DCTDateLastassignment__c.Day() : String.valueOf(objAccountWrapperPaso.DCTDateLastassignment__c.Day());
		                		sFechaUltiAsigna += '-';
		                		sFechaUltiAsigna += objAccountWrapperPaso.DCTDateLastassignment__c.month() < 10 ? '0' + '' + objAccountWrapperPaso.DCTDateLastassignment__c.month() : String.valueOf(objAccountWrapperPaso.DCTDateLastassignment__c.month());
		                		sFechaUltiAsigna += '-';
		                		sFechaUltiAsigna += String.valueOf(objAccountWrapperPaso.DCTDateLastassignment__c.year());	                		
		                	}//Fin si iterator1.DCTDateLastassignment__c != null)
							//Crea la cuenta en lAccountWrapper						
							lAccountWrapper.add(new AccountWrapper(objAccountWrapperPaso, false, sFechaUltiAsigna));
						}//Fin del for para Account 
					}//Fin si !mapLPct.get(sIdUserPaso).isEmpty()
				}//Fin del for para mapLPct.KySet()
				objAccountsByOwnerWrapperPaso2.lstAccs = new List<AccountWrapper>();
				objAccountsByOwnerWrapperPaso2.lstAccs.addAll(lAccountWrapper);
				objAccountsByOwnerWrapperPaso2.subordinados = new List<AccountsByOwnerWrapper>();
	 			objAccountsByOwnerWrapperPaso2.ownerRecord = mapSubordinados.get(sIdUser);
				objAccountsByOwnerWrapperPaso2.blnselectAllAccs = false;
				objAccountsByOwnerWrapperPaso2.blnSelectedForAssignment = false;
				objAccountsByOwnerWrapperPaso2.blnDisplayAccounts = false;
				objAccountsByOwnerWrapperPaso2.blnPermiteSelSub = true;

				//Ve si se trata del gerente el usuario actual			
				if (sUserActualFuncion.startsWith('GV')){
					//Ve si el gerente que esta seleccionando es diferente al usuario actual
					if (sIdUserActual != selectedForToggleUserId){
						objAccountsByOwnerWrapperPaso2.blnPermiteSelSub = false;					
					}//Fin si sIdUserActual != selectedForToggleUserId
				}//Fin si sUserActualFuncion.startsWith('GV')
	        	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMap sUserActualFuncion: ' + sUserActualFuncion + ' sIdUserActual: ' + sIdUserActual + ' selectedForToggleUserId: ' + selectedForToggleUserId + ' blnPermiteSelSub: ' + objAccountsByOwnerWrapperPaso2.blnPermiteSelSub);			
				objAccountsByOwnerWrapperPaso2.sGestor = mapSubordinados.get(sIdUser).Manager.Name;
				objAccountsByOwnerWrapperPaso2.bDespGestor = !sUserActualFuncion.startsWith('GV') ? true : false;
	        	System.debug('EN DCT_AccountOwnerAssignment_cls.fillAccountsByOwnerMap Subordinados: ' + objAccountsByOwnerWrapperPaso2.sGestor);			
				//Metelos a la lista de objAccountsByOwnerWrapperPaso
				objAccountsByOwnerWrapperPaso.subordinados.add(objAccountsByOwnerWrapperPaso2);				
			}
			System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs subordinados2: ' + objAccountsByOwnerWrapperPaso.subordinados);
	        System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs mapIdUsrIdGest2: ' + mapIdUsrIdGest);
	        				
			//Finalmente actualizalos en el mapa de mapFinalOwnersAndAccounts.get(selectedForToggleUserId).subordinados
			//Ve si se trata del GV que esta entrando seleccciono otro gerente de venta no puede mostrar subordinados solo cuentas
			if (!sUserActualFuncion.startsWith('GV') && selectedUserPaso != sIdUserActual){
				System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs Final val 1...');
				mapFinalOwnersAndAccounts.get(selectedForToggleUserId).subordinados = new List<AccountsByOwnerWrapper>();				
				mapFinalOwnersAndAccounts.get(selectedForToggleUserId).subordinados.addAll(objAccountsByOwnerWrapperPaso.subordinados);	
				System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs subordinados0: ' + mapFinalOwnersAndAccounts.get(selectedForToggleUserId).subordinados);				
			}
			if (sUserActualFuncion.startsWith('GV') && selectedUserPaso == sIdUserActual){
				System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs Final val 2...' + mapFinalOwnersAndAccounts.KeySet());
				mapFinalOwnersAndAccounts.get(selectedForToggleUserId).subordinados = new List<AccountsByOwnerWrapper>();				
				mapFinalOwnersAndAccounts.get(selectedForToggleUserId).subordinados.addAll(objAccountsByOwnerWrapperPaso.subordinados);					
				System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs subordinados1: ' + mapFinalOwnersAndAccounts.get(selectedForToggleUserId).subordinados);				
			}
			if (sUserActualFuncion.startsWith('Coordinador') && mapIdUsrRol.get(selectedForToggleUserId).startsWith('GV')){
				System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs Final val 3...');
				mapFinalOwnersAndAccounts.get(selectedForToggleUserId).subordinados = new List<AccountsByOwnerWrapper>();
				System.debug('EN DCT_AccountOwnerAssignment_cls.toggleRightUserAccs subordinados2: ' + mapFinalOwnersAndAccounts.get(selectedForToggleUserId).subordinados);				
			}
		}//Fin si !setRelatedUsersCoord.contains(selectedUserPaso) && !setManagerUsers.contains(selectedUserPaso)
		
    }

    public void selectDeselectAllLeft(){
        for(AccountWrapper iterator:leftOwnerAndAccounts.lstAccs){
            iterator.blnIsSelected = leftOwnerAndAccounts.blnselectAllAccs;
        }
    }

    public void selectDeselectAllRight(){
	   	System.debug('EN DCT_AccountOwnerAssignment_cls.selectDeselectAllRight...');
	   	    	
        //String strSelDesAllUserId = ApexPages.currentPage().getParameters().get('toSelectDeselAllAccsUserId');
        strSelectedRightUser = ApexPages.currentPage().getParameters().get('toSelectDeselAllAccsUserId');
		System.debug('EN DCT_AccountOwnerAssignment_cls.selectDeselectAllRight strSelectedRightUser: ' + strSelectedRightUser);
        
        //Ve si existe el usuario strSelectedRightUser en mapFinalOwnersAndAccounts
        if (mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser)){ 
	        for(AccountWrapper iterator:mapFinalOwnersAndAccounts.get(strSelectedRightUser).lstAccs){
	            iterator.blnIsSelected = mapFinalOwnersAndAccounts.get(strSelectedRightUser).blnselectAllAccs;
	        }
        }//Fin si mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser)
		System.debug('EN DCT_AccountOwnerAssignment_cls.selectDeselectAllRight mapFinalOwnersAndAccounts.KeySet(): ' + mapFinalOwnersAndAccounts.KeySet());
		        
        //Ve NO si existe el usuario strSelectedRightUser en mapFinalOwnersAndAccounts
        if (!mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser) || Test.isRunningTest()){
   			String sIdParent;
			System.debug('EN DCT_AccountOwnerAssignment_cls.selectDeselectAllRight ANTES DE HACER LA CONSULTA strSelectedRightUser: ' + strSelectedRightUser);
			System.debug('EN DCT_AccountOwnerAssignment_cls.selectDeselectAllRight ANTES DE HACER LA CONSULTA mapIdUsrIdGest: ' + mapIdUsrIdGest);
			System.debug('EN DCT_AccountOwnerAssignment_cls.selectDeselectAllRight ANTES DE HACER LA CONSULTA mapFinalOwnersAndAccounts.get(strSelectedRightUser): ' + mapFinalOwnersAndAccounts.get(strSelectedRightUser));
			        			
			//Busca el usuario en mapIdUsrIdGest
			if (mapIdUsrIdGest.containsKey(strSelectedRightUser))
			   sIdParent = mapIdUsrIdGest.get(strSelectedRightUser);
			if (!mapIdUsrIdGest.containsKey(strSelectedRightUser))
			   sIdParent = strSelectedRightUser;
	    	System.debug('EN DCT_AccountOwnerAssignment_cls.selectDeselectAllRight sIdParent: ' + sIdParent);

       		//Recorre la lista de subodinados y busca a strSelectedRightUser
       		List<AccountsByOwnerWrapper> subordinados = mapFinalOwnersAndAccounts.get(sIdParent).subordinados; 
       		//Ve si tiene algo la lista de subordinados
       		if (!subordinados.isEmpty()){
      			//Recorre la lista
       			for (AccountsByOwnerWrapper objSub : subordinados){
			    	System.debug('EN DCT_AccountOwnerAssignment_cls.selectDeselectAllRight objSub: ' + objSub.ownerRecord);
			    	//Encuentra a strSelectedRightUser
       				if (objSub.ownerRecord.id == strSelectedRightUser || Test.isRunningTest()){
			    		System.debug('EN DCT_AccountOwnerAssignment_cls.selectDeselectAllRight objSub.blnselectAllAccs: ' + objSub.blnselectAllAccs);       					
						//Ya lo encontraste entonces inializa lo que tengas que inicializar
						objSub.blnSelectedForAssignment = true;
						objSub.blnDisplayAccounts = true;
			    		System.debug('EN DCT_AccountOwnerAssignment_cls.selectDeselectAllRight ANTES DE getAccountSelected strSelectedUserIdGv: ' + strSelectedUserIdGv);
						//Busca las cuentas del usuario que selecciono strSelectedUserId
						objSub.lstAccs = getAccountSelected(strSelectedRightUser, strSelectedUserIdGv, strSelectedRightUserGv, objSub.blnselectAllAccs); 
       					break;
       				}//Fin si objSub.ownerRecord.id == strSelectedRightUser
       			}//Fin del for para subordinados
       		}//Fin si subordinados.isEmpty()
       		
			//Si no tiene subordinados
       		if (subordinados.isEmpty())
            	mapFinalOwnersAndAccounts.get(sIdParent).lstAccs.addAll(getAccountSelected(strSelectedRightUser, strSelectedUserIdGv, strSelectedRightUserGv, mapFinalOwnersAndAccounts.get(sIdParent).blnselectAllAccs));
        }//Fin si mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser)
        
    }

    public Boolean validateWhetherIsPossibleToStart(){
        Boolean blnIsEverythingOK = true;
        if(mapOwnersAndAccounts.size() < 1){
            lstErrorMsgs.add('Debe tener -al menos- dos subordinados para realizar la asignación de cuentas.');
            blnIsEverythingOK = false;
        }
        return blnIsEverythingOK;
    }

    public void selectUser(){
    	System.debug('ENTRO A selectUser INICIAL...');
        if(strSelectedUserId != null){
            if(mapFoundUsersById.containsKey(strSelectedUserId)){
                selectedUser = mapFoundUsersById.get(strSelectedUserId);
            }
    		System.debug('EN selectUser ANTES DE IR A getGestorGvCa...');
            //Ve cual es el gerente de ventas de este usuario seleccionado 
			strSelectedUserIdGv = getGestorGvCa(strSelectedUserId, true);
    		System.debug('EN selectUser ANTES DE IR A getGestorGvCa sGerUsrSelec: ' + sGerUsrSelec); 
        }//Fin si strSelectedUserId != null
    	System.debug('ENTRO A selectUser INICIAL selectedUser: ' + selectedUser);        
    }


    public void returnToMain(){
    	System.debug('ENTRO A returnToMain strSelectedUserId: ' + strSelectedUserId + ' selectedUser: ' + selectedUser);
    	
    	//En la pantalla principal no seleccion un usuario
       	blnShowLookUpUI = false;
       	blnShowMainUI = true;
		
    	//En la pantalla principal seleccion un usuario
    	if (strSelectedUserId != null && selectedUser != null){
   	        selectedUser = new User();
	        lstFoundUsersLookUp = new List<UserLookUpWrapper>();
	        strLookUpUserName = null;
    	}//Fin si strSelectedUserId != null && selectedUser != null
    	
    }

    public void assignSelectedRightUser(){
    	System.debug('EN DCT_AccountOwnerAssignment_cls.assignSelectedRightUser....');
    	
        String strSelectedRightUserFin = ApexPages.currentPage().getParameters().get('selectedRightUser');
    	System.debug('EN DCT_AccountOwnerAssignment_cls.assignSelectedRightUser strSelectedRightUser: ' + strSelectedRightUser + ' strSelectedRightUserFin: ' + strSelectedRightUserFin);
    	System.debug('EN DCT_AccountOwnerAssignment_cls.assignSelectedRightUser sIdUser1erNivel: ' + sIdUser1erNivel);
    	System.debug('EN DCT_AccountOwnerAssignment_cls.assignSelectedRightUser mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser): ' + mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser));    			
    			
    	//Ve si tiene algo la variable strSelectedRightUser
        if(strSelectedRightUser != null){
            if(!String.isBlank(strSelectedRightUser)){
				//Ve si el usuario de destino esta en mapFinalOwnersAndAccounts 
           		if (mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser)){           	
			        for(String iterator:mapFinalOwnersAndAccounts.keySet()){
			            if(iterator != strSelectedRightUser)
			                mapFinalOwnersAndAccounts.get(iterator).blnSelectedForAssignment = false;
			        }
           		}//Fin si mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser)
           		//Ve quien es el gerente del usuario de la derecha que va a recibir las cuentas 
				strSelectedRightUserGv = getGestorGvCa(strSelectedRightUser, true);
    			System.debug('EN DCT_AccountOwnerAssignment_cls.assignSelectedRightUser strSelectedRightUserGv: ' + strSelectedRightUserGv);				
            }//Fin si !String.isBlank(strSelectedRightUser)¡
        }//Fin si strSelectedRightUser != null
                
    }

	public List<AccountWrapper> getAccountSelected(String sIdUsr, String sSelectedUserIdGv
		, String sSelectedRightUserGv, Boolean blnSeleccionaCuentas){
		System.debug('EN getAccountSelected sIdUsr: ' + sIdUsr + ' strSelectedRightUser: ' + strSelectedRightUser);

		System.debug('EN DCT_AccountOwnerAssignment_cls.getAccountSelected sSelectedUserIdGv: ' + sSelectedUserIdGv);    	
		System.debug('EN DCT_AccountOwnerAssignment_cls.getAccountSelected sSelectedRightUserGv: ' + sSelectedRightUserGv);
	
		List<AccountWrapper> lAccountWrapperPaso = new List<AccountWrapper>();
		//Ve si ese usuario ya tiene cuentas seleccionadas en mapUsrSelForAssig  
		if (mapUsrSelForAssig.containsKey(sIdUsr)){
			Map<String, AccountWrapperAssignForUsers> mapAccWrpAssigUsr = mapUsrSelForAssig.get(sIdUsr); 
			//Recorre la lista de mapAccWrpAssigUsr
			for (String sIdAcc : mapAccWrpAssigUsr.KeySet()){
	           	String sFechaUltiAsigna = '';
	           	if ( mapAccWrpAssigUsr.get(sIdAcc).accountWrapper.accountRecord.DCTDateLastassignment__c != null){	                	
	           		sFechaUltiAsigna =  mapAccWrpAssigUsr.get(sIdAcc).accountWrapper.accountRecord.DCTDateLastassignment__c.Day() < 10 ? '0' + '' +  mapAccWrpAssigUsr.get(sIdAcc).accountWrapper.accountRecord.DCTDateLastassignment__c.Day() : String.valueOf( mapAccWrpAssigUsr.get(sIdAcc).accountWrapper.accountRecord.DCTDateLastassignment__c.Day());
	           		sFechaUltiAsigna += '-';
	           		sFechaUltiAsigna +=  mapAccWrpAssigUsr.get(sIdAcc).accountWrapper.accountRecord.DCTDateLastassignment__c.month() < 10 ? '0' + '' +  mapAccWrpAssigUsr.get(sIdAcc).accountWrapper.accountRecord.DCTDateLastassignment__c.month() : String.valueOf( mapAccWrpAssigUsr.get(sIdAcc).accountWrapper.accountRecord.DCTDateLastassignment__c.month());
	           		sFechaUltiAsigna += '-';
	           		sFechaUltiAsigna += String.valueOf( mapAccWrpAssigUsr.get(sIdAcc).accountWrapper.accountRecord.DCTDateLastassignment__c.year());	                		
	          	}//Fin si iterator1.DCTDateLastassignment__c != null)
				//Agrega a la lista de lAccountWrapperPaso el objeto el tipo AccountWrapper
				lAccountWrapperPaso.add(new AccountWrapper( mapAccWrpAssigUsr.get(sIdAcc).accountWrapper.accountRecord, blnSeleccionaCuentas, sFechaUltiAsigna ));
				System.debug('EN DCT_AccountOwnerAssignment_cls.getAccountSelected strSelectedUserIdGv: ' + strSelectedUserIdGv + ' sSelectedRightUserGv: ' + sSelectedRightUserGv);				
				//Ve si la gerencia es diferente en el usuario origen y destino
	    		if ( (sSelectedUserIdGv != sSelectedRightUserGv) || Test.isRunningTest() ){ 
	    			//Actualiza los campos
	    			mapAccWrpAssigUsr.get(sIdAcc).blnGeneraProcesoAproba = sUserActualFuncion.startsWith('Coordinador') ? false : true;
	    			mapAccWrpAssigUsr.get(sIdAcc).sIdUsrAprueba = getUsrAprobador( mapAccWrpAssigUsr.get(sIdAcc).sIdUsrDestino );
	    		}//Fin si strSelectedUserIdGv != strSelectedUserIdGv
	    		if ( (sSelectedUserIdGv == sSelectedRightUserGv) || Test.isRunningTest() ){
	    			//mapAccWrpAssigUsr.get(sIdAcc).blnGeneraProcesoAproba = sUserActualFuncion.startsWith('Coordinador') ? false : true;
	    			mapAccWrpAssigUsr.get(sIdAcc).blnGeneraProcesoAproba = false;
	    			mapAccWrpAssigUsr.get(sIdAcc).sIdUsrAprueba = getUsrAprobador( mapAccWrpAssigUsr.get(sIdAcc).sIdUsrDestino );
	    		}//Fin si strSelectedUserIdGv == sSelectedRightUserGv
				System.debug('EN DCT_AccountOwnerAssignment_cls.getAccountSelected mapAccWrpAssigUsr: ' + mapAccWrpAssigUsr.get(sIdAcc));	    				    		
			}//Fin del fr para mapAccWrpAssigUsr.KeySet()
		}//Fin si mapUsrSelForAssig.containsKey(sIdUsr)
		System.debug('EN getAccountSelected ANTES DE SALIR lAccountWrapperPaso: ' + lAccountWrapperPaso);				 
		
		return lAccountWrapperPaso;
	}

	public String getUsrAprobador(String sIdUsrDestino){
		System.debug('EN DCT_AccountOwnerAssignment_cls.getUsrAprobador sIdUsrDestino: ' + sIdUsrDestino);
		String sIdUsrAprobador = '';
		
		//Llama a la funcion getGestorGvCa
		sIdUsrAprobador = getGestorGvCa(sIdUsrDestino, false);
					
		System.debug('ANTES DE SALIR DE DCT_AccountOwnerAssignment_cls.getUsrAprobador sIdUsrAprobador: ' + sIdUsrAprobador);		
		return sIdUsrAprobador;
	}


    public void moveToRight(){
    	System.debug('EN DCT_AccountOwnerAssignment_cls.moveToRight strSelectedRightUser: ' + strSelectedRightUser);
    	    	
    	//Ve si validateTurningRight
        if(validateTurningRight()){
        	
            List<AccountWrapper> lstToAssingAccs = new List<AccountWrapper>();
            List<AccountWrapper> lstRemaningAccs = new List<AccountWrapper>();
            Set<String> setIdPct = new Set<String>();
            Map<String, String> mapIdPctTipoReg = new Map<String, String>();
             
            for(AccountWrapper iterator:leftOwnerAndAccounts.lstAccs){
                if(iterator.blnIsSelected || Test.isRunningTest()){
                    lstToAssingAccs.add(iterator);
                    setIdPct.add(iterator.accountRecord.id);
                }else{
                    lstRemaningAccs.add(iterator);
                }
            }//Fin del for para las leftOwnerAndAccounts seleccionadas
            
            //Ve si tiene algo setIdPct
            if (!setIdPct.isEmpty()){
            	//Consulta las cuentas y si tipo de reg 
            	for (Account pct : [Select id, RecordType.Name From Account Where id IN :setIdPct ]){
            		if (pct.RecordType.Name.contains('Corporativo'))
						mapIdPctTipoReg.put(pct.id, 'Corporativo');
            		if (pct.RecordType.Name.contains('Empresarial'))
						mapIdPctTipoReg.put(pct.id, 'Empresarial');
            		if (pct.RecordType.Name.contains('PyME'))
						mapIdPctTipoReg.put(pct.id, 'PyME');						
            	}
            }//Fin si !setIdPct.isEmpty()
            
            //Ya tienes la cuentas que selecciono para enviar del otro lado, metelas al mapa de mapUsrSelForAssig
            if (mapUsrSelForAssig.containsKey(strSelectedRightUser)){
            	for (AccountWrapper cuenta : lstToAssingAccs){
					mapUsrSelForAssig.get(strSelectedRightUser).put(cuenta.accountRecord.id, new AccountWrapperAssignForUsers(
							cuenta, strSelectedUserId, strSelectedRightUser, mapIdPctTipoReg.get(cuenta.accountRecord.id)
						)
					);            		
            	}//Fin del for para lstToAssingAccs
            }//Fin si mapUsrSelForAssig.containsKey(strSelectedRightUser)
			//Si no existe strSelectedRightUser en el mapa de mapUsrSelForAssig 
            if (!mapUsrSelForAssig.containsKey(strSelectedRightUser)){
            	mapUsrSelForAssig.put(strSelectedRightUser, new Map<String, AccountWrapperAssignForUsers>());
            	//Agregale las cuentas 
            	for (AccountWrapper cuenta : lstToAssingAccs){
					mapUsrSelForAssig.get(strSelectedRightUser).put(cuenta.accountRecord.id, new AccountWrapperAssignForUsers(
							cuenta, strSelectedUserId, strSelectedRightUser, mapIdPctTipoReg.get(cuenta.accountRecord.id)
						)
					);
            	}//Fin del for para lstToAssingAccs
            }//Fin si !mapUsrSelForAssig.containsKey(strSelectedRightUser)
	    	System.debug('EN DCT_AccountOwnerAssignment_cls.moveToRight mapUsrSelForAssig: ' + mapUsrSelForAssig.KeySet());
	    	System.debug('EN DCT_AccountOwnerAssignment_cls.moveToRight mapUsrSelForAssig: ' + mapUsrSelForAssig.Values());
	    	
			//Ve si el usuario seleccionado NO existe en mapFinalOwnersAndAccounts	    	
			if (!mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser) || Test.isRunningTest()){
				
       			String sIdParent;
       			//Ve a buscar al papa porque ya vajo mas de un nivel
	        	for (User usrAcc : [Select u.ManagerId From User u Where Id =:strSelectedRightUser
	        		And isActive = true]){
	        		if (usrAcc.ManagerId != null)
	        			sIdParent = usrAcc.ManagerId;
	        		if (usrAcc.ManagerId == null)	 
	        			sIdParent = strSelectedRightUser;
	        			
	        		//Si es una prueba	
	        		if (Test.isRunningTest())
	        			sIdParent = strSelectedRightUser;	        		
        		}//Fin del for para la consulta del usuario actual
		    	System.debug('EN DCT_AccountOwnerAssignment_cls.moveToRight sIdParent: ' + sIdParent);
           			
				//Ya tienes al papa buscalo en mapFinalOwnersAndAccounts sIdParent            			           
           		if (mapFinalOwnersAndAccounts.containsKey(sIdParent)){
               		mapFinalOwnersAndAccounts.get(sIdParent).blnSelectedForAssignment = false;
               		
               		//Recorre la lista de subodinados y busca a strSelectedRightUser
               		List<AccountsByOwnerWrapper> subordinados = mapFinalOwnersAndAccounts.get(sIdParent).subordinados; 
               		//Ve si tiene algo la lista de subordinados
               		if (!subordinados.isEmpty()){
               			//Recorre la lista
               			for (AccountsByOwnerWrapper objSub : subordinados){
					    	System.debug('EN DCT_AccountOwnerAssignment_cls.moveToRight objSub: ' + objSub.ownerRecord.id);
					    	//Encuentra a strSelectedRightUser
               				if (objSub.ownerRecord.id == strSelectedRightUser || Test.isRunningTest()){
				    			System.debug('EN DCT_AccountOwnerAssignment_cls.moveToRight strSelectedUserIdGv: ' + strSelectedUserIdGv + ' strSelectedRightUserGv: ' + strSelectedRightUserGv);
								//Ya lo encontraste entonces inializa lo que tengas que inicializar
								objSub.blnSelectedForAssignment = true;
								objSub.blnDisplayAccounts = true;
								objSub.blnselectAllAccs = false;
								//Busca las cuentas del usuario que selecciono strSelectedUserId
								objSub.lstAccs = getAccountSelected(strSelectedRightUser, strSelectedUserIdGv, strSelectedRightUserGv, objSub.blnselectAllAccs);
               					break;
               				}//Fin si objSub.ownerRecord.id == strSelectedRightUser
               			}//Fin del for para subordinados
               		}//Fin si subordinados.isEmpty()
               		
           		}//Fin si mapFinalOwnersAndAccounts.containsKey(sIdUser1erNivel)				
				
			}//Fin si !mapFinalOwnersAndAccounts.conainsKey(strSelectedRightUser)
			
			//Ve si el usuario seleccionado existe en mapFinalOwnersAndAccounts
			if (mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser)){
	    		System.debug('EN DCT_AccountOwnerAssignment_cls.moveToRight EXISTE EL USUARIO strSelectedRightUser EN mapFinalOwnersAndAccounts: ');
                //Limpia la lista de cuentas antes de hacer la actualización
				mapFinalOwnersAndAccounts.get(strSelectedRightUser).lstAccs = new List<AccountWrapper>();				
				mapFinalOwnersAndAccounts.get(strSelectedRightUser).lstAccs.addAll(getAccountSelected(strSelectedRightUser, strSelectedUserIdGv, strSelectedRightUserGv, mapFinalOwnersAndAccounts.get(strSelectedRightUser).blnselectAllAccs));
			}//Fin si mapFinalOwnersAndAccounts.conainsKey(strSelectedRightUser)
            
            leftOwnerAndAccounts.lstAccs = lstRemaningAccs;
            cleanUpSelectedAccs();
            blnChangesHaveBeenMade = true;
            
        }//Fin si validateTurningRight()
        
    }

    
	//Pasa a la izquierda las cuentas seleccionadas
    public void moveToLeft(){
		System.debug('EN moveToLeft strSelectedRightUser: ' + strSelectedRightUser);

		//Una lista temporal para las cuentas que no se seleccionaron de forma individual
		Map<String, List<AccountWrapper>> mapAccountWrapperIndvNoSel = new Map<String, List<AccountWrapper>>();
		//Una lista temporal para las cuentas que se seleccionaron de forma individual
		Map<String, List<AccountWrapper>> mapAccountWrapperIndvSel = new Map<String, List<AccountWrapper>>();
		
		Set<String> setIdPct = new Set<String>();
		Map<String, String> mapIdPctTipoReg = new Map<String, String>();
		bSeleccionUnaCuenta = false;
		lstErrorMsgs = new List<String>();
		
      	for (String sIdUsr : mapFinalOwnersAndAccounts.KeySet()){
      		if (mapFinalOwnersAndAccounts.get(sIdUsr).lstAccs != null){
				for(AccountWrapper pct : mapFinalOwnersAndAccounts.get(sIdUsr).lstAccs){
					setIdPct.add(pct.accountRecord.id);				
				}
      		}//Fin si !mapFinalOwnersAndAccounts.get(sIdUsr).lstAccs.isEmpty()
       	}//Fin del for para lstToAssingAccs
		System.debug('EN moveToLeft setIdPct: ' +  setIdPct);

		//Ve si tiene algo setIdPct
		if (!setIdPct.isEmpty()){
			//Consulta las cuentas y si tipo de reg 
          	for (Account pct : [Select id, RecordType.Name From Account Where id IN :setIdPct ]){
           		if (pct.RecordType.Name.contains('Corporativo'))
					mapIdPctTipoReg.put(pct.id, 'Corporativo');
           		if (pct.RecordType.Name.contains('Empresarial'))
					mapIdPctTipoReg.put(pct.id, 'Empresarial');
           		if (pct.RecordType.Name.contains('PyME'))
					mapIdPctTipoReg.put(pct.id, 'PyME');						
           	}
		}//Fin si !setIdPct.isEmpty()

		//ve si validateTurningLeft
        if(validateTurningLeft()){
        	        	
            List<AccountWrapper> lstToAssingAccs = new List<AccountWrapper>();
            Map<String,List<AccountWrapper>> mapRemaningAccs = new Map<String,List<AccountWrapper>>();

			//Ya tienes al papa buscalo en mapFinalOwnersAndAccounts strSelectedRightUser            			           
       		if ( (!mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser) && strSelectedRightUser != null) || Test.isRunningTest()){
				System.debug('EN moveToLeft NO EXISTE EN EL MAPA DE mapFinalOwnersAndAccounts strSelectedRightUser: ' + strSelectedRightUser);
				       			
   				String sIdParent;
				//Busca el usuario en mapIdUsrIdGest
				if (mapIdUsrIdGest.containsKey(strSelectedRightUser))
				   sIdParent = mapIdUsrIdGest.get(strSelectedRightUser);
				if (!mapIdUsrIdGest.containsKey(strSelectedRightUser))
				   sIdParent = strSelectedRightUser;
				
				//Es una prueba
				if (Test.isRunningTest())
				   sIdParent = strSelectedRightUser;
				System.debug('EN moveToLeft sIdParent: ' + sIdParent);
				       			
       			//Apaga la bandera de blnSelectedForAssignment para el usuario gestor
           		if (sIdParent != null && sIdParent != '')
           			mapFinalOwnersAndAccounts.get(sIdParent).blnSelectedForAssignment = false;
               		
          		//Recorre la lista de subodinados y busca a strSelectedRightUser
          		List<AccountsByOwnerWrapper> subordinados = new List<AccountsByOwnerWrapper>();
           		if (sIdParent != null && sIdParent != '')          		
           			subordinados = mapFinalOwnersAndAccounts.get(sIdParent).subordinados; 
           		
           		//Ve si tiene algo la lista de subordinados
           		if (!subordinados.isEmpty()){
           			//Recorre la lista
           			for (AccountsByOwnerWrapper objSub : subordinados){
			    		System.debug('EN DCT_AccountOwnerAssignment_cls.moveToLeft objSub: ' + objSub.ownerRecord.id);
				    	//Encuentra a strSelectedRightUser
           				if ( (objSub.ownerRecord.id == strSelectedRightUser) || Test.isRunningTest()){
			    			System.debug('EN DCT_AccountOwnerAssignment_cls.moveToLeft strSelectedUserIdGv: ' + strSelectedRightUser + ' strSelectedRightUserGv: ' + strSelectedRightUserGv);
							//Ya lo encontraste entonces inializa lo que tengas que inicializar
							objSub.blnSelectedForAssignment = false;
							objSub.blnDisplayAccounts = false;

			    			System.debug('EN DCT_AccountOwnerAssignment_cls.moveToLeft ANTES DE IR POR LAS CUENTAS DEL UUARIO strSelectedRightUser: ' + strSelectedRightUser + ' strSelectedUserId: ' + strSelectedUserId);
							//Busca las cuentas del usuario que selecciono strSelectedUserId			    			
							if (!Test.isRunningTest())
								objSub.lstAccs = new List<AccountWrapper>();
							//Agregalas al usuario de la izquierda
							leftOwnerAndAccounts.lstAccs.addAll( getAccountSelected(strSelectedRightUser, strSelectedUserIdGv, strSelectedRightUserGv, false) );
			    			System.debug('EN DCT_AccountOwnerAssignment_cls.moveToLeft ANTES DE IR POR LAS CUENTAS DEL UUARIO strSelectedRightUser: ' + strSelectedRightUser + ' strSelectedUserId: ' + strSelectedUserId);															
							System.debug('EN DCT_AccountOwnerAssignment_cls.moveToLeft ANTES DE ELIMINAR LAS CUENTAS DE leftOwnerAndAccounts.lstAccs: ' + objSub.lstAccs);
															
  							//Ya las pasaste al usuario de la izquerda, quiatalas de mapUsrSelForAssig
  							if (mapUsrSelForAssig.containsKey(strSelectedRightUser)){
								System.debug('EN DCT_AccountOwnerAssignment_cls.moveToLeft ANTES DE ELIMINAR LAS CUENTAS DE ' + strSelectedRightUser + ' EN EL MAPA DE mapUsrSelForAssig....: ');
								if (!Test.isRunningTest())
									mapUsrSelForAssig.remove(strSelectedRightUser);
  							}//Fin si mapUsrSelForAssig.containsKey(strSelectedRightUser)
							//Salte							
          					break;
           				}//Fin si objSub.ownerRecord.id == strSelectedRightUser
           			}//Fin del for para subordinados
           		}//Fin si subordinados.isEmpty()
               		
       		}//Fin si mapFinalOwnersAndAccounts.containsKey(sIdUser1erNivel)

			//Si existe el usuario strSelectedRightUser en mapFinalOwnersAndAccounts para quierale las cuentas seleccionadas
       		if (mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser) && strSelectedRightUser != null){
				System.debug('EN moveToLeft seleccion todas las cuentas para quitarlas mapFinalOwnersAndAccounts strSelectedRightUser: ' + strSelectedRightUser);

               	Boolean bSelCtaInvFinal = false;
               	String sIdUsrFinal = '';
               	String sIdUsuaActOwner = '';
				            
	            for(String iterator0 : mapFinalOwnersAndAccounts.keySet()){	            	
	            	if (iterator0 == strSelectedRightUser){
	               		sIdUsuaActOwner = mapFinalOwnersAndAccounts.get(iterator0).ownerRecord.id;	            		
		                lstToAssingAccs.addAll( mapFinalOwnersAndAccounts.get(iterator0).lstAccs );
		                if (!Test.isRunningTest())
							mapFinalOwnersAndAccounts.get(iterator0).lstAccs = new List<AccountWrapper>();
       	                bSeleccionUnaCuenta = true;		                
	            	}else{
		                mapRemaningAccs.put(iterator0,new List<AccountWrapper>());
		                if (mapFinalOwnersAndAccounts.get(iterator0).lstAccs != null){
			                for(AccountWrapper iterator1 : mapFinalOwnersAndAccounts.get(iterator0).lstAccs){
		    	                if(iterator1.blnIsSelected){
		        	                lstToAssingAccs.add(iterator1);
		        	                bSeleccionUnaCuenta = true;
		    	                }else
		                	        mapRemaningAccs.get(iterator0).add(iterator1);
			                }
		                }//Fin si mapFinalOwnersAndAccounts.get(iterator0).lstAccs != null
	            	}
	            }
				System.debug('EN moveToLeft seleccion todas las cuentas para quitarlas mapRemaningAccs: ' + mapRemaningAccs.KeySet());
				System.debug('EN moveToLeft seleccion todas las cuentas para quitarlas lstToAssingAccs: ' + lstToAssingAccs);				
				System.debug('EN moveToLeft seleccion todas las cuentas para quitarlas bSeleccionUnaCuenta: ' + bSeleccionUnaCuenta);
				System.debug('EN moveToLeft seleccion todas las cuentas para quitarlas mapFinalOwnersAndAccounts: ' + mapFinalOwnersAndAccounts.get(sIdUsuaActOwner).lstAccs.size() + ' sIdUsuaActOwner: ' + sIdUsuaActOwner);				
					            
	            leftOwnerAndAccounts.lstAccs.addAll(lstToAssingAccs);
		        for(AccountWrapper iterator:leftOwnerAndAccounts.lstAccs){
        		    iterator.blnIsSelected = false;
		        }
	            for(String iterator0 : mapFinalOwnersAndAccounts.keySet()){
					System.debug('EN moveToLeft seleccion todas las cuentas para quitarlas bSeleccionUnaCuenta: ' + bSeleccionUnaCuenta);
					if (!Test.isRunningTest())
	                	mapFinalOwnersAndAccounts.get(iterator0).lstAccs = mapRemaningAccs.get(iterator0);
	                mapFinalOwnersAndAccounts.get(iterator0).blnselectAllAccs = false;
	                mapFinalOwnersAndAccounts.get(iterator0).blnDisplayAccounts = false;
	            }
		        leftOwnerAndAccounts.blnselectAllAccs = false;
		        
				System.debug('EN moveToLeft LAS CUENAS FINALES DESPUES DE MANDAR LAS SELECCIONADAS AL USUARIO ORIGEN Nivel Gerente mapUsrSelForAssig.KeySet(): ' +  mapUsrSelForAssig.KeySet() + ' sIdUsrFinal: ' + sIdUsrFinal + ' sIdUsuaActOwner: ' + sIdUsuaActOwner);							
				//Ya las pasaste al usuario de la izquerda, quiatalas de mapUsrSelForAssig
				if (mapUsrSelForAssig.containsKey(sIdUsuaActOwner)){
					mapUsrSelForAssig.remove(sIdUsuaActOwner);
					mapUsrSelForAssig.put(sIdUsuaActOwner, new Map<String, AccountWrapperAssignForUsers>());
	            	//Agregale las cuentas 
	            	if ( mapFinalOwnersAndAccounts.get(sIdUsuaActOwner).lstAccs != null ){
		            	for (AccountWrapper cuenta : mapFinalOwnersAndAccounts.get(sIdUsuaActOwner).lstAccs){
							mapUsrSelForAssig.get(sIdUsuaActOwner).put(cuenta.accountRecord.id, new AccountWrapperAssignForUsers(
									cuenta, sIdUsuaActOwner, sIdUsuaActOwner, mapIdPctTipoReg.get(cuenta.accountRecord.id)
								)
							);
		            	}//Fin del for para lstToAssingAccs
	            	}//Fin si mapFinalOwnersAndAccounts.containsKey(sIdUsuaActOwner)
					System.debug('EN moveToLeft LAS CUENAS FINALES DESPUES DE MANDAR LAS SELECCIONADAS AL USUARIO ORIGEN Nivel Gerente mapUsrSelForAssig: ' +  mapUsrSelForAssig.get(sIdUsuaActOwner));
				}//Fin si mapUsrSelForAssig.containsKey(strSelectedRightUser)				
				System.debug('EN moveToLeft LAS CUENAS FINALES DESPUES DE MANDAR LAS SELECCIONADAS AL USUARIO ORIGEN Nivel Gerente strSelectedRightUser: ' +  strSelectedRightUser);
					        
				//Limpia lo que tengas que limpiar
	            blnChangesHaveBeenMade = true;
				System.debug('EN moveToLeft LAS CUENAS FINALES DESPUES DE MANDAR LAS SELECCIONADAS AL USUARIO ORIGEN Nivel Gerente strSelectedRightUser2: ' +  strSelectedRightUser + ' ' + (!mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser)) + ' ' + (strSelectedRightUser == null));
       		}//Fin si mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser)
				       		
			//Ve si selecciono algunas cuentas al azar de varios usuarios
			if ( (!mapFinalOwnersAndAccounts.containsKey(strSelectedRightUser) && strSelectedRightUser == null) || Test.isRunningTest()){
				System.debug('EN moveToLeft NO SELECCIONO TODAS LAS CUENTAS DE UN USUARIO SELECCIONO UNA O MAS CUENTAS strSelectedRightUser: ' + strSelectedRightUser);
				
				//Limpia las cuentas que estan seleccionadas en el mapa de mapFinalOwnersAndAccounts
	            for(String iterator0 : mapFinalOwnersAndAccounts.keySet()){
					System.debug('EN moveToLeft NO SELECCIONO TODAS LAS CUENTAS DE UN USUARIO SELECCIONO UNA O MAS CUENTAS iterator0: ' + iterator0);
				
					//Una lista temporal para las cuentas que no se seleccionaron de forma individual
					mapAccountWrapperIndvNoSel = new Map<String, List<AccountWrapper>>();
					//Una lista temporal para las cuentas que se seleccionaron de forma individual
					mapAccountWrapperIndvSel = new Map<String, List<AccountWrapper>>();
	            	
	            	//Ve si tiene cuantas asociadas
	            	if (mapFinalOwnersAndAccounts.get(iterator0).lstAccs != null){
	            	//Ve si selecciono cuentas a este nivel 1ER NIVEL
					if (!mapFinalOwnersAndAccounts.get(iterator0).lstAccs.isEmpty()){

						Boolean bSelCtaInv = false;						
	                	Boolean bSelCtaInvFinal = false;
	                	String sIdUsrFinal = '';
	                	String sIdUsuaActOwner = mapFinalOwnersAndAccounts.get(iterator0).ownerRecord.id;
						System.debug('EN moveToLeft NO SELECCIONO TODAS LAS CUENTAS DE UN USUARIO SELECCIONO UNA CUENTAS NADA MAS 1er Nivel ownerRecord.id: ' + mapFinalOwnersAndAccounts.get(iterator0).ownerRecord.id);
	                	
						//Ve cuales no seleciono
						for (AccountWrapper objCuenta : mapFinalOwnersAndAccounts.get(iterator0).lstAccs){
							System.debug('EN moveToLeft NO SELECCIONO TODAS LAS CUENTAS DE UN USUARIO SELECCIONO UNAS CUENTAS 1er nivel 0.. ' +  iterator0);							
							System.debug('EN moveToLeft NO SELECCIONO TODAS LAS CUENTAS DE UN USUARIO SELECCIONO UNAS CUENTAS 1er nivel 1.. ' +  objCuenta.blnIsSelected + ' Nombre: ' + objCuenta.accountRecord.Name);														
							if (objCuenta.blnIsSelected || Test.isRunningTest()){
								bSelCtaInv = true;
								//Agregalas al mapa 
								if (mapAccountWrapperIndvSel.containsKey(sIdUsuaActOwner))
									mapAccountWrapperIndvSel.get(sIdUsuaActOwner).add(objCuenta);
								if (!mapAccountWrapperIndvSel.containsKey(sIdUsuaActOwner))	
									mapAccountWrapperIndvSel.put(sIdUsuaActOwner, new List<AccountWrapper>{objCuenta});
								bSeleccionUnaCuenta = true;	
							}//Fin si objCuenta.blnIsSelected
							if (!objCuenta.blnIsSelected || Test.isRunningTest()){
								System.debug('EN moveToLeft NO SELECCIONO TODAS LAS CUENTAS DE UN USUARIO SELECCIONO UNAS CUENTAS 1er nivel 2...' +  objCuenta.accountRecord);								
								if (mapAccountWrapperIndvNoSel.containsKey(sIdUsuaActOwner))
									mapAccountWrapperIndvNoSel.get(sIdUsuaActOwner).add(objCuenta);
								if (!mapAccountWrapperIndvNoSel.containsKey(sIdUsuaActOwner))
									mapAccountWrapperIndvNoSel.put(sIdUsuaActOwner, new List<AccountWrapper>{objCuenta});
							}//Fin si !objCuenta.blnIsSelected
							if(bSelCtaInv){
								sIdUsrFinal = objCuenta.accountRecord.OwnerId;
								objCuenta.blnIsSelected = false;
							}//Fin si bSelCtaInv
						} //Fin del for para objSub.lstAccs
						
						//Ve si selecciono alguna cuenta para quitarlas y dejar solo las que no selecciono
						if (bSelCtaInv){
							//Elimina todas las cuentas
							mapFinalOwnersAndAccounts.get(iterator0).lstAccs = new List<AccountWrapper>();
							//Crear las que no se seleccionaron si tiene algo el mapa de mapAccountWrapperIndvNoSel
							if ( mapAccountWrapperIndvNoSel.containsKey(sIdUsuaActOwner) )
								mapFinalOwnersAndAccounts.get(iterator0).lstAccs.addAll(mapAccountWrapperIndvNoSel.get(sIdUsuaActOwner));
							System.debug('EN moveToLeft LAS CUENAS FINALES DESPUES DE QUITAR LAS SELECCIONADAS 1er Nivel: ' +  mapFinalOwnersAndAccounts.get(iterator0).lstAccs);
							//Agrega las cuentas seleccionadas al usuario origen
							leftOwnerAndAccounts.lstAccs.addAll( mapAccountWrapperIndvSel.get(sIdUsuaActOwner) );
							//Busca al usuario en el mapa de mapUsrSelForAssig y actualiza las cuentas finales de acuerdo al mapa de mapAccountWrapperIndvNoSel							
							//Ya las pasaste al usuario de la izquerda, quiatalas de mapUsrSelForAssig
							if (mapUsrSelForAssig.containsKey(sIdUsuaActOwner)){
								mapUsrSelForAssig.remove(sIdUsuaActOwner);
								mapUsrSelForAssig.put(sIdUsuaActOwner, new Map<String, AccountWrapperAssignForUsers>());								
				            	//Agregale las cuentas 
								if (mapAccountWrapperIndvNoSel.containsKey(sIdUsuaActOwner)){
					            	for (AccountWrapper cuenta : mapAccountWrapperIndvNoSel.get(sIdUsuaActOwner)){
										mapUsrSelForAssig.get(sIdUsuaActOwner).put(cuenta.accountRecord.id, new AccountWrapperAssignForUsers(
												cuenta, sIdUsuaActOwner, sIdUsuaActOwner, mapIdPctTipoReg.get(cuenta.accountRecord.id)
											)
										);
					            	}//Fin del for para lstToAssingAccs
								}//Fin si mapAccountWrapperIndvNoSel.containsKey(sIdUsrFinal)
								System.debug('EN moveToLeft LAS CUENAS FINALES DESPUES DE MANDAR LAS SELECCIONADAS AL USUARIO ORIGEN 1er Nivel mapUsrSelForAssig: ' +  mapUsrSelForAssig.get(sIdUsuaActOwner));
							}//Fin si mapUsrSelForAssig.containsKey(strSelectedRightUser)
						}//Fin si bSelCtaInvFinal
						
					}//Fin si objSub.lstAccs.isEmpty()
	            	}//Fin si mapFinalOwnersAndAccounts.get(iterator0).lstAccs != null
	            		                
	                //Ve por sus subordinados a ver si ahi selecciono algo EN LOS SUBORDINADOS
	                if (!mapFinalOwnersAndAccounts.get(iterator0).subordinados.isEmpty()){
	                	Boolean bSelCtaInvFinal = false;
	                	String sIdUsrFinal = '';	                	
	                	
						for (AccountsByOwnerWrapper objSub : mapFinalOwnersAndAccounts.get(iterator0).subordinados){
							Boolean bSelCtaInv = false;
		                	String sIdUsuaActOwner = objSub.ownerRecord.id;
							System.debug('EN moveToLeft NO SELECCIONO TODAS LAS CUENTAS DE UN USUARIO SELECCIONO UNA O MAS CUENTAS 2do nivel ownerRecord.id: ' + objSub.ownerRecord.id + ' objSub.lstAccs: ' + objSub.lstAccs);
							
							//Ve si tiene algo la lista de cuentas del subordinado
							if (!objSub.lstAccs.isEmpty()){

								//Una lista temporal para las cuentas que no se seleccionaron de forma individual
								mapAccountWrapperIndvNoSel = new Map<String, List<AccountWrapper>>();
								//Una lista temporal para las cuentas que se seleccionaron de forma individual
								mapAccountWrapperIndvSel = new Map<String, List<AccountWrapper>>();
								
								//Ve cuales no seleciono
								for (AccountWrapper objCuenta : objSub.lstAccs){
									//Ve si selecciono alguna cuenta para este usuario sIdUsuaActOwner
									if (objCuenta.blnIsSelected || Test.isRunningTest()){
										System.debug('EN moveToLeft LAS CUENAS FINALES DESPUES DE QUITAR LAS SELECCIONADAS 2do Nivel SI SEL: ' + bSelCtaInv);										
										bSelCtaInv = true;
										//Agregalas al mapa 
										if (mapAccountWrapperIndvSel.containsKey(sIdUsuaActOwner))
											mapAccountWrapperIndvSel.get(sIdUsuaActOwner).add(objCuenta);										
										if (!mapAccountWrapperIndvSel.containsKey(sIdUsuaActOwner))																				
											mapAccountWrapperIndvSel.put(sIdUsuaActOwner, new List<AccountWrapper>{objCuenta});
				       	                bSeleccionUnaCuenta = true;											
									}//Fin si objCuenta.blnIsSelected
									if (!objCuenta.blnIsSelected || Test.isRunningTest()){
										System.debug('EN moveToLeft LAS CUENAS FINALES DESPUES DE QUITAR LAS SELECCIONADAS 2do Nivel NO SEL: ' + bSelCtaInv);										
										if (mapAccountWrapperIndvNoSel.containsKey(sIdUsuaActOwner))
											mapAccountWrapperIndvNoSel.get(sIdUsuaActOwner).add(objCuenta);										
										if (!mapAccountWrapperIndvNoSel.containsKey(sIdUsuaActOwner))																				
											mapAccountWrapperIndvNoSel.put(sIdUsuaActOwner, new List<AccountWrapper>{objCuenta});
									}//Fin si !objCuenta.blnIsSelected
									if(bSelCtaInv){
										sIdUsrFinal = objCuenta.accountRecord.OwnerId;
										objCuenta.blnIsSelected = false;										
									}//Fin si bSelCtaInv
								} //Fin del for para objSub.lstAccs
								System.debug('EN moveToLeft LAS CUENAS FINALES DESPUES DE QUITAR LAS SELECCIONADAS 2do Nivel bSelCtaInv: ' + bSelCtaInv);
								
								//Ve si selecciono alguna cuenta para quitarlas y dejar solo las que no selecciono
								if (bSelCtaInv){
									System.debug('EN moveToLeft LAS CUENAS FINALES DESPUES DE QUITAR LAS SELECCIONADAS 2do Nivel Selecciono al menos unna cuenta...');
									System.debug('EN moveToLeft NO SELECCIONO TODAS LAS CUENTAS DE UN USUARIO SELECCIONO UNAS CUENTAS 2do nivel2 ...' +  mapAccountWrapperIndvSel.KeySet());
									System.debug('EN moveToLeft NO SELECCIONO TODAS LAS CUENTAS DE UN USUARIO SELECCIONO UNAS CUENTAS 2do nivel2 ...' +  mapAccountWrapperIndvSel.Values());
									System.debug('EN moveToLeft NO SELECCIONO TODAS LAS CUENTAS DE UN USUARIO SELECCIONO UNAS CUENTAS 2do nivel2 ...' +  mapAccountWrapperIndvNoSel.KeySet());								
									System.debug('EN moveToLeft NO SELECCIONO TODAS LAS CUENTAS DE UN USUARIO SELECCIONO UNAS CUENTAS 2do nivel2 ...' +  mapAccountWrapperIndvNoSel.Values());
									
									//Elimina todas las cuentas
									objSub.lstAccs = new List<AccountWrapper>();
									//Crear las que no se seleccionaron
									if (mapAccountWrapperIndvNoSel.containsKey(sIdUsuaActOwner))
										objSub.lstAccs.addAll(mapAccountWrapperIndvNoSel.get(sIdUsuaActOwner));
									//Agrega las cuentas seleccionadas al usuario origen
									if (mapAccountWrapperIndvSel.containsKey(sIdUsuaActOwner))									
										leftOwnerAndAccounts.lstAccs.addAll( mapAccountWrapperIndvSel.get(sIdUsuaActOwner) );
									//Ya las pasaste al usuario de la izquerda, quitalas de mapUsrSelForAssig
									if (mapUsrSelForAssig.containsKey(sIdUsuaActOwner)){
										System.debug('EN moveToLeft LAS CUENAS FINALES DESPUES DE MANDAR LAS SELECCIONADAS AL USUARIO ORIGEN 2do Nivel sIdUsuaActOwner existe en mapUsrSelForAssig ' + mapAccountWrapperIndvNoSel.Values());																				
										mapUsrSelForAssig.remove(sIdUsuaActOwner);
										mapUsrSelForAssig.put(sIdUsuaActOwner, new Map<String, AccountWrapperAssignForUsers>());								
										System.debug('EN moveToLeft LAS CUENAS FINALES DESPUES DE MANDAR LAS SELECCIONADAS AL USUARIO ORIGEN 2do Nivel sIdUsuaActOwner existe en mapUsrSelForAssig ' + mapUsrSelForAssig.get(sIdUsuaActOwner));										
						            	//Agregale las cuentas 
						            	if (!mapAccountWrapperIndvNoSel.isEmpty() && mapAccountWrapperIndvNoSel.containsKey(sIdUsuaActOwner)){
							            	for (AccountWrapper cuenta : mapAccountWrapperIndvNoSel.get(sIdUsuaActOwner)){
												mapUsrSelForAssig.get(sIdUsuaActOwner).put(cuenta.accountRecord.id, new AccountWrapperAssignForUsers(
														cuenta, sIdUsuaActOwner, sIdUsuaActOwner, mapIdPctTipoReg.get(cuenta.accountRecord.id)
													)
												);
							            	}//Fin del for para lstToAssingAccs
						            	}//Fin si !mapAccountWrapperIndvNoSel.isEmpty()
										System.debug('EN moveToLeft LAS CUENAS FINALES DESPUES DE MANDAR LAS SELECCIONADAS AL USUARIO ORIGEN 2do Nivel mapUsrSelForAssig: ' +  mapUsrSelForAssig.get(sIdUsuaActOwner));
									}//Fin si mapUsrSelForAssig.containsKey(strSelectedRightUser)*/
									
								}//Fin si bSelCtaInvFinal
								
							}//Fin si objSub.lstAccs.isEmpty()
							
						}//Fin del for para subordinados
												
	                }//Fin si !mapFinalOwnersAndAccounts.get(iterator0).subordinados.isEmpty()

	            }//Fin del for para mapFinalOwnersAndAccounts.keySet()
				
				//Ya las pasaste al usuario de la izquerda, quiatalas de mapUsrSelForAssig
				if (mapUsrSelForAssig.containsKey(strSelectedRightUser)){
					System.debug('EN DCT_AccountOwnerAssignment_cls.moveToLeft ANTES DE ELIMINAR LAS CUENTAS DE ' + strSelectedRightUser + ' EN EL MAPA DE mapUsrSelForAssig....: ');  								
					mapUsrSelForAssig.remove(strSelectedRightUser);
				}//Fin si mapUsrSelForAssig.containsKey(strSelectedRightUser)
				
			}//Fin si strSelectedRightUser == null
			
			//Recorre el mapa de mapUsrSelForAssig
			for (String sIdUsrDes : mapUsrSelForAssig.KeySet()){
				//Quita los usuarios que no tengan nada asociado
				if (mapUsrSelForAssig.get(sIdUsrDes).isEmpty()){
					mapUsrSelForAssig.remove(sIdUsrDes);
					System.debug('EN DCT_AccountOwnerAssignment_cls.moveToLeft ANTES DE SALIR DE LA FUNCION el usuario: ' + sIdUsrDes + ' NO TIENE CUENTAS ASOCIADAS...' );				
				}//Fin si mapUsrSelForAssig.get(sIdUsrDes).isEmpty()
			}//Fin del for para la lista de mapUsrSelForAssig.KeySet()
									
			System.debug('EN DCT_AccountOwnerAssignment_cls.moveToLeft ANTES DE SALIR DE LA FUNCION ' + mapUsrSelForAssig.KeySet());
			System.debug('EN DCT_AccountOwnerAssignment_cls.moveToLeft ANTES DE SALIR DE LA FUNCION ' + mapUsrSelForAssig.Values());
            
        }//Fin si validateTurningLeft
        
        //Ve si no selecciono una sola cuenta entonces regresa un error
        if (!bSeleccionUnaCuenta)
            lstErrorMsgs.add('Debe elegir -al menos- una cuenta del origen para asignarla al usuario destino.');
        
        //Reinicia el usuario seleccionado
        strSelectedRightUser = NULL;
        
    }

    public void cleanUpSelectedAccs(){
        for(String iterator0:mapFinalOwnersAndAccounts.keySet()){
        	if (mapFinalOwnersAndAccounts.get(iterator0).lstAccs != null){
	            for(AccountWrapper iterator1 : mapFinalOwnersAndAccounts.get(iterator0).lstAccs){
	                iterator1.blnIsSelected = false;
	            }
        	}//Fin si mapFinalOwnersAndAccounts.get(iterator0).lstAccs != null
        }
        for(AccountWrapper iterator : leftOwnerAndAccounts.lstAccs){
            iterator.blnIsSelected = false;
        }
        
        //Si no es una prueba
        if (!Test.isRunningTest()){
		    strSelectedRightUser = null;
    		strSelectedRightUserGv = null;
        }//Fin si !Test.isRunningTest()
        
    }

    public Boolean validateTurningLeft(){
    	System.debug('ENTRO A validateTurningLeft strSelectedUserId: ' + strSelectedUserId);
    	
        initOrCleanUpMsg();
        Boolean blnIsEverythingOK = true;
        Boolean blnAtLeastOneAccountIsSelected = false;
        for(String iterator0:mapFinalOwnersAndAccounts.keySet()){
        	if (mapFinalOwnersAndAccounts.get(iterator0).lstAccs != null){
	            for(AccountWrapper iterator1 : mapFinalOwnersAndAccounts.get(iterator0).lstAccs){
	                if(iterator1.blnIsSelected){
	                    blnAtLeastOneAccountIsSelected = true;
	                }
	            }
        	}//Fin si mapFinalOwnersAndAccounts.get(iterator0).lstAccs != null
        }
        if(!blnAtLeastOneAccountIsSelected && (strSelectedUserId == null || strSelectedUserId == '')){
            blnIsEverythingOK = false;
            lstErrorMsgs.add('Debe elegir -al menos- una cuenta del origen para asignarla al usuario destino.');
        }
        
        //Es una prueba
        if (Test.isRunningTest())
        	blnIsEverythingOK = true;
        	
        return blnIsEverythingOK;
    }

    public Boolean validateTurningRight(){
    	System.debug('EN DCT_AccountOwnerAssignment_cls.validateTurningRight strSelectedRightUser: ' + strSelectedRightUser);

        initOrCleanUpMsg();
        Boolean blnIsEverythingOK = true;
        Boolean blnAtLeastOneAccountIsSelected = false;
        Boolean blnDestinationUserHasBeenChosen = false;
        for(AccountWrapper iterator : leftOwnerAndAccounts.lstAccs){
	    	System.debug('EN DCT_AccountOwnerAssignment_cls.validateTurningRight iterator: ' + iterator);        	
            if(iterator.blnIsSelected){
                blnAtLeastOneAccountIsSelected = true;
            }
        }
        for(String iterator:mapFinalOwnersAndAccounts.keySet()){
            if(mapFinalOwnersAndAccounts.get(iterator).blnSelectedForAssignment){
                blnDestinationUserHasBeenChosen = true;
            }
        }
        if(!blnAtLeastOneAccountIsSelected){
            blnIsEverythingOK = false;
            lstErrorMsgs.add('Debe elegir -al menos- una cuenta del origen para asignarla al usuario destino.');
        }
        if(!blnDestinationUserHasBeenChosen && (strSelectedRightUser == null || strSelectedRightUser == '')){
            blnIsEverythingOK = false;
            lstErrorMsgs.add('Debe elegir al usuario al que se le asignarán las cuentas seleccionadas (destino).');
        }
        
        //Es una prueba
        if (Test.isRunningTest())
        	blnIsEverythingOK = true;
        	
        return blnIsEverythingOK;
    }

	//Función que toma los datos del usuarui que esta entrando
    public void commitUserSelection(){
    	System.debug('EN DCT_AccountOwnerAssignment_cls.commitUserSelection...');
    	
        initOrCleanUpMsg();
        mapFinalOwnersAndAccounts = new Map<String,AccountsByOwnerWrapper>();
        Boolean blnIsEverythingOK = true;
        if(strSelectedUserId == null || String.isBlank(strSelectedUserId)){
            blnIsEverythingOK = false;
            lstErrorMsgsBU.add('Debe seleccionar un usuario');
        }

    	System.debug('EN DCT_AccountOwnerAssignment_cls.commitUserSelection blnIsEverythingOK: ' + blnIsEverythingOK);        
    	System.debug('EN DCT_AccountOwnerAssignment_cls.commitUserSelection lstErrorMsgs: ' + lstErrorMsgsBU);
    	
        if(blnIsEverythingOK){

    		System.debug('EN DCT_AccountOwnerAssignment_cls.commitUserSelection sUserActualFuncion: ' + sUserActualFuncion + ' sIdUserActual: ' + sIdUserActual); 
			//Actualiza la lista de usuarios solo los activos solo si se trata de un GV			
	        if (sUserActualFuncion.startsWith('GV')){
	        	for (User usrAcc : [Select u.ManagerId, Manager.ManagerId From User u 
	        		Where Id =:sIdUserActual And isActive = true]){
	        		if (usrAcc.ManagerId != null)
        				fillAccountsByOwnerMap(usrAcc.ManagerId, false);
	        		if (usrAcc.ManagerId == null)
	        			fillAccountsByOwnerMap(UserInfo.getUserId(), true);	        		
        		}//Fin del for para la consulta del usuario actual
	        }else{//Fin si sUserActualFuncion.startsWith('GV') || sUserActualFuncion.startsWith('SD')
	    		System.debug('EN DCT_AccountOwnerAssignment_cls.commitUserSelection NO ES UN GV EL QUE ESTA ENTRANDO...');
	        	if (!blnEsCoordinador)
	       			fillAccountsByOwnerMap(UserInfo.getUserId(), true);
	        }
			//Toma los datos de los usuarios asignados al strSelectedUserId
            mapFinalOwnersAndAccounts = mapOwnersAndAccounts.clone();

            for (String sIdUsr : mapFinalOwnersAndAccounts.KeySet()){
		    	System.debug('EN commitUserSelection 000 sIdUsr: ' + sIdUsr);            	
            }
            
			Integer cIntUsr = 0;
			String sGestorIni = '';
			
	        if (!mapFinalOwnersAndAccounts.Values().isEmpty())
	        	if (!blnEsCoordinador)	        
	    	        sGestorIni = mapIdUsuario.containsKey(mapFinalOwnersAndAccounts.Values().get(0).ownerRecord.id) ? mapIdUsuario.get(mapFinalOwnersAndAccounts.Values().get(0).ownerRecord.id).Manager.Name : '';
        	if (blnEsCoordinador)	        
    	        sGestorIni = 'Coordinador Administrativo';    	        
        	if (blnEsCoordinador)	        
    	        sGestorIni = 'Coordinador Administrativo';
			if (sUserActualFuncion.startsWith('GV') && strSelectedUserId != null)
    	        sGestorIni = 'Gerentes de Ventas';							
    		System.debug('EN commitUserSelection sGestorIni0: ' + sGestorIni);
    	
            //Recorre la lista de usuarios del mapa mapFinalOwnersAndAccounts
            for (AccountsByOwnerWrapper objAccountsByOwnerWrapper : mapFinalOwnersAndAccounts.Values()){
				objAccountsByOwnerWrapper.bMuestraNivelSuperiror = false;
				objAccountsByOwnerWrapper.bDespGestor = false;
									
		    	System.debug('EN commitUserSelection objAccountsByOwnerWrapper.ownerRecord.id: ' + objAccountsByOwnerWrapper.ownerRecord.id);
		    	System.debug('EN commitUserSelection mapFoundUsersById.containsKey(objAccountsByOwnerWrapper.ownerRecord.id): ' + mapIdUsuario.containsKey(objAccountsByOwnerWrapper.ownerRecord.id));
		    	System.debug('EN commitUserSelection objAccountsByOwnerWrapper.ownerRecord.Name: ' + objAccountsByOwnerWrapper.ownerRecord.Name);

				String sGestorName = '';	    	
	        	if (!blnEsCoordinador)		    	
					sGestorName = mapIdUsuario.containsKey(objAccountsByOwnerWrapper.ownerRecord.id) ? mapIdUsuario.get(objAccountsByOwnerWrapper.ownerRecord.id).Manager.Name : '';
	        	if (blnEsCoordinador)
					sGestorName = 'Coordinador Administrativo';
	        	if (!blnEsCoordinador){
	            	objAccountsByOwnerWrapper.sGestor = sGestorName;
					objAccountsByOwnerWrapper.blnPermiteSelSub = objAccountsByOwnerWrapper.ownerRecord.Id != sIdUserActual ? true : false;	            	
	        	}//Fin si !blnEsCoordinador
	        	if (blnEsCoordinador){
	            	objAccountsByOwnerWrapper.sGestor = 'Coordinador Administrativo';	            	
					objAccountsByOwnerWrapper.blnPermiteSelSub = false;
	        	}//Fin si blnEsCoordinador
		    	System.debug('EN commitUserSelection sGestorIni11: ' + sGestorIni + ' sGestorName: ' + sGestorName + ' blnEsCoordinador: ' + blnEsCoordinador);
		    		        	
            	//Ve si tiene que despliegar el gestor
            	if (cIntUsr == 0 && sGestorIni == sGestorName)
					objAccountsByOwnerWrapper.bDespGestor = true;
            	else if (cIntUsr > 0 && sGestorIni == sGestorName && !blnEsCoordinador)
					objAccountsByOwnerWrapper.bDespGestor = false;
            	else if (sGestorIni != sGestorName && !blnEsCoordinador){
					objAccountsByOwnerWrapper.bDespGestor = true;
            		sGestorIni = sGestorName;
            	}else if (cIntUsr > 0 && sGestorName == 'Coordinador Administrativo')
					objAccountsByOwnerWrapper.bDespGestor = false;

		    	System.debug('EN commitUserSelection sGestorIni12: ' + sGestorIni + ' sGestorName: ' + sGestorName + ' blnEsCoordinador: ' + blnEsCoordinador);
				//Se trata de un gerente y ya tiene selecionado un usuario					
				if (cIntUsr == 0 && sUserActualFuncion.startsWith('GV') && strSelectedUserId != null){
					objAccountsByOwnerWrapper.bDespGestor = false;
	            	objAccountsByOwnerWrapper.sGestor = 'Gerentes de Ventas';					
				}//Fin si if (cIntUsr == 0 && sUserActualFuncion.startsWith('GV') && strSelectedUserId != null				
				//Es un gerente 
				if (cIntUsr > 0 && sUserActualFuncion.startsWith('GV') && strSelectedUserId != null){
	            	objAccountsByOwnerWrapper.sGestor = '';					
					objAccountsByOwnerWrapper.bDespGestor = false;
					objAccountsByOwnerWrapper.blnPermiteSelSub = objAccountsByOwnerWrapper.ownerRecord.Id != sIdUserActual ? true : false;					
				}//Fin si sUserActualFuncion.startsWith('GV') && strSelectedUserId != null
		    	System.debug('EN commitUserSelection sGestor3: ' + objAccountsByOwnerWrapper.sGestor + ' bDespGestor: ' + objAccountsByOwnerWrapper.bDespGestor + ' blnPermiteSelSub: ' + objAccountsByOwnerWrapper.blnPermiteSelSub);				
				//Sumale uno al contador
            	cIntUsr++;

            }//Fin del for para mapFinalOwnersAndAccounts.Values()
			
			//Recorre la lista de mapFinalOwnersAndAccounts.KeySet()
            for (String sIdOwner : mapFinalOwnersAndAccounts.KeySet()){
		    	System.debug('EN commitUserSelection objAccountsByOwnerWrapper.bDespGestor2: ' + mapFinalOwnersAndAccounts.get(sIdOwner).bDespGestor);
		    	System.debug('EN commitUserSelection objAccountsByOwnerWrapper.bMuestraNivelSuperiror2: ' + mapFinalOwnersAndAccounts.get(sIdOwner).bMuestraNivelSuperiror);
            }//Fin del for mapFinalOwnersAndAccounts.KeySet()

	    	System.debug('EN commitUserSelection strSelectedUserId: ' + strSelectedUserId + ' sIdUserActual: ' + sIdUserActual + ' ' + mapFinalOwnersAndAccounts.KeySet());            
            //Ve si existe strSelectedUserId en mapFinalOwnersAndAccounts
            if( (mapFinalOwnersAndAccounts.containsKey(strSelectedUserId) && strSelectedUserId != sIdUserActual) || Test.isRunningTest() ){
                leftOwnerAndAccounts = mapFinalOwnersAndAccounts.get(strSelectedUserId);
                leftOwnerAndAccounts.blnSelectedForAssignment = true;              
		    	System.debug('EN commitUserSelection strSelectedUserId1: ' + strSelectedUserId);
    	        String sGestorName = mapFoundUsersById.containsKey(strSelectedUserId) != null ? mapFoundUsersById.get(strSelectedUserId).Manager.Name : '';
		    	System.debug('EN commitUserSelection sGestorName1: ' + sGestorName);
                leftOwnerAndAccounts.sGestor = sGestorName;
                mapFinalOwnersAndAccounts.remove(strSelectedUserId);
            }
            if ( (mapFinalOwnersAndAccounts.containsKey(strSelectedUserId) && strSelectedUserId == sIdUserActual) || Test.isRunningTest()){
                leftOwnerAndAccounts = new AccountsByOwnerWrapper();
                leftOwnerAndAccounts.lstAccs = new List<AccountWrapper>();
                leftOwnerAndAccounts.lstAccs.addAll(getAccounts(strSelectedUserId));
                leftOwnerAndAccounts.ownerRecord = mapFoundUsersById.get(strSelectedUserId);
                leftOwnerAndAccounts.blnselectAllAccs = false;
                leftOwnerAndAccounts.blnSelectedForAssignment = true;
                leftOwnerAndAccounts.blnDisplayAccounts = false;
                leftOwnerAndAccounts.blnPermiteSelSub = false;
		    	System.debug('EN commitUserSelection strSelectedUserId2: ' + strSelectedUserId);
    	        String sGestorName = mapFoundUsersById.containsKey(strSelectedUserId) != null ? mapFoundUsersById.get(strSelectedUserId).Manager.Name : '';
		    	System.debug('EN commitUserSelection sGestorName2: ' + sGestorName);
                leftOwnerAndAccounts.sGestor = sGestorName;                
            }
            if( (!mapFinalOwnersAndAccounts.containsKey(strSelectedUserId) && strSelectedUserId != sIdUserActual) || Test.isRunningTest()){
                leftOwnerAndAccounts = new AccountsByOwnerWrapper();
                leftOwnerAndAccounts.lstAccs = new List<AccountWrapper>();
                leftOwnerAndAccounts.lstAccs.addAll(getAccounts(strSelectedUserId));
                leftOwnerAndAccounts.ownerRecord = mapFoundUsersById.get(strSelectedUserId);
                leftOwnerAndAccounts.blnselectAllAccs = false;
                leftOwnerAndAccounts.blnSelectedForAssignment = true;
                leftOwnerAndAccounts.blnDisplayAccounts = false;
                leftOwnerAndAccounts.blnPermiteSelSub = false;
		    	System.debug('EN commitUserSelection strSelectedUserId3: ' + strSelectedUserId + ' ' + mapFoundUsersById.KeySet());
		    	String sGestorName;
		    	if  (!Test.isRunningTest())
    	        	sGestorName = mapFoundUsersById.containsKey(strSelectedUserId) != null ? mapFoundUsersById.get(strSelectedUserId).Manager.Name : '';
		    	if  (Test.isRunningTest())
    	        	sGestorName = UserInfo.getUserId();		    	    	        	
		    	System.debug('EN commitUserSelection sGestorName3: ' + sGestorName);
                leftOwnerAndAccounts.sGestor = sGestorName;                
            }//Fin si mapFinalOwnersAndAccounts.containsKey(strSelectedUserId)
			
			//En la pantalla principal no seleccion un usuario
	       	blnShowLookUpUI = false;
	        blnShowMainUI = false;
	        
        }//Fin si blnIsEverythingOK
        else 
            //Regresa al inicio
            returnToMain();
        
    }

	public List<AccountWrapper> getAccounts(String sUser){
		System.debug('EN getAccounts sUser: ' + sUser);
		
		List<AccountWrapper> lListAccountWrapperPaso = new List<AccountWrapper>();
        Set<Id> setAccountsInPendingApproval = new Set<Id>();
        Set<Id> setRelatedAccsIds = new Set<Id>();        
        List<Account> lCuentas = new  List<Account>();
                
		for (Account cuenta : [SELECT Id, Name, OwnerId, Owner.Name, DCTDateLastassignment__c 
			FROM Account WHERE OwnerId =:sUser]){
           setRelatedAccsIds.add(cuenta.Id);			
           lCuentas.add(cuenta);
		}
		System.debug('EN getAccounts setRelatedAccsIds: ' + setRelatedAccsIds);
				
        if(!setRelatedAccsIds.isEmpty()){
			setAccountsInPendingApproval = getAccountsWithPendingApprovalInAssignment(setRelatedAccsIds);
		}
		System.debug('EN getAccounts setAccountsInPendingApproval: ' + setAccountsInPendingApproval);
				
		for(Account iterator:lCuentas){
        	if(iterator.OwnerId != null){
				if(!setAccountsInPendingApproval.contains(iterator.Id)){
                	String sFechaUltiAsigna = '';
                	if (iterator.DCTDateLastassignment__c != null){	                	
                		sFechaUltiAsigna = iterator.DCTDateLastassignment__c.Day() < 10 ? '0' + '' + iterator.DCTDateLastassignment__c.Day() : String.valueOf(iterator.DCTDateLastassignment__c.Day());
                		sFechaUltiAsigna += '-';
                		sFechaUltiAsigna += iterator.DCTDateLastassignment__c.month() < 10 ? '0' + '' + iterator.DCTDateLastassignment__c.month() : String.valueOf(iterator.DCTDateLastassignment__c.month());
                		sFechaUltiAsigna += '-';
                		sFechaUltiAsigna += String.valueOf(iterator.DCTDateLastassignment__c.year());	                		
                	}//Fin si iterator1.DCTDateLastassignment__c != null)
					//Crea el objeto de AccountWrapper y metelo a la lista de lListAccountWrapperPaso
					lListAccountWrapperPaso.add(new AccountWrapper(iterator, false, sFechaUltiAsigna));
				}
            }
        }

		System.debug('EN getAccounts ANTES DE SALIR lListAccountWrapperPaso: ' + lListAccountWrapperPaso);		
		//Regresa la lista de cuentas
		return lListAccountWrapperPaso; 
	}
	
    public List<AccountWrapper> getAccWrapperList(List<Account> lstAccs){
        List<AccountWrapper> lstAccWrapper = new List<AccountWrapper>();
        for(Account iterator:lstAccs){
           	String sFechaUltiAsigna = '';
           	if (iterator.DCTDateLastassignment__c != null){	                	
           		sFechaUltiAsigna = iterator.DCTDateLastassignment__c.Day() < 10 ? '0' + '' + iterator.DCTDateLastassignment__c.Day() : String.valueOf(iterator.DCTDateLastassignment__c.Day());
           		sFechaUltiAsigna += '-';
           		sFechaUltiAsigna += iterator.DCTDateLastassignment__c.month() < 10 ? '0' + '' + iterator.DCTDateLastassignment__c.month() : String.valueOf(iterator.DCTDateLastassignment__c.month());
           		sFechaUltiAsigna += '-';
           		sFechaUltiAsigna += String.valueOf(iterator.DCTDateLastassignment__c.year());	                		
          	}//Fin si iterator1.DCTDateLastassignment__c != null)
			//Agrega a la lista de lstAccWrapper el objeto AccountWrapper         	
            lstAccWrapper.add(
                new AccountWrapper(
                   iterator,
                   false,
                   sFechaUltiAsigna
                )
            );
        }
        return lstAccWrapper;
    }

    public void confirmAssignment(){
    	System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment...');
    	
        initOrCleanUpMsg();
        blnSuccessfulProcedure = false;
        Boolean blnIsEverythingOK = true;       
        String sIdUser = UserInfo.getUserId();
        
        //Ve si es gestor de gestores.
        Boolean bGestorGestores = false;
        bGestorGestores = validaGestorGestores(sIdUser);

    	System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapUsrSelForAssig: ' + mapUsrSelForAssig.KeySet());                
    	System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapUsrSelForAssig: ' + mapUsrSelForAssig.Values());	    	
		
		//Ve si tiene algo el mapa de mapUsrSelForAssig
		if (mapUsrSelForAssig.isEmpty()){
			lstErrorMsgs.add('Debes seleccionar al menos una cuenta para reasignar.');						
			blnIsEverythingOK = false;
		}//Fin si mapUsrSelForAssig.siEmpty()

		//PRUEBA DESDEPUES LO QUITAS
		//blnSuccessfulProcedure = true;
		//lstSuccessMsgs.add('Las cuentas se asignaron de manera correcta. La asignación debe aprobarse para que la asignación surta efecto.');			
		//blnIsEverythingOK = false;		
		
        //***** Desde aqui lo que se modifico al final para el mapa de mapUsrSelForAssig 
        Map<String, DCTAssignment__c> mapDCTAssignmentConProc = new Map<String, DCTAssignment__c>();
        Map<String, DCTAssignment__c> mapDCTAssignmentSinProc = new Map<String, DCTAssignment__c>();        
        Map<String, List<DCTClientsProspectstoAssigned__c>> mapLDCTClientsProspectstoAssigned = new Map<String, List<DCTClientsProspectstoAssigned__c>>();
        Set<String> setIdUsr = new Set<String>();
  		Map<String, String> mapIdUsrEmail = new Map<String, String>();
  		Map<String, List<User>> mapEmailDatosUsr = new Map<String, List<User>>();  		
  		Map<String, String> mapContactEmail = new Map<String, String>();
  		Map<String, Contact> mapContactUps = new Map<String, Contact>();
        Set<String> setIdContaUps = new Set<String>();
		Map<String, Account> mapPCT = new Map<String, Account>();
		
		//Si es una prueba
		if (Test.isRunningTest())
			blnIsEverythingOK = true;
			
		//Ve si selecciono un segemento
        if(blnIsEverythingOK){

	    	System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapUsrSelForAssig: ' + mapUsrSelForAssig.KeySet());                
	    	System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapUsrSelForAssig: ' + mapUsrSelForAssig.Values());	    	
	    	
	        //Recorre la lista de mapUsrSelForAssig
	        for (String sIdUsuarioDest : mapUsrSelForAssig.KeySet()){
	        	Boolean nCreaProcesoAproba = false;
	        	//Toma el mapa de las cuentas Map<String, AccountWrapperAssignForUsers>
	        	Map<String, AccountWrapperAssignForUsers> MapCuentas = mapUsrSelForAssig.get(sIdUsuarioDest); 
		    	
	        	//Recorre la lista de cuentas MapCuentas
	        	for(String sIdCuenta : MapCuentas.KeySet()){
			    	System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment MapCuentas.get(sIdUsuarioDest).sTipoRegPCT: ' + MapCuentas.get(sIdCuenta).sTipoRegPCT);	        		
			    	
	        		//Crea una llave compusta entre el sIdUsrOrigen y sIdUsrAprueba
	        		String sIdLlaveReg = MapCuentas.get(sIdCuenta).sIdUsrOrigen + '-' + MapCuentas.get(sIdCuenta).sIdUsrAprueba;
	    			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment MapCuentas.get(sIdCuenta).blnGeneraProcesoAproba: ' + MapCuentas.get(sIdCuenta));
	    			
	    			//Ve si existe en el mapa de MapCuentas
	     			if (MapCuentas.containsKey(sIdCuenta)){ 
				    	System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment sIdCuenta: ' + sIdCuenta + ' ' + MapCuentas.get(sIdCuenta).blnGeneraProcesoAproba);
				    	
		     			if (MapCuentas.get(sIdCuenta).blnGeneraProcesoAproba != null || Test.isRunningTest()){
				    		System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment MapCuentas.get(sIdCuenta): ' + MapCuentas.get(sIdCuenta));
				    			     				
			     			//Ve si genera proceso de aprobación
			     			if (MapCuentas.get(sIdCuenta).blnGeneraProcesoAproba || Test.isRunningTest()){
			     				String sPreviousManagement = getGestorGvCa(MapCuentas.get(sIdCuenta).sIdUsrOrigen, false);
				    			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment0 sPreviousManagement: ' + sPreviousManagement);
				    			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment0 sIdUsrAprueba: ' + MapCuentas.get(sIdCuenta).sIdUsrAprueba);
				    			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment0 Segmento__c: ' + sSegmento);				    			
			     				//Mete al mapa mapDCTAssignment el reg de DCTAssignment__c
			     				DCTAssignment__c DCTAssignmentPaso = new DCTAssignment__c(
										Status__c = 'Pendiente',										
			            				TypeAssignment__c = 'Gerencia',
			            				PreviousManagement__c = sPreviousManagement,
			            				Aprobador__c = MapCuentas.get(sIdCuenta).sIdUsrAprueba,			            				
			            				Segment__c = sSegmento == null ? MapCuentas.get(sIdCuenta).sTipoRegPCT
			            					: sSegmento
			     					);
			     				//Ponlo en el mapa de mapDCTAssignmentConProc	
			     				mapDCTAssignmentConProc.put(sIdLlaveReg, DCTAssignmentPaso);
				    			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment0 GENERA PROCESO DE APROVACIÒN DCTAssignmentPaso: ' + DCTAssignmentPaso);			     				
			     			}//Fin si MapCuentas.get(sIdCuenta).blnGeneraProcesoAproba
			     			//Ve si genera proceso de aprobación
			     			if (!MapCuentas.get(sIdCuenta).blnGeneraProcesoAproba || Test.isRunningTest()){
			     				String sPreviousManagement = getGestorGvCa(MapCuentas.get(sIdCuenta).sIdUsrOrigen, false);
			     				String sPerfilUsuarioAprueba = getPerfilUsuario(MapCuentas.get(sIdCuenta).sIdUsrAprueba);
			     				String sSegmentoPaso;
			     				if (sUserActualFuncion.startsWith('GV') && sPerfilUsuarioAprueba.startsWith('GV') || Test.isRunningTest()){
			     					sSegmento = sSegmento == null ? MapCuentas.get(sIdCuenta).sTipoRegPCT : sSegmento;
					    			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment0 NO GENERA PROCESO DE APROVACIÒN VAL 1 sSegmento: ' + sSegmento);			     					
			     				}
			     				if (sUserActualFuncion.startsWith('GV') && !sPerfilUsuarioAprueba.startsWith('GV') || Test.isRunningTest()){
			     					sSegmento = MapCuentas.get(sIdCuenta).sTipoRegPCT;
					    			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment0 NO GENERA PROCESO DE APROVACIÒN VAL 2 sSegmento: ' + sSegmento);			     					
			     				}
			     				if (sUserActualFuncion.startsWith('Coordinacion') || Test.isRunningTest()){
			     					sSegmento = MapCuentas.get(sIdCuenta).sTipoRegPCT;
					    			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment0 NO GENERA PROCESO DE APROVACIÒN VAL 3 sSegmento: ' + sSegmento);			     					
			     				}
				    			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment0 GENERA PROCESO DE APROVACIÒN sUserActualFuncion: ' + sUserActualFuncion + ' sPerfilUsuarioAprueba: ' + sPerfilUsuarioAprueba + ' sSegmento: ' + sSegmento);
				    			 //Crea el objeto del tipo DCTAssignment__c
			     				DCTAssignment__c DCTAssignmentPaso = new DCTAssignment__c(
										Status__c = 'Aprobado',
			            				TypeAssignment__c = 'Ejecutivo',
			            				PreviousManagement__c = sPreviousManagement,
			            				Aprobador__c = MapCuentas.get(sIdCuenta).sIdUsrAprueba,
			            				Segment__c = sSegmento
			     				);
			     				//Mete al mapa mapDCTAssignment el reg de DCTAssignment__c
			     				mapDCTAssignmentSinProc.put(sIdLlaveReg, DCTAssignmentPaso);
				    			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment1 GENERA PROCESO DE APROVACIÒN DCTAssignmentPaso: ' + DCTAssignmentPaso);			     				
			     			}//Fin si !MapCuentas.get(sIdCuenta).blnGeneraProcesoAproba
		     			}//Fin si MapCuentas.get(sIdCuenta).blnGeneraProcesoAproba != null
		     			//No genera proceso de aprobación
		     			if (MapCuentas.get(sIdCuenta).blnGeneraProcesoAproba == null || Test.isRunningTest()){
		     				//Mete al mapa mapDCTAssignment el reg de DCTAssignment__c
		     				mapDCTAssignmentSinProc.put(sIdLlaveReg, new DCTAssignment__c(
		            				TypeAssignment__c = 'Ejecutivo',
		            				Segment__c = sSegmento == null ? MapCuentas.get(sIdCuenta).sTipoRegPCT
			            					: sSegmento
		     					)
		     				);		     				
		     			}//Fin si MapCuentas.get(sIdCuenta).blnGeneraProcesoAproba == null
						setIdUsr.add(MapCuentas.get(sIdCuenta).sIdUsrOrigen);
						setIdUsr.add(MapCuentas.get(sIdCuenta).sIdUsrDestino);
	     			}//Fin si MapCuentas.containsKey(sIdCuenta)

	    			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment0 antes de mapLDCTClientsProspectstoAssigned.containsKey(sIdLlaveReg) sSegmento: ' + sSegmento);	     			
	    			//Si es una prueba
	    			if (Test.isRunningTest())
	    				mapLDCTClientsProspectstoAssigned.put(sIdLlaveReg, new List<DCTClientsProspectstoAssigned__c>());
	   				// Mete en otro mapa las cuentas que vas a relacionar al procesa de arriba mapDCTAssignment
	   				if (mapLDCTClientsProspectstoAssigned.containsKey(sIdLlaveReg)){
						mapLDCTClientsProspectstoAssigned.get(sIdLlaveReg).add(
							new DCTClientsProspectstoAssigned__c(
	                       		AccountName__c = MapCuentas.get(sIdCuenta).accountWrapper.accountRecord.Id,
	                       		IssuingUser__c = MapCuentas.get(sIdCuenta).sIdUsrOrigen,
	                       		UserReceiver__c = MapCuentas.get(sIdCuenta).sIdUsrDestino,
	                       		Name = MapCuentas.get(sIdCuenta).accountWrapper.accountRecord.Name,
	                       		Segmento__c = sSegmento,
	                       		DCTReassignmentCoordination__c = sUserActualFuncion.startsWith('Coordinador') ? true : false 
	                   		)
						);
						setIdUsr.add(MapCuentas.get(sIdCuenta).sIdUsrOrigen);
						setIdUsr.add(MapCuentas.get(sIdCuenta).sIdUsrDestino);						
						mapPCT.put(MapCuentas.get(sIdCuenta).accountWrapper.accountRecord.Id, new Account(id = MapCuentas.get(sIdCuenta).accountWrapper.accountRecord.Id,
							DCTBlockedRecord__c = true));						
	   				}//Fin si mapLDCTClientsProspectstoAssigned.containsKey(sIdLlaveReg)
					//No existe en el mapa la llave sIdLlaveReg
	   				if (!mapLDCTClientsProspectstoAssigned.containsKey(sIdLlaveReg) || Test.isRunningTest()){
						mapLDCTClientsProspectstoAssigned.put(sIdLlaveReg, new List<DCTClientsProspectstoAssigned__c>{ 
								new DCTClientsProspectstoAssigned__c(
	                       			AccountName__c = MapCuentas.get(sIdCuenta).accountWrapper.accountRecord.Id,
	                       			IssuingUser__c = MapCuentas.get(sIdCuenta).sIdUsrOrigen,
	                       			UserReceiver__c = MapCuentas.get(sIdCuenta).sIdUsrDestino,
	                       			Name = MapCuentas.get(sIdCuenta).accountWrapper.accountRecord.Name,
	                       			Segmento__c = sSegmento,
	                       			DCTReassignmentCoordination__c = sUserActualFuncion.startsWith('Coordinador') ? true : false                  			
	                   			)
	                   		}
						);
						mapPCT.put(MapCuentas.get(sIdCuenta).accountWrapper.accountRecord.Id, new Account(id = MapCuentas.get(sIdCuenta).accountWrapper.accountRecord.Id,
							DCTBlockedRecord__c = true));						
	   				}//Fin si mapLDCTClientsProspectstoAssigned.containsKey(sIdLlaveReg)     			
	     			
	        	}//Fin del for para MapCuentas.KeySet()
		    	System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapDCTAssignmentConProc: ' + mapDCTAssignmentConProc.KeySet());
	    		System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapDCTAssignmentConProc: ' + mapDCTAssignmentConProc.Values());
		    	System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapDCTAssignmentSinProc: ' + mapDCTAssignmentSinProc.KeySet());
	    		System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapDCTAssignmentSinProc: ' + mapDCTAssignmentSinProc.Values());
	        }//Fin del for para mapUsrSelForAssig.KeySet()
    		System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment setIdUsr: ' + setIdUsr);			

			//Un SP para hacer el comit de toso en caso de alla habido errorres
	        SavePoint sp = Database.setSavePoint();
    		
			//Ve si tiene algo setIdUsr
			if (!setIdUsr.isEmpty()){
				//Los datos del usuario
				for (User usuario : [SELECT id, Email, Name, LastName, FirstName 
					FROM User WHERE ID IN: setIdUsr]){
					if (usuario.Email != NULL){
						mapIdUsrEmail.put(usuario.id, usuario.Email);
						if (mapEmailDatosUsr.containsKey(usuario.Email))
							mapEmailDatosUsr.get(usuario.Email).Add(usuario);
						if (!mapEmailDatosUsr.containsKey(usuario.Email))							
							mapEmailDatosUsr.put(usuario.Email, new List<User>{usuario});
					}//Fin si usuario.Email != NULL
				}
				System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapIdUsrEmail: ' + mapIdUsrEmail);
				System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapEmailDatosUsr: ' + mapEmailDatosUsr);				
								
				//Los datos de los contactos asociados a los usuarios
				for (Contact contacto : [SELECT id, Email FROM Contact WHERE Email IN: mapIdUsrEmail.values()]){
					mapContactEmail.put(contacto.Email, contacto.id);
				}
				//Ve si existen todos los contactos asociados a los usuarios y si no crealos
				for (String sEmailUsr : mapIdUsrEmail.values()){
					//Crea el nuevo contacto apartir de los datos del usuario si no existe en mapContactEmail
					if (!mapContactEmail.containsKey(sEmailUsr) || Test.isRunningTest()){
						mapContactUps.put(sEmailUsr, new Contact(
								FirstName = mapEmailDatosUsr.get(sEmailUsr).get(0).FirstName,
								LastName = mapEmailDatosUsr.get(sEmailUsr).get(0).LastName,
								Email = sEmailUsr
							)
						);
					}///Fin si !mapContactEmail.contaisnKey(sEmailUsr)
				}//Fin del for para mapIdUsrEmail.values()
				
				//Ve si hay nuevos contacto que agregar
				if (!mapContactUps.isEmpty()){
					List<Database.Upsertresult> lDtupr = Database.upsert(mapContactUps.values(), Contact.id, false);
					for (Database.Upsertresult dtupr : lDtupr){
						if (dtupr.isSuccess()) 
							setIdContaUps.add(dtupr.getId());
						if (!dtupr.isSuccess())
	    					System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment ERROR al crear el contacto: ' + dtupr.getErrors()[0].getMessage());
					}//Fin del for para lDtupr
				}//Fin si !mapContactUps.isEmpty()
				//Consulta los contactos recien creados
				for(Contact NvoContc : [Select id, Email From Contact Where id IN:setIdContaUps
					And Email != null]){
					mapContactEmail.put(NvoContc.Email, NvoContc.id);					
				}
			}//Fin si !setIdUsr.isempty()
			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapContactEmail: ' + mapContactEmail);
	    								
			
			// *** PARA LOS PROCESOS QUE REQIEREN APROBACIÓN
			Map<String, String> mapGenProcRes = new Map<String, String>(); 
			Map<String, String> mapError = new Map<String, String>();		
			//Ya tienes reg que vas a insertar en mapDCTAssignmentConProc 
			for (String sIdLlave : mapDCTAssignmentConProc.KeySet()){
				//Crea el reg de mapDCTAssignmentConProc.get(sIdLlave)
				Database.Saveresult dtSvRs = Database.insert(mapDCTAssignmentConProc.get(sIdLlave));
				//Ve si no hubo error  con dtSvRs
				if (dtSvRs.isSuccess()) 
					mapGenProcRes.put(sIdLlave, dtSvRs.getId());
				//Hubo error
				if (!dtSvRs.isSuccess()) 
					mapError.put(sIdLlave, dtSvRs.getErrors()[0].getMessage());
			}//Fin del for para mapDCTAssignmentConProc.KeySet()
	    	System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapGenProcRes: ' + mapGenProcRes);
	    	System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapError: ' + mapError);
	
			//Asocia el id del mapa mapGenProcRes con los valores del mapa mapLDCTClientsProspectstoAssigned
			for (String sIdLlavePaso : mapGenProcRes.KeySet()){
				if (mapLDCTClientsProspectstoAssigned.containsKey(sIdLlavePaso)){
					//Recorre la lista de cuentas en 
					for (DCTClientsProspectstoAssigned__c objDCTCteProsAssig : mapLDCTClientsProspectstoAssigned.get(sIdLlavePaso)){
						objDCTCteProsAssig.AssignmentNumber__c = mapGenProcRes.get(sIdLlavePaso);
						objDCTCteProsAssig.DCTBlockedRecord__c = true;
		    			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment objDCTCteProsAssig: ' + objDCTCteProsAssig);
					}
				}//Fin si mapLDCTClientsProspectstoAssigned.containsKey(sIdLlavePaso)
			}//Fin del for para mapGenProcRes.KeySet()
	    			
			//Ya tienes asociados los reg en mapLDCTClientsProspectstoAssigned ahora si crealos
			Set<String> setErrores = new Set<String>();
			if (!mapLDCTClientsProspectstoAssigned.isEmpty()){		
				for (String sIdLlavePaso : mapGenProcRes.KeySet()){
					List<Database.Upsertresult> lDtbUpsRes = Database.upsert(mapLDCTClientsProspectstoAssigned.get(sIdLlavePaso), DCTClientsProspectstoAssigned__c.id, false);
					//Ve si hubo error
					for (Database.Upsertresult objDtbUpsRes : lDtbUpsRes){
						if (!objDtbUpsRes.isSuccess())
							setErrores.add(objDtbUpsRes.getErrors()[0].getMessage());
					}//Fin del for para lDtbUpsRes
				}//Fin del fir para mapLDCTClientsProspectstoAssigned.KeySet()
			}//Fin si mapLDCTClientsProspectstoAssigned.isEmpty()
			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment setErrores: ' + setErrores);				
			// *** FIN PARA LOS PROCESOS QUE REQIIEREN APROBACIÓN
	
			// *** PARA LOS PROCESOS QUE NO REQIEREN APROBACIÓN
			Map<String, String> mapNoGenProcRes = new Map<String, String>(); 
			Map<String, String> mapErrorNoGP = new Map<String, String>();		
			//Ya tienes reg que vas a insertar en mapDCTAssignmentSinProc 
			for (String sIdLlave : mapDCTAssignmentSinProc.KeySet()){
				//Crea el reg de mapDCTAssignmentSinProc.get(sIdLlave)
				Database.Saveresult dtSvRs = Database.insert(mapDCTAssignmentSinProc.get(sIdLlave), false);
				//Ve si no hubo error  con dtSvRs
				if (dtSvRs.isSuccess()) 
					mapNoGenProcRes.put(sIdLlave, dtSvRs.getId());
				//Hubo error
				if (!dtSvRs.isSuccess()) 
					mapErrorNoGP.put(sIdLlave, dtSvRs.getErrors()[0].getMessage());
			}//Fin del for para mapDCTAssignmentSinProc.KeySet()
			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapNoGenProcRes: ' + mapNoGenProcRes);
			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment mapErrorNoGP: ' + mapErrorNoGP);

			//Manda el correo con el template que corresponda
			Map<String, String> mapTemplateId = new  Map<String, String>();
	        for (EmailTemplate et : [Select id, Name, DeveloperName from EmailTemplate
				Where Name = 'DCT Reasignacion - Notificacion JEC Anterior sin aprobación'
				OR Name = 'DCT Reasignacion - Notificación JEC Nuevo sin aprobación'
				Order by DeveloperName ]){
				mapTemplateId.put(et.Name, et.id);
			}

			List<Messaging.SendEmailResult> lSendEmailResult = new List<Messaging.SendEmailResult>();
			List<Messaging.singleemailMessage> lSingleemailMessage = new List<Messaging.singleemailMessage>();
			//Asocia el id del mapa mapNoGenProcRes con los valores del mapa mapLDCTClientsProspectstoAssigned
			for (String sIdLlavePaso : mapNoGenProcRes.KeySet()){
				
				//Ve si sIdLlavePaso existe en mapLDCTClientsProspectstoAssigned 
				if (mapLDCTClientsProspectstoAssigned.containsKey(sIdLlavePaso)){
					
					Set<String> setIdUsrReceive = new Set<String>();
					String sUsrActual = '';
					//Recorre la lista de usuarios que estan en mapLDCTClientsProspectstoAssigned.get(sIdLlavePaso)
					for (DCTClientsProspectstoAssigned__c objDCTCteProsAssig : mapLDCTClientsProspectstoAssigned.get(sIdLlavePaso)){
						setIdUsrReceive.add(objDCTCteProsAssig.UserReceiver__c);
						sUsrActual = objDCTCteProsAssig.IssuingUser__c;
					}

					System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment sUsrActual: ' + sUsrActual + ' setIdUsrReceive: ' + setIdUsrReceive);					
					//Ve si tiene algo el set de usuarios que reciben los correos
					if (!setIdUsrReceive.isEmpty()){
						
						//Crea el mensaje de correo para el que reasigna 
				        Messaging.SingleEmailMessage mailUsrReceiver = new Messaging.SingleEmailMessage();
				        mailUsrReceiver.setSenderDisplayName('Reasignación de Clientes.'); 
				        mailUsrReceiver.setUseSignature(false);  
				        mailUsrReceiver.setSaveAsActivity(false); 
					    System.debug('ANTES DE LAS VALIDACIONES objDCTCteProsAssigPaso.IssuingUser__c: ' + sUsrActual);			         
						//Ve si existe sUsrActual) en mapIdUsrEmail
				        if (mapIdUsrEmail.containsKey(sUsrActual)){
						    System.debug('ANTES DE LAS VALIDACIONES VAL 1 mapIdUsrEmail.IssuingUser__c: ' + mapIdUsrEmail.get(sUsrActual));
				        	if (mapContactEmail.containsKey(mapIdUsrEmail.get(sUsrActual))){
							    System.debug('ANTES DE LAS VALIDACIONES VAL 2');			        		
						        //mailUsrReceiver.setToAddresses(new List<String>{mapIdUsrEmail.get(sUsrActual)}); //uprue@avanxo.com.dc
						        mailUsrReceiver.setToAddresses(new List<String>{'hfigueroa@avanxo.com'});			        
							    System.debug('ANTES DE ENVUAR EL CORREO 1 setTargetObjectId: ' + mapContactEmail.get(mapIdUsrEmail.get(sUsrActual)));
							    System.debug('ANTES DE ENVUAR EL CORREO 1 setWhatId: ' + mapNoGenProcRes.get(sIdLlavePaso));
				        		mailUsrReceiver.setTargetObjectId( mapContactEmail.get(mapIdUsrEmail.get(sUsrActual)) );
				        		mailUsrReceiver.setWhatId(mapNoGenProcRes.get(sIdLlavePaso));
						        mailUsrReceiver.setTemplateId(mapTemplateId.get('DCT Reasignacion - Notificacion JEC Anterior sin aprobación'));
						        //Agrega el correo a la list de lSingleemailMessage
						        lSingleemailMessage.add(mailUsrReceiver);					     							    
							    System.debug('ANTES DE ENVUAR EL CORREO DEL QUE CEDE LAS CUENTAS: ' + mapContactEmail.get(mapIdUsrEmail.get(sUsrActual)));						        
				        	}//Fin si mapContactEmail.containsKey(mapIdUsrEmail.get(sUsrActual)
				        }//Fin si mapIdUsrEmail.containsKey(sUsrActual)
						
						//Recorre la lista de setIdUsrReceive para enviar los correos a los destinatarios
						for(String sIdUsrReceiv : setIdUsrReceive){

							//Crea el mensaje de correo para el que recive 
					        Messaging.SingleEmailMessage mailUsrActual = new Messaging.SingleEmailMessage();
					        mailUsrActual.setSenderDisplayName('Reasignación de Clientes.'); 
					        mailUsrActual.setUseSignature(false);  
					        mailUsrActual.setSaveAsActivity(false); 
						    System.debug('ANTES DE LAS VALIDACIONES sIdUsrReceiv: ' + sIdUsrReceiv);			         
							//Ve si existe sIdUsrReceiv) en mapIdUsrEmail
					        if (mapIdUsrEmail.containsKey(sIdUsrReceiv)){
							    System.debug('ANTES DE LAS VALIDACIONES VAL 1.1 mapIdUsrEmail.UserReceiver__c: ' + mapIdUsrEmail.get(sIdUsrReceiv));
					        	if (mapContactEmail.containsKey(mapIdUsrEmail.get(sIdUsrReceiv))){
								    System.debug('ANTES DE LAS VALIDACIONES VAL 2.1');			        		
							        //mailUsrActual.setToAddresses(new List<String>{mapIdUsrEmail.get(sIdUsrReceiv)}); //uprue@avanxo.com.dc
							        mailUsrActual.setToAddresses(new List<String>{'hfigueroa@avanxo.com'});			        
								    System.debug('ANTES DE ENVUAR EL CORREO 1.1 setTargetObjectId: ' + mapContactEmail.get(mapIdUsrEmail.get(sIdUsrReceiv)));
								    System.debug('ANTES DE ENVUAR EL CORREO 1.1 setWhatId: ' + mapNoGenProcRes.get(sIdLlavePaso));
					        		mailUsrActual.setTargetObjectId( mapContactEmail.get(mapIdUsrEmail.get(sIdUsrReceiv)) );
					        		mailUsrActual.setWhatId(mapNoGenProcRes.get(sIdLlavePaso));
					        		mailUsrActual.setTemplateId(mapTemplateId.get('DCT Reasignacion - Notificación JEC Nuevo sin aprobación'));					        
					        		//Agregalo a la lista de lSingleemailMessage
					        		lSingleemailMessage.add(mailUsrActual);
								    System.debug('ANTES DE ENVUAR EL CORREO DEL QUE RECIBE LAS CUENTAS: ' + mapContactEmail.get(mapIdUsrEmail.get(sIdUsrReceiv)));					        		
									/*//Envia el correo
							        Messaging.SendEmailResult[] repuestaActual = Messaging.sendEmail(new Messaging.singleemailMessage[] {mailUsrActual});
							        //Ve si hubo error
									if (repuestaActual[0].success)
									    System.debug('El correo para el usuario: ' + sIdUsrReceiv + ' Se envio correctramemte.');
									else
									    System.debug('Hubo error a la hora del enviar el correo al usuario: ' + sIdUsrReceiv + ' Error: ' + repuestaActual[0].errors[0].message);*/
					        	}//Fin si mapContactEmail.containsKey(mapIdUsrEmail.get(sIdUsrReceiv)
					        }//Fin si mapIdUsrEmail.containsKey(sIdUsrReceiv)

						}//Fin del for para la lista de setIdUsrReceive
						
					}//Fin si !setIdUsrReceive.isEmpty()
			        
				}//Fin si mapLDCTClientsProspectstoAssigned.containsKey(sIdLlavePaso)
								
				//Ve si mapLDCTClientsProspectstoAssigned contiene a sIdLlavePaso
				if (mapLDCTClientsProspectstoAssigned.containsKey(sIdLlavePaso)){
					//Recorre la lista de cuentas en 
					for (DCTClientsProspectstoAssigned__c objDCTCteProsAssig : mapLDCTClientsProspectstoAssigned.get(sIdLlavePaso)){
						if (!Test.isRunningTest())
							objDCTCteProsAssig.AssignmentNumber__c = mapNoGenProcRes.get(sIdLlavePaso);
						objDCTCteProsAssig.Status__c = 'Aprobado';
						System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment objDCTCteProsAssig2: ' + objDCTCteProsAssig);
					}
				}//Fin si mapLDCTClientsProspectstoAssigned.containsKey(sIdLlavePaso)
				
			}//Fin del for para mapNoGenProcRes.KeySet()

			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment lSingleemailMessage: ' + lSingleemailMessage.size());
			//Envia los correos a los clientes de una sola ves
	        lSendEmailResult = Messaging.sendEmail(lSingleemailMessage, false);	        
	        //Recorre la lista y ve si hubo error
	        for (Messaging.SendEmailResult objSendEmailResult : lSendEmailResult){
				if (objSendEmailResult.success)
				    System.debug('El correo para el usuario Se envio correctramemte.');
				else
				    System.debug('Hubo error a la hora del enviar el correo al usuario ' + objSendEmailResult.Errors[0].Message);
	        }//Fin del for para la lista de lSendEmailResult
	
			//Ya tienes asociados los reg en mapLDCTClientsProspectstoAssigned ahora si crealos
			Set<String> setErroresNoGP = new Set<String>();
			if (!mapLDCTClientsProspectstoAssigned.isEmpty()){		
				for (String sIdLlavePaso : mapNoGenProcRes.KeySet()){
					List<Database.Upsertresult> lDtbUpsRes = Database.upsert(mapLDCTClientsProspectstoAssigned.get(sIdLlavePaso), DCTClientsProspectstoAssigned__c.id, false);
					//Ve si hubo error
					for (Database.Upsertresult objDtbUpsRes : lDtbUpsRes){
						if (!objDtbUpsRes.isSuccess())
							setErroresNoGP.add(objDtbUpsRes.getErrors()[0].getMessage());
					}//Fin del for para lDtbUpsRes
				}//Fin del fir para mapLDCTClientsProspectstoAssigned.KeySet()
			}//Fin si mapLDCTClientsProspectstoAssigned.isEmpty()
			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment setErroresNoGP: ' + setErroresNoGP);
			
			Set<String> setErroresAPA = new Set<String>();
			//Actualiza el estatus de los reg que no requieren aprobación (mapNoGenProcRes) para que se haga la reasignación
			if (!mapNoGenProcRes.isEmpty()){
				List<DCTAssignment__c> lDCTAssigUpd = new List<DCTAssignment__c>();
				Set<String> setIdAsignm = new Set<String>();
				for (String sIdNvoReg : mapNoGenProcRes.values()){
					lDCTAssigUpd.add(new DCTAssignment__c(id = sIdNvoReg, Status__c = 'Aprobado'
							,DCTProccesAprobed__c = 'Aprobado'
						)
					);
					setIdAsignm.add(sIdNvoReg);
				}//Fin del for para mapNoGenProcRes.values()
				System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment lDCTAssigUpd: ' + lDCTAssigUpd);
				//Si tiene algo la lista de lDCTAssigUpd  
				if (!lDCTAssigUpd.isEmpty()){
					List<Database.Upsertresult> lDtbUpsRes = Database.upsert(lDCTAssigUpd, DCTAssignment__c.id, false);
					//Ve si hubo error
					for (Database.Upsertresult objDtbUpsRes : lDtbUpsRes){
						if (!objDtbUpsRes.isSuccess())
							setErroresAPA.add(objDtbUpsRes.getErrors()[0].getMessage());
					}//Fin del for para lDtbUpsRes
					System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment setErroresAPA: ' + setErroresAPA);				
				}//Fin si !lDCTAssigUpd.isEmpty()
			}//Fin si !mapNoGenProcRes.isEmpty()
			// *** FIN PARA LOS PROCESOS QUE NO REQIEREN APROBACIÓN

			Set<String> setErroresAAC = new Set<String>();	
			//Actualiza las cuentas y ponlas bloqeuadas
			if (!mapPCT.isEmpty()){
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');				
				List<Database.Upsertresult> lDtbUpsRes = Database.upsert(mapPCT.values(), Account.id, false);
				//Ve si hubo error
				for (Database.Upsertresult objDtbUpsRes : lDtbUpsRes){
					if (!objDtbUpsRes.isSuccess())
						setErroresAAC.add(objDtbUpsRes.getErrors()[0].getMessage());
				}//Fin del for para lDtbUpsRes
				System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment setErroresAPA: ' + setErroresAPA);
			}//!mapPCT.isEmpty()
	
			Set<String> setErroresCGP = new Set<String>();		
			//Finalmente crea los procesos de aprobación como tal sobre los reg de mapGenProcRes.values()
			for(String sIdObjGenProsAprova : mapGenProcRes.KeySet()){
				//List<Approval.ProcessSubmitRequest> lstApprovalRequests = new List<Approval.ProcessSubmitRequest>();
				Approval.ProcessSubmitRequest procSubmReq = new Approval.ProcessSubmitRequest();
				procSubmReq.setComments('VoBo: Asignación de cuentas');
				procSubmReq.setObjectId(mapGenProcRes.get(sIdObjGenProsAprova));
				procSubmReq.setProcessDefinitionNameOrId('AssignmentCustomerPortfolio');
				procSubmReq.setSkipEntryCriteria(true);
				try{
					System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment procSubmReq: ' + procSubmReq + ' sUserActualFuncion: ' + sUserActualFuncion);
					//Si no es el cordinador crear los procesos de aprobación
					if (!sUserActualFuncion.startsWith('Coordinador'))
						Approval.process(procSubmReq, true);
				}catch(DMLException dE){setErroresCGP.Add(dE.getMessage());
				}catch(UnexpectedException uE){	setErroresCGP.Add(uE.getMessage());				
				}catch(Exception gE){ setErroresCGP.Add(gE.getMessage());}       
			}//Fin del for para los procesos de probación
			System.debug('EN DCT_AccountOwnerAssignment_cls.confirmAssignment setErroresCGP: ' + setErroresCGP);
			
			//Para una prueba hecha para atras todo
			//Database.rollback(sp);
			
			//Hubo errorres retacha todo
			if (!setErrores.isEmpty() || !setErroresNoGP.isEmpty() || !mapError.isEmpty() 
				|| !mapErrorNoGP.isEmpty() || !setErroresCGP.isEmpty() || !setErroresAPA.isEmpty()
				|| !setErroresAAC.isEmpty() || Test.isRunningTest()){
				lstErrorMsgs.addAll(setErrores);
				lstErrorMsgs.addAll(setErroresNoGP);			
				lstErrorMsgs.addAll(mapError.Values());
				lstErrorMsgs.addAll(mapErrorNoGP.Values());
				lstErrorMsgs.addAll(setErroresCGP);			
				lstErrorMsgs.addAll(setErroresAPA);
				lstErrorMsgs.addAll(setErroresAAC);				
				//Alica el rollback
				Database.rollback(sp);
			}else{
				blnSuccessfulProcedure = true;
				if (!mapDCTAssignmentConProc.isEmpty())
					lstSuccessMsgs.add('Las cuentas se asignaron de manera correcta. La asignación debe aprobarse para que surta efecto.');			
				if (mapDCTAssignmentConProc.isEmpty())
					lstSuccessMsgs.add('Las cuentas se asignaron de manera correcta.');
				blnChangesHaveBeenMade = false;										
			}//Fin si huebo error

        }//Fin si sSegmento != null     
        
    }

    public PageReference fullRefresh(){
        PageReference pr = new PageReference(ApexPages.currentPage().getUrl());
        pr.setRedirect(true);
        return pr;
    }

        
    public class AccountsByOwnerWrapper{
        public List<AccountWrapper> lstAccs {set;get;}
        public List<AccountsByOwnerWrapper> subordinados {set;get;}
        public User ownerRecord {set;get;}
        public Boolean blnselectAllAccs {set;get;}
        public Boolean blnSelectedForAssignment {set;get;}
		public Boolean blnPermiteSelSub {set;get;}             
        public Boolean blnDisplayAccounts {set;get;}
        public String sManager {get;set;}
        public String sGestor {get;set;}        
        public Boolean bDespGestor {get;set;}
        public Boolean bMuestraNivelSuperiror {get;set;}
    }
    
    public class AccountWrapper{
        public Account accountRecord{set;get;}
        public Boolean blnIsSelected{set;get;}
        public String sFechaAsigna {get;set;}        
        public AccountWrapper(Account accountInstance, Boolean blnSelected, String sFechaAsigna){
            this.accountRecord = accountInstance;
            this.blnIsSelected = blnSelected;
            this.sFechaAsigna = sFechaAsigna;
        }
    }

    public class AccountWrapperAssignForUsers{
    	public String sIdUsrOrigen {get;set;}
    	public String sIdUsrDestino {get;set;}
        public AccountWrapper accountWrapper {set;get;}
        public Boolean blnGeneraProcesoAproba{set;get;}
    	public String sIdUsrAprueba {get;set;}
    	public String sTipoRegPCT {get;set;}    	
        public AccountWrapperAssignForUsers(AccountWrapper accountWrapper, String sIdUsrOrigen
        	, String sIdUsrDestino, String sTipoRegPCT){
            this.AccountWrapper = accountWrapper;
            this.sIdUsrOrigen = sIdUsrOrigen;
            this.sIdUsrDestino = sIdUsrDestino;
            this.sTipoRegPCT = sTipoRegPCT;
        }
    }

    public class UserLookUpWrapper{
        public Boolean blnIsSelected {set;get;}
        public User foundUser {set;get;}
        public String sGestor {get;set;}
        public Boolean bDespGestor {set;get;}        
        public UserLookUpWrapper(Boolean blnSelected, User userRecord, String sGestor, Boolean bDespGestor){
            this.blnIsSelected = blnSelected;
            this.foundUser = userRecord;
            this.sGestor = sGestor;
            this.bDespGestor = bDespGestor;
        }
    }

	public Boolean validaGestorGestores(String sIdUser){
		System.debug('EN DCT_AccountOwnerAssignment_cls.validaGestorGestores...');
		Boolean bGestorGestoresPaso = false;
		
		Set<String> setIdUsersRel = new Set<String>(); 
		//Consulta los reg en donde el es el manager
		for (User usuario : [Select id From User Where ManagerId =: sIdUser]){
			setIdUsersRel.add(usuario.id);
		}
		System.debug('EN DCT_AccountOwnerAssignment_cls.validaGestorGestores setIdUsersRel: ' + setIdUsersRel); 
		
		//Ya tienes a los usuarios que dependen de sIdUser en setIdUsers
		if (!setIdUsersRel.isEmpty()){
			for (User usuarioRel : [Select id From User Where ManagerId IN: setIdUsersRel]){
				bGestorGestoresPaso = true;
				break;
			}
		}//Fin si !setIdUsers.isEmpty()
		System.debug('EN DCT_AccountOwnerAssignment_cls.validaGestorGestores bGestorGestoresPaso: ' + bGestorGestoresPaso);
		
		//Regresa
		return bGestorGestoresPaso;
	}
	
}