/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class DCT_InvestigacionesUpd_ctrl_tst {

	public static String VaRtAccountCorpo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Corporativo').getRecordTypeId();
	public static String VaRtAccountEmpre = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Empresarial').getRecordTypeId();  
	public static String VaRtAccountPyme = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel PyME').getRecordTypeId();

	@isTest(seeAllData = true)
    static void DCT_InvestigacionesUpdCtrlOk() {
    	
    	Test.startTest();

			String sNomPerfUsrAdmin = 'Administrador del sistema';																		
			List<User > lUserAdmin = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrAdmin);			
			
			//Crea una clase para los objetos
			List<Account> lCliente = DCT_CreaObjetosTest_tst.CreaClienteC(1, VaRtAccountCorpo, lUserAdmin.get(0).id);
			List<Cliente__c> lDirCom = DCT_CreaObjetosTest_tst.CreaDirCom(1, lUserAdmin.get(0).id, lCliente.get(0));
			System.debug('EN sJsonDatosEntrada DCT_InvestigacionesUpd_ctrl_tst.DCT_InvestigacionesUpdCtrlOk lDirCom: ' + lDirCom.get(0));
			
			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserAdmin.get(0)){
			
		    	DCT_InvestigacionesUpd_ctrl_rst.DatosEntrada objDatosEntrada = new DCT_InvestigacionesUpd_ctrl_rst.DatosEntrada();
		    	objDatosEntrada.RazonSocial = lDirCom.get(0).Name;
		    	objDatosEntrada.Rfc = lDirCom.get(0).RFC1__c;
		    	objDatosEntrada.TotalLineasAutorizadas = 10;
		    	objDatosEntrada.ClaveInvestigacion = 'IT';
		    	objDatosEntrada.EstatusInvestigacion = 'POSITIVA';
		    	
		    	DCT_InvestigacionesUpd_ctrl_rst.ResultadoSfdc objResultadoSfdc = new DCT_InvestigacionesUpd_ctrl_rst.ResultadoSfdc();
		    	objResultadoSfdc.errorLista = new List<DCT_InvestigacionesUpd_ctrl_rst.Error>();
		    	objResultadoSfdc.esExitoso = true;
		    	objResultadoSfdc.idSfdc = '';
		    	
		    	DCT_InvestigacionesUpd_ctrl_rst.Error Error = new DCT_InvestigacionesUpd_ctrl_rst.Error('codigo', 'descripcion');
		    	
				//Manda llamar el metodo de ValidaDatos
				DCT_InvestigacionesUpd_ctrl_rst.lErrores = new List<DCT_InvestigacionesUpd_ctrl_rst.Error>();
				DCT_InvestigacionesUpd_ctrl_rst.DatosEntrada objDatosEntradaVacios = new DCT_InvestigacionesUpd_ctrl_rst.DatosEntrada();				
				String sJsonDatosEntrada = JSON.serialize(objDatosEntradaVacios);
				DCT_InvestigacionesUpd_ctrl_rst.ValidaDatos(sJsonDatosEntrada);

				//Llama el avento updInvestigaciones
				sJsonDatosEntrada = JSON.serialize(objDatosEntrada);
				System.debug('EN sJsonDatosEntrada DCT_InvestigacionesUpd_ctrl_tst.DCT_InvestigacionesUpdCtrlOk: ' + sJsonDatosEntrada);
				DCT_InvestigacionesUpd_ctrl_rst.updInvestigaciones(sJsonDatosEntrada);

				//Reinicializa los datos y vuelve a llamar
		    	objDatosEntrada.RazonSocial = lDirCom.get(0).Name;
		    	objDatosEntrada.Rfc = lDirCom.get(0).RFC1__c;
		    	objDatosEntrada.TotalLineasAutorizadas = 10;
		    	objDatosEntrada.ClaveInvestigacion = 'IT';
		    	objDatosEntrada.EstatusInvestigacion = 'NEGATIVA';

				//Llama el avento updInvestigaciones
				sJsonDatosEntrada = JSON.serialize(objDatosEntrada);
				System.debug('EN sJsonDatosEntrada DCT_InvestigacionesUpd_ctrl_tst.DCT_InvestigacionesUpdCtrlOk: ' + sJsonDatosEntrada);
				DCT_InvestigacionesUpd_ctrl_rst.updInvestigaciones(sJsonDatosEntrada);

				//Reinicializa los datos y vuelve a llamar
		    	objDatosEntrada.RazonSocial = lDirCom.get(0).Name;
		    	objDatosEntrada.Rfc = lDirCom.get(0).RFC1__c + '123';
		    	objDatosEntrada.TotalLineasAutorizadas = 0;
		    	objDatosEntrada.ClaveInvestigacion = 'IT';
		    	objDatosEntrada.EstatusInvestigacion = 'NEGATIVA';

				//Llama el avento updInvestigaciones
				sJsonDatosEntrada = JSON.serialize(objDatosEntrada);
				System.debug('EN sJsonDatosEntrada DCT_InvestigacionesUpd_ctrl_tst.DCT_InvestigacionesUpdCtrlOk3: ' + sJsonDatosEntrada);
				DCT_InvestigacionesUpd_ctrl_rst.updInvestigaciones(sJsonDatosEntrada);
				
				//Ve si se crearon los objetos para hacer el llamado
    		    System.assertNotEquals(objDatosEntrada, null);
    		    System.assertNotEquals(objResultadoSfdc, null);
				
			}//Fin si System.runAs(lUserGV.get(0))
				
		Test.stopTest();
    }
    
	@isTest(seeAllData = true)
    static void DCT_InvestigacionesUpdCtrlEror() {
    	
    	Test.startTest();

			String sNomPerfUsrAdmin = 'Administrador del sistema';																		
			List<User > lUserAdmin = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrAdmin);			
			
			//Crea una clase para los objetos
			List<Account> lCliente = DCT_CreaObjetosTest_tst.CreaClienteC(1, VaRtAccountCorpo, lUserAdmin.get(0).id);
			List<Cliente__c> lDirCom = DCT_CreaObjetosTest_tst.CreaDirCom(1, lUserAdmin.get(0).id, lCliente.get(0));
			System.debug('EN sJsonDatosEntrada DCT_InvestigacionesUpd_ctrl_tst.DCT_InvestigacionesUpdCtrlOk lDirCom: ' + lDirCom.get(0));
			
			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserAdmin.get(0)){
			
		    	DCT_InvestigacionesUpd_ctrl_rst.DatosEntrada objDatosEntrada = new DCT_InvestigacionesUpd_ctrl_rst.DatosEntrada();
		    	objDatosEntrada.RazonSocial = lDirCom.get(0).Name;
		    	objDatosEntrada.Rfc = lDirCom.get(0).RFC1__c;
		    	objDatosEntrada.TotalLineasAutorizadas = 0;
		    	objDatosEntrada.ClaveInvestigacion = null;
		    	objDatosEntrada.EstatusInvestigacion = null;
		    	
		    	DCT_InvestigacionesUpd_ctrl_rst.ResultadoSfdc objResultadoSfdc = new DCT_InvestigacionesUpd_ctrl_rst.ResultadoSfdc();
		    	objResultadoSfdc.errorLista = new List<DCT_InvestigacionesUpd_ctrl_rst.Error>();
		    	objResultadoSfdc.esExitoso = true;
		    	objResultadoSfdc.idSfdc = '';
		    	
		    	DCT_InvestigacionesUpd_ctrl_rst.Error Error = new DCT_InvestigacionesUpd_ctrl_rst.Error('codigo', 'descripcion');

				//Llama el avento updInvestigaciones
				String sJsonDatosEntrada = JSON.serialize(objDatosEntrada);
				System.debug('EN sJsonDatosEntrada DCT_InvestigacionesUpd_ctrl_tst.DCT_InvestigacionesUpdCtrlOk1 sJsonDatosEntrada: ' + sJsonDatosEntrada);
				DCT_InvestigacionesUpd_ctrl_rst.updInvestigaciones(sJsonDatosEntrada);
		    	
				//Manda llamar el metodo de ValidaDatos				
		    	objDatosEntrada.RazonSocial = 'NOMBRE';
		    	objDatosEntrada.Rfc = 'RFC';
		    	objDatosEntrada.TotalLineasAutorizadas = 5;
		    	objDatosEntrada.ClaveInvestigacion = 'ClaveInvestigacion';
		    	objDatosEntrada.EstatusInvestigacion = 'EstatusInvestigacion';
				sJsonDatosEntrada = JSON.serialize(objDatosEntrada);
				DCT_InvestigacionesUpd_ctrl_rst.DirComUpd = null;
				DCT_InvestigacionesUpd_ctrl_rst.lErrores = new List<DCT_InvestigacionesUpd_ctrl_rst.Error>();				
				System.debug('EN sJsonDatosEntrada DCT_InvestigacionesUpd_ctrl_tst.DCT_InvestigacionesUpdCtrlOk2 sJsonDatosEntrada: ' + sJsonDatosEntrada);				
				DCT_InvestigacionesUpd_ctrl_rst.updInvestigaciones(sJsonDatosEntrada);

				//Ve si se crearon los objetos para hacer el llamado
    		    System.assertNotEquals(objDatosEntrada, null);
    		    System.assertNotEquals(objResultadoSfdc, null);
				
			}//Fin si System.runAs(lUserGV.get(0))
		
		Test.stopTest();
    }
    
}