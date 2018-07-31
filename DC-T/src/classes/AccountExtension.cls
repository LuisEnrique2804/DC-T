public class AccountExtension {

    private final Id acctId;
    
    public List<InformacionSocietaria__c> lstInfSoc { get; set; }
    public List<ConocimientoMercado__c> lstcc {get; set;}
    public List<Competencia__c> lstct {get; set;}
    public List<Directriz_Telcel__c> lstdt {get; set;}
    public List<Interlocutor__c> lstit {get; set;}
    public List<SeguimientoOportunidades__c> lstso {get; set;}
    
    //Conocimiento de Mercado Atributos
    public Integer indiceActualConocimiento{set;get;}
    public Integer totalIndicesConocimiento{set;get;}
    public Map<Integer,List<ConocimientoMercado__c>> mapaIndexacionConocimiento;
    public List<ConocimientoMercado__c> totalElementosConocimiento;
    public List<ConocimientoMercado__c> elementosAMostrarConocimiento{set;get;}
    // Fin Conocimiento de Mercado Atributos
    
    //Competencia Telcel Atributos
    public Integer indiceActualCompetencia{set;get;}
    public Integer totalIndicesCompetencia{set;get;}
    public Map<Integer,List<Competencia__c>> mapaIndexacionCompetencia;
    public List<Competencia__c> totalElementosCompetencia;
    public List<Competencia__c> elementosAMostrarCompetencia{set;get;}
    // Fin Conocimiento de Mercado Atributos
    
    //Oportunidades Atributos
    public Integer indiceActualOportunidades{set;get;}
    public Integer totalIndicesOportunidades{set;get;}
    public Map<Integer,List<SeguimientoOportunidades__c>> mapaIndexacionOportunidades;
    public List<SeguimientoOportunidades__c> totalElementosOportunidades;
    public List<SeguimientoOportunidades__c> elementosAMostrarOportunidades{set;get;}
    // Fin Oportunidades Atributos
    
    //Interlocutores Atributos
    public Integer indiceActualInterlocutores{set;get;}
    public Integer totalIndicesInterlocutores{set;get;}
    public Map<Integer,List<Interlocutor__c>> mapaIndexacionInterlocutores;
    public List<Interlocutor__c> totalElementosInterlocutores;
    public List<Interlocutor__c> elementosAMostrarInterlocutores{set;get;}
    // Fin Interlocutores Atributos
    
    //Directriz Telcel Atributos
    public Integer indiceActualDirectriz{set;get;}
    public Integer totalIndicesDirectriz{set;get;}
    public Map<Integer,List<Directriz_Telcel__c>> mapaIndexacionDirectriz;
    public List<Directriz_Telcel__c> totalElementosDirectriz;
    public List<Directriz_Telcel__c> elementosAMostrarDirectriz{set;get;}
    // Fin Directriz Telcel Atributos
    
    //Información Societaria Atributos
    public Integer indiceActualInformacion{set;get;}
    public Integer totalIndicesInformacion{set;get;}
    public Map<Integer,List<InformacionSocietaria__c>> mapaIndexacionInformacion;
    public List<InformacionSocietaria__c> totalElementosInformacion;
    public List<InformacionSocietaria__c> elementosAMostrarInformacion{set;get;}
    // Fin Información Societaria Atributos
    
    //Responsables Atributos
    public Integer indiceActualResponsables{set;get;}
    public Integer totalIndicesResponsables{set;get;}
    public Map<Integer,List<Responsable__c>> mapaIndexacionResponsables;
    public List<Responsable__c> totalElementosResponsables;
    public List<Responsable__c> elementosAMostrarResponsables{set;get;}
    // Fin Responsables Atributos
    
    public Boolean hanHabidoCambios{set;get;}
    
    //Campos Conocimiento del cliente
    public Boolean lecturaCampoUno{set;get;}
    public Boolean lecturaCampoDos{set;get;}
    public Boolean lecturaCampoTres{set;get;}
    public Boolean lecturaCampoCuatro{set;get;}
    public Boolean escrituraCampoUno{set;get;}
    public Boolean escrituraCampoDos{set;get;}
    public Boolean escrituraCampoTres{set;get;}
    public Boolean escrituraCampoCuatro{set;get;}
    //FIN Campos Conocimiento del cliente
    
    //Campos Estrategia TIC
    public Boolean lecturaCampoCinco{set;get;}
    public Boolean lecturaCampoSeis{set;get;}
    public Boolean escrituraCampoCinco{set;get;}
    public Boolean escrituraCampoSeis{set;get;}
    //FIN Campos Estrategia TIC
    
    //Campos Información Análisis Estratégico
    public Boolean lecturaCampoSiete{set;get;}
    public Boolean lecturaCampoOcho{set;get;}
    public Boolean lecturaCampoNueve{set;get;}
    public Boolean lecturaCampoDiez{set;get;}
    public Boolean lecturaCampoOnce{set;get;}
    public Boolean lecturaCampoDoce{set;get;}
    public Boolean escrituraCampoSiete{set;get;}
    public Boolean escrituraCampoOcho{set;get;}
    public Boolean escrituraCampoNueve{set;get;}
    public Boolean escrituraCampoDiez{set;get;}
    public Boolean escrituraCampoOnce{set;get;}
    public Boolean escrituraCampoDoce{set;get;}
    //FIN Campos Información Análisis Estratégico

    //Campos Datos Basicos Cliente
    public Boolean lecturaCampoTrece{set;get;}
    public Boolean lecturaCampoCatorce{set;get;}
    public Boolean lecturaCampoQuince{set;get;}
    public Boolean lecturaCampoDieciseis{set;get;}
    public Boolean lecturaCampoDiecisiete{set;get;}
    public Boolean lecturaCampoDieciocho{set;get;}
    public Boolean lecturaCampoDiecinueve{set;get;}
    public Boolean lecturaCampoVeinte{set;get;}
    public Boolean escrituraCampoTrece{set;get;}
    public Boolean escrituraCampoCatorce{set;get;}
    public Boolean escrituraCampoQuince{set;get;}
    public Boolean escrituraCampoDieciseis{set;get;}
    public Boolean escrituraCampoDiecisiete{set;get;}
    public Boolean escrituraCampoDieciocho{set;get;}
    public Boolean escrituraCampoDiecinueve{set;get;}
    public Boolean escrituraCampoVeinte{set;get;}
    //FIN Campos Datos Basicos Cliente
    
    public Account cuenta{set;get;}    
    public ApexPages.StandardController aCController; 
    public Boolean huboError{set;get;}
    
    public final String escritura{set;get;}
    public Boolean perfilValidoEscritura{set;get;}

	public Map<String, DCT_DirectorioEmpleados_rst.DatosEmpleado> mapIdExternoFurzaVenta {get;set;}
	public Map<String, Contact> mapIdExternoContacto {get;set;}
	public Map<String, Responsable__c> mapIdExternoResponsable {get;set;}	
	public Account DatosOwner {get; set;}
	    
    public AccountExtension (ApexPages.StandardController stdController){
    
        aCController = stdController;
        DatosOwner = new  Account();
        
        List<String> todosCamposCuenta = new List<String>();
        todosCamposCuenta.addAll(SObjectType.Account.fields.getMap().keySet());
        todosCamposCuenta.add('InterlocutorEstrategia__r.Name');
        if (!test.isRunningTest()) aCController.addFields(todosCamposCuenta);
        cuenta = (Account) aCController.getRecord();
        
        //Consulta los datos de XO y VT para el usuario dueño del reg
        for(Account clientePaso : [Select Owner.DCTVT__c, Owner.DCTXO__c From Account Where ID =: cuenta.id]){
        	DatosOwner = clientePaso;
        }
        System.debug('EN AccountExtension ctrl DCTVT__c: ' + DatosOwner.Owner.DCTVT__c + ' DCTXO__c: ' + DatosOwner.Owner.DCTXO__c + ' cuenta.id: ' + cuenta.id);
        
        huboError = false;      
        
        escritura = '\'escritura\'';          
        String nombrePerfil = [SELECT Name FROM Profile WHERE Id=:userInfo.getProfileId()].Name;
        perfilValidoEscritura = (nombrePerfil  == 'Administrador del sistema' || nombrePerfil  == 'JEC') ? true : false;
        acctId = stdController.getId();
        
        hanHabidoCambios = false;
        
        //Campos Conocimiento del cliente
        lecturaCampoUno = true;
        lecturaCampoDos = true;
        lecturaCampoTres = true;
        lecturaCampoCuatro = true;
        escrituraCampoUno = false;
        escrituraCampoDos = false;
        escrituraCampoTres = false;
        escrituraCampoCuatro = false;
        //FIN Campos Conocimiento del cliente
        
        //Campos Estrategia TIC
        lecturaCampoCinco = true;
        lecturaCampoSeis = true;
        escrituraCampoCinco = false;
        escrituraCampoSeis = false;
        //FIN Campos Estrategia TIC
        
        //Campos Información Análisis Estratégico
        lecturaCampoSiete = true;
        lecturaCampoOcho = true;
        lecturaCampoNueve = true;
        lecturaCampoDiez = true;
        lecturaCampoOnce = true;
        lecturaCampoDoce = true;
        escrituraCampoSiete = false;
        escrituraCampoOcho = false;
        escrituraCampoNueve = false;
        escrituraCampoDiez = false;
        escrituraCampoOnce = false;
        escrituraCampoDoce = false;
        //FIN Campos Información Análisis Estratégico

        //Campos Datos Basicos Cliente
        lecturaCampoTrece = true;
        lecturaCampoCatorce = true;
        lecturaCampoQuince = true;
        lecturaCampoDieciseis = true;
        lecturaCampoDiecisiete = true;
        lecturaCampoDieciocho = true;
        lecturaCampoDiecinueve = true;
        lecturaCampoVeinte = true;
        escrituraCampoTrece = false;
        escrituraCampoCatorce = false;
        escrituraCampoQuince = false;
        escrituraCampoDieciseis = false;
        escrituraCampoDiecisiete = false;
        escrituraCampoDieciocho = false;
        escrituraCampoDiecinueve = false;
        escrituraCampoVeinte = false;
        //FIN Campos Datos Basicos Cliente
        
        mapIdExternoFurzaVenta = new Map<String, DCT_DirectorioEmpleados_rst.DatosEmpleado>();
        mapIdExternoContacto = new Map<String, Contact>();
        mapIdExternoResponsable = new Map<String, Responsable__c>();
        
         //Operaciones Conocimiento de Mercado
        indiceActualConocimiento = 1;
        totalElementosConocimiento = new List<ConocimientoMercado__c>();    
        mapaIndexacionConocimiento = new Map<Integer,List<ConocimientoMercado__c>>();
        totalElementosConocimiento = Database.query('SELECT '+String.join(new List<String>(SObjectType.ConocimientoMercado__c.fields.getMap().keySet()),', ')+' FROM ConocimientoMercado__c WHERE PlanCliente__c = \''+acctId+'\''+ 'order by CreatedDate ASC');
        for(Integer i=0; i<totalElementosConocimiento.size(); i++){
            if(!mapaIndexacionConocimiento.containsKey(((i/5)+1))){
                mapaIndexacionConocimiento.put(((i/5)+1),new List<ConocimientoMercado__c>());
            }
            mapaIndexacionConocimiento.get(((i/5)+1)).add(totalElementosConocimiento[i]);
        }
        totalIndicesConocimiento = mapaIndexacionConocimiento.keySet().size();
        elementosAMostrarConocimiento = (mapaIndexacionConocimiento.containsKey(indiceActualConocimiento))?mapaIndexacionConocimiento.get(indiceActualConocimiento):new List<ConocimientoMercado__c>();
        // Fin Operaciones Conocimiento de Mercado
        
         //Operaciones Competencia Telcel
        indiceActualCompetencia = 1;
        totalElementosCompetencia = new List<Competencia__c>();    
        mapaIndexacionCompetencia = new Map<Integer,List<Competencia__c>>();
        totalElementosCompetencia = Database.query('SELECT '+String.join(new List<String>(SObjectType.Competencia__c.fields.getMap().keySet()),', ')+' FROM Competencia__c WHERE PlanCliente__c = \''+acctId+'\''+ 'order by CreatedDate ASC');
        for(Integer i=0; i<totalElementosCompetencia.size(); i++){
            if(!mapaIndexacionCompetencia.containsKey(((i/5)+1))){
                mapaIndexacionCompetencia.put(((i/5)+1),new List<Competencia__c>());
            }
            mapaIndexacionCompetencia.get(((i/5)+1)).add(totalElementosCompetencia[i]);
        }
        totalIndicesCompetencia = mapaIndexacionCompetencia.keySet().size();
        elementosAMostrarCompetencia = (mapaIndexacionCompetencia.containsKey(indiceActualCompetencia))?mapaIndexacionCompetencia.get(indiceActualCompetencia):new List<Competencia__c>();
        // Fin Operaciones Competencia Telcel
        
        //Operaciones Oportunidades
        indiceActualOportunidades = 1;
        totalElementosOportunidades = new List<SeguimientoOportunidades__c>();    
        mapaIndexacionOportunidades = new Map<Integer,List<SeguimientoOportunidades__c>>();
        totalElementosOportunidades = Database.query('SELECT '+String.join(new List<String>(SObjectType.SeguimientoOportunidades__c.fields.getMap().keySet()),', ')+', Embudo__r.P__c, Embudo__r.Id,  Embudo__r.Name, Embudo__r.CloseDate, Embudo__r.StageName, Embudo__r.FechaInicio__c  FROM SeguimientoOportunidades__c WHERE PlanCliente__c = \''+acctId+'\''+ 'order by Embudo__r.StageName DESC, LineasR9__c DESC, Embudo__r.CloseDate ASC');
        for(Integer i=0; i<totalElementosOportunidades.size(); i++){
            if(!mapaIndexacionOportunidades.containsKey(((i/5)+1))){
                mapaIndexacionOportunidades.put(((i/5)+1),new List<SeguimientoOportunidades__c>());
            }
            mapaIndexacionOportunidades.get(((i/5)+1)).add(totalElementosOportunidades[i]);
        }
        totalIndicesOportunidades = mapaIndexacionOportunidades.keySet().size();
        elementosAMostrarOportunidades = (mapaIndexacionOportunidades.containsKey(indiceActualOportunidades))?mapaIndexacionOportunidades.get(indiceActualOportunidades):new List<SeguimientoOportunidades__c>();
        // Fin Operaciones Oportunidades
        
        //Operaciones Interlocutor
        indiceActualInterlocutores = 1;
        totalElementosInterlocutores = new List<Interlocutor__c>();    
        mapaIndexacionInterlocutores = new Map<Integer,List<Interlocutor__c>>();
        totalElementosInterlocutores = Database.query('SELECT '+String.join(new List<String>(SObjectType.Interlocutor__c.fields.getMap().keySet()),', ')+' ,Interlocutor__r.Name FROM Interlocutor__c WHERE PlanCliente__c = \''+acctId+'\''+ 'order by Tipo__c');
        for(Integer i=0; i<totalElementosInterlocutores.size(); i++){
            if(!mapaIndexacionInterlocutores.containsKey(((i/5)+1))){
                mapaIndexacionInterlocutores.put(((i/5)+1),new List<Interlocutor__c>());
            }
            mapaIndexacionInterlocutores.get(((i/5)+1)).add(totalElementosInterlocutores[i]);
        }
        totalIndicesInterlocutores = mapaIndexacionInterlocutores.keySet().size();
        elementosAMostrarInterlocutores = (mapaIndexacionInterlocutores.containsKey(indiceActualInterlocutores))?mapaIndexacionInterlocutores.get(indiceActualInterlocutores):new List<Interlocutor__c>();
        // Fin Operaciones Interlocutor
        
        //Operaciones Directriz
        indiceActualDirectriz = 1;
        totalElementosDirectriz = new List<Directriz_Telcel__c>();    
        mapaIndexacionDirectriz = new Map<Integer,List<Directriz_Telcel__c>>();
        totalElementosDirectriz = Database.query('SELECT '+String.join(new List<String>(SObjectType.Directriz_Telcel__c.fields.getMap().keySet()),', ')+' FROM Directriz_Telcel__c WHERE PlanCliente__c = \''+acctId+'\''+ 'order by CreatedDate DESC');
        for(Integer i=0; i<totalElementosDirectriz.size(); i++){
            if(!mapaIndexacionDirectriz.containsKey(((i/5)+1))){
                mapaIndexacionDirectriz.put(((i/5)+1),new List<Directriz_Telcel__c>());
            }
            mapaIndexacionDirectriz.get(((i/5)+1)).add(totalElementosDirectriz[i]);
        }
        totalIndicesDirectriz = mapaIndexacionDirectriz.keySet().size();
        elementosAMostrarDirectriz = (mapaIndexacionDirectriz.containsKey(indiceActualDirectriz))?mapaIndexacionDirectriz.get(indiceActualDirectriz):new List<Directriz_Telcel__c>();
        // Fin Operaciones Directriz 
        
        //Operaciones Información Societaria
        indiceActualInformacion = 1;
        totalElementosInformacion = new List<InformacionSocietaria__c>();    
        mapaIndexacionInformacion = new Map<Integer,List<InformacionSocietaria__c>>();
        totalElementosInformacion = Database.query('SELECT '+String.join(new List<String>(SObjectType.InformacionSocietaria__c.fields.getMap().keySet()),', ')+' FROM InformacionSocietaria__c WHERE PlanCliente__c = \''+acctId+'\''+ 'order by Tipo__c');
        for(Integer i=0; i<totalElementosInformacion.size(); i++){
            if(!mapaIndexacionInformacion.containsKey(((i/5)+1))){
                mapaIndexacionInformacion.put(((i/5)+1),new List<InformacionSocietaria__c>());
            }
            mapaIndexacionInformacion.get(((i/5)+1)).add(totalElementosInformacion[i]);
        }
        totalIndicesInformacion = mapaIndexacionInformacion.keySet().size();
        elementosAMostrarInformacion = (mapaIndexacionInformacion.containsKey(indiceActualInformacion))?mapaIndexacionInformacion.get(indiceActualInformacion):new List<InformacionSocietaria__c>();
        // Fin Operaciones Información Societaria 

        //Operaciones Responsables
        	//Se paso a la parte de la función ActualizaFuerzaVetaWs ya que los manda llamar un WS
        // Fin Operaciones Responsables
        
        lstInfSoc = [select Id, Name, Tipo__c, Nombre__c, createddate
                     from InformacionSocietaria__c
                     where PlanCliente__c =:acctId
                     order by Tipo__c];
        
        lstcc = [select Id, Name, Competencia__c, Cuota__c, Presencia__c, Liderazgo__c, DiferenciacionCliente__c, CreatedDate
                 from ConocimientoMercado__c
                 where PlanCliente__c =:acctId
                 order by CreatedDate ASC];  
        
        lstct = [select Id, Name, Crear__c, Debilidad__c, Estatus__c, VentajaCompetitiva__c, ApoyoenCliente__c, CreatedDate
                 from Competencia__c
                 where PlanCliente__c =:acctId 
                 order by CreatedDate ASC];
        
        lstdt = [select Id, Name, CreadoPor__c, Directriz__c, FechaCreacion__c, ReenviarNotificacion__c, CreatedDate
                 from Directriz_Telcel__c
                 where PlanCliente__c =:acctId
                 order by CreatedDate DESC];  
        
        lstit = [select Id, Name, Actitud__c, Interlocutor__c, Logro__c, PosicionPuesto__c, RelacionTelcel__c, Tipo__c, 
                 Interlocutor__r.Name, CreatedDate
                 from Interlocutor__c
                 where PlanCliente__c =:acctId
                 order by Tipo__c];  
        
        lstso = [select Id, Name, Embudo__r.FechaInicio__c, Fase__c, Proximaaccion__c, Fechaproximaaccion__c, LineasR9__c, LineasR1a8__c, 
                 LineasDAT__c, Fechacierre__c, Embudo__r.P__c,  Embudo__r.Id,  Embudo__r.Name, Embudo__r.StageName,CreatedDate
                 from SeguimientoOportunidades__c
                 where PlanCliente__c =:acctId
                 order by Embudo__r.StageName DESC];                      
        
    }

	//Funcion que se manda llamar cuando se carga la pagina del PCT para actualizar la fuerza de venta
    public PageReference ActualizaFuerzaVetaWs() {
    	System.debug('EN AccountExtension.ActualizaFuerzaVetaWs DatosOwner.Owner.DCTXO__c: ' + DatosOwner.Owner.DCTXO__c);
    	
    	elementosAMostrarResponsables = new List<Responsable__c>();
   		Set<String> setIdUptResp = new Set<String>();
	    Map<String, Contact> mapContactos = new Map<String, Contact>();
	    List<Responsable__c> lResponsables = new List<Responsable__c>();
	    	    	    		
		//Por aqui mandamos llamar el WebService de directorioEmpleados/ConsultarEmpleado/			
	    DCT_DirectorioEmpleados_rst.classRespuestaTelcel objClsResTelDirEmp = DCT_DirectorioEmpleados_rst.getDirectorioEmpleados(DatosOwner.Owner.DCTXO__c); //'XDO0207'
	    System.debug(loggingLevel.Error, 'EN AccountExtension.ActualizaFuerzaVetaWs objClsResTelDirEmp: ' + objClsResTelDirEmp);
	    
        //Ve si no hubo error a la hora de responder del servicio
	    if (objClsResTelDirEmp.ErrorID == NULL)
			actualizaResponsables(objClsResTelDirEmp);    	

	    if (objClsResTelDirEmp.ErrorID != NULL){
		    System.debug(loggingLevel.Error, 'EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs objClsResTelDirEmp.ErrorID: ' + objClsResTelDirEmp.ErrorID);	    	
		    if (objClsResTelDirEmp.ErrorID.contains('Read timed out')){
			    System.debug(loggingLevel.Error, 'EN DCT_SalesForceInformation_ctr.ActualizaFuerzaVetaWs ANTES DE HACER EL LLAMADO POR 2DA VEZ...' + objClsResTelDirEmp);		    	
			    DCT_DirectorioEmpleados_rst.classRespuestaTelcel objClsResTelDirEmp2 = DCT_DirectorioEmpleados_rst.getDirectorioEmpleados(DatosOwner.Owner.DCTXO__c); //'XDO0207'		    	
				actualizaResponsables(objClsResTelDirEmp2);
		    }//Fin si objClsResTelDirEmp.ErrorID.contains('Read timed out')
	    }//Fin si objClsResTelDirEmp.ErrorID == NULL    	
        
		//Regresa solo null
        return null;
    }
    
	//Funcion que sirve para actualizar los datos de los responsables
	public void actualizaResponsables(DCT_DirectorioEmpleados_rst.classRespuestaTelcel objClsResTelDirEmp){

    	elementosAMostrarResponsables = new List<Responsable__c>();
   		Set<String> setIdUptResp = new Set<String>();
	    Map<String, Contact> mapContactos = new Map<String, Contact>();
	    List<Responsable__c> lResponsables = new List<Responsable__c>();
	
    	//Ve si tiene algo la lista de objClsResTelDirEmp.DirectorioEmpleados
    	if (objClsResTelDirEmp.DirectorioEmpleados != null){
    		String sIdDirCom;
    		//Consulta los datos del directorio comercial asociado a este PCT
    		for (Cliente__c dirComer : [Select dc.id, dc.Cliente__c From Cliente__c dc Where dc.Cliente__c =: cuenta.id]){
    			sIdDirCom = dirComer.id;
    		}
			System.debug('EN AccountExtension.ActualizaFuerzaVetaWs sIdDirCom: ' + sIdDirCom);	    		
    		//Dale la vuelta a los reg y empieza a crear los reg del tipo Contact
    		for (DCT_DirectorioEmpleados_rst.DatosEmpleado objDatEmple : objClsResTelDirEmp.DirectorioEmpleados){
    			//Ve que el numero de empleado sea mayor a cero
    			if (objDatEmple.mNumeroEmpleado != '0'){
	    			//Agrega el reg el mapa de mapIdExternoContacto
	    			mapIdExternoContacto.put(DatosOwner.Owner.DCTXO__c + '-' + objDatEmple.mNumeroEmpleado + '-' + cuenta.id, new Contact(
	    					PCT_IdExterno__c = DatosOwner.Owner.DCTXO__c + '-' + objDatEmple.mNumeroEmpleado + '-' + cuenta.id,
	    					AccountId = cuenta.id,
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
	    			mapIdExternoResponsable.put(DatosOwner.Owner.DCTXO__c + '-' + objDatEmple.mNumeroEmpleado + '-' + cuenta.id, new Responsable__c(
	    					PCT_IdExterno__c = DatosOwner.Owner.DCTXO__c + '-' + objDatEmple.mNumeroEmpleado + '-' + cuenta.id,
	    					PlanCliente__c = cuenta.id,
							DCTPosition__c = objDatEmple.mDescripcionPuesto,
							DCTCommercialDirectory__c = sIdDirCom,
							DCTUniversalUser__c = DatosOwner.Owner.DCTXO__c,
							DCTSalesForce__c = DatosOwner.Owner.DCTVT__c 
	    				)
	    			);
    			}//Fin si objDatEmple.mNumeroEmpleado != '0'
    		}//Fin del for para objClsResTelDirEmp.DirectorioEmpleados
    	}//Fin si objClsResTelDirEmp.DirectorioEmpleados != null
		System.debug('EN AccountExtension.ActualizaFuerzaVetaWs mapIdExternoContacto: ' + mapIdExternoContacto.KeySet());
		System.debug('EN AccountExtension.ActualizaFuerzaVetaWs mapIdExternoResponsable: ' + mapIdExternoResponsable.KeySet());			
		
		Set<String> setIdCliente = new Set<String>();
		for (Contact Contacto : [Select id, AccountId, PCT_IdExterno__c From Contact Where AccountId = :cuenta.id]){
			if (Contacto.AccountId != null)
				setIdCliente.add(Contacto.AccountId);
		}					    		
		setIdCliente.add(cuenta.id);
		
		//Antes de consultar los datos de los resonsables eliminalos de contactos
		for (Responsable__c Responsable : [Select id, PlanCliente__c, PCT_IdExterno__c From Responsable__c Where PlanCliente__c IN :setIdCliente]){
			lResponsables.add(Responsable);
	    	System.debug('EN AccountExtension.ActualizaFuerzaVetaWs lResponsables: ' + Responsable.PlanCliente__c + ' ' + Responsable.id);
		}
		//Elimina los responsables
		if (!lResponsables.isEmpty()){
			List<Database.Deleteresult> lDtbDr = Database.delete(lResponsables, false);
			for (Database.Deleteresult objDtbDr : lDtbDr){
				if (!objDtbDr.isSuccess())
			    	System.debug('EN AccountExtension.ActualizaFuerzaVetaWs ERROR A LS HORA DE ELIMINAR LOS RESPONSABLES: ' + objDtbDr.getErrors()[0].getMessage()	);					
			}
		}
	    
		//Antes de consultar los datos de los resonsables eliminalos de contactos
		for (Contact Contacto : [Select id, AccountId, PCT_IdExterno__c From Contact Where AccountId = :cuenta.id
			And DCT_ContactoDirectorio__c = false and PCT_IdExterno__c != null]){
			mapContactos.put(Contacto.id, Contacto);
			System.debug('EN AccountExtension.ActualizaFuerzaVetaWs Contacto.id: ' + Contacto.id + ' AccountId: ' + Contacto.AccountId);
		}					    		
		//Elimina los responsables
		if (!mapContactos.isEmpty()){
			List<Database.Deleteresult> lDtbDr = Database.delete(mapContactos.Values(), false);
			for (Database.Deleteresult objDtbDr : lDtbDr){
				if (!objDtbDr.isSuccess())
			    	System.debug('EN AccountExtension.ActualizaFuerzaVetaWs ERROR A LS HORA DE ELIMINAR LOS CONTACTOS: ' + objDtbDr.getErrors()[0].getMessage()	);					
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
    				System.debug('EN AccountExtension.ActualizaFuerzaVetaWs ERROR a la hora de crear el contacto: ' + objDtupr.getErrors()[0].getMessage());
    		}//Fin del for para lDtupr
    		//Ya tienes los id de los nuevos contactos consultalos
    		if (!setIdUptContact.isEmpty()){
	    		for (Contact objContacto : [Select id, Name, PCT_IdExterno__c 
	    			From Contact Where id IN : setIdUptContact]){
	    			mapIdExtIdSfdc.put(objContacto.PCT_IdExterno__c, objContacto.id);
	    		}//Fin del for para los nuevos contactos
    		}//Fin si !setIdUptContact.isEmpty()
   			System.debug('EN AccountExtension.ActualizaFuerzaVetaWs setIdUptContact: ' + setIdUptContact);
   			System.debug('EN AccountExtension.ActualizaFuerzaVetaWs mapIdExtIdSfdc: ' + mapIdExtIdSfdc);
   		    		
    		//Recorre el mapa de mapIdExternoResponsable y relaciona el reg del Responsable con el del contacto
    		for (String sIdExt : mapIdExternoResponsable.KeySet()){
    			if (mapIdExtIdSfdc.containsKey(sIdExt))
    				mapIdExternoResponsable.get(sIdExt).NombreResponsable__c = mapIdExtIdSfdc.get(sIdExt);
    		}//Fin del for para mapIdExternoResponsable.KeySet()
   			System.debug('EN AccountExtension.ActualizaFuerzaVetaWs mapIdExternoResponsable: ' + mapIdExternoResponsable.Values());
   				    		
    		//Ya tienes los datos de los responsables que vas a insertar
    		List<Database.Upsertresult> lDtuprr = Database.upsert(mapIdExternoResponsable.values(), Responsable__c.PCT_IdExterno__c, false);
    		//Da la vuelta y ve si hubo errores
    		for (Database.Upsertresult objDtuprr : lDtuprr){
    			if (objDtuprr.isSuccess())
    				setIdUptResp.add(objDtuprr.getId());
    			if (!objDtuprr.isSuccess())
    				System.debug('EN AccountExtension.ActualizaFuerzaVetaWs ERROR a la hora de crear el responsable: ' + objDtuprr.getErrors()[0].getMessage());
    		}//Fin del for para lDtupr
   			System.debug('EN AccountExtension.ActualizaFuerzaVetaWs setIdUptResp: ' + setIdUptResp);
    			    		
    	}//Fin si !mapIdExternoContacto.isEmpty()
    	
        if(objClsResTelDirEmp.DirectorioEmpleados == null) {
			elementosAMostrarResponsables = [SELECT Name,  NombreResponsable__c, Funcion__c, Correoelectronico__c, TelefonoExtension__c, Celular__c, CUC__c, Sector__c, Subsector__c FROM Responsable__c WHERE PlanCliente__c = :cuenta.id];
  			System.debug('EN AccountExtension.ActualizaFuerzaVetaWs elementosAMostrarResponsables: ' + elementosAMostrarResponsables);                
        }

		if(objClsResTelDirEmp.ErrorID == null) {
			elementosAMostrarResponsables = [SELECT Name,  NombreResponsable__c, Funcion__c, Correoelectronico__c, TelefonoExtension__c, Celular__c, CUC__c, Sector__c, Subsector__c FROM Responsable__c WHERE PlanCliente__c = :cuenta.id];
			System.debug('EN AccountExtension.ActualizaFuerzaVetaWs elementosAMostrarResponsables: ' + elementosAMostrarResponsables);                
		}

		System.debug('EN AccountExtension.ActualizaFuerzaVetaWs setIdUptResp: ' + setIdUptResp);
   		//Muy bien consulta los datos de los Responsables y metelos al mapa de
		if (!setIdUptResp.isEmpty()){
	        indiceActualResponsables = 1;
	        totalElementosResponsables = new List<Responsable__c>();    
	        mapaIndexacionResponsables = new Map<Integer,List<Responsable__c>>();
	        //String sQuery = 'SELECT '+String.join(new List<String>(SObjectType.Responsable__c.fields.getMap().keySet()),', ')+' FROM Responsable__c WHERE PlanCliente__c = \''+acctId+'\' And PCT_IdExterno__c != null';
	        String sQuery = 'SELECT '+String.join(new List<String>(SObjectType.Responsable__c.fields.getMap().keySet()),', ')+' FROM Responsable__c WHERE ID IN :setIdUptResp And PCT_IdExterno__c != null';
   			System.debug('EN AccountExtension.ActualizaFuerzaVetaWs sQuery: ' + sQuery);
	        totalElementosResponsables = Database.query(sQuery);
	        //Recorre la lista de reg y ve sacando los paquetes
	        for(Integer i=0; i<totalElementosResponsables.size(); i++){
	            if(!mapaIndexacionResponsables.containsKey(((i/5)+1))){
	                mapaIndexacionResponsables.put(((i/5)+1),new List<Responsable__c>());
	            }
	            mapaIndexacionResponsables.get(((i/5)+1)).add(totalElementosResponsables[i]);
	        }
	        totalIndicesResponsables = mapaIndexacionResponsables.keySet().size();
	        elementosAMostrarResponsables = (mapaIndexacionResponsables.containsKey(indiceActualResponsables))
	        	? mapaIndexacionResponsables.get(indiceActualResponsables)
	        	: new List<Responsable__c>();
		}//Fin si tiene algo !setIdUptResp.isEmpty()
        System.debug(loggingLevel.Error, '*** totalElementosResponsables: ' + totalElementosResponsables);
	
	}
    
    public void cambios()
    {
        hanHabidoCambios = true;
    }
    
    public void guardarCambios()
    {
        aCController.save();
        huboError = (ApexPages.hasMessages())?true:false;
    }
    
    //Metodo Conocimiento del cliente
    public void cambiarModoCampo1()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoUno = (modo == 'lectura')?true:false;
        escrituraCampoUno = (modo == 'escritura')?true:false;
    }
    //FIN Metodo Conocimiento del cliente
    
    //Metodo Conocimiento del cliente
    public void cambiarModoCampo2()
    {
        lecturaCampoDos = false;
        escrituraCampoDos = true;
    }
    //FIN Metodo Conocimiento del cliente
    
    //Metodo Conocimiento del cliente
    public void cambiarModoCampo3()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoTres = (modo == 'lectura')?true:false;
        escrituraCampoTres = (modo == 'escritura')?true:false;
        
        if(cuenta.RecordTypeId == SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Empresarial').getRecordTypeId() || cuenta.RecordTypeId == SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel PyME').getRecordTypeId())
        {
            cuenta.InterlocutorConocimientoCliente__c = (modo=='escritura')?null:cuenta.InterlocutorConocimientoCliente__c;
            escrituraCampoDos = (modo=='escritura')?true:escrituraCampoDos;
            lecturaCampoDos = (modo=='escritura')?false:lecturaCampoDos;
        }
    }
    //FIN Metodo Conocimiento del cliente
    
    //Metodo Conocimiento del cliente
    public void cambiarModoCampo4()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoCuatro = (modo == 'lectura')?true:false;
        escrituraCampoCuatro = (modo == 'escritura')?true:false;
        
        cuenta.InterlocutorConocimientoCliente__c = (modo=='escritura')?null:cuenta.InterlocutorConocimientoCliente__c;
        escrituraCampoDos = (modo=='escritura')?true:escrituraCampoDos;
        lecturaCampoDos = (modo=='escritura')?false:lecturaCampoDos;
    }
    //FIN Metodo Conocimiento del cliente
    
    //Metodo Estrategia TIC
    public void cambiarModoCampo5()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoCinco = (modo == 'lectura')?true:false;
        escrituraCampoCinco = (modo == 'escritura')?true:false;
        
        cuenta.InterlocutorEstrategia__c = (modo=='escritura')?null:cuenta.InterlocutorEstrategia__c;
        escrituraCampoSeis = (modo=='escritura')?true:escrituraCampoSeis;
        lecturaCampoSeis = (modo=='escritura')?false:lecturaCampoSeis;
    }
    //FIN Metodo Estrategia TIC
    
    //Metodo Estrategia TIC
    public void cambiarModoCampo6()
    {
        lecturaCampoSeis = false;
        escrituraCampoSeis = true;
    }
    //FIN Metodo Estrategia TIC
    
    //Método Información Análisis Estratégico
    public void cambiarModoCampo7()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoSiete = (modo == 'lectura')?true:false;
        escrituraCampoSiete = (modo == 'escritura')?true:false;
        
        cuenta.InterlocutorAlineamiento__c = (modo=='escritura')?null:cuenta.InterlocutorAlineamiento__c;
        escrituraCampoOcho = (modo=='escritura')?true:escrituraCampoOcho;
        lecturaCampoOcho = (modo=='escritura')?false:lecturaCampoOcho;
    }
    //FIN Método Información Análisis Estratégico
    
    //Método Información Análisis Estratégico
    public void cambiarModoCampo8()
    {
        lecturaCampoOcho = false;
        escrituraCampoOcho = true;
    }
    //FIN Método Información Análisis Estratégico
    
    //Método Información Análisis Estratégico
    public void cambiarModoCampo9()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoNueve = (modo == 'lectura')?true:false;
        escrituraCampoNueve = (modo == 'escritura')?true:false;
    }
    //FIN Método Información Análisis Estratégico
    
    //Método Información Análisis Estratégico
    public void cambiarModoCampo10()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoDiez = (modo == 'lectura')?true:false;
        escrituraCampoDiez = (modo == 'escritura')?true:false;
            
        cuenta.VoBoFecha__c = null;
        cuenta.VoBoNombre__c = null;       
    }
    //FIN Método Información Análisis Estratégico
    
    //Método Información Análisis Estratégico
    public void cambiarModoCampo11()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoOnce = (modo == 'lectura')?true:false;
        escrituraCampoOnce = (modo == 'escritura')?true:false;
    }
    //FIN Método Información Análisis Estratégico
    
    //Método Información Análisis Estratégico
    public void cambiarModoCampo12()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoDoce = (modo == 'lectura')?true:false;
        escrituraCampoDoce = (modo == 'escritura')?true:false;
    }
    //FIN Método Información Análisis Estratégico
    
    //Método Datos Básicos Cliente
    public void cambiarModoCampo13()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoTrece = (modo == 'lectura')?true:false;
        escrituraCampoTrece = (modo == 'escritura')?true:false;
    }
    //FIN Método Datos Básicos Cliente

    //Método Datos Básicos Cliente
    public void cambiarModoCampo14()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoCatorce = (modo == 'lectura')?true:false;
        escrituraCampoCatorce = (modo == 'escritura')?true:false;
    }
    //FIN Método Datos Básicos Cliente

    //Método Datos Básicos Cliente
    public void cambiarModoCampo15()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoQuince = (modo == 'lectura')?true:false;
        escrituraCampoQuince = (modo == 'escritura')?true:false;
    }
    //FIN Método Datos Básicos Cliente

    //Método Datos Básicos Cliente
    public void cambiarModoCampo16()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoDieciseis = (modo == 'lectura')?true:false;
        escrituraCampoDieciseis = (modo == 'escritura')?true:false;
    }
    //FIN Método Datos Básicos Cliente

    //Método Datos Básicos Cliente
    public void cambiarModoCampo17()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoDiecisiete = (modo == 'lectura')?true:false;
        escrituraCampoDiecisiete = (modo == 'escritura')?true:false;
    }
    //FIN Método Datos Básicos Cliente

    //Método Datos Básicos Cliente
    public void cambiarModoCampo18()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoDieciocho = (modo == 'lectura')?true:false;
        escrituraCampoDieciocho = (modo == 'escritura')?true:false;
    }
    //FIN Método Datos Básicos Cliente

    //Método Datos Básicos Cliente
    public void cambiarModoCampo19()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoDiecinueve = (modo == 'lectura')?true:false;
        escrituraCampoDiecinueve = (modo == 'escritura')?true:false;
    }
    //FIN Método Datos Básicos Cliente

    //Método Datos Básicos Cliente
    public void cambiarModoCampo20()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoVeinte = (modo == 'lectura')?true:false;
        escrituraCampoVeinte = (modo == 'escritura')?true:false;
    }
    //FIN Método Datos Básicos Cliente
    
    //Método Siguiente Conocimiento Mercado
    public void anteriorConocimiento()
    {
        indiceActualConocimiento-=1;
        elementosAMostrarConocimiento = mapaIndexacionConocimiento.get(indiceActualConocimiento);
    }
    //Fin Método Siguiente Conocimiento Mercado
    
    //Método Anterior Conocimiento Mercado
    public void siguienteConocimiento()
    {
        indiceActualConocimiento+=1;
        elementosAMostrarConocimiento = mapaIndexacionConocimiento.get(indiceActualConocimiento);
    }
    //Fin Método Anterior Conocimiento Mercado
    
    //Método Siguiente Competencia Telcel
    public void anteriorCompetencia()
    {
        indiceActualCompetencia-=1;
        elementosAMostrarCompetencia = mapaIndexacionCompetencia.get(indiceActualCompetencia);
    }
    //Fin Método Siguiente Competencia Telcel
    
    //Método Anterior Comptencia Telcel
    public void siguienteCompetencia()
    {
        indiceActualCompetencia+=1;
        elementosAMostrarCompetencia = mapaIndexacionCompetencia.get(indiceActualCompetencia);
    }
    //Fin Método Anterior Competencia Telcel
    
    //Método Siguiente Oportunidades
    public void anteriorOportunidades()
    {
        indiceActualOportunidades-=1;
        elementosAMostrarOportunidades = mapaIndexacionOportunidades.get(indiceActualOportunidades);
    }
    //Fin Método Siguiente Oportunidades
    
    //Método Anterior Oportunidades
    public void siguienteOportunidades()
    {
        indiceActualOportunidades+=1;
        elementosAMostrarOportunidades = mapaIndexacionOportunidades.get(indiceActualOportunidades);
    }
    //Fin Método Anterior Oportunidades
    
    //Método Siguiente Interlocutores
    public void anteriorInterlocutores()
    {
        indiceActualInterlocutores-=1;
        elementosAMostrarInterlocutores = mapaIndexacionInterlocutores.get(indiceActualInterlocutores);
    }
    //Fin Método Siguiente Interlocutores
    
    //Método Anterior Interlocutores
    public void siguienteInterlocutores()
    {
        indiceActualInterlocutores+=1;
        elementosAMostrarInterlocutores = mapaIndexacionInterlocutores.get(indiceActualInterlocutores);
    }
    //Fin Método Anterior Interlocutores
    
    //Método Siguiente Directriz
    public void anteriorDirectriz()
    {
        indiceActualDirectriz-=1;
        elementosAMostrarDirectriz = mapaIndexacionDirectriz.get(indiceActualDirectriz);
    }
    //Fin Método Siguiente Directriz
    
    //Método Anterior Directriz
    public void siguienteDirectriz()
    {
        indiceActualDirectriz+=1;
        elementosAMostrarDirectriz = mapaIndexacionDirectriz.get(indiceActualDirectriz);
    }
    //Fin Método Anterior Directriz

    //Método Siguiente Información Societaria
    public void anteriorInformacion()
    {
        indiceActualInformacion-=1;
        elementosAMostrarInformacion = mapaIndexacionInformacion.get(indiceActualInformacion);
    }
    //Fin Método Siguiente Información Societaria
    
    //Método Anterior Información Societaria
    public void siguienteInformacion()
    {
        indiceActualInformacion+=1;
        elementosAMostrarInformacion = mapaIndexacionInformacion.get(indiceActualInformacion);
    }
    //Fin Método Anterior Información Societaria
    
    
    //Método Siguiente Responsables
    public void anteriorResponsables()
    {
        if(elementosAMostrarResponsables.size()>0) {
            indiceActualResponsables-=1;
            elementosAMostrarResponsables = mapaIndexacionResponsables.get(indiceActualResponsables);
        }

    }
    //Fin Método Siguiente Responsables
    
    //Método Anterior Responsables
    public void siguienteResponsables()
    {

        if(elementosAMostrarResponsables.size()>0) {
            indiceActualResponsables+=1;
            elementosAMostrarResponsables = mapaIndexacionResponsables.get(indiceActualResponsables);
        }
    }
    //Fin Método Anterior Responsables
            
    public PageReference reset() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());
        newpage.setRedirect(true);
        return newpage; 
    }

}