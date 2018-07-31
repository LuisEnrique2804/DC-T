@isTest (SeeAllData = true)
private class EvaluarAlarmasSegOportunidad_tst {

    @isTest static void myUnitTest01() {
        
        test.startTest();
        	String					rtSO					= '';
			for(RecordType rt : [SELECT DeveloperName,Name,SobjectType FROM RecordType])
			{
				if (rt.SobjectType == 'SeguimientoOportunidades__c' && rt.developerName == 'Corporativo'){
					rtSO = rt.id;
				}
				
			}
        	
        	Account 								Cliente					= DataGenerator_cls.createAccount(true, 'Cliente Test', 'Corporativo', '');
			Contact 								Contacto 				= DataGenerator_cls.createContacto(true, Cliente.Id, 'CC01', 'DD01');
        	Opportunity 							Opp 					= DataGenerator_cls.createOpportunity(true, 'Opp Test', Cliente, Contacto, 'Oportunidad');
        	SeguimientoOportunidades__c 			objSO					= DataGenerator_cls.createSeguimientoOportunidad( true, Opp, rtSO);
        	List<SeguimientoOportunidades__c> scope = new List<SeguimientoOportunidades__c>();
        	scope.add(objSO);
        	
        	EvaluarAlarmasSegOportunidadBtch obj = new EvaluarAlarmasSegOportunidadBtch();
        	Database.BatchableContext BC;
	     	obj.start(BC); 		     
	     	obj.execute(BC, scope);      
	     	obj.finish(BC);  
        	
        test.stopTest();
        
    }
    
    
    @isTest static void myUnitTest02() {
        
        test.startTest();
        	EvaluarAlarmasSegOportunidades_Schdlb obj = new EvaluarAlarmasSegOportunidades_Schdlb();
        	SchedulableContext SC;
        	obj.execute(SC);
        test.stopTest();
        
    }
}