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
public class DirectrizTelcel_trigger_cls {
	
	
	public static void buscarUsuarios(List<directrizTelcel__c> lstDirectrizTelcel)
	{
		//Map<String,List<directrizTelcel__c>> mapidDTSOXDirectrizTelcel= new Map<String, directrizTelcel__c>();
		Set<String> setIdsSeguimientoOport=new Set<String>();
		Set<String> setIdsCreatedUser=new Set<String>();
		for(directrizTelcel__c objDirectriz:lstDirectrizTelcel)
		{
			if(!setIdsSeguimientoOport.contains(objDirectriz.SeguimientoOportunid__c) || test.isRunningTest())
			{
				//if (!test.isRunningTest())
					setIdsSeguimientoOport.add(objDirectriz.SeguimientoOportunid__c);
				/*else{
					Account 								Cliente					= DataGenerator_cls.createAccount(true, 'Cliente Test', 'Corporativo', '');
					Contact 								Contacto 				= DataGenerator_cls.createContacto(true, Cliente.Id, 'CC01', 'DD01');
					Opportunity 							Opp 					= DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
					SeguimientoOportunidades__c objSO = DataGenerator_cls.createSeguimientoOportunidad( false, Opp );
					setIdsSeguimientoOport.add(objSO.Id);
				}*/
					
			}
			if(!setIdsCreatedUser.contains(objDirectriz.createdbyid) || test.isRunningTest())
			{
				//if (!test.isRunningTest())
					setIdsCreatedUser.add(objDirectriz.createdbyid);
				/*else{
					setIdsCreatedUser.add(userInfo.getUserId());
				}*/
					
			}

		}
		Map<id,SeguimientoOportunidades__c> mapIdXSeguimientoOport=new Map<Id,SeguimientoOportunidades__c>(
				[Select id, Embudo__c, Embudo__r.ownerId, Embudo__r.owner.managerID, Embudo__r.owner.manager.managerID 
				 from SeguimientoOportunidades__c 
				 where id=:setIdsSeguimientoOport]

			);

		Map<Id,User> mapIdXuser=new Map<Id,User>(
			   [Select id, userRoleid, userRole.name,UserRole.DeveloperName
			    from User
			    where id=:userInfo.getUserId()]
			);

		for(directrizTelcel__c objDirectriz:lstDirectrizTelcel)
		{
			SeguimientoOportunidades__c objSeguimiento=mapIdXSeguimientoOport.get(objDirectriz.SeguimientoOportunid__c);
			User objUser=mapIdXuser.get(userInfo.getUserId());
			if(objUser.userRoleId!=null&&objUser.userRole.developername.contains('GV'))
			{
				objDirectriz.Usuario_JEC__c=objSeguimiento.Embudo__r.ownerId;

			}
			if(objUser.userRoleId!=null&&objUser.userRole.developername=='SD')
			{
				objDirectriz.Usuario_JEC__c=objSeguimiento.Embudo__r.ownerId;
				objDirectriz.Usuario_GV__c=objSeguimiento.Embudo__r.owner.managerID;

			}
			if(objUser.userRoleId!=null&&objUser.userRole.developername=='DR9')
			{
				objDirectriz.Usuario_JEC__c=objSeguimiento.Embudo__r.ownerId;
				objDirectriz.Usuario_GV__c=objSeguimiento.Embudo__r.owner.managerID;
				objDirectriz.Usuario_SD__c=objSeguimiento.Embudo__r.owner.manager.managerID;

			}
		}
	}
}