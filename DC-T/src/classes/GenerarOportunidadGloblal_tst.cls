@isTest (SeeAllData = true)
private class GenerarOportunidadGloblal_tst {

	@IsTest static void myUnitTest01(){
		test.startTest();
		    PageReference pageRef = Page.GenerarOportunidadGlobalFin;
        	Test.setCurrentPage(pageRef);
        	ApexPages.currentPage().getParameters().put('msjResultado', 'Test');
		    GenerarOportunidadGlobalFinCtr objGOppFin = new GenerarOportunidadGlobalFinCtr();
        	PageReference objFin = objGOppFin.salir();
        test.stopTest();
	}


    @IsTest static void myUnitTest02() {
    	test.startTest();
    	
	    	PageReference pageRef = Page.GenerarOportunidadGlobal;
	        Test.setCurrentPage(pageRef);
	        
	        List<UserRole> funciones= [SELECT ID FROM UserRole];
	        User usuario = DataGenerator_cls.crearUsuario(DataGenerator_cls.getPerfilPorNombre().get('GV').id, funciones[2].id, 'UGV');
	        insert usuario;
	        ApexPages.currentPage().getParameters().put('userId', usuario.Id);
	        String nextPage = '/apex/GenerarOportunidadGlobal';
	        System.runAs(usuario){
	        	GenerarOportunidadGlobalCtr Controller = new GenerarOportunidadGlobalCtr();
	        	
	        	List<String> fases = controller.fases;
	        	controller.getValoresClientesFiltro();
	        	List<GenerarOportunidadGlobalCtr.UserGrouping> nodos= controller.nodosRaizes;
	        	//controller.faseActual = 0;
	        	List<GenerarOportunidadGlobalCtr.NodoCuenta> lNodocuenta;
	        	GenerarOportunidadGlobalCtr.idLineaMarcada = '';
	        	controller.getRenderPanelClientes();
	        	controller.getRenderPanelClienteUnico();
	        	controller.faseActual = 4;
	        	controller.faseInicial = 4;
	        	lNodocuenta = controller.getListaCuentas();
	        	controller.crearOportunidadesUsuarios();	
	
	     		PageReference PRnextPage = controller.crearOportunidadesUsuarios();
	     		Boolean bRes = controller.getRenderPanelClientes();
	     		bRes = controller.getRenderPanelClienteUnico();
	     		
	     		List<GenerarOportunidadGlobalCtr.UserGrouping> directores = controller.getListaDirectores();
	     		List<GenerarOportunidadGlobalCtr.UserGrouping> gerentes = controller.getListaGerentes();
	     		
	     		controller.faseActual = 2;
	        	controller.crearOportunidadesUsuarios();
	     		
	     		//System.assertEquals('[/apex/generaroportunidadglobal]',String.valueOf(PRnextPage));
	        }
	        
	        usuario = DataGenerator_cls.crearUsuario(DataGenerator_cls.getPerfilPorNombre().get('JEC').id, funciones[7].id, 'UJEC');
	        insert usuario;
	        ApexPages.currentPage().getParameters().put('userId', usuario.Id);
	        
	        //System.runAs(usuario){
	        	GenerarOportunidadGlobalCtr Controller = new GenerarOportunidadGlobalCtr();
	        	
	        	Controller.segmentoCuenta = 'Corporativo';
	        	Controller.subSectorCuenta = 'Industria';
	        	Controller.sectorCuenta = 'Industria';
	        	
	        	List<String> fases = controller.fases;
	        	controller.getValoresClientesFiltro();
	        	List<GenerarOportunidadGlobalCtr.UserGrouping> nodos= controller.nodosRaizes;
	        	List<GenerarOportunidadGlobalCtr.NodoCuenta> lNodocuenta;
	        	controller.OpcionBusqueda = '1';
	        	controller.ValidarOpcionBusqueda();
	        	controller.faseActual = 4;
	        	controller.faseInicial = 4;
	        	lNodocuenta = controller.getListaCuentas();
	        	controller.faseActual = 0;
	        	List<GenerarOportunidadGlobalCtr.UserGrouping> directores = controller.getListaDirectores();
	        	controller.avanzarFase();
	        	controller.volverFase();
	        	controller.avanzarFase();
	        	controller.faseActual = 1;
	        	controller.faseInicial = 1;
	        	directores = controller.getListaDirectores();
	        	List<GenerarOportunidadGlobalCtr.UserGrouping> gerentes = controller.getListaGerentes();
	        	
	        	controller.faseActual = 3;
	        	gerentes = controller.getListaGerentes();
	        	controller.gerentes = gerentes;
	        	controller.avanzarFase();
	        	controller.volverFase();
	        	controller.avanzarFase();
	        	controller.faseActual = 1;
	        	List<GenerarOportunidadGlobalCtr.UserGrouping> JECs = controller.getListaJECs();
	        	controller.faseActual = 3;
	        	controller.faseInicial = 3;
	        	JECs = controller.getListaJECs();
	        	controller.JECs = JECs;
	        	controller.avanzarFase();
	        	controller.volverFase();
	        	controller.avanzarFase();
	        	controller.faseActual = 4;
	        	List<GenerarOportunidadGlobalCtr.NodoCuenta> ListaCuentas = controller.getListaCuentas();
	        	controller.faseActual = 3;
	        	ListaCuentas = controller.getListaCuentas();
	        	controller.NodosCuentas = ListaCuentas;
	        	controller.avanzarFase();
	        	controller.volverFase();
	        	controller.avanzarFase();
	        	
	        	List<SelectOption> lstValoresClientesFiltro = controller.getValoresClientesFiltro();
	        	List<selectOption> lstlistaSegmentos = controller.getlistaSegmentos();
	        	List<selectOption> lstlistaSector = controller.getlistaSector();
	        	List<selectOption> getlistaSubSector = controller.getlistaSubSector();
	        	
	        	
	        	
	        	controller.SeleccionarLista1();
	        	controller.deSeleccionarLista1();
	        	controller.faseActual = 1;
	        	controller.SeleccionarLista2();
	        	controller.deSeleccionarLista2();
	        	controller.SeleccionarLista3();
	        	controller.deSeleccionarLista3();
	        	controller.faseActual = Null;
	        	controller.faseInicial = 0;
	        	controller.activado = false;
	        	controller.avanzarFase();
	        	controller.faseActual = 4;
	        	controller.volverFase();
	        	controller.activado = true;
	        	controller.faseActual = 0;
	        	controller.avanzarFase();
	        	controller.faseActual = 1;
	        	controller.avanzarFase();
	        	controller.faseActual = 2;
	        	controller.avanzarFase();
	        	controller.faseActual = 3;
	        	controller.avanzarFase();
	        	controller.faseActual = 4;
	        	controller.avanzarFase();
	        	controller.volverFase();
	        	controller.volverFase();
	        	controller.volverFase();
	        	controller.volverFase();
	        	
	        	controller.faseActual = 0;
	        	controller.crearOportunidadesUsuarios();	
	        	controller.faseActual = 4;
	        	controller.crearOportunidadesUsuarios();
	        	controller.crearOportunidadesPorCliente();
	        	
	        //}
	        
	        usuario = DataGenerator_cls.crearUsuario(DataGenerator_cls.getPerfilPorNombre().get('SD').id, funciones[11].id, 'USD');
	        insert usuario;
	        ApexPages.currentPage().getParameters().put('userId', usuario.Id);
	        
	        System.runAs(usuario){
	        	 Controller = new GenerarOportunidadGlobalCtr();
	        	
	        	fases = controller.fases;
	        	controller.getValoresClientesFiltro();
	        	nodos= controller.nodosRaizes;
	        	//controller.faseActual = 0;
	        	controller.faseActual = 4;
	        	controller.faseInicial = 4;
	        	lNodocuenta = controller.getListaCuentas();
	 	
	     		controller.faseActual = 1;
	        	controller.crearOportunidadesUsuarios();
	        }
	        
	         
	        usuario = DataGenerator_cls.crearUsuario(DataGenerator_cls.getPerfilPorNombre().get('DR9').id, funciones[1].id, 'UDR9');
	        insert usuario;
	        ApexPages.currentPage().getParameters().put('userId', usuario.Id);
	        
	        System.runAs(usuario){
	        	 Controller = new GenerarOportunidadGlobalCtr();
	        	
	        	fases = controller.fases;
	        	controller.getValoresClientesFiltro();
	        	nodos= controller.nodosRaizes;
	        	//controller.faseActual = 0;
	        	controller.faseActual = 4;
	        	controller.faseInicial = 4;
	        	lNodocuenta = controller.getListaCuentas();
	        	controller.faseActual = 4;
	        	controller.crearOportunidadesUsuarios();	
	     
	        }
	        
	        usuario = DataGenerator_cls.crearUsuario(DataGenerator_cls.getPerfilPorNombre().get('DG').id, funciones[0].id, 'UDG');
	        insert usuario;
	        ApexPages.currentPage().getParameters().put('userId', usuario.Id);
	        
	        System.runAs(usuario){
	        	 Controller = new GenerarOportunidadGlobalCtr();
	        	
	        	fases = controller.fases;
	        	controller.getValoresClientesFiltro();
	        	nodos= controller.nodosRaizes;
	        	//controller.faseActual = 0;
	        	controller.faseActual = 4;
	        	controller.faseInicial = 4;
	        	lNodocuenta = controller.getListaCuentas();
	        	controller.crearOportunidadesUsuarios();	
	        	controller.faseActual = 1;
	        	controller.crearOportunidadesUsuarios();	
	        	controller.faseActual = 2;
	        	controller.crearOportunidadesUsuarios();
	        	controller.faseActual = 3;
	        	controller.crearOportunidadesUsuarios();
	        	controller.crearOportunidadesPorCliente();
	        }
	        
	        
	        
	        System.assertEquals('/apex/GenerarOportunidadGlobal', nextPage);
		test.stopTest();
    }
    
}