trigger DCT_Competitors_tgr on DCTCompetitors__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	new DCT_CompetitorsTriggerHandler().Run();	
}