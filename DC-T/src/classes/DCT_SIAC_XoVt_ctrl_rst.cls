public with sharing class DCT_SIAC_XoVt_ctrl_rst {

	public static List<Error> lErrores {get;set;}

	public class ResultRfcNomReg{
		public Boolean isSuccessful;
		public String UsuarioUniversal;
		public String FuerzaVenta;
		public List<Error> errorList;
		public ResultRfcNomReg(){
			isSuccessful = false;
			errorList = new List<Error>();
		}
	}

	public class ResultRfcTipoReg{
		public Boolean isSuccessful;
		public String UsuarioUniversal;
		public String FuerzaVenta;		
		public String RazonSocial;
		public List<Error> errorList;
		public ResultRfcTipoReg(){
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
		public String Rfc;
		public String RazonSocial;
		public String Region;
		public Integer TipoConsulta;		
	}

	//Metodo que sirve para redireccionar al tipo de consulta que le corresponde
	public static String redireccionaConsulta(String sDatosEntrada){
		System.debug('ENTRO A DCT_SIAC_XoVt_ctrl_rst.redireccionaConsulta sDatosEntrada: ' + sDatosEntrada);
		
		lErrores = new List<Error>();		
		String sResultado = '';
		ResultRfcNomReg Resultado2 = new ResultRfcNomReg();		
		List<ResultRfcTipoReg> Resultado = new List<ResultRfcTipoReg>();		
				
		DatosEntrada objDatosEntrada = new DatosEntrada();
		
		//Crea el obieto del tipo 
		objDatosEntrada = JSONParserEntrada(sDatosEntrada);
		System.debug('ENTRO A DCT_SIAC_XoVt_ctrl_rst.redireccionaConsulta objDatosEntrada: ' + objDatosEntrada);
				
		//Toma el dato del TipoConsulta y ve a donde lo redireccionas
		if (objDatosEntrada.TipoConsulta == 1){
			Resultado2 = siacXoVtRfcNomRegion(objDatosEntrada.Rfc, objDatosEntrada.RazonSocial, objDatosEntrada.Region);
			//Regresa el objeto de Resultado serailizado
			sResultado = JSON.serialize(Resultado2);
		}else if (objDatosEntrada.TipoConsulta == 2){
			Resultado = siacXoVtRfcRegion(objDatosEntrada.Rfc, objDatosEntrada.Region);
			//Regresa el objeto de Resultado serailizado
			sResultado = JSON.serialize(Resultado);				
		}else{ 
			lErrores.add(new Error('04', 'El campo de titpo de consulta debe ser 1 o 2.'));
			Resultado2.errorList = lErrores;
			//Regresa el objeto de Resultado serailizado
			sResultado = JSON.serialize(Resultado2);
		}				
		//Regresa el resultado serializado
		return sResultado;
	}

	public static ResultRfcNomReg siacXoVtRfcNomRegion(String rfc, String RazonSocial, String region){
		System.debug('ENTRO A DCT_SIAC_XoVt_ctrl_rst.siacXoVtRfcNomRegion rfc: ' + rfc + ' RazonSocial: ' + RazonSocial + ' region: ' + region);
		
		Boolean bExiste = false;		
		Boolean blnSuccessfulProcedure = false;
		Boolean blnAccountWasConverted = false;
		ResultRfcNomReg Resultado = new ResultRfcNomReg();
		ResultRfcNomReg ResultError = new ResultRfcNomReg();
		lErrores = new List<Error>();		
		
		Map<String, DTCFuerzaVentas__c> DTCFuerzaVentas = DTCFuerzaVentas__c.getAll();

		Try{
							
			//Valida los datos de entrada
			if(validateInputsRfcNombreReg(rfc, RazonSocial, region)){
			
				Cliente__c clientePaso = new Cliente__c();
				List<Cliente__c> lstCtes = new List<Cliente__c>();
		        String strConsulta = 'SELECT Id, XO__c, VT__c, DCTRegion__c, Name ' + 
		        	' FROM Cliente__c ' +
		        	' WHERE RFC__c = \'' + rfc + '\'' +
		        	//' And DCTRegion__c = \'' + region + '\'' +
		        	' And Name like \'' + RazonSocial + '%\'';		        		
				System.debug('ENTRO A DCT_SIAC_XoVt_ctrl_rst.siacXoVtRfcNomRegion strConsulta: ' + strConsulta);		        	
        		try{
        			lstCtes = Database.query(strConsulta);

					//Consulta los datos del cliente
					for (Cliente__c clienteCons : lstCtes ){ 	
						Resultado.isSuccessful = true;
						Resultado.UsuarioUniversal = clienteCons.XO__c != null ? clienteCons.XO__c : '';
						Resultado.FuerzaVenta = clienteCons.VT__c != null ? clienteCons.VT__c : '';
						//Resultado.Region = clienteCons.DCTRegion__c != null ? clienteCons.DCTRegion__c : '';
						//No es la region R09
						if (DTCFuerzaVentas.containsKey(region))
							Resultado.FuerzaVenta = DTCFuerzaVentas.get(region).FuerzaVentas__c;
						bExiste = true;
					}//Fin del for para los clientes
					//Ve si no existe el cliente con esos datos
					if (!bExiste){
						lErrores.add(new Error('04', 'No se encontró ningun cliente con los datos proporcionados.'));
						Resultado.isSuccessful = false;
					}//Fin si 	!bExiste				

        		}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        		        				
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

	public static Boolean validateInputsRfcNombreReg(String rfc, String RazonSocial, String region){
		Boolean blnIsEverythingOk = true;
		if(rfc == null || String.isBlank(rfc)){
			blnIsEverythingOk = false;
			lErrores.add(new Error('01', 'Debe especificar el RFC.'));
		}
		if(RazonSocial == null || String.isBlank(RazonSocial)){
			blnIsEverythingOk = false;
			lErrores.add(new Error('02', 'Debe especificar la Razón Social.'));
		}
		if(region == null || String.isBlank(region)){
			blnIsEverythingOk = false;
			lErrores.add(new Error('03', 'Debe especificar la Región.'));
		}
		return blnIsEverythingOk;
	}

	public static List<ResultRfcTipoReg> siacXoVtRfcRegion(String rfc, String region){
		System.debug('ENTRO A DCT_SIAC_XoVt_ctrl_rst.siacXoVtRfcRegion rfc: ' + rfc + ' region: ' + region);
		
		Boolean bExiste = false;		
		Boolean blnSuccessfulProcedure = false;
		Boolean blnAccountWasConverted = false;
		List<ResultRfcTipoReg> Resultado = new List<ResultRfcTipoReg>();
		ResultRfcTipoReg ResultError = new ResultRfcTipoReg();
		lErrores = new List<Error>();		
		
		Map<String, DTCFuerzaVentas__c> DTCFuerzaVentas = DTCFuerzaVentas__c.getAll();

		Try{
				
			//Valida los datos de entrada
			if(validateInputsRfcReg(rfc, region)){
				Cliente__c clientePaso = new Cliente__c();
				//Consulta los datos del cliente
				for (Cliente__c clienteCons : [SELECT Id, XO__c, VT__c, DCTRegion__c, Name
					FROM Cliente__c WHERE RFC__c =: rfc 
					//And DCTRegion__c =:region
					]){
					ResultRfcTipoReg ResultPaso = new ResultRfcTipoReg(); 	
					ResultPaso.isSuccessful = true;
					ResultPaso.UsuarioUniversal = clienteCons.XO__c != null ? clienteCons.XO__c : '';
					ResultPaso.FuerzaVenta = clienteCons.VT__c != null ? clienteCons.VT__c : '';
					//ResultPaso.Region = clienteCons.DCTRegion__c != null ? clienteCons.DCTRegion__c : '';
					ResultPaso.RazonSocial = clienteCons.Name != null ? clienteCons.Name : '';					
					//No es la region R09
					if (DTCFuerzaVentas.containsKey(region))
						ResultPaso.FuerzaVenta = DTCFuerzaVentas.get(region).FuerzaVentas__c;
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

	public static Boolean validateInputsRfcReg(String rfc, String region){
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