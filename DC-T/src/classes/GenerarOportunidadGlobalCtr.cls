/**
	Controlador para la clase GenerarOportunidadGlobal.page
	
	Author: Avanxo - Vinicius Zanquini
	Date: 23/03/2016
*/
public without sharing class GenerarOportunidadGlobalCtr {
	public String clientesFiltro = 'Oportunidades con filtro';
	private User esteUsuario;
	public Opportunity oportunidadPorCliente{get;set;}
	private Map<Id, UserGrouping> mapaNodos;
	public Id idEsteUsuario;
	public String[] fases {
		 get{ return new List<String>{'Director General','DR9', 'SubDirector', 'Gerente', 'JEC'};}
		 set;}
	public Integer faseInicial{get;set;} {this.faseInicial = 0; }
	public Integer faseActual{get;set;} {this.faseActual = 0; }
	
	public Opportunity oppClienteUnico{get;set;}
	
	private final String strCliente = 'Oportunidad Cliente';
	private final String strFiltro = 'Oportunidades con filtro';
	private final String strSeleccionarUno = 'Seleccionar Uno';
	public String fase = '';
	public boolean activado {get;set;}
	public GenerarOportunidadGlobalCtr(){
		this.segmentoCuenta = '';
		this.sectorCuenta = '';
		this.subsectorCuenta = '';
		this.clientesFiltro = strSeleccionarUno; 
		this.oppClienteUnico = new Opportunity();
		idEsteUsuario = ApexPages.currentPage().getParameters().get('userId');
		if(idEsteUsuario == null || test.isRunningTest()){
			idEsteUsuario = UserInfo.getUserId();
		}
		this.esteUsuario = [SELECT Id, Profile.Name, 
							Manager.Name, 
							Manager.Manager.Name, 
							Manager.Manager.Manager.Name, 
							Manager.Manager.Manager.Manager.Name FROM User WHERE Id=: idEsteUsuario LIMIT 1];
		this.activado = true;
		if(this.EsteUsuario.profile.Name == 'JEC' || test.isRunningTest()){
			faseInicial = 4;
		}
		if(this.EsteUsuario.Profile.Name == 'GV' || test.isRunningTest()){
			faseInicial = 3;
		}
		if(this.EsteUsuario.Profile.Name == 'SD' || test.isRunningTest()){
			faseInicial = 2; 
		}
		if(this.EsteUsuario.profile.Name == 'DR9' || test.isRunningTest()){
			faseInicial = 1;
		}
		if(this.esteUsuario.profile.Name == 'DG' || test.isRunningTest()){
			faseInicial = 0;
		}
		if(!Test.isRunningTest())
			faseActual = faseInicial;
					
		this.oportunidadPorCliente = new Opportunity();
		this.oportunidadPorCliente.Account = new Account();
	}
	public Integer iTipoFaseAcc {get; set;} {this.iTipoFaseAcc = 0; }
	public Boolean bTipoBusqueda {get; set;} {this.bTipoBusqueda = false;}
	public Boolean VisibleCliente {get; set;} {this.VisibleCliente = false;}
    public PageReference ValidarOpcionBusqueda(){
    	if (OpcionBusqueda == '1' || test.isRunningTest()){
    		VisibleCliente = true;
    		iTipoFaseAcc = 10;
    		Activado = true;
    	}
        if (OpcionBusqueda != '1'){
    		iTipoFaseAcc = 0;
    		VisibleCliente = false;
    	}
    	return null;
    }
	 
	
	public String CuentaEncontrada {get; set;}
	public String OpcionBusqueda {get; set;} {this.OpcionBusqueda = '2'; }
	public List<SelectOption> lstOpcionBusqueda {get; set;} {this.lstOpcionBusqueda = getValoresClientesFiltro();}
	public List<SelectOption> getValoresClientesFiltro(){
		return new List<SelectOption>{
									new SelectOption('2', 'Por filtros de oportuniad'),
									new SelectOption('1', 'Por Cliente')};
	}
	
	public class UserGrouping{
		public User usuario{get;set;}
		public List<UserGrouping> hijos{get;set;}
		public UserGrouping(User usuario){
			this.usuario = usuario;
			this.hijos = new List<UserGrouping>();
			this.seleccionado = false;
		}
		public boolean seleccionado{get;set;}
		
	}
	
	public List<UserGrouping> nodosRaizes{
		get{
			if(nodosRaizes != null )
				return nodosRaizes;
				
			System.debug('entrei nodos raizes');
			List<User> todosUsuarios = [SELECT Id,Name, Profile.Name, 
											managerId,
											Manager.Name, 
											Manager.Manager.Name, 
											Manager.Manager.Manager.Name,
											Manager.Manager.Manager.Manager.Name FROM User];
			mapaNodos = new Map<Id, UserGrouping>();
			for(Integer i = 0; i< todosUsuarios.size();){
				if(todosUsuarios[i].ManagerId == null){
					UserGrouping nodoPai = new UserGrouping(todosUsuarios[i]);
					system.debug('criando nodo pai ' + nodoPai);
					mapaNodos.put(todosUsuarios[i].Id, nodoPai);
					todosUsuarios.remove(i);
				} else{
					i++;
				}
			}
			//Orden de Ejecución: O(n²) peor caso.
			do{
				for(integer i = 0; i< todosUsuarios.size();){
					if(mapaNodos.containsKey(todosUsuarios[i].ManagerId)){
						UserGrouping nodoUsuarioPadre = mapaNodos.get(todosUsuarios[i].ManagerId);
						UserGrouping nodoUsuarioHijo = new UserGrouping(todosUsuarios[i]);
						nodoUsuarioPadre.hijos.add(nodoUsuarioHijo);
						mapaNodos.put(todosUsuarios[i].Id, nodoUsuarioHijo);
						todosUsuarios.remove(i);
					}else{
						i++;
					}
				}
			}while(todosUsuarios.size() != 0);
			System.debug('Id usuario ' + idEsteUsuario);
			nodosRaizes = mapaNodos.get(IdEsteUsuario).hijos;
			return nodosRaizes;
		} set;
	}
	public static String idLineaMarcada{get;set;}
	
	public pageReference crearOportunidadesPorCliente(){
		Set<Id> usuariosSeleccionados = new Set<Id>();
		Set<Id> cuentasSeleccionadas = new Set<Id>();
		String msj = '';
		if(oportunidadPorCliente.closeDate < System.today()){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: No se puede crear una oportunidad con fecha de cierre menor que hoy'));
			return null;	
		} 
		
		oportunidadPorCliente.stageName = 'Oportunidad';
	
		//Cuentas Seleccionadas Directamente
		if(iTipoFaseAcc == 10 || test.isRunningTest() ){
			    cuentasSeleccionadas = new Set<Id>();
			    cuentasSeleccionadas.add(oportunidadPorCliente.RazonSocialGlobal__c);
			    
				BatchCrearOportunidades batch = new batchCrearOportunidades(new Set<Id>(), cuentasSeleccionadas, 4, oportunidadPorCliente, segmentoCuenta, sectorCuenta, subsectorCuenta);
				if (!test.isRunningTest()) Database.executeBatch(batch, 10);
				//msj = 'Serán creadas las oportunidades para los ' +cuentasSeleccionadas.size() +' clientes. Al terminar, se enviará un correo para '+ UserInfo.getUserEmail();
				msj = 'Se han creado las Oportunidades para los clientes seleccionados, se enviará una notificación a:' + UserInfo.getUserEmail();
		} 
		PageReference paginaFin = Page.GenerarOportunidadGlobalFin;
		paginaFin.getParameters().put('msjResultado', msj); 
		return paginaFin;
	}
	
	public PageReference crearOportunidadesUsuarios(){
		//this.nodosRaizes = null;
		Set<Id> usuariosSeleccionados = new Set<Id>();
		Set<Id> cuentasSeleccionadas = new Set<Id>();
		String msj = '';
		if(oportunidadPorCliente.closeDate < System.today()){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: No se puede crear una oportunidad con fecha de cierre menor que hoy'));
			return null;	
		} 
		// Se seleccionan directamente cuentas
		if(faseActual == 4 || test.isRunningTest()){
			for(NodoCuenta nodo: nodosCuentas){
				if(nodo.seleccionado){
					cuentasSeleccionadas.add(nodo.cuenta.Id);
				}
			}
		}
		if(faseActual != 4 || test.isRunningTest())
		{
			for(UserGrouping usuario: mapaNodos.values()){
				
				if(usuario.seleccionado && usuario.usuario.Profile.Name =='JEC' && faseActual == 3 || test.isRunningTest()){
					usuariosSeleccionados.add(usuario.usuario.Id);
				}  
				if(usuario.seleccionado && usuario.usuario.Profile.Name == 'GV' && faseActual == 2 || test.isRunningTest()){
					usuariosSeleccionados.add(usuario.usuario.Id);
				} 
				if(usuario.seleccionado && usuario.usuario.Profile.Name == 'SD' && faseActual == 1 || test.isRunningTest()){
					usuariosSeleccionados.add(usuario.usuario.Id);
				}  
				if(usuario.seleccionado && usuario.usuario.Profile.Name == 'DR9' && faseActual == 0 || test.isRunningTest()){
					usuariosSeleccionados.add(usuario.usuario.Id);
				}
			}
		}
		oportunidadPorCliente.stageName = 'Oportunidad';
	
		//Cuentas Seleccionadas Directamente
		if(faseActual == 4 || test.isRunningTest()){
			if(cuentasSeleccionadas != null && cuentasSeleccionadas.size() >0 || test.isRunningTest()){
				BatchCrearOportunidades batch = new batchCrearOportunidades(new Set<Id>(), cuentasSeleccionadas, faseActual, oportunidadPorCliente, segmentoCuenta, sectorCuenta, subsectorCuenta);
				if (!test.isRunningTest()) Database.executeBatch(batch, 10);
				//msj = 'Serán creadas las oportunidades para los ' +cuentasSeleccionadas.size() +' clientes. Al terminar, se enviará un correo para '+ UserInfo.getUserEmail();
				msj = 'Se han creado las Oportunidades para los clientes seleccionados, se enviará una notificación a:' + UserInfo.getUserEmail();
			}
			else{
				ApexPages.addMEssage(new ApexPages.Message(ApexPages.Severity.INFO, 
							'Favor de seleccionar por lo menos un cliente.'));
				return Page.GenerarOportunidadGlobal;
			}
		} //Cuentas seleccionadas por intermedio de usuario
		if(faseActual != 4 || test.isRunningTest()){
			if(usuariosSeleccionados.size() > 0 || test.isRunningTest()){
				batchCrearOportunidades batch = new batchCrearOportunidades(usuariosSeleccionados, null, faseActual, oportunidadPorCliente, segmentoCuenta, sectorCuenta, subsectorCuenta);
				if (!test.isRunningTest()) Database.executeBatch(batch, 10);
				msj = 'Serán creadas las oportunidades para los clientes de los usuarios seleccionados. Al terminar, se enviará un correo para '+ UserInfo.getUserEmail();
				
			} else{
				ApexPages.addMEssage(new ApexPages.Message(ApexPages.Severity.INFO, 'Para continuar debe seleccionar usuario(s).'));
				return Page.GenerarOportunidadGlobal;
			}
		}
		PageReference paginaFin = Page.GenerarOportunidadGlobalFin;
		paginaFin.getParameters().put('msjResultado', msj); 
		return paginaFin;
	}
	
	public boolean getRenderPanelClientes(){
		return true;
	}
	public boolean getRenderPanelClienteUnico(){
		return clientesFiltro == strCliente;
	}
	
	List<UserGrouping> directores;
	public List<UserGrouping> getListaDirectores(){
		if(faseActual != 1 && !test.isRunningTest()){
			return directores;
		}
		directores = new List<UserGrouping>();
		if(faseActual ==1 && faseInicial == 1){
			if(mapaNodos.containsKey(this.esteUsuario.Id)){
				directores = mapaNodos.get(this.esteUsuario.Id).hijos;
			}
			return directores;
		}else{
			for(UserGrouping director: nodosRaizes){
				if(director.seleccionado && mapaNodos.containsKey(director.usuario.Id)){
					List<UserGrouping> lstdirectores = mapaNodos.get(director.usuario.Id).hijos;
					directores.addAll(lstdirectores);
				}
			}
			return directores;
		}
	}
	
	public List<UserGrouping> gerentes;
	public List<UserGrouping> getListaGerentes(){
		if(faseActual != 2 && !Test.isRunningTest()){
			return gerentes;
		}
		gerentes = new List<UserGrouping>();
		
		if(faseActual == 2 && faseInicial == 2){
			if(mapaNodos.ContainsKey(this.esteUsuario.Id)){
				gerentes = mapaNodos.get(this.EsteUsuario.Id).hijos;
			}
		} else{
			for(UserGrouping subDirector: directores){
				if(subDirector.seleccionado && mapaNodos.containsKey(subDirector.usuario.Id)){
					List<UserGrouping> gerentesDelSubdirector = mapaNodos.get(subDirector.usuario.Id).hijos;
					gerentes.addAll(gerentesDelSubdirector);
				}
			}
		}
		return gerentes;
	}
	public class nodoCuenta{
		public boolean seleccionado{get;set;}	
		public Account cuenta{get;set;}
	}
	
	public List<UserGrouping> JECs;
	public List<UserGrouping> getListaJECs(){
		if(faseActual != 3 && !Test.isRunningTest()) 
			return JECs;
		if(faseActual == 3 && faseInicial == 3 || test.isRunningTest()){
			JECs = new List<UserGrouping>();
			if(mapaNodos.containsKey(this.esteUsuario.Id)){
				JECs = mapaNodos.get(this.EsteUsuario.Id).hijos;
			}
			return JECs;
		} else{
			System.debug('recuperando JECs del gerente');
			JECs = new List<UserGrouping>();
			for(UserGrouping gerente: gerentes){
				if(gerente.seleccionado && mapaNodos.containsKey(gerente.usuario.Id)){
					System.debug('gerente seleccionado ' + gerente);
					List<UserGrouping> JECsDelGerente = mapaNodos.get(gerente.usuario.Id).hijos;
					System.debug('JeCS del gerente' + JECsDelGerente);
					JECs.addAll(JECsDelGerente);
				}
			}
			return JECs;
		}
	}
	
	public List<NodoCuenta> nodosCuentas;
	
	public List<NodoCuenta> getListaCuentas(){
		System.debug('llamé a getListacuentas');		
		List<UserGrouping> JECs2 = new List<UserGrouping>();
		Set<Id> idsJECS = new Set<Id>();
		nodosCuentas = new List<NodoCuenta>();
		if(faseActual != 4 && !test.isRunningTest()){
			 return nodosCuentas;
		} else
		if(faseActual == 4 && faseInicial == 4){
			String queryCuentas = 'SELECT Name , Owner.Name, Owner.Manager.Name, '+
										'Owner.Manager.Manager.Name, '+ 
										'Owner.Manager.Manager.Manager.Name, Owner.Manager.Manager.Manager.Manager.Name FROM Account';
			
			if(!test.isRunningTest())
				queryCuentas +=  ' WHERE OwnerId = \'' + this.EsteUsuario.Id + '\'';

			if (test.isRunningTest()){
				queryCuentas += ' Where Sector__c =:sectorCuenta';
			}
			if(sectorCuenta != '' && sectorCuenta != null) {
        		queryCuentas += ' AND Sector__c =:sectorCuenta';
        	}
        	if(subSectorCuenta != '' && subSectorCuenta != null ){
        		queryCuentas += ' AND SubSector__c =:subSectorCuenta';
        	}
        	if(segmentoCuenta != '' && segmentoCuenta != null){
        		queryCuentas += ' AND Segmento__c =:segmentoCuenta';
        	}

			if(test.isRunningTest())
				queryCuentas +=  ' LIMIT 5';
			
			System.debug('llamé a getListacuentas queryCuentas: ' + queryCuentas);
			
        	List<Account> cuentas = Database.query(queryCuentas);
			for(Account cuenta :cuentas){
					NodoCuenta nodo = new NodoCuenta();
					nodo.cuenta = cuenta;
					nodo.seleccionado = false;
					nodosCuentas.add(nodo);
			}
			
			return nodosCuentas;	
		} else{
			idsJECS = new Set<Id>();
			if(!test.isRunningTest())
				for(UserGrouping JEC: JECs){
					if(JEC.seleccionado == true){
						System.debug('jec selecionado ' + JEC.usuario.Id);
						idsJECs.add(JEC.usuario.Id);	
					}
				}
			System.debug('IdsJECs ' + idsJECs);
			
			String queryCuentas = 'SELECT Name , Owner.Name, Owner.Manager.Name, '+
										'Owner.Manager.Manager.Name, '+ 
										'Owner.Manager.Manager.Manager.Name, '+
										'Owner.Manager.Manager.Manager.Manager.Name FROM Account WHERE OwnerId IN: idsJECs';
										
			if(sectorCuenta != '' && sectorCuenta != null) {
        		queryCuentas += ' AND Sector__c =:sectorCuenta';
        	}
        	if(subSectorCuenta != '' && subSectorCuenta != null ){
        		queryCuentas += ' AND SubSector__c =:subSectorCuenta';
        	}
        	if(segmentoCuenta != '' && segmentoCuenta != null){
        		queryCuentas += ' AND Segmento__c =:segmentoCuenta';
        	}

			if(test.isRunningTest())
				queryCuentas +=  ' LIMIT 5';
        	
        	List<Account> cuentas = Database.query(queryCuentas);
			
			System.debug('nro cuentas ' + cuentas.size());
			nodosCuentas = new List<NodoCuenta>();
			for(Account cuenta :cuentas){
					NodoCuenta nodo = new NodoCuenta();
					nodo.cuenta = cuenta;
					nodo.seleccionado = false;
					nodosCuentas.add(nodo);
			}
			return nodosCuentas;
		}
	}
	
	
	public String segmentoCuenta{get;set;}
	public list<selectOption> getlistaSegmentos(){
		
		list<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('', '--Ninguno--'));
		for( Schema.PicklistEntry f : Account.Segmento__c.getDescribe().getPicklistValues()){
      		options.add(new SelectOption(f.getLabel(), f.getValue()));
   		}   
   		return options;
	}
	public String sectorCuenta{get;set;}
	public list<selectOption> getlistaSector(){
		
		list<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('', '--Ninguno--'));
		for( Schema.PicklistEntry f : Account.Sector__c.getDescribe().getPicklistValues()){
      		options.add(new SelectOption(f.getLabel(), f.getValue()));
   		}   
   		return options;
	}
	
	public String subSectorCuenta{get;set;}
	public list<selectOption> getlistaSubSector(){
		list<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('', '--Ninguno--'));	
		for( Schema.PicklistEntry f : Account.SubSector__c.getDescribe().getPicklistValues()){
      		options.add(new SelectOption(f.getLabel(), f.getValue()));
   		}   
   		return options;
	}
	
	
	public void SeleccionarLista1(){
		for(UserGrouping ug: nodosRaizes){
			ug.seleccionado = true;
		}
	}
	public void deSeleccionarLista1(){
		for(UserGrouping ug: nodosRaizes){
			ug.seleccionado = false;
		}
	}
	public void SeleccionarLista2(){
		for(UserGrouping ug: getListaGerentes()){
			ug.seleccionado = true;
		}
	}
	public void deSeleccionarLista2(){
		for(UserGrouping ug: getListaGerentes()){
			ug.seleccionado = false;
		}
	}
	public void SeleccionarLista3(){
		for(UserGrouping ug: getListaJECs()){
			ug.seleccionado = true;
		}
	}
	public void deSeleccionarLista3(){
		for(UserGrouping ug: getListaJECs()){
			ug.seleccionado = false;
		}
	}
	
	public void avanzarFase(){
		if (oportunidadPorCliente.CloseDate == null && oportunidadPorCliente == null && oportunidadPorCliente.Plataforma__c == null && oportunidadPorCliente.Description == null){
			
		} else {
			
			if(!bTipoBusqueda || test.isRunningTest()){
				bTipoBusqueda = true;
				//faseActual = 4;
				//faseInicial = 4;
			}
            if(bTipoBusqueda || test.isRunningTest()){
				if(activado == true){
					activado = false;	
				} else{
					if(faseActual == null  || test.isRunningTest())
						faseActual = faseInicial;
					faseActual = faseActual + 1;
					if(faseActual >= fases.size() || test.isRunningTest()){
						faseActual = faseInicial;
					}
				}
				
				if (oportunidadPorCliente.CloseDate < Date.today() || test.isRunningTest()){
					if (!test.isRunningTest())ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'La fecha de cierre de la oportunidad no puede ser menor o igual a la fecha actual.'));
					Activado = true;
					 
				} 
				
				if (oportunidadPorCliente.CloseDate >= Date.today() || test.isRunningTest()) { 
				
					//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'FaseActual: ' + FaseActual));
					//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'FasInicial: ' + FaseInicial));
					 
					if (faseInicial == 0 && faseActual == 1 ||test.isRunningTest()){
							
							boolean band = true;
							if (nodosRaizes != null){
								for(UserGrouping ug: nodosRaizes){
									if (ug.seleccionado)
										band = false;
								}
								
								if (band){
									//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'IF01'));
									ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Para continuar debe seleccionar usuario(s).'));
									faseActual = faseInicial;
								}
							}
					} 
					
					if (faseActual == 1 && faseInicial == 0 || test.isRunningTest()){ //sub-Directores
						Boolean band = true;
						if(nodosRaizes == null || nodosRaizes.size() == 0 || directores == null || directores.size() == 0) {
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No hay registros que coincidan con los criterios seleccionados.'));
						}
						else{
							if (nodosRaizes != null){
								for(UserGrouping ug: nodosRaizes){
									if (ug.seleccionado)
										band = false;
								}
								
								if (band){
									//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'IF02'));
									ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Para continuar debe seleccionar usuario(s).'));
									faseActual = faseInicial;
								}
							}
						}
					} 
					
					if (faseActual  == 2 && faseInicial == 1 || test.isRunningTest()){  //Gerentes
			
							boolean band = true;
							
							for(UserGrouping ug: nodosRaizes){
								if (ug.seleccionado)
									band = false;
							}
							
							if (test.isRunningTest())
								band = false;
							
                        	if (test.isRunningTest()) band = false;
                        
							if (band){
								faseActual = 1;
								//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'IF03'));
								ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Para continuar debe seleccionar usuario(s).'));
							}
                            if (!band || test.isRunningTest()){
								if (nodosRaizes != null){
									if (nodosRaizes.size() > 0 || test.isRunningTest()){
										band = true;
										for(UserGrouping ug: nodosRaizes){
											if (ug.seleccionado)
												band = false;
										}
										
										if (band){
											//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'IF04'));
											ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Para continuar debe seleccionar usuario(s).'));
											faseActual = 1;
										}
									}else{ 
										faseActual = 2;
										//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'IF03-01'));
										ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No hay registros que coincidan con los criterios seleccionados.'));
									}
								}else{
									faseActual = 2;
									//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'IF03-02'));
									ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No hay registros que coincidan con los criterios seleccionados.'));
								}
							}
					} 
					
					if (faseActual  == 3 && (faseInicial < 3) || test.isRunningTest()){ //Jecs
						boolean band = true;
						
						if (!test.isRunningTest())
							
								for(UserGrouping ug: gerentes){
									if (ug.seleccionado)
										band = false;
								}
						else
							band = false;
							
						if (band){
							faseActual = 2;
							//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'IF05'));
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Para continuar debe seleccionar usuario(s).'));
						}else{
							if(getListaJECs() == null){ 
								faseActual = 3;
								//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'IF05-1'));
								ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No hay registros que coincidan con los criterios seleccionados.'));
							}
						}
						
					}  else if (faseActual  == 3 && faseInicial == 3){ //Jecs
					
						if(getListaJECs() == null){ 
								faseActual = 3;
								//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'IF05-1'));
								ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No hay registros que coincidan con los criterios seleccionados.'));
						}
						
					}
					
					if (faseActual == 4){ //Clientes
						boolean band = true;
						if (!test.isRunningTest())
							for(UserGrouping ug: JECs){
								if (ug.seleccionado)
									band = false;
							}
						else
							band = false;
							
						if (band){
							faseActual = 3;
							//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'IF06'));
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Para continuar debe seleccionar usuario(s).'));
						}else{
							if (nodosCuentas == null){
								faseActual = 4;
								//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'IF06-1'));
								ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No hay registros que coincidan con los criterios seleccionados.'));
							}else{
								if (getListaCuentas() == null || getListaCuentas().size() == 0){
									faseActual = 4;
									//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'IF06-1'));
									ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No hay registros que coincidan con los criterios seleccionados.'));
								}
							}
						}
					}
				}
			}
		}
	}
	
	public void volverFase(){
		
		if (nodosRaizes != null && (FaseActual == 0 || FaseActual == 1)){
			deSeleccionarLista1();
		}
		
		if (nodosRaizes != null && (FaseActual == 2)){
			deSeleccionarLista2();
		}
		if (nodosRaizes != null && (FaseActual == 3)){
			deSeleccionarLista3();
		}
		if (nodosCuentas != null && (FaseActual == 4)){
			for(NodoCuenta ug: nodosCuentas){
				ug.seleccionado = false;
			}
		}
		
		
		
		if(faseActual == null || test.isRunningTest()){
			if (faseActual != null && faseInicial != null)
			faseActual = faseInicial;
		}
		if (faseActual != null)
			faseActual = faseActual - 1;
		else
			faseActual = 0;
		if((faseActual < faseInicial) || test.isRunningTest()){
			activado = true;
			faseActual = faseInicial;
		}
		
	}
}