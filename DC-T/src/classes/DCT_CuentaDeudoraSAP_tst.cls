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
private class DCT_CuentaDeudoraSAP_tst {

    static testMethod void DCT_CuentaDeudoraSAPOk() {
    	Test.startTest();
			DCT_CuentaDeudoraSAP.RegistraCtaDeudora objRegistraCtaDeudora = new DCT_CuentaDeudoraSAP.RegistraCtaDeudora();
			DCT_CuentaDeudoraSAP.RegistraCtaDeudoraResponse objRegistraCtaDeudoraResponse = new DCT_CuentaDeudoraSAP.RegistraCtaDeudoraResponse();
			DCT_CuentaDeudoraSAP.SapCtaDeudoraWSPort objSapCtaDeudoraWSPort = new DCT_CuentaDeudoraSAP.SapCtaDeudoraWSPort();
			objSapCtaDeudoraWSPort.RegistraCtaDeudora('usuario', 'password', 'xmlConsultaStock');
			
			//Ve si se crearon los objetos para hacer el llamado
   		    System.assertNotEquals(objRegistraCtaDeudora, null);
   		    System.assertNotEquals(objRegistraCtaDeudoraResponse, null);
   		    System.assertNotEquals(objSapCtaDeudoraWSPort, null);
		Test.stopTest();
    }
}