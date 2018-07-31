@isTest
private class UserTriggerHandler_Tst { 
	
	@isTest static void test_method_one() {
		Test.startTest();
			User us=[Select id, ManagerId from user where id=:UserInfo.getUserId()];
			list <Profile> lstPerfil             = new list <Profile>();
	        lstPerfil               = [SELECT Id, Name FROM Profile Where PermissionsCustomizeApplication = true ORDER BY CreatedDate ASC limit 1];
	        system.debug('datos Perfil '+lstPerfil);
	        
	        list <UserRole> lstRoles                = new list <UserRole>();
	        lstRoles                = [Select id,Name from UserRole where Name = 'GV 3 Corporativos'];
	        //ObjUsuario
	        User objUsuario = new User();
	        objUsuario.Alias = 'standt';
	        objUsuario.Email ='pruebas@test.com';
	        objUsuario.EmailEncodingKey = '';
	        objUsuario.LastName ='Testing';
	        objUsuario.LanguageLocaleKey ='en_US';
	        objUsuario.LocaleSidKey ='en_US'; 
	        objUsuario.ProfileId = lstPerfil.get(0).Id;
	        objUsuario.TimeZoneSidKey ='America/Los_Angeles';
	        objUsuario.UserName ='pruebas@test.com';
	        objUsuario.EmailEncodingKey ='UTF-8';
	        objUsuario.UserRoleId = lstRoles.get(0).Id; 
	        insert objUsuario;
	
	        
	        us.ManagerId=objUsuario.id;
	        update us;
		Test.stopTest();
	}

}