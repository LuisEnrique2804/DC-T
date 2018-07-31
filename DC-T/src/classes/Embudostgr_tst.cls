@isTest
private class Embudostgr_tst {
	
	@isTest static void test_method_one() 
	{
		Test.startTest();
			DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');
			User us=[Select id, ManagerId from user where id=:UserInfo.getUserId()];
			System.runAs(us){
				AprobadorIC__c apr=new AprobadorIC__c();
				apr.Aprobador__c='Inteligencia Competitiva';
				apr.Name='AprovIC';
				try{
					insert apr;
				}catch (exception ex){} 
			}
	
			list <Profile> lstPerfil             = new list <Profile>();
	        lstPerfil               = [SELECT Id, Name FROM Profile Where PermissionsCustomizeApplication = true ORDER BY CreatedDate ASC limit 1];
	        system.debug('datos Perfil '+lstPerfil);
	        
	        list <UserRole> lstRoles                = new list <UserRole>();
	        lstRoles                = [Select id,Name from UserRole where Name = 'DR9'];
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
	
	        System.runAs(us){
	         	
			Rentabilidad__c objrenta=new Rentabilidad__c();
			objrenta.Minimo__c=40;
			objrenta.Maximo__c=49;
			objrenta.Funcion__c='SD';
			objrenta.Name='SDProductividad';
			objrenta.PlataformaRent__c='Productividad';
			try{
				insert objrenta;
			}catch(exception ex){ }
	
			PlatApro__c objpa=new PlatApro__c();
			objpa.MinR9__c=5;
			objpa.MinR18__c=5;
			objpa.MinDAT__c=5;
			objpa.Aprobacion__c=false;
			objpa.Plataforma__c='Productividad';
			objpa.Name='Productividad';
			try {
				insert objpa;
			}catch (exception ex){ }
			
			Account actest=new Account();
			actest.Name='Test prueba';
			actest.Segmento__c='PyME';
			insert actest;
			
			Contact Objconta=new Contact();
			Objconta.AccountId=actest.id;
			Objconta.FirstName='Clase';
			Objconta.LastName='Prueba';
			Objconta.Title='Ingeniero';
			Objconta.Email='correo@telcel.com.mx';
			insert Objconta;
			
			Opportunity optest=new Opportunity();
			optest.AccountId=actest.id;
			optest.Amount=34000;
			optest.StageName='Oportunidad';
			optest.Name='OPT de pruebas';
			optest.CloseDate=System.today()+15;
			optest.Plataforma__c='Productividad';
			optest.Rentabilidad__c=34;
			optest.PendienteAprobacionRentabilidad__c=true;
			optest.OportunidadlenguajeCliente__c='Lenguaje del cliente';
			optest.Description='Prueba de clase de pruebas';
			insert optest;
	
			optest.Rentabilidad__c=43;
			optest.OportunidadlenguajeCliente__c='Prueba lenguaje';
			update optest;
	
			optest.Proyectolisto__c='Clase de ruebas';
			optest.AprobacionLenguajeCliente__c=false;
			optest.ValidaAprovIC__c=true;
			update optest;
	
			optest.Proyectolisto__c='Clase de ruebas';
			optest.AprobacionLenguajeCliente__c=false;
			optest.ValidaAprovIC__c=false;
			update optest;
	
			actest.Segmento__c='Corporativo';
			update actest;
	
			optest.FechaRIP__c=System.today();
			optest.StageName='Aproximación';
			optest.PersonaRIP__c=Objconta.id;
			update optest;
	
			optest.FechaRIP__c=System.today()+10;
			update optest;
	
			optest.FechacontactoP__c=System.today()+10;
			optest.StageName='Proyecto';
			optest.P__c=Objconta.id;
			update optest;
	
			optest.FechacontactoP__c=System.today()+2;
			update optest;
	
	
			optest.TipoPlataformaPropuesta__c='TIC';
			optest.PlataformaPropuesta__c='VOZ';
			optest.Nombrenuevaoportunidad__c='Nombre de clase de pruebas';
			optest.ObjetivoComercialPropuesta__c='Tener a la fuerza de venta localizada para asegurar la visita a los clientes.';
			optest.VoBoCierre__c='Aprobado';
			optest.StageName='Perdida';
			try {update optest;} catch(Exception ex){}
	
			Opportunity opt2=new Opportunity();
			opt2.AccountId=actest.id;
			opt2.Amount=34000;
			opt2.StageName='Oportunidad';
			opt2.Name='OPT de pruebas';
			opt2.CloseDate=System.today()+15;
			opt2.Plataforma__c='Productividad';
			opt2.Rentabilidad__c=43;
			opt2.PendienteAprobacionRentabilidad__c=true;
			opt2.OportunidadlenguajeCliente__c='Lenguaje del cliente';
			opt2.Description='Prueba de clase de pruebas';
			insert opt2;
		
			}
		Test.stopTest();
	}

}