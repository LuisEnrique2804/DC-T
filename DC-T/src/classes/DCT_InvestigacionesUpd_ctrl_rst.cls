public with sharing class DCT_InvestigacionesUpd_ctrl_rst {

	public static ResultadoSfdc objResultadoSfdc {get;set;}
	public static List<Error> lErrores {get;set;}
	public static DatosEntrada objDatosEntrada {get;set;}
	public static Cliente__c DirComUpd {get;set;}
	
	public class ResultadoSfdc{
		public Boolean esExitoso;
		public String idSfdc;
		public List<Error> errorLista;
	}

	public class Error{
		public String codigo;
		public String descripcion;
		public Error(String strCode, String strDescr){
			codigo = strCode;
			descripcion = strDescr;
		}
	}

	public class DatosEntrada{
		public String RazonSocial {get;set;}
		public String Rfc {get;set;}
		public Integer TotalLineasAutorizadas {get;set;}		
		public String ClaveInvestigacion {get;set;}
		public String EstatusInvestigacion {get;set;}
	}

	public static String updInvestigaciones(String sDatosEntrada){
		System.debug('ENTRO A DCT_InvestigacionesUpd_ctrl_rst.updInvestigaciones sDatosEntrada: ' + sDatosEntrada);
		String sResultadoSfdc = '';
		
		objResultadoSfdc = new ResultadoSfdc();
		lErrores = new List<Error>();
		
		Boolean bValidaDatosEntrada = ValidaDatos(sDatosEntrada);
		System.debug('ENTRO A DCT_InvestigacionesUpd_ctrl_rst.updInvestigaciones bValidaDatosEntrada: ' + bValidaDatosEntrada);		
		
		//Valida los datos y ve si hay errores
		if (bValidaDatosEntrada){
			
			//Busca el registro de la empresa
			for (Cliente__c dirCom : [Select id, Name, DCTResearchLegend__c From Cliente__c 
				Where Name =:objDatosEntrada.RazonSocial.toUpperCase() And 
				(RFC__c =:objDatosEntrada.Rfc OR RFC1__c = :objDatosEntrada.Rfc)]){
				DirComUpd = new Cliente__c(id = dirCom.id);	
				if (objDatosEntrada.TotalLineasAutorizadas != null)				
					DirComUpd.DCTTotLineasAutorInvest__c = String.valueOf(objDatosEntrada.TotalLineasAutorizadas);
				//Ve si tiene algo el dato de ClaveInvestigacion
				if (objDatosEntrada.ClaveInvestigacion != null && objDatosEntrada.ClaveInvestigacion != '')
					DirComUpd.DCTInvestigation__c = objDatosEntrada.ClaveInvestigacion;
				if (objDatosEntrada.EstatusInvestigacion != null && objDatosEntrada.EstatusInvestigacion != '')					
					DirComUpd.DCTResultVerification__c = objDatosEntrada.EstatusInvestigacion;
				//Si el valor que esta poniendo es IT entonces en la leyenda de Investigaciòn es Rechazar Activación
				if (objDatosEntrada.ClaveInvestigacion != null && objDatosEntrada.ClaveInvestigacion != ''){
					if (objDatosEntrada.ClaveInvestigacion == 'IT' && dirCom.DCTResearchLegend__c == null){
						DirComUpd.DCTResearchLegend__c = 'Rechazar Activación';
						DirComUpd.DCTTotLineasAutorInvest__c = '0';
					}//Fin si objDatosEntrada.ClaveInvestigacion == 'IT' && dirCom.DCTResearchLegend__c == null
				}//Fin si objDatosEntrada.ClaveInvestigacion != null && objDatosEntrada.ClaveInvestigacion != ''					
			}//Fin del for para los datos de la consulta de la empresa

			System.debug('ENTRO A DCT_InvestigacionesUpd_ctrl_rst.updInvestigaciones DirComUpd1: ' + DirComUpd);			
			//Ve si tiene algo el objeto de DirComUpd
			if (DirComUpd != null){
				//Bloquea el trigger para que no se mande llamar dos veces el servicio cuando es V1
				if (objDatosEntrada.ClaveInvestigacion == 'VI')				
					DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
				//Actualiza el reg en SFDC	
				Database.Saveresult objDtsv = Database.update(DirComUpd);
				if (!objDtsv.isSuccess()){
					objResultadoSfdc.esExitoso = false;
					objResultadoSfdc.idSfdc = null;
					lErrores.Add(new Error('01', objDtsv.getErrors()[0].getMessage()));					
					objResultadoSfdc.errorLista = lErrores;					

				}//Fin si !objDtsv.isSuccess()
				if (objDtsv.isSuccess()){
					objResultadoSfdc.esExitoso = true;
					objResultadoSfdc.idSfdc = objDtsv.getId();
					objResultadoSfdc.errorLista = lErrores;					
					System.debug('ENTRO A DCT_InvestigacionesUpd_ctrl_rst.updInvestigaciones objDatosEntrada.EstatusInvestigacion: ' + objDatosEntrada.EstatusInvestigacion + ' ClaveInvestigacion: ' + objDatosEntrada.ClaveInvestigacion);
					//Solo cuando se trata de una RESPUESTA POSITIVA
					if (objDatosEntrada.EstatusInvestigacion == 'POSITIVA')
						DCT_Utils_cls.ActualizaInvestigacionesEsc1Pos(DirComUpd.id, true);
					//Solo cuando se trata de una RESPUESTA NEGATIVA
					if (objDatosEntrada.EstatusInvestigacion == 'NEGATIVA')
						DCT_Utils_cls.ActualizaInvestigacionesEsc12Pos(DirComUpd.id, true);
					//Solo ClaveInvestigacion es igual a 'VI'
					if (objDatosEntrada.ClaveInvestigacion == 'VI')
						DCT_Utils_cls.ActualizaInvestigacionesEsc5VI(DirComUpd.id, true);
				}//Fin si objDtsv.isSuccess()
			}//Fin si DirComUpd != null

			System.debug('ENTRO A DCT_InvestigacionesUpd_ctrl_rst.updInvestigaciones DirComUpd2: ' + DirComUpd);			
			//No existe la empresa en SFDC
			if (DirComUpd == null){
				objResultadoSfdc.esExitoso = false;
				objResultadoSfdc.idSfdc = null;
				lErrores.Add(new Error('01', 'No existe la empresa con el nombre: ' + objDatosEntrada.RazonSocial.toUpperCase() + ' en el Directorio Comercial'));					
				objResultadoSfdc.errorLista = lErrores;
			}//Fin si DirComUpd == null
			
		}//Fin si ValidaDatos(sDatosEntrada)
		
		//Hubo errores de validación de datos
		if (!bValidaDatosEntrada){
			objResultadoSfdc.esExitoso = false;
			objResultadoSfdc.idSfdc = null;
			objResultadoSfdc.errorLista = lErrores;
		}//Fin si !ValidaDatos(sDatosEntrada)		
				
		//Crea el JSON DE salida
		sResultadoSfdc = JSON.serialize(objResultadoSfdc);
		System.debug('EN DCT_InvestigacionesUpd_ctrl_rst.updInvestigaciones sResultadoSfdc: ' + sResultadoSfdc);
		
		//Regresa el mensaje de error
		return sResultadoSfdc;
	}

	public static boolean ValidaDatos(String sDatosEntrada){
		System.debug('EN DCT_InvestigacionesUpd_ctrl_rst.ValidaDatos sDatosEntrada lErrores: ' + lErrores);
		
		Boolean bError = true;
		objDatosEntrada = new DatosEntrada();
		
		try{
			//Deserializa kla cadena con los datos de entrada
			objDatosEntrada = (DatosEntrada)JSON.deserialize(sDatosEntrada, DatosEntrada.class);
			System.debug('EN DCT_InvestigacionesUpd_ctrl_rst.ValidaDatos objDatosEntrada: ' + objDatosEntrada);
			//Ve si no tiene nada el campo de RazonSocial
			if (objDatosEntrada.RazonSocial == null || objDatosEntrada.RazonSocial == '')
				lErrores.Add(new Error('01', 'Debes capturar un valor en el campo de: RazonSocial'));					
			if (objDatosEntrada.Rfc == null || objDatosEntrada.Rfc == '')
				lErrores.Add(new Error('02', 'Debes capturar un valor en el campo de: Rfc'));					

			if ( (objDatosEntrada.TotalLineasAutorizadas == null || objDatosEntrada.TotalLineasAutorizadas == 0)
				 &&	(objDatosEntrada.ClaveInvestigacion == null || objDatosEntrada.ClaveInvestigacion == '')
				 &&	(objDatosEntrada.EstatusInvestigacion == null || objDatosEntrada.EstatusInvestigacion == '')				 
				)
				lErrores.Add(new Error('03', 'Debes capturar al menos un un valor en alguno de estos campos: Tot. Lineas Autor Invest., Clave Investigación o Estatus Investigación'));
				
			if (!lErrores.isEmpty())	
				bError = false;			
		}catch(Exception ex){
			lErrores.Add(new Error('00', ex.getMessage()));
			bError = false;
			System.debug('EN DCT_InvestigacionesUpd_ctrl_rst.ValidaDatos ex.getMessage(): ' + ex.getMessage());			
		}

		System.debug('EN DCT_InvestigacionesUpd_ctrl_rst.ValidaDatos bError: ' + bError + ' lErrores: ' + lErrores);		
		return bError;
	}

}