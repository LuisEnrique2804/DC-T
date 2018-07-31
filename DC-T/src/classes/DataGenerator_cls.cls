/******************************************************************************
* Autor: Alejandro Hurtado ahurtado@avanxo.com
* Descripcion: esta clase se encarga de crear los datos utilizados en las
			   clases de prueba
* Creada en: 2016-01-26
******************************************************************************/
public with sharing class DataGenerator_cls
{	
	
	public static Map<String, Profile> perfilPorNombre;
	
	public static Map<String, Profile> getPerfilPorNombre(){
		if(perfilPorNombre == null){
			List<Profile> perfiles = [SELECT Id, Name FROM Profile];
    		perfilPorNombre = new Map<String, Profile>();
    		for(Profile perfil: perfiles){
    			perfilPorNombre.put(perfil.Name, perfil);
    		}
		}
		return perfilPorNombre;
	}
	
	public static User crearUsuario(Id profileId, Id roleId, String NombreUsuario){
		User objUsuario = new User();
        objUsuario.Alias = NombreUsuario + 'A';
        objUsuario.Email =NombreUsuario + '-c@test.com';
        objUsuario.EmailEncodingKey = '';
        objUsuario.LastName ='Testing' + NombreUsuario;
        objUsuario.LanguageLocaleKey ='en_US';
        objUsuario.LocaleSidKey ='en_US'; 
        objUsuario.ProfileId = profileId;
        objUsuario.TimeZoneSidKey ='America/Los_Angeles';
        objUsuario.UserName =NombreUsuario + 'pruebas@test.com';
        objUsuario.EmailEncodingKey ='UTF-8';
        objUsuario.UserRoleId = roleId;
        
		return objUsuario;
	}
	
    public static Account createAccount( 	Boolean blnInsert, 
    										String 	strName, 
    										String 	strSegmento,
    										String 	RecordTypeId 
    									){
        Account objAccount = new Account();
        
        objAccount.Name = strName;
        objAccount.Segmento__c = strSegmento;
        if(RecordTypeId != '')
        	objAccount.RecordTypeId = RecordTypeId;
        objAccount.ClienteSinEvento__c = True;
        
        if( blnInsert )
        {
        	//try {
            	insert objAccount;
        	/*}catch (Exception ex){
        		objAccount = [Select Id, Name from Account Where Name = 'TELCEL' limit 1];
        	}*/
        }
        
        return objAccount;
    }
    
    public static Contact createContact( Boolean blnInsert, Account objAccount,
    	String strLastName, String strFirstName )
    {
    	Contact objContact = new Contact();
    	objContact.LastName = strLastName;
    	objContact.FirstName = strFirstName;
    	objContact.AccountId = objAccount.Id;
    	
    	if( blnInsert )
    	{
    		insert objContact;
    	}
    	
    	return objContact;
    }
    
    public static Opportunity createOpportunity( Boolean blnInsert, String strName,
    	Account objAccount, Contact objContact, String strStageName)
    {
    	Opportunity objOpportunity = new Opportunity();
    	
    	objOpportunity.Name = strName;
    	objOpportunity.StageName = strStageName;
    	objOpportunity.AccountId = objAccount.Id;
    	objOpportunity.CloseDate = Date.today().addDays( 60 );
    	objOpportunity.FechaRIP__c = Date.today().addDays( 20 );
    	objOpportunity.PersonaRIP__c = objContact.Id;
    	objOpportunity.Plataforma__c = 'M2M';
    	objOpportunity.OwnerId = Userinfo.getUserId();
    	objOpportunity.TipoActivacion__c = 'Nueva';
    	objOpportunity.P__c = objContact.Id;
		objOpportunity.FechainicioOportunidad__c = Date.today();
		objOpportunity.Liberarfaseoportunidad__c = false;		
    	if( blnInsert )
    	{
    		insert objOpportunity;
    		
    		objOpportunity.TipoRenta__c = 'Renta Alta';
    		update objOpportunity;
    	}
    	
    	return objOpportunity;
    }
    
    public static SeguimientoOportunidades__c createSeguimientoOportunidad( Boolean blnInsert,
    	Opportunity objOpportunity, string RT)
    {
    	SeguimientoOportunidades__c objSO = new SeguimientoOportunidades__c();
    	objSO.Proximaaccion__c = 'TestAcción';
    	objSO.Fechaproximaaccion__c = Date.today().addDays(1); 
    	objSO.Embudo__c = objOpportunity.Id;
		objSO.PlanCliente__c = objOpportunity.AccountId;

		if(RT != '')
			objSO.RecordTypeId = RT;
    	
    	if( blnInsert )
    	{
    		insert objSO;
    	}
    	
    	return objSO;
    }


    public static Presupuesto__c createPresupuesto( Boolean blnInsert )
    {
        Presupuesto__c objPresupuesto = new Presupuesto__c();
        
        
        objPresupuesto.R9__c = 100;
        objPresupuesto.PrevisionR9__c = 100;
        objPresupuesto.GanadaR9__c = 100;

        /*objPresupuesto.PrevisionvsPresupuesto__c 
        objPresupuesto.VentavsPresupuesto__c 
        objPresupuesto.Gerente__c 
        objPresupuesto.JEC__c
        */
        
        if( blnInsert )
        {
            insert objPresupuesto;
        }
        
        return objPresupuesto;
    }
    
    public static CatalogoPlataformaTIC__c createPlataformaTic( Boolean bInInsert,
   																String LlavePlataformaTIc,
   																String PlataformaTIC,
   																String ProductosServicios)
    {
    	CatalogoPlataformaTIC__c obj = new CatalogoPlataformaTIC__c();
    	
    	try{
	    	obj.Activo__c = true;
	    	obj.LlavePlataformaTIC__c = LlavePlataformaTIc;
	    	obj.PlataformaTIC__c = PlataformaTIC;
	    	obj.ProductosServiciosSolucionesTelcel__c = ProductosServicios;
	    	
	    	if( bInInsert ) 
	        {
	            insert obj;
	        }
    	}catch(exception ex){
    		obj = null;
    	}
        
        return obj;
    }
    
     public static ConocimientoMercado__c createConocimientoMercado( Boolean bInInsert,
   																String Competencia,
   																Decimal Cuota,
   																String DiferenciacionCliente,
   																String Liderazgo,
   																String Nombre,
   																String Presencia,
   																String PlanCliente)
    {
    	ConocimientoMercado__c obj = new ConocimientoMercado__c();
    	obj.Competencia__c = Competencia;
    	obj.Cuota__c = Cuota;
    	obj.DiferenciacionCliente__c = DiferenciacionCliente;
    	obj.Liderazgo__c = Liderazgo;
    	obj.PlanCliente__c = PlanCliente;
    	obj.Presencia__c = Presencia;
    	obj.Name = Nombre;
    	
    	if( bInInsert ) 
        {
            insert obj;
        }
        
        return obj;
    }
    
    public static Competencia__c createCompetencia( Boolean bInInsert,
													String Debilidad,
													String Nombre,
													String PlanCliente)
    {
    	Competencia__c obj = new Competencia__c();
    	obj.Debilidad__c = Debilidad;
    	obj.Name = Nombre;
    	obj.PlanCliente__c = PlanCliente;
    	
    	if( bInInsert ) 
        {
            insert obj;
        }
        
        return obj;
    }
    
    public static Contact createContacto( Boolean bInInsert,
    									  String  Cliente,
    									  String  Nombre,
    									  String  Apellido){
    	Contact obj = new Contact();
    	obj.AccountId = Cliente;
    	obj.FirstName = Nombre;
    	obj.LastName = Apellido;
    	obj.Nivel__c = '1';
    	obj.Estatus__c = 'Activo';
    	obj.Estructura__c = 'Autoridad';
    	
    	
    	
    	if( bInInsert ) 
        {
            insert obj;
        }
        
        return obj;
    }
    
    public static Interlocutor__c createInterlocutor( 	Boolean bInInsert,
    													String 	Actitud,
    													String	ContactoId,
    													String 	PlanCliente){
    	Interlocutor__c obj = new Interlocutor__c();
    	obj.Actitud__c = Actitud;
    	obj.Interlocutor__c = ContactoId;
    	obj.PlanCliente__c = PlanCliente;
    	
    	if( bInInsert ) 
        {
            insert obj;
        }
        
        return obj;
    }
    
    public static DirectrizTelcel__c createDirectriz ( 	Boolean bInInsert,
    													String IdCliente,
    													String IdOportunidad){
    	DirectrizTelcel__c obj = new DirectrizTelcel__c();
		obj.Directriz__c = 'NA';
		obj.Fecha__c = Date.today();
		obj.Notificacion__c = false;
		obj.PlanCliente__c = IdCliente;
    	obj.Quien__c =  UserInfo.getUserId();
    	obj.SeguimientoOportunid__c = IdOportunidad;
    	obj.Usuario_GV__c = UserInfo.getUserId();
    	obj.Usuario_SD__c = UserInfo.getUserId();
    	obj.Usuario_JEC__c = UserInfo.getUserId();
    	
    	
    	if( bInInsert ) 
        {
            insert obj;
        }
        
        return obj;
    }
    
    public static Directriz_Telcel__c createDirectriz2 ( 	Boolean bInInsert,
    													String IdCliente){
    	Directriz_Telcel__c obj = new Directriz_Telcel__c();
		obj.Directriz__c = 'Test';
		obj.PlanCliente__c = IdCliente;
		obj.Usuario_GV__c = UserInfo.getUserId();
		obj.Usuario_JEC__c = UserInfo.getUserId();
		obj.UsuarioSD__c = UserInfo.getUserId();
		
    	if( bInInsert ) 
        {
            insert obj;
        }
        
        return obj;
    }
    
    public static MapaCliente__c createMapaCliente ( 	Boolean bInInsert,
    													String IdCliente,
    													String RecordTypeId){
    	MapaCliente__c obj = new MapaCliente__c();
		try{
			obj.ActivaAlarmaAnalisisGeneral__c = false;
			obj.AnalisisGeneralCuenta__c = 'Test';
			obj.EstrategiaTelcelCliente__c = 'Test';
			obj.NotificaCambioAnalisisGeneral__c = false;
			obj.PlanCliente__c = IdCliente;
			obj.ProblematicaSectorActividad__c = 'Test';
			obj.ProcesoCompra__c = 'INICIO DE PRUEBAS';
			if(RecordTypeId != '')
				obj.RecordTypeId = RecordTypeId;
    	
    	if( bInInsert ) 
        {
            insert obj;
        }
		}catch(exception ex){
			for (MapaCliente__c mc : [Select Id, Name from MapaCliente__c Where PlanCliente__c =: IdCliente limit 1]){
				obj = mc;
			}
		}
        return obj;
    }
    
    public static InversionServicioTICFacturacion__c createInversionServiciosTICFacturacion(Boolean bInInsert,
    																						String 	IdCompetencia,
    																						String	IdCliente)
    {
    	InversionServicioTICFacturacion__c obj = new InversionServicioTICFacturacion__c();
    	obj.CompetenciaTelcel__c = IdCompetencia;
    	obj.FactTelcel__c = 15000;
    	obj.InversionCliente__c = 10000;
    	obj.MapaCliente__c = IdCliente;
    	obj.PlataformasTIC__c = 'Seguridad';
    	obj.ProductosServiciosSolucionesTelcel__c = 'Seguridad';
    	
    	if( bInInsert ) 
        {
            insert obj;
        }
        
        return obj;
    }
    
    public static Event createEventRIP( Boolean bInInsert,
    									Opportunity opp,
                                       	Account acc,
    									String sType)
    {               
        system.debug('revisar ' + sType);
        Event obj = new Event();
        obj.Subject = 'Cita Persona RIP';
        obj.StartDateTime = DateTime.now();
        obj.EndDateTime = DateTime.now().addDays(2);
        obj.OwnerId = opp.OwnerId;
        if(sType == 'PCTPruebaAvxAdm')
        	obj.WhatId = acc.Id;
        else
            obj.WhatId = opp.Id;
        obj.WhoId = opp.PersonaRIP__c;
        obj.Type = sType;
        
        if( bInInsert ) 
        {
            insert obj;
        }
        
        return obj;
    } 
    
    public static list<Event> createlstEvent(Opportunity opp){
    		list<Event> lstEvent = new list<Event>();
    		Event 									Evento1					= new Event();		
			Event 									Evento2					= new Event();	
			Event 									Evento3					= new Event();											
			
			
			Evento1.Subject = 'Cita Persona RIP';
			DateTime Fecha1 = DateTime.now().addDays(10);
			Evento1.StartDateTime = Fecha1;
			Evento1.EndDateTime = Fecha1.addMinutes(30);
			Evento1.DurationInMinutes = 30;
	     	Evento1.OwnerId = opp.OwnerId;
	     	Evento1.WhatId = opp.Id;
	     	Evento1.WhoId = opp.PersonaRIP__c;
	     	Evento1.Type = 'Embudo';
			lstEvent.add(Evento1);
			Evento2.Subject = 'Cita P';
			DateTime Fecha2 = DateTime.now().addDays(10);
			Evento2.StartDateTime = Fecha2; 
			Evento2.EndDateTime = Fecha2.addMinutes(30);
			Evento2.DurationInMinutes = 30;
			Evento2.OwnerId = opp.OwnerId;
	     	Evento2.WhatId = opp.Id;
	     	Evento2.WhoId = opp.PersonaRIP__c;
	     	Evento2.Type = 'Embudo';
			lstEvent.add(Evento2);
			
			Evento3.Subject = 'Firma';
			DateTime Fecha3 = DateTime.now().addDays(10);
			Evento3.StartDateTime = Fecha3; 
			Evento3.EndDateTime = Fecha3.addMinutes(30);
			Evento3.DurationInMinutes = 30;
			Evento3.OwnerId = opp.OwnerId;
	     	Evento3.WhatId = opp.Id;
	     	Evento3.WhoId = opp.PersonaRIP__c;
	     	Evento3.Type = 'Embudo';
			lstEvent.add(Evento3);
			
			return lstEvent;
    }
    
    public static Event createEventSO( Boolean bInInsert,
    								   String IdSO){               
                 
     	Event obj = new Event();
    	obj.Subject = 'Test de Proxima Acción';
     	obj.StartDateTime = DateTime.now().addDays(1);
     	obj.EndDateTime = DateTime.now().addDays(2);
     	obj.OwnerId = UserInfo.getUserId();
     	obj.WhatId = IdSO;
     	obj.WhoId = UserInfo.getUserId();
     	obj.Type = 'PCT';

        if( bInInsert ) 
        {
            insert obj;
        }
        
        return obj;
    } 
    
    public static Rentabilidad__c createRentabilidad( 	Boolean 	bInInsert,
    													string 		OrganizationId){                        
        Rentabilidad__c obj = new Rentabilidad__c();
        obj.Funcion__c = 'GV';
        obj.Maximo__c = 50;
        obj.Minimo__c = 1;
        obj.Name = 'GVComunicacionTest';
        obj.PlataformaRent__c = 'Comunicación';
        obj.SetupOwnerId = OrganizationId;
        if( bInInsert ) 
        {
        	try{
            	insert obj;
        	}catch (Exception ex){
        		for (Rentabilidad__c r : [Select Id, Name, Funcion__c, Minimo__c, Maximo__c, PlataformaRent__c, SetupOwnerId From Rentabilidad__c Where SetupOwnerId =: OrganizationId]){
        			obj = r;
        		}
        	}
        }
        return obj;
    } 

    public static DAT__c createDAT( 	Boolean 	bInInsert){                        
        DAT__c obj = new DAT__c();
        obj.Clave__c = 'CALME';
        obj.RazonSocial__c = 'CENTRO CELULAR SA DE CV';
        obj.Name = 'CALME';
        if( bInInsert ) 
        {
            insert obj;
        }
        return obj;
    } 
    
    public static CatalogoServiciosTradicionales__c createCatalogoServicioTradicional(Boolean 	bInInsert, Boolean Activo, String sServicio){
    	CatalogoServiciosTradicionales__c obj = new CatalogoServiciosTradicionales__c();
        obj.Competidor__c = 'AT&T';
        obj.PlataformaServiciosTradicionales__c = sServicio;
        obj.Activo__c = Activo;
        if( bInInsert ) 
        {
            insert obj;
        }
        return obj;
    }
    
     public static SoportedentroTelcel__c createSoporteDentroTelcel(Boolean bInInsert, Contact objContacto, SeguimientoOportunidades__c objSO){
    	SoportedentroTelcel__c obj = new SoportedentroTelcel__c();
        obj.Descripcion__c = 'Test';
        obj.Nombre__c = objContacto.Id;
		obj.Notificacion__c = true;
		obj.SeguimientoOportunidad__c = objSO.Id;        

        if( bInInsert ) 
        {
            insert obj;
        }
        return obj;
    }
    
    public static CatalgoCompetidoresPlataformas__c createCatalogoCopetidoresPlataformas(Boolean bInInsert, String sCompetidor,CatalogoServiciosTradicionales__c objCS ){
    	CatalgoCompetidoresPlataformas__c obj = new CatalgoCompetidoresPlataformas__c();
        obj.Name = sCompetidor;
        obj.CatalogoServiciosTradicionales__c = objCS.Id;
        if( bInInsert ) 
        {
            insert obj;
        }
        return obj;
    }
    
    public static PlatApro__c createPlatApro(	Boolean 	bInInsert){
    	PlatApro__c obj = new PlatApro__c();
      	obj.Aprobacion__c = false;
      	obj.MinDAT__c = 5;
      	obj.MinR18__c = 5;
      	obj.MinR9__c = 5;
      	obj.Plataforma__c = 'Voz';
      	obj.Name = 'Voz y Datos';

        if( bInInsert ) 
        {
        	try{
            	insert obj;
        	}catch(exception ex){
        		for(PlatApro__c pa : [Select MinR9__c, MinR18__c, MinDAT__c, Aprobacion__c from PlatApro__c Where Name = 'Voz y Datos']){
        			obj = pa;
        		}
        	}
        }
        return obj;
    }
    
    public static List<ControlAlarmas__c> createControlAlarmas( 	Boolean 	bInInsert,
    																String		sIdEmbudo,
    																String		sIdSO,
    																String		sIdMapa){                        
        ControlAlarmas__c obj;
        List<ControlAlarmas__c> lst = new List<ControlAlarmas__c>();
      
	        obj = new ControlAlarmas__c();
	        obj.Estatus__c = 'Activa';
	        obj.Embudo__c = sIdEmbudo;
	        obj.Fase__c = 'Oportunidad';
	        obj.Objeto__c = 'Embudo';
	        obj.Tipoalarma__c = 'Ausencia de registro "Tipo" "P"';
	        obj.SeguimientoOportunidades__c = sIdSO;
	        obj.MapaCliente__c = sIdMapa;
	        obj.Motivo__c = 'Diferencia Inversión en Servicios TIC';
	        
        	lst.add(obj);
        	
        	obj = new ControlAlarmas__c();
	        obj.Estatus__c = 'Activa';
	        obj.Embudo__c = sIdEmbudo;
	        obj.Fase__c = 'Oportunidad';
	        obj.Objeto__c = 'Embudo';
	        obj.Tipoalarma__c = 'Ausencia de registro "Tipo" "P"';
	        obj.SeguimientoOportunidades__c = sIdSO;
	        obj.MapaCliente__c = sIdMapa;
	        obj.Motivo__c = 'Diferencia Inversión en Servicios Tradicionales';
	        lst.add(obj);
	        
	        obj = new ControlAlarmas__c();
	        obj.Estatus__c = 'Activa';
	        obj.Embudo__c = sIdEmbudo;
	        obj.Fase__c = 'Oportunidad';
	        obj.Objeto__c = 'Embudo';
	        obj.Tipoalarma__c = 'Ausencia de registro "Tipo" "P"';
	        obj.SeguimientoOportunidades__c = sIdSO;
	        obj.MapaCliente__c = sIdMapa;
	        obj.Motivo__c = 'Falta Información en Analisis General de la Cuenta';
	        lst.add(obj);
	        
        
        
        if( bInInsert ) 
        {
            insert lst;
        }
        return lst;
    } 
    
}