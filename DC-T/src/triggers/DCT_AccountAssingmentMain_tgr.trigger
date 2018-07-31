trigger DCT_AccountAssingmentMain_tgr on DCTClientsProspectstoAssigned__c (before insert) {

	if(trigger.isBefore){
		if(trigger.isInsert){
			DCT_AccountAssingmentMethods_cls.validatePreviosAssignmentDoesNotExist(Trigger.new);
		}
	}

}