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
private class DCT_TelcelPlanesMetodos_tst {

	public static String VaRtAccountCorpo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Corporativo').getRecordTypeId();
	public static String VaRtAccountEmpre = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Empresarial').getRecordTypeId();  
	public static String VaRtAccountPyme = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel PyME').getRecordTypeId();

	@isTest(seeAllData = true)
    static void DCT_TelcelPlanesMetodos_OK() {
    	
		Test.startTest();

			String sNomPerfUsrAdmin = 'Administrador del sistema';																		
			List<User > lUserAdmin = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrAdmin);			
			
			//Crea una clase para los objetos
			List<Account> lCliente = DCT_CreaObjetosTest_tst.CreaClienteC(1, VaRtAccountCorpo, lUserAdmin.get(0).id);
			List<Cliente__c> lDirCom = DCT_CreaObjetosTest_tst.CreaDirCom(1, lUserAdmin.get(0).id, lCliente.get(0));
			lDirCom.get(0).Cliente__c = lCliente.get(0).id;
			lDirCom.get(0).DCTRegion__c = 'R09';
			update lDirCom.get(0);
			
			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserAdmin.get(0)){

				DCT_TelcelPlanesMetodos_ws.wrpGrupoPlan objWrpGrupoPlan = new DCT_TelcelPlanesMetodos_ws.wrpGrupoPlan();
				DCT_TelcelPlanesMetodos_ws.wrpGrupoPlan objWrpGrupoPlan2 
					= new DCT_TelcelPlanesMetodos_ws.wrpGrupoPlan(new List<DCT_CorporativoPlanesWs.GrupoPlan>(), 'Estatus'
					, 'Descripcion');
				DCT_TelcelPlanesMetodos_ws.ConsultarGruposPlanCorp();
				
				DCT_TelcelPlanesMetodos_ws.wrpPlazo objwrpPlazo = new DCT_TelcelPlanesMetodos_ws.wrpPlazo();
				DCT_TelcelPlanesMetodos_ws.wrpPlazo objwrpPlazo2 
					= new DCT_TelcelPlanesMetodos_ws.wrpPlazo(new List<DCT_CorporativoPlanesWs.Plazo>(), 
					'Estatus', 'Descripcion');
				DCT_TelcelPlanesMetodos_ws.ConsultarPlazosCorp();
				
				DCT_TelcelPlanesMetodos_ws.wrpPlan objWrpPlan = new DCT_TelcelPlanesMetodos_ws.wrpPlan();
				DCT_TelcelPlanesMetodos_ws.wrpPlan objWrpPlan2 
					= new DCT_TelcelPlanesMetodos_ws.wrpPlan(new List<DCT_CorporativoPlanesWs.Plan>(), 
					'Estatus', 'Descripcion');
				DCT_TelcelPlanesMetodos_ws.ConsultarPlanesCorp(123, 123);
				
				//Ve si se crearon los objetos para hacer el llamado
	   		    System.assertNotEquals(objWrpGrupoPlan, null);
	   		    System.assertNotEquals(objWrpGrupoPlan2, null);

	   		    System.assertNotEquals(objwrpPlazo, null);
	   		    System.assertNotEquals(objwrpPlazo2, null);

	   		    System.assertNotEquals(objWrpPlan, null);
	   		    System.assertNotEquals(objWrpPlan2, null);
											
			}//Fin del System.runAs(lUserAdmin.get(0)
			
		Test.stopTest();
    	
    }

}