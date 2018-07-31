public class DCT_Product_ctr {
	
	public User objUsrActual = [Select Id, DCTXO__c, DCTVT__c From User Where id =:UserInfo.getUserId()];
	
    public DCTDirectoryProductRelationship__c       DCTnewProduct {get; set;}
    public DCTAuthorizedLines__c                    dctNewLine    {get; set;}
    public List<DirectorioProducosSeleccionados__c> lstProdSelecc    {get; set;}
    public List<DCTAuthorizedLines__c>              lstDCTPlan    {get; set;}
    public String                                   idRecord      {get; set;}
    public Boolean                                  blnIsOnclick  {get; set;}
    public Boolean                                  blnIsOnclick2 {get; set;}
    public SObject                                  recordDC      {get; set;}
	public Set<String> setIdProdExist {get;set;}    
    public String slConsecCons {get;set;}
    public Map<String,Map<String,RecordType>> mapRTsByDevName {get;set;}
    public String idRecodPlan {get;set;}
    
    public List<SelectOption> slTipoMercado {get;set;} 
    public String sTipoMercado {get;set;}
    public String sTipoMercadoDesc {get;set;}    
    public Map<String, DCT_TelcelPlanesSoap_ws.planMercado> mapTipoMercado {get;set;}
        
    public List<SelectOption> slGrupoPlan {get;set;} 
    public String sGrupoPlan {get;set;}
    //public Map<String, DCT_TelcelPlanesSoap_ws.grupoPlanMercado> mapGruposPlanes {get;set;}
    public Map<String, DCT_CorporativoPlanesWs.GrupoPlan> mapGruposPlanes {get;set;}

    public List<SelectOption> selPlazos {get;set;} 
    public String sPlazos {get;set;}
    //public Map<String, DCT_TelcelPlanesSoap_ws.planPlazoMercado> mapPlazos {get;set;}
    public Map<String, DCT_CorporativoPlanesWs.Plazo> mapPlazos {get;set;}

    public List<SelectOption> selPlanes {get;set;} 
    public String sPlanes {get;set;}
    //public Map<String, DCT_TelcelPlanesSoap_ws.planPlazoM2K> mapPlanes {get;set;}
    public Map<String, DCT_CorporativoPlanesWs.Plan> mapPlanes {get;set;}

    public List<SelectOption> selTarifas {get;set;} 
    public String sTarifas {get;set;}

    public List<SelectOption> selGuiaPlanes {get;set;} 
    public String sGuiaPlanes {get;set;}
    public Map<String, DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO> mapGuiaPlanes {get;set;}
    
    public String sError {get;set;}
    public Boolean bErrorIns {get;set;}    
    
    public Cliente__c DirComFzaVta {get;set;}
    public Set<String> setIdFzaVtas {get;set;}
    public String sProductoBusqueda {get;set;}
    public List<Product2> lProductos {get;set;}
    public List<wrpProductoSelecionados> lwrpProductoSelecionados {get;set;} 
    public String provId {get;set;}
    
    public DCT_Product_ctr(ApexPages.StandardController stdCtr){
    	System.debug('EN DCT_Product_ctr...');
    	
    	lstDCTPlan = new List<DCTAuthorizedLines__c>();
    	setIdProdExist = new Set<String>();
    	lstProdSelecc = new List<DirectorioProducosSeleccionados__c>();
    	DirComFzaVta = new Cliente__c();
    	setIdFzaVtas = new Set<String>();
		lProductos = new List<Product2>();
		lwrpProductoSelecionados = new List<wrpProductoSelecionados>();
		    	
        idRecord = stdCtr.getid();
        recordDC = stdCtr.getRecord();
		
		//Agrega la fuerza de ventas del usuario
		if (objUsrActual.DCTVT__c != null)
			setIdFzaVtas.add(objUsrActual.DCTVT__c);
		//Busca los datos de 
		for (Cliente__c DircCom : [Select c.DCTSharedTreatment__c, 
				c.DCT_CatalogoFuerzaVenta__c, 
				c.DCT_CatalogoFuerzaVenta__r.Name, 
				c.DCTCatalogoFuerzaVenta2__c, 
				c.DCTCatalogoFuerzaVenta2__r.Name,
				c.DCTStatus__c
				From Cliente__c c Where id =:idRecord]){
			DirComFzaVta = DircCom;
			if  (DircCom.DCT_CatalogoFuerzaVenta__c != null)
				setIdFzaVtas.add(DircCom.DCT_CatalogoFuerzaVenta__r.Name);
			if  (DircCom.DCTCatalogoFuerzaVenta2__c != null)
				setIdFzaVtas.add(DircCom.DCTCatalogoFuerzaVenta2__r.Name);			
		}
    	System.debug('EN DCT_Product_ctr setIdFzaVtas: ' + setIdFzaVtas);
    			
		//Inicializa el resto de las varuiables
        mapRTsByDevName = TLCL_Utils_cls.getRecordTypes('DeveloperName');
        String idRecodPlan = mapRTsByDevName.get('DCTAuthorizedLines__c').get('DCTPlan').id;
        System.debug(loggingLevel.Error, '*** idRecord: ' + idRecord);
        System.debug(loggingLevel.Error, '*** idRecodPlan: ' + idRecodPlan);
		
		/*//Ve por los productos asociados al directorio
		for (DCTDirectoryProductRelationship__c objPaso : [
				SELECT id, Name, DCTProduct__r.Name, 
					DCTProduct__r.DCTKey__c, 
					DCTProduct__r.ServiceID__c, 
					DCTProduct__r.Family,
					DCTProduct__c
				FROM DCTDirectoryProductRelationship__c 
				WHERE DCTCommercialDirectory__c =:idRecord And DCTProduct__c != null
				ORDER BY Name
			]){
			//Agrega los reg a lstDirProd
			lstDirProd.add(objPaso);
			setIdProdExist.add(objPaso.DCTProduct__c);
		}
        System.debug('EN DCT_Product_ctr lstDirProd: ' + lstDirProd);*/

		//Ve por los productos asociados al directorio
		for (DirectorioProducosSeleccionados__c objPaso : [SELECT id, Producto__c, Producto__r.Name, 
				Producto__r.Family, Producto__r.Description, Producto__r.DCT_IsSpecialProduct__c,
				Producto__r.DCTKey__c  
				From DirectorioProducosSeleccionados__c p Where Producto__r.isActive = true
				And Prospecto__c =: idRecord And Producto__c != null 
				ORDER BY Name
			]){
			//Agrega los reg a lstProdSelecc
			lstProdSelecc.add(objPaso);
			setIdProdExist.add(objPaso.Producto__c);
		}
        System.debug('EN DCT_Product_ctr lstProdSelecc: ' + lstProdSelecc);
        
        DCTnewProduct = new DCTDirectoryProductRelationship__c(
            DCTCommercialDirectory__c = stdCtr.getid()
        );

        //Busca las lineas autorizads
        for(DCTAuthorizedLines__c objPaso : [SELECT id,
	                Clave__c, 
	                Name, 
	                DCTLineType__c, 
	                DCTPlanType__c, 
	                DCTTerm__c, 
	                DCTPlan__c, 
	                Plan__c,
	                DCTHideAdditionalServices__c,
	                Plan__r.ClaveTarifa__c,
	                DCT_Tarifa__c,
	                Status__c
	            FROM DCTAuthorizedLines__c
	            WHERE CommercialDirectory__c = :idRecord 
	            AND RecordTypeId =  :idRecodPlan
	            And Plan__c != null And Status__c != 'Rechazado'  
	            ORDER BY CreatedDate ASC
	        ]){
			lstDCTPlan.add(objPaso);			
        }        
        
        dctNewLine = new DCTAuthorizedLines__c (
            CommercialDirectory__c = idRecord
        );
        
        blnIsOnclick = false;
        bErrorIns = false;
        
        system.debug('DCTnewProduct: '+DCTnewProduct);
        System.debug(loggingLevel.Error, '*** dctNewLine: ' + dctNewLine);
        
        //Inicializa las variables para el nuevo plan
        slTipoMercado = new List<SelectOption>();
        mapTipoMercado = new Map<String, DCT_TelcelPlanesSoap_ws.planMercado>();
        //slTipoMercado.add(new SelectOption('' , '--Ninguno--'));

        slGrupoPlan = new List<SelectOption>();
        //mapGruposPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.grupoPlanMercado>();
        mapGruposPlanes = new Map<String, DCT_CorporativoPlanesWs.GrupoPlan>();        
        slGrupoPlan.add(new SelectOption('' , '--Ninguno--'));
        
        selPlazos = new List<SelectOption>();
        //mapPlazos = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoMercado>();
		mapPlazos = new Map<String, DCT_CorporativoPlanesWs.Plazo>();        
        selPlazos.add(new SelectOption('' , '--Ninguno--'));

        selPlanes = new List<SelectOption>();
        //mapPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoM2K>();
        mapPlanes = new Map<String, DCT_CorporativoPlanesWs.Plan>();
        selPlanes.add(new SelectOption('' , '--Ninguno--'));

	    selTarifas = new List<SelectOption>(); 
        selTarifas.add(new SelectOption('' , '--Ninguno--'));

        selGuiaPlanes = new List<SelectOption>();
        mapGuiaPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO>();
        selGuiaPlanes.add(new SelectOption('' , '--Ninguno--'));        
        
    }

    public PageReference buscaProducto(){
        System.debug('EN buscaProducto....');
        
        lProductos.clear();
        List<String> lNomProdGene = new List<String>();
        List<String> lNomProdEsp = new List<String>();
        List<String> lNomProdFinales = new List<String>();        
        Map<String, Product2> mapProduct2Gen = new Map<String, Product2>();
        Map<String, DCTDirectoryProductRelationship__c> mapProduct2Esp = new Map<String, DCTDirectoryProductRelationship__c>();
        blnIsOnclick = false;
		        
		List<Product2> lProdGenPaso = new List<Product2>();		
		List<DCTDirectoryProductRelationship__c> lProdEspPaso = new List<DCTDirectoryProductRelationship__c>();
		lwrpProductoSelecionados.clear();

		sProductoBusqueda = sProductoBusqueda.trim();
        System.debug('EN buscaProducto sProductoBusqueda: ' + sProductoBusqueda);
		//Ve si capturo algo en el campo de sProductoBusqueda
		if (sProductoBusqueda == null || sProductoBusqueda == ''){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Debes capturar un valor para buscar productos.'));
			return null;			
		}//Fin si sProductoBusqueda == null
		                     
		//Cosulta los productos asociados a sProductoBusqueda
		if (sProductoBusqueda != null){
			
			//Productos varios
	        String strConsulta = 'SELECT p.id, p.Name, p.Family, p.Description, p.DCT_IsSpecialProduct__c, ' +
	        	' p.DCTKey__c ' +
  	        	' From Product2 p Where p.DCT_IsSpecialProduct__c = false and isActive = true ' +
	        	' And Name like \'%' + sProductoBusqueda + '%\'';
			System.debug('ENTRO A DCT_Product_ctr.buscaProducto strConsulta1: ' + strConsulta);		        	
       		try{
       			lProdGenPaso = Database.query(strConsulta);
       			if (!lProdGenPaso.isEmpty()){
       				for (Product2 prodcutoGen : lProdGenPaso){
       					lNomProdFinales.add(prodcutoGen.Name);
       					mapProduct2Gen.put(prodcutoGen.Name, prodcutoGen);       					
       				}
       			}
				if (lNomProdFinales.isEmpty())
					lNomProdFinales.sort();
				System.debug('ENTRO A DCT_Product_ctr.buscaProducto lNomProdGene: ' + lNomProdFinales);					
       		}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}

			//Productos especiales
	        strConsulta = 'SELECT DCTProduct__r.Name, DCTProduct__r.Family, DCTProduct__r.Description, ' +
	        	' DCTProduct__r.DCT_IsSpecialProduct__c, DCTProduct__r.DCTKey__c  ' +	        
  	        	' From DCTDirectoryProductRelationship__c p ' +
  	        	' Where DCTProduct__r.isActive = true And DCTProduct__r.DCT_IsSpecialProduct__c = true ' +
   	        	' And DCTProduct__r.Name like \'%' + sProductoBusqueda + '%\' ' +
   	        	' And DCTCommercialDirectory__c = \'' + idRecord + '\'';      	
			System.debug('ENTRO A DCT_Product_ctr.buscaProducto strConsulta2: ' + strConsulta);		        	
       		try{
        		lProductos.clear();       			
       			lProdEspPaso = Database.query(strConsulta);
       			if (!lProdEspPaso.isEmpty()){
       				for (DCTDirectoryProductRelationship__c prodcutoEsp : lProdEspPaso){
       					lNomProdFinales.add(prodcutoEsp.DCTProduct__r.Name);
       					mapProduct2Esp.put(prodcutoEsp.DCTProduct__r.Name, prodcutoEsp);       					
       				}
       			}
				if (lNomProdFinales.isEmpty())
					lNomProdFinales.sort();
				System.debug('ENTRO A DCT_Product_ctr.buscaProducto lNomProdEsp: ' + lNomProdFinales);					
       			
       			//Ya tienes los prudctos ordenados en las dos listas metelos a la tercea
       		}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
			
			//si tiene algo la lista de  lProductos
			if (!lNomProdFinales.isEmpty()){
				for (String sProducto : lNomProdFinales){
					System.debug('ENTRO A DCT_Product_ctr.buscaProducto sProducto: ' + sProducto);					
					//Buscalo en el mapa de mapProduct2Gen
					if (mapProduct2Gen.containsKey(sProducto)){
						if ( !setIdProdExist.contains(mapProduct2Gen.get(sProducto).id) ){
							Product2 Product2Paso = mapProduct2Gen.get(sProducto);
							lwrpProductoSelecionados.add(new wrpProductoSelecionados(Product2Paso, false));
						}//Fin si !setIdProdExist.contains(mapProduct2Gen.get(sProducto).id)
					}//Fin si mapProduct2Gen.containsKey(sProducto)
					//Buscalo en el mapa de mapProduct2Gen
					if (mapProduct2Esp.containsKey(sProducto)){
						if ( !setIdProdExist.contains(mapProduct2Esp.get(sProducto).DCTProduct__r.id) ){						
							Product2 Product2Paso = mapProduct2Esp.get(sProducto).DCTProduct__r;
							lwrpProductoSelecionados.add(new wrpProductoSelecionados(Product2Paso, false));
						}//Fin si !setIdProdExist.contains(mapProduct2Gen.get(sProducto).id)
					}//Fin si mapProduct2Esp.containsKey(sProducto)
				}//Fin del for para lNomProdFinales
			}//Fin si !lProductos.isEmpty()
			
			//Ve si no existen productos para asociar
			if (lwrpProductoSelecionados.isEmpty())
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No se encontrarón productos con este criterio ó ya estan asignados a este cliente'));
						
		}//Fin si sProductoBusqueda != null
		
        System.debug('ANTES DE SALIR DE lwrpProductoSelecionados: ' + lwrpProductoSelecionados);
        //Solo null
        return null;
    }   
	
	public class wrpProductoSelecionados{
		public Product2 producto {get;set;}
		public Boolean bSelect {get;set;}
		
		public wrpProductoSelecionados(){
			this.producto = new Product2();
			this.bSelect = false;
		}				
		
		public wrpProductoSelecionados(Product2 producto, Boolean bSelect){
			this.producto = producto;
			this.bSelect = bSelect;
		}				
	}

    public PageReference saveProduct(){
        System.debug('EN DCT_Product_ctr.DCTnewProduct: '+ DCTnewProduct);
		
		List<DirectorioProducosSeleccionados__c> lProdAsociados = new List<DirectorioProducosSeleccionados__c>();	
		Boolean bNoSelProd = false;	
		Boolean bErrorInsProd = false;		
		//Ve si selecciono algun producto
		if  (!lwrpProductoSelecionados.isEmpty()){
			for (wrpProductoSelecionados prodSel : lwrpProductoSelecionados){
				if (prodSel.bSelect){
					bNoSelProd = true;
					//Metelo al objeto de DirectorioProducosSeleccionados__c
					lProdAsociados.add(new DirectorioProducosSeleccionados__c(Name = prodSel.producto.Name,
							Producto__c = prodSel.producto.id, Prospecto__c = idRecord
						)
					);
				}//Fin si prodSel.bSelect
			}//Fin del for para lwrpProductoSelecionados
		}//Fin si !lwrpProductoSelecionados.isEmpty()

		//Ve si tiene productos que asociar
		if (!lProdAsociados.isEmpty()){
			List<Database.Saveresult> lObjDburDc = DataBase.insert(lProdAsociados, true);
			for (Database.Saveresult objDbur : lObjDburDc){
				if (!objDbur.isSuccess()){
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error al asociar el producto: ' + objDbur.getErrors()[0].getMessage()));					
					System.debug('Error al asociar el producto: ' + objDbur.getErrors()[0].getMessage());
					bErrorInsProd = true;
					return null;
				}//Fin si !objDbur.isSuccess()
			}//Fin del for para lObjDburDc			
		}//Fin si !lProdAsociados.isEmpty()
		
		//Si no selecciono ningun producto
		if (!bNoSelProd){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Debes seleccionar al menos un producto.'));
			return null;
		}//Fin si !bNoSelProd

		if (!bErrorInsProd){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'La información se actualizó con éxito.'));
			//Limpia las variables
			sProductoBusqueda = null;			
			blnIsOnclick2 = false;
			lProductos = new List<Product2>();
			lwrpProductoSelecionados = new List<wrpProductoSelecionados>();
			
			//Actualiza la lista de productos asociados
	    	lstProdSelecc = new List<DirectorioProducosSeleccionados__c>();
    		setIdProdExist = new Set<String>();
			//Ve por los productos asociados al directorio
			for (DirectorioProducosSeleccionados__c objPaso : [SELECT id, Producto__c, Producto__r.Name, 
					Producto__r.Family, Producto__r.Description, Producto__r.DCT_IsSpecialProduct__c,
					Producto__r.DCTKey__c 
					From DirectorioProducosSeleccionados__c p Where Producto__r.isActive = true
					And Prospecto__c =: idRecord And Producto__c != null 
					ORDER BY Name
				]){
				//Agrega los reg a lstProdSelecc
				lstProdSelecc.add(objPaso);
				setIdProdExist.add(objPaso.Producto__c);
			}
	        System.debug('EN DCT_Product_ctr lstProdSelecc: ' + lstProdSelecc);
			
			//Solo null
			return null;
		}//Fin si !bNoSelProd
		
		//Solo null		
		return null;   
        
    }

    public PageReference eliminarProducto(){
        System.debug('EN eliminarProducto provId: ' + provId);

		//Ve si tiene algo provId 
		if (provId != null && provId != ''){
			DirectorioProducosSeleccionados__c productoDel = new DirectorioProducosSeleccionados__c(id = provId); 

			Database.Deleteresult objDburDc = DataBase.delete(productoDel, true);
			if (!objDburDc.isSuccess()){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error al eliminar el producto: ' + objDburDc.getErrors()[0].getMessage()));					
				System.debug('EN eliminarProducto Error al eliminar el producto: ' + objDburDc.getErrors()[0].getMessage());
				return null;
			}//Fin si !objDbur.isSuccess()
			
			//Actualiza la lista de productos asociados
	    	lstProdSelecc = new List<DirectorioProducosSeleccionados__c>();
    		setIdProdExist = new Set<String>();
			//Ve por los productos asociados al directorio
			for (DirectorioProducosSeleccionados__c objPaso : [SELECT id, Producto__c, Producto__r.Name, 
					Producto__r.Family, Producto__r.Description, Producto__r.DCT_IsSpecialProduct__c,
					Producto__r.DCTKey__c 
					From DirectorioProducosSeleccionados__c p Where Producto__r.isActive = true
					And Prospecto__c =: idRecord And Producto__c != null 
					ORDER BY Name
				]){
				//Agrega los reg a lstProdSelecc
				lstProdSelecc.add(objPaso);
				setIdProdExist.add(objPaso.Producto__c);
			}
	        System.debug('EN eliminarProducto lstProdSelecc: ' + lstProdSelecc);

		}//Fin si provId != null && provId != ''
		
        //Solo null
        return null;
    }   

    public PageReference cancelarBusqueda(){
        System.debug('EN cancelarBusqueda....');

		//Limpia las variables
		sProductoBusqueda = null;
		blnIsOnclick2 = false;
		lProductos = new List<Product2>();
		lwrpProductoSelecionados = new List<wrpProductoSelecionados>();        

        //Solo null
        return null;
    }   

    public PageReference cancelarNuevoPlan(){
        System.debug('EN cancelarNuevoPlan....');

		//Limpia las variables
        blnIsOnclick = false;
        bErrorIns = false;
        
        system.debug('DCTnewProduct: '+DCTnewProduct);
        System.debug(loggingLevel.Error, '*** dctNewLine: ' + dctNewLine);
        
        //Inicializa las variables para el nuevo plan
        slTipoMercado = new List<SelectOption>();
        mapTipoMercado = new Map<String, DCT_TelcelPlanesSoap_ws.planMercado>();
        //slTipoMercado.add(new SelectOption('' , '--Ninguno--'));

        slGrupoPlan = new List<SelectOption>();
        //mapGruposPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.grupoPlanMercado>();
        mapGruposPlanes = new Map<String, DCT_CorporativoPlanesWs.GrupoPlan>();        
        slGrupoPlan.add(new SelectOption('' , '--Ninguno--'));
        
        selPlazos = new List<SelectOption>();
        //mapPlazos = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoMercado>();
		mapPlazos = new Map<String, DCT_CorporativoPlanesWs.Plazo>();        
        selPlazos.add(new SelectOption('' , '--Ninguno--'));

        selPlanes = new List<SelectOption>();
        //mapPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoM2K>();
        mapPlanes = new Map<String, DCT_CorporativoPlanesWs.Plan>();
        selPlanes.add(new SelectOption('' , '--Ninguno--'));

	    selTarifas = new List<SelectOption>(); 
        selTarifas.add(new SelectOption('' , '--Ninguno--'));

        selGuiaPlanes = new List<SelectOption>();
        mapGuiaPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO>();
        selGuiaPlanes.add(new SelectOption('' , '--Ninguno--'));        

        //Solo null
        return null;
    }   
	
    public PageReference creaConsecutivoWebSer(){
        System.debug('EN creaConsecutivoWebSer....');
        
        //Crea el consecutivo para el llamado;
        //slConsecCons = String.valueOf(DCT_Utils_cls.consectivoPlanesYEquipos());

        System.debug('ANTES DE SALIR DE creaConsecutivoWebSer: ' + slConsecCons);
        //Solo null
        return null;
    }   

    public void DespliegaCamposNuevoPlan(){
        System.debug('EN DCT_Product_ctr.DespliegaCamposNuevoPlan slConsecCons: ' + slConsecCons);
        blnIsOnclick = true;
        bErrorIns = false;
        
        //Ve si tiene algo la lista de slTipoMercado
        if (slConsecCons != null){
            
            //Agrega los datos  la lista ditectamente
        	slTipoMercado.add(new SelectOption('' , '--Ninguno--'));                        
			slTipoMercado.add(new SelectOption('2', 'CORPORATIVO')); //1 MASIVO, 3 PRECORPORATIVO			
            
            /*//Llama al WS que consulta los mercados en el controlador de        
            //Manda llamar los metodos del WS de planeas
            DCT_TelcelPlanesSoap_ws.getMercadosResponseDTO MercadosResponseDTOResult = DCT_TelcelPlanesMetodos_ws.ConsultarMercados(slConsecCons, 'CELME');
            System.debug('EN DCT_Product_ctr.DespliegaCamposNuevoPlan objMercadosResponseDTOPaso: ' + MercadosResponseDTOResult);       
            //Ve si no hay error 
            if (MercadosResponseDTOResult.detailResponse != null){            
	            if (MercadosResponseDTOResult.detailResponse.code == '0'){
	                DCT_TelcelPlanesSoap_ws.planesMercadoWSOUTDTO objPlanesMercadoWSOUTDTO = MercadosResponseDTOResult.listaMercados;
	                //Ve si tiene algo la lista de objPlanesMercadoWSOUTDTO.
	                if (!objPlanesMercadoWSOUTDTO.Mercado.isEmpty()){
	                    //Recorre la lista de objPlanesMercadoWSOUTDTO.
	                    for (DCT_TelcelPlanesSoap_ws.planMercado planMercado : objPlanesMercadoWSOUTDTO.Mercado){
	                        System.debug('EN DCT_Product_ctr.DespliegaCamposNuevoPlan planMercado: cveMercado: ' + planMercado.cveMercado + ' ' + planMercado.descripcionMercado);
	                        if (planMercado.descripcionMercado == 'CORPORATIVO'){
		                        slTipoMercado.add(new SelectOption(String.valueOf(planMercado.cveMercado), planMercado.descripcionMercado));
		                        mapTipoMercado.put(String.valueOf(planMercado.cveMercado), planMercado);
		                        sTipoMercadoDesc = planMercado.descripcionMercado;
		                        sTipoMercado = String.valueOf(planMercado.cveMercado);
	                        }
	                    }
	                }//Fin si !objPlanesMercadoWSOUTDTO.Mercado.isEmpty()
	            }//Fin si !MercadosResponseDTOResult.listaMercados.isEmpty()
            }//Fin si MercadosResponseDTOResult.detailResponse.code != null*/
        }//Fin si slTipoMercado.isEmpty()

        System.debug('EN DCT_Product_ctr.DespliegaCamposNuevoPlan sTipoMercado: ' + sTipoMercado);        
        //if (sTipoMercadoDesc == 'CORPORATIVO')
        	actualizaGrupoPlan();
        	Tarifas();
        
    }

    public PageReference actualizaGrupoPlan(){
        System.debug('ENTRO A actualizaGrupoPlan...');
        System.debug('EN DCT_Product_ctr.actualizaGrupoPlan slConsecCons: ' + slConsecCons + ' ' + sTipoMercado);       
        bErrorIns = false;
		
		sGrupoPlan = null;
        slGrupoPlan = new List<SelectOption>();
        //mapGruposPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.grupoPlanMercado>();
        mapGruposPlanes = new Map<String, DCT_CorporativoPlanesWs.GrupoPlan>();        
        slGrupoPlan.add(new SelectOption('' , '--Ninguno--'));
		
		sPlazos = null;
        selPlazos = new List<SelectOption>();
        //mapPlazos = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoMercado>();
		mapPlazos = new Map<String, DCT_CorporativoPlanesWs.Plazo>();        
        selPlazos.add(new SelectOption('' , '--Ninguno--'));
		
		sPlanes = null;
        selPlanes = new List<SelectOption>();
        //mapPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoM2K>();
        mapPlanes = new Map<String, DCT_CorporativoPlanesWs.Plan>();
        selPlanes.add(new SelectOption('' , '--Ninguno--'));
		
		sGuiaPlanes = null;
        selGuiaPlanes = new List<SelectOption>();
        mapGuiaPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO>();
        selGuiaPlanes.add(new SelectOption('' , '--Ninguno--'));        
        
        //Manda llamar el servicio de los grupos en DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlanCorp()
        DCT_TelcelPlanesMetodos_ws.wrpGrupoPlan objWrpGrupoPlan = new DCT_TelcelPlanesMetodos_ws.wrpGrupoPlan();
        objWrpGrupoPlan = DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlanCorp();
		System.debug('EN DCT_Product_ctr.actualizaGrupoPlan GruposPlan: ' + objWrpGrupoPlan.Estatus + ' ' + objWrpGrupoPlan.Descripcion);
        //Ve si hubo error de time out a la hora de llamar el servicio
        if (objWrpGrupoPlan.Estatus == 'ERR'){
        	if (objWrpGrupoPlan.Descripcion.contains('Read timed out'))
        		objWrpGrupoPlan = DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlanCorp();
			System.debug('EN DCT_Product_ctr.actualizaGrupoPlan GruposPlan2: ' + objWrpGrupoPlan.Estatus + ' ' + objWrpGrupoPlan.Descripcion);        		        
        }//Fin si objWrpGrupoPlan.Estatus == 'ERR'
        if (objWrpGrupoPlan.Estatus == 'ERR'){
        	if (objWrpGrupoPlan.Descripcion.contains('Read timed out'))       	
        		objWrpGrupoPlan = DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlanCorp();
			System.debug('EN DCT_Product_ctr.actualizaGrupoPlan GruposPlan3: ' + objWrpGrupoPlan.Estatus + ' ' + objWrpGrupoPlan.Descripcion);        		        
    	}//Fin si objWrpGrupoPlan.Estatus == 'ERR'
        //Ve si el estatus del servicio es igual a OK    	
    	if (objWrpGrupoPlan.Estatus == 'OK'){
        	//Ve si la lista de grupos tiene algo
        	if (!objWrpGrupoPlan.lGrupoPlan.isEmpty()){
        		//Recorre la lista de objetos del tipo DCT_CorporativoPlanesWs.GrupoPlan
        		for (DCT_CorporativoPlanesWs.GrupoPlan objGrupoPlan : objWrpGrupoPlan.lGrupoPlan ){
        			//Inicializa la lista de
					//System.debug('EN DCT_Product_ctr.actualizaGrupoPlan GruposPlan: ' + objGrupoPlan);
					slGrupoPlan.add(new SelectOption(String.valueOf(objGrupoPlan.ID), objGrupoPlan.NOMBRE_GRUPO_PLAN));
					mapGruposPlanes.put(String.valueOf(objGrupoPlan.ID), objGrupoPlan);
        		} //Fin del for para objWrpGrupoPlan.lGrupoPlan
        	} //Fin si !objWrpGrupoPlan.lGrupoPlan.isEmpty()
        }//Fin si objWrpGrupoPlan.Estatus == 'OK'
        
        /*//Ve si tiene algo la lista de slTipoMercado
        if (slGrupoPlan.size() == 1 && slConsecCons != null && sTipoMercado != null){

       		System.debug('ENTRO A actualizaGrupoPlan setIdFzaVtas: ' + setIdFzaVtas);            
			//Ve si tiene algo la lista de setIdFzaVtas
			//if  (!setIdFzaVtas.isEmpty()){
			//	for (String sNomFzaVta : setIdFzaVtas){
	  //      		System.debug('ENTRO A actualizaGrupoPlan sNomFzaVta: ' + sNomFzaVta);
		 //           //Manda llamar los metodos del WS de planeas
		 //           //DCT_TelcelPlanesSoap_ws.getGruposPlanResponseDTO GruposPlanResponseDTOResult = DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlan(slConsecCons, sNomFzaVta, sTipoMercado); //CELME
		 //           DCT_TelcelPlanesSoap_ws.getGruposPlanResponseDTO GruposPlanResponseDTOResult = DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlanCorp(); 
   //                 //System.debug('EN DCT_Product_ctr.actualizaGrupoPlan objGruposPlanResponseDTOPaso: ' + GruposPlanResponseDTOResult);     
		 //           //Ve si no hay error 
		 //           //if (GruposPlanResponseDTOResult.detailResponse != null){            
			//           // if (GruposPlanResponseDTOResult.detailResponse.code == '0'){
			//           //     DCT_TelcelPlanesSoap_ws.grupoPlanesMercadoOUTDTO objgrupoPlanesMercadoOUTDTO = GruposPlanResponseDTOResult.listaGruposPlan;
			//           //     //Ve si tiene algo la lista de objgrupoPlanesMercadoOUTDTO.
			//           //     if (!objgrupoPlanesMercadoOUTDTO.GrupoPlan.isEmpty()){
			//           //         //Recorre la lista de objgrupoPlanesMercadoOUTDTO.
			//           //         for (DCT_TelcelPlanesSoap_ws.grupoPlanMercado GruposPlan : objgrupoPlanesMercadoOUTDTO.GrupoPlan){
			//           //             //System.debug('EN DCT_Product_ctr.actualizaGrupoPlan GruposPlan: ' + GruposPlan);
			//           //             slGrupoPlan.add(new SelectOption(sNomFzaVta +'-'+ String.valueOf(GruposPlan.cveGrupoPlan), GruposPlan.grupoPlanSubgrupoPlan));
			//           //             mapGruposPlanes.put(sNomFzaVta +'-'+ String.valueOf(GruposPlan.cveGrupoPlan), GruposPlan);
			//           //         }
			//           //     }//Fin si !objgrupoPlanesMercadoOUTDTO.Mercado.isEmpty()
			//           // }//Fin si !GruposPlanResponseDTOResult.listaMercados.isEmpty()
		 //           //}//Fin si MercadosResponseDTOResult.detailResponse.code != null            
			//	}
			//}//Fin si !setIdFzaVtas.isEmpty()

            DCT_TelcelPlanesMetodos_ws.wrpGrupoPlan wppGrupoPlan = DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlanCorp();
            System.debug(loggingLevel.Error, '*** wppGrupoPlan: ' + wppGrupoPlan);
			
        }//Fin si slGrupoPlan.isEmpty() && slConsecCons != null && sTipoMercado != null*/
				
		//Ve si no tiene nada sTipoMercado
        if (sTipoMercado == null){
        	sTipoMercado = '2';
	        slTipoMercado = new List<SelectOption>();
    	    mapTipoMercado = new Map<String, DCT_TelcelPlanesSoap_ws.planMercado>();        	
        	//creaConsecutivoWebSer();
			//DespliegaCamposNuevoPlan();
        }//Fin si sTipoMercado == null

        //Solo regresa null
        return null;
    }

    public PageReference actualizaPlazos(){
        System.debug('ENTRO A actualizaPlazos...');
        System.debug('EN DCT_Product_ctr.actualizaPlazos slConsecCons: ' + slConsecCons + ' ' + sTipoMercado + ' ' + sGrupoPlan + ' ');

        //Hazle un split a sGrupoPlan para que puedas consultar los datos de los plazos
        List<String> lGrupoPlan = sGrupoPlan.split('-');
        System.debug('ENTRO A actualizaPlazos lGrupoPlan: ' + lGrupoPlan + ' selPlazos: ' + selPlazos);

		bErrorIns = false;        
        
        //Si ya tiene algo no lo mandes llamar de nuevo
        if (selPlazos.isEmpty() || selPlazos.size() == 1){
			sPlazos = null;
	        selPlazos = new List<SelectOption>();
	        //mapPlazos = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoMercado>();
	        mapPlazos = new Map<String, DCT_CorporativoPlanesWs.Plazo>();        
	        selPlazos.add(new SelectOption('' , '--Ninguno--'));
			
			sPlanes = null;
	        selPlanes = new List<SelectOption>();
	        //mapPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoM2K>();
	        mapPlanes = new Map<String, DCT_CorporativoPlanesWs.Plan>();
	        selPlanes.add(new SelectOption('' , '--Ninguno--'));
			
			sGuiaPlanes = null;
	        selGuiaPlanes = new List<SelectOption>();
	        mapGuiaPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO>();
	        selGuiaPlanes.add(new SelectOption('' , '--Ninguno--'));
        }//Fin si !selPlazos.isEmpty()
			
		//Si esta vacia la lista de selPlazos 
        if (selPlazos.isEmpty() || selPlazos.size() == 1){
	        //Manda llamar el servicio de los grupos en DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlanCorp()
	        DCT_TelcelPlanesMetodos_ws.wrpPlazo objwrpPlazo = new DCT_TelcelPlanesMetodos_ws.wrpPlazo();
	        objwrpPlazo = DCT_TelcelPlanesMetodos_ws.ConsultarPlazosCorp();
	        //Ve si hubo error de time out a la hora de llamar el servicio
	        if (objwrpPlazo.Estatus == 'ERR'){
	        	if (objwrpPlazo.Descripcion.contains('Read timed out'))
	        		objwrpPlazo = DCT_TelcelPlanesMetodos_ws.ConsultarPlazosCorp();
				System.debug('EN DCT_Product_ctr.actualizaGrupoPlan GruposPlan2: ' + objwrpPlazo.Estatus + ' ' + objwrpPlazo.Descripcion);        		        
	        }//Fin si objwrpPlazo.Estatus == 'ERR'
	        if (objwrpPlazo.Estatus == 'ERR'){
	        	if (objwrpPlazo.Descripcion.contains('Read timed out'))       	
	        		objwrpPlazo = DCT_TelcelPlanesMetodos_ws.ConsultarPlazosCorp();
				System.debug('EN DCT_Product_ctr.actualizaGrupoPlan GruposPlan3: ' + objwrpPlazo.Estatus + ' ' + objwrpPlazo.Descripcion);        		        
	    	}//Fin si objwrpPlazo.Estatus == 'ERR'
        
	        //Ve si el estatus del servicio es igual a OK
	        if (objwrpPlazo.Estatus == 'OK'){
	        	//Ve si la lista de grupos tiene algo
	        	if (!objwrpPlazo.lPlazo.isEmpty()){
	        		//Recorre la lista de objetos del tipo DCT_CorporativoPlanesWs.Plazo
	        		for (DCT_CorporativoPlanesWs.Plazo objPlazo : objwrpPlazo.lPlazo ){
	        			//Inicializa la lista de
						System.debug('EN DCT_Product_ctr.actualizaPlazo GruposPlan: ' + objPlazo);
						selPlazos.add(new SelectOption(String.valueOf(objPlazo.ID), objPlazo.DESCRIPCION));
						mapPlazos.put(String.valueOf(objPlazo.ID), objPlazo);
	        		} //Fin del for para objwrpPlazo.lPlazo
	        	} //Fin si !objwrpPlazo.lPlazo.isEmpty()
	        }//Fin si objwrpPlazo.Estatus == 'OK'
        }//Fin si selPlazos.isEmpty()

        //Ve si tiene algo la lista de slTipoMercado
        //if (slConsecCons != null && sTipoMercado != null && sGrupoPlan != null){
            
        //    //Busca el grupo de plan asociado a sGrupoPlan en mapGruposPlanes
        //    DCT_TelcelPlanesSoap_ws.grupoPlanMercado GruposPlanCons =  mapGruposPlanes.get(sGrupoPlan);
        //    System.debug('EN DCT_Product_ctr.actualizaPlazos GruposPlanCons: ' + GruposPlanCons);
            
        //    //Manda llamar los metodos del WS de planeas
        //    DCT_TelcelPlanesSoap_ws.getPlazosResponseDTO PlazosResponseDTOResult = DCT_TelcelPlanesMetodos_ws.ConsultarPlazos(slConsecCons, lGrupoPlan.get(0), sTipoMercado, lGrupoPlan.get(1), String.valueOf(GruposPlanCons.cveSubGrupoPlan));
        //    System.debug('EN DCT_Product_ctr.actualizaPlazos PlazosResponseDTOResult: ' + PlazosResponseDTOResult);     
            
        //    //Ve si no hay error 
        //    if (PlazosResponseDTOResult.detailResponse != null){            
	       //     if (PlazosResponseDTOResult.detailResponse.code == '0'){
	       //         DCT_TelcelPlanesSoap_ws.planPlazoFVMercadoOUTDTO objplanPlazoFVMercadoOUTDTO = PlazosResponseDTOResult.listaPlazos;
	       //         //Ve si tiene algo la lista de objplanPlazoFVMercadoOUTDTO.
	       //         if (!objplanPlazoFVMercadoOUTDTO.Plazo.isEmpty()){
	       //             //Recorre la lista de objplanPlazoFVMercadoOUTDTO.
	       //             for (DCT_TelcelPlanesSoap_ws.planPlazoMercado PlazoMercado : objplanPlazoFVMercadoOUTDTO.Plazo){
	       //                 System.debug('EN DCT_Product_ctr.actualizaPlazos PlazoMercado: ' + PlazoMercado);
	       //                 selPlazos.add(new SelectOption(lGrupoPlan.get(0) + '-' + String.valueOf(PlazoMercado.cvePlazo), PlazoMercado.descripcionPlazo));
	       //                 mapPlazos.put(lGrupoPlan.get(0) + '-' + String.valueOf(PlazoMercado.cvePlazo), PlazoMercado);
	       //             }
	       //         }//Fin si !objplanPlazoFVMercadoOUTDTO.Mercado.isEmpty()
	       //     }//Fin si !PlazosResponseDTOResult.listaMercados.isEmpty()
        //    }//Fin si MercadosResponseDTOResult.detailResponse.code != null
            
        //}//Fin si slGrupoPlan.isEmpty() && slConsecCons != null && sTipoMercado != null

        System.debug('EN DCT_Product_ctr.actualizaPlazos ANTES DE ENTRAR A actualizaPlanes: ' + sGrupoPlan + ' ' + sPlazos);
		//Ve si tiene algo sGrupoPlan
		if (sGrupoPlan != null && sPlazos != null)		
			actualizaPlanes();			

        //Solo regresa null
        return null;
    }

	//Ls tarifas
	

    public PageReference actualizaPlanes(){
        System.debug('ENTRO A ConsultarPlanes...');
        System.debug('EN DCT_Product_ctr.actualizaPlanesslConsecCons: ' + slConsecCons + ' ' + sTipoMercado + ' ' + sGrupoPlan + ' ' + sPlazos);
             
        List<String> lGrupoPlan = sGrupoPlan!= null ? sGrupoPlan.split('-') : new List<String>();
        List<String> lPlazos = sPlazos != null ? sPlazos.split('-') : new List<String>();
        System.debug('ENTRO A actualizaPlazos lGrupoPlan: ' + lGrupoPlan + ' lPlazos: ' + lPlazos + ' selPlanes: ' + selPlanes);

		//No hay planes
        //if (selPlanes.isEmpty() || selPlanes.size() == 1){        
			bErrorIns = false;
			sPlanes = null;
	        selPlanes = new List<SelectOption>();
	        //mapPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoM2K>();
	        mapPlanes = new Map<String, DCT_CorporativoPlanesWs.Plan>();
	        selPlanes.add(new SelectOption('' , '--Ninguno--'));
			
			sGuiaPlanes = null;
	        selGuiaPlanes = new List<SelectOption>();
	        mapGuiaPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO>();
	        selGuiaPlanes.add(new SelectOption('' , '--Ninguno--'));        
        //}//Fin si selPlanes.isEmpty()
		
		//Si esta vacia la lista de selPlanes 
        //if (selPlanes.isEmpty() || selPlanes.size() == 1){
	        //Manda llamar el servicio de los grupos en DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlanCorp()
	        DCT_TelcelPlanesMetodos_ws.wrpPlan objwrpPlan = new DCT_TelcelPlanesMetodos_ws.wrpPlan();
	        objwrpPlan = DCT_TelcelPlanesMetodos_ws.ConsultarPlanesCorp(Integer.valueOf(sGrupoPlan), Integer.valueOf(sPlazos));
			System.debug('EN DCT_Product_ctr.actualizaPlanesslConsecCons GruposPlan1: ' + objwrpPlan.Estatus + ' ' + objwrpPlan.Descripcion);
				        
	        //Ve si hubo error de time out a la hora de llamar el servicio
	        if (objwrpPlan.Estatus == 'ERR'){
	        	if (objwrpPlan.Descripcion.contains('Read timed out'))
			        objwrpPlan = DCT_TelcelPlanesMetodos_ws.ConsultarPlanesCorp(Integer.valueOf(sGrupoPlan), Integer.valueOf(sPlazos));
				System.debug('EN DCT_Product_ctr.actualizaPlanesslConsecCons GruposPlan2: ' + objwrpPlan.Estatus + ' ' + objwrpPlan.Descripcion);        		        
	        }//Fin si objwrpPlan.Estatus == 'ERR'
	        if (objwrpPlan.Estatus == 'ERR'){
	        	if (objwrpPlan.Descripcion.contains('Read timed out'))       	
			        objwrpPlan = DCT_TelcelPlanesMetodos_ws.ConsultarPlanesCorp(Integer.valueOf(sGrupoPlan), Integer.valueOf(sPlazos));
				System.debug('EN DCT_Product_ctr.actualizaPlanesslConsecCons GruposPlan3: ' + objwrpPlan.Estatus + ' ' + objwrpPlan.Descripcion);        		        
	    	}//Fin si objwrpPlan.Estatus == 'ERR'
	        //Ve si el estatus del servicio es igual a OK
	        if (objwrpPlan.Estatus == 'OK'){
	        	//Ve si la lista de grupos tiene algo
	        	if (!objwrpPlan.lPlan.isEmpty()){
	        		//Recorre la lista de objetos del tipo DCT_CorporativoPlanesWs.Plazo
	        		for (DCT_CorporativoPlanesWs.Plan objPlan : objwrpPlan.lPlan ){
	        			//Inicializa la lista de
						System.debug('EN DCT_Product_ctr.actualizaPlan GruposPlan: ' + objPlan);
						selPlanes.add(new SelectOption(String.valueOf(objPlan.ID), objPlan.DESCRIPCION));
						mapPlanes.put(String.valueOf(objPlan.ID), objPlan);
	        		} //Fin del for para objwrpPlan.lPlan
	        	} //Fin si !objwrpPlan.lPlan.isEmpty()
	        }//Fin si objwrpPlan.Estatus == 'OK'
        //}//Fin si selPlanes.isEmpty()

		
        //Ve si tiene algo la lista de slTipoMercado
        //if (slConsecCons != null && sTipoMercado != null && sGrupoPlan != null && sPlazos != null){
            
        //    //Busca el grupo de plan asociado a sGrupoPlan en mapGruposPlanes
        //    DCT_TelcelPlanesSoap_ws.grupoPlanMercado GruposPlanCons =  mapGruposPlanes.get(sGrupoPlan);
        //    System.debug('EN DCT_Product_ctr.actualizaPlanes GruposPlanCons: ' + GruposPlanCons);

        //    //Busca el grupo de plan asociado a sGrupoPlan en mapGruposPlanes
        //    DCT_TelcelPlanesSoap_ws.planPlazoMercado PlazoMercadoCons =  mapPlazos.get(sPlazos);
        //    System.debug('EN DCT_Product_ctr.actualizaPlanes PlazoMercadoCons : ' + PlazoMercadoCons );
            
        //    //Manda llamar los metodos del WS de planeas
        //    DCT_TelcelPlanesSoap_ws.getPlanesResponseDTO PlanesResponseDTOResult = DCT_TelcelPlanesMetodos_ws.ConsultarPlanes(slConsecCons, lGrupoPlan.get(0), sTipoMercado, String.valueOf(PlazoMercadoCons.cvePlazo), lGrupoPlan.Get(1), String.valueOf(GruposPlanCons.cveSubGrupoPlan));
        //    System.debug('EN DCT_Product_ctr.actualizaPlanes PlanesResponseDTOResult: ' + PlanesResponseDTOResult);       
            
        //    //Ve si no hay error
        //    if (PlanesResponseDTOResult.detailResponse != null){            
	       //     if (PlanesResponseDTOResult.detailResponse.code == '0'){
	       //         DCT_TelcelPlanesSoap_ws.getPlanesOUTDTO objgetPlanesOUTDTO = PlanesResponseDTOResult.listaPlanes;
	       //         //Ve si tiene algo la lista de objgetPlanesOUTDTO.
	       //         if (!objgetPlanesOUTDTO.plan.isEmpty()){
	       //             //Recorre la lista de objgetPlanesOUTDTO.
	       //             for (DCT_TelcelPlanesSoap_ws.planPlazoM2K PlanMercado : objgetPlanesOUTDTO.plan){
	       //                 System.debug('EN DCT_Product_ctr.actualizaPlanes PlanMercado : ' + PlanMercado );
	       //                 selPlanes.add(new SelectOption(lPlazos.get(0) + '-' + String.valueOf(PlanMercado.cvePlanM2k), PlanMercado.descripcionPlan));
	       //                 mapPlanes.put(lPlazos.get(0) + '-' + String.valueOf(PlanMercado.cvePlanM2k), PlanMercado);                        
	       //             }
	       //         }//Fin si !objgetPlanesOUTDTO.Mercado.isEmpty()
	       //     }//Fin si !PlanesResponseDTOResult.listaMercados.isEmpty()
        //    }//Fin si MercadosResponseDTOResult.detailResponse.code != null            

        //}//Fin si slGrupoPlan.isEmpty() && slConsecCons != null && sTipoMercado != null


        //Solo regresa null
        return null;
    }
	 
    public PageReference Tarifas(){
		
		Schema.DescribeFieldResult F = cliente__c.DCTRates__c.getDescribe(); 
		List<Schema.PicklistEntry> P = F.getPicklistValues();
		//Recore la lista y creo los reg para el selec opotions
		for (Schema.PicklistEntry objP : P){
        	selTarifas.add(new SelectOption(objP.getValue(), objP.getLabel()));			
		}
		
		//Solo null
    	return null;
    }	 

    public PageReference actualizaGuiaPlanes(){
        System.debug('ENTRO A actualizaGuiaPlanes...');
        System.debug('EN DCT_Product_ctr.actualizaGuiaPlanes : ' + slConsecCons + ' ' + sTipoMercado + ' ' + sGrupoPlan + ' ' + sPlazos + ' ' + sPlanes);
        List<String> lPlanes = sPlanes.split('-');
        System.debug('ENTRO A actualizaGuiaPlanes lPlanes: ' + lPlanes);
		bErrorIns = false;

		sGuiaPlanes = null;
        selGuiaPlanes = new List<SelectOption>();
        mapGuiaPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO>();
        selGuiaPlanes.add(new SelectOption('' , '--Ninguno--'));        
		
        //Ve si tiene algo la lista de slTipoMercado
        //if (slConsecCons != null && sTipoMercado != null && sGrupoPlan != null && sPlanes != null){

        //    //Busca el grupo de plan asociado a sGrupoPlan en mapGruposPlanes
        //    DCT_TelcelPlanesSoap_ws.planPlazoM2K PlanMercadoCons = mapPlanes.get(sPlanes);
        //    System.debug('EN DCT_Product_ctr.actualizaGuiaPlanesPlanMercadoCons: ' + PlanMercadoCons );

        //    //Manda llamar los metodos del WS de planeas
        //    DCT_TelcelPlanesSoap_ws.getGuiaPlanesResponseDTO GuiaPlanesResponseDTOResult = DCT_TelcelPlanesMetodos_ws.ConsultarGuiaPlanes(slConsecCons, lPlanes.get(0), lPlanes.get(1));
        //    System.debug('EN DCT_Product_ctr.actualizaGuiaPlanesGuiaPlanesResponseDTOResult: ' + GuiaPlanesResponseDTOResult);        
            
        //    //Ve si no hay error
        //    if (GuiaPlanesResponseDTOResult.detailResponse != null){            
	       //     if (GuiaPlanesResponseDTOResult.detailResponse.code == '0'){
	       //         DCT_TelcelPlanesSoap_ws.guiaPlanesOUTDTO objguiaPlanesOUTDTO = GuiaPlanesResponseDTOResult.listaPlanes;
	       //         //Despliega los objetos         
	       //         System.debug('EN DCT_Product_ctr.actualizaGuiaPlanes objguiaPlanesOUTDTO.caracteristicas: ' + objguiaPlanesOUTDTO.caracteristicas);
	       //         //System.debug('EN DCT_AccountOwnerAssignment_cls.pruebaLoginTelcel objguiaPlanesOUTDTO.servicios: ' + objguiaPlanesOUTDTO.servicios);
	       //         DCT_TelcelPlanesSoap_ws.ArrayOfGuiaPlanesServiciosDTO objArrayOfGuiaPlanesServiciosDTO = objguiaPlanesOUTDTO.servicios;
	       //         //Recorre la lista de servicios
	       //         if (!objArrayOfGuiaPlanesServiciosDTO.servicio.isEmpty()){
	       //             for (DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO objGuiaPlanesServiciosDTO : objArrayOfGuiaPlanesServiciosDTO.servicio){
	       //                 System.debug('EN DCT_Product_ctr.actualizaGuiaPlanes objGuiaPlanesServiciosDTO: ' + objGuiaPlanesServiciosDTO);                    
	       //                 selGuiaPlanes.add(new SelectOption(lPlanes.get(0) + '-' + String.valueOf(objGuiaPlanesServiciosDTO.id), objGuiaPlanesServiciosDTO.tipoServicio + ' - '  + objGuiaPlanesServiciosDTO.descripcion));
	       //                 mapGuiaPlanes.put(lPlanes.get(0) + '-' + objGuiaPlanesServiciosDTO.id, objGuiaPlanesServiciosDTO);
	       //             }
	       //         }//Fin si !objArrayOfGuiaPlanesServiciosDTO.servicio.isEmpty()
	       //     }//Fin si !GuiaPlanesResponseDTOResult.listaMercados.isEmpty()*/
        //    }//Fin si MercadosResponseDTOResult.detailResponse.code != null            

        //}//Fin si slGrupoPlan.isEmpty() && slConsecCons != null && sTipoMercado != null
            
        //Solo regresa null
        return null;
    }

    public PageReference validaTipoServ(){
    	System.debug('EN validaTipoServ: ');
		bErrorIns = false;
		    	
		return null;
    }
             
    public PageReference refreshTable(){
    	System.debug('EN refreshTable: ' + bErrorIns);
    	if (!bErrorIns){
	        Cliente__c newClient = new Cliente__c(id = idRecord);
	        PageReference pr = new ApexPages.StandardController(newClient).view();  
	        pr.setRedirect(true);
	        return pr;	        
    	}//FIN SI !bErrorIns
    	//Solo null
		return null;
    }
    
    public void watchField2(){
        blnIsOnclick2 = true;
        
		//Limpia las variables
        blnIsOnclick = false;
        bErrorIns = false;
        
        system.debug('DCTnewProduct: '+DCTnewProduct);
        System.debug(loggingLevel.Error, '*** dctNewLine: ' + dctNewLine);
        
        //Inicializa las variables para el nuevo plan
        slTipoMercado = new List<SelectOption>();
        mapTipoMercado = new Map<String, DCT_TelcelPlanesSoap_ws.planMercado>();
        //slTipoMercado.add(new SelectOption('' , '--Ninguno--'));

        slGrupoPlan = new List<SelectOption>();
        //mapGruposPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.grupoPlanMercado>();
        mapGruposPlanes = new Map<String, DCT_CorporativoPlanesWs.GrupoPlan>();        
        slGrupoPlan.add(new SelectOption('' , '--Ninguno--'));
        
        selPlazos = new List<SelectOption>();
        //mapPlazos = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoMercado>();
		mapPlazos = new Map<String, DCT_CorporativoPlanesWs.Plazo>();        
        selPlazos.add(new SelectOption('' , '--Ninguno--'));

        selPlanes = new List<SelectOption>();
        //mapPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoM2K>();
        mapPlanes = new Map<String, DCT_CorporativoPlanesWs.Plan>();
        selPlanes.add(new SelectOption('' , '--Ninguno--'));

	    selTarifas = new List<SelectOption>(); 
        selTarifas.add(new SelectOption('' , '--Ninguno--'));

        selGuiaPlanes = new List<SelectOption>();
        mapGuiaPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO>();
        selGuiaPlanes.add(new SelectOption('' , '--Ninguno--'));        

    }

    public void savePlans(){
    	System.debug('EN savePlans...');
		String sRt = Schema.SObjectType.DCTAuthorizedLines__c.getRecordTypeInfosByName().get('Plan').getRecordTypeId();		
		Boolean bExietPlan = false;
		Boolean bTieneRegLinAut = false;		
		sError = null;
    	System.debug('EN savePlans sTipoMercado: ' + sTipoMercado);    	

        /*List<String> lGrupoPlan = sGrupoPlan != null ? sGrupoPlan.split('-') : new List<String>();    	
    	System.debug('EN savePlans sGrupoPlan: ' + sGrupoPlan + ' lGrupoPlan: ' + lGrupoPlan);    	
        List<String> lPlazos = sPlazos != null ? sPlazos.split('-') : new List<String>();    	
    	System.debug('EN savePlans sPlazos: ' + sPlazos + ' lPlazos: ' + lPlazos);
        List<String> lPlanes = sPlanes != null ? sPlanes.split('-') : new List<String>();
    	System.debug('EN savePlans sPlanes: ' + sPlanes + ' lPlanes: ' + lPlanes);
        List<String> lGuiaPlanes = sGuiaPlanes != null ? sGuiaPlanes.split('-') : new List<String>();    	
    	System.debug('EN savePlans sGuiaPlanes: ' + sGuiaPlanes + ' lGuiaPlanes: ' + lGuiaPlanes);
		Set<String> setIdGuiaPlan = new Set<String>();*/

        List<String> lPlazos = sPlazos != null ? mapPlazos.get(sPlazos).DESCRIPCION.split('-') : new List<String>();
    	System.debug('EN savePlans bExietPlan lPlazos: ' + lPlazos);
    	System.debug('EN savePlans bExietPlan lPlazos: ' + lPlazos.get(0) + ' ' + lPlazos.get(1));    	
    		        		
        Boolean blnWasThereanException = false;
        String strErrorMsg = '';
        
        //Valida que haya capturado todos los campos
        if (ValidaDatosEntrada()){
 
			//Ve si ya existe un registro con esos datos del plan
			for (DCTAuthorizedLines__c plan : [Select Plan__r.TipoMercado__c, Plan__r.ClaveGrupoPlan__c, 
				Plan__r.ClavePlazo__c, Plan__r.ClavePlan__c, Plan__r.ClaveDetallePlan__c, RecordTypeId,
				Plan__r.ClaveTarifa__c
				From DCTAuthorizedLines__c Where Plan__r.TipoMercado__c =: sTipoMercado 
				And Plan__r.ClaveGrupoPlan__c =: sGrupoPlan
				And Plan__r.ClavePlazo__c =: sPlazos
				And Plan__r.ClavePlan__c =: sPlanes
				And Plan__r.ClaveTarifa__c =: sTarifas
				And CommercialDirectory__c =: idRecord
				And RecordTypeId =: sRt]){
				bTieneRegLinAut = true;	
			} 
    		//System.debug('EN savePlans setIdGuiaPlan: ' + setIdGuiaPlan);
    		
			//Ve si tiene reg la consulta	    					
			if (bTieneRegLinAut)
				bExietPlan = true;
			//Si existe el plan despliega el msg
			if(bExietPlan){
				sError = '' + 'Ya existe un plan con esos datos.';			
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' ' + sError));				
			}
    		System.debug('EN savePlans bExietPlan: ' + bExietPlan + ' sError: ' + sError);
    				
			//Ve si no tienen un plan ya asociado del mismo
			if (!bExietPlan){
				Savepoint sp = Database.setSavePoint();
										        
		        //Crea el objeto del tipo DCTPlan__c
		        DCTPlan__c objDCTPlanNuevo = new DCTPlan__c();
		        String sName = '';
		        if (mapPlanes.get(sPlanes).DESCRIPCION.length() > 80)
		        	sName = mapPlanes.get(sPlanes).DESCRIPCION.substring(0, 79);
		        else if (mapPlanes.get(sPlanes).DESCRIPCION.length() < 80)
		        	sName = mapPlanes.get(sPlanes).DESCRIPCION;		        
		        objDCTPlanNuevo.Name = sName;	        
		        objDCTPlanNuevo.DCTCode__c = sPlazos; //Ve si contiene un - y entonces quita los meses nada mas
		        objDCTPlanNuevo.DCTTerm__c = lPlazos.get(0);
		        objDCTPlanNuevo.DCTTypeofLine__c = null; //mapGuiaPlanes.containsKey(sGuiaPlanes) ? mapGuiaPlanes.get(sGuiaPlanes).tipoServicio : null;
				objDCTPlanNuevo.ClaveFuerzaVenta__c = null; //lPlanes.get(0);
		        objDCTPlanNuevo.TipoMercado__c = sTipoMercado;
				objDCTPlanNuevo.ClaveMercado__c = sTipoMercado;
		        objDCTPlanNuevo.ClaveGrupoPlan__c = sGrupoPlan;
		        objDCTPlanNuevo.ClavePlazo__c = sPlazos;
		        objDCTPlanNuevo.ClavePlan__c = sPlanes;
		        objDCTPlanNuevo.ClaveTarifa__c = sTarifas; 
		        objDCTPlanNuevo.ClaveDetallePlan__c = null; //sGuiaPlanes != null ? lGuiaPlanes.get(1) : null;
		        objDCTPlanNuevo.DescripcionServcicio__c = null; //mapGuiaPlanes.containsKey(sGuiaPlanes) ? (mapGuiaPlanes.get(sGuiaPlanes).tipoServicio +' : '+ mapGuiaPlanes.get(sGuiaPlanes).descripcion): null;
		        
		        //Crea la linea 
		        insert objDCTPlanNuevo;
	    		System.debug('EN savePlans objDCTPlanNuevo.id: ' + objDCTPlanNuevo.id);
	    		        	        
		        //Actualiza el objeto intermedio con esta id de la nueva linea
		        dctNewLine.Plan__c = objDCTPlanNuevo.id;
				//Actualiza el resto de los datos
		        dctNewLine.Name = mapPlanes.get(sPlanes).DESCRIPCION;
		        dctNewLine.Clave__c = sPlanes;
		        String sMeses = lPlazos.get(0) + 'MESES';
		        System.debug('EN savePlans sMeses: ' + sMeses);		        
		        dctNewLine.DCTTerm__c = sMeses;
		        dctNewLine.DCTLineType__c = null; //mapGuiaPlanes.containsKey(sGuiaPlanes) ? mapGuiaPlanes.get(sGuiaPlanes).tipoServicio : null;
		        dctNewLine.RecordTypeId = sRt;
		        dctNewLine.DCT_Tarifa__c = sTarifas;
		        if (lPlazos.get(0) != '12 ' && sTarifas != 'DD')		        
					dctNewLine.Status__c = 'APROBADO';

		        //System.debug(loggingLevel.Error, '*** recordDC.OwnerId: ' + recordDC.OwnerId);
		        List<DCTPlan__c> lstPlan = [
		            SELECT DCTCode__c, DCTTerm__c, DCTTypeofPlan__c, DCTTypeofLine__c, Name, ClaveTarifa__c
		            FROM DCTPlan__c
		            WHERE id = :dctNewLine.Plan__c
		            LIMIT 1
		        ];
		
		        Cliente__c idOwner = [
		            SELECT OwnerId
		            FROM Cliente__c
		            WHERE id = :idRecord
		            LIMIT 1
		        ];
		        System.debug(loggingLevel.Error, '*** idOwner: ' + idOwner);
		        
		        List<User> lstUserManager = [
		            SELECT Id, ManagerId, Manager.ManagerId 
		            FROM User 
		            WHERE Id = :idOwner.OwnerId
		        ];
		        System.debug(loggingLevel.Error, '*** lstUserManager: ' + lstUserManager);        
		        System.debug(loggingLevel.Error, '*** lstPlan: ' + lstPlan);
		        
		        if(!lstUserManager.isEmpty()) {
		            for(User userIterator: lstUserManager) {
		                dctNewLine.DCTSubdirector__c = userIterator.Manager.ManagerId;
		            }
		        }
		        System.debug(loggingLevel.Error, 'EN savePlans antes de insertar dctNewLine: ' + dctNewLine);
		        
		        Database.SaveResult sr = Database.insert(dctNewLine, true);
		        if(sr.isSuccess()){
		        	
		            System.debug('Se Guardo Exitosamente idRecord: ' + idRecord + ' sRt: ' + sRt + ' sr.getId(): ' + sr.getId());
		            lstDCTPlan = new List<DCTAuthorizedLines__c>(); 
			        //Busca las lieas autorizads
			        for(DCTAuthorizedLines__c objPaso : [  SELECT id,
				                Clave__c, 
				                Name, 
				                DCTLineType__c, 
				                DCTPlanType__c, 
				                DCTTerm__c, 
				                DCTPlan__c, 
				                Plan__c ,
				                DCTHideAdditionalServices__c,
				                DCT_Tarifa__c,
	                			Status__c 
				            FROM DCTAuthorizedLines__c
				            WHERE CommercialDirectory__c = :idRecord 
				            AND RecordTypeId = :sRt
							AND Status__c != 'Rechazado'				            
				            ORDER BY CreatedDate DESC
				        ]){
						lstDCTPlan.add(objPaso);			
			        }
			        
			        System.debug('EN savePlans DESPUES DEL INSERT lPlazos.get(0): ' + lPlazos.get(0) + ' ' + sTarifas);			        
			        if (lPlazos.get(0) == '12 ' || sTarifas == 'DD')
 						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'El nuevo plan fue enviado para su aprobación.'));
					else				        
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'El nuevo plan se creo correctamente.'));						
					blnIsOnclick = false;
					
					dctNewLine = new DCTAuthorizedLines__c();
		            dctNewLine.CommercialDirectory__c = idRecord;
					            
		            //Inicializa los campos para los planes
			        slTipoMercado = new List<SelectOption>();
	        		mapTipoMercado = new Map<String, DCT_TelcelPlanesSoap_ws.planMercado>();
	        		sTipoMercado = null;
	
		    		sGrupoPlan = null;            
			        slGrupoPlan = new List<SelectOption>();
			        //mapGruposPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.grupoPlanMercado>();
			        mapGruposPlanes = new Map<String, DCT_CorporativoPlanesWs.GrupoPlan>();
			        slGrupoPlan.add(new SelectOption('' , '--Ninguno--'));
		    	        
					sPlazos = null;
			        selPlanes = new List<SelectOption>();
			        //mapPlazos = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoMercado>();
					mapPlazos = new Map<String, DCT_CorporativoPlanesWs.Plazo>();
			        
			        selPlazos.add(new SelectOption('' , '--Ninguno--'));
			
					sPlanes = null;
			        selPlanes = new List<SelectOption>();
			        //mapPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.planPlazoM2K>();
			        mapPlanes = new Map<String, DCT_CorporativoPlanesWs.Plan>();			        
			        selPlanes.add(new SelectOption('' , '--Ninguno--'));
		
					sGuiaPlanes = null;	
			        selGuiaPlanes = new List<SelectOption>();
			        mapGuiaPlanes = new Map<String, DCT_TelcelPlanesSoap_ws.guiaPlanesServiciosDTO>();
			        selGuiaPlanes.add(new SelectOption('' , '--Ninguno--'));
					
		        }//Fin si sr.isSuccess()
				
				//Regresa todo lo que creaste        	
				//Database.rollback(sp);
        	}//Fin si !bExietPlan
         		        
        }else //Fin si ValidaDatosEntrada()
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' ' + sError));        
           
    }
    
	public Boolean ValidaDatosEntrada(){
		System.debug('ENTRO A ValidaDatosEntrada...');
		Boolean bErrorPaso = false;
		sError = '';
		
		//Ve si faltan datos de capturar
		//if (sTipoMercado == null)
		//	sError = '' + 'Te falta capturar el tipo de mercado.';		
		if (sGrupoPlan == null)
			sError += '' + 'Te falta capturar el grupo.';
		if (sPlazos == null)
			sError += '' + 'Te falta capturar el plazo.';
		if (sPlanes == null)
			sError += '' + 'Te falta capturar el plan.';
		//if (sGuiaPlanes == null)
		//	sError += '' + 'Te falta capturar el tipo de servicio.';
		if (sTarifas == null)
			sError += '' + 'Te falta capturar la tarifa.';

		if (sError != null && sError != ''){
			bErrorPaso = true;
			bErrorIns = true;
			sError = sError.replaceAll('null', '');
		}

		System.debug('ENTRO A ValidaDatosEntrada sError: ' + sError);
		System.debug('ENTRO A ValidaDatosEntrada bErrorPaso: ' + bErrorPaso);		
		return !bErrorPaso;
	}
    
    
    
    
}