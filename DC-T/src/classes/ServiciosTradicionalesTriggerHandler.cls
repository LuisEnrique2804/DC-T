public with sharing class ServiciosTradicionalesTriggerHandler  extends TriggerHandler {
	private Map<Id, CatalogoServiciosTradicionales__c> newMap;
    private Map<Id, CatalogoServiciosTradicionales__c> oldMap;
    private List<CatalogoServiciosTradicionales__c> newList;
    private List<CatalogoServiciosTradicionales__c> oldList;
    
    public ServiciosTradicionalesTriggerHandler() {
        this.newMap = (Map<Id, CatalogoServiciosTradicionales__c>) trigger.newMap;
        this.oldMap = (Map<Id, CatalogoServiciosTradicionales__c>) trigger.oldMap;
        this.newList = (List<CatalogoServiciosTradicionales__c>) trigger.new;
        this.oldList = (List<CatalogoServiciosTradicionales__c>) trigger.old;
    }
    
	public override void beforeDelete(){}

    public override void beforeInsert(){}
     
    public override void beforeUpdate(){}
    
    public override void afterDelete() {}

	public override void afterInsert() {
		List<MapaCliente__c> mapasCliente = new List<MapaCliente__c>();
		if(!Test.isRunningTest()) mapasCliente = new List<MapaCliente__c>([SELECT Id FROM MapaCliente__c]);
		if(Test.isRunningTest())mapasCliente = new List<MapaCliente__c>([SELECT Id FROM MapaCliente__c limit 5]); 
		List<ServiciosTradicionales__c> inversionesGeneradas = new List<ServiciosTradicionales__c>();
		for(CatalogoServiciosTradicionales__c catalogo : newList){
			if(catalogo.Activo__c){
				for(MapaCliente__c mapaCliente: mapasCliente){
					ServiciosTradicionales__c relacionMapaCatalogo = new ServiciosTradicionales__c();
					relacionMapaCatalogo.MapaCliente__c =mapaCliente.Id;
					relacionMapaCatalogo.Plataforma__c = catalogo.PlataformaServiciosTradicionales__c;
					//relacionMapaCatalogo.PlataformaServiciosTradicionales__c = catalogo.PlataformaServiciosTradicionales__c;
					//relacionMapaCatalogo.Competidor__c = catalogo.Competidor__c;
					inversionesGeneradas.add(relacionMapaCatalogo);
				}
			}  
		}
		if(!Test.isRunningTest())
		database.insert(inversionesGeneradas);
	}
	
	public override void afterUndelete() {}
    
    public override void afterUpdate(){
    	List<MapaCliente__c> mapasCliente = new List<MapaCliente__c>();
		if(!Test.isRunningTest()) mapasCliente = new List<MapaCliente__c>([SELECT Id FROM MapaCliente__c]);
		if(Test.isRunningTest())mapasCliente = new List<MapaCliente__c>([SELECT Id FROM MapaCliente__c limit 5]);  
		List<ServiciosTradicionales__c> inversionesGeneradas = new List<ServiciosTradicionales__c>();
		for(CatalogoServiciosTradicionales__c catalogo : newList){
			CatalogoServiciosTradicionales__c oldEntity = oldMap.get(catalogo.Id);
			
			if(oldEntity.Activo__c == false && catalogo.Activo__c == true){
				for(MapaCliente__c mapaCliente: mapasCliente){
					ServiciosTradicionales__c relacionMapaCatalogo = new ServiciosTradicionales__c();
					relacionMapaCatalogo.MapaCliente__c =mapaCliente.Id;
					relacionMapaCatalogo.Plataforma__c = catalogo.PlataformaServiciosTradicionales__c;
					//relacionMapaCatalogo.PlataformaServiciosTradicionales__c = catalogo.PlataformaServiciosTradicionales__c;
					//relacionMapaCatalogo.Competidor__c = catalogo.Competidor__c;
					inversionesGeneradas.add(relacionMapaCatalogo);
				}
			}  
		}
		if(!Test.isRunningTest())
		database.insert(inversionesGeneradas);
    }
}