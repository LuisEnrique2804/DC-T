public class DCT_CompetitorsTriggerHandler extends TriggerHandler {
	
	private Map<Id, DCTCompetitors__c> newMap;
    private Map<Id, DCTCompetitors__c> oldMap;
    private List<DCTCompetitors__c> newList;
    private List<DCTCompetitors__c> oldList;
    
    public DCT_CompetitorsTriggerHandler() {
        this.newMap = (Map<Id, DCTCompetitors__c>) trigger.newMap;
        this.oldMap = (Map<Id, DCTCompetitors__c>) trigger.oldMap;
        this.newList = (List<DCTCompetitors__c>) trigger.new;
        this.oldList = (List<DCTCompetitors__c>) trigger.old;
    }
    
	public override void beforeDelete(){}

    public override void beforeInsert(){}
    
    public override void beforeUpdate(){}
    
    public override void afterDelete() {}

	public override void afterInsert() {
		System.debug('EN DCT_CompetitorsTriggerHandler.afterInsert...');
		
		set<Id> setSerTrad = new set<Id>();
		set<String> setPlataformas = new set<String>();		
		Map<Id, CatalogoServiciosTradicionales__c> mapServTradPadres = new Map<Id, CatalogoServiciosTradicionales__c>();
		Set<String> setIdCompPlat = new Set<String>();
		
		//Ya no esta relacionado al catalogo de CatalogoServiciosTradicionales__c toma todo lo que tiene CatalogoServiciosTradicionales__c y que esta activo	
		mapServTradPadres = new Map<Id, CatalogoServiciosTradicionales__c>([Select Id, Name, PlataformaServiciosTradicionales__c, Activo__c From CatalogoServiciosTradicionales__c Where Activo__c = true]);
		System.debug('mapServTradPadres: ' + mapServTradPadres);
		
		//CompetidoresPlataformas__c
		for(CatalogoServiciosTradicionales__c cst : mapServTradPadres.Values()){
			try { 
				setPlataformas.add(cst.PlataformaServiciosTradicionales__c); 
			} catch (Exception ex) { }
		}
		
		Map<Id, ServiciosTradicionales__c> mapST = new Map<id,ServiciosTradicionales__c>([Select Id,Name,Plataforma__c from ServiciosTradicionales__c Where Plataforma__c in: setPlataformas]);
		System.debug('mapST: ' + mapST); 
		
		//Recorre la lista de reg del tipo DCTCompetitors__c
		for(DCTCompetitors__c newEntity : newList){
			//No hay relacion con el catalogo de CompetidoresPlataformas__c asi que recorre todos los reg de CatalogoServiciosTradicionales__c
			//objCST = mapServTradPadres.get(newEntity.CatalogoServiciosTradicionales__c);			
			for (CatalogoServiciosTradicionales__c objCST: mapServTradPadres.Values()){
				//Crea la lista del tipo  CompetidoresPlataformas__c
				List<CompetidoresPlataformas__c> lstCompPlat = new List<CompetidoresPlataformas__c>();
				//Recorre la lista de mapST
				for (ServiciosTradicionales__c st : mapST.Values()){
					if(objCST.PlataformaServiciosTradicionales__c == st.Plataforma__c){
						CompetidoresPlataformas__c objCP = new CompetidoresPlataformas__c();
						objCP.ServiciosTradicionales__c = st.Id;
						objCP.Name = newEntity.Name;
						objCP.DCTCompetitors__c = newEntity.id;
						lstCompPlat.add(objCP); 
					}//Fin si objCST.PlataformaServiciosTradicionales__c == st.Plataforma__c
				}//Fin del for para mapST.Values()

				//Ve si tiene algo para agregar la lista de lstCompPlat
				System.debug('EN DCT_CompetitorsTriggerHandler.afterInsert lstCompPlat: ' + lstCompPlat);
				if (lstCompPlat.size() > 0){
					List<Database.Saveresult> lObjDtsv = Database.insert(lstCompPlat, true);
					/*//mete los id a un set para que despues los elimines
					for (Database.Saveresult objDtsv : lObjDtsv){
						if (objDtsv.isSuccess())
							setIdCompPlat.add(objDtsv.getId());
					}
					//Ve si tiene algo el set de setIdCompPlat
					if (!setIdCompPlat.isEmpty()){
						List<Logs__c> lLogsIns = new List<Logs__c>();
						for (String sIdCompPlan : setIdCompPlat){
							lLogsIns.add(new Logs__c(
									NombreProceso__c = 'Creacion de Competidores',
									NombreSubpoceso__c = 'Creacion de Competidores Plataformas',								
									NombreObjeto__c = sIdCompPlan
								)
							);
						}//Fin del for para setIdCompPlat
						//Crea los registros en lLogsIns
						insert lLogsIns;
					}//Fin si !setIdCompPlat.isEmpty()*/
				}//Fin si lstCompPlat.size() > 0
				
			}//Fin del for para mapServTradPadres.Values()
		}//Fin del for para newList
		
	}
	
	public override void afterUndelete() {}
    
    public override void afterUpdate(){
		System.debug('EN DCT_CompetitorsTriggerHandler.afterInsert...');
		
		set<Id> setSerTrad = new set<Id>();
		set<String> setPlataformas = new set<String>();
		list<CompetidoresPlataformas__c> lstCompPlat = new list<CompetidoresPlataformas__c>();
		
		map<Id, CatalogoServiciosTradicionales__c> mapServTradPadres = new map<Id, CatalogoServiciosTradicionales__c>();
				
		//Ya no esta relacionado al catalogo de CatalogoServiciosTradicionales__c toma todo lo que tiene CatalogoServiciosTradicionales__c y que esta activo	
		mapServTradPadres = new map<Id, CatalogoServiciosTradicionales__c>([Select Id, Name, PlataformaServiciosTradicionales__c, Activo__c From CatalogoServiciosTradicionales__c Where Activo__c = true]);
		System.debug('mapServTradPadres: ' + mapServTradPadres);
		
		//CompetidoresPlataformas__c
		for(CatalogoServiciosTradicionales__c cst : mapServTradPadres.Values()){
			try { 
				setPlataformas.add(cst.PlataformaServiciosTradicionales__c); 
			} catch (Exception ex) { }
		}
		
		map<Id, ServiciosTradicionales__c> mapST = new map<id,ServiciosTradicionales__c>([Select Id,Name,Plataforma__c from ServiciosTradicionales__c Where Plataforma__c in: setPlataformas]);
		System.debug('mapST: ' + mapST); 
		
		/*//Recorre la lista de reg del tipo DCTCompetitors__c
		for(DCTCompetitors__c newEntity : newList){
			//No hay relacion con el catalogo de CompetidoresPlataformas__c asi que recorre todos los reg de CatalogoServiciosTradicionales__c
			//objCST = mapServTradPadres.get(newEntity.CatalogoServiciosTradicionales__c);			
			for (CatalogoServiciosTradicionales__c objCST: mapServTradPadres.Values()){
				//Recorre la lista de mapST
				for (ServiciosTradicionales__c st : mapST.Values()){
					if(objCST.PlataformaServiciosTradicionales__c == st.Plataforma__c){
						CompetidoresPlataformas__c objCP = new CompetidoresPlataformas__c();
						objCP.ServiciosTradicionales__c = st.Id;
						objCP.Name = newEntity.Name;
						objCP.DCTCompetitors__c = newEntity.id;
						lstCompPlat.add(objCP); 
					}//Fin si objCST.PlataformaServiciosTradicionales__c == st.Plataforma__c
				}//Fin del for para mapST.Values()
			}//Fin del for para mapServTradPadres.Values()
		}//Fin del for para newList
		
		//Ve si tiene algo para agregar la lista de lstCompPlat
		System.debug('EN DCT_CompetitorsTriggerHandler.afterInsert lstCompPlat: ' + lstCompPlat);
		if (lstCompPlat.size() > 0)
			insert lstCompPlat;*/
    	
    }
    
}