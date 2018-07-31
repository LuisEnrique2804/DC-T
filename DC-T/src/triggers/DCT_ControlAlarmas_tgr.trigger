trigger DCT_ControlAlarmas_tgr on ControlAlarmas__c (before update) {

	Boolean blnExecuteTrigger = true;
	String sPerfil = [Select u.Profile.Name, u.ProfileId From User u where u.ProfileId =:UserInfo.getProfileId() And id =: UserInfo.getUserId()].Profile.Name;
   	System.debug('EN DCT_ControlAlarmas_tgr sPerfil: ' + sPerfil);	

	//Se trata del evento before
   	if  (Trigger.isBefore ){
		//Se trata del evento update   		
    	if  (Trigger.isUpdate){
   			blnExecuteTrigger = !DCT_TriggerExecutionControl_cls.hasAlreadyBeenExecuted('DCT_ControlAlarmas_tgr');
			System.debug('EN AccountTriggerHandler.isAfter blnExecuteTrigger: ' + blnExecuteTrigger);
			if( blnExecuteTrigger ){	    		
				//Ve si esta cambiando el propietario
				for (id idPct : Trigger.newMap.KeySet()){
					//Ve si cambio el owner y fue alguin que no es el JEC
					if (Trigger.newMap.get(idPct).OwnerId != Trigger.oldMap.get(idPct).OwnerId && !sPerfil.startsWith('Administrador') )
						Trigger.newMap.get(idPct).OwnerId.AddError('No se puede cambiar el propietario, si requieres reasignarlo ponte en contacto con tu Gerente o con la Coordinación Administrativa.');
				}
			}//Fin si blnExecuteTrigger
    	}//Fin si Trigger.isUpdate 
   	}//Fin si Trigger.isBefore

}