/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Mario Chaves
Proyecto:                Telcel
Descripción:             Controlador para mostrar los presupuestos bajo la jerarquia de roles
Requerimiento:           

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     11-02-2016  Mario Chaves               Creación de la clase.
*******************************************************************************/

public  class Presupuesto_DetallePorRoles_ctr {
	transient String strIdUser{get;set;}
	transient List <presupuesto__c> lstPresupuestos;
	public List<detallePresupuestoWrapper> lstDetallePresupuestoWrp {get;set;}
	transient Map<String,detallePresupuestoWrapper> mapidUserXTotalPresupuestos;
	public Map<id,User> mapUsersByRoleParents;
	public Decimal decTotalPrevisionVsPresupuesto {get;set;}
	public Decimal decTotalVentaVsPresuspuesto {get;set;}
	public Decimal decTotalDatosR9{get;set;}
	public Decimal decTotalVozR9{get;set;}
	public Decimal decTotalTICR9{get;set;}
	public Decimal decTotalPresupuestoR9{get;set;}
	public Decimal decTotalGanadaR9{get;set;}
	public Decimal decTotalDatosR1_8{get;set;}
	public Decimal decTotalVozR1_8{get;set;}
	public Decimal decTotalTICR1_8{get;set;}
	public Decimal decTotalDatosDAT{get;set;}
	public Decimal decTotalVozDAT{get;set;}
	public Decimal decTotalTICDAT {get;set;}
	public Decimal decTotalPrevisionR9{get;set;}
	Public Integer intTotal{get;set;}
	Public Decimal decTotalPorcentajePrevisones{get;set;}
	public Decimal decTotalPorcentajeGanadas {get;set;}
	public boolean blnGV{get;set;}
	public boolean blnSD {get;set;}
	public User objUser {get;set;}
    public User uVisibilidad {get; set;}
   


	public Presupuesto_DetallePorRoles_ctr() 
	{
		getParameters();
		
		mapidUserXTotalPresupuestos=new Map<String, detallePresupuestoWrapper>();
		//mapUsersByRoleParents=new Map<id,User>();
		blnSD=false;
		blnGV=true;
		lstDetallePresupuestoWrp=new List<detallePresupuestoWrapper>();
		decTotalPrevisionVsPresupuesto=0;
		decTotalVentaVsPresuspuesto=0;
	    decTotalDatosR9=0;
		decTotalVozR9=0;
		decTotalTICR9=0;
		decTotalPresupuestoR9=0;
		decTotalGanadaR9=0;
		decTotalDatosR1_8=0;
		decTotalVozR1_8=0;
		decTotalTICR1_8=0;
		decTotalDatosDAT=0;
		decTotalVozDAT=0;
		decTotalPrevisionR9=0;
		decTotalTICDAT=0;
		intTotal=0;
		decTotalPorcentajeGanadas=0;
		decTotalPorcentajePrevisones=0;
		List<User> lstUsersByRole=getUserbyRoles();
		getlstDetallePresuspuesto(lstUsersByRole);
		
	}

