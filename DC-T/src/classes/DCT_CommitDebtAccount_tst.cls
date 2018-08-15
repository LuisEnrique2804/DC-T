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
private class DCT_CommitDebtAccount_tst {

	public static String VaRtAccountCorpo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Corporativo').getRecordTypeId();
	public static String VaRtAccountEmpre = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Empresarial').getRecordTypeId();  
	public static String VaRtAccountPyme = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel PyME').getRecordTypeId();

	@isTest(seeAllData = true)
    static void DCT_CommitDebtAccountOK() {
    	
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
				
				//Un objeto del tipo Result 				 
				DCT_CommitDebtAccount_ws.Result objResult = new DCT_CommitDebtAccount_ws.Result();
				objResult.convertedIntoDebtAccount = false;
				objResult.isSuccessful = true;
				objResult.idSfdc = lUserAdmin.get(0).id; 
				objResult.errorList = new List<DCT_CommitDebtAccount_ws.Error>();

				//Un objeto del tipo Error
				DCT_CommitDebtAccount_ws.Error objError = new DCT_CommitDebtAccount_ws.Error('code', 'description');
				objError.code = 'code';
				objError.description = 'description';
				
				//Un objeto del tipo CommitDebtAccountArgsFolio				
				DCT_CommitDebtAccount_ws.CommitDebtAccountArgsFolio objDatosFolio = new DCT_CommitDebtAccount_ws.CommitDebtAccountArgsFolio();
				objDatosFolio.RFC = lCliente.get(0).RFC__c;
				objDatosFolio.Name = lCliente.get(0).Name;
				objDatosFolio.folio = lCliente.get(0).DCTFolio__c;				
				System.debug('EN DCT_CommitDebtAccount_tst.DCT_CommitDebtAccountOK objDatosFolio: ' + objDatosFolio);
			
				//Un objeto del tipo CommitDebtAccountArgsNisi
				DCT_CommitDebtAccount_ws.CommitDebtAccountArgsNisi objDatosNisi = new DCT_CommitDebtAccount_ws.CommitDebtAccountArgsNisi();
				objDatosNisi.NISI = lDirCom.get(0).RFC1__c;
				objDatosNisi.folio = lDirCom.get(0).DCTFolio__c;				
				System.debug('EN DCT_CommitDebtAccount_tst.DCT_CommitDebtAccountOK objDatosNisi: ' + objDatosNisi);
				
				//Un objeto del tipo initCleanUpMsgs
				DCT_CommitDebtAccount_ws.initCleanUpMsgs(); 
				//Llama al metodo commitDebtAccountFolio
				DCT_CommitDebtAccount_ws.commitDebtAccountFolio(objDatosFolio);
				//Llama al metodo commitDebtAccountFolio
				DCT_CommitDebtAccount_ws.commitDebtAccountNisi(objDatosNisi);
								
				//Ve si se crearon los objetos para hacer el llamado
    		    System.assertNotEquals(lCliente, null);
    		    System.assertNotEquals(lDirCom, null);
    		    System.assertNotEquals(objResult, null);								
    		    System.assertNotEquals(objDatosFolio, null);
    		    System.assertNotEquals(objDatosNisi, null);    		    
    		    								
			}//Fin si System.runAs(lUserAdmin.get(0))
					
		Test.stopTest();		

    }

	@isTest(seeAllData = true)
    static void DCT_CommitDebtAccountFolioError() {

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
				System.debug('EN DCT_CommitDebtAccount_tst.DCT_CommitDebtAccountOK ENTRO A GENERAR LOS OBJETOS...');
				
				//Un objeto del tipo Result 				 
				DCT_CommitDebtAccount_ws.Result objResult = new DCT_CommitDebtAccount_ws.Result();
				objResult.convertedIntoDebtAccount = false;
				objResult.isSuccessful = true;
				objResult.idSfdc = lUserAdmin.get(0).id; 
				objResult.errorList = new List<DCT_CommitDebtAccount_ws.Error>();

				//Un objeto del tipo Error
				DCT_CommitDebtAccount_ws.Error objError = new DCT_CommitDebtAccount_ws.Error('code', 'description');
				objError.code = 'code';
				objError.description = 'description';
				
				//Un objeto del tipo CommitDebtAccountArgsFolio				
				DCT_CommitDebtAccount_ws.CommitDebtAccountArgsFolio objDatosFolio = new DCT_CommitDebtAccount_ws.CommitDebtAccountArgsFolio();
				System.debug('EN DCT_CommitDebtAccount_tst.DCT_CommitDebtAccountOK objDatosFolio: ' + objDatosFolio);
			
				//Un objeto del tipo CommitDebtAccountArgsNisi
				DCT_CommitDebtAccount_ws.CommitDebtAccountArgsNisi objDatosNisi = new DCT_CommitDebtAccount_ws.CommitDebtAccountArgsNisi();
				System.debug('EN DCT_CommitDebtAccount_tst.DCT_CommitDebtAccountOK objDatosNisi: ' + objDatosNisi);
				
				//Un objeto del tipo initCleanUpMsgs
				DCT_CommitDebtAccount_ws.initCleanUpMsgs(); 
				//Llama al metodo commitDebtAccountFolio
				DCT_CommitDebtAccount_ws.commitDebtAccountFolio(objDatosFolio);
				//Llama al metodo commitDebtAccountFolio
				DCT_CommitDebtAccount_ws.commitDebtAccountNisi(objDatosNisi);
								
				//Ve si se crearon los objetos para hacer el llamado
    		    System.assertNotEquals(objResult, null);								
    		    System.assertNotEquals(objDatosFolio, null);
    		    System.assertNotEquals(objDatosNisi, null);    		    
    		    								
			}//Fin si System.runAs(lUserAdmin.get(0))
					
		Test.stopTest();
		
    }

}