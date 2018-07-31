/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Mario Chaves
Proyecto:                Telcel
Descripción:             trigger para contacto
Requerimiento:           

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     06-03-2016  Mario Chaves               Creación de la clase.
*******************************************************************************/

trigger Contact_tgr on Contact (before insert, before update) {

	Boolean blnExecuteTrigger = true;
	String sPerfil = [Select u.Profile.Name, u.ProfileId From User u where u.ProfileId =:UserInfo.getProfileId() And id =: UserInfo.getUserId()].Profile.Name;
   	System.debug('EN Contact_tgr sPerfil: ' + sPerfil);	

	//Se trata del evento before
   	if  (Trigger.isBefore ){
		//Se trata del evento update   		
    	if  (Trigger.isUpdate){
   			blnExecuteTrigger = !DCT_TriggerExecutionControl_cls.hasAlreadyBeenExecuted('Contact_tgr');
			System.debug('EN Contact_tgr.isAfter blnExecuteTrigger: ' + blnExecuteTrigger);
			if( blnExecuteTrigger ){	    		
				//Ve si esta cambiando el propietario
				for (id idPct : Trigger.newMap.KeySet()){
					//Ve si cambio el owner y fue alguin que no es el JEC
					if (Trigger.newMap.get(idPct).OwnerId != Trigger.oldMap.get(idPct).OwnerId && !sPerfil.startsWith('Administrador') )
						Trigger.newMap.get(idPct).OwnerId.AddError('No se puede cambiar el propietario, si requieres reasignarlo ponte en contacto con tu Gerente o con la Coordinación Administrativa.');
					else
						Contact_ActualizarMapaCliente_Cls.updateMapaCliente(trigger.new);						
				}
			}//Fin si blnExecuteTrigger
    	}//Fin si Trigger.isUpdate 
   	}//Fin si Trigger.isBefore

}