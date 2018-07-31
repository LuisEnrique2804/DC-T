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
trigger DirectrizTelcel_trigger_tgr on directrizTelcel__c (before insert) {

	if(trigger.isBefore&&trigger.isInsert)
	{
		DirectrizTelcel_trigger_cls.buscarUsuarios(trigger.new);
	}

}