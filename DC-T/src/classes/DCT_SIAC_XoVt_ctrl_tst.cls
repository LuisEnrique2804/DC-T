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
private class DCT_SIAC_XoVt_ctrl_tst {

	public static String VaRtAccountCorpo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Corporativo').getRecordTypeId();
	public static String VaRtAccountEmpre = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Empresarial').getRecordTypeId();  
	public static String VaRtAccountPyme = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel PyME').getRecordTypeId();

	@isTest(seeAllData = true)
    static void DCT_SIAC_XoVt_ctrl_OK() {
		
		Test.startTest();

			String sNomPerfUsrAdmin = 'Administrador del sistema';																		
			List<User > lUserAdmin = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrAdmin);			
			
			//Crea una clase para los objetos
			List<Account> lCliente = DCT_CreaObjetosTest_tst.CreaClienteC(1, VaRtAccountCorpo, lUserAdmin.get(0).id);
			List<Cliente__c> lDirCom = DCT_CreaObjetosTest_tst.CreaDirCom(1, lUserAdmin.get(0).id, lCliente.get(0));
			lDirCom.get(0).Cliente__c = lCliente.get(0).id;
			update lDirCom.get(0);
			
			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserAdmin.get(0)){

				DCT_SIAC_XoVt_ctrl_rst.DatosEntrada objDatosEntrada = new DCT_SIAC_XoVt_ctrl_rst.DatosEntrada();			
				DCT_SIAC_XoVt_ctrl_rst.ResultRfcNomReg objResultRfcNomReg = new DCT_SIAC_XoVt_ctrl_rst.ResultRfcNomReg();
				DCT_SIAC_XoVt_ctrl_rst.ResultRfcTipoReg objResultRfcTipoReg = new DCT_SIAC_XoVt_ctrl_rst.ResultRfcTipoReg();
				DCT_SIAC_XoVt_ctrl_rst.Error objError = new DCT_SIAC_XoVt_ctrl_rst.Error('code', 'description');
				
				//Valida los metodos de validateInputsRfcReg y validateInputsRfcNombreReg
				DCT_SIAC_XoVt_ctrl_rst.lErrores = new List<DCT_SIAC_XoVt_ctrl_rst.Error>();
				DCT_SIAC_XoVt_ctrl_rst.validateInputsRfcReg(null, null);
				DCT_SIAC_XoVt_ctrl_rst.validateInputsRfcNombreReg(null, null, null);
				
				//Inicializa los datos del objeto objDatosEntrada
				objDatosEntrada.RazonSocial = 'RazonSocial';
				objDatosEntrada.Region = 'Region';
				objDatosEntrada.Rfc = 'Rfc';
				objDatosEntrada.TipoConsulta = 0;
				//Serializa 
				String sJsonResp = JSON.serialize(objDatosEntrada);
				//Llama el metodo JSONParserEntrada
				DCT_SIAC_XoVt_ctrl_rst.JSONParserEntrada(sJsonResp);
				
				//Muy bien llama al metodo siacXoVtRfcRegion
				DCT_SIAC_XoVt_ctrl_rst.redireccionaConsulta(sJsonResp);
				
				Cliente__c ClienteCons = new Cliente__c();
				for (Cliente__c DirCom : [Select id, Name, RFC1__c from Cliente__c Where id =:lDirCom.get(0).id]){
					//System.debug('EN DCT_SIAC_XoVt_ctrl_tst.DCT_SIAC_XoVt_ctrl_OK DirCom: ' + DirCom);
					ClienteCons = DirCom;
				}
				System.debug('EN DCT_SIAC_XoVt_ctrl_tst.DCT_SIAC_XoVt_ctrl_OK ClienteCons: ' + ClienteCons);
									
				//Manda la consulta siacXoVtRfcNomRegion
				DCT_SIAC_XoVt_ctrl_rst.siacXoVtRfcNomRegion(ClienteCons.RFC1__c, ClienteCons.Name, 'R09');
				DCT_SIAC_XoVt_ctrl_rst.siacXoVtRfcRegion(ClienteCons.RFC1__c, 'R09');

				//Ve si se crearon los objetos para hacer el llamado
	   		    System.assertNotEquals(objDatosEntrada, null);
	   		    System.assertNotEquals(objResultRfcNomReg, null);
	   		    System.assertNotEquals(sJsonResp, null);
	   		    			
			}//Fin del System.runAs(lUserAdmin.get(0)
			
		Test.stopTest();
		
    }
}