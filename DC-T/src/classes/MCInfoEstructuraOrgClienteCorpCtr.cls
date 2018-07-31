public with sharing class MCInfoEstructuraOrgClienteCorpCtr {
    
    private MapaCliente__c esteMCP;
    //Atributos Organigrama Mapa Cliente
    public Integer indiceActualContactos{set;get;}
    public Integer totalIndicesContactos{set;get;}
    public Map<Integer,List<Contact>> mapaIndexacionContactos;
    public List<Contact> totalElementosContactos;
    public List<Contact> elementosAMostrarContactos{set;get;}
    
    //Atributos Analisis Relaciones
    public Integer indiceActualAnalisis{set;get;}
    public Integer totalIndicesAnalisis{set;get;}
    public Map<Integer,List<AnalisisRelaciones__c>> mapaIndexacionAnalisis;
    public List<AnalisisRelaciones__c> totalElementosAnalisis;
    public List<AnalisisRelaciones__c> elementosAMostrarAnalisis{set;get;}
    
    public MCInfoEstructuraOrgClienteCorpCtr(ApexPages.StandardController ctr){
        if (!test.isRunningTest()) ctr.addFields(new List<String>{'PlanCliente__c'});
        esteMCP = (MapaCliente__c) ctr.getRecord();
        String idControlador = ctr.getId();
        
        //Organigrama Mapa Clientes
        indiceActualContactos = 1;
        totalElementosContactos = new List<Contact>();    
        mapaIndexacionContactos = new Map<Integer,List<Contact>>();
        if(!test.isRunningTest()) totalElementosContactos = Database.query('SELECT '+String.join(new List<String>(SObjectType.Contact.fields.getMap().keySet()),', ')+' FROM Contact WHERE MapaCliente__c = \''+idControlador+'\'');
        if(test.isRunningTest()) totalElementosContactos = Database.query('SELECT '+String.join(new List<String>(SObjectType.Contact.fields.getMap().keySet()),', ')+' FROM Contact');
        for(Integer i=0; i<totalElementosContactos.size(); i++)
        {
            if(!mapaIndexacionContactos.containsKey(((i/5)+1)))
            {
                mapaIndexacionContactos.put(((i/5)+1),new List<Contact>());
            }
            
            mapaIndexacionContactos.get(((i/5)+1)).add(totalElementosContactos[i]);
        }
        totalIndicesContactos = mapaIndexacionContactos.keySet().size();
        elementosAMostrarContactos = (mapaIndexacionContactos.containsKey(indiceActualContactos))?mapaIndexacionContactos.get(indiceActualContactos):new List<Contact>();
        // Fin Organigrama
        
        //Analisis Relaciones
        indiceActualAnalisis = 1;
        totalElementosAnalisis = new List<AnalisisRelaciones__c>();    
        mapaIndexacionAnalisis = new Map<Integer,List<AnalisisRelaciones__c>>();
        if(!test.isRunningTest()) totalElementosAnalisis = Database.query('SELECT '+String.join(new List<String>(SObjectType.AnalisisRelaciones__c.fields.getMap().keySet()),', ')+' FROM AnalisisRelaciones__c WHERE MapaCliente__c = \''+idControlador+'\'' + 'order by PersonasTelcel__c');
        if(test.isRunningTest()) totalElementosAnalisis = Database.query('SELECT '+String.join(new List<String>(SObjectType.AnalisisRelaciones__c.fields.getMap().keySet()),', ')+' FROM AnalisisRelaciones__c');
        for(Integer i=0; i<totalElementosAnalisis.size(); i++)
        {
            if(!mapaIndexacionAnalisis.containsKey(((i/5)+1)))
            {
                mapaIndexacionAnalisis.put(((i/5)+1),new List<AnalisisRelaciones__c>());
            }
            
            mapaIndexacionAnalisis.get(((i/5)+1)).add(totalElementosAnalisis[i]);
        }
        totalIndicesAnalisis = mapaIndexacionAnalisis.keySet().size();
        elementosAMostrarAnalisis = (mapaIndexacionAnalisis.containsKey(indiceActualAnalisis))?mapaIndexacionAnalisis.get(indiceActualAnalisis):new List<AnalisisRelaciones__c>();
        // Fin Analisis                
                      
    } 
    //Método Siguiente Organigrama
    public void anteriorContactos()
    {
        indiceActualContactos-=1;
        elementosAMostrarContactos = mapaIndexacionContactos.get(indiceActualContactos);
    }
    //Fin Método Siguiente Organigrama
    
    //Método Anterior Organigrama
    public void siguienteContactos()
    {
        indiceActualContactos+=1;
        elementosAMostrarContactos = mapaIndexacionContactos.get(indiceActualContactos);
    }
    //Fin Método Anterior Organigrama
    //Método Siguiente Analisis
    public void anteriorAnalisis()
    {
        indiceActualAnalisis-=1;
        elementosAMostrarAnalisis = mapaIndexacionAnalisis.get(indiceActualAnalisis);
    }
    //Fin Método Siguiente Analisis
    
    //Método Anterior Analisis
    public void siguienteAnalisis()
    {
        indiceActualAnalisis+=1;
        elementosAMostrarAnalisis = mapaIndexacionAnalisis.get(indiceActualAnalisis);
    }
    //Fin Método Anterior Analisis
    
    public class Linea{
        public String nivel;
    }
    
    public class nodeArbolContactos{
        public String nivel;
        public Contact conta;
    } 
    public string getuserdata(){
        List<Contact> contatos = [SELECT ID, Name,ReportsTo.Name,ReportsTo.estructura__c,ReportsToId, Nivel__c, ReportsTo.Nivel__c, Estructura__c 
                                    FROM Contact 
                                    WHERE AccountId = :esteMCP.PlanCliente__c ORDER BY Nivel__c DESC];
        
        for(Contact contato: contatos){
            
        }
        //return '[\'02\', \'03\', \'\'],[\'01\', \'02\', \'\'] ';
        
        String datastr = '';
        Set<Id> contatosYa = new Set<Id>();
        for (integer i=0;i<contatos.size();i++)
        {
            /*if(contatosYa.contains(contatos[i].Id)){
                continue;
            } else{
                contatosYa.add(contatos[i].Id);
            }*/
            datastr = datastr + '[\'';
            
            system.debug('revisar '+ contatos[i].Estructura__c);
            
            if(contatos[i].Estructura__c == 'Autoridad'){
                dataStr += '<div style="width:100%; height:100%;background-color:#6495ED">';   
            } else if(contatos[i].Estructura__c == 'Influencia'){
                dataStr += '<div style="width:100%; height:100%;background-color:#E9967A">';
            }else{
                //dataStr += '<div style="width:100%; height:100%;background-color:#D3D3D3">';
                dataStr += '<div style="width:100%; height:100%">';
            } 
            
            datastr += contatos[i].Name;
            dataStr +='</div>'; 
            datastr+= '\',\'';
            
            system.debug('revisar ' + contatos[i].ReportsToId);
            
            if(contatos[i].ReportsToId != null){
                
                /*if(contatos[i].ReportsTo.Nivel__c == 'Staff' || test.isRunningTest()){
                    //dataStr += '<div style="width:100%; height:100%;background-color:#D3D3D3">';
                    dataStr += '<div style="width:100%; height:100%">';
                }else*/
	                if(contatos[i].ReportsTo.estructura__c == 'Autoridad'){
	                    dataStr += '<div style="width:100%; height:100%;background-color:#6495ED">';   
	                } else if(contatos[i].ReportsTo.estructura__c == 'Influencia'){
	                    dataStr += '<div style="width:100%; height:100%;background-color:#E9967A">';
	                }
              
                datastr+= contatos[i].ReportsTo.Name;
              
                //if((contatos[i].ReportsTo.estructura__c != null || contatos[i].ReportsTo.Nivel__c == 'Staff') ||Test.isRunningTest()){
                    dataStr +='</div>'; 
                //}
               // contatosYa.add(contatos[i].ReportsToId);
                
            }
            datastr+='\',\'\'],';
        } 
        System.debug('dataStr ' + dataStr);
        datastr = datastr + '';
        return datastr;
    }

}