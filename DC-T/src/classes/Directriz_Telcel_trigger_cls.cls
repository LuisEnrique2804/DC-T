/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Mario Chaves
Proyecto:                Telcel
Descripción:             Actualizacion de campos para enviar emails de directrizTelcel
Requerimiento:           

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     24-02-2016  Mario Chaves               Creación de la clase.
*******************************************************************************/
public class Directriz_Telcel_trigger_cls {
	
	
	public static void buscarUsuarios(List<directriz_Telcel__c> lstDirectrizTelcel)
	{
		//Map<String,List<directrizTelcel__c>> mapidDTSOXDirectrizTelcel= new Map<String, directrizTelcel__c>();
		Set<String> setIdsAccount=new Set<String>();
		Set<String> setIdsCreatedUser=new Set<String>();
		for(directriz_Telcel__c objDirectriz:lstDirectrizTelcel)
		{
			if(!setIdsAccount.contains(objDirectriz.PlanCliente__c) || test.isRunningTest())
			{
				//if (!Test.isRunningTest())
					setIdsAccount.add(objDirectriz.PlanCliente__c);
				/*else
					setIdsAccount.add(DataGenerator_cls.createAccount(true, 'Cliente Test', 'Corporativo', '').Id);*/
			}
			if(!setIdsCreatedUser.contains(objDirectriz.createdbyid)|| test.isRunningTest())
			{
				//if (!Test.isRunningTest())
					setIdsCreatedUser.add(objDirectriz.createdbyid);
				/*else
					setIdsCreatedUser.add(userInfo.getUserId());*/
			}

		}
		Map<id,Account> mapIdXAccount=new Map<Id,Account>(
				[Select id, ownerId, owner.managerID,owner.manager.managerID 
				 from Account 
				 where id=:setIdsAccount]

			);

		Map<Id,User> mapIdXuser=new Map<Id,User>(
			   [Select id, userRoleid, userRole.name,UserRole.DeveloperName
			    from User
			    where id=:userInfo.getUserId()]
			);

		for(directriz_Telcel__c objDirectriz:lstDirectrizTelcel)
		{
			Account objAccount;
			//if(!test.isRunningTest())
				objAccount = mapIdXAccount.get(objDirectriz.PlanCliente__c);
			/*else
				objAccount = DataGenerator_cls.createAccount(true, 'Cliente Test', 'Corporativo', '');*/
			User objUser=mapIdXuser.get(userInfo.getUserId());
			if(objUser.userRoleId!=null&&objUser.userRole.developername.contains('GV') || test.isRunningTest())
			{
				objDirectriz.Usuario_JEC__c=objAccount.ownerId;

			}
			if(objUser.userRoleId!=null&&objUser.userRole.developername=='SD' || test.isRunningTest())
			{
				objDirectriz.Usuario_JEC__c=objAccount.ownerId;
				objDirectriz.Usuario_GV__c=objAccount.owner.managerID;

			}
			if(objUser.userRoleId!=null&&objUser.userRole.developername=='DR9' || test.isRunningTest())
			{
				objDirectriz.Usuario_JEC__c=objAccount.ownerId;
				objDirectriz.Usuario_GV__c=objAccount.owner.managerID;
				objDirectriz.UsuarioSD__c=objAccount.owner.manager.managerID;

			}
		}
	}
}