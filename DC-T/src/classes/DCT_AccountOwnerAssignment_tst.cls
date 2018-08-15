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
private class DCT_AccountOwnerAssignment_tst {

	public static String VaRtAccountCorpo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Corporativo').getRecordTypeId();
	public static String VaRtAccountEmpre = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Empresarial').getRecordTypeId();  
	public static String VaRtAccountPyme = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel PyME').getRecordTypeId();
		
	@isTest(seeAllData = true)
	static void DCT_AccountOwnerAssignmentOK() {	
		
		Test.startTest();

			String sNomPerfUsrJEC = 'JEC';
			String sNomPerfUsrGV = 'GV';
			String sNomPerfUsrCOOR = 'CoordinacionAdministrativa';
															
			List<User > lUserJEC = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrJEC);															
			List<User > lUserGV = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrGV);
			List<User > lUserCOOR = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrCOOR);
			
			//Crea una clase para los objetos
			List<Account> lCliente = DCT_CreaObjetosTest_tst.CreaClienteC(1, VaRtAccountCorpo, lUserGV.get(0).id);

			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserGV.get(0)){
								
				//Utiliza la pagina de DCT_AccountOwnerAssignment_pag
				PageReference pageRef = Page.DCT_AccountOwnerAssignment_pag;
				//Unos parametros para que entre por el controlador estandar
				pageRef.getParameters().put('toToggleUserId', lUserGV.get(0).id);
				pageRef.getParameters().put('toToggleNivel', lUserCOOR.get(0).id);				
				pageRef.getParameters().put('toSelectDeselAllAccsUserId', lUserGV.get(0).id);
				pageRef.getParameters().put('selectedRightUser', lUserGV.get(0).id);
				Test.setCurrentPage(pageRef);
						
				//Crea el controlador para la clase DCT_AccountOwnerAssignment_cls
				DCT_AccountOwnerAssignment_cls ctrl = new DCT_AccountOwnerAssignment_cls();

				//Los objetos de tipo wrp para la clase
				ctrl.getAccWrapperList(new List<Account>{lCliente.get(0)});
				
				//Empieza a llamar a los meodos
				ctrl.strSelectedUserId = lUserGV.get(0).id; 
				ctrl.sIdUserActual = lUserGV.get(0).id;
				ctrl.setUsrCoord = new Set<String>{lUserCOOR.get(0).id};
				//Llama el metodo de getDatosUsuario
				ctrl.getDatosUsuario(lUserGV.get(0).id);
				ctrl.getPerfilUsuario(lUserGV.get(0).id);
				ctrl.getGestorGvCa(lUserGV.get(0).ManagerId, false);
				ctrl.goToLookUpUI();
				ctrl.fillAccountsByOwnerMap(lUserGV.get(0).id, true);				
				ctrl.searchUsers();
				ctrl.commitUserSelection();				
				ctrl.fillAccountsByOwnerMapGerente(lUserGV.get(0).id, true);
				ctrl.fillAccountsByOwnerMapCoordinador(lUserCOOR.get(0).id, false);
				ctrl.toggleLeftUserAccs();						
				
				//Inicializa ctrl.mapFinalOwnersAndAccounts
				ctrl.mapFinalOwnersAndAccounts = new Map<String,DCT_AccountOwnerAssignment_cls.AccountsByOwnerWrapper>();
				//Un objeto del tipo AccountsByOwnerWrapper
				DCT_AccountOwnerAssignment_cls.AccountsByOwnerWrapper accsByWrapperInstance 
					= new DCT_AccountOwnerAssignment_cls.AccountsByOwnerWrapper();
				DCT_AccountOwnerAssignment_cls.AccountWrapper objAccountWrapper 
					= new DCT_AccountOwnerAssignment_cls.AccountWrapper(lCliente.get(0), false, String.valueOf(Date.today()));	
                accsByWrapperInstance.lstAccs = new List<DCT_AccountOwnerAssignment_cls.AccountWrapper>{objAccountWrapper};
                accsByWrapperInstance.ownerRecord = lUserGV.get(0);
                accsByWrapperInstance.blnselectAllAccs = false;
                accsByWrapperInstance.blnSelectedForAssignment = false;
                accsByWrapperInstance.blnDisplayAccounts = false;
                accsByWrapperInstance.subordinados = new List<DCT_AccountOwnerAssignment_cls.AccountsByOwnerWrapper>();
                accsByWrapperInstance.bMuestraNivelSuperiror = false;
				
				//Agrega al usuario al mapa de ctrl.mapFinalOwnersAndAccounts  
				ctrl.mapFinalOwnersAndAccounts.put(lUserGV.get(0).id, accsByWrapperInstance);
				System.debug('EN DCT_AccountOwnerAssignmentOK ctrl.mapFinalOwnersAndAccounts: ' + ctrl.mapFinalOwnersAndAccounts.KeySet());				
				ctrl.mapFinalOwnersAndAccounts.get(lUserGV.get(0).id).subordinados = new List<DCT_AccountOwnerAssignment_cls.AccountsByOwnerWrapper>{accsByWrapperInstance};
				
				//Llama toggleRightUserAccs
				ctrl.toggleRightUserAccs();
				ctrl.selectDeselectAllLeft();
				//Llama a selectDeselectAllRight
				ctrl.selectDeselectAllRight();
				
				ctrl.validateWhetherIsPossibleToStart();
				ctrl.selectUser();
				ctrl.assignSelectedRightUser();
				ctrl.moveToRight();
				ctrl.moveToLeft();
				ctrl.validaGestorGestores(lUserGV.get(0).id);
				
				//un objeto del tipo AccountWrapper
				DCT_AccountOwnerAssignment_cls.AccountWrapper objAccountWrapper2 
					= new DCT_AccountOwnerAssignment_cls.AccountWrapper(lCliente.get(0), false, String.valueOf(Date.today()));	
				//un objeto del tipo AccountWrapperAssignForUsers
				DCT_AccountOwnerAssignment_cls.AccountWrapperAssignForUsers objAccountWrapperAssignForUsers 
					= new DCT_AccountOwnerAssignment_cls.AccountWrapperAssignForUsers(objAccountWrapper2, lUserGV.get(0).id, 
						lUserGV.get(0).id, VaRtAccountCorpo);
				objAccountWrapperAssignForUsers.blnGeneraProcesoAproba = true;
				objAccountWrapperAssignForUsers.sIdUsrAprueba = lUserGV.get(0).id;
				objAccountWrapperAssignForUsers.sTipoRegPCT = 'Corporativo';
				//Llena el mapa de mapUsrSelForAssig para hacer la confirmación de datos
				ctrl.mapUsrSelForAssig = new Map<String, Map<String, DCT_AccountOwnerAssignment_cls.AccountWrapperAssignForUsers>>{lUserGV.get(0).id => new Map<String, DCT_AccountOwnerAssignment_cls.AccountWrapperAssignForUsers>{lCliente.get(0).id => objAccountWrapperAssignForUsers}};
				System.debug('EN DCT_AccountOwnerAssignmentOK ANTES DE confirmAssignment() ctrl.mapUsrSelForAssig: ' + ctrl.mapUsrSelForAssig);				
				
				//Confirma los cambios
				ctrl.confirmAssignment();
				
				//Los metodos finales
				ctrl.returnToMain();
				ctrl.fullRefresh();
				
			}//Fin si System.runAs(lUserGV.get(0))
		
		Test.stopTest();
		
    }

}