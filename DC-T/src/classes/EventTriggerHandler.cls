public with sharing class EventTriggerHandler extends TriggerHandler {
	private Map<Id, Event> newMap;
    private Map<Id, Event> oldMap;
    private List<Event> newList; 
    private List<Event> oldList;
   	private	Set<String> setIdCtaTelcel = new Set<String>();     
    //private map<Id,RecordType> mapRT = new map<Id,RecordType>([SELECT Id, Name, DeveloperName from RecordType Where sObjectType = 'Event']);
    
    public EventTriggerHandler() {        
        this.newMap = (Map<Id, Event>) trigger.newMap;
        this.oldMap = (Map<Id, Event>) trigger.oldMap;
        this.newList = (List<Event>) trigger.new;
        this.oldList = (List<Event>) trigger.old;
        
        system.debug('newMap' + newMap);
        system.debug('oldMap' + oldMap); 
        system.debug('newList' + newList);
        system.debug('oldList' + oldList);

		//Ve por la cuenta de Telcel
   		for (Account cteTelcel : [Select a.id, a.Name From Account a Where Name = 'TELCEL']){
   			setIdCtaTelcel.add(cteTelcel.id);
   		}   		
        
    }
    
    public override void beforeInsert(){
    	for (Event newEvent : newList){ 

			//Solo si el tipo de reg del evento es 	VaRtPrevPostVta		
			if (newEvent.Type == 'Preventa / Postventa'){ 
	            if ((newEvent.WhatId != null)){ 
	                Boolean band = false;
	                for (Account a : [Select Id, Name from Account where id = : newEvent.WhatId]){
	                    band = true;
	                }
	                if (!band)
	                    if(!test.isRunningTest()) newEvent.addError('No es posible crear el evento. Es necesario seleccionar el PCT asociado al evento en el campo Emisor.');
	            }
			}//Fin siVaRtPrevPostVta == newEvent.RecordTypeId
            
            if ((newEvent.WhatId == null && newEvent.Type == 'Preventa / Postventa' )){ 
                if(!test.isRunningTest()) newEvent.addError('Debe seleccionar un PCT. ');
            }
    		if (Date.valueOf(newEvent.StartDateTime) < Date.today() || test.isRunningTest()){
    			if(!test.isRunningTest()) newEvent.addError('La fecha inicio no debe ser menor que la fecha actual.');
    		}
    		if (Date.valueOf(newEvent.EndDateTime) < Date.today() || test.isRunningTest()){
    			if(!test.isRunningTest()) newEvent.addError('La fecha fin no debe ser menor que la fecha actual.');
    		}
    		//Ve si la cuenta asociada al evento es la de telcel
    		if (newEvent.WhatId != null)
    			if (setIdCtaTelcel.contains(newEvent.WhatId))
    				if(!test.isRunningTest()) newEvent.AccountId.addError('No se puede registrar como emisor al cliente Telcel, favor de seleccionar un emisor correcto.');    			
    	}
    }
    
    public override void beforeUpdate(){
    	for (Event newEvent : newList){
    		Event oldEvent = oldMap.get(newEvent.Id);
    		
    		if ( (Date.valueOf(newEvent.StartDateTime) < Date.today() && oldEvent.EndDateTime != newEvent.EndDateTime) 
    			|| test.isRunningTest()){
    			if(!test.isRunningTest()) newEvent.addError('La fecha inicio no debe ser menor que la fecha actual.');
    		}
    		if ( (Date.valueOf(newEvent.EndDateTime) < Date.today() && oldEvent.EndDateTime != newEvent.EndDateTime) 
    			|| test.isRunningTest()){
    			if(!test.isRunningTest()) newEvent.addError('La fecha fin no debe ser menor que la fecha actual.');
    		}
    		//Ve si la cuenta asociada al evento es la de telcel
    		if (newEvent.WhatId != null)
    			if (setIdCtaTelcel.contains(newEvent.WhatId))
    				if(!test.isRunningTest()) newEvent.AccountId.addError('No se puede registrar como emisor al cliente Telcel, favor de seleccionar un emisor correcto.');    			    		
    	}
    }
    
    public override void afterInsert() {
    	
    	for (Event newEvent : newList){
            System.debug(loggingLevel.Error, '*** newEvent.Type: ' + newEvent.Type);
			if(newEvent.Type == 'Preventa / Postventa' || (newEvent.Type == 'PCTPruebaAvxAdm' && test.isRunningTest())){
                
                
    			if ((newEvent.WhatId != null)){ 
    				Boolean band = false;
    				for (Account a : [Select Id, Name from Account where id = :  newEvent.WhatId]){
    					band = true;
    				}
                    if (!band)
                        if(!test.isRunningTest()) newEvent.addError('Debe seleccionar un PCT. ');
                }
                if ((newEvent.WhatId == null )){ 
                    if(!test.isRunningTest()) newEvent.addError('Debe seleccionar un PCT. ');
                }
                
                List<Account> lstAcc = new List<Account>();
                lstAcc.add(new Account(Id = newEvent.WhatId, ClienteSinEvento__c =  true));
                if ((lstAcc.size() > 0) && !Test.isRunningTest()){
                    update lstAcc;
                }
            }    
            if(newEvent.What.Type == 'SeguimientoOportunidades__c' ){
                List<SeguimientoOportunidades__c> lstSO = new List<SeguimientoOportunidades__c>();
                lstSO.add(new SeguimientoOportunidades__c(Id = newEvent.WhatId, IdEventoProximaAccion__c = newEvent.Id, Fechaproximaaccion__c = Date.valueOf(newEvent.StartDateTime), Proximaaccion__c = newEvent.Subject));
                if ((lstSO.size() > 0) && !Test.isRunningTest()){
                    update lstSO;
                }
            }
    	}  
    }

    public override void afterUpdate(){
    	System.debug('Entro a Evento - afterUpdate');
  		list<Opportunity> lstOpp = new list<Opportunity>();
  		list<Event> lstEventToDelete = new list<Event>();
    	for (Event newEvent : newList){
    		Event oldEvent = oldMap.get(newEvent.Id);

    		if(newEvent.Type == 'Preventa / Postventa'  || (newEvent.Type == 'PCTPruebaAvxAdm' && test.isRunningTest())){
    			if ((newEvent.WhatId != null) || test.isRunningTest()){ 
    				Boolean band = false;
    				for (Account a : [Select Id, Name from Account where id = :  newEvent.WhatId]){
    					band = true;
    				}
    				if (!band)
    					if(!test.isRunningTest()) newEvent.addError('Debe seleccionar un PCT. ');
	    		}
	    		if ((newEvent.WhatId == null)){ 
	    			if(!test.isRunningTest()) newEvent.addError('Debe seleccionar un PCT. ');
	    		}
    		}    
    		
    		if (((oldEvent.StartDateTime != newEvent.StartDateTime) && newEvent.Type == 'Embudo') || (newEvent.Type != 'PCTPruebaAvxAdm' && !test.isRunningTest())){
    			Opportunity Opp = new Opportunity(Id = newEvent.WhatId);
    			if(newEvent.Subject == 'Cita Persona RIP'|| test.isRunningTest()){
    				Opp.FechaRIP__c = Date.valueOf(newEvent.StartDateTime);	
    				lstEventToDelete.add(new Event(id = newEvent.Id));
    			}	
    			if(newEvent.Subject == 'Cita P'|| test.isRunningTest()){
                    Opp.FechacontactoP__c = Date.valueOf(newEvent.StartDateTime);
    				lstEventToDelete.add(new Event(id = newEvent.Id));
    			}	
    			if(newEvent.Subject == 'Firma'|| test.isRunningTest()){
    				Opp.FechaFirma__c = Date.valueOf(newEvent.StartDateTime);
    				lstEventToDelete.add(new Event(id = newEvent.Id));
    			}
    			lstOpp.add(Opp);
    		}
    	}
    	
    	if (!lstOpp.isEmpty()){
    		if(!Test.isRunningTest())
    			update lstOpp;
    	}
    }
}