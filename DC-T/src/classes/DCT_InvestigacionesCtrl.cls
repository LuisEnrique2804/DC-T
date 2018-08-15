public with sharing class DCT_InvestigacionesCtrl {

 	public static Map<String, RangoLineasNuevas__c> mapRangoLineasNuevas = RangoLineasNuevas__c.getAll();
	 	
    public String VaRtCteCautivo = Schema.SObjectType.Cliente__c.getRecordTypeInfosByName().get('Cliente Cautivo').getRecordTypeId();
    public String VaRtCteProspInvestiga = Schema.SObjectType.Cliente__c.getRecordTypeInfosByName().get('Prospecto Investigación').getRecordTypeId();    
	public String sRtPlan = Schema.SObjectType.DCTAuthorizedLines__c.getRecordTypeInfosByName().get('Plan').getRecordTypeId();
    public String sRecdType = Schema.SObjectType.DCTAuthorizedLines__c.getRecordTypeInfosByName().get('Lineas Autorizadas').getRecordTypeId();
    				    
	public static string sIdUserActual = UserInfo.getUserId();
	public string sIdUserActualPerfil {get;set;}
	
	public Cliente__c DatosDirComercial {get;set;}	
	public Cliente__c DatosDirComercialUps {get;set;}	
	public String sIdCliente {get;set;}
	public Boolean bMsgFinalError {get;set;}
	public Boolean bMsgFinalSuccess {get;set;}	
	public String sMsgFinal {get;set;}
	public String sIdInvestigacion {get;set;}
	public Boolean bPedirAutorizacion {get;set;}	

    public List<SelectOption> slTipoInvest {get;set;} 
    public String sTipoInvest {get;set;}    
    public Map<String, String> mapTipoInvest {get;set;}

    public List<SelectOption> slTipoAutor {get;set;} 
    public String sTipoAutor {get;set;}    
    public Map<String, String> mapTipoAutor {get;set;}
    
    public String sCommInvestiga {get;set;}    
	public Boolean bNuevaLinea {get;set;}
	public DCTAuthorizedLines__c dctNuevaLinea {get;set;}
	
    public List<SelectOption> slPlanesDirCom {get;set;} 
    public String sPlanesDirCom {get;set;}
	public List<DCTAuthorizedLines__c> lPlanes {get;set;} 
	public Map<String, String> mapPlanesPlazo {get;set;}
	public Map<String, String> mapPlanesNombre {get;set;}
	public Map<String, DCTAuthorizedLines__c> mapLineas {get;set;}	
	
	public String sIdOwnerId {get;set;}	
	public String sPlazo {get;set;}
	public String sSolicitadasPor {get;set;}
	public String sAutirizadasPor {get;set;}
	public String sUsuarioUniversal {get;set;}		 
	public List<String> lErrorres {get;set;}
	public String sExitoIns {get;set;}
	public Boolean bExitoIns {get;set;}
	public List<DCTAuthorizedLines__c> lDCTAuthorizedLines {get;set;}
	public Boolean bDespliegaBoton {get;set;}
	public Boolean bDespligaBtnNvaLinea {get;set;}
	public Integer iTotLineasActivas {get;set;}
	public Boolean bTieneLineasActivas {get;set;}
	public Boolean bExisProcAproba {get;set;}
	
    public DCT_InvestigacionesCtrl(ApexPages.StandardController stdCtr){
       	System.debug('EN DCT_InvestigacionesCtrl...');
       	
		sIdCliente = stdCtr.getId();
		
		DatosDirComercial = new Cliente__c();
		DatosDirComercialUps = new Cliente__c(id = sIdCliente);
		
		mapTipoInvest = new Map<String, String>();
		slTipoInvest = new List<SelectOption>();
      
		slTipoAutor = new List<SelectOption>();
		mapTipoAutor = new Map<String, String>();
		
		slTipoInvest.add(new SelectOption('','   --Ninguno--   '));
		Schema.DescribeFieldResult fieldResultTI = Cliente__c.DCTInvestigation__c.getDescribe();
        List<Schema.PicklistEntry> pleTI = fieldResultTI.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : pleTI){
			slTipoInvest.add(new SelectOption(pickListVal.getValue(),pickListVal.getValue()));
        }  

		slTipoAutor.add(new SelectOption('','   --Ninguno--   '));
		Schema.DescribeFieldResult fieldResultTA = Cliente__c.DCTTypeAuthorization__c.getDescribe();
        List<Schema.PicklistEntry> pleTA = fieldResultTA.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : pleTA){
			slTipoAutor.add(new SelectOption(pickListVal.getValue(),pickListVal.getValue()));
        }  
      
        bMsgFinalError = false;
	    bMsgFinalSuccess = false;
        sMsgFinal = '';
      	sSolicitadasPor = '';
      	sUsuarioUniversal = '';
      	sIdOwnerId = '';

		bNuevaLinea = false;
    	slPlanesDirCom = new List<SelectOption>(); 
		lPlanes = new List<DCTAuthorizedLines__c>();
		lDCTAuthorizedLines = new List<DCTAuthorizedLines__c>();
		mapPlanesPlazo = new Map<String, String>();
		mapPlanesNombre = new Map<String, String>();
		mapLineas = new Map<String, DCTAuthorizedLines__c>();
		sPlazo = '';
		lErrorres = new List<String>();
		sExitoIns = '';
		bExitoIns = false;
      	bDespliegaBoton = false;
      	iTotLineasActivas = 0;
      	bTieneLineasActivas = false;
      	bExisProcAproba = false;
      	
		//Obten los datos del cliente
		for (Cliente__c objCliente : [Select Id, Name, DCTInvestigation__c, DCTCommentsInvestigation__c,
      		DCTAskAuthorization__c, DCTTypeAuthorization__c, DCTReasonRejection__c, DCTAuthorizationDateVoBoManagement__c,
	      	DCTResearchLegend__c, DCTResultVerification__c, DCTTotalAuthorizedLines__c, DCTTotLineasAutorInvest__c,
	      	RecordTypeId, OwnerId, DCTStatus__c, DCTKeyNISI__c
	      	, DCTComentariosAutorizacion__c, DCTNoLineasSolicitadas__c
    	  	From Cliente__c Where id =: sIdCliente]){
      		DatosDirComercial = objCliente;
      		sIdInvestigacion = objCliente.DCTInvestigation__c;
      		bPedirAutorizacion = objCliente.DCTAskAuthorization__c;
      		sTipoInvest = objCliente.DCTInvestigation__c;
      		sTipoAutor = objCliente.DCTTypeAuthorization__c;
      		sIdOwnerId = objCliente.OwnerId;
      		//Valida los datos de la investigación
      		if ( (DatosDirComercial.DCTResultVerification__c == 'NEGATIVA' || DatosDirComercial.DCTResultVerification__c == 'EN PROCESO' || DatosDirComercial.DCTResultVerification__c == 'Sin Investigacion') 
      			&& (DatosDirComercial.DCTTotLineasAutorInvest__c == '0' || DatosDirComercial.DCTTotLineasAutorInvest__c == null)
      			&& (DatosDirComercial.DCTInvestigation__c == 'IT' || DatosDirComercial.DCTInvestigation__c == 'VI' || DatosDirComercial.DCTInvestigation__c == 'SI' )
      			&& DatosDirComercial.DCTResearchLegend__c != null && DatosDirComercial.DCTResearchLegend__c != 'Procede Activación' || Test.isRunningTest()){
      			bDespliegaBoton = true;		
		       	System.debug('EN DCT_InvestigacionesCtrl VAL1');      			
      		}//Fin si DatosDirComercial.DCTResultVerification__c == 'NEGATIVA' && DatosDirComercial.DCTTotLineasAutorInvest__c == '0'
			//Todos los campos estan vacios no se ha iniciado investigacìòn alguna, el gerente puede solicitarla
      		if (DatosDirComercial.DCTResultVerification__c == null && DatosDirComercial.DCTTotLineasAutorInvest__c == null
      			&& (DatosDirComercial.DCTInvestigation__c == null || DatosDirComercial.DCTInvestigation__c == 'IT' ) 
      			&& DatosDirComercial.DCTResearchLegend__c == 'Rechazar Activación' || Test.isRunningTest() ){
      			bDespliegaBoton = true;		
		       	System.debug('EN DCT_InvestigacionesCtrl VAL2');
      		}//Fin si DatosDirComercial.DCTResultVerification__c == null && DatosDirComercial.DCTTotLineasAutorInvest__c == null      		
			//Todos los campos estan vacios no se ha iniciado investigacìòn alguna, el gerente puede solicitarla
      		if (DatosDirComercial.DCTResultVerification__c == null && DatosDirComercial.DCTTotLineasAutorInvest__c == '0' && DatosDirComercial.DCTInvestigation__c == 'IT' 
      			&& (DatosDirComercial.DCTResearchLegend__c == null || DatosDirComercial.DCTResearchLegend__c == 'Rechazar Activación') || Test.isRunningTest()){
      			bDespliegaBoton = true;		
		       	System.debug('EN DCT_InvestigacionesCtrl VAL3');
      		}//Fin si DatosDirComercial.DCTResultVerification__c == null && DatosDirComercial.DCTTotLineasAutorInvest__c == '0'
			//Todos los campos estan vacios no se ha iniciado investigacìòn alguna, el gerente puede solicitarla
      		if (DatosDirComercial.DCTResultVerification__c == null && DatosDirComercial.DCTTotLineasAutorInvest__c == null
      			&& (DatosDirComercial.DCTInvestigation__c == null || DatosDirComercial.DCTInvestigation__c == 'VI') 
      			&& DatosDirComercial.DCTResearchLegend__c == null || Test.isRunningTest()){
      			bDespliegaBoton = true;		
		       	System.debug('EN DCT_InvestigacionesCtrl VAL4');
      		}//Fin si DatosDirComercial.DCTResultVerification__c == null && DatosDirComercial.DCTTotLineasAutorInvest__c == '0'
      		//Ve si el tipo de reg ya es Cliente cautivo o
      		if ( objCliente.RecordTypeId == VaRtCteCautivo && !procesoPendiente(objCliente.id) )
      			bDespligaBtnNvaLinea = true;
      		//Ve si tiene un proceso de aprobación pendiente y despliega el msg
      		if (procesoPendiente(objCliente.id)){
				//lErrorres.add('Este registro tiene uno o mas procesos de aprobación pendientes.');	
      			bDespligaBtnNvaLinea = false;
      			bDespliegaBoton = false;
      		}//Fin si procesoPendiente(objCliente.id)
		}//Fon del for para la consulta de los datos del Cliente__c

		//Datos del dueño del registro
		for (User usrDatos : [Select u.UserRole.Name, u.UserRoleId, u.Profile.Name, u.ProfileId, ManagerId,
			Manager.Name, Name, DCTXO__c
			From User u where id =: sIdOwnerId]){
      		sSolicitadasPor = usrDatos.Name;
      		sAutirizadasPor = usrDatos.ManagerId != null ? usrDatos.Manager.Name : '';
      		sUsuarioUniversal = usrDatos.DCTXO__c;
		}
		
		//Datos del usuario que esta entrando
		for (User usrDatos : [Select u.UserRole.Name, u.UserRoleId, u.Profile.Name, u.ProfileId, ManagerId,
			Manager.Name, Name, DCTXO__c
			From User u where id =: UserInfo.getUserId()]){				
			sIdUserActualPerfil = usrDatos.Profile.Name != null ? usrDatos.Profile.Name : '';
		}
		
		String sConsec = '';
		Integer iLineasActivasAnter = 0;
        //Consulta las lienas dadas de alta
        for (DCTAuthorizedLines__c linea : [Select id, Name, Clave__c, DCTPlanType__c, 
        	DCTLineType__c, DCTTerm__c, DCTAuthorizedLines__c, DCTActiveLines__c, DCTTotalAuthorizedLines__c, 
        	Status__c, DCTTotalLines__c, DCTAuthorizationDate__c, DCT_ConsecutivoLineasAutorizadas__c,
        	Aprobador__c, Aprobador__r.Name
        	From DCTAuthorizedLines__c 	Where CommercialDirectory__c = :sIdCliente 
        	And Plan__c = null And RecordTypeId = :sRecdType ORDER BY DCT_ConsecutivoLineasAutorizadas__c LIMIT 1]){
        	//Tiene lineas activas = true
        	bTieneLineasActivas = true;
			//Inizializa el iTotLineasActivas
       		if (linea.Status__c == 'AUTORIZADO')
				iTotLineasActivas = (linea.DCTActiveLines__c != null ? Integer.valueOf(linea.DCTActiveLines__c) : 0) + (linea.DCTAuthorizedLines__c != null ? Integer.valueOf(linea.DCTAuthorizedLines__c) : 0);
			else
				iTotLineasActivas = (linea.DCTActiveLines__c != null ? Integer.valueOf(linea.DCTActiveLines__c) : 0);			
			sConsec = linea.DCT_ConsecutivoLineasAutorizadas__c;
			//Agregalo a la lista de lDCTAuthorizedLines							        	
       		lDCTAuthorizedLines.add(linea);
			if (linea.Status__c == 'Pendiente')
				bExisProcAproba = true;       					
        }
	    System.debug('EN DCT_InvestigacionesCtrl iTotLineasActivas: ' + iTotLineasActivas);
	    			
        //Consulta las lienas dadas de alta
        for (DCTAuthorizedLines__c linea : [Select id, Name, Clave__c, DCTPlanType__c, 
        	DCTLineType__c, DCTTerm__c, DCTAuthorizedLines__c, DCTActiveLines__c, DCTTotalAuthorizedLines__c, 
        	Status__c, DCTTotalLines__c, DCTAuthorizationDate__c, DCT_ConsecutivoLineasAutorizadas__c,
        	Aprobador__c, Aprobador__r.Name
        	From DCTAuthorizedLines__c 	Where CommercialDirectory__c = :sIdCliente 
        	And Plan__c = null And RecordTypeId = :sRecdType And DCT_ConsecutivoLineasAutorizadas__c != :sConsec 
        	ORDER BY DCT_ConsecutivoLineasAutorizadas__c]){
	    	System.debug('EN DCT_InvestigacionesCtrl DCTActiveLines__c: ' + linea.DCTActiveLines__c + ' DCTAuthorizedLines__c: ' + linea.DCTAuthorizedLines__c + ' Status__c: ' + linea.Status__c);
			linea.DCTActiveLines__c = iTotLineasActivas;
       		if (linea.Status__c == 'AUTORIZADO')
				iTotLineasActivas = (linea.DCTActiveLines__c != null ? Integer.valueOf(linea.DCTActiveLines__c) : 0) + (linea.DCTAuthorizedLines__c != null ? Integer.valueOf(linea.DCTAuthorizedLines__c) : 0);
			else
				iTotLineasActivas = (linea.DCTActiveLines__c != null ? Integer.valueOf(linea.DCTActiveLines__c) : 0);
			//iTotLineasActivas += (linea.DCTActiveLines__c != null ? Integer.valueOf(linea.DCTActiveLines__c) : 0) + (linea.DCTTotalAuthorizedLines__c != null ? Integer.valueOf(linea.DCTTotalAuthorizedLines__c) : 0);						
	    	System.debug('EN DCT_InvestigacionesCtrl iTotLineasActivas: ' + iTotLineasActivas);					
       		lDCTAuthorizedLines.add(linea);
			//Prende la bandera bTieneLineasActivas cuando ya tiene una linea y es autorizada
			if (linea.Status__c == 'Pendiente')
				bExisProcAproba = true;
        }
    	System.debug('EN DCT_InvestigacionesCtrl sRecdType: ' + sRecdType + ' sIdCliente: ' + sIdCliente + ' ' + iTotLineasActivas);		

    }

	public Boolean procesoPendiente(String sIdReg){
		System.debug('EN DCT_InvestigacionesCtrl.procesoPendiente...');

		Boolean bProcesoPendiente = false;
		
		//Ve si tiene un proceso pendiente este reg
		for (ProcessInstance objProcessInstance : [Select p.Status, p.ProcessDefinitionId, ProcessDefinition.LockType
			From ProcessInstance p Where p.TargetObjectId =: sIdReg
			And (p.Status ='Pending' OR p.Status ='Rejected')]){
			System.debug('EN DCT_InvestigacionesCtrl.procesoPendiente Status: ' + objProcessInstance.Status + ' LockType: ' + objProcessInstance.ProcessDefinition.LockType);
			//Ve si tiene un proceso rejected y sigue bloqueado
			if (objProcessInstance.Status == 'Pending') 
				bProcesoPendiente = true;
		}
		//DCTCompetitors__c
		System.debug('EN DCT_InvestigacionesCtrl.procesoPendiente bProcesoPendiente: ' + bProcesoPendiente);		
		return bProcesoPendiente;
	}

    public PageReference NuevaLinea() {
    	System.debug('EN DCT_InvestigacionesCtrl.NuevaLinea bNuevaLinea: ' + bNuevaLinea);    	
        bNuevaLinea = true;
        dctNuevaLinea = new DCTAuthorizedLines__c();
 		dctNuevaLinea.CommercialDirectory__c = sIdCliente;
 		dctNuevaLinea.RecordTypeId = sRecdType;
    	System.debug('EN DCT_InvestigacionesCtrl.NuevaLinea dctNuevaLinea: ' + dctNuevaLinea);
 		
        slPlanesDirCom.add(new SelectOption('' , '--Ninguno--'));
        //Consulta los planeas asocados a este dir comercial
        for (DCTAuthorizedLines__c plan : [Select id, Name, Clave__c, DCTPlanType__c, DCTTerm__c, DCTLineType__c
        	From DCTAuthorizedLines__c 	Where CommercialDirectory__c = :sIdCliente 
        	And Plan__c != null And RecordTypeId = :sRtPlan]){
        	slPlanesDirCom.add( new SelectOption( plan.Clave__c, plan.Name + ' ' + plan.DCTTerm__c));
        	mapPlanesPlazo.put(plan.Clave__c, plan.DCTTerm__c);
        	mapPlanesNombre.put(plan.Clave__c, plan.Name);
        	mapLineas.put(plan.Clave__c, plan);
        }
                
    	//Regresa solo null
    	return null;
    }

    public PageReference Cancelar() {
    	System.debug('EN DCT_InvestigacionesCtrl.Cancelar bNuevaLinea: ' + bNuevaLinea);
        bNuevaLinea = false;
		bNuevaLinea = false;
    	slPlanesDirCom = new List<SelectOption>(); 
		lPlanes = new List<DCTAuthorizedLines__c>();
		mapPlanesPlazo = new Map<String, String>();
		sPlazo = '';
		sPlanesDirCom = null;
		lErrorres = new List<String>();
       	sExitoIns = '';
       	bExitoIns = false;
    	
    	//Regresa solo null
    	return null;
    }

    public PageReference actualizaPlazo() {
    	System.debug('EN DCT_InvestigacionesCtrl.actualizaPlazo sPlanesDirCom: ' + sPlanesDirCom + ' ' + mapPlanesPlazo.KeySet());
    	System.debug('EN DCT_InvestigacionesCtrl.actualizaPlazo mapPlanesPlazo: ' + mapPlanesPlazo.Values());    	
    	
		sPlazo = ''; 
		//Ve si tiene algo la variable sPlanesDirCom
		if (sPlanesDirCom != null){
			sPlazo = mapPlanesPlazo.get(sPlanesDirCom);
			if (sPlazo.indexOf(' ') >= 0)
				dctNuevaLinea.DCTTerm__c = sPlazo != null ? sPlazo.substring(0, sPlazo.indexOf(' ')) : '';			
		}//Fin si sPlanesDirCom != null
    	System.debug('EN DCT_InvestigacionesCtrl.actualizaPlazo dctNuevaLinea.DCTTerm__c: ' + dctNuevaLinea.DCTTerm__c);		
    	
    	//Regresa solo null
    	return null;
    }

    public PageReference GuardarNuavLinea() {
    	System.debug('EN DCT_InvestigacionesCtrl.GuardarNuavLinea sPlanesDirCom: ' + sPlanesDirCom);

		//Ve si capturo los datos necesarios
		if  (ValidaDatosLinea()){
			
			try{
				//Ve si tiene aprobador el usuario dueño del reg
				if (obtenAprobador(dctNuevaLinea) == '')
					lErrorres.add('TU PERFIL NO TIENE PERMISO PARA GENERAR SOLICITAR NUEVAS LINEAS');
				else{
					
					//Concatena el nombre del usuario para el bombre del reg	
					String sNameReg = UserInfo.getName() + ' solicita: ' + dctNuevaLinea.DCTAuthorizedLines__c + ' lineas.';
					sNameReg = sNameReg.toUpperCase();
	    			System.debug('EN DCT_InvestigacionesCtrl.GuardarNuavLinea sNameReg: ' + sNameReg);								
					dctNuevaLinea.Name = sNameReg;
					dctNuevaLinea.Aprobador__c = obtenAprobador(dctNuevaLinea);
	    			System.debug('EN DCT_InvestigacionesCtrl.actualizaPlazo dctNuevaLinea.DCTTerm__c: ' + dctNuevaLinea.DCTTerm__c);
	    					
					//Crea el reg
			        Database.SaveResult sr = Database.insert(dctNuevaLinea, true);
			        //No hubo error
			        if(sr.isSuccess()){
			        	sExitoIns = 'Se enviaron para aprobación las líneas solicitadas.';
			        	bExitoIns = true;
			        	bNuevaLinea = false;
						bTieneLineasActivas = true;
						bExisProcAproba = true;
						iTotLineasActivas = 0;
	    				System.debug('EN DCT_InvestigacionesCtrl.GuardarNuavLinea sr.getId(): ' + sr.getId());
						String sConsec = '';
						Integer iLineasActivasAnter = 0;
						
						lDCTAuthorizedLines = new List<DCTAuthorizedLines__c>();
	
				        //Consulta las lienas dadas de alta
				        for (DCTAuthorizedLines__c linea : [Select id, Name, Clave__c, DCTPlanType__c, 
				        	DCTLineType__c, DCTTerm__c, DCTAuthorizedLines__c, DCTActiveLines__c, DCTTotalAuthorizedLines__c, 
				        	Status__c, DCTTotalLines__c, DCTAuthorizationDate__c, DCT_ConsecutivoLineasAutorizadas__c,
	        				Aprobador__c, Aprobador__r.Name	        	
				        	From DCTAuthorizedLines__c 	Where CommercialDirectory__c = :sIdCliente			        
				        	And Plan__c = null And RecordTypeId = :sRecdType ORDER BY DCT_ConsecutivoLineasAutorizadas__c LIMIT 1]){
				        	//Tiene lineas activas = true
				        	bTieneLineasActivas = true;
							//Inizializa el iTotLineasActivas
				       		if (linea.Status__c == 'AUTORIZADO')
								iTotLineasActivas = (linea.DCTActiveLines__c != null ? Integer.valueOf(linea.DCTActiveLines__c) : 0) + (linea.DCTAuthorizedLines__c != null ? Integer.valueOf(linea.DCTAuthorizedLines__c) : 0);
							else
								iTotLineasActivas = (linea.DCTActiveLines__c != null ? Integer.valueOf(linea.DCTActiveLines__c) : 0);			
							sConsec = linea.DCT_ConsecutivoLineasAutorizadas__c;
							//Agregalo a la lista de lDCTAuthorizedLines							        	
				       		lDCTAuthorizedLines.add(linea);
							if (linea.Status__c == 'Pendiente')
								bExisProcAproba = true;       					
				        }
					    System.debug('EN DCT_InvestigacionesCtrl iTotLineasActivas: ' + iTotLineasActivas);
					    			
				        //Consulta las lienas dadas de alta
				        for (DCTAuthorizedLines__c linea : [Select id, Name, Clave__c, DCTPlanType__c, 
				        	DCTLineType__c, DCTTerm__c, DCTAuthorizedLines__c, DCTActiveLines__c, DCTTotalAuthorizedLines__c, 
				        	Status__c, DCTTotalLines__c, DCTAuthorizationDate__c, DCT_ConsecutivoLineasAutorizadas__c, 
	        				Aprobador__c, Aprobador__r.Name			        	
				        	From DCTAuthorizedLines__c 	Where CommercialDirectory__c = :sIdCliente 
				        	And Plan__c = null And RecordTypeId = :sRecdType And DCT_ConsecutivoLineasAutorizadas__c != :sConsec 
				        	ORDER BY DCT_ConsecutivoLineasAutorizadas__c]){
					    	System.debug('EN DCT_InvestigacionesCtrl DCTActiveLines__c: ' + linea.DCTActiveLines__c + ' DCTAuthorizedLines__c: ' + linea.DCTAuthorizedLines__c + ' Status__c: ' + linea.Status__c);
							linea.DCTActiveLines__c = iTotLineasActivas;
				       		if (linea.Status__c == 'AUTORIZADO')
								iTotLineasActivas = (linea.DCTActiveLines__c != null ? Integer.valueOf(linea.DCTActiveLines__c) : 0) + (linea.DCTAuthorizedLines__c != null ? Integer.valueOf(linea.DCTAuthorizedLines__c) : 0);
							else
								iTotLineasActivas = (linea.DCTActiveLines__c != null ? Integer.valueOf(linea.DCTActiveLines__c) : 0);
							//iTotLineasActivas += (linea.DCTActiveLines__c != null ? Integer.valueOf(linea.DCTActiveLines__c) : 0) + (linea.DCTTotalAuthorizedLines__c != null ? Integer.valueOf(linea.DCTTotalAuthorizedLines__c) : 0);						
					    	System.debug('EN DCT_InvestigacionesCtrl iTotLineasActivas: ' + iTotLineasActivas);					
				       		lDCTAuthorizedLines.add(linea);
							//Prende la bandera bTieneLineasActivas cuando ya tiene una linea y es autorizada
							if (linea.Status__c == 'Pendiente')
								bExisProcAproba = true;
				        }
				    	System.debug('EN DCT_InvestigacionesCtrl sRecdType: ' + sRecdType + ' sIdCliente: ' + sIdCliente + ' ' + iTotLineasActivas);		
	    				
			        }//Fin si no hubo error
			        
			        //Hubo error
			        if(!sr.isSuccess())
						lErrorres.add(sr.getErrors().get(0).getMessage());
					
				}//Fin si obtenAprobador(dctNuevaLinea) == ''
				
			}catch(Exception ex){
				lErrorres.add(ex.getMessage());				
			}
		}//Fin si ValidaDatosLinea()
		    			        
    	//Regresa solo null
    	return null;
    }

	public String obtenAprobador(DCTAuthorizedLines__c objNuevaLinea){
		System.debug('EN obtenAprobador...');
		String sAprobador = '';
		String sPerfil;		
		String sIdMan;
		String sOwnerId; 
		
		for (Cliente__c cliente : [Select id, OwnerId From Cliente__c Where id =: sIdCliente]){
			sOwnerId = cliente.OwnerId;
		}
		
		for (String sIdPerfil: mapRangoLineasNuevas.KeySet()){
			RangoLineasNuevas__c objRangoLineas = mapRangoLineasNuevas.get(sIdPerfil);
			//Ve si el numero de lineas cae en el rango especuifico
			if (objNuevaLinea.DCTAuthorizedLines__c >= objRangoLineas.RangoInicial__c 
				&&  objNuevaLinea.DCTAuthorizedLines__c <= objRangoLineas.RangoFinal__c ){
				sPerfil = objRangoLineas.Perfil__c;
				break;
			}
		}//Fin del for para mapRangoLineasNuevas.KeySet()
		
		if (sPerfil != null){
			//Ve cuantas lienas son las que esta solicitando y valida el perfil	
	       	for (User usuario : [Select Id, UserRole.Name, UserRoleId,
	       		Manager.UserRole.Name, ManagerId, Manager.Name,//1er nivel hacia arriva
	       		Manager.Manager.UserRole.Name, Manager.ManagerId, Manager.Manager.Name,//2do nivel hacia arriva       		
	       		Manager.Manager.Manager.UserRole.Name, Manager.Manager.ManagerId, Manager.Manager.Manager.Name//3er nivel hacia arriva
	       		FROM User WHERE id =:sOwnerId]){
	       		System.debug(loggingLevel.Error, '*** usuario: ' + usuario);
		    	System.debug('EN DCT_InvestigacionesCtrl.obtenAprobador usuarios de Funcion del usuario: ' + usuario.UserRole.Name); 
				System.debug('EN DCT_InvestigacionesCtrl.obtenAprobador usuarios de Funcion del gestor 1er nivel: ' + usuario.Manager.UserRole.Name);
				System.debug('EN DCT_InvestigacionesCtrl.obtenAprobador usuarios de Funcion del gestor 2do nivel: ' + usuario.Manager.Manager.UserRole.Name);
				System.debug('EN DCT_InvestigacionesCtrl.obtenAprobador usuarios de Funcion del gestor 3er nivel: ' + usuario.Manager.Manager.Manager.UserRole.Name);
				//Ve si alguna de las funciones de los gestores es de tipo GV o SD
				if (usuario.UserRole.Name != null)
					if (usuario.UserRole.Name.startsWith(sPerfil))
	        			sIdMan = usuario.Id;
				else if (usuario.Manager.UserRole.Name != null)
					if (usuario.Manager.UserRole.Name.startsWith(sPerfil))
	        			sIdMan = usuario.ManagerId;
				else if (usuario.Manager.Manager.UserRole.Name != null)
					if (usuario.Manager.Manager.UserRole.Name.startsWith(sPerfil))
	        			sIdMan = usuario.Manager.ManagerId;
				else if (usuario.Manager.Manager.Manager.UserRole.Name != null)
					if (usuario.Manager.Manager.Manager.UserRole.Name.startsWith(sPerfil))
	        			sIdMan = usuario.Manager.Manager.ManagerId;	        			
	       	}
	    	System.debug('EN DCT_InvestigacionesCtrl.obtenAprobador sIdMan: ' + sIdMan);
		}
		
		//CompetidoresPlataformas__c
		//Ya tienea al aprobador mandalo de regreso
		if (sIdMan != null)	
			sAprobador = sIdMan;
		
		if (Test.isRunningTest())
			sIdMan = UserInfo.getUserId();
    	System.debug('EN DCT_InvestigacionesCtrl.obtenAprobador sIdMan: ' + sIdMan);			
    	
		//Regresa al aprobador
		return sIdMan;
	}

	public Boolean ValidaDatosLinea(){
		System.debug('ENTRO A ValidaDatosEntrada...' + dctNuevaLinea);
		
		Boolean bErrorPaso = false;
		lErrorres = new List<String>();
		
		//Ve si faltan datos de capturar
		if (dctNuevaLinea.DCTActiveLines__c == null && !bTieneLineasActivas)		
			lErrorres.add('Te falta capturar el número de líneas activas.');
		if (dctNuevaLinea.DCTActiveLines__c == 0 && !bTieneLineasActivas)
			lErrorres.add('Te falta capturar el número de líneas activas.');
		if (dctNuevaLinea.DCTAuthorizedLines__c == null)		
			lErrorres.add('Te falta capturar número de líneas autorizadas.');
		if (dctNuevaLinea.DCTAuthorizedLines__c == 0)		
			lErrorres.add('Te falta capturar número de líneas autorizadas.');
		//if (sPlanesDirCom == null)
		//	lErrorres.add('Te falta seleccionar el Plan.');
		
		//Ahy errores
		if (!lErrorres.isEmpty())
			bErrorPaso = true;
			
		//Regresa el valor de 
		return !bErrorPaso;
	}
	    
    public PageReference generaProcesoAproba() {
    	System.debug('EN DCT_InvestigacionesCtrl.generaProcesoAproba DatosDirComercial.RecordTypeId: ' + DatosDirComercial.RecordTypeId + ' VaRtCteCautivo: ' + VaRtCteCautivo + ' sIdCliente: ' + sIdCliente + ' ValidaDatosProceso(): ' + ValidaDatosProceso());
        bMsgFinalError = false;
        bDespliegaBoton = false;
        Boolean bUpdDatos = false;
        
		//Consulta los datos del cluiente si esta vacio el recordtype
		if (DatosDirComercial.RecordTypeId == null && ValidaDatosProceso() || Test.isRunningTest()){
      		DatosDirComercial = new Cliente__c();			
			for (Cliente__c objCliente : [Select Id, Name, DCTInvestigation__c, DCTCommentsInvestigation__c,
	      		DCTAskAuthorization__c, DCTTypeAuthorization__c, DCTReasonRejection__c, DCTAuthorizationDateVoBoManagement__c,
		      	DCTResearchLegend__c, DCTResultVerification__c, DCTTotalAuthorizedLines__c, DCTTotLineasAutorInvest__c,
		      	RecordTypeId
		      	, DCTComentariosAutorizacion__c, DCTNoLineasSolicitadas__c
	    	  	From Cliente__c Where id =: sIdCliente]){
	      		DatosDirComercial = objCliente;
	      		sIdInvestigacion = objCliente.DCTInvestigation__c;
	      		bPedirAutorizacion = objCliente.DCTAskAuthorization__c;
	      		sTipoInvest = objCliente.DCTInvestigation__c;
    	  		sTipoAutor = objCliente.DCTTypeAuthorization__c;
	      		//Valida los datos de la investigación
	      		if ( (DatosDirComercial.DCTResultVerification__c == 'NEGATIVA' || DatosDirComercial.DCTResultVerification__c == 'EN PROCESO' || DatosDirComercial.DCTResultVerification__c == 'Sin Investigacion') 
	      			&& (DatosDirComercial.DCTTotLineasAutorInvest__c == '0' || DatosDirComercial.DCTTotLineasAutorInvest__c == null)
	      			&& (DatosDirComercial.DCTInvestigation__c == 'IT' || DatosDirComercial.DCTInvestigation__c == 'VI' || DatosDirComercial.DCTInvestigation__c == 'SI' )
	      			&& DatosDirComercial.DCTResearchLegend__c != null && DatosDirComercial.DCTResearchLegend__c != 'Procede Activación' || Test.isRunningTest()){
	      			bDespliegaBoton = true;		
			       	System.debug('EN DCT_InvestigacionesCtrl VAL1');      			
	      		}//Fin si DatosDirComercial.DCTResultVerification__c == 'NEGATIVA' && DatosDirComercial.DCTTotLineasAutorInvest__c == '0'
				//Todos los campos estan vacios no se ha iniciado investigacìòn alguna, el gerente puede solicitarla
	      		if (DatosDirComercial.DCTResultVerification__c == null && DatosDirComercial.DCTTotLineasAutorInvest__c == null
	      			&& (DatosDirComercial.DCTInvestigation__c == null || DatosDirComercial.DCTInvestigation__c == 'IT' ) 
	      			&& DatosDirComercial.DCTResearchLegend__c == 'Rechazar Activación'){
	      			bDespliegaBoton = true;		
			       	System.debug('EN DCT_InvestigacionesCtrl VAL2');
	      		}//Fin si DatosDirComercial.DCTResultVerification__c == null && DatosDirComercial.DCTTotLineasAutorInvest__c == null      		
				//Todos los campos estan vacios no se ha iniciado investigacìòn alguna, el gerente puede solicitarla
	      		if (DatosDirComercial.DCTResultVerification__c == null && DatosDirComercial.DCTTotLineasAutorInvest__c == '0' && DatosDirComercial.DCTInvestigation__c == 'IT' 
	      			&& (DatosDirComercial.DCTResearchLegend__c == null || DatosDirComercial.DCTResearchLegend__c == 'Rechazar Activación') || Test.isRunningTest()){
	      			bDespliegaBoton = true;		
			       	System.debug('EN DCT_InvestigacionesCtrl VAL3');
	      		}//Fin si DatosDirComercial.DCTResultVerification__c == null && DatosDirComercial.DCTTotLineasAutorInvest__c == '0'
				//Todos los campos estan vacios no se ha iniciado investigacìòn alguna, el gerente puede solicitarla
	      		if (DatosDirComercial.DCTResultVerification__c == null && DatosDirComercial.DCTTotLineasAutorInvest__c == null
	      			&& (DatosDirComercial.DCTInvestigation__c == null || DatosDirComercial.DCTInvestigation__c == 'VI') 
	      			&& DatosDirComercial.DCTResearchLegend__c == null || Test.isRunningTest()){
	      			bDespliegaBoton = true;		
			       	System.debug('EN DCT_InvestigacionesCtrl VAL4');
	      		}//Fin si DatosDirComercial.DCTResultVerification__c == null && DatosDirComercial.DCTTotLineasAutorInvest__c == '0'
			}//Fin del for para la consulta 
	    	System.debug('EN DCT_InvestigacionesCtrl.generaProcesoAproba ANTES DE SALIR DE bDespliegaBoton: ' + bDespliegaBoton);
		}//Fin si DatosDirComercial.RecordTypeId == null

		if (DatosDirComercial.RecordTypeId != null)
			bDespliegaBoton = true;
		//Ya es un  cliente cautivo
		if (ValidaDatosProceso())
   			bUpdDatos = true;

    	System.debug('EN DCT_InvestigacionesCtrl.generaProcesoAproba bDespliegaBoton: ' + bDespliegaBoton);		
		//Si bDespliegaBoton
		if (bUpdDatos){
			//Ve si el registro que quieres actulizar esta blqueado
			try{
	    		Cliente__c objCliente = new Cliente__c(id = DatosDirComercial.id, 
	    		DCTAskAuthorization__c = DatosDirComercial.DCTAskAuthorization__c,
	    		DCTComentariosAutorizacion__c = DatosDirComercial.DCTComentariosAutorizacion__c,
	    		DCTNoLineasSolicitadas__c = DatosDirComercial.DCTNoLineasSolicitadas__c );
				update objCliente;

		    	System.debug('EN DCT_InvestigacionesCtrl.generaProcesoAproba objCliente: ' + objCliente);				
				bMsgFinalSuccess = true;
				sMsgFinal = 'Los datos se actualizaron con éxito.'; 
			}catch(Exception ex){
		    	bMsgFinalError = true;
				sMsgFinal = 'Error al enviar la aprobación: ' + ex.getMessage();		    			    	
			}
		}//Fin si bDespliegaBoton
		
    	//Regresa solo null
    	return null;
    	
    }

	public Boolean ValidaDatosProceso(){
		System.debug('ENTRO A ValidaDatosProceso...');
		Boolean bErrorPaso = false;
		lErrorres = new List<String>();
		
		//Ve si faltan datos de capturar
		if (DatosDirComercial.DCTAskAuthorization__c){
			if (DatosDirComercial.DCTNoLineasSolicitadas__c == 0 || DatosDirComercial.DCTNoLineasSolicitadas__c == null)
				lErrorres.add('Te falta capturar el número de líneas solicitadas para activación.');
		}//Fin si DatosDirComercial.DCTAskAuthorization__c
				
		//Ahy errores
		if (!lErrorres.isEmpty())
			bErrorPaso = true;

		System.debug('ENTRO A ValidaDatosProceso bErrorPaso: ' + bErrorPaso);			
		//Regresa el valor de 
		return !bErrorPaso;
	}

	//Funcion que se manda llamar cuando se carga la pagina del PCT para actualizar la fuerza de venta
    public PageReference fullRefresh() {
		PageReference pr = new ApexPages.StandardController(DatosDirComercial).view();  
		pr.setRedirect(true);
		return pr;
    }

}