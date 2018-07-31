global class DCT_AdminCartera_bch implements Database.Batchable<sObject>, Database.Stateful{

    global string query;
    
    //Un constructor por default
    global DCT_AdminCartera_bch(string query){
        this.query = query;
    }
    
    //Start
    global Database.querylocator start(Database.BatchableContext BC){
        System.debug('EN DCT_AdminCartera_bch.start query: ' + this.query);
        return Database.getQueryLocator(this.query);
    }
    
    //Execute
    global void execute(Database.BatchableContext BC, List<DCTClientsProspectstoAssigned__c> scope){
        System.debug('EN DCT_AdminCartera_bch.');
		
		//Crea la lista para poder eliminar los reg de ClientesPaso__c
		Map<String, DCTClientesReasignadosPaso__c> mapClientesPasoIns = new Map<String, DCTClientesReasignadosPaso__c>();
		
        //Recorre la lista de Casos para cerrarlos 
        for (DCTClientsProspectstoAssigned__c objDTCteProspAsig : scope){
        	String sRegistroPaso = '';
        	String sIdExterno = '';
        	String sSpacios = ' ';
        	String sConSpacios = ' ';
        	sRegistroPaso += (objDTCteProspAsig.AccountName__r.RFC__c != null ? objDTCteProspAsig.AccountName__r.RFC__c.rightPad(13, sSpacios) : sConSpacios.rightPad(13, sSpacios)) + ',';        	
	        System.debug('EN DCT_AdminCartera_bch objDTCteProspAsig.AccountName__r.RFC__c: ' + objDTCteProspAsig.AccountName__r.RFC__c);        	
        	sRegistroPaso += (objDTCteProspAsig.AccountName__r.Owner.DCTVT__c != null ? objDTCteProspAsig.AccountName__r.Owner.DCTVT__c.rightPad(9, sSpacios) : sConSpacios.rightPad(9, sSpacios)) + ',';        	
	        System.debug('EN DCT_AdminCartera_bch objDTCteProspAsig.AccountName__r.Owner.DCTVT__c: ' + objDTCteProspAsig.AccountName__r.Owner.DCTVT__c);
        	sRegistroPaso += (objDTCteProspAsig.IssuingUser__r.DCTXO__c != null ? objDTCteProspAsig.IssuingUser__r.DCTXO__c.rightPad(8, sSpacios) : sConSpacios.rightPad(8, sSpacios)) + ',';        	
	        System.debug('EN DCT_AdminCartera_bch objDTCteProspAsig.IssuingUser__r.DCTXO__c: ' + objDTCteProspAsig.IssuingUser__r.DCTXO__c);        	
        	sRegistroPaso += (objDTCteProspAsig.UserReceiver__r.DCTXO__c != null ? objDTCteProspAsig.UserReceiver__r.DCTXO__c.rightPad(8, sSpacios) : sConSpacios.rightPad(8, sSpacios));
	        System.debug('EN DCT_AdminCartera_bch objDTCteProspAsig.UserReceiver__r.DCTXO__c: ' + objDTCteProspAsig.UserReceiver__r.DCTXO__c);        	
	        System.debug('EN DCT_AdminCartera_bch sRegistroPaso: ' + sRegistroPaso);
	        sIdExterno = objDTCteProspAsig.AccountName__r.RFC__c + '-' + objDTCteProspAsig.UserReceiver__c + '-' + objDTCteProspAsig.IssuingUser__c + '-' + Date.today();
	        System.debug('EN DCT_AdminCartera_bch sIdExterno: ' + sIdExterno);	        
	        DCTClientesReasignadosPaso__c objDCTClientesReasignadosPaso = new DCTClientesReasignadosPaso__c(
        		IdExterno__c = sIdExterno,
        		Registro__c = sRegistroPaso,
        		FechaProceso__c = Date.today()
        	);
	        mapClientesPasoIns.put(sIdExterno, objDCTClientesReasignadosPaso);
        }//Fin del for para los reg que se estan creando
        
        System.debug('EN DCT_AdminCartera_bch mapClientesPasoIns: ' + mapClientesPasoIns);        
        //Ve si tiene algo la lista de mapClientesPasoIns
        if (!mapClientesPasoIns.isEmpty())
        	Upsert mapClientesPasoIns.values() DCTClientesReasignadosPaso__c.IdExterno__c;
        
    }
    
    //Finish
    global void finish(Database.BatchableContext BC){
        System.debug('EN DCT_AdminCartera_bch.finish Hora: ' + DateTime.now());      
    }


}