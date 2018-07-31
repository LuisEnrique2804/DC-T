public class SeguimientoOportunidadListasExtension
{
    //Soportes Atributos
    public Integer indiceActualSoportes{set;get;}
    public Integer totalIndicesSoportes{set;get;}
    public Map<Integer,List<SoportedentroTelcel__c>> mapaIndexacionSoportes;
    public List<SoportedentroTelcel__c> totalElementosSoportes;
    public List<SoportedentroTelcel__c> elementosAMostrarSoportes{set;get;}
    // Fin Soportes Atributos
    
    //Directrices Atributos
    public Integer indiceActualDirectrices{set;get;}
    public Integer totalIndicesDirectrices{set;get;}
    public Map<Integer,List<DirectrizTelcel__c>> mapaIndexacionDirectrices;
    public List<DirectrizTelcel__c> totalElementosDirectrices;
    public List<DirectrizTelcel__c> elementosAMostrarDirectrices{set;get;}
    // Fin Directrices Atributos
    
    
    public SeguimientoOportunidadListasExtension(ApexPages.StandardController standardController)
    {
        String idControlador = standardController.getId();
        
        //Operaciones Soportes
        indiceActualSoportes = 1;
        totalElementosSoportes = new List<SoportedentroTelcel__c>();    
        mapaIndexacionSoportes = new Map<Integer,List<SoportedentroTelcel__c>>();
        totalElementosSoportes = Database.query('SELECT '+String.join(new List<String>(SObjectType.SoportedentroTelcel__c.fields.getMap().keySet()),', ')+' FROM SoportedentroTelcel__c WHERE SeguimientoOportunidad__c = \''+idControlador+'\''+ 'order by CreatedDate DESC' );
        for(Integer i=0; i<totalElementosSoportes.size(); i++)
        {
            if(!mapaIndexacionSoportes.containsKey(((i/5)+1)))
            {
                mapaIndexacionSoportes.put(((i/5)+1),new List<SoportedentroTelcel__c>());
            }
            
            mapaIndexacionSoportes.get(((i/5)+1)).add(totalElementosSoportes[i]);
        }
        totalIndicesSoportes = mapaIndexacionSoportes.keySet().size();
        elementosAMostrarSoportes = (mapaIndexacionSoportes.containsKey(indiceActualSoportes))?mapaIndexacionSoportes.get(indiceActualSoportes):new List<SoportedentroTelcel__c>();
        // Fin Operaciones Soportes
        
        //Operaciones Directrices
        indiceActualDirectrices = 1;
        totalElementosDirectrices = new List<DirectrizTelcel__c>();    
        mapaIndexacionDirectrices = new Map<Integer,List<DirectrizTelcel__c>>();
        totalElementosDirectrices = Database.query('SELECT '+String.join(new List<String>(SObjectType.DirectrizTelcel__c.fields.getMap().keySet()),', ')+' FROM DirectrizTelcel__c WHERE SeguimientoOportunid__c = \''+idControlador+'\'' + 'order by CreatedDate DESC');
        for(Integer i=0; i<totalElementosDirectrices.size(); i++)
        {
            if(!mapaIndexacionDirectrices.containsKey(((i/5)+1)))
            {
                mapaIndexacionDirectrices.put(((i/5)+1),new List<DirectrizTelcel__c>());
            }
            
            mapaIndexacionDirectrices.get(((i/5)+1)).add(totalElementosDirectrices[i]);
        }
        totalIndicesDirectrices = mapaIndexacionDirectrices.keySet().size();
        elementosAMostrarDirectrices = (mapaIndexacionDirectrices.containsKey(indiceActualDirectrices))?mapaIndexacionDirectrices.get(indiceActualDirectrices):new List<DirectrizTelcel__c>();
        // Fin Operaciones Directrices
        
    }

    //Método Siguiente Soportes
    public void anteriorSoportes()
    {
        indiceActualSoportes-=1;
        elementosAMostrarSoportes = mapaIndexacionSoportes.get(indiceActualSoportes);
    }
    //Fin Método Siguiente Soportes
    
    //Método Anterior Soportes
    public void siguienteSoportes()
    {
        indiceActualSoportes+=1;
        elementosAMostrarSoportes = mapaIndexacionSoportes.get(indiceActualSoportes);
    }
    //Fin Método Anterior Soportes
    
    //Método Siguiente Directrices
    public void anteriorDirectrices()
    {
        indiceActualDirectrices-=1;
        elementosAMostrarDirectrices = mapaIndexacionDirectrices.get(indiceActualDirectrices);
    }
    //Fin Método Siguiente Directrices
    
    //Método Anterior Directrices
    public void siguienteDirectrices()
    {
        indiceActualDirectrices+=1;
        elementosAMostrarDirectrices = mapaIndexacionDirectrices.get(indiceActualDirectrices);
    }
    //Fin Método Anterior Directrices
}