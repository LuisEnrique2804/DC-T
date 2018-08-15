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
private class DCT_ConsultarDistribuidorPorClaveSch_tst {
	
	public static String VaRtAccountCorpo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Corporativo').getRecordTypeId();
	public static String VaRtAccountEmpre = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Empresarial').getRecordTypeId();  
	public static String VaRtAccountPyme = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel PyME').getRecordTypeId();

	@isTest(seeAllData = true)
    static void DCT_ConsultarDistribuidorPorClaveBchOK() {
    	
		Test.startTest();

			List<ID> lIdProcess = new List<ID>();
		    ProcessInstanceWorkitem procesoActual;			
			String sNomPerfUsrJEC = 'JEC';
			String sNomPerfUsrGV = 'GV';
			String sNomPerfUsrCOOR = 'CoordinacionAdministrativa';
			String sNomPerfUsrAdmin = 'Administrador del sistema';			
															
			List<User > lUserAdmin = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrAdmin);																		

			//Crea una clase para los objetos
			List<Account> lCliente = DCT_CreaObjetosTest_tst.CreaClienteC(1, VaRtAccountCorpo, lUserAdmin.get(0).id);
			List<Cliente__c> lDirCom = DCT_CreaObjetosTest_tst.CreaDirCom(1, lUserAdmin.get(0).id, lCliente.get(0));			
			System.debug('EN DCT_CommitDebtAccount_tst.DCT_CommitDebtAccountOK lCliente: ' + lCliente.get(0).DCTFolio__c);
			System.debug('EN DCT_CommitDebtAccount_tst.DCT_CommitDebtAccountOK lCliente: ' + lDirCom.get(0).DCTFolio__c);
						
			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserAdmin.get(0)){
				System.debug('EN DCT_CommitDebtAccount_tst.DCT_CommitDebtAccountOK ENTRO A GENERAR LOS OBJETOS...');
				
				//Crea el objeto del tipo listaFuerzaVentaDistTodo
				DCT_ConsultarDistribuidorPorClave_bch.listaFuerzaVentaDistTodo objPasoFzaVta = new DCT_ConsultarDistribuidorPorClave_bch.listaFuerzaVentaDistTodo();
				objPasoFzaVta.ErrorID = 'ErrorID';
				objPasoFzaVta.ErrorDescripcion = 'ErrorDescripcion';
				objPasoFzaVta.PrepagoSiapID = 0;
				objPasoFzaVta.EstatusID = 0;
				objPasoFzaVta.RazonSocial = 'RazonSocial';
				objPasoFzaVta.ClavePPAS = 'ClavePPAS';
				
				String sQuery = 'Select id From User Where isActive = true LIMIT 1';
				DCT_ConsultarDistribuidorPorClave_bch bchTest = new DCT_ConsultarDistribuidorPorClave_bch(sQuery);
				Id batchInstanceId = Database.executeBatch( bchTest, 1);

				//Ve si se crearon los objetos para hacer el llamado
    		    System.assertNotEquals(lCliente, null);
    		    System.assertNotEquals(lDirCom, null);    		    

			}//Fin si System.runAs(lUserAdmin.get(0))
					
		Test.stopTest();		

    }
    
	@isTest(seeAllData = true)
    static void DCT_ConsultarDistribuidorPorClaveSchOK() {
    	
		Test.startTest();

			String sNomPerfUsrAdmin = 'Administrador del sistema';
			List<User > lUserAdmin = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrAdmin);
			
			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserAdmin.get(0)){
				System.debug('EN DCT_CommitDebtAccount_tst.DCT_CommitDebtAccountOK ENTRO A GENERAR LOS OBJETOS...');
				
				String CRON_EXP = '0 0 0 15 3 ? 2022';
				// Schedule the test job
				String jobId = System.schedule('DCT_ConsultarDistribuidorPorClave_sch',
					CRON_EXP, 
					new DCT_ConsultarDistribuidorPorClave_sch() );
				// Get the information from the CronTrigger API object
				CronTrigger ct = [SELECT Id FROM CronTrigger WHERE id = :jobId];

				//Ve si se crearon los objetos para hacer el llamado
    		    System.assertNotEquals(lUserAdmin, null);

			}//Fin si System.runAs(lUserAdmin.get(0))
					
		Test.stopTest();		

    }

}