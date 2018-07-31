public with sharing class InterlocutorTriggerHandler extends TriggerHandler {
	private Map<Id, Interlocutor__c> newMap;
    private Map<Id, Interlocutor__c> oldMap;
    private List<Interlocutor__c> newList;
    private List<Interlocutor__c> oldList;
    
    public InterlocutorTriggerHandler() {
        this.newMap = (Map<Id, Interlocutor__c>) trigger.newMap;
        this.oldMap = (Map<Id, Interlocutor__c>) trigger.oldMap;
        this.newList = (List<Interlocutor__c>) trigger.new;
        this.oldList = (List<Interlocutor__c>) trigger.old;
    }
    
	public override void beforeDelete(){}

    public override void beforeInsert(){}
    
    public override void beforeUpdate(){
    	for(Interlocutor__c forData : newList) {
    		
    		Interlocutor__c oldEntity = oldMap.get(forData.Id);
    		
    		if (oldEntity.Interlocutor__c != forData.Interlocutor__c && oldEntity.RelacionTelcel__c == forData.RelacionTelcel__c){
    			forData.RelacionTelcel__c = null;
    		}                                            
        }
    }
    
    public override void afterDelete() {}

	public override void afterInsert() {}
	
	public override void afterUndelete() {}
    
    public override void afterUpdate(){}
    
}