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
private class DCT_ContactosDirectorioCtrl_tst {

	public static String VaRtAccountCorpo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Corporativo').getRecordTypeId();
	public static String VaRtAccountEmpre = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Empresarial').getRecordTypeId();  
	public static String VaRtAccountPyme = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel PyME').getRecordTypeId();

	@isTest(seeAllData = true)
    static void DCT_ContactosDirectorioCtrlOK() {
		Test.startTest();

			String sNomPerfUsrAdmin = 'Administrador del sistema';																		
			List<User > lUserAdmin = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrAdmin);			
			
			//Crea una clase para los objetos
			List<Account> lCliente = DCT_CreaObjetosTest_tst.CreaClienteC(1, VaRtAccountCorpo, lUserAdmin.get(0).id);
			List<Cliente__c> lDirCom = DCT_CreaObjetosTest_tst.CreaDirCom(1, lUserAdmin.get(0).id, lCliente.get(0));			
			List<Contact > lContacto = DCT_CreaObjetosTest_tst.CreaContacto(1, lCliente.get(0).id);
			lContacto.get(0).Directorio_Comercial__c = lDirCom.get(0).id;
			lContacto.get(0).DCT_ContactoDirectorio__c = true;
			lContacto.get(0).PCT_IdExterno__c = null;
			update lContacto.get(0);
			
			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserAdmin.get(0)){
				
				//Utiliza la pagina de DCT_AccountOwnerAssignment_pag
				PageReference pageRef = Page.DCT_ContactosDirectorio_pag;
				/*//Unos parametros para que entre por el controlador estandar
				pageRef.getParameters().put('toToggleUserId', lUserGV.get(0).id);*/
				Test.setCurrentPage(pageRef);

		        // Instantiate a standard controller class with our contact
        		DCT_ContactosDirectorioCtrl stdCon = new DCT_ContactosDirectorioCtrl(new ApexPages.StandardController(lContacto.get(0)));
				stdCon.ConsultaContactosDirectorio(lDirCom.get(0).id);
				
				//Ve si se crearon los objetos para hacer el llamado
    		    System.assertNotEquals(lCliente, null);
    		    System.assertNotEquals(lContacto, null);    		    		
				
			}//Fin si System.runAs(lUserGV.get(0))
			
		Test.stopTest();
    }
}