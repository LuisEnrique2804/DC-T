trigger Interlocutor_tgr on Interlocutor__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	new InterlocutorTriggerHandler().run();
}