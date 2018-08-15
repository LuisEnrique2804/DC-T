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
private class DCT_CatalogoClavesVPN_tst {

	public static String VaRtAccountCorpo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Corporativo').getRecordTypeId();
	public static String VaRtAccountEmpre = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Empresarial').getRecordTypeId();  
	public static String VaRtAccountPyme = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel PyME').getRecordTypeId();

	@isTest(seeAllData = true)
    static void DCT_CatalogoClavesVPNOK() {
    	
		Test.startTest();

			List<ID> lIdProcess = new List<ID>();
		    ProcessInstanceWorkitem procesoActual;			
			String sNomPerfUsrJEC = 'JEC';
			String sNomPerfUsrGV = 'GV';
			String sNomPerfUsrCOOR = 'CoordinacionAdministrativa';
			String sNomPerfUsrAdmin = 'Administrador del sistema';			
															
			List<User > lUserAdmin = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrAdmin);																		
											
			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserAdmin.get(0)){
				System.debug('EN DCT_CatalogoClavesVPN_tst.DCT_CatalogoClavesVPNOK ENTRO A GENERAR LOS OBJETOS...');
				
				//Crea el objeto del tipo 				
				DCT_CatalogoClavesVPN_rst objDCTCatalogoClavesVPN = new DCT_CatalogoClavesVPN_rst();				
				DCT_CatalogoClavesVPN_rst.classRespuestaTelcel objClassRespuestaTelcel = new DCT_CatalogoClavesVPN_rst.classRespuestaTelcel();
				objClassRespuestaTelcel.productoVPNListField = new List<DCT_CatalogoClavesVPN_rst.listaProductosVPN>();
				objClassRespuestaTelcel.Message = 'Message';
				objClassRespuestaTelcel.ExceptionMessage = 'ExceptionMessage';
				objClassRespuestaTelcel.ExceptionType = 'ExceptionType';
				objClassRespuestaTelcel.StackTrace = 'StackTrace';
				
				DCT_CatalogoClavesVPN_rst.listaProductosVPN objListaProductosVPN = new DCT_CatalogoClavesVPN_rst.listaProductosVPN();
				objListaProductosVPN.productoField = new DCT_CatalogoClavesVPN_rst.DTOProductoField();
				
				DCT_CatalogoClavesVPN_rst.DTOProductoField objDTOProductoField = new DCT_CatalogoClavesVPN_rst.DTOProductoField();
				objDTOProductoField.costoField = 0.00;
				objDTOProductoField.descripcionField = 'descripcionField';
				objDTOProductoField.claveProductoField = 'claveProductoField';
																
				//Lama al metodo principal
				DCT_CatalogoClavesVPN_rst.getCatalogoClavesVPN('["9","CC"]');

				//Ve si se crearon los objetos para hacer el llamado
    		    System.assertNotEquals(objClassRespuestaTelcel, null);
    		    System.assertNotEquals(objListaProductosVPN, null);
    		    System.assertNotEquals(objDTOProductoField, null);    		    
				
			}//Fin si System.runAs(lUserAdmin.get(0))
			
		Test.stopTest();		

    }

}