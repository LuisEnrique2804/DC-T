global with sharing class DCT_SIAC_XoVt_ws {

	global static List<Error> lErrores {get;set;}

	global class Result{
		webservice Boolean isSuccessful;
		webservice String Xo;
		webservice String Vt;
		webservice String Region;		
		webservice String RazonSocial;		
		webservice List<Error> errorList;
		global Result(){
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

	webservice static Result siacXoVtRfcNomRegion(String rfc, String nombre, String region){

		Boolean bExiste = false;		
		Boolean blnSuccessfulProcedure = false;
		Boolean blnAccountWasConverted = false;
		Result Resultado = new Result();
		Result ResultError = new Result();
		lErrores = new List<Error>();		
		
		Map<String, DTCFuerzaVentas__c> DTCFuerzaVentas = DTCFuerzaVentas__c.getAll();

		Try{
				
			//Valida los datos de entrada
			if(validateInputsRfcNombreReg(rfc, nombre, region)){
				Cliente__c clientePaso = new Cliente__c();
				//Consulta los datos del cliente
				for (Cliente__c clienteCons : [SELECT Id, XO__c, VT__c, DCTRegion__c, Name
					FROM Cliente__c WHERE RFC__c =: rfc And DCTRegion__c =:region]){ 	
					Resultado.isSuccessful = true;
					Resultado.Xo = clienteCons.XO__c != null ? clienteCons.XO__c : '';
					Resultado.Vt = clienteCons.VT__c != null ? clienteCons.VT__c : '';
					Resultado.Region = clienteCons.DCTRegion__c != null ? clienteCons.DCTRegion__c : '';
					//No es la region R09
					if (DTCFuerzaVentas.containsKey(region))
						Resultado.Vt = DTCFuerzaVentas.get(region).FuerzaVentas__c;
					bExiste = true;
				}//Fin del for para los clientes
				//Ve si no existe el cliente con esos datos
				if (!bExiste){
					lErrores.add(new Error('04', 'No se encontró ningun cliente con los datos proporcionados.'));
					Resultado.isSuccessful = false;
				}//Fin si 	!bExiste				
			}else{//Fin si validateInputs(datodEntrada)
				Resultado.isSuccessful = false;
			}
		
		}Catch(Exception ex){
			lErrores.add(new Error('00', ex.getMessage() + ' Causa: ' + ex.getCause() + ' Linea: ' + ex.getLineNumber()));						
		}
		
		//Inicializa la lista de errores
		if (!lErrores.isEmpty()){
			Resultado.errorList = lErrores;
		}
		
		//Regresa la respuesta en el objeto de Resultado 	
		return Resultado;
		
	}

	global static Boolean validateInputsRfcNombreReg(String rfc, String nombre, String region){
		Boolean blnIsEverythingOk = true;
		if(rfc == null || String.isBlank(rfc)){
			blnIsEverythingOk = false;
			lErrores.add(new Error('01', 'Debe especificar el RFC.'));
		}
		if(nombre == null || String.isBlank(nombre)){
			blnIsEverythingOk = false;
			lErrores.add(new Error('02', 'Debe especificar el Nombre o razón social.'));
		}
		if(region == null || String.isBlank(region)){
			blnIsEverythingOk = false;
			lErrores.add(new Error('03', 'Debe especificar la Región.'));
		}
		return blnIsEverythingOk;
	}

	webservice static List<Result> siacXoVtRfcRegion(String rfc, String region){

		Boolean bExiste = false;		
		Boolean blnSuccessfulProcedure = false;
		Boolean blnAccountWasConverted = false;
		List<Result> Resultado = new List<Result>();
		Result ResultError = new Result();
		lErrores = new List<Error>();		
		
		Map<String, DTCFuerzaVentas__c> DTCFuerzaVentas = DTCFuerzaVentas__c.getAll();

		Try{
				
			//Valida los datos de entrada
			if(validateInputsRfcReg(rfc, region)){
				Cliente__c clientePaso = new Cliente__c();
				//Consulta los datos del cliente
				for (Cliente__c clienteCons : [SELECT Id, XO__c, VT__c, DCTRegion__c, Name
					FROM Cliente__c WHERE RFC__c =: rfc And DCTRegion__c =:region]){
					Result ResultPaso = new Result(); 	
					ResultPaso.isSuccessful = true;
					ResultPaso.Xo = clienteCons.XO__c != null ? clienteCons.XO__c : '';
					ResultPaso.Vt = clienteCons.VT__c != null ? clienteCons.VT__c : '';
					ResultPaso.Region = clienteCons.DCTRegion__c != null ? clienteCons.DCTRegion__c : '';
					ResultPaso.RazonSocial = clienteCons.Name != null ? clienteCons.Name : '';					
					//No es la region R09
					if (DTCFuerzaVentas.containsKey(region))
						ResultPaso.Vt = DTCFuerzaVentas.get(region).FuerzaVentas__c;
					Resultado.add(ResultPaso);
					bExiste = true;
				}//Fin del for para los clientes
				//Ve si no existe el cliente con esos datos
				if (!bExiste)
					lErrores.add(new Error('03', 'No se encontró ningun cliente con los datos proporcionados.'));
			}else{//Fin si validateInputs(datodEntrada)
				ResultError.isSuccessful = false;
			}
		
		}Catch(Exception ex){
			lErrores.add(new Error('00', ex.getMessage() + ' Causa: ' + ex.getCause() + ' Linea: ' + ex.getLineNumber()));						
		}
		
		//Inicializa la lista de errores
		if (!lErrores.isEmpty()){
			ResultError.errorList = lErrores;
			Resultado.add(ResultError);
		}
		
		//Regresa la respuesta en el objeto de ResultPaso 	
		return Resultado;
		
	}

	global static Boolean validateInputsRfcReg(String rfc, String region){
		Boolean blnIsEverythingOk = true;
		if(rfc == null || String.isBlank(rfc)){
			blnIsEverythingOk = false;
			lErrores.add(new Error('01', 'Debe especificar el RFC.'));
		}
		if(region == null || String.isBlank(region)){
			blnIsEverythingOk = false;
			lErrores.add(new Error('02', 'Debe especificar la Región.'));
		}
		return blnIsEverythingOk;
	} 

}