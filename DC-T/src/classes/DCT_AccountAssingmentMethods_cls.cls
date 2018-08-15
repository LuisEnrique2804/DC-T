public class DCT_AccountAssingmentMethods_cls {
	
	public static void validatePreviosAssignmentDoesNotExist(List<DCTClientsProspectstoAssigned__c> lstNewAssigns){
		Map<Id,DCTClientsProspectstoAssigned__c> mapAssignsByAccountId = new Map<Id,DCTClientsProspectstoAssigned__c>();
		Set<Id> setAccountsToAssignIds = new Set<Id>();
		
		for(DCTClientsProspectstoAssigned__c iterator:lstNewAssigns){
			if(iterator.AccountName__c != null){
				setAccountsToAssignIds.add(iterator.AccountName__c);
				mapAssignsByAccountId.put(iterator.AccountName__c,iterator);
			}
		}
		if(!setAccountsToAssignIds.isEmpty()){
			List<DCTClientsProspectstoAssigned__c> lstAccsPendingApprovalForAssignment = new List<DCTClientsProspectstoAssigned__c>();
			String strQueryOverPendingForApprovalAssignments = 'SELECT Id, AccountName__c, AccountName__r.Name  FROM DCTClientsProspectstoAssigned__c WHERE AccountName__c IN (\''+String.join(new List<Id>(setAccountsToAssignIds),'\',\'')+'\') AND AssignmentNumber__r.Status__c = \'Pendiente\'';
			try{lstAccsPendingApprovalForAssignment = Database.query(strQueryOverPendingForApprovalAssignments);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
			for(DCTClientsProspectstoAssigned__c iterator:lstAccsPendingApprovalForAssignment){
				if(mapAssignsByAccountId.containsKey(iterator.AccountName__c))
					mapAssignsByAccountId.get(iterator.AccountName__c).addError('La cuenta '+iterator.AccountName__r.Name+' ya se encuentra en una asignación pendiente de aprobación.');
			}
		}

	}

}