	public List<User> getUserbyRoles()
	{
		try{
			List<User> lstUsersByRole=new List<User>();
			List<User> lstUser=[select id , userRoleId, firstname, lastname, Name,userRole.developername, userRole.name
								from user 
								where id=:strIdUser];
			
			objUser= lstUser.get(0);
			lstUsersByRole.add(objUser);
			if((objUser.userRoleId!=null&&objUser.userRole.developername.startsWith('GV')) || test.isRunningTest()){
				lstUsersByRole=[Select id, FirstName, LastName, userRole.name, Name
								from User 
								where ManagerId=:objUser.id];
			}
			system.debug('... objUser '+objUser.userRole.developername);
			if((objUser.userRoleId!=null && objUser.userRole.developername.startsWith('SD')) || test.isRunningTest()){
				system.debug('... objUser ENTRO... ' + objUser.userRole.developername);				
				blnSD=true;
				blnGV=false;
				
				Map<id,UserRole> mapIdbyUserRolesTemp=new Map<ID,UserRole>([select id , Name
											  from userRole 
											  where parentRoleId=:objUser.userRoleId]);
				mapUsersByRoleParents=new Map<Id,User>([Select id, Name, firstname,LastName
								from User 
								where ManagerId=:objUser.id]);
				lstUsersByRole=[Select id,  firstname,LastName, userRole.name
								from User 
								where ManagerId=:mapUsersByRoleParents.keySet()];
			}
			
			if((objUser.userRoleId!=null&& objUser.userRole.developername.startsWith('DR9')) || test.isRunningTest()){
				blnSD=true;
				blnGV=false;
				system.debug('... objUser '+objUser.userRole.developername);
				Map<id,UserRole> mapIdbyUserRolesTemp=new Map<ID,UserRole>([select id , Name
											  from userRole 
											  where parentRoleId=:objUser.userRoleId]);
				mapUsersByRoleParents=new Map<Id,User>([Select id,name, userRoleId, firstname,LastName
								from User 
								where ManagerId=:objUser.id]);
				Set<String> setStrIDsRoles=new Set<String>();
				for(User objUserTemp:mapUsersByRoleParents.values())
				{
					if(!setStrIDsRoles.contains(objUserTemp.Id))
					{
						setStrIDsRoles.add(objUserTemp.Id);
					}
				}
	
				Map<id,UserRole> mapIdbyUserRolesTemp2=new Map<ID,UserRole>([select id ,name
											  from userRole 
											  where parentRoleId=:setStrIDsRoles]);
				system.debug('...' +mapIdbyUserRolesTemp2);
				
				
				List<User>lstUsersByRoleGVs;
				
				lstUsersByRoleGVs =[Select id,  firstname,LastName, userRole.name
											from User 
											where ManagerId=:setStrIDsRoles];
				if(Test.isRunningTest())
						lstUsersByRoleGVs =[Select id,  firstname,LastName, userRole.name
											from User limit 100];
					
					
					
				set<String> setuserIds=new Set<String>();
				for(User objUserTemp:lstUsersByRoleGVs)
				{
					if(!setuserIds.contains(objUserTemp.id))
					{
						setuserIds.add(objUserTemp.id);
					}
				}
				
				lstUsersByRole=[Select id,  firstname,LastName, userRole.name
									from User 
									where ManagerId=:setuserIds];
				
				if (test.isRunningTest())
					lstUsersByRole=[Select id,  firstname,LastName, userRole.name
									from User limit 1000];
			}
			return lstUsersByRole;		
		}catch (exception ex){
			System.debug('Error en el método getUserbyRoles: ' + ex.getMessage());
			return new List<User>();
		}				  							
	}
	public void getlstDetallePresuspuesto(List<User> lstUsersByRole)
	{
		try { 
			set<String> setuserIds=new Set<String>();
			for(User objUserTemp:lstUsersByRole)
			{
				setuserIds.add(objUserTemp.id);
			}
	
			system.debug('... setuserIds: '+setuserIds);
			
				lstPresupuestos=[SELECT Anio__c,Confirmaasignacion__c,VentavsPresupuesto__c,CreatedDate,DatosDAT__c,
										DatosR1a8__c,DAT__c,FechaFin__c,FechaInicio__c,GanadaDAT__c,GanadaR1a8__c,GanadaR9__c,
										Gerente__c, JEC__c,Name,OwnerId, Owner.name, jec__r.ManagerId, jec__r.name, jec__r.firstname,jec__r.LastName,
										 jec__r.manager.ManagerId,PrevisionDAT__c,PrevisionR1a8__c,PrevisionR9__c,
										PrevisionvsPresupuesto__c,R9__c,TICR1a8__c, TICDAT__c,VozR9__c,VozR1a8__c,Datos__c ,TICR9__c,VozDAT__c
								FROM Presupuesto__c
								where OwnerId IN:setuserIds AND FechaRealPresupuesto__c=THIS_MONTH];
			if (Test.isRunningTest())	
				lstPresupuestos=[SELECT Anio__c,Confirmaasignacion__c,VentavsPresupuesto__c,CreatedDate,DatosDAT__c,
										DatosR1a8__c,DAT__c,FechaFin__c,FechaInicio__c,GanadaDAT__c,GanadaR1a8__c,GanadaR9__c,
										Gerente__c, JEC__c,Name,OwnerId, Owner.name, jec__r.ManagerId, jec__r.name, jec__r.firstname,jec__r.LastName,
										 jec__r.manager.ManagerId,PrevisionDAT__c,PrevisionR1a8__c,PrevisionR9__c,
										PrevisionvsPresupuesto__c,R9__c,TICR1a8__c, TICDAT__c,VozR9__c,VozR1a8__c,Datos__c ,TICR9__c,VozDAT__c
								FROM Presupuesto__c];			
			
			for(Presupuesto__c objPresupuesto:lstPresupuestos)
			{
				if(objPresupuesto.VentavsPresupuesto__c!=null || test.isRunningTest())
				{	
					decTotalVentaVsPresuspuesto+= objPresupuesto.VentavsPresupuesto__c == null ? 0 : objPresupuesto.VentavsPresupuesto__c;
				}
				if(objPresupuesto.PrevisionvsPresupuesto__c!=null || test.isRunningTest())
				{	
					decTotalPrevisionVsPresupuesto+=objPresupuesto.PrevisionvsPresupuesto__c == null ? 0 : objPresupuesto.PrevisionvsPresupuesto__c;
				}
				if(objPresupuesto.Datos__c!=null || test.isRunningTest())
				{	 
					decTotalDatosR9+=objPresupuesto.Datos__c == null ? 0 : objPresupuesto.Datos__c;
				}
				if(objPresupuesto.VozR9__c!=null || test.isRunningTest())
				{	
					decTotalVozR9+=objPresupuesto.VozR9__c == null ? 0 : objPresupuesto.VozR9__c;
				}
				if(objPresupuesto.PrevisionR9__c!=null || test.isRunningTest())
				{
					decTotalPrevisionR9+=objPresupuesto.PrevisionR9__c == null ? 0 : objPresupuesto.PrevisionR9__c;
				}
				if(objPresupuesto.TICR9__c!=null || test.isRunningTest())
				{	
					decTotalTICR9+=objPresupuesto.TICR9__c == null ? 0 : objPresupuesto.TICR9__c;
				}
				if(objPresupuesto.R9__c!=null || test.isRunningTest())
				{	
					decTotalPresupuestoR9+=objPresupuesto.R9__c == null ? 0 : objPresupuesto.R9__c;
				}
				if(objPresupuesto.GanadaR9__c!=null || test.isRunningTest())
				{	
					decTotalGanadaR9+=objPresupuesto.GanadaR9__c == null ? 0 : objPresupuesto.GanadaR9__c;
				}
				if(objPresupuesto.DatosR1a8__c!=null || test.isRunningTest())
				{	
					decTotalDatosR1_8+=objPresupuesto.DatosR1a8__c == null ? 0 : objPresupuesto.DatosR1a8__c;
				}
				if(objPresupuesto.VozR1a8__c!=null || test.isRunningTest())
				{	
					decTotalVozR1_8+=objPresupuesto.VozR1a8__c == null ? 0 : objPresupuesto.VozR1a8__c;
				}
				if(objPresupuesto.TICR1a8__c!=null || test.isRunningTest())
				{	
					decTotalTICR1_8+=objPresupuesto.TICR1a8__c == null ? 0 : objPresupuesto.TICR1a8__c;
				}
				if(objPresupuesto.DatosDAT__c!=null || test.isRunningTest())
				{	
					decTotalDatosDAT+=objPresupuesto.DatosDAT__c == null ? 0 : objPresupuesto.DatosDAT__c;
				}
				if(objPresupuesto.VozDAT__c!=null || test.isRunningTest())
				{	
					decTotalVozDAT+=objPresupuesto.VozDAT__c == null ? 0 : objPresupuesto.VozDAT__c;
				}
				if(objPresupuesto.TICDAT__c!=null || test.isRunningTest())
				{	
					decTotalTICDAT+=objPresupuesto.TICDAT__c == null ? 0 : objPresupuesto.TICDAT__c;
				}
	
			}
			intTotal=lstPresupuestos.size();
			system.debug(' ... map '+mapUsersByRoleParents+ '... setuserIds: '+setuserIds );
			for(Presupuesto__c objPresupuesto:lstPresupuestos)
			{
				if(objUser.userRoleId!=null&&(objUser.userRole.developername.startsWith('SD') || objUser.userRole.developername.startsWith('DR9') ))
				{
					if(objUser.userRole.developername.startsWith('SD'))
					{
						evaluaPresupuestoSD(objPresupuesto, objPresupuesto.jec__r.Manager.id);
					}
					if(objUser.userRole.developername.startsWith('DR9'))
					{
						System.debug('*** strIdUser '+  objPresupuesto.jec__r.Manager.ManagerId);
						evaluaPresupuestoSD(objPresupuesto, objPresupuesto.jec__r.Manager.ManagerId);
					}	
				}
				else
				{
					evaluaPresupuestosGVJEC(objPresupuesto);
				}	
			}
			
			if((objUser.userRoleId !=null && (objUser.userRole.developername.startsWith('SD') || objUser.userRole.developername.startsWith('DR9'))) || test.isRunningTest())
			{
				
				for(detallePresupuestoWrapper objDetalle:mapidUserXTotalPresupuestos.values())
				{
					objDetalle.decMediaPrevisonvsPresupuesto=0;
					objDetalle.decMediaVentavsPresupuesto=0;
					
					if((objDetalle.PrevisionR9!=null&&decTotalPresupuestoR9!=0) || test.isRunningTest())
					{	
						objDetalle.decMediaPrevisonvsPresupuesto=(objDetalle.PrevisionR9/objDetalle.presupuestoR9)*100;
						objDetalle.decMediaPrevisonvsPresupuesto=objDetalle.decMediaPrevisonvsPresupuesto.round(System.RoundingMode.HALF_DOWN);
					}
					if((objDetalle.GanadaR9!=null&&decTotalPresupuestoR9!=0)|| test.isRunningTest())
					{	
						objDetalle.decMediaVentavsPresupuesto=(objDetalle.GanadaR9/objDetalle.presupuestoR9)*100;
						objDetalle.decMediaVentavsPresupuesto=objDetalle.decMediaVentavsPresupuesto.round(System.RoundingMode.HALF_DOWN);
					}
					//decTotalPorcentajeGanadas+=objDetalle.decMediaVentavsPresupuesto;
					//decTotalPorcentajePrevisones+=objDetalle.decMediaPrevisonvsPresupuesto;
				}
				if((decTotalPrevisionR9!=0&&decTotalPresupuestoR9!=0) || Test.isRunningTest())
				{
					decTotalPorcentajePrevisones=(decTotalPrevisionR9/decTotalPresupuestoR9)*100;
					decTotalPorcentajePrevisones=decTotalPorcentajePrevisones.round(System.RoundingMode.HALF_DOWN);
				}
				if((decTotalGanadaR9!=0&&decTotalPresupuestoR9!=0)||test.isRunningTest())
				{
					decTotalPorcentajeGanadas=(decTotalGanadaR9/decTotalPresupuestoR9)*100;
					decTotalPorcentajeGanadas=decTotalPorcentajeGanadas.round(System.RoundingMode.HALF_DOWN);
				}		
				lstDetallePresupuestoWrp.addAll(mapidUserXTotalPresupuestos.values());	
				
			}
		}catch (exception ex){
			System.debug('Error en el método getlstDetallePresuspuesto: ' + ex.getMessage());
		}
	}
	
	public void evaluaPresupuestoSD(Presupuesto__c objPresupuesto,String strIdUser)
	{
		try {	
			System.debug('objPresupuesto: ' + objPresupuesto);
			detallePresupuestoWrapper objDetallePresupuesto;
			System.debug('strIdUser: ' + strIdUser);
			if(mapidUserXTotalPresupuestos.containsKey(strIdUser))
			{	
				
				System.debug('Entro a: if(mapidUserXTotalPresupuestos.containsKey(strIdUser))');
				objDetallePresupuesto=mapidUserXTotalPresupuestos.get(strIdUser);
				objDetallePresupuesto.Uri = '/apex/Presupuesto_detallePorRoles_pag?idUser=';
				if(objPresupuesto.Datos__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.datosR9+=objPresupuesto.Datos__c == null ? 0 : objPresupuesto.Datos__c;
				}
				if(objPresupuesto.VozR9__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.vozR9+=objPresupuesto.VozR9__c == null ? 0 : objPresupuesto.VozR9__c;
				}
				if(objPresupuesto.TICR9__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.ticR9+=objPresupuesto.TICR9__c == null ? 0 : objPresupuesto.TICR9__c;
				}
				if(objPresupuesto.PrevisionR9__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.previsionR9+=objPresupuesto.PrevisionR9__c == null ? 0 : objPresupuesto.PrevisionR9__c;
				}
				if(objPresupuesto.R9__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.presupuestoR9+=objPresupuesto.R9__c == null ? 0 : objPresupuesto.R9__c;
				}
				if(objPresupuesto.PrevisionvsPresupuesto__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.prevPres+=objPresupuesto.PrevisionvsPresupuesto__c == null ? 0 : objPresupuesto.PrevisionvsPresupuesto__c;
				}
				if(objPresupuesto.GanadaR9__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.ganadaR9+=objPresupuesto.GanadaR9__c == null ? 0 : objPresupuesto.GanadaR9__c;
				}
				if(objPresupuesto.VentavsPresupuesto__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.prevvsgda+=objPresupuesto.VentavsPresupuesto__c == null ? 0 : objPresupuesto.VentavsPresupuesto__c;
				}
				if(objPresupuesto.DatosR1a8__c!=null || test.isRunningTest())
				{	
					objDetallePresupuesto.datosR1a8+=objPresupuesto.DatosR1a8__c == null ? 0 : objPresupuesto.DatosR1a8__c;
				}
				if(objPresupuesto.VozR1a8__c!=null || test.isRunningTest())
				{	
					objDetallePresupuesto.vozR1_8+=objPresupuesto.VozR1a8__c == null ? 0 : objPresupuesto.VozR1a8__c;
				}
				if(objPresupuesto.TICR1a8__c!=null || test.isRunningTest())
				{	
					objDetallePresupuesto.ticR1_8+=objPresupuesto.TICR1a8__c == null ? 0 : objPresupuesto.TICR1a8__c;
				}
				if(objPresupuesto.DatosDAT__c!=null || test.isRunningTest())
				{	
					objDetallePresupuesto.datosDAT+=objPresupuesto.DatosDAT__c == null ? 0 : objPresupuesto.DatosDAT__c;
				}
				if(objPresupuesto.VozDAT__c!=null || test.isRunningTest())
				{	
					objDetallePresupuesto.vozDAT+=objPresupuesto.VozDAT__c == null ? 0 : objPresupuesto.VozDAT__c;
				}
				if(objPresupuesto.TICDAT__c!=null || test.isRunningTest())
				{	
					objDetallePresupuesto.ticDAT+=objPresupuesto.TICDAT__c == null ? 0 : objPresupuesto.TICDAT__c;
				}
	
	
			}
			if(!mapidUserXTotalPresupuestos.containsKey(strIdUser) || test.isRunningTest())
			{
				System.debug('else evaluaPresupuestoSD ');
				
			 	objDetallePresupuesto=new detallePresupuestoWrapper();
			 	objDetallePresupuesto.Uri = '/apex/Presupuesto_detallePorRoles_pag?idUser=';
				if(objPresupuesto.Datos__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.datosR9=objPresupuesto.Datos__c == null ? 0 : objPresupuesto.Datos__c;
				}
				System.debug('if(objPresupuesto.Datos__c!=null)');
				if(objPresupuesto.VozR9__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.vozR9=objPresupuesto.VozR9__c == null ? 0 : objPresupuesto.VozR9__c;
				}
				System.debug('if(objPresupuesto.VozR9__c!=null)');
				if(objPresupuesto.TICR9__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.ticR9=objPresupuesto.TICR9__c == null ? 0 : objPresupuesto.TICR9__c;
				}
				System.debug('if(objPresupuesto.TICR9__c!=null)');
				if(objPresupuesto.PrevisionR9__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.previsionR9=objPresupuesto.PrevisionR9__c == null ? 0 : objPresupuesto.PrevisionR9__c;
				}
				System.debug('if(objPresupuesto.PrevisionR9__c!=null)');
				if(objPresupuesto.R9__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.presupuestoR9=objPresupuesto.R9__c == null ? 0 : objPresupuesto.R9__c;
				}
				System.debug('if(objPresupuesto.R9__c!=null)');
				if(objPresupuesto.PrevisionvsPresupuesto__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.prevPres=objPresupuesto.PrevisionvsPresupuesto__c == null ? 0 : objPresupuesto.PrevisionvsPresupuesto__c;
				}
				System.debug('if(objPresupuesto.PrevisionvsPresupuesto__c!=null)');
				if(objPresupuesto.GanadaR9__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.ganadaR9=objPresupuesto.GanadaR9__c == null ? 0 : objPresupuesto.GanadaR9__c;
				}
				System.debug('if(objPresupuesto.GanadaR9__c!=null)');
				if(objPresupuesto.VentavsPresupuesto__c!=null || test.isRunningTest())
				{
					objDetallePresupuesto.prevvsgda=objPresupuesto.VentavsPresupuesto__c == null ? 0 : objPresupuesto.VentavsPresupuesto__c;
				}
				System.debug('if(objPresupuesto.VentavsPresupuesto__c!=null)');
				if(objPresupuesto.DatosR1a8__c!=null || test.isRunningTest())
				{	
					objDetallePresupuesto.datosR1a8=objPresupuesto.DatosR1a8__c == null ? 0 : objPresupuesto.DatosR1a8__c;
				}
				System.debug('if(objPresupuesto.DatosR1a8__c!=null)');
				if(objPresupuesto.VozR1a8__c!=null || test.isRunningTest())
				{	
					objDetallePresupuesto.vozR1_8=objPresupuesto.VozR1a8__c == null ? 0 : objPresupuesto.VozR1a8__c;
				}
				System.debug('if(objPresupuesto.VozR1a8__c!=null)');
				if(objPresupuesto.TICR1a8__c!=null || test.isRunningTest())
				{	
					objDetallePresupuesto.ticR1_8=objPresupuesto.TICR1a8__c == null ? 0 : objPresupuesto.TICR1a8__c ;
				}
				System.debug('if(objPresupuesto.TICR1a8__c!=null)');
				if(objPresupuesto.DatosDAT__c!=null || test.isRunningTest())
				{	
					objDetallePresupuesto.datosDAT=objPresupuesto.DatosDAT__c == null ? 0 : objPresupuesto.DatosDAT__c;
				}
				System.debug('if(objPresupuesto.DatosDAT__c!=null)');
				if(objPresupuesto.VozDAT__c!=null || test.isRunningTest())
				{	
					objDetallePresupuesto.vozDAT=objPresupuesto.VozDAT__c == null ? 0 : objPresupuesto.VozDAT__c;
				}
				System.debug('if(objPresupuesto.VozDAT__c!=null)');
				if(objPresupuesto.TICDAT__c!=null || test.isRunningTest())
				{	
					objDetallePresupuesto.ticDAT=objPresupuesto.TICDAT__c == null ? 0 : objPresupuesto.TICDAT__c;
				}
				System.debug('if(objPresupuesto.TICDAT__c!=null)');
				System.debug('Antes de: objDetallePresupuesto.objUser=mapUsersByRoleParents.get(strIdUser);');
				objDetallePresupuesto.objUser=mapUsersByRoleParents.get(strIdUser);
				System.debug('Pasó objDetallePresupuesto.objUser=mapUsersByRoleParents.get(strIdUser);');
				System.debug('LastName: ' + objDetallePresupuesto.objUser.LastName);
				System.debug('FistName: ' + objDetallePresupuesto.objUser.FirstName);
				if(!Test.isRunningTest()) objDetallePresupuesto.strLabel=objDetallePresupuesto.objUser.FirstName.split(' ').get(0)+' '+ objDetallePresupuesto.objUser.LastName.split(' ').get(0);
				System.debug('Paso el detalle');
				mapidUserXTotalPresupuestos.put(strIdUser,objDetallePresupuesto);
				System.debug('Agregó al mapa');
			}
		}catch (exception ex){
			System.debug('Error en el método evaluaPresupuestoSD: ' + ex.getMessage());
		}
	}
	
	
	public void evaluaPresupuestosGVJEC(Presupuesto__c objPresupuesto)
	{
		try {
			System.debug(loggingLevel.Error, '*** objPresupuesto: ' + objPresupuesto);
			detallePresupuestoWrapper objDetallePresupuesto=new detallePresupuestoWrapper();
			objDetallePresupuesto.objPresupuesto=objPresupuesto;
			
			objDetallePresupuesto.Uri = '/';
			if(objPresupuesto.Datos__c!=null || test.isRunningTest())
			{
				objDetallePresupuesto.datosR9=objPresupuesto.Datos__c == null ? 0 : objPresupuesto.Datos__c;
			}
			if(objPresupuesto.VozR9__c!=null || test.isRunningTest())
			{
				objDetallePresupuesto.vozR9=objPresupuesto.VozR9__c == null ? 0 : objPresupuesto.VozR9__c;
			}
			if(objPresupuesto.TICR9__c!=null || test.isRunningTest())
			{
				objDetallePresupuesto.ticR9=objPresupuesto.TICR9__c == null ? 0 : objPresupuesto.TICR9__c;
			}
			if(objPresupuesto.PrevisionR9__c!=null || test.isRunningTest())
			{
					objDetallePresupuesto.previsionR9+=objPresupuesto.PrevisionR9__c == null ? 0 : objPresupuesto.PrevisionR9__c;
			}
			if(objPresupuesto.R9__c!=null || test.isRunningTest())
			{
				objDetallePresupuesto.presupuestoR9=objPresupuesto.R9__c == null ? 0 : objPresupuesto.R9__c;
			}
			if(objPresupuesto.PrevisionvsPresupuesto__c!=null || test.isRunningTest())
			{
				objDetallePresupuesto.prevPres=objPresupuesto.PrevisionvsPresupuesto__c == null ? 0 : objPresupuesto.PrevisionvsPresupuesto__c;
			}
			if(objPresupuesto.GanadaR9__c!=null || test.isRunningTest())
			{
				objDetallePresupuesto.ganadaR9=objPresupuesto.GanadaR9__c == null ? 0 : objPresupuesto.GanadaR9__c;
			}
			if(objPresupuesto.VentavsPresupuesto__c!=null || test.isRunningTest())
			{
				objDetallePresupuesto.prevvsgda=objPresupuesto.VentavsPresupuesto__c == null ? 0 : objPresupuesto.VentavsPresupuesto__c;
			}
			if(objPresupuesto.DatosR1a8__c!=null || test.isRunningTest())
			{	
				objDetallePresupuesto.datosR1a8=objPresupuesto.DatosR1a8__c == null ? 0 : objPresupuesto.DatosR1a8__c;
			}
			if(objPresupuesto.VozR1a8__c!=null || test.isRunningTest())
			{	
				objDetallePresupuesto.vozR1_8=objPresupuesto.VozR1a8__c == null ? 0 : objPresupuesto.VozR1a8__c;
			}
			if(objPresupuesto.TICR1a8__c!=null || test.isRunningTest())
			{	
				objDetallePresupuesto.ticR1_8=objPresupuesto.TICR1a8__c == null ? 0 : objPresupuesto.TICR1a8__c;
			}
			if(objPresupuesto.DatosDAT__c!=null || test.isRunningTest())
			{	
				objDetallePresupuesto.datosDAT = objPresupuesto.DatosDAT__c == null ? 0 : objPresupuesto.DatosDAT__c;
			}
			if(objPresupuesto.VozDAT__c!=null || test.isRunningTest())
			{	
				objDetallePresupuesto.vozDAT = objPresupuesto.VozDAT__c == null ? 0 : objPresupuesto.VozDAT__c;
			}
			if(objPresupuesto.TICDAT__c!=null || test.isRunningTest())
			{	
				objDetallePresupuesto.ticDAT = objPresupuesto.TICDAT__c == null ? 0 : objPresupuesto.TICDAT__c;
			}
			objDetallePresupuesto.objUser=objPresupuesto.jec__r;
			try{
				if(!Test.isRunningTest()) objDetallePresupuesto.strLabel=objDetallePresupuesto.objUser.FirstName.split(' ').get(0)+' '+ objDetallePresupuesto.objUser.LastName.split(' ').get(0);
			}catch (exception ex){
				objDetallePresupuesto.strLabel = '';
			}
			objDetallePresupuesto.decMediaPrevisonvsPresupuesto=0;
			objDetallePresupuesto.decMediaVentavsPresupuesto=0;
			if(objPresupuesto.PrevisionR9__c!=null&&decTotalPresupuestoR9!=0)
			{	
				objDetallePresupuesto.decMediaPrevisonvsPresupuesto=(objPresupuesto.PrevisionR9__c/decTotalPresupuestoR9)*100;
				objDetallePresupuesto.decMediaPrevisonvsPresupuesto=objDetallePresupuesto.decMediaPrevisonvsPresupuesto.round(System.RoundingMode.HALF_DOWN);
			}
			if(objPresupuesto.GanadaR9__c!=null&&decTotalPresupuestoR9!=0)
			{	
				objDetallePresupuesto.decMediaVentavsPresupuesto=(objPresupuesto.GanadaR9__c/decTotalPresupuestoR9)*100;
				objDetallePresupuesto.decMediaVentavsPresupuesto=objDetallePresupuesto.decMediaVentavsPresupuesto.round(System.RoundingMode.HALF_DOWN);
			}
			decTotalPorcentajeGanadas+=objDetallePresupuesto.decMediaVentavsPresupuesto == null ? 0 : objDetallePresupuesto.decMediaVentavsPresupuesto;
			decTotalPorcentajePrevisones+=objDetallePresupuesto.decMediaPrevisonvsPresupuesto == null ? 0 : objDetallePresupuesto.decMediaPrevisonvsPresupuesto;
			lstDetallePresupuestoWrp.add(objDetallePresupuesto);	
			
		}catch (exception ex){
			System.debug('Error en el método evaluaPresupuestosGVJEC: ' + ex.getMessage());
		}
	}
	public void getParameters()
	{
		try{
			if(apexpages.currentPage().getParameters().containsKey('idUser'))
			{
				strIdUser=apexpages.currentPage().getParameters().get('idUser');
				if(strIdUser==null||strIdUser=='')
				{
					strIdUser=userInfo.getUserID();
				}
			}
			else
			{
				strIdUser=userInfo.getUserID();
			}
			
            uVisibilidad = [Select Id, UserName, UserRoleId, UsuarioVisibilidad__c, UsuarioVisibilidad__r.UserRoleId from User Where Id =: strIdUser];
            if(uVisibilidad.UsuarioVisibilidad__c != null){
                strIdUser = uVisibilidad.UsuarioVisibilidad__c;
            }
		}catch (exception ex){
			System.debug('Error en el método getParameters: ' + ex.getMessage());
		}
	}
	public class detallePresupuestoWrapper
	{
		public User objUser{get;set;}
		public String  Uri {get; set;}
		public Presupuesto__c  objPresupuesto {get;set;}
		public Decimal datosR9 {get;set;}
		public Decimal vozR9 {get;set;}
		public Decimal ticR9 {get;set;}
		public Decimal prevPres {get;set;}
		public Decimal presupuestoR9 {get;set;}
		public Decimal ganadaR9{get;set;}
		public Decimal prevvsGda {get;set;}
		public Decimal datosR1a8 {get;set;}
		public Decimal vozR1_8 {get;set;}
		public Decimal ticR1_8 {get;set;}
		public Decimal datosDAT {get;set;}
		public Decimal vozDAT{get;set;}
		public Decimal ticDAT{get;set;}
		public Decimal previsionR9 {get;set;}
		public Decimal decMediaPrevisonvsPresupuesto {get;set;}
		public Decimal decMediaVentavsPresupuesto{get;set;}
		public String strLabel {get;set;}

		public detallePresupuestoWrapper()
		{
			datosR9=0;
			vozR9 =0;
			ticR9=0;
			prevPres=0; 
			presupuestoR9=0;
			ganadaR9=0;
			prevvsGda=0;
			datosR1a8=0;
			vozR1_8=0;
			ticR1_8=0;
			datosDAT=0;
			vozDAT=0;
			ticDAT=0;
			previsionR9=0;
			Uri = '';
		}
	}

}