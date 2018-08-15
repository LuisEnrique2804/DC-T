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
private class DCT_ProductosClientes_ctlr_tst {

	public static String VaRtAccountCorpo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Corporativo').getRecordTypeId();
	public static String VaRtAccountEmpre = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Empresarial').getRecordTypeId();  
	public static String VaRtAccountPyme = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel PyME').getRecordTypeId();
	public static String sRtPlan = Schema.SObjectType.DCTAuthorizedLines__c.getRecordTypeInfosByName().get('Plan').getRecordTypeId();
    public static String sRecdType = Schema.SObjectType.DCTAuthorizedLines__c.getRecordTypeInfosByName().get('Lineas Autorizadas').getRecordTypeId();
    
	public static String VaRtAccountProd = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Productos').getRecordTypeId();
	public static String VaRtAccountServTelCloudEmpre = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Servicios Telcel Cloud').getRecordTypeId();  
	public static String VaRtAccountSolCobro = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Soluciones de cobro').getRecordTypeId();

	@isTest(seeAllData = true)
    static void DCT_ProductosClientes_ctlr_OK() {

		Test.startTest();

			String sNomPerfUsrAdmin = 'Administrador del sistema';																		
			List<User > lUserAdmin = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrAdmin);			
			
			//Crea una clase para los objetos
			List<Account> lCliente = DCT_CreaObjetosTest_tst.CreaClienteC(1, VaRtAccountCorpo, lUserAdmin.get(0).id);
			List<Cliente__c> lDirCom = DCT_CreaObjetosTest_tst.CreaDirCom(1, lUserAdmin.get(0).id, lCliente.get(0));
			lDirCom.get(0).Cliente__c = lCliente.get(0).id;
			lDirCom.get(0).DCTRegion__c = 'R09';
			update lDirCom.get(0);
			List<DCTPlan__c > lPlanes = DCT_CreaObjetosTest_tst.CreaPlanes(1);
			List<DCTAuthorizedLines__c > lDCTAuthorizedLines = DCT_CreaObjetosTest_tst.CreaDCTAuthorizedLines(2, 
				lDirCom.get(0).id, sRecdType, '18 MESES', lUserAdmin.get(0).id);
			List<DCTAuthorizedLines__c > lDCTAuthorizedLinesPlanes = DCT_CreaObjetosTest_tst.CreaDCTAuthorizedLines(2, 
				lDirCom.get(0).id, sRtPlan, '18 MESES', lUserAdmin.get(0).id);
			lDCTAuthorizedLinesPlanes.get(0).Plan__c = lPlanes.get(0).id;				
			update lDCTAuthorizedLinesPlanes.get(0);			
			List<Product2> lProducto = DCT_CreaObjetosTest_tst.CreaProducto(2, VaRtAccountProd);
			List<DCTDirectoryProductRelationship__c> lDCTDirectoryProductRel = DCT_CreaObjetosTest_tst.CreaDCTDirectoryProductRel(1, 
				lProducto.get(0).id, lDirCom.get(0).id);
			List<DCTDirectoryProductRelationship__c> lDCTDirectoryProductRel2 = DCT_CreaObjetosTest_tst.CreaDCTDirectoryProductRel(1, 
				lProducto.get(1).id, lDirCom.get(0).id);
			List<DirectorioProducosSeleccionados__c> lDirectorioProducosSel = DCT_CreaObjetosTest_tst.CreaDirectorioProducosSel(2, 
				lProducto.get(0).id, lDirCom.get(0).id);
				
			//Actualiza el producto 2 y ponlo como especial
			lProducto.get(1).DCT_IsSpecialProduct__c = true;
			update lProducto.get(1);
			
			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserAdmin.get(0)){
				
				//Crea el objeto del tipo wrpProductoSelecionados
				DCT_Product_ctr.wrpProductoSelecionados objProdSel = new DCT_Product_ctr.wrpProductoSelecionados();
				DCT_Product_ctr.wrpProductoSelecionados objProdSel2 = new DCT_Product_ctr.wrpProductoSelecionados(lProducto.get(0), true);
				
				//Utiliza la pagina de DCT_AccountOwnerAssignment_pag
				PageReference pageRef = Page.DCT_Product_pag;
				/*//Unos parametros para que entre por el controlador estandar
				pageRef.getParameters().put('toToggleUserId', lUserGV.get(0).id);*/
				Test.setCurrentPage(pageRef);

		        // Instantiate a standard controller class with our contact
        		DCT_Product_ctr stdCon = new DCT_Product_ctr(new ApexPages.StandardController(lDirCom.get(0)));

        		//Consulta el producto creado
				stdCon.sProductoBusqueda = lProducto.get(0).Name;
				stdCon.buscaProducto();
				
				//Inicializa el objeto de  objWrpGrupoPlan ERR	
	    		DCT_TelcelPlanesMetodos_ws.wrpGrupoPlan objWrpGrupoPlan = new DCT_TelcelPlanesMetodos_ws.wrpGrupoPlan();
    			objWrpGrupoPlan.Estatus = 'ERR';
    			objWrpGrupoPlan.Descripcion = 'Read timed out';
				stdCon.objWrpGrupoPlan = objWrpGrupoPlan;
				stdCon.DespliegaCamposNuevoPlan();
				//Inicializa el objeto de  objWrpGrupoPlan OK
	    		DCT_TelcelPlanesMetodos_ws.wrpGrupoPlan objWrpGrupoPlan2 = new DCT_TelcelPlanesMetodos_ws.wrpGrupoPlan();
    			DCT_CorporativoPlanesWs.GrupoPlan objGrupoPlan = new DCT_CorporativoPlanesWs.GrupoPlan();
    			objGrupoPlan.ID = '123';
	    		objGrupoPlan.NOMBRE_GRUPO_PLAN = 'NOMBRE';
    			objWrpGrupoPlan2.lGrupoPlan = new List<DCT_CorporativoPlanesWs.GrupoPlan>{objGrupoPlan};
    			objWrpGrupoPlan2.Estatus = 'OK';
				stdCon.objWrpGrupoPlan = objWrpGrupoPlan2;
				stdCon.DespliegaCamposNuevoPlan();

				//Inicializa el objeto de  objwrpPlazo ERR
	    		DCT_TelcelPlanesMetodos_ws.wrpPlazo objwrpPlazo = new DCT_TelcelPlanesMetodos_ws.wrpPlazo();
    			objwrpPlazo.Estatus = 'ERR';
    			objwrpPlazo.Descripcion = 'Read timed out';
				stdCon.objwrpPlazo = objwrpPlazo;
				stdCon.actualizaPlazos();
				//Inicializa el objeto de  objwrpPlazo OK
	    		DCT_TelcelPlanesMetodos_ws.wrpPlazo objwrpPlazo2 = new DCT_TelcelPlanesMetodos_ws.wrpPlazo();
    			DCT_CorporativoPlanesWs.Plazo objPlazo = new DCT_CorporativoPlanesWs.Plazo();
    			objPlazo.ID = '123';
	    		objPlazo.DESCRIPCION = '18-MESES';
    			objwrpPlazo2.lPlazo = new List<DCT_CorporativoPlanesWs.Plazo>{objPlazo};
    			objwrpPlazo2.Estatus = 'OK';
				stdCon.objwrpPlazo = objwrpPlazo2;
				stdCon.actualizaPlazos();

				//Inicializa el objeto de  objwrpPlazo ERR
	    		DCT_TelcelPlanesMetodos_ws.wrpPlan objwrpPlan = new DCT_TelcelPlanesMetodos_ws.wrpPlan();
    			objwrpPlan.Estatus = 'ERR';
    			objwrpPlan.Descripcion = 'Read timed out';
				stdCon.objwrpPlan = objwrpPlan;
				stdCon.actualizaPlanes();
				//Inicializa el objeto de  objwrpPlan OK
	    		DCT_TelcelPlanesMetodos_ws.wrpPlan objwrpPlan2 = new DCT_TelcelPlanesMetodos_ws.wrpPlan();
    			DCT_CorporativoPlanesWs.Plan objPlan = new DCT_CorporativoPlanesWs.Plan();
    			objPlan.ID = '123';
	    		objPlan.DESCRIPCION = 'NOMBRE';
    			objwrpPlan2.lPlan = new List<DCT_CorporativoPlanesWs.Plan>{objPlan};
    			objwrpPlan2.Estatus = 'OK';
				stdCon.objwrpPlan = objwrpPlan2;
				stdCon.actualizaPlanes();
			
				stdCon.actualizaGuiaPlanes();
				stdCon.Tarifas();

				//Antes de guardar los datos					
				stdCon.validaTipoServ();
				stdCon.ValidaDatosEntrada();
				
				//Inicializa la lista de lwrpProductoSelecionados
				stdCon.lwrpProductoSelecionados = new List<DCT_Product_ctr.wrpProductoSelecionados>{objProdSel2};
				System.debug('EN DCT_ProductosClientes_ctlr_tst.DCT_ProductosClientes_ctlr_OK lwrpProductoSelecionados: ' + stdCon.lwrpProductoSelecionados);
				//Vamos a guardar los datos
				stdCon.saveProduct();
				
				//Inicializa los datos de entrada para los servicios
				stdCon.sGrupoPlan = objGrupoPlan.NOMBRE_GRUPO_PLAN;
				stdCon.sPlazos = '18 MESES';
				stdCon.sPlanes = 'PLAN AAA';
				stdCon.sTarifas = 'AAA';
				stdCon.mapGruposPlanes = new Map<String, DCT_CorporativoPlanesWs.GrupoPlan>{stdCon.sGrupoPlan => objGrupoPlan};
				stdCon.mapPlazos = new Map<String, DCT_CorporativoPlanesWs.Plazo>{stdCon.sPlazos => objPlazo};
				stdCon.mapPlanes = new Map<String, DCT_CorporativoPlanesWs.Plan>{stdCon.sPlanes => objPlan};

				//Crea el plan
				stdCon.savePlans();
				
				//Inicializa provId para de eliminar 
				stdCon.provId = lDirectorioProducosSel.get(0).id;
				stdCon.eliminarProducto();
				stdCon.watchField2();
				stdCon.cancelarNuevoPlan();
				stdCon.cancelarBusqueda();
				stdCon.refreshTable();
				
				//Ve si se crearon los objetos para hacer el llamado
	   		    System.assertNotEquals(objWrpGrupoPlan, null);
	   		    System.assertNotEquals(objWrpGrupoPlan2, null);
	   		    System.assertNotEquals(objwrpPlazo, null);
	   		    System.assertNotEquals(objwrpPlazo2, null);
	   		    System.assertNotEquals(objwrpPlan, null);
	   		    System.assertNotEquals(objwrpPlan2, null);
											
			}//Fin del System.runAs(lUserAdmin.get(0)
			
		Test.stopTest();    	

    	
    }
}