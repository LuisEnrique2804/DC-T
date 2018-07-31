global with sharing class DCT_SISAC_Activa_ws {

	global static List<Error> lErrores {get;set;}

	global class DatosEntrada{
		webservice String rfc;
		webservice String name;		
	}	

	global class Result{
		webservice Boolean isSuccessful;
		webservice String RazonSocial; //Name
		webservice String FuerzaDeVentasDist; //DCTPowerSales__c
					
		webservice String EntidadFederativa; //DCTCorrespondenceEntity__c, FiscalFederalEntity__c
		webservice String DelegacionMunicipio; //DCTDelMpiocorrespondence__c, DCTDelMpiofiscal__c
		webservice String GrupoCategoriaDatos; //Grupo__r.Name
		webservice String Estado; //Cliente__r.Estatus__c
		webservice String ClavePlan; //DCTPlan__r.Clave__c
		webservice String NombrePlan; //DCTPlan__r.DCTLineType__c
		webservice String ClaveServicio; //DCTPlan__r.DCTServicekey__c
		webservice String NombreServicioAdicional; //DCTPlan__r.DCTAdditionalServices__c
		webservice String TipoSociedad; //DCTCompanyType__c
		webservice String TarifaPlanAutorizado; //DCTRates__c	
		webservice String Marca; //DCTPlan__r.DCTBrand__c
		webservice String Modelo; //DCTPlan__r.DCTModel__c
		webservice String PlazoDias; //DCTPlan__r.DCTTerm__c //DCTTermDays__c
		webservice String FechaPrimeraActivacion; //DCTCustomerFrom__c

		webservice String FuerzaDeVentasInterna; //DCTPowerSales2__c
		webservice String FuerzaVentaActivarVPN; //No esta		
		webservice String DatVoz; //DCTCustomerFrom__c
		webservice String DatDatos; //No esta
		webservice String Integrador; //DCTIntegrador__c
		webservice String Ciclo; //DCTBillingCycle__c
		webservice String ClaseDeCredito; //DCTCreditClass__c
		webservice String TipoCuenta; //DCTAccountType__c
		webservice String PromoVtaEmpleado; //No esta 
		webservice String DATRenovacionAdendum; //No esta
		webservice String CambioSIM; //No esta
		webservice String RFC; //RFC__c
		webservice String AdendumAnt; //DCTAnticipatedAdendum__c
		webservice Boolean Bonifica; //DCTCollectionBonus__c
		webservice String UsuarioId; //OwnerId
								
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

	webservice static Result siacRfc(String rfc){

		lErrores = new List<Error>();
		Boolean bExiste = false;		
		Boolean blnSuccessfulProcedure = false;
		Boolean blnAccountWasConverted = false;
		Result ResultPaso = new Result();

		Try{

			//Valida los datos de entrada
			if(validateInputs(rfc, 1)){
				
				//Consulta los datos del cliente
				for (Cliente__c clientePaso : [SELECT Id, 
					DCTCorrespondenceEntity__c, FiscalFederalEntity__c,
					DCTDelMpiocorrespondence__c, DCTDelMpiofiscal__c,
					Grupo__r.Name, Cliente__r.Estatus__c,  
					DCTPlan__r.Clave__c, DCTPlan__r.DCTLineType__c, 
					DCTPlan__r.DCTServicekey__c, DCTPlan__r.DCTAdditionalServices__c,
					DCTCompanyType__c, DCTRates__c, DCTPlan__r.DCTBrand__c, DCTPlan__r.DCTModel__c,
					DCTPlan__r.DCTTerm__c, DCTCustomerFrom__c, Name, DCTPowerSales__c,
					DCTPowerSales2__c, RFC__c, DCTAnticipatedAdendum__c, DCTBonusCustomization__c,
					OwnerId
					FROM Cliente__c WHERE RFC__c =: rfc
					]){
					//And Name =: datodEntrada.name.toUpperCase()]){						
					
					//Inicializa los datos del cliente en inicializaDatosCliente
					inicializaDatosCliente(clientePaso);
					//Prende la bandera de bExiste						
					bExiste = true;
				}
				//Ve si no existe el cliente con esos datos
				if (bExiste){
					ResultPaso.isSuccessful = false;				
					lErrores.add(new Error('03', 'No se encontró ningun cliente con los datos proporcionados.'));
				}
			}else{//Fin si validateInputs(datodEntrada)
				ResultPaso.isSuccessful = false;
			}
		
		}Catch(Exception ex){
			lErrores.add(new Error('00', ex.getMessage() + ' Causa: ' + ex.getCause() + ' Linea: ' + ex.getLineNumber()));
		}
		
		//Inicializa la lista de errores
		ResultPaso.errorList = lErrores; 		
		
		//Regresa la respuesta en el objeto de ResultPaso 	
		return ResultPaso;
		
	}

	global static Boolean validateInputs(String sRfc, Integer Metodo){
		Boolean blnIsEverythingOk = true;
		if(sRfc == null || String.isBlank(sRfc) && Metodo == 1){
			blnIsEverythingOk = false;
			lErrores.add(new Error('01', 'Debe especificar el RFC de la cuenta deudora.'));
		}
		/*if(pDatosEntrada.name == null || String.isBlank(pDatosEntrada.name)){
			blnIsEverythingOk = false;
			lErrores.add(new Error('03', 'Debe especificar el nombre de la cuenta deudora.'));
		}*/
		return blnIsEverythingOk;
	}
	
	//Metodo para llenar el objeto del tipo ResultPaso con los datos de la consulta
	global static Result inicializaDatosCliente(Cliente__c cobjCiente){
		Result Resultado = new Result();

		Resultado.isSuccessful = true;
		Resultado.RazonSocial = cobjCiente.Name != null ? cobjCiente.Name : '';
				
		Resultado.EntidadFederativa = cobjCiente.DCTCorrespondenceEntity__c != null ? cobjCiente.DCTCorrespondenceEntity__c : '';
		Resultado.DelegacionMunicipio = cobjCiente.DCTDelMpiocorrespondence__c != null ? cobjCiente.DCTDelMpiocorrespondence__c : '';
		Resultado.GrupoCategoriaDatos = cobjCiente.Grupo__r.Name != null ? cobjCiente.Grupo__r.Name : '';					
		Resultado.Estado = cobjCiente.Cliente__r.Estatus__c != null ? cobjCiente.Cliente__r.Estatus__c : '';
		Resultado.ClavePlan = cobjCiente.DCTPlan__r.Clave__c != null ? cobjCiente.DCTPlan__r.Clave__c : '';
		Resultado.NombrePlan = cobjCiente.DCTPlan__r.DCTLineType__c != null ? cobjCiente.DCTPlan__r.DCTLineType__c : '';
		Resultado.ClaveServicio = cobjCiente.DCTPlan__r.DCTServicekey__c != null ? cobjCiente.DCTPlan__r.DCTServicekey__c : '';
		Resultado.NombreServicioAdicional = cobjCiente.DCTPlan__r.DCTAdditionalServices__c != null ? cobjCiente.DCTPlan__r.DCTAdditionalServices__c : '';
		Resultado.TipoSociedad = cobjCiente.DCTCompanyType__c != null ? cobjCiente.DCTCompanyType__c : '';
		Resultado.TarifaPlanAutorizado = cobjCiente.DCTRates__c != null ? cobjCiente.DCTRates__c : '';
		Resultado.Marca = cobjCiente.DCTPlan__r.DCTBrand__c != null ? cobjCiente.DCTPlan__r.DCTBrand__c : '';
		Resultado.Modelo = cobjCiente.DCTPlan__r.DCTModel__c != null ? cobjCiente.DCTPlan__r.DCTModel__c : '';
		Resultado.PlazoDias = cobjCiente.DCTPlan__r.DCTTerm__c != null ? cobjCiente.DCTPlan__r.DCTTerm__c : '';
		Resultado.FechaPrimeraActivacion = cobjCiente.DCTCustomerFrom__c != null ? String.valueOf(cobjCiente.DCTCustomerFrom__c) : '';
		Resultado.FuerzaDeVentasDist = cobjCiente.Name != null ? cobjCiente.Name : '';
		Resultado.FuerzaDeVentasInterna = cobjCiente.DCTPowerSales2__c != null ? cobjCiente.DCTPowerSales2__c : '';
		Resultado.DatVoz = '';
		Resultado.DatDatos = '';
		Resultado.Integrador = cobjCiente.DCTIntegrador__c != null ? cobjCiente.DCTIntegrador__c : '';
		Resultado.Ciclo = cobjCiente.DCTBillingCycle__c != null ? cobjCiente.DCTBillingCycle__c : '';
		Resultado.ClaseDeCredito = cobjCiente.DCTCreditClass__c != null ? cobjCiente.DCTCreditClass__c : '';
		Resultado.TipoCuenta = cobjCiente.DCTAccountType__c != null ? cobjCiente.DCTAccountType__c : '';
		Resultado.PromoVtaEmpleado = '';
		Resultado.DATRenovacionAdendum = '';
		Resultado.CambioSIM = '';
		Resultado.RFC = cobjCiente.RFC__c != null ? cobjCiente.RFC__c : '';
		Resultado.AdendumAnt = cobjCiente.DCTAnticipatedAdendum__c != null ? cobjCiente.DCTAnticipatedAdendum__c : '';
		Resultado.Bonifica = cobjCiente.DCTCollectionBonus__c;
		Resultado.UsuarioId = cobjCiente.OwnerId != null ? cobjCiente.OwnerId : '';
		Resultado.FuerzaVentaActivarVPN = '';
		
		//Regresa el dato del tipo Result
		return  Resultado;
	}	
	
	 
}