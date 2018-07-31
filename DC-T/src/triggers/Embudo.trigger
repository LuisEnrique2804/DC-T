trigger Embudo on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	String sPerfil = [Select u.Profile.Name, u.ProfileId From User u where u.ProfileId =:UserInfo.getProfileId() And id =: UserInfo.getUserId()].Profile.Name;
   	System.debug('EN Embudo sPerfil: ' + sPerfil);	
	
    System.debug(loggingLevel.Error, '*EN Embudo.hasAlreadyBeenExecuted(DCT_Opportunity): ' + DCT_TriggerExecutionControl_cls.hasAlreadyBeenExecuted('DCT_Opportunity'));
    if(!DCT_TriggerExecutionControl_cls.hasAlreadyBeenExecuted('DCT_Opportunity')){
    	if  (Trigger.isBefore ){
	    	if  (Trigger.isUpdate){
				//Ve si esta cambiando el propietario
				for (id idPct : Trigger.newMap.KeySet()){
					//Ve si cambio el owner y fue alguin que no es el JEC
					if (Trigger.newMap.get(idPct).OwnerId != Trigger.oldMap.get(idPct).OwnerId && !sPerfil.startsWith('Administrador') )
						Trigger.newMap.get(idPct).OwnerId.AddError('No se puede cambiar el propietario, si requieres reasignarlo ponte en contacto con tu Gerente o con la Coordinación Administrativa.');
					else
				    	new OpportunityTriggerHandler().run();					
				}
	    	}//Fin si Trigger.isUpdate 
    	}//Fin si Trigger.isBefore
    	if  (Trigger.isAfter)	    	
	    	new OpportunityTriggerHandler().run();    	
    }//Fin si !DCT_TriggerExecutionControl_cls.hasAlreadyBeenExecuted('DCT_Opportunity')
}