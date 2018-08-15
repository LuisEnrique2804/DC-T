public class DCT_SalesForceInformation_ctr {

	public Map<String, DCT_DirectorioEmpleados_rst.DatosEmpleado> mapIdExternoFurzaVenta {get;set;}
	public List<Responsable__c > lstResponsable {get; set;}
	public Map<String, Contact> mapIdExternoContacto {get;set;}
	public Map<String, Responsable__c> mapIdExternoResponsable {get;set;}	
	public User DatosOwner {get; set;}	
    public id idResponsable {get;set;} 
    
    public DCT_SalesForceInformation_ctr(ApexPages.StandardController stdCtr){
	    idResponsable = stdCtr.getId();
	    System.debug(loggingLevel.Error, '*** stdCtr: ' + stdCtr);
		System.debug('lstResponsable: '+lstResponsable);

        mapIdExternoFurzaVenta = new Map<String, DCT_DirectorioEmpleados_rst.DatosEmpleado>();
        mapIdExternoContacto = new Map<String, Contact>();
        mapIdExternoResponsable = new Map<String, Responsable__c>();
		lstResponsable = new List<Responsable__c >();
		System.debug(loggingLevel.Error, '*** idResponsable: ' + idResponsable);
		//Consulta los daos del OwnerId del objeto de clientes 
		String sIdOwner = [Select id, OwnerId From Cliente__c Where ID =: idResponsable].OwnerId;
		
		//Consulta los datos de XO y VT para el usuario dueño del reg
		for(User usuarioPaso : [Select DCTVT__c, DCTXO__c From User Where ID =: sIdOwner]){
			DatosOwner = usuarioPaso;
		}
		System.debug('EN DCT_SalesForceInformation_ctr ctrl DCTVT__c: ' + DatosOwner.DCTVT__c + ' DCTXO__c: ' + DatosOwner.DCTXO__c);

    }

	//Funcion que se manda llamar cuando se carga la pagina del PCT para actualizar la fuerza de venta
    public PageReference ActualizaFuerzaVetaWs() {
    	System.debug('EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs DatosOwner.Owner.DCTXO__c: ' + DatosOwner.DCTXO__c);
    	
    	List<Responsable__c> elementosAMostrarResponsables = new List<Responsable__c>();
   		Set<String> setIdUptResp = new Set<String>();
	    String sPCT;
   		String sIdDirCom;	    

	    Map<String, Contact> mapContactos = new Map<String, Contact>();
	    List<Responsable__c> lResponsables = new List<Responsable__c>();
	    			    		
		//Por aqui mandamos llamar el WebService de directorioEmpleados/ConsultarEmpleado/			
	    DCT_DirectorioEmpleados_rst.classRespuestaTelcel objClsResTelDirEmp = DCT_DirectorioEmpleados_rst.getDirectorioEmpleados(DatosOwner.DCTXO__c); //'XDO0207'
	    System.debug(loggingLevel.Error, '*****************************************************************************************');	
	    System.debug(loggingLevel.Error, 'EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs objClsResTelDirEmp: ' + objClsResTelDirEmp);
	    
        //Ve si no hubo error a la hora de responder del servicio
	    if (objClsResTelDirEmp.ErrorID == NULL || Test.isRunningTest())
			actualizaResponsables(objClsResTelDirEmp);    	

	    if (objClsResTelDirEmp.ErrorID != NULL){
		    System.debug(loggingLevel.Error, 'EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs objClsResTelDirEmp.ErrorID: ' + objClsResTelDirEmp.ErrorID);	    	
		    if (objClsResTelDirEmp.ErrorID.contains('Read timed out')){
			    System.debug(loggingLevel.Error, 'EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs ANTES DE HACER EL LLAMADO POR 2DA VEZ...' + objClsResTelDirEmp);		    	
			    DCT_DirectorioEmpleados_rst.classRespuestaTelcel objClsResTelDirEmp2 = DCT_DirectorioEmpleados_rst.getDirectorioEmpleados(DatosOwner.DCTXO__c); //'XDO0207'		    	
				actualizaResponsables(objClsResTelDirEmp2);
		    }//Fin si objClsResTelDirEmp.ErrorID.contains('Read timed out')
	    }//Fin si objClsResTelDirEmp.ErrorID == NULL    	
		 
		//Regresa solo null
        return null;
    }    

	//Funcion que sirve para actualizar los datos de los responsables
	public void actualizaResponsables(DCT_DirectorioEmpleados_rst.classRespuestaTelcel objClsResTelDirEmp){

    	List<Responsable__c> elementosAMostrarResponsables = new List<Responsable__c>();
   		Set<String> setIdUptResp = new Set<String>();
	    String sPCT;
   		String sIdDirCom;	    

	    Map<String, Contact> mapContactos = new Map<String, Contact>();
	    List<Responsable__c> lResponsables = new List<Responsable__c>();
		System.debug(loggingLevel.Error, '*** objClsResTelDirEmp: ' + objClsResTelDirEmp);
    	//Ve si tiene algo la lista de objClsResTelDirEmp.DirectorioEmpleados
    	if (objClsResTelDirEmp.DirectorioEmpleados != null){
    		//Consulta los datos del directorio comercial asociado a este PCT
    		for (Cliente__c dirComer : [Select dc.id, dc.Cliente__c From Cliente__c dc Where dc.id =: idResponsable]){
    			sIdDirCom = dirComer.id;
    			sPCT = dirComer.Cliente__c;
    		}
			System.debug('EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs sIdDirCom: ' + sIdDirCom + ' sPCT: ' + sPCT);
    		//Dale la vuelta a los reg y empieza a crear los reg del tipo Contact
    		for (DCT_DirectorioEmpleados_rst.DatosEmpleado objDatEmple : objClsResTelDirEmp.DirectorioEmpleados){
    			//Ve que el numero de empleado sea mayor a cero
    			if (objDatEmple.mNumeroEmpleado != '0'){
	    			//Agrega el reg el mapa de mapIdExternoContacto
	    			mapIdExternoContacto.put(DatosOwner.DCTXO__c + '-' + objDatEmple.mNumeroEmpleado + '-' + sPCT, new Contact(
	    					PCT_IdExterno__c = DatosOwner.DCTXO__c + '-' + objDatEmple.mNumeroEmpleado + '-' + sPCT,
	    					AccountId = sPCT,
	    					Directorio_Comercial__c = sIdDirCom,
	    					FirstName = objDatEmple.mNombreEmpleado,
	    					LastName = objDatEmple.mApellidoPaterno + ' ' + objDatEmple.mApellidoMaterno,
							MobilePhone = objDatEmple.mCelular,
							Area__c = objDatEmple.mDescripcionArea,
							DCTTypeContact__c = objDatEmple.mDescripcionTipoEmpleado,
							DCTExtension__c = objDatEmple.mExtension,
							Posicion__c = objDatEmple.mDescripcionPuesto,
							Phone = objDatEmple.mExtension
	    				)
	    			);
	    			//Agrega el reg el mapa de mapIdExternoResponsable
	    			mapIdExternoResponsable.put(DatosOwner.DCTXO__c + '-' + objDatEmple.mNumeroEmpleado + '-' + sPCT, new Responsable__c(
	    					PCT_IdExterno__c = DatosOwner.DCTXO__c + '-' + objDatEmple.mNumeroEmpleado + '-' + sPCT,
	    					PlanCliente__c = sPCT,
							DCTPosition__c = objDatEmple.mDescripcionPuesto,
							DCTCommercialDirectory__c = sIdDirCom,
							DCTUniversalUser__c = DatosOwner.DCTXO__c,
							DCTSalesForce__c = DatosOwner.DCTVT__c
	    				)
	    			);
    			}//Fin si objDatEmple.mNumeroEmpleado != '0'
    		}//Fin del for para objClsResTelDirEmp.DirectorioEmpleados
    	}//Fin si objClsResTelDirEmp.DirectorioEmpleados != null
		System.debug('EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs mapIdExternoContacto: ' + mapIdExternoContacto.KeySet());
		System.debug('EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs mapIdExternoResponsable: ' + mapIdExternoResponsable.KeySet());
					
		Set<String> setIdCliente = new Set<String>();
		for (Contact Contacto : [Select id, AccountId, PCT_IdExterno__c From Contact Where AccountId = :sPCT]){
			if (Contacto.AccountId != null)
				setIdCliente.add(Contacto.AccountId);
		}					    		
		setIdCliente.add(sPCT);
		
		//Antes de consultar los datos de los resonsables eliminalos de contactos
		for (Responsable__c Responsable : [Select id, PlanCliente__c, PCT_IdExterno__c From Responsable__c 
			Where PlanCliente__c IN :setIdCliente]){
			lResponsables.add(Responsable);
	    	System.debug('EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs lResponsables: ' + Responsable.PlanCliente__c + ' ' + Responsable.id);
		}
		//Elimina los responsables
		if (!lResponsables.isEmpty()){
			List<Database.Deleteresult> lDtbDr = Database.delete(lResponsables, false);
			for (Database.Deleteresult objDtbDr : lDtbDr){
				if (!objDtbDr.isSuccess())
			    	System.debug('EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs ERROR A LS HORA DE ELIMINAR LOS RESPONSABLES: ' + objDtbDr.getErrors()[0].getMessage()	);					
			}
		}
	    
		//Antes de consultar los datos de los resonsables eliminalos de contactos
		for (Contact Contacto : [Select id, AccountId, PCT_IdExterno__c From Contact Where AccountId = :sPCT
			And DCT_ContactoDirectorio__c = false and PCT_IdExterno__c != null]){
			mapContactos.put(Contacto.id, Contacto);
			System.debug('EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs Contacto.id: ' + Contacto.id + ' AccountId: ' + Contacto.AccountId);
		}					    		
		//Elimina los responsables
		if (!mapContactos.isEmpty()){
			List<Database.Deleteresult> lDtbDr = Database.delete(mapContactos.Values(), false);
			for (Database.Deleteresult objDtbDr : lDtbDr){
				if (!objDtbDr.isSuccess())
			    	System.debug('EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs ERROR A LS HORA DE ELIMINAR LOS CONTACTOS: ' + objDtbDr.getErrors()[0].getMessage()	);					
			}			
		}
    					    	
    	//Ve si tiene algo el mapa de mapIdExternoContacto
    	if (!mapIdExternoContacto.isEmpty()){
    		Set<String> setIdUptContact = new Set<String>();
    		Map<String, String> mapIdExtIdSfdc = new Map<String, String>();
    		
    		//Inserta los datos de los contactos asociados al pct
    		List<Database.Upsertresult> lDtupr = Database.upsert(mapIdExternoContacto.values(), Contact.PCT_IdExterno__c, false);
    		//Da la vuelta y ve si hubo errores
    		for (Database.Upsertresult objDtupr : lDtupr){
    			if (objDtupr.isSuccess())
    				setIdUptContact.add(objDtupr.getId());
    			if (!objDtupr.isSuccess())
    				System.debug('EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs ERROR a la hora de crear el contacto: ' + objDtupr.getErrors()[0].getMessage());
    		}//Fin del for para lDtupr
    		//Ya tienes los id de los nuevos contactos consultalos
    		if (!setIdUptContact.isEmpty()){
	    		for (Contact objContacto : [Select id, Name, PCT_IdExterno__c 
	    			From Contact Where id IN : setIdUptContact]){
	    			mapIdExtIdSfdc.put(objContacto.PCT_IdExterno__c, objContacto.id);
	    		}//Fin del for para los nuevos contactos
    		}//Fin si !setIdUptContact.isEmpty()
   			System.debug('EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs setIdUptContact: ' + setIdUptContact);
   			System.debug('EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs mapIdExtIdSfdc: ' + mapIdExtIdSfdc);
   		    		
    		//Recorre el mapa de mapIdExternoResponsable y relaciona el reg del Responsable con el del contacto
    		for (String sIdExt : mapIdExternoResponsable.KeySet()){
    			if (mapIdExtIdSfdc.containsKey(sIdExt))
    				mapIdExternoResponsable.get(sIdExt).NombreResponsable__c = mapIdExtIdSfdc.get(sIdExt);
    		}//Fin del for para mapIdExternoResponsable.KeySet()
   			System.debug('EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs mapIdExternoResponsable: ' + mapIdExternoResponsable);
   			
    		//Ya tienes los datos de los responsables que vas a insertar
    		List<Database.Upsertresult> lDtuprr = Database.upsert(mapIdExternoResponsable.values(), Responsable__c.PCT_IdExterno__c, false);
    		//Da la vuelta y ve si hubo errores
    		for (Database.Upsertresult objDtuprr : lDtuprr){
    			if (objDtuprr.isSuccess())
    				setIdUptResp.add(objDtuprr.getId());
    			if (!objDtuprr.isSuccess())
    				System.debug('EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs ERROR a la hora de crear el responsable: ' + objDtuprr.getErrors()[0].getMessage());
    		}//Fin del for para lDtupr
   			System.debug('EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs setIdUptResp: ' + setIdUptResp);
    			    		
    	}//Fin si !mapIdExternoContacto.isEmpty()
    	
		if(objClsResTelDirEmp.DirectorioEmpleados == null) {
			elementosAMostrarResponsables = [SELECT Name,  NombreResponsable__c, Funcion__c, Correoelectronico__c, TelefonoExtension__c, Celular__c, CUC__c, Sector__c, Subsector__c FROM Responsable__c WHERE ID IN :setIdUptResp And PCT_IdExterno__c != null];
			system.debug('elementosAMostrarResponsables VAL 1: '+elementosAMostrarResponsables);
		}	

		if(objClsResTelDirEmp.ErrorID == null) {
	        String sQuery = 'SELECT Name, NombreResponsable__c, Funcion__c, Correoelectronico__c, TelefonoExtension__c, Celular__c, CUC__c, Sector__c, Subsector__c, NombreResponsable__r.Name, DCTPosition__c, DCTSalesForce__c, DCTUniversalUser__c  FROM Responsable__c WHERE ID IN :setIdUptResp And PCT_IdExterno__c != null';
   			System.debug('EN AccountExtension.ActualizaFuerzaVetaWs sQuery: ' + sQuery);
	        lstResponsable = Database.query(sQuery);
			System.debug('DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs lstResponsable: ' + lstResponsable);
		}//Fin si objClsResTelDirEmp.ErrorID == null
	
	}
    
}