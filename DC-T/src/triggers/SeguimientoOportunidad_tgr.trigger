trigger SeguimientoOportunidad_tgr on SeguimientoOportunidades__c (before insert, after insert,
	before update, after update)
{
	if( trigger.isBefore )
	{
		if( trigger.isInsert )
		{
			//SeguimientoOportunidad_cls.createControlAlarma2( trigger.new );
		}
		else if( trigger.isUpdate )
		{
			SeguimientoOportunidad_cls.createControlAlarma2( trigger.new );

			//SAO - Disparar Crear Alarma de seguimiento de oportunidades
			List<SeguimientoOportunidades__c> lstSeguimientoOpp = new List<SeguimientoOportunidades__c>();
        	for(Integer i=0; i<trigger.new.size(); i++){
	        	if(trigger.new[i].AlarmaOportunidad__c != trigger.old[i].AlarmaOportunidad__c)
						lstSeguimientoOpp.add(trigger.new[i]);
          	}
            if(!lstSeguimientoOpp.isEmpty()){
            	System.debug('@@-lstSeguimientoOpp->'+lstSeguimientoOpp);
				//cls.xxx(lstSeguimientoOpp);				
			}
		}
	}
    else if( trigger.isAfter )
    {
    	SeguimientoOportunidad_cls.createEvent( trigger.new, trigger.oldMap );
    	//SeguimientoOportunidad_cls.createControlAlarma( trigger.new );
    }
}