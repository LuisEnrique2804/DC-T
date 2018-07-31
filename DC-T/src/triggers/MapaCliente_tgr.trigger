/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Mario Chaves
Proyecto:                Telcel
Descripción:             Trigger para Mapa de cleinte
Requerimiento:           

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     10-03-2016  Mario Chaves               Creación de la clase.
*******************************************************************************/
trigger MapaCliente_tgr on MapaCliente__C (after insert, after update) {

	Boolean blnExecuteTrigger = true;

	if(trigger.isAfter){
		if (Trigger.isInsert)
			mapaCliente_CreacionAlarmas_cls.crearAlarmas(trigger.new);
		if (Trigger.isUpdate){
   			blnExecuteTrigger = !DCT_TriggerExecutionControl_cls.hasAlreadyBeenExecuted('MapaCliente_tgr');
			System.debug('EN AccountTriggerHandler.isAfter blnExecuteTrigger: ' + blnExecuteTrigger);
			if( blnExecuteTrigger )
				mapaCliente_CreacionAlarmas_cls.crearAlarmas(trigger.new);
		}//Fin si Trigger.isUpdate
	}//Fin si trigger.isAfter
		
}