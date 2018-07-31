trigger InvServiciosTicFact on InversionServicioTICFacturacion__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	
	 
	
	list<InversionServicioTICFacturacion__c> lstUpISTF = new list<InversionServicioTICFacturacion__c>();
	set<Id> idMapas = new set<Id>();
	set<Id> idSer = new set<Id>();
	map<id, MapaCliente__c> mapMapCliente;
	map<id, InversionServicioTICFacturacion__c> mapISTF; 
	list<InversionServicioTICFacturacion__c> lstISTF;
	map<Id,InversionServicioTICFacturacion__c> sId;
	
	if(trigger.isBefore && trigger.isInsert){
		idMapas = new set<Id>();
		idSer = new set<Id>();

		for (InversionServicioTICFacturacion__c newEntity : trigger.new){
			idMapas.add(newEntity.MapaCliente__c);
			idSer.add(newEntity.Id);
		}
		
		mapMapCliente = new map<id, MapaCliente__c>([Select Id, Name, PlanCliente__c from MapaCliente__c Where Id in :idMapas]);
		for (InversionServicioTICFacturacion__c newEntity : trigger.new){
			MapaCliente__c Mapa = mapMapCliente.get(newEntity.MapaCliente__c);
			newEntity.PlanCliente__c = Mapa.PlanCliente__c;
		}
		
		for (InversionServicioTICFacturacion__c newEntity : trigger.new){
			idMapas.add(newEntity.MapaCliente__c);
			idSer.add(newEntity.Id);
		}
	}
	
	if(trigger.isBefore && trigger.isUpdate){
		
		for (InversionServicioTICFacturacion__c newEntity : trigger.new){
			idMapas.add(newEntity.MapaCliente__c);
			idSer.add(newEntity.Id);
		}
		
		mapMapCliente = new map<id, MapaCliente__c>([Select Id, Name, PlanCliente__c from MapaCliente__c Where Id in :idMapas]);
		mapISTF = new map<id, InversionServicioTICFacturacion__c>([SELECT CompetenciaTelcel__c,FactTelcel__c,GastoTIC__c,Id,InversionClienteCalculo__c,InversionCliente__c,Llave_unica__c,MapaCliente__c,Name,PlanCliente__c,PlataformasTIC__c,PorcentajeTelcel__c,ProductosServiciosSolucionesTelcel__c,SumaInversionCliente__c FROM InversionServicioTICFacturacion__c  Where MapaCliente__c =: idMapas and Id not in: idSer]);
		lstISTF = new list<InversionServicioTICFacturacion__c>();
		lstUpISTF = new list<InversionServicioTICFacturacion__c>();
		for (InversionServicioTICFacturacion__c newEntity : trigger.new){
			InversionServicioTICFacturacion__c oldEntity = trigger.oldMap.get(newEntity.Id); 
			MapaCliente__c Mapa = mapMapCliente.get(newEntity.MapaCliente__c);
			
			if(InversionServicioTICFacturacionFuture.Estatus == 0 && newEntity.InversionCliente__c != 0 && newEntity.InversionCliente__c != null) 
				newEntity.InversionClienteCalculo__c = newEntity.InversionCliente__c;
			
			for (InversionServicioTICFacturacion__c r : mapISTF.Values()){
				if (r.MapaCliente__c == mapa.Id){
					if (r.PlataformasTIC__c == newEntity.PlataformasTIC__c){
						if (r.InversionCliente__c != null && r.InversionCliente__c != 0 && newEntity.InversionCliente__c != null && newEntity.InversionCliente__c != 0 && InversionServicioTICFacturacionFuture.Estatus == 0){
							newEntity.addError('Ya existen registros con valor Inversión del Cliente. ');
						}
						//if (r.CompetenciaTelcel__c != null && InversionServicioTICFacturacionFuture.Estatus == 0){
						if (r.CompetenciaTelcel__c != null && newEntity.CompetenciaTelcel__c != null && InversionServicioTICFacturacionFuture.Estatus == 0){
							newEntity.addError('Ya existen registros con valor Proveedor Principal. ');
						}
					}
				}
			}
		}
		
	}
	
	if(trigger.isAfter && trigger.isUpdate){
		if(InversionServicioTICFacturacionFuture.Estatus == 0){
			idMapas = new set<Id>();
			idSer = new set<Id>();
			for (InversionServicioTICFacturacion__c newEntity : trigger.new){
				idMapas.add(newEntity.MapaCliente__c);
				idSer.add(newEntity.Id);
			}
			
			mapMapCliente = new map<id, MapaCliente__c>([Select Id, Name, PlanCliente__c from MapaCliente__c Where Id in :idMapas]);
			
			lstISTF = new list<InversionServicioTICFacturacion__c>();
			lstUpISTF = new list<InversionServicioTICFacturacion__c>();
			sId = new map<Id,InversionServicioTICFacturacion__c>();
			for (InversionServicioTICFacturacion__c newEntity : trigger.new){
				InversionServicioTICFacturacion__c oldEntity = trigger.oldMap.get(newEntity.Id); 
				
				mapISTF = new map<id, InversionServicioTICFacturacion__c>([SELECT Id,InversionClienteCalculo__c,InversionCliente__c,PlataformasTIC__c, MapaCliente__c FROM InversionServicioTICFacturacion__c  Where MapaCliente__c =: newEntity.MapaCliente__c and PlataformasTIC__c = :newEntity.PlataformasTIC__c and Id <>: newEntity.Id and InversionCliente__c = null and CompetenciaTelcel__c = null]);

				MapaCliente__c Mapa = mapMapCliente.get(newEntity.MapaCliente__c);

				for (InversionServicioTICFacturacion__c r : mapISTF.Values()){
					//if((r.InversionCliente__c == 0) && newEntity.CompetenciaTelcel__c == null){
						InversionServicioTICFacturacion__c obj = new InversionServicioTICFacturacion__c();
						obj.id = r.Id;
						obj.InversionClienteCalculo__c = newEntity.InversionCliente__c;
						//obj.InversionCliente__c = 0.00;//null;//newEntity.InversionCliente__c;
						lstUpISTF.add(obj);
					//}	
				}
			}
						
			system.debug('ListaActualizada: ' + lstUpISTF);
			
			if(lstUpISTF.size() > 0){				
				InversionServicioTICFacturacionFuture.Estatus = 1;
			    //List<database.UpsertResult> lstSR = 
			    DataBase.upsert(lstUpISTF);
			    //system.debug('SaveResultLst: ' + lstSR);
			    system.debug('Result Query: ' + [SELECT Id,InversionClienteCalculo__c,InversionCliente__c FROM InversionServicioTICFacturacion__c  Where MapaCliente__c =: idMapas and PlataformasTIC__c = 'Movilidad']);
			}
		}
	}
	
}