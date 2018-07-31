trigger DCT_AssignmentMain_tgr on DCTAssignment__c (before update, after update) {
	
	//Ve si se trata del evento Before
	if(Trigger.isBefore){
		if(Trigger.isUpdate){
			System.debug('EN DCT_AssignmentMain_tgr NEW before UPDATE...');			
			//Ve si no capturo nada en el campo segemento
			/*if (Trigger.newMap.get(Trigger.new.get(0).id).Segment__c == null && Trigger.newMap.get(Trigger.new.get(0).id).Status__c == 'Aprobado'
				&& Trigger.newMap.get(Trigger.new.get(0).id).TypeAssignment__c == 'Gerencia')
				Trigger.newMap.get(Trigger.new.get(0).id).Segment__c.addError('Debes de capturar el segmento cuando se trata de una Gerencia.');
			else*/
				DCT_AssignmentMethods_cls.performAssigmentIfApplies(Trigger.oldMap, Trigger.newMap);
		}//Fin si Trigger.isUpdate
	}//Fin Trigger.isBefore
	
	//Ve si se trata del evento after
	if (Trigger.isAfter){
		if(Trigger.isUpdate){
			//Recorre la lista de Trigger.new
			for (DCTAssignment__c objAsig : Trigger.new){
				System.debug('EN DCT_AssignmentMain_tgr NEW DCTProccesAprobed__c: ' + Trigger.oldMap.get(objAsig.id).DCTProccesAprobed__c + ' OLD DCTProccesAprobed__c: ' + Trigger.newMap.get(objAsig.id).DCTProccesAprobed__c + ' NEW Status__c: ' + objAsig.Status__c);
				if ( Trigger.oldMap.get(objAsig.id).DCTProccesAprobed__c != Trigger.newMap.get(objAsig.id).DCTProccesAprobed__c
						&& objAsig.DCTProccesAprobed__c != null ){
					System.debug('EN DCT_AssignmentMain_tgr SI PASO LA VALIDACIÓN NEW DCTProccesAprobed__c: ' + Trigger.oldMap.get(objAsig.id).DCTProccesAprobed__c + ' OLD DCTProccesAprobed__c: ' + Trigger.newMap.get(objAsig.id).DCTProccesAprobed__c + ' NEW Status__c: ' + objAsig.Status__c);						
					DCT_AssignmentMethods_cls.actCtasAproRech(objAsig.id, objAsig.DCTProccesAprobed__c);
				}else//Fin si objAsig.DCTProccesAprobed__c != null && objAsig.Status__c == nul					
					System.debug('EN DCT_AssignmentMain_tgr NO PASO LA VALIDACIÓN NEW DCTProccesAprobed__c: ' + Trigger.oldMap.get(objAsig.id).DCTProccesAprobed__c + ' OLD DCTProccesAprobed__c: ' + Trigger.newMap.get(objAsig.id).DCTProccesAprobed__c + ' NEW Status__c: ' + objAsig.Status__c);
			}//Fin del for para objAsig
		}//Fin si Trigger.isUpdate
	}//Fin si Trigger.isAfter
	
}