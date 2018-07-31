public class testAPEXCorporativoDatosBasicoCliente{


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
    
    public Account cuenta{set;get;}    
    public ApexPages.StandardController aCController; 
    
    public testAPEXCorporativoDatosBasicoCliente(ApexPages.StandardController stdController){
    
        aCController = stdController;
        List<String> todosCamposCuenta = new List<String>();
        todosCamposCuenta.addAll(SObjectType.Account.fields.getMap().keySet());
        todosCamposCuenta.add('InterlocutorEstrategia__r.Name');
        if (!test.isRunningTest())aCController.addFields(todosCamposCuenta);
        cuenta = (Account) aCController.getRecord();
                
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
        
         //Operaciones Conocimiento de Mercado
        indiceActualConocimiento = 1;
        totalElementosConocimiento = new List<ConocimientoMercado__c>();    
        mapaIndexacionConocimiento = new Map<Integer,List<ConocimientoMercado__c>>();
        totalElementosConocimiento = Database.query('SELECT '+String.join(new List<String>(SObjectType.ConocimientoMercado__c.fields.getMap().keySet()),', ')+' FROM ConocimientoMercado__c WHERE PlanCliente__c = \''+acctId+'\''+ 'order by CreatedDate ASC');
        for(Integer i=0; i<totalElementosConocimiento.size(); i++)
        {
            if(!mapaIndexacionConocimiento.containsKey(((i/5)+1)))
            {
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
        for(Integer i=0; i<totalElementosCompetencia.size(); i++)
        {
            if(!mapaIndexacionCompetencia.containsKey(((i/5)+1)))
            {
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
        totalElementosOportunidades = Database.query('SELECT '+String.join(new List<String>(SObjectType.SeguimientoOportunidades__c.fields.getMap().keySet()),', ')+', Embudo__r.P__c, Embudo__r.Id,  Embudo__r.Name, Embudo__r.StageName, Embudo__r.FechaInicio__c  FROM SeguimientoOportunidades__c WHERE PlanCliente__c = \''+acctId+'\''+ 'order by Embudo__r.StageName DESC, LineasR9__c DESC');
        for(Integer i=0; i<totalElementosOportunidades.size(); i++)
        {
            if(!mapaIndexacionOportunidades.containsKey(((i/5)+1)))
            {
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
        for(Integer i=0; i<totalElementosInterlocutores.size(); i++)
        {
            if(!mapaIndexacionInterlocutores.containsKey(((i/5)+1)))
            {
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
        for(Integer i=0; i<totalElementosDirectriz.size(); i++)
        {
            if(!mapaIndexacionDirectriz.containsKey(((i/5)+1)))
            {
                mapaIndexacionDirectriz.put(((i/5)+1),new List<Directriz_Telcel__c>());
            }
            
            mapaIndexacionDirectriz.get(((i/5)+1)).add(totalElementosDirectriz[i]);
        }
        totalIndicesDirectriz = mapaIndexacionDirectriz.keySet().size();
        elementosAMostrarDirectriz = (mapaIndexacionDirectriz.containsKey(indiceActualDirectriz))?mapaIndexacionDirectriz.get(indiceActualDirectriz):new List<Directriz_Telcel__c>();
        // Fin Operaciones Directriz 

        
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
    
    public void cambios()
    {
        hanHabidoCambios = true;
    }
    
    //Metodo Conocimiento del cliente
    public void cambiarModoCampo1()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoUno = (modo == 'lectura')?true:false;
        escrituraCampoUno = (modo == 'escritura')?true:false;
        
        cuenta.InterlocutorConocimientoCliente__c = (modo=='escritura')?null:cuenta.InterlocutorConocimientoCliente__c;
        escrituraCampoDos = (modo=='escritura')?true:escrituraCampoDos;
        lecturaCampoDos = (modo=='escritura')?false:lecturaCampoDos;
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
    }
    //FIN Metodo Conocimiento del cliente
    
    //Metodo Conocimiento del cliente
    public void cambiarModoCampo4()
    {
        String modo = ApexPages.currentPage().getParameters().get('modo');
        lecturaCampoCuatro = (modo == 'lectura')?true:false;
        escrituraCampoCuatro = (modo == 'escritura')?true:false;
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
    
    
    public PageReference reset() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());
        newpage.setRedirect(true);
        return newpage;
    }
    
    

}