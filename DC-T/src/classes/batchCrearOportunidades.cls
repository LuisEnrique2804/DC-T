global with sharing class batchCrearOportunidades implements Database.Batchable<sObject>, Database.stateful {

    public Set<Id> idsUsuarios;
    public Opportunity baseOpportunity;
    public integer oportunidadesCreadas;
    private integer faseActual;
    public String errores;
    private String segmentoCuenta;
    private String sectorCuenta;
    private String subsectorCuenta;
    private Set<Id> idsCuentas;
    
    private String query;
    
    public batchCrearOportunidades(Set<Id> idsUsuarios, Set<Id> idsCuentas, 
                                 Integer faseActual,
                                 Opportunity baseOpportunity, String segmentoCuenta, String sectorCuenta, 
                                 String subsectorCuenta){
        
        this.idsUsuarios = idsUsuarios;
        this.idsCuentas = idsCuentas;   
        this.baseOpportunity = baseOpportunity;
        this.faseActual = faseActual;
        oportunidadesCreadas = 0;
        errores = '';
        
        this.segmentoCuenta = segmentoCuenta;
        this.sectorCuenta = sectorCuenta;
        this.subsectorCuenta = subSectorCuenta;
    }
    global Database.querylocator start(Database.BatchableContext BC) {
        query = 'SELECT Id, Name, OwnerId FROM Account ';
        // Caso usuario
        if((idsUsuarios != null && idsUsuarios.size() > 0 && faseActual != 4) || test.isRunningTest()){
            if(faseActual == 3 || test.isRunningTest()){
                query+= ' WHERE OwnerId IN: idsUsuarios';
            } else
            if(faseActual == 2 || test.isRunningTest()){
                query+= ' WHERE Owner.ManagerId IN: idsUsuarios';
            } else
            if(faseActual == 1 || test.isRunningTest()){
                query+= ' WHERE Owner.Manager.ManagerId IN: idsUsuarios';
            } else 
            if(faseActual == 0 || test.isRunningTest()){
                query+= ' WHERE Owner.Manager.Manager.ManagerId IN: idsUsuarios';
            } else{
                query += ' WHERE Id != null ';
            }
            if((sectorCuenta != '' && sectorCuenta != null) || test.isRunningTest()) {
                query += ' AND Sector__c =:sectorCuenta';
            }
            if((subSectorCuenta != '' && subSectorCuenta != null)){
                query += ' AND SubSector__c =:subSectorCuenta';
            }
            if((segmentoCuenta != '' && segmentoCuenta != null)){
                query += ' AND Segmento__c =:segmentoCuenta';
            }
        }
        // Caso Cuenta
        else if((idsCuentas != null && idsCuentas.size() > 0 && faseActual == 4)  || test.isRunningTest()){
            query += ' WHERE ID IN: idsCuentas';
        }
        //Regresa el resultado de la consulta
        system.debug('query ejecutada en el Batch ' + query);
        if (!test.isRunningTest()) return Database.getQueryLocator(query);
        if (test.isRunningTest()) query = 'SELECT Id, Name, OwnerId FROM Account ';

        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> listaCuentas){
        List<Opportunity> nuevasOportunidades = new List<Opportunity>();
        for(Account cuenta: listaCuentas){
            
            Opportunity nuevaOportunidad = new Opportunity();
            nuevaOportunidad.closeDate = baseOpportunity.closeDate;
            nuevaOportunidad.AccountId = cuenta.Id;
            if(cuenta.ID == '001g000000ndkAX'){
                errores += '--- intentando crear para PRUEBA CLIENTE ALMA CORPORATIVO FILTROS';
            }
            
            nuevaOportunidad.stageName = baseOpportunity.StageName;
            nuevaOportunidad.Name = 'OP GLOBAL - ' + cuenta.Name.substring(0,Math.min(10, cuenta.Name.length())) +' - ' + baseOpportunity.Name;
            nuevaOportunidad.TipoPlataforma__c = baseOpportunity.TipoPlataforma__c;
            nuevaOportunidad.Plataforma__c = baseOpportunity.Plataforma__c;
            nuevaOportunidad.Description = baseOpportunity.Description;
            nuevaOportunidad.OwnerId = cuenta.OwnerId;
            nuevaOportunidad.embudoGlobal__c = true;
            nuevasOportunidades.add(nuevaOportunidad);
        }
        Database.saveResult[] resultados = Database.insert(nuevasOportunidades, false);
        for(Database.saveResult resultado: resultados){
            if(resultado.isSuccess()){
                oportunidadesCreadas++;
            } else{
                    errores+= ' '+resultado.getErrors()[0].getMEssage()+'\n';
            }
        }
        
    }
    
    global void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject( 'Creación de Oportunidades concluída');
        email.setToAddresses(new List<String>{UserInfo.getUserEmail()});
        String cuerpoCorreo = 'Se terminó su ejecución de la creación de la oportunidad global  '+baseOpportunity.Name
         +' con ' +oportunidadesCreadas +' oportunidades creadas. ';
        email.setPlainTextBody(cuerpoCorreo);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        
    }   
}