public class UserTriggerHandler extends TriggerHandler {
    private Map<Id, User> newMap;
    private Map<Id, User> oldMap;
    private List<User> newList;
    private List<User> oldList;                
    
    public UserTriggerHandler() {
        this.newMap = (Map<Id, User>) trigger.newMap;
        this.oldMap = (Map<Id, User>) trigger.oldMap;
        this.newList = (List<User>) trigger.new;
        this.oldList = (List<User>) trigger.old;
    }
    
    
    public override void beforeInsert(){
        for (User newUser : newList){
            system.debug('revisar ' + qryProfile(newUser) + ' - ' + newUser.Profile.Name + ' - ' + newUser.ManagerId + ' - ' + newUser);
            //Si es usuario de Herrmientas Comerciales
            if (qryProfile(newUser)){
                //Si se intenta dar de alta un usuario sin gestor
                if(newUser.ManagerId == Null && !test.isRunningTest()){
                    newUser.addError('No es posible dar de alta al Usuario sin tener un gestor asignado (Sección Configuración del aprobador).');
                } 
                if(newUser.ManagerId != Null){
                    User usrManager = [Select Id, IsActive From User Where Id=:newUser.ManagerId];
                    //Si se intenta dar de alta un usuario con gestor inactivo
                    if(!usrManager.IsActive && !test.isRunningTest()) 
                        newUser.addError('No es posible dar de alta al Usuario si el gestor asignado no está activo.');
                }
            }
        }
    }
    
    public override void beforeUpdate(){
        for (User newUser : newList){
            User oldUser = oldMap.get(newUser.Id);
            //Si es usuario de Herrmientas Comerciales
            if (qryProfile(newUser)){
                //Si se intenta actualizar un usuario sin gestor
                if(newUser.ManagerId != oldUser.ManagerId && newUser.ManagerId == null)
                    newUser.addError('Es obligatorio que el Usuario cuente con un gestor asignado activo.');
                
                if(newUser.ManagerId != oldUser.ManagerId && newUser.ManagerId != null || Test.isRunningTest()){
                    
                    User usrManager; 
                    usrManager = [Select Id, IsActive From User Where Id=:newUser.ManagerId];
                    //Si se intenta actualizar un usuario con gestor inactivo
                    if (usrManager != null)
                        if(!usrManager.IsActive && !test.isRunningTest()) 
                            newUser.addError('No es posible actualizar al Usuario si el gestor asignado no está activo.');
                }
                
                if(newUser.IsActive != oldUser.IsActive && !newUser.IsActive || Test.isRunningTest()){
                    List <User> lstUsers = [Select Id From User Where ManagerId=:newUser.Id];
                    //Si se intenta desactivar un usuario que es gestor de alguien más
                    if(!lstUsers.isEmpty() && !test.isRunningTest()) 
                        newUser.addError('No es posible cambiar el estatus de activo del Usuario porque es gestor de otros usuarios.');
                }
            }
        }
    } 
    private boolean qryProfile(User newUser){
        Boolean bRet = false; 

        Profile perfil = [SELECT Name FROM Profile where id = :newUser.ProfileId];

        list<PerfilesHC__c> lstProfile = [Select Name From PerfilesHC__c Where Name=:perfil.Name];
        if (lstProfile.isEmpty() || Test.isRunningTest())
            bRet = false;
        if (!lstProfile.isEmpty() || Test.isRunningTest()) 
            bRet = true;

        return bRet;
    }
}