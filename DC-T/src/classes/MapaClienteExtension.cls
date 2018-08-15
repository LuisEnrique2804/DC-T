public class MapaClienteExtension {
    
    private final Id acctId;
    public List<ValoracionGeneralCuenta__c> lstvgc {get;set;}
    public List<DeteccionNuevaOportunidad__c> lstdno {get;set;}
    
    //Competidores Plataformas Atributos
    public Integer indiceActualCompetidores{set;get;}
    public Integer totalIndicesCompetidores{set;get;}
    public Map<Integer,List<CompetidoresPlataformas__c>> mapaIndexacionCompetidores;
    public List<CompetidoresPlataformas__c> totalElementosCompetidores;
    public List<CompetidoresPlataformas__c> elementosAMostrarCompetidores{set;get;}
    // Fin Competidores Atributos Atributos
    
    //Clientes Atributos
    public Integer indiceActualClientes{set;get;}
    public Integer totalIndicesClientes{set;get;}
    public Map<Integer,List<ClienteEstratagico__c>> mapaIndexacionClientes;
    public List<ClienteEstratagico__c> totalElementosClientes;
    public List<ClienteEstratagico__c> elementosAMostrarClientes{set;get;}
    // Fin Clientes Atributos
    
    //Proveedores Atributos
    public Integer indiceActualProveedores{set;get;}
    public Integer totalIndicesProveedores{set;get;}
    public Map<Integer,List<ProveedorEstrategico__c>> mapaIndexacionProveedores;
    public List<ProveedorEstrategico__c> totalElementosProveedores;
    public List<ProveedorEstrategico__c> elementosAMostrarProveedores{set;get;}
    // Fin Proveedores Atributos
    
    //Invesrión TIC Atributos
    public Integer indiceActualInversionTIC{set;get;}
    public Integer totalIndicesInversionTIC{set;get;}
    public Map<Integer,List<InversionServicioTICFacturacion__c>> mapaIndexacionInversionTIC;
    public List<InversionServicioTICFacturacion__c> totalElementosInversionTIC;
    public List<InversionServicioTICFacturacion__c> elementosAMostrarInversionTIC{set;get;}
    // Fin Inversión TIC Atributos
    
    //Invesrión Tradicional
    public Integer indiceActualInversionTradicional{set;get;}
    public Integer totalIndicesInversionTradicional{set;get;}
    public Map<Integer,List<InversionServiciosTradicionales__c>> mapaIndexacionInversionTradicional;
    public List<InversionServiciosTradicionales__c> totalElementosInversionTradicional;
    public List<InversionServiciosTradicionales__c> elementosAMostrarInversionTradicional{set;get;}
    // Fin Inversión Tradicional Atributos
    
    //Contrataciones Especiales Atributos
    public Integer indiceActualContrataciones{set;get;}
    public Integer totalIndicesContrataciones{set;get;}
    public Map<Integer,List<ContratacionesEspeciales__c>> mapaIndexacionContrataciones;
    public List<ContratacionesEspeciales__c> totalElementosContrataciones;
    public List<ContratacionesEspeciales__c> elementosAMostrarContrataciones{set;get;}
    // Fin Contrataciones Especiales Atributos
    
    //Centros Decisión Atributos
    public Integer indiceActualCentros{set;get;}
    public Integer totalIndicesCentros{set;get;}
    public Map<Integer,List<CentroDecision__c>> mapaIndexacionCentros;
    public List<CentroDecision__c> totalElementosCentros;
    public List<CentroDecision__c> elementosAMostrarCentros{set;get;}
    // Fin Centros Decisión Atributos
    
    //Centros Decisión Atributos
    public Integer indiceActualIncidencias{set;get;}
    public Integer totalIndicesIncidencias{set;get;}
    public Map<Integer,List<IncidenciaRelevante__c>> mapaIndexacionIncidencias;
    public List<IncidenciaRelevante__c> totalElementosIncidencias;
    public List<IncidenciaRelevante__c> elementosAMostrarIncidencias{set;get;}
    // Fin Centros Decisión Atributos
    
    //Deteccion Nuevas Oportunides Atributos
    public Integer indiceActualDeteccion{set;get;}
    public Integer totalIndicesDeteccion{set;get;}
    public Map<Integer,List<DeteccionNuevaOportunidad__c>> mapaIndexacionDeteccion;
    public List<DeteccionNuevaOportunidad__c> totalElementosDeteccion;
    public List<DeteccionNuevaOportunidad__c> elementosAMostrarDeteccion{set;get;}
    // Fin Detección Nuevas Oportunidades Atributos
    
    //Conectores con Otras Areas Atributos
    public Integer indiceActualConectores{set;get;}
    public Integer totalIndicesConectores{set;get;}
    public Map<Integer,List<ConectoresOtrasAreas__c>> mapaIndexacionConectores;
    public List<ConectoresOtrasAreas__c> totalElementosConectores;
    public List<ConectoresOtrasAreas__c> elementosAMostrarConectores{set;get;}
    // Fin Conectores con Otras Areas Atributos
    
    //Valoracion General Cuenta Atributos
    public Integer indiceActualValoracion{set;get;}
    public Integer totalIndicesValoracion{set;get;}
    public Map<Integer,List<ValoracionGeneralCuenta__c>> mapaIndexacionValoracion;
    public List<ValoracionGeneralCuenta__c> totalElementosValoracion;
    public List<ValoracionGeneralCuenta__c> elementosAMostrarValoracion{set;get;}
    // Fin Valoracion General Cuenta Atributos
    
    //Campos Información de Telcel y del Cliente
    public Boolean lecturaCampoUno{set;get;}
    public Boolean escrituraCampoUno{set;get;}
    public Boolean lecturaCampoDos{set;get;}
    public Boolean escrituraCampoDos{set;get;}
    //FIN Campos Información de Telcel y del Cliente
    
    //Campos Información para Detectar Oportunidades
    public Boolean lecturaCampoTres{set;get;}
    public Boolean lecturaCampoCuatro{set;get;}
    public Boolean escrituraCampoTres{set;get;}
    public Boolean escrituraCampoCuatro{set;get;}
    //FIN Campos Información para Detectar Oportunidades
    
    public MapaCliente__c mapaCliente{set;get;}    
    public ApexPages.StandardController mCController; 
    public Boolean huboError{set;get;}
    public Boolean hanHabidoCambios{set;get;}
    public Boolean perfilValidoEscritura{set;get;}
    
    public final String escritura{set;get;}
    
    public class wrpCompetidoresPlataformas{
    	public String sPlataforma {get;set;}
    	public CompetidoresPlataformas__c objCompetPlat {get;set;}    	
    	
    	public wrpCompetidoresPlataformas(String sPlataforma, CompetidoresPlataformas__c objCompetPlat){
    		this.sPlataforma = sPlataforma;
    		this.objCompetPlat = objCompetPlat;
    	}
    }
    public List<wrpCompetidoresPlataformas> lWrpCompPlat {get;set;}
    
    public MapaClienteExtension(ApexPages.StandardController stdController){
    
        mCController= stdController;
        List<String> todosCamposMapaCliente = new List<String>();
        todosCamposMapaCliente.addAll(SObjectType.MapaCliente__c.fields.getMap().keySet());
        if (!test.isRunningTest()) mCController.addFields(todosCamposMapaCliente);
        mapaCliente= (MapaCliente__c) mCController.getRecord();
        
        escritura = '\'escritura\'';  
        
        huboError = false;       
        
        String nombrePerfil = [SELECT Name FROM Profile WHERE Id=:userInfo.getProfileId()].Name;
        perfilValidoEscritura = (nombrePerfil  == 'Administrador del sistema' || nombrePerfil  == 'JEC')?true:false; 
    
        //acctId = stdController.getId();
        String acctId = stdController.getId();
        
        //Campos Información de Telcel y del Cliente
        lecturaCampoUno = true;
        escrituraCampoUno = false;
        lecturaCampoDos = true;
        escrituraCampoDos = false;
        //FIN Campos Información de Telcel y del Cliente
        
        //Campos Información para Detectar Oportunidades
        lecturaCampoTres = true;
        lecturaCampoCuatro = true;
        escrituraCampoTres = false;
        escrituraCampoCuatro = false;
        //FIN Campos Información para Detectar Oportunidades
        
        //Operaciones Competidores
		lWrpCompPlat = new List<wrpCompetidoresPlataformas>();
        indiceActualCompetidores = 1;
        totalElementosCompetidores = new List<CompetidoresPlataformas__c>();    
        mapaIndexacionCompetidores = new Map<Integer,List<CompetidoresPlataformas__c>>();
        Map<String, CompetidoresPlataformas__c> mapCompe = new map<String, CompetidoresPlataformas__c>();        
        Map<String, CompetidoresPlataformas__c> mapCompeSD = new map<String, CompetidoresPlataformas__c>();        
        Set<String> setNomCom = new Set<String>();
        //totalElementosCompetidores = Database.query('SELECT '+String.join(new List<String>(SObjectType.CompetidoresPlataformas__c.fields.getMap().keySet()),', ')+' from CompetidoresPlataformas__c Where ServiciosTradicionales__r.MapaCliente__c = \''+acctId+'\''+ ' And Directorio_Comercial__c != null order by Name');
        
        //Cambia la consulta los que estan asociados a un directorio
		for (CompetidoresPlataformas__c competidor : [Select c.Directorio_Comercial__c, c.DCTsummary__c, c.CreatedDate, 
			DCTCompetitors__r.Name, Directorio_Comercial__r.Cliente__c, Name, Facturacion__c, Plataforma__c,
			LineasCompetidor__c
			From CompetidoresPlataformas__c c 
			Where ServiciosTradicionales__r.MapaCliente__c = :acctId
			And Directorio_Comercial__c != null
			Order by c.Name DESC]){				
			System.debug('EN MapaClienteExtension Name0: ' + competidor.Name + ' LineasCompetidor__c: ' + competidor.LineasCompetidor__c);
			//Metelos al set de setCompe
			if (mapCompe.containsKey(competidor.Name))
				mapCompe.get(competidor.Name).DCTsummary__c += competidor.LineasCompetidor__c != null ? competidor.LineasCompetidor__c : 0;
			if (!mapCompe.containsKey(competidor.Name)){
				competidor.DCTsummary__c = competidor.LineasCompetidor__c != null ? competidor.LineasCompetidor__c : 0;
				mapCompe.put(competidor.Name, competidor);
			}
			System.debug('EN MapaClienteExtension DCTsummary__c: ' + mapCompe.get(competidor.Name).DCTsummary__c);				
			//Metelos a setNomCom			
			setNomCom.add(competidor.Name);			
		}
		System.debug('EN MapaClienteExtension mapCompe: ' + mapCompe.KeySet());		
		System.debug('EN MapaClienteExtension mapCompe: ' + mapCompe.Values());
		
		//Los que no estan asociados a un directorio
		for (CompetidoresPlataformas__c competidor : [Select c.Directorio_Comercial__c, c.DCTsummary__c, c.CreatedDate, 
			DCTCompetitors__r.Name, Directorio_Comercial__r.Cliente__c, Name, Facturacion__c, Plataforma__c,
			LineasCompetidor__c
			From CompetidoresPlataformas__c c 
			Where ServiciosTradicionales__r.MapaCliente__c = :acctId
			And Directorio_Comercial__c = null
			Order by c.Name DESC]){
			System.debug('EN MapaClienteExtension Name1: ' + competidor.Name + ' LineasCompetidor__c: ' + competidor.LineasCompetidor__c);
			if (mapCompeSD.containsKey(competidor.Name))
				mapCompeSD.get(competidor.Name).DCTsummary__c += competidor.LineasCompetidor__c != null ? competidor.LineasCompetidor__c : 0;
			if (!mapCompeSD.containsKey(competidor.Name)){
				competidor.DCTsummary__c = competidor.LineasCompetidor__c != null ? competidor.LineasCompetidor__c : 0;
				mapCompeSD.put(competidor.Name, competidor);
			}
			System.debug('EN MapaClienteExtension DCTsummary__c: ' + mapCompeSD.get(competidor.Name).DCTsummary__c);			
			//Metelos a setNomCom 	
			setNomCom.add(competidor.Name);
		}
		System.debug('EN MapaClienteExtension mapCompeSD: ' + mapCompeSD.KeySet());		
		System.debug('EN MapaClienteExtension mapCompeSD: ' + mapCompeSD.Values());
				
		//Recorre el mapa de mapCompe y mete los reg a totalElementosCompetidores
		for (String sNomComPaso : setNomCom){
			Decimal dTotLinCom = 0;
			CompetidoresPlataformas__c competidor;
			//Ve si existe en mapCompe
			if (mapCompe.containsKey(sNomComPaso)){
				competidor = mapCompe.get(sNomComPaso);
				dTotLinCom += mapCompe.get(sNomComPaso).DCTsummary__c;
			}
			if (mapCompeSD.containsKey(sNomComPaso)){
				competidor = mapCompeSD.get(sNomComPaso);				
				dTotLinCom += mapCompeSD.get(sNomComPaso).DCTsummary__c;
			}
			//Actualiza las lineas totales
			competidor.LineasCompetidor__c = dTotLinCom;
			lWrpCompPlat.add(new wrpCompetidoresPlataformas('Voz/Datos', competidor));	
		}		
		System.debug('EN MapaClienteExtension lWrpCompPlat: ' + lWrpCompPlat);
		
		//Recorre la lista de totalElementosCompetidores
        for(Integer i=0; i<totalElementosCompetidores.size(); i++){
            if(!mapaIndexacionCompetidores.containsKey(((i/5)+1))){
               mapaIndexacionCompetidores.put(((i/5)+1),new List<CompetidoresPlataformas__c>());
            }
            mapaIndexacionCompetidores.get(((i/5)+1)).add(totalElementosCompetidores[i]);
        }
        totalIndicesCompetidores = mapaIndexacionCompetidores.keySet().size();
        elementosAMostrarCompetidores = (mapaIndexacionCompetidores.containsKey(indiceActualCompetidores))?mapaIndexacionCompetidores.get(indiceActualCompetidores):new List<CompetidoresPlataformas__c>(); 
        // Fin Operaciones Competidores
        
        
        //Operaciones Clientes
        indiceActualClientes = 1;
        totalElementosClientes = new List<ClienteEstratagico__c>();    
        mapaIndexacionClientes = new Map<Integer,List<ClienteEstratagico__c>>();
        totalElementosClientes = Database.query('SELECT '+String.join(new List<String>(SObjectType.ClienteEstratagico__c.fields.getMap().keySet()),', ')+' FROM ClienteEstratagico__c WHERE MapaCliente__c = \''+acctId+'\''+ 'order by CreatedDate ASC');
        for(Integer i=0; i<totalElementosClientes.size(); i++)
        {
            if(!mapaIndexacionClientes.containsKey(((i/5)+1)))
            {
                mapaIndexacionClientes.put(((i/5)+1),new List<ClienteEstratagico__c>());
            }
            
            mapaIndexacionClientes.get(((i/5)+1)).add(totalElementosClientes[i]);
        }
        totalIndicesClientes = mapaIndexacionClientes.keySet().size();
        elementosAMostrarClientes = (mapaIndexacionClientes.containsKey(indiceActualClientes))?mapaIndexacionClientes.get(indiceActualClientes):new List<ClienteEstratagico__c>();
        // Fin Operaciones Clientes
        
        //Operaciones Proveedores
        indiceActualProveedores = 1;
        totalElementosProveedores = new List<ProveedorEstrategico__c>();    
        mapaIndexacionProveedores = new Map<Integer,List<ProveedorEstrategico__c>>();
        totalElementosProveedores = Database.query('SELECT '+String.join(new List<String>(SObjectType.ProveedorEstrategico__c.fields.getMap().keySet()),', ')+' FROM ProveedorEstrategico__c WHERE MapaCliente__c = \''+acctId+'\''+ 'order by CreatedDate ASC');
        for(Integer i=0; i<totalElementosProveedores.size(); i++)
        {
            if(!mapaIndexacionProveedores.containsKey(((i/5)+1)))
            {
                mapaIndexacionProveedores.put(((i/5)+1),new List<ProveedorEstrategico__c>());
            }
            
            mapaIndexacionProveedores.get(((i/5)+1)).add(totalElementosProveedores[i]);
        }
        totalIndicesProveedores = mapaIndexacionProveedores.keySet().size();
        elementosAMostrarProveedores = (mapaIndexacionProveedores.containsKey(indiceActualProveedores))?mapaIndexacionProveedores.get(indiceActualProveedores):new List<ProveedorEstrategico__c>();
        // Fin Operaciones Proveedores
    
        //Operaciones Inversion TIC
        indiceActualInversionTIC = 1;
        totalElementosInversionTIC = new List<InversionServicioTICFacturacion__c>();    
        mapaIndexacionInversionTIC = new Map<Integer,List<InversionServicioTICFacturacion__c>>();
        totalElementosInversionTIC = Database.query('SELECT '+String.join(new List<String>(SObjectType.InversionServicioTICFacturacion__c.fields.getMap().keySet()),', ')+' FROM InversionServicioTICFacturacion__c WHERE MapaCliente__c = \''+acctId+'\''+ 'order by PlataformasTIC__c');
        for(Integer i=0; i<totalElementosInversionTIC.size(); i++)
        {
            if(!mapaIndexacionInversionTIC.containsKey(((i/5)+1)))
            {
                mapaIndexacionInversionTIC.put(((i/5)+1),new List<InversionServicioTICFacturacion__c>());
            }
            
            mapaIndexacionInversionTIC.get(((i/5)+1)).add(totalElementosInversionTIC[i]);
        }
        totalIndicesInversionTIC = mapaIndexacionInversionTIC.keySet().size();
        elementosAMostrarInversionTIC = (mapaIndexacionInversionTIC.containsKey(indiceActualInversionTIC))?mapaIndexacionInversionTIC.get(indiceActualInversionTIC):new List<InversionServicioTICFacturacion__c>();
        // Fin Operaciones Inversion TIC
        
        //Operaciones Inversion Tradicionales
        indiceActualInversionTradicional = 1;
        totalElementosInversionTradicional = new List<InversionServiciosTradicionales__c>();    
        mapaIndexacionInversionTradicional = new Map<Integer,List<InversionServiciosTradicionales__c>>();
        totalElementosInversionTradicional = Database.query('SELECT '+String.join(new List<String>(SObjectType.InversionServiciosTradicionales__c.fields.getMap().keySet()),', ')+' FROM InversionServiciosTradicionales__c WHERE MapaCliente__c = \''+acctId+'\''+ 'order by CreatedDate ASC');
        for(Integer i=0; i<totalElementosInversionTradicional.size(); i++)
        {
            if(!mapaIndexacionInversionTradicional.containsKey(((i/5)+1)))
            {
                mapaIndexacionInversionTradicional.put(((i/5)+1),new List<InversionServiciosTradicionales__c>());
            }
            
            mapaIndexacionInversionTradicional.get(((i/5)+1)).add(totalElementosInversionTradicional[i]);
        }
        totalIndicesInversionTradicional = mapaIndexacionInversionTradicional.keySet().size();
        elementosAMostrarInversionTradicional = (mapaIndexacionInversionTradicional.containsKey(indiceActualInversionTradicional))?mapaIndexacionInversionTradicional.get(indiceActualInversionTradicional):new List<InversionServiciosTradicionales__c>();
        // Fin Operaciones Inversiones Tradicionales
        
        //Operaciones Conrataciones Especiales
        indiceActualContrataciones = 1;
        totalElementosContrataciones = new List<ContratacionesEspeciales__c>();    
        mapaIndexacionContrataciones = new Map<Integer,List<ContratacionesEspeciales__c>>();
        totalElementosContrataciones = Database.query('SELECT '+String.join(new List<String>(SObjectType.ContratacionesEspeciales__c.fields.getMap().keySet()),', ')+' FROM ContratacionesEspeciales__c WHERE MapaCliente__c = \''+acctId+'\''+ 'order by CreatedDate ASC');
        for(Integer i=0; i<totalElementosContrataciones.size(); i++)
        {
            if(!mapaIndexacionContrataciones.containsKey(((i/5)+1)))
            {
                mapaIndexacionContrataciones.put(((i/5)+1),new List<ContratacionesEspeciales__c>());
            }
            
            mapaIndexacionContrataciones.get(((i/5)+1)).add(totalElementosContrataciones[i]);
        }
        totalIndicesContrataciones = mapaIndexacionContrataciones.keySet().size();
        elementosAMostrarContrataciones = (mapaIndexacionContrataciones.containsKey(indiceActualContrataciones))?mapaIndexacionContrataciones.get(indiceActualContrataciones):new List<ContratacionesEspeciales__c>();
        // Fin Operaciones Contrataciones Especiales
        
        //Operaciones Centros Decisión
        indiceActualCentros = 1;
        totalElementosCentros = new List<CentroDecision__c>();    
        mapaIndexacionCentros = new Map<Integer,List<CentroDecision__c>>();
        totalElementosCentros = Database.query('SELECT '+String.join(new List<String>(SObjectType.CentroDecision__c.fields.getMap().keySet()),', ')+' FROM CentroDecision__c WHERE MapaCliente__c = \''+acctId+'\''+ 'order by CreatedDate ASC');
        for(Integer i=0; i<totalElementosCentros.size(); i++)
        {
            if(!mapaIndexacionCentros.containsKey(((i/5)+1)))
            {
                mapaIndexacionCentros.put(((i/5)+1),new List<CentroDecision__c>());
            }
            
            mapaIndexacionCentros.get(((i/5)+1)).add(totalElementosCentros[i]);
        }
        totalIndicesCentros = mapaIndexacionCentros.keySet().size();
        elementosAMostrarCentros = (mapaIndexacionCentros.containsKey(indiceActualCentros))?mapaIndexacionCentros.get(indiceActualCentros):new List<CentroDecision__c>();
        // Fin Operaciones Centros Decisión
        
        //Operaciones Incidencias
        indiceActualIncidencias = 1;
        totalElementosIncidencias = new List<IncidenciaRelevante__c>();    
        mapaIndexacionIncidencias = new Map<Integer,List<IncidenciaRelevante__c>>();
        totalElementosIncidencias = Database.query('SELECT '+String.join(new List<String>(SObjectType.IncidenciaRelevante__c.fields.getMap().keySet()),', ')+' FROM IncidenciaRelevante__c WHERE MapaCliente__c = \''+acctId+'\''+ 'order by CreatedDate ASC');
        for(Integer i=0; i<totalElementosIncidencias.size(); i++)
        {
            if(!mapaIndexacionIncidencias.containsKey(((i/5)+1)))
            {
                mapaIndexacionIncidencias.put(((i/5)+1),new List<IncidenciaRelevante__c>());
            }
            
            mapaIndexacionIncidencias.get(((i/5)+1)).add(totalElementosIncidencias[i]);
        }
        totalIndicesIncidencias = mapaIndexacionIncidencias.keySet().size();
        elementosAMostrarIncidencias = (mapaIndexacionIncidencias.containsKey(indiceActualIncidencias))?mapaIndexacionIncidencias.get(indiceActualIncidencias):new List<IncidenciaRelevante__c>();
        // Fin Operaciones Incidencias
        
        //Operaciones Deteccion Nueva Oportunidad
        indiceActualDeteccion = 1;
        totalElementosDeteccion = new List<DeteccionNuevaOportunidad__c>();    
        mapaIndexacionDeteccion = new Map<Integer,List<DeteccionNuevaOportunidad__c>>();
        totalElementosDeteccion = Database.query('SELECT '+String.join(new List<String>(SObjectType.DeteccionNuevaOportunidad__c.fields.getMap().keySet()),', ')+' FROM DeteccionNuevaOportunidad__c WHERE MapaCliente__c = \''+acctId+'\''+ 'order by CreatedDate ASC');
        for(Integer i=0; i<totalElementosDeteccion.size(); i++)
        {
            if(!mapaIndexacionDeteccion.containsKey(((i/5)+1)))
            {
                mapaIndexacionDeteccion.put(((i/5)+1),new List<DeteccionNuevaOportunidad__c>());
            }
            
            mapaIndexacionDeteccion.get(((i/5)+1)).add(totalElementosDeteccion[i]);
        }
        totalIndicesDeteccion = mapaIndexacionDeteccion.keySet().size();
        elementosAMostrarDeteccion = (mapaIndexacionDeteccion.containsKey(indiceActualDeteccion))?mapaIndexacionDeteccion.get(indiceActualDeteccion):new List<DeteccionNuevaOportunidad__c>();
        // Fin Operaciones Nueva Oportunidad
        
        //Operaciones Conectores con Otras Areas
        indiceActualConectores = 1;
        totalElementosConectores = new List<ConectoresOtrasAreas__c>();    
        mapaIndexacionConectores = new Map<Integer,List<ConectoresOtrasAreas__c>>();
        totalElementosConectores = Database.query('SELECT '+String.join(new List<String>(SObjectType.ConectoresOtrasAreas__c.fields.getMap().keySet()),', ')+' FROM ConectoresOtrasAreas__c WHERE MapaCliente__c = \''+acctId+'\''+ 'order by CreatedDate ASC');
        for(Integer i=0; i<totalElementosConectores.size(); i++)
        {
            if(!mapaIndexacionConectores.containsKey(((i/5)+1)))
            {
                mapaIndexacionConectores.put(((i/5)+1),new List<ConectoresOtrasAreas__c>());
            }
            
            mapaIndexacionConectores.get(((i/5)+1)).add(totalElementosConectores[i]);
        }
        totalIndicesConectores = mapaIndexacionConectores.keySet().size();
        elementosAMostrarConectores = (mapaIndexacionConectores.containsKey(indiceActualConectores))?mapaIndexacionConectores.get(indiceActualConectores):new List<ConectoresOtrasAreas__c>();
        // Fin Operaciones Conectores con Otras Areas
        
        //Operaciones Valoracion General Cuenta
        indiceActualValoracion = 1;
        totalElementosValoracion = new List<ValoracionGeneralCuenta__c>();    
        mapaIndexacionValoracion = new Map<Integer,List<ValoracionGeneralCuenta__c>>();
        totalElementosValoracion = Database.query('SELECT '+String.join(new List<String>(SObjectType.ValoracionGeneralCuenta__c.fields.getMap().keySet()),', ')+' FROM ValoracionGeneralCuenta__c WHERE MapaCliente__c = \''+acctId+'\''+ 'order by Tipo__c, CreatedDate ASC');
        for(Integer i=0; i<totalElementosValoracion.size(); i++)
        {
            if(!mapaIndexacionValoracion.containsKey(((i/5)+1)))
            {
                mapaIndexacionValoracion.put(((i/5)+1),new List<ValoracionGeneralCuenta__c>());
            }
            
            mapaIndexacionValoracion.get(((i/5)+1)).add(totalElementosValoracion[i]);
        }
        totalIndicesValoracion = mapaIndexacionValoracion.keySet().size();
        elementosAMostrarValoracion = (mapaIndexacionValoracion.containsKey(indiceActualValoracion))?mapaIndexacionValoracion.get(indiceActualValoracion):new List<ValoracionGeneralCuenta__c>();
        // Fin Operaciones Valoración General Cuenta
    
        lstvgc = [select Id, Name, Tipo__c, Descripcion__c, createddate
                  from ValoracionGeneralCuenta__c
                  where MapaCliente__c =:acctId
                  order by Tipo__c];
                  
                  
        lstdno = [select Id, Name, AreaCliente__c, Fecha__c, Interlocutor__c, OportunidadesPotenciales__c, createddate
                  from DeteccionNuevaOportunidad__c
                  where MapaCliente__c =:acctId
                  order by createddate ASC];          
        
    }
    
    
    
    
    public void cambios()
    {
        hanHabidoCambios = true;
    }
    
    public void guardarCambios()
    {
        if (!test.isRunningTest()) mCController.save();
        huboError = (ApexPages.hasMessages())?true:false;
    }
    
    //Metodo Información de Telcel y del Cliente
    public void cambiarModoCampo1()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoUno = (modo == 'lectura')?true:false;
        escrituraCampoUno = (modo == 'escritura')?true:false;
    }
    //FIN Metodo Información de Telcel y del Cliente
    
    //Metodo Información de Telcel y del Cliente
    public void cambiarModoCampo2()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoDos = (modo == 'lectura')?true:false;
        escrituraCampoDos = (modo == 'escritura')?true:false;
    }
    //FIN Metodo Información de Telcel y del Cliente
    
    //Metodo Información para Detectar Oportunidades
    public void cambiarModoCampo3()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoTres = (modo == 'lectura')?true:false;
        escrituraCampoTres = (modo == 'escritura')?true:false;
    }
    //FIN Metodo Información para Detectar Oportunidades
    
    //Metodo Información para Detectar Oportunidades
    public void cambiarModoCampo4()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoCuatro = (modo == 'lectura')?true:false;
        escrituraCampoCuatro = (modo == 'escritura')?true:false;
    }
    //FIN Metodo Información para Detectar Oportunidades
    
    //Método Siguiente Clientes
    public void anteriorClientes()
    {
        indiceActualClientes-=1;
        elementosAMostrarClientes = mapaIndexacionClientes.get(indiceActualClientes);
    }
    //Fin Método Siguiente Clientes
    
    //Método Anterior Clientes
    public void siguienteClientes()
    {
        indiceActualClientes+=1;
        elementosAMostrarClientes = mapaIndexacionClientes.get(indiceActualClientes);
    }
    //Fin Método Anterior Clientes
    
    //Método Siguiente Proveedores
    public void anteriorProveedores()
    {
        indiceActualProveedores-=1;
        elementosAMostrarProveedores = mapaIndexacionProveedores.get(indiceActualProveedores);
    }
    //Fin Método Siguiente Proveedores
    
    //Método Anterior Proveedores
    public void siguienteProveedores()
    {
        indiceActualProveedores+=1;
        elementosAMostrarProveedores = mapaIndexacionProveedores.get(indiceActualProveedores);
    }
    //Fin Método Anterior Proveedores
    
    //Método Siguiente Inversion TIC
    public void anteriorInversionTIC()
    {
        indiceActualInversionTIC-=1;
        elementosAMostrarInversionTIC = mapaIndexacionInversionTIC.get(indiceActualInversionTIC);
    }
    //Fin Método Siguiente Inversion TIC
    
    //Método Anterior Inversion TIC
    public void siguienteInversionTIC()
    {
        indiceActualInversionTIC+=1;
        elementosAMostrarInversionTIC = mapaIndexacionInversionTIC.get(indiceActualInversionTIC);
    }
    //Fin Método Anterior Inversion TIC
    
    //Método Siguiente Inversion Tradicional
    public void anteriorInversionTradicional()
    {
        indiceActualInversionTradicional-=1;
        elementosAMostrarInversionTradicional = mapaIndexacionInversionTradicional.get(indiceActualInversionTradicional);
    }
    //Fin Método Siguiente Inversion Tradicional
    
    //Método Anterior Inversion Tradicional
    public void siguienteInversionTradicional()
    {
        indiceActualInversionTradicional+=1;
        elementosAMostrarInversionTradicional = mapaIndexacionInversionTradicional.get(indiceActualInversionTradicional);
    }
    //Fin Método Anterior Inversion Tradicional
    
    //Método Siguiente Contrataciones 
    public void anteriorContrataciones()
    {
        indiceActualContrataciones-=1;
        elementosAMostrarContrataciones = mapaIndexacionContrataciones.get(indiceActualContrataciones);
    }
    //Fin Método Siguiente Contrataciones
    
    //Método Anterior Contrataciones
    public void siguienteContrataciones()
    {
        indiceActualContrataciones+=1;
        elementosAMostrarContrataciones = mapaIndexacionContrataciones.get(indiceActualContrataciones);
    }
    //Fin Método Anterior Contrataciones
    
    //Método Siguiente Centros
    public void anteriorCentros()
    {
        indiceActualCentros-=1;
        elementosAMostrarCentros = mapaIndexacionCentros.get(indiceActualCentros);
    }
    //Fin Método Siguiente Centros
    
    //Método Anterior Centros
    public void siguienteCentros()
    {
        indiceActualCentros+=1;
        elementosAMostrarCentros = mapaIndexacionCentros.get(indiceActualCentros);
    }
    //Fin Método Anterior Centros
    
    //Método Siguiente Incidencias
    public void anteriorIncidencias()
    {
        indiceActualIncidencias-=1;
        elementosAMostrarIncidencias = mapaIndexacionIncidencias.get(indiceActualIncidencias);
    }
    //Fin Método Siguiente Incidencias
    
    //Método Anterior Incidencias
    public void siguienteIncidencias()
    {
        indiceActualIncidencias+=1;
        elementosAMostrarIncidencias = mapaIndexacionIncidencias.get(indiceActualIncidencias);
    }
    //Fin Método Anterior Incidencias
    
    //Método Siguiente Deteccion Nueva Oportunidad
    public void anteriorDeteccion()
    {
        indiceActualDeteccion-=1;
        elementosAMostrarDeteccion = mapaIndexacionDeteccion.get(indiceActualDeteccion);
    }
    //Fin Método Siguiente Deteccion Nueva Oportunidad
    
    //Método Anterior Deteccion Nueva Oportunidad
    public void siguienteDeteccion()
    {
        indiceActualDeteccion+=1;
        elementosAMostrarDeteccion = mapaIndexacionDeteccion.get(indiceActualDeteccion);
    }
    //Fin Método Anterior Detección Nuevas Oportunidad
    
    //Método Siguiente Conector con Otra Area
    public void anteriorConectores()
    {
        indiceActualConectores-=1;
        elementosAMostrarConectores = mapaIndexacionConectores.get(indiceActualConectores);
    }
    //Fin Método Siguiente Conector con Otra Area
    
    //Método Anterior Conector con Otra Area
    public void siguienteConectores()
    {
        indiceActualConectores+=1;
        elementosAMostrarConectores = mapaIndexacionConectores.get(indiceActualConectores);
    }
    //Fin Método Anterior Conector con Otra Area
    
    //Método Siguiente Valoracion General Cuenta
    public void anteriorValoracion()
    {
        indiceActualValoracion-=1;
        elementosAMostrarValoracion = mapaIndexacionValoracion.get(indiceActualValoracion);
    }
    //Fin Método Siguiente Valoracion General Cuenta
    
    //Método Anterior Valoracion General Cuenta
    public void siguienteValoracion()
    {
        indiceActualValoracion+=1;
        elementosAMostrarValoracion = mapaIndexacionValoracion.get(indiceActualValoracion);
    }
    //Fin Método Anterior Valoracion General Cuenta
    
    //Método Siguiente Competidores
    public void anteriorCompetidores()
    {
        indiceActualCompetidores-=1;
        elementosAMostrarCompetidores = mapaIndexacionCompetidores.get(indiceActualCompetidores);
    }
    //Fin Método Siguiente Competidores
    
    //Método Anterior Competidores
    public void siguienteCompetidores()
    {
        indiceActualCompetidores+=1;
        elementosAMostrarCompetidores = mapaIndexacionCompetidores.get(indiceActualCompetidores);
    }
    //Fin Método Anterior Competidores
    
    public PageReference reset() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());
        newpage.setRedirect(true);
        return newpage;
    }


}