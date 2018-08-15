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
private class DCT_FolioSAP_tst {

    static testMethod void DCT_FolioSAPOK() {
    	
		Test.startTest();
			DCT_FolioSAP_ws objDCTFolioSAPWs = new DCT_FolioSAP_ws();
			DCT_FolioSAP_ws.respSalesforce objRespSalesforce = new DCT_FolioSAP_ws.respSalesforce();
			objRespSalesforce.error = true;
			objRespSalesforce.mensaje = 'mensaje';
			objRespSalesforce.folio = 'folio';
			
			//Llena los datos del arreglo
			String sDatosParaFolioSAP = '17537,MR09,IME030218UTA,ISBAN MEXICO SA DE CV,ISBAN MEXICO SA DE CV,,,,CAM 3,,0,42500,ACTOPAN,CA¥ADA CHICA ANTIGUA,,MX,HGOMEX,';
			DCT_FolioSAP_ws.getFolioSAP(sDatosParaFolioSAP, 'sUsuario', 'sPwd', 'Moral');
			DCT_FolioSAP_ws.getFolioSAP(sDatosParaFolioSAP, 'sUsuario', 'sPwd', 'Física');
			
			//Ve si se crearon los objetos para hacer el llamado
   		    System.assertNotEquals(objDCTFolioSAPWs, null);
   		    System.assertNotEquals(objRespSalesforce, null);			
		Test.stopTest();
		
    }
}