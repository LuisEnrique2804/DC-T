public class SOExtension {
    public List<Attachment> lstAttach {get;set;}
    public List<Attachment> lstAttachShowed{set;get;}
    public Integer indexTotAttach{set;get;}
    public Integer indexActAttach{set;get;}
    public Map<Integer,List<Attachment>> mapAttach;
    private Integer iMapSize = 5;
    
    //private final SeguimientoOportunidades__c thisSO;
    
    public SOExtension (ApexPages.StandardController ctrlrSO) {

        if(!Test.isRunningTest())ctrlrSO.addFields(new List<String>{'IdOportunidad__c'});
        SeguimientoOportunidades__c SO = (SeguimientoOportunidades__c) ctrlrSO.getRecord();
        
        indexActAttach = 1;   
        mapAttach = new Map<Integer,List<Attachment>>();
        
        lstAttach = [SELECT Description, ParentId, BodyLength, Name, ContentType, Id, LastModifiedDate, CreatedById FROM Attachment where ParentId = :SO.IdOportunidad__c];
        for(Integer i=0; i<lstAttach.size(); i++){
            
            if(!mapAttach.containsKey(((i/iMapSize)+1))){
                
                mapAttach.put(((i/iMapSize)+1),new List<Attachment>());
            }
            
            mapAttach.get(((i/iMapSize)+1)).add(lstAttach[i]);
        }
        
        indexTotAttach = mapAttach.keySet().size();
        lstAttachShowed = (mapAttach.containsKey(indexActAttach))? mapAttach.get(indexActAttach):new List<Attachment>();
        
    }
    
     public void antAtt(){
        indexActAttach-=1;
        lstAttachShowed = mapAttach.get(indexActAttach);
    }
    public void sigAtt(){
        indexActAttach+=1;
        lstAttachShowed = mapAttach.get(indexActAttach);
    }
    
}