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
private class DCT_CorporativoPlanesWs_tst {

    static testMethod void DCT_CorporativoPlanesWsOk() {
		Test.startTest();
			DCT_CorporativoPlanesWs.Plazo objPlazo = new DCT_CorporativoPlanesWs.Plazo();
			DCT_CorporativoPlanesWs.ObtenerPlazoResponse_element obtPlazoResp = new DCT_CorporativoPlanesWs.ObtenerPlazoResponse_element();		
			DCT_CorporativoPlanesWs.GrupoPlanSalida ObtGrupoSalida = new DCT_CorporativoPlanesWs.GrupoPlanSalida();		
			DCT_CorporativoPlanesWs.ObtenerGrupoPlanResponse_element obtGrupoPlanResp = new DCT_CorporativoPlanesWs.ObtenerGrupoPlanResponse_element();		
			DCT_CorporativoPlanesWs.ObtenerPlanResponse_element obtPlanResp = new DCT_CorporativoPlanesWs.ObtenerPlanResponse_element();		
			DCT_CorporativoPlanesWs.GrupoPlan obtGrupoPlan = new DCT_CorporativoPlanesWs.GrupoPlan();		
			DCT_CorporativoPlanesWs.PlanSalida obtPlanSalida = new DCT_CorporativoPlanesWs.PlanSalida();		
			DCT_CorporativoPlanesWs.ArrayOfPlan obtArrayOfPlan = new DCT_CorporativoPlanesWs.ArrayOfPlan();
			DCT_CorporativoPlanesWs.Plan objPlan = new DCT_CorporativoPlanesWs.Plan();
			DCT_CorporativoPlanesWs.ArrayOfGrupoPlan objArrayOfGrupoPlan = new DCT_CorporativoPlanesWs.ArrayOfGrupoPlan();		
			DCT_CorporativoPlanesWs.PlazoSalida objPlazoSalida = new DCT_CorporativoPlanesWs.PlazoSalida();		
			DCT_CorporativoPlanesWs.ObtenerPlazo_element objObtenerPlazo = new DCT_CorporativoPlanesWs.ObtenerPlazo_element();		
			DCT_CorporativoPlanesWs.ObtenerGrupoPlan_element objGrupoPlanElem = new DCT_CorporativoPlanesWs.ObtenerGrupoPlan_element();
			DCT_CorporativoPlanesWs.ArrayOfPlazo objArrayOfPlazo = new DCT_CorporativoPlanesWs.ArrayOfPlazo();		
			DCT_CorporativoPlanesWs.ObtenerPlan_element objObtenerPlanElem = new DCT_CorporativoPlanesWs.ObtenerPlan_element();
			DCT_CorporativoPlanesWs objDCTCorporativoPlanesWs = new DCT_CorporativoPlanesWs();
			DCT_CorporativoPlanesWs.Corporativo_WServiceSoap objCorpWser = new DCT_CorporativoPlanesWs.Corporativo_WServiceSoap();
			objCorpWser.ObtenerGrupoPlan();
			objCorpWser.ObtenerPlazo();
			objCorpWser.ObtenerPlan(123, 123);
		Test.stopTest();
    }
}