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
private class DCT_SISACactivaRest_tst {
	@TestSetup static void setup(){
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('Eventos');
		
		String  profileName = Label.DCT_AdministratorProfile; //Administrador del sistema
		String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';
		String   username2 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';
		Map<String,Map<String,RecordType>> mapRTsByDevName = TLCL_Utils_cls.getRecordTypes('DeveloperName');
		System.debug(loggingLevel.Error, '*** mapRTsByDevName: ' + mapRTsByDevName);

		Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

        User usr = new User(
            Alias             = username.substringAfterLast('@'),
            Email             = username,
            EmailEncodingKey  = 'UTF-8',
            LastName          = username,
            FirstName         = username,
            LanguageLocaleKey = 'es_MX',
            LocaleSidKey      = 'es_MX',
            ProfileId         = p.Id,
            TimeZoneSidKey    = 'America/Mexico_City',
            UserName          = username
        );
        insert usr;

        User usr2 = new User(
            Alias             = username2.substringAfterLast('@'),
            Email             = username2,
            EmailEncodingKey  = 'UTF-8',
            LastName          = username2,
            FirstName         = username2,
            LanguageLocaleKey = 'es_MX',
            LocaleSidKey      = 'es_MX',
            ProfileId         = p.Id,
            TimeZoneSidKey    = 'America/Mexico_City',
            UserName          = username2
        );
        insert usr2;

		Account newLeadAcc = new Account(
			DTC_LegalEntity__c      = 'Moral',
			RFC__c                  = 'ABC123456EFJ',
			Name                    = 'Pruebas',
			Segmento__c             = 'Corporativo',
			DCT_TypeOfProcedure__c  = 'Lineas Nuevas',
			Sector__c               = 'Financiero',
			Subsector__c            = 'Afores',
			DCT_RegistrationDate__c = System.today(),
			OwnerId                 = usr.id
		);
		Insert newLeadAcc;

		Cliente__c prospect = new Cliente__c(
			Name = 'LUIS ENRIQUE PRUEBA',
			RFC1__c = 'BETA123456ASD',
			//RecordType.Name
			OwnerId = usr2.Id,
			DCTStatus__c = 'Activo'
			//DCTRegistrationDate__c = ,
		);
		insert prospect;

		DCTPlan__c plan = new DCTPlan__c(
			ClaveFuerzaVenta__c = 'Test', 
			ClavePlan__c = 'Test', 
			ClaveDetallePlan__c = 'Test',
			DescripcionServcicio__c = 'Test'
		);
		insert plan;

		System.debug(loggingLevel.Error, '*** mapRTsByDevName.get(DCTAuthorizedLines__c).get(DCTPlan): ' + mapRTsByDevName.get('DCTAuthorizedLines__c').get('DCTPlan'));
		DCTAuthorizedLines__c newAuthLines = new DCTAuthorizedLines__c(
			Status__c = 'Pendiente',
			CommercialDirectory__c = prospect.id,
			RecordTypeid  = mapRTsByDevName.get('DCTAuthorizedLines__c').get('DCTPlan').Id,
			Clave__c = 'Test',
			Name = 'Test',
			DCTTerm__c = 'LIBRE',
			DCT_Tarifa__c = 'B',
			DCTHideAdditionalServices__c = true,
			Plan__c = plan.id
		);
		insert newAuthLines;

		DCTAuthorizedLines__c newAuthLines2 = new DCTAuthorizedLines__c(
			Status__c = 'Pendiente',
			CommercialDirectory__c = prospect.id,
			RecordTypeid  = mapRTsByDevName.get('DCTAuthorizedLines__c').get('DCTLineas_Autorizadas').Id,
			DCTAuthorizedLines__c = 12,
			DCTAuthorizationDate__c = system.today(),
			DCTTotalAuthorizedLines__c = 12
		);
		insert newAuthLines2;

		Contact cont = new Contact(
			OwnerId   = usr.Id, 
			FirstName = 'test',
			LastName  = 'test',
			AccountId = newLeadAcc.Id,
			Directorio_Comercial__c = prospect.Id,
			DCT_ContactoDirectorio__c = true
		);
		insert cont;
		System.debug(loggingLevel.Error, '*** cont: ' + cont);
	}

    static testMethod void DCT_SISACactivaRest_OK_1() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','1');
			req.params.put('RFC','BETA123456ASD');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_1() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','1');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }

    static testMethod void DCT_SISACactivaRest_OK_2() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','2');
			req.params.put('RazonSocial','LUIS+ENRIQUE+PRUEBA');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_2() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','2');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }

    static testMethod void DCT_SISACactivaRest_OK_3() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','3');
			req.params.put('RFC','BETA123456ASD');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_3() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','3');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }

    static testMethod void DCT_SISACactivaRest_OK_4() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','4');
			req.params.put('RFC','BETA123456ASD');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_4() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','4');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }

    static testMethod void DCT_SISACactivaRest_OK_5() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','5');
			req.params.put('NISI','987654');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_5() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','5');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }

    static testMethod void DCT_SISACactivaRest_OK_6() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','6');
			req.params.put('RFC','BETA123456ASD');
			req.params.put('RazonSocial','LUIS+ENRIQUE+PRUEBA');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_6() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','6');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }

    static testMethod void DCT_SISACactivaRest_OK_7() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','7');
			req.params.put('RFC','BETA123456ASD');
			req.params.put('TipoPersona','1');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_7() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','7');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }

    static testMethod void DCT_SISACactivaRest_OK_8() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','8');
			req.params.put('RazonSocial','LUIS+ENRIQUE+PRUEBA');
			req.params.put('TipoPersona','1');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_8() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','8');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }

    static testMethod void DCT_SISACactivaRest_OK_9() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','9');
			req.params.put('RFC','BETA123456ASD');
			req.params.put('RazonSocial','LUIS+ENRIQUE+PRUEBA');
			req.params.put('TipoPersona','1');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_9() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','9');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }

    static testMethod void DCT_SISACactivaRest_OK_10() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','10');
			req.params.put('RFC','BETA123456ASD');
			req.params.put('RazonSocial','LUIS+ENRIQUE+PRUEBA');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_10() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','10');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }

    static testMethod void DCT_SISACactivaRest_OK_11() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','11');
			req.params.put('RFC','BETA123456ASD');
			req.params.put('RazonSocial','LUIS+ENRIQUE+PRUEBA');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_11() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','11');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }

    static testMethod void DCT_SISACactivaRest_OK_12() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','12');
			req.params.put('RFC','BETA123456ASD');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_12() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','12');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }

    static testMethod void DCT_SISACactivaRest_OK_13() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','13');
			req.params.put('Identificador','001');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_13() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','13');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }

    static testMethod void DCT_SISACactivaRest_OK_14() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','14');
			req.params.put('RFC','BETA123456ASD');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_14() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','14');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }

    static testMethod void DCT_SISACactivaRest_OK_15() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','15');
			req.params.put('RazonSocial','LUIS+ENRIQUE+PRUEBA');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
		
    }
    static testMethod void DCT_SISACactivaRest_NOT_OK_15() {
		
		Test.startTest();
			RestRequest req			=	new RestRequest(); 
			RestResponse resp		=	new RestResponse();
			req.requestURI			=	'https://telcel-dev--dc.cs18.my.salesforce.com/services/apexrest/SISAC-Activa?Metodo=1&RFC=BETA123456ASD';
			req.httpMethod			=	'GET';
			req.requestBody			=	Blob.valueOf('{}');
			req.params.put('Metodo','15');
			RestContext.request 	=	req;
			RestContext.response 	=	resp;
			System.debug(loggingLevel.Error, '*** RestContext.request: ' + RestContext.request);
			DCT_SISACactivaRest_ws.SISAC();
		Test.stopTest();
    }


}