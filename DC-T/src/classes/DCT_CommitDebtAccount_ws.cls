/*
	Servicio web de actualización de cuenta deudora
*/

global class DCT_CommitDebtAccount_ws {
	
	// almacena los mensajes de error
	global static Map<String,String> mapErrorMsgs;

	global class Result{
		webservice Boolean convertedIntoDebtAccount;
		webservice Boolean isSuccessful;
		webservice String  idSfdc;
		webservice List<Error> errorList;
		global Result(){
			convertedIntoDebtAccount = false;
			isSuccessful = false;
			errorList = new List<Error>();
		}
	}

	global class Error{
		webservice String code;
		webservice String description;
		global Error(String strCode, String strDescr){
			code = strCode;
			description = strDescr;
		}
	}

	global class CommitDebtAccountArgsFolio{
		webservice String RFC;
		webservice String Name;
		webservice String folio;
	}

	global class CommitDebtAccountArgsNisi{
		webservice String NISI;
		webservice String folio;
	}

	global static void initCleanUpMsgs(){
		mapErrorMsgs = new Map<String,String>();
	}

	webservice static Result commitDebtAccountFolio(CommitDebtAccountArgsFolio argsInstance){
		initCleanUpMsgs();
		Boolean blnSuccessfulProcedure = false;
		Boolean blnAccountWasConverted = false;
		String sIdSfdc = '';		
		if(validateInputs(argsInstance)){
			Account accountInstance = new Account();
			try{accountInstance = [SELECT Id FROM Account WHERE RFC__c =: argsInstance.RFC
				And Name =: argsInstance.Name LIMIT 1]; }catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
			if(accountInstance.Id != null){
				Database.SaveResult sr = Database.update(new Account(
					Id = accountInstance.Id,
					DCTFolio__c = argsInstance.folio
				),false);
				if(sr.isSuccess()){
					blnSuccessfulProcedure = true;
					blnAccountWasConverted = true;
					sIdSfdc = sr.getId();					
				}else
					mapErrorMsgs.put('06',sr.getErrors()[0].getMessage());
			}else
				mapErrorMsgs.put('05','No se encontró ningun cliente con los datos proporcionados.');
		}
		Result wsResponseInstance = new Result();
		wsResponseInstance.convertedIntoDebtAccount = blnAccountWasConverted;
		wsResponseInstance.isSuccessful = blnSuccessfulProcedure;
		wsResponseInstance.idSfdc = sIdSfdc;
		List<Error> lstErrors = new List<Error>();
		for(String iterator:mapErrorMsgs.keySet()){
			lstErrors.add(new Error(
				iterator,
				mapErrorMsgs.get(iterator)
			));
		}
		if(!lstErrors.isEmpty()){
			wsResponseInstance.errorList = lstErrors;
		}
		return wsResponseInstance;
	}

	global static Boolean validateInputs(CommitDebtAccountArgsFolio argsInstance){
		Boolean blnIsEverythingOk = true;
		if(argsInstance.RFC == null || String.isBlank(argsInstance.RFC)){
			blnIsEverythingOk = false;
			mapErrorMsgs.put('01','Debe especificar el RFC de la cuenta deudora.');
		}
		if(argsInstance.name == null || String.isBlank(argsInstance.name)){
			blnIsEverythingOk = false;
			mapErrorMsgs.put('02','Debe especificar el nombre de la cuenta deudora.');
		}
		if(argsInstance.folio == null || String.isBlank(argsInstance.folio)){
			blnIsEverythingOk = false;
			mapErrorMsgs.put('03','Debe especificar el folio.');
		}
		return blnIsEverythingOk;
	} 

	webservice static Result commitDebtAccountNisi(CommitDebtAccountArgsNisi argsInstance){
		System.debug('EN DCT_CommitDebtAccount_ws.commitDebtAccountNisi argsInstance...');

		initCleanUpMsgs();
		Boolean blnSuccessfulProcedure = false;
		Boolean blnAccountWasConverted = false;
		String sIdSfdc = '';		
		if(validateInputs(argsInstance)){
			System.debug('EN DCT_CommitDebtAccount_ws.commitDebtAccountNisi DESPUES DE validateInputs argsInstance: ' + argsInstance);
			Cliente__c accountInstance = new Cliente__c();
			try{
				accountInstance = [SELECT Id, DCTFolio__c FROM Cliente__c WHERE DCTFolio__c =: argsInstance.folio LIMIT 1]; 
			}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
			if(accountInstance.Id != null){
				Cliente__c PCT = new Cliente__c(Id = accountInstance.Id, 
				DCTKeyNISI__c = argsInstance.NISI,
				DCTSAPSporadicCustomer__c = argsInstance.NISI);
				System.debug('EN commitDebtAccountNisi2 : ' + PCT);
				Database.SaveResult sr = Database.update(PCT,false);
				if(sr.isSuccess()){
					blnSuccessfulProcedure = true;
					blnAccountWasConverted = true;
					sIdSfdc = sr.getId();					
				}else
					mapErrorMsgs.put('06',sr.getErrors()[0].getMessage());
			}else
				mapErrorMsgs.put('05','No se encontró ningun cliente con los datos proporcionados.');
		}
		Result wsResponseInstance = new Result();
		wsResponseInstance.convertedIntoDebtAccount = blnAccountWasConverted;
		wsResponseInstance.isSuccessful = blnSuccessfulProcedure;
		wsResponseInstance.idSfdc = sIdSfdc;		
		List<Error> lstErrors = new List<Error>();
		for(String iterator:mapErrorMsgs.keySet()){
			lstErrors.add(new Error(
				iterator,
				mapErrorMsgs.get(iterator)
			));
		}
		if(!lstErrors.isEmpty()){
			wsResponseInstance.errorList = lstErrors;
		}
		return wsResponseInstance;
	}

	global static Boolean validateInputs(CommitDebtAccountArgsNisi argsInstance){
		Boolean blnIsEverythingOk = true;
		if(argsInstance.folio == null || String.isBlank(argsInstance.folio)){
			blnIsEverythingOk = false;
			mapErrorMsgs.put('01','Debe especificar el folio.');
		}		
		if(argsInstance.NISI == null || String.isBlank(argsInstance.NISI)){
			blnIsEverythingOk = false;
			mapErrorMsgs.put('02','Debe especificar el código NISI de la cuenta deudora.');
		}
		return blnIsEverythingOk;
	} 
	
}