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
private class DCT_WebServiceException_tst {

    static testMethod void DCT_WebServiceException_OK() {
		
		Test.startTest();

			String sNomPerfUsrAdmin = 'Administrador del sistema';																		
			List<User > lUserAdmin = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrAdmin);			
						
			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserAdmin.get(0)){

				DCT_WebServiceException objDCTWebServiceException 
					= new DCT_WebServiceException(new EndpointSetting__mdt(), 
					'message', 'strRequest', 'strResponse');
								
				//Ve si se crearon los objetos para hacer el llamado
	   		    System.assertNotEquals(objDCTWebServiceException, null);
											
			}//Fin del System.runAs(lUserAdmin.get(0)
			
		Test.stopTest();		
		
    }
}