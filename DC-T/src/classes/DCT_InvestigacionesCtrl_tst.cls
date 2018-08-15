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
private class DCT_InvestigacionesCtrl_tst {

	public static String VaRtAccountCorpo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Corporativo').getRecordTypeId();
	public static String VaRtAccountEmpre = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Empresarial').getRecordTypeId();  
	public static String VaRtAccountPyme = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel PyME').getRecordTypeId();
	public static String sRtPlan = Schema.SObjectType.DCTAuthorizedLines__c.getRecordTypeInfosByName().get('Plan').getRecordTypeId();
    public static String sRecdType = Schema.SObjectType.DCTAuthorizedLines__c.getRecordTypeInfosByName().get('Lineas Autorizadas').getRecordTypeId();

	@isTest(seeAllData = true)
    static void DCT_InvestigacionesCtrlOk() {

		Test.startTest();

			String sNomPerfUsrAdmin = 'Administrador del sistema';																		
			List<User > lUserAdmin = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrAdmin);			
			
			//Crea una clase para los objetos
			List<Account> lCliente = DCT_CreaObjetosTest_tst.CreaClienteC(1, VaRtAccountCorpo, lUserAdmin.get(0).id);
			List<Cliente__c> lDirCom = DCT_CreaObjetosTest_tst.CreaDirCom(1, lUserAdmin.get(0).id, lCliente.get(0));
			List<DCTPlan__c > lPlanes = DCT_CreaObjetosTest_tst.CreaPlanes(1);
			List<DCTAuthorizedLines__c > lDCTAuthorizedLines = DCT_CreaObjetosTest_tst.CreaDCTAuthorizedLines(2, 
				lDirCom.get(0).id, sRecdType, '18 MESES', lUserAdmin.get(0).id);
			List<DCTAuthorizedLines__c > lDCTAuthorizedLinesPlanes = DCT_CreaObjetosTest_tst.CreaDCTAuthorizedLines(2, 
				lDirCom.get(0).id, sRtPlan, '18 MESES', lUserAdmin.get(0).id);
			lDCTAuthorizedLinesPlanes.get(0).Plan__c = lPlanes.get(0).id;				
			update lDCTAuthorizedLinesPlanes.get(0);
						
			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserAdmin.get(0)){
				
				//Utiliza la pagina de DCT_AccountOwnerAssignment_pag
				PageReference pageRef = Page.DCT_Investigaciones_pag;
				/*//Unos parametros para que entre por el controlador estandar
				pageRef.getParameters().put('toToggleUserId', lUserGV.get(0).id);*/
				Test.setCurrentPage(pageRef);

		        // Instantiate a standard controller class with our contact
        		DCT_InvestigacionesCtrl stdCon = new DCT_InvestigacionesCtrl(new ApexPages.StandardController(lDirCom.get(0)));
				stdCon.procesoPendiente(lDirCom.get(0).id);
				stdCon.NuevaLinea();
				System.debug('EN DCT_InvestigacionesCtrl_tst.DCT_InvestigacionesCtrlOk Clave__c: ' + lDCTAuthorizedLinesPlanes.get(0).Clave__c);
				stdCon.sPlanesDirCom = lDCTAuthorizedLinesPlanes.get(0).Clave__c;
				stdCon.dctNuevaLinea.DCTAuthorizedLines__c = 10;
				stdCon.actualizaPlazo();
				stdCon.obtenAprobador(stdCon.dctNuevaLinea);
				
				//Actualiza el dato del plan
				lDirCom.get(0).DCTAskAuthorization__c = true;
				update lDirCom.get(0);
				
				//Llama a generaProcesoAproba
				stdCon.generaProcesoAproba();
				stdCon.GuardarNuavLinea();
				
				//Limíía el objeto de la nueva Liena stdCon.dctNuevaLinea.DCTAuthorizedLines__c = 10;
				DCTAuthorizedLines__c objDCTAuthorizedLines = new DCTAuthorizedLines__c();
				stdCon.dctNuevaLinea = objDCTAuthorizedLines;
				System.debug('EN DCT_InvestigacionesCtrl_tst.DCT_InvestigacionesCtrlOk dctNuevaLinea: ' + stdCon.dctNuevaLinea);
				stdCon.Cancelar();
				stdCon.ValidaDatosLinea();
				stdCon.ValidaDatosProceso();
				stdCon.fullRefresh();
								
				//Ve si se crearon los objetos para hacer el llamado
    		    System.assertNotEquals(lCliente, null);
    		    System.assertNotEquals(lDirCom, null);
    		    System.assertNotEquals(lPlanes, null);
    		    System.assertNotEquals(lDCTAuthorizedLines, null);
    		    System.assertNotEquals(lDCTAuthorizedLinesPlanes, null);    		    
				
			}//Fin si System.runAs(lUserGV.get(0))		
		
		Test.stopTest();
		
    }
}