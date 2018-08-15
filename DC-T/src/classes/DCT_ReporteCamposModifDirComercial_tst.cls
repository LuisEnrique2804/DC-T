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
private class DCT_ReporteCamposModifDirComercial_tst {

	public static String VaRtAccountCorpo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Corporativo').getRecordTypeId();
	public static String VaRtAccountEmpre = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Empresarial').getRecordTypeId();  
	public static String VaRtAccountPyme = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel PyME').getRecordTypeId();
	public static String sRtPlan = Schema.SObjectType.DCTAuthorizedLines__c.getRecordTypeInfosByName().get('Plan').getRecordTypeId();
    public static String sRecdType = Schema.SObjectType.DCTAuthorizedLines__c.getRecordTypeInfosByName().get('Lineas Autorizadas').getRecordTypeId();

	@isTest(seeAllData = true)
    static void DCT_ReporteCamposModifDirComercialBchOK() {
    	
		Test.startTest();

			List<ID> lIdProcess = new List<ID>();
		    ProcessInstanceWorkitem procesoActual;			
			String sNomPerfUsrJEC = 'JEC';
			String sNomPerfUsrGV = 'GV';
			String sNomPerfUsrCOOR = 'CoordinacionAdministrativa';
			String sNomPerfUsrAdmin = 'Administrador del sistema';			
															
			List<User > lUserAdmin = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrAdmin);																		

			String sClaveDistPaso = String.valueOf(Math.random());
			String sClaveDist = sClaveDistPaso.substring(12);
			System.debug('EN DCT_ReporteCamposModifDirComercial_tst.DCT_ReporteCamposModifDirComercialBchOK sClaveDist: ' + sClaveDist);
							
			List<DCTSalesForceCatalog__c> lDCTSalesForceCatalog = DCT_CreaObjetosTest_tst.CreaDCTSalesForceCatalog(2, 
				'EMPACADORA ABETO SA DE CV', 'ABETO', sClaveDist);

			//Crea una clase para los objetos
			List<Account> lCliente = DCT_CreaObjetosTest_tst.CreaClienteC(1, VaRtAccountCorpo, lUserAdmin.get(0).id);
			List<Cliente__c> lDirCom = DCT_CreaObjetosTest_tst.CreaDirCom(1, lUserAdmin.get(0).id, lCliente.get(0));			
			//lDirCom.get(0).DCT_CatalogoFuerzaVenta__c = lDCTSalesForceCatalog.get(0).id;
			//lDirCom.get(0).DCTCatalogoFuerzaVenta2__c = lDCTSalesForceCatalog.get(1).id;
			//update lDirCom.get(0);
			
			List<Contact > lContacto = DCT_CreaObjetosTest_tst.CreaContacto(1, lCliente.get(0).id);
			lContacto.get(0).Directorio_Comercial__c = lDirCom.get(0).id;
			lContacto.get(0).DCT_ContactoDirectorio__c = true;
			lContacto.get(0).PCT_IdExterno__c = null;
			update lContacto.get(0);			
			List<DCTPlan__c > lPlanes = DCT_CreaObjetosTest_tst.CreaPlanes(1);
			List<DCTAuthorizedLines__c > lDCTAuthorizedLines = DCT_CreaObjetosTest_tst.CreaDCTAuthorizedLines(2, 
				lDirCom.get(0).id, sRecdType, '18 MESES', lUserAdmin.get(0).id);
			List<DCTAuthorizedLines__c > lDCTAuthorizedLinesPlanes = DCT_CreaObjetosTest_tst.CreaDCTAuthorizedLines(2, 
				lDirCom.get(0).id, sRtPlan, '18 MESES', lUserAdmin.get(0).id);
			lDCTAuthorizedLinesPlanes.get(0).Plan__c = lPlanes.get(0).id;				
			update lDCTAuthorizedLinesPlanes.get(0);

			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserAdmin.get(0)){
				
				//Crea la consulta con los campos 
				String sQuery = ' Select 		RFC__c, RFC1__c, 		Name,				Grupo__r.Name,			Segmento__c,		Sector__c,	Subsector__c,	DCTKeyNISI__c,	';
				sQuery +=' DCTFiscalAddress__c,  DCTCorrespondenceAddress__c,		DCTAnticipatedAdendum__c,	DCTTermDays__c,	DCTBonusCustomization__c,	DCTCustomerFrom__c,	';
				sQuery +=' DCTAntiquity__c,		DCTBank__c,	DCTRapReference__c,		Tipocliente__c,		Estatus__c,		DCT_LegalPerson__c, DTC_LegalEntity__c,	';
				sQuery +=' DCTSocialReasonModified__c,		DCTDateRegistrationAdjudication__c,			DCTVIP__c,		DCTAVL__c,		DCTLegalRepresentative__c, DCTCatalogoFuerzaVenta2__r.Name, ';
				sQuery +=' DCTBenefits__c,					DCTRegistrationDate__c,		DCTLowDateAccuont__c,	DCTVPNActivation__c,		DCTBillingCycle__c,	DCT_CatalogoFuerzaVenta__r.Name, ';
				sQuery +=' DCTCreditClass__c,	DCTExemptBail__c,	DCTComments__c,		DCTSharedTreatment__c,	FuerzaVentaPrincipal__c, FuerzaVentaPrincipal__r.Name, FuerzaVentaSecundario__c, FuerzaVentaSecundario__r.Name, ';
				sQuery +=' DCTDistribuidorPrincipal__c, DCTDistribuidorSecundario__c,		DCTInplantName1__c, DCTInplantName2__c,		DCTInplantPhone1__c, DCTInplantPhone2__c,	';
				sQuery +=' DCTExt1__c, DCTExt2__c,		DCTInplantmobile1__c, DCTInplantmobile2__c,		DCTInplantEmail1__c, DCTInplantEmail2__c, DCT_CatalogoFuerzaVenta__c, DCTCatalogoFuerzaVenta2__c, ';
				sQuery +=' DCTInplantDate1__c,	DCTInplantDate2__c,		DCTResearchLegend__c,		DCTResultVerification__c,		DCTReasonRejection__c,	DCTInvestigation__c, ';
				sQuery +=' DCTCommentsInvestigation__c,	DCTAuthorizationDateVoBoManagement__c,	DCTTotLineasAutorInvest__c,	OwnerId, DCTServices1__c, DCTServices2__c, ';
				sQuery +=' (Select Plan__r.DescripcionGrupoPlan__c, Plan__r.ClaveTarifa__c, Plan__r.ClaveGrupoPlan__c,   Plan__r.DescripcionPlan__c, Plan__r.DCTTerm__c, ';
				sQuery +=' DCTSubdirector__r.Name, DCTAuthorizationDate__c, DCTActiveLines__c, DCTAuthorizedLines__c, Status__c, RecordType.Name, Plan__r.ClavePlan__c ';
				sQuery +=' From Lineas_Autorizadas__r ORDER BY DCT_ConsecutivoLineasAutorizadas__c), '; //Where RecordType.Name = \'Plan\'
				sQuery +=' (Select Name, Posicion__c, DCTTypeContact__c, MobilePhone, DCTNIP__c, Email, DCTReceiveInformation__c ';
				sQuery +=' From DirectorioComercial_Contactos__r Where DCT_ContactoDirectorio__c = true) ';
				
				//Si es una prueba
				sQuery += ' From Cliente__c ';
				sQuery += ' Where ';			
				sQuery += ' LastModifiedDate = TODAY ';
				sQuery += ' And ID = \''+ lDirCom.get(0).id +'\'';		
				sQuery += ' LIMIT 1';			

				System.debug('EN DCT_ReporteCamposModifDirComercial_tst.DCT_ReporteCamposModifDirComercialBchOK sQuery: ' + sQuery);
				
				DCT_ReporteCamposModifDirComercial_bch bchTest = new DCT_ReporteCamposModifDirComercial_bch(sQuery);
				Id batchInstanceId = Database.executeBatch( bchTest, 1);

				//Ve si se crearon los objetos para hacer el llamado
    		    //System.assertNotEquals(lCliente, null);
    		    //System.assertNotEquals(lDirCom, null);    		    

			}//Fin si System.runAs(lUserAdmin.get(0))
					
		Test.stopTest();		

    }
    
	@isTest(seeAllData = true)
    static void DCT_ReporteCamposModifDirComercialSchOK() {
    	
		Test.startTest();

			String sNomPerfUsrAdmin = 'Administrador del sistema';
			List<User > lUserAdmin = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrAdmin);
			
			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserAdmin.get(0)){
				System.debug('EN DCT_CommitDebtAccount_tst.DCT_CommitDebtAccountOK ENTRO A GENERAR LOS OBJETOS...');
				
				String CRON_EXP = '0 0 0 15 3 ? 2022';
				// Schedule the test job
				String jobId = System.schedule('DCT_ReporteCamposModifDirComercial_sch',
					CRON_EXP, 
					new DCT_ReporteCamposModifDirComercial_sch() );
				// Get the information from the CronTrigger API object
				CronTrigger ct = [SELECT Id FROM CronTrigger WHERE id = :jobId];

				//Ve si se crearon los objetos para hacer el llamado
    		    System.assertNotEquals(lUserAdmin, null);

			}//Fin si System.runAs(lUserAdmin.get(0))
					
		Test.stopTest();		

    }

}