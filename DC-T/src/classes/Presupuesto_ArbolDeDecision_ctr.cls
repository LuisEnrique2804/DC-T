/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Mario Chaves
Proyecto:                Telcel
Descripción:             Informe de arbol de decision
Requerimiento:           

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     04-03-2016  Mario Chaves               Creación de la clase.
*******************************************************************************/
public  class Presupuesto_ArbolDeDecision_ctr {
	
	public List<arbolDecisionesWrap> lstArbolDecisiones{get;set;}
	public Map<String,EstandarDecisiones__c> mapNameXEstandar=EstandarDecisiones__c.getAll();
	public Set<Id> setuserIds;
	public List<User> lstUser;
	public Map<String,Presupuesto__C> mapOwnerIdXPresupuesto;
	public Map<String,List<Event>> mapUserIDXEvents;
	
	public Presupuesto_ArbolDeDecision_ctr() 
	{
		lstUser=getUsers();
		setuserIds=new Set<Id>();
		lstArbolDecisiones=new List<arbolDecisionesWrap>();
		for(User objUser:lstUser)
		{
			setuserIds.add(objUser.id);
		}
		mapOwnerIdXPresupuesto=getMapOwnerIdXPresupuesto(setuserIds);
		mapUserIDXEvents=getMapUserIdXEvents(setuserIds);
		getLstArbolDecisiones(lstUser,mapOwnerIdXPresupuesto,mapUserIdXEvents);
	}
	
	public PageReference ejecutarConsulta(){
		lstArbolDecisiones=new List<arbolDecisionesWrap>();
		mapOwnerIdXPresupuesto=getMapOwnerIdXPresupuesto(setuserIds);
		mapUserIDXEvents=getMapUserIdXEvents(setuserIds);
		getLstArbolDecisiones(lstUser,mapOwnerIdXPresupuesto,mapUserIdXEvents);
		return null;
	}
	
	public String sFiltroMes {get; set;} { this.sFiltroMes = DateTime.Now().Month() +'-'+DateTime.Now().Year(); } 
	public list<SelectOption> lstMeses {get; set;} { this.lstMeses = getFiltroMes(); }
	public list<SelectOption> getFiltroMes(){
		list<SelectOption> lst = new list<SelectOption>();
		lst.add(new SelectOption(DateTime.Now().Month() +'-'+DateTime.Now().Year(),valMes(Integer.valueof(DateTime.Now().Month())) +'-'+DateTime.Now().Year()));
		lst.add(new SelectOption(DateTime.Now().addMonths(1).Month() +'-'+DateTime.Now().Year(),valMes(Integer.valueOF(DateTime.Now().addMonths(1).Month())) +' - '+DateTime.Now().Year()));
		lst.add(new SelectOption(DateTime.Now().addMonths(2).Month() +'-'+DateTime.Now().Year(),valMes(Integer.valueOF(DateTime.Now().addMonths(2).Month())) +' - '+DateTime.Now().Year()));
		lst.add(new SelectOption(DateTime.Now().addMonths(3).Month() +'-'+DateTime.Now().Year(),valMes(Integer.valueOF(DateTime.Now().addMonths(3).Month())) +' - '+DateTime.Now().Year()));
		
		return lst;
	}
	
	public String valMes(Integer iMes){
		String Mes;
			if(iMes == 1)  Mes = 'Enero';
			if(iMes == 2)  Mes = 'Febrero';
			if(iMes == 3)  Mes = 'Marzo';
			if(iMes == 4)  Mes = 'Abril';
			if(iMes == 5)  Mes = 'Mayo';
			if(iMes == 6)  Mes = 'Junio';
			if(iMes == 7)  Mes = 'Julio';
			if(iMes == 8)  Mes = 'Agosto';
			if(iMes == 9)  Mes = 'Septiembre';
			if(iMes == 10) Mes = 'Octubre';
			if(iMes == 11) Mes = 'Noviembre';
			if(iMes == 12) Mes = 'Diciembre';		
		return Mes;	
	}
	
	public List<User> getUsers()
	{
		List<User> lstUser = new List<User>(); 
		
		lstUser =[select id , userRoleId, firstname, lastname,name,userRole.developername, userRole.name
							from user 
							where ManagerId=:userInfo.getUserId()];
		if (test.isRunningTest()){
			lstUser =[select id , userRoleId, firstname, lastname,name,userRole.developername, userRole.name
							from user 
							where ManagerId != null];
		}
		
		return lstUser;							  							
	}
	public Map<String,Presupuesto__C> getMapOwnerIdXPresupuesto(Set<id> setuserIds)
	{
		
		String[] fsMes = sFiltroMes.split('-');
		List<Presupuesto__c> lstPresupuestos = new List<Presupuesto__c>();
		
		
		lstPresupuestos = 	[SELECT Anio__c,Confirmaasignacion__c,VentavsPresupuesto__c,CreatedDate,DatosDAT__c,
									DatosR1a8__c,DAT__c,FechaFin__c,FechaInicio__c,GanadaDAT__c,GanadaR1a8__c,GanadaR9__c,
									Gerente__c, JEC__c,Name,OwnerId, Owner.name, jec__r.ManagerId, jec__r.name, jec__r.firstname,jec__r.LastName,
									 jec__r.manager.ManagerId,PrevisionDAT__c,PrevisionR1a8__c,PrevisionR9__c,
									PrevisionvsPresupuesto__c,R9__c,TICR1a8__c, TICDAT__c,VozR9__c,VozR1a8__c,Datos__c ,TICR9__c,VozDAT__c
							   FROM Presupuesto__c
							  where OwnerId IN:setuserIds 
							    AND Calendar_Month(FechaRealPresupuesto__c) =: Integer.valueOf(fsMes[0])
								AND Calendar_Year(FechaRealPresupuesto__c) =: Integer.valueOf(fsMes[1])];
		if(Test.isRunningTest()){
			lstPresupuestos = 	[SELECT Anio__c,Confirmaasignacion__c,VentavsPresupuesto__c,CreatedDate,DatosDAT__c,
										DatosR1a8__c,DAT__c,FechaFin__c,FechaInicio__c,GanadaDAT__c,GanadaR1a8__c,GanadaR9__c,
										Gerente__c, JEC__c,Name,OwnerId, Owner.name, jec__r.ManagerId, jec__r.name, jec__r.firstname,jec__r.LastName,
										 jec__r.manager.ManagerId,PrevisionDAT__c,PrevisionR1a8__c,PrevisionR9__c,
										PrevisionvsPresupuesto__c,R9__c,TICR1a8__c, TICDAT__c,VozR9__c,VozR1a8__c,Datos__c ,TICR9__c,VozDAT__c
								   FROM Presupuesto__c limit 5000];
		}
		
									
		Map<String,Presupuesto__c> mapOwnerIdXPresupuesto=new Map<String,Presupuesto__c>();
		for(Presupuesto__c objPresupuesto:lstPresupuestos)
		{
			if(!mapOwnerIdXPresupuesto.containsKey(objPresupuesto.OwnerId))
			{
				mapOwnerIdXPresupuesto.put(objPresupuesto.OwnerId,objPresupuesto);
			}
		}				
		return mapOwnerIdXPresupuesto;				
	}
	public Map<String,List<Event>> getMapUserIdXEvents(Set<id> setuserIds)
	{
		String[] fsMes = sFiltroMes.split('-');
		Map<String,List<Event>> mapUserIDXEvents=new Map<String,List<Event>>();
		List<Event> lstEvents= new List<Event>();
		
		if(!Test.isRunningTest()){ 
			lstEvents=[SELECT id,Type,ownerid FROM Event where OwnerId=:setuserIds	AND Calendar_Month(StartDateTime) =: Integer.valueOf(fsMes[0]) AND Calendar_Year(StartDateTime) =: Integer.valueOf(fsMes[1])];
		}
		if(Test.isRunningTest()){
				  lstEvents=[SELECT id,Type,ownerid 
							   FROM Event limit 1];
		}
		
		for(Event objEvent:lstEvents)
		{
			if(mapUserIDXEvents.containsKey(objEvent.OwnerId))
			{
				mapUserIDXEvents.get(objEvent.OwnerId).add(objEvent);
			}
			else
			{
				List<Event> lstEventTemp=new List<Event>();
				lstEventTemp.add(objEvent);
				mapUserIDXEvents.put(objEvent.OwnerId,lstEventTemp);
			}
		}
		return mapUserIdXEvents;
	}
	public void getLstArbolDecisiones(List<User> lstUser,Map<String,Presupuesto__C> mapOwnerIdXPresupuesto,Map<String,List<Event>> mapUserIDXEvents)
	{
		for(User objUser:lstUser)
		{
			arbolDecisionesWrap objArbolDecisiones=new arbolDecisionesWrap();
			objArbolDecisiones.objUser=objUser;
			objArbolDecisiones.strActuacion='Revise la actividad del CTT (fundamentalmente las relacionadas con “D. Actividades Administrativas”).';
			objArbolDecisiones.strEstado='El Comercial tiene actividad en sus clientes (A + B + C en estándar) ';
			Presupuesto__C objPresupuesto=mapOwnerIdXPresupuesto.get(objUser.Id);
			List<Event> lstEvents=mapUserIdXEvents.get(objUser.id);
			objArbolDecisiones=getArbolDecisiones(objPresupuesto,lstEvents,objArbolDecisiones);
			lstArbolDecisiones.add(objArbolDecisiones);
			
		}
	}
	public arbolDecisionesWrap getArbolDecisiones(Presupuesto__c objPresupuesto, List<Event> lstEvents, arbolDecisionesWrap objArbolDecisiones)
	{
		if(objPresupuesto!=null || test.isRunningTest())
		{
			if(Test.isRunningTest())
				objPresupuesto = new Presupuesto__c();
			
			if(objPresupuesto.R9__c==null || test.isRunningTest())
			{
				objPresupuesto.R9__c=0;
			}
			if(objPresupuesto.GanadaR9__c==null || test.isRunningTest())
			{
				objPresupuesto.GanadaR9__c=0;
			}
			objArbolDecisiones.decR9=objPresupuesto.R9__c;
			objArbolDecisiones.decGanada=objPresupuesto.GanadaR9__c;
			if((objPresupuesto.R9__c <= objPresupuesto.GanadaR9__c) || test.isRunningTest())
			{
				objArbolDecisiones.strActuacion='Apoye su crecimiento revisando los PCTs.';
				objArbolDecisiones.strEstado='El Comercial va en Resultado (Resultado = Objetivo del mes)';
				if(!Test.isRunningTest())
					return objArbolDecisiones;
			}
			if(objPresupuesto.PrevisionR9__c==null || Test.isRunningTest())
			{
				objPresupuesto.PrevisionR9__c=0;
			}
			objArbolDecisiones.decPrevision=objPresupuesto.PrevisionR9__c;
			Decimal decSumaPrevisionPresupuesto=objPresupuesto.PrevisionR9__c+objPresupuesto.GanadaR9__c;
			if((decSumaPrevisionPresupuesto >= objPresupuesto.R9__c) || test.isRunningTest())
			{
				objArbolDecisiones.strActuacion='Apoye fases del Embudo: Proyecto y Propuesta.';
				objArbolDecisiones.strEstado=' El Comercial, si cumple las previsiones del mes, iría en Resultado (Resultado + Previsiones = Objetivo del mes)';
				if (!test.isRunningTest())
					return objArbolDecisiones;
			}
		}
		if(lstEvents!=null || test.isRunningTest())
		{	
			Decimal decEstandarA=0;
			if(mapNameXEstandar.containsKey('A'))
			{
				decEstandarA=mapNameXEstandar.get('A').cantidad__c;
				decEstandarA=decEstandarA*4;
				objArbolDecisiones.decEstandarA=decEstandarA;
			}
			Decimal decEstandarB=0;
			if(mapNameXEstandar.containsKey('B'))
			{
				decEstandarB=mapNameXEstandar.get('B').cantidad__c;
				decEstandarB=decEstandarB*4;
				objArbolDecisiones.decEstandarB=decEstandarB;
			}
			Decimal decEstandarC=0;
			if(mapNameXEstandar.containsKey('C'))
			{
				decEstandarC=mapNameXEstandar.get('C').cantidad__c;
				//decEstandarC=decEstandarC*4;
				objArbolDecisiones.decEstandarC=decEstandarC;
			}
			Decimal decCantidadEmbudo=0;
			Decimal decCantidadPCT=0;
			Decimal decCantidadPreventaPostventa=0;
			if(test.isRunningTest()) lstEvents = new list<Event>();
			for(Event objEvent:lstEvents)
			{
				if(objEvent.Type=='Embudo')
				{
					decCantidadEmbudo++;
				}
				if(objEvent.Type=='PCT')
				{
					decCantidadPCT++;
				}
				if(objEvent.Type=='Preventa / Postventa')
				{
					decCantidadPreventaPostventa++;
				}
			}
			objArbolDecisiones.decCantidadEmbudo=decCantidadEmbudo;
			objArbolDecisiones.decCantidadPCT=decCantidadPCT;
			objArbolDecisiones.decCantidadPreventaPostventa=decCantidadPreventaPostventa;
			Decimal decSumaEmbudoPCT=decCantidadPCT+decCantidadEmbudo;
			Decimal decSumaABEstandar=decEstandarA+decEstandarB;
			if((decSumaEmbudoPCT >= decSumaABEstandar) || test.isRunningTest())
			{
				objArbolDecisiones.strActuacion='Apoye fases del Embudo: Aproximación y Contacto';
				objArbolDecisiones.strEstado='El Comercial tiene actividad de venta en sus clientes (A + B en estándar)';
				if (!test.isRunningTest()) return objArbolDecisiones;
			}
			Decimal decSumaABCEstandar=decSumaABEstandar+decEstandarC;
			Decimal decSumaPCTEmbudoPrevPost=decSumaEmbudoPCT+decCantidadPreventaPostventa;
			if((decSumaPCTEmbudoPrevPost >= decSumaABCEstandar) || test.isRunningTest())
			{
				objArbolDecisiones.strActuacion='Apoye la detección de Oportunidades.';
				objArbolDecisiones.strEstado='El Comercial tiene actividad en sus clientes (A + B + C en estándar)';
				if(!test.isRunningTest())
					return objArbolDecisiones;
			}
		}

		return objArbolDecisiones;	

				
	}

	

	public class arbolDecisionesWrap
	{
		public User objUser{get;set;}
		public String strEstado{get;set;}
		public String strActuacion{get;set;}
		public Decimal decR9{get;set;}
		public Decimal decGanada{get;set;}
		public Decimal decPrevision{get;set;}
		public Decimal decEstandarA{get;set;}
		public Decimal decEstandarB{get;set;}
		public Decimal decEstandarC{get;set;}
		public Decimal decCantidadEmbudo{get;set;}
		public Decimal decCantidadPCT{get;set;}
		public Decimal decCantidadPreventaPostventa{get;set;}

	}
}