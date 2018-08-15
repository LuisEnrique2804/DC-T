public with sharing class CompetidoresPlataformasTriggerHandler extends TriggerHandler {
	
	/*private Map<Id, CatalgoCompetidoresPlataformas__c> newMap;
    private Map<Id, CatalgoCompetidoresPlataformas__c> oldMap;
    private List<CatalgoCompetidoresPlataformas__c> newList;
    private List<CatalgoCompetidoresPlataformas__c> oldList;
    
    public CompetidoresPlataformasTriggerHandler() {
        this.newMap = (Map<Id, CatalgoCompetidoresPlataformas__c>) trigger.newMap;
        this.oldMap = (Map<Id, CatalgoCompetidoresPlataformas__c>) trigger.oldMap;
        this.newList = (List<CatalgoCompetidoresPlataformas__c>) trigger.new;
        this.oldList = (List<CatalgoCompetidoresPlataformas__c>) trigger.old;
    }
    
	public override void beforeDelete(){}

    public override void beforeInsert(){}
    
    public override void beforeUpdate(){}
    
    public override void afterDelete() {}

	public override void afterInsert() {
		set<Id> setSerTrad = new set<Id>();
		set<String> setPlataformas = new set<String>();
		list<CompetidoresPlataformas__c> lstCompPlat = new list<CompetidoresPlataformas__c>();
		
		map<Id, CatalogoServiciosTradicionales__c> mapServTradPadres = new map<Id, CatalogoServiciosTradicionales__c>();
		
		for(CatalgoCompetidoresPlataformas__c newEntity : newList){
			setSerTrad.add(newEntity.CatalogoServiciosTradicionales__c); 
		}
		
		mapServTradPadres = new map<Id, CatalogoServiciosTradicionales__c>([Select Id, Name, PlataformaServiciosTradicionales__c, Activo__c From CatalogoServiciosTradicionales__c Where Id in: setSerTrad and Activo__c = true]);
		system.debug('mapServTradPadres: ' + mapServTradPadres);
		
		//CompetidoresPlataformas__c
		for(CatalogoServiciosTradicionales__c cst : mapServTradPadres.Values()){
			try { setPlataformas.add(cst.PlataformaServiciosTradicionales__c); } catch (Exception ex) { }
		}
		
		map<Id, ServiciosTradicionales__c> mapST = new map<id,ServiciosTradicionales__c>([Select Id,Name,Plataforma__c from ServiciosTradicionales__c Where Plataforma__c in: setPlataformas]);
		system.debug('mapST: ' + mapST); 
		CompetidoresPlataformas__c objCP = new CompetidoresPlataformas__c();		
		CatalogoServiciosTradicionales__c objCST = new CatalogoServiciosTradicionales__c();
		
		for(CatalgoCompetidoresPlataformas__c newEntity : newList){
			
			objCST = mapServTradPadres.get(newEntity.CatalogoServiciosTradicionales__c);
			
			for (ServiciosTradicionales__c st : mapST.Values()){
				
				if(objCST.PlataformaServiciosTradicionales__c == st.Plataforma__c){
					
					objCP = new CompetidoresPlataformas__c();
					objCP.ServiciosTradicionales__c = st.Id;
					objCP.Name = newEntity.Name;
					lstCompPlat.add(objCP); 
		
				}
				
			}
			
		}
		
		if (lstCompPlat.size() > 0){
			insert lstCompPlat;
		}
		
	}
	
	public override void afterUndelete() {}
    
    public override void afterUpdate(){}*/
    
}