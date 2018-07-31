public with sharing class DCT_Nisi_ctrl_rst {

	// almacena los mensajes de error
	public static Map<String,String> mapErrorMsgs;

	public class Result{
		//Indica si la cuenta fue convertida en deudora.
		public Boolean convertedIntoDebtAccount;
		//indica si la transacción fue exitosa
		public Boolean isSuccessful;
		public String  idSfdc;		
		//Mensajes de error
		public List<Error> errorList;
		public Result(){
			convertedIntoDebtAccount = false;
			isSuccessful = false;
			errorList = new List<Error>();
		}
	}

	public class Error{
		public String code;
		public String description;
		public Error(String strCode, String strDescr){
			code = strCode;
			description = strDescr;
		}
	}

	public class DatosEntrada{
		public String RFC;
		public String NISI;
		public String name;
		public String folio;
	}

	public static void initCleanUpMsgs(){
		mapErrorMsgs = new Map<String,String>();
	}

	public static String updNisi(String sDatosEntrada){
		System.debug('EN DCT_Nisi_ctrl_rst.updNisi: ' + sDatosEntrada);
		
		String sResult = '';
		initCleanUpMsgs();
		
		DatosEntrada objDatosEntrada = JSONParserEntrada(sDatosEntrada);
		System.debug('EN DCT_Nisi_ctrl_rst.updNisi objDatosEntrada: ' + objDatosEntrada);
				
		Boolean blnSuccessfulProcedure = false;
		Boolean blnAccountWasConverted = false;
		String sIdSfdc = '';
		if(validateInputs(objDatosEntrada)){
			Account accountInstance = new Account();
			try{accountInstance = [SELECT Id FROM Account WHERE DCTFolio__c =: objDatosEntrada.folio 
				//AND id =: '0011100001WmMjPAAV' 
				//AND Numeroempleado__c = '37364' 
				LIMIT 1]; 
			}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
			if(accountInstance.Id != null){
				Database.SaveResult sr = Database.update(new Account(
					Id = accountInstance.Id,
					DCT_KeyNISI__c = objDatosEntrada.NISI
					//DCTFolio__c = objDatosEntrada.folio
				),false);
				if(sr.isSuccess()){
					blnSuccessfulProcedure = true;
					blnAccountWasConverted = true;
					sIdSfdc = sr.getId();
					System.debug('ANTES DE SALIR DE EN DCT_Nisi_ctrl_rst.updNisi sr.getErrors()[0].getId(): ' + sr.getId());					
				}else{
					mapErrorMsgs.put('06',sr.getErrors()[0].getMessage());
					System.debug('ANTES DE SALIR DE EN DCT_Nisi_ctrl_rst.updNisi sr.getErrors()[0].getMessage(): ' + sr.getErrors()[0].getMessage());					
				}
			}else{
				mapErrorMsgs.put('05','No se encontró ningun cliente con los datos proporcionados.');				
			}
		}
		Result wsResponseInstance = new Result();
		wsResponseInstance.convertedIntoDebtAccount = blnAccountWasConverted;
		wsResponseInstance.isSuccessful = blnSuccessfulProcedure;
		wsResponseInstance.idSfdc =	sIdSfdc;
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
		
		//Serializa el objeto con la respuesta
		sResult = JSON.serialize(wsResponseInstance);
		System.debug('ANTES DE SALIR DE EN DCT_Nisi_ctrl_rst.updNisi sResult: ' + sResult);
				
		//Regresa el resultado en formato JSON
		return sResult;
		
	}

	public static Boolean validateInputs(DatosEntrada objDatosEntrada){
		Boolean blnIsEverythingOk = true;
		if(objDatosEntrada.RFC == null || String.isBlank(objDatosEntrada.RFC)){
			blnIsEverythingOk = false;
			mapErrorMsgs.put('01','Debe especificar el RFC de la cuenta deudora.');
		}
		if(objDatosEntrada.NISI == null || String.isBlank(objDatosEntrada.NISI)){
			blnIsEverythingOk = false;
			mapErrorMsgs.put('02','Debe especificar el código NISI de la cuenta deudora.');
		}
		/*if(objDatosEntrada.name == null || String.isBlank(objDatosEntrada.name)){
			blnIsEverythingOk = false;
			mapErrorMsgs.put('03','Debe especificar el nombre de la cuenta deudora.');
		}*/
		if(objDatosEntrada.folio == null || String.isBlank(objDatosEntrada.folio)){
			blnIsEverythingOk = false;
			mapErrorMsgs.put('03','Debe especificar el folio.');
		}
		return blnIsEverythingOk;
	} 

	//Regresa un objeto del tipo DtRespuestaTelcel si no hubo error a la hora de registrar el cliente		
	public static DatosEntrada JSONParserEntrada(String sJsonResp){
		System.debug('EN DCT_Nisi_ctrl_rst.JSONParserEntrada: sJsonResp: ' + sJsonResp);
		
		DatosEntrada objAPPResp = new DatosEntrada();		
	
		try{
            JSONParser parser = JSON.createParser(sJsonResp);
            //Ve si tiene algo el objeto de parser  
            while (parser.nextToken() != null) {//{"error": "invalid_client","error_description": "Las credenciales proporcionadas no son correctas."}
				//Inicia el detalle del objeto: sNombreObj
				if (parser.getCurrentToken() == JSONToken.START_OBJECT) { // 
					//Inicia el arreglo
					objAPPResp = (DatosEntrada)parser.readValueAs(DatosEntrada.class);							
				}//Fin si parser.getCurrentToken() == JSONToken.START_OBJECT
            }//Fin mientras parser.nextToken() != null
		}catch(Exception ex){
			System.debug('ERROR EN DCT_Nisi_ctrl_rst.JSONParserEntrada: sJsonResp: ' + ex.getMessage());
	 	}

		System.debug('ANTES DE SALIR DE DCT_Nisi_ctrl_rst.JSONParserEntrada: objAPPResp: ' + objAPPResp);
			 	
		//Regresa el objeto objSignInClsPaso
		return objAPPResp;
	}

}