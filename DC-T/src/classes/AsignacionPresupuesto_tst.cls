@isTest (SeeAllData = true)
private class AsignacionPresupuesto_tst {
	
	@isTest static void test_method_one() {
		test.startTest();
			// Implement test code
			User us=[Select id, ManagerId from user where id=:UserInfo.getUserId()];
	
			list <Profile> lstPerfil             = new list <Profile>();
	        lstPerfil               = [SELECT Id, Name FROM Profile Where PermissionsCustomizeApplication = true ORDER BY CreatedDate ASC limit 1];
	        system.debug('datos Perfil '+lstPerfil);
	        
	        list <UserRole> lstRoles                = new list <UserRole>();
	        lstRoles                = [Select id,Name from UserRole where Name = 'GV 3 Corporativos'];
			Presupuesto__c psv =new Presupuesto__c();
	        psv.Mes__c='Enero';
			psv.JEC__c=UserInfo.getUserId();
			psv.Anio__c='2015';
			psv.LlavePresupuesto__c=UserInfo.getUserId()+'Enero'+'2015';
			psv.ownerID=UserInfo.getUserId();
			insert psv;
			 Date myDate2=Date.today();
	
			Presupuesto__c psv2 =new Presupuesto__c();
	        psv2.Mes__c='Enero';
			psv2.JEC__c=UserInfo.getUserId();
			psv2.Anio__c=String.valueOf(myDate2.year());
			psv2.LlavePresupuesto__c=UserInfo.getUserId()+'Enero'+String.valueOf(myDate2.year());
			psv2.ownerID=UserInfo.getUserId();
			insert psv2;
			
			AsignacionPresupuesto_ctr.WrapperUS objWUS = new AsignacionPresupuesto_ctr.WrapperUS(new User(), false);
			objWUS.seleccionado = false;
			objWUS.us = new User(); 
	
			AsignacionPresupuesto_ctr crmp=new AsignacionPresupuesto_ctr( new ApexPages.StandardController(psv));
			Date myDate=Date.newInstance(1990, 11, 21);
			crmp.getOptionanios(myDate);
			crmp.anio=String.valueOf(myDate2.year());
			crmp.wrapreLleno(UserInfo.getUserId(), new List<String>{'Enero','Febrero','Marzo'});
			crmp.getPageSize();
	
			crmp.action_seleccionarTodos();
			crmp.createWraper('Julio');
			AsignacionPresupuesto_ctr.WrapperPresupuesto wpr=new AsignacionPresupuesto_ctr.WrapperPresupuesto(psv,'Mayo');
			wpr.strAno=String.valueOf(myDate2.year());
			
			crmp.siguente();
			for(AsignacionPresupuesto_ctr.WrapperUS wu:crmp.listUser)
			{
				wu.seleccionado=true;
			}
			crmp.siguente();
	
			crmp.guardar();
	
			/*for(AsignacionPresupuesto_ctr.WrapperPresupuesto wp : crmp.lstwraPre)
			{
				wp.objPresupuesto.DAT__c = 0.0;
			}*/
			crmp.guardar();
		
		test.stopTest();

	}
	
	@isTest static void test_method_two() {
		test.startTest();
			Date myDate2=Date.today();
			User us=[Select id, ManagerId from user where id=:UserInfo.getUserId()];
	
			list <Profile> lstPerfil             = new list <Profile>();
	        lstPerfil               = [SELECT Id, Name FROM Profile Where PermissionsCustomizeApplication = true ORDER BY CreatedDate ASC limit 1];
	        system.debug('datos Perfil '+lstPerfil);
	        
	        list <UserRole> lstRoles                = new list <UserRole>();
	        lstRoles                = [Select id,Name from UserRole where Name = 'GV 3 Corporativos'];
			Presupuesto__c psv2 =new Presupuesto__c();
	        psv2.Mes__c='Enero';
			psv2.JEC__c=UserInfo.getUserId();
			psv2.Anio__c=String.valueOf(myDate2.year());
			psv2.LlavePresupuesto__c=UserInfo.getUserId()+'Enero'+String.valueOf(myDate2.year());
			psv2.ownerID=UserInfo.getUserId();
			insert psv2;
		test.stopTest();
	}
	
}