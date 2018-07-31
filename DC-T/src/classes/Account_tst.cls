@IsTest (SeeAllData = true)
public class Account_tst {
    @isTest static void AccountTest(){
    	test.startTest();
	        Account objAccount = DataGenerator_cls.createAccount( true, 'Test Acount', 'Corporativo', '');
	 		Contact                 Contacto         = DataGenerator_cls.createContacto(true, objAccount.Id, 'CC01', 'DD01');
	        objAccount.DeTelcelCliente__c = 'ClienteTest';
	        objAccount.DelClienteTelcel__c = 'Test';
	        objAccount.InterlocutorAlineamiento__c = Contacto.Id;
	        objAccount.InterlocutorConocimientoCliente__c = Contacto.Id;
	        objAccount.RetoNegocioEstrategiaCliente__c = 'Test';
	        objAccount.RetosNegocioCliente__c = 'Test';
	        objAccount.GastoMovilidad__c = 1000;
	       	objAccount.GastoTIC__c = 100;
	      	objAccount.Segmento__c = 'PyME'; 
	        update objAccount;
		test.stopTest();
    }
}