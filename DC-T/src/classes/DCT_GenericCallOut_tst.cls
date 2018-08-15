@isTest
private class DCT_GenericCallOut_tst {
	
    @testSetup static void createNeededRecords(){
        List<sObject> ls = Test.loadData(AppMainSetting_cs__c.SObjectType, 'AppMain');
        //List<sObject> ls2 = Test.loadData(EndpointSetting__mdt.SObjectType, 'endPoint');
        Id idProfile = UserInfo.getProfileId();
        User usr = new User(
            Alias               = 'usrTLCL',
            Email               = 'emailtelceltst@email.com',
            EmailEncodingKey    = 'UTF-8',
            LastName            = 'userLastName',
            LanguageLocaleKey   = 'es_MX',
            LocaleSidKey        = 'es_MX',
            TimeZoneSidKey      = 'America/Mexico_City',
            ProfileId           = idProfile,
            UserName            = 'emailtelceltst@email.com',
            EmployeeNumber = '123456789',
            isActive = true
        );
        Database.insert(usr);
  

    } 

    @isTest static void shouldNotAnswerCorrectly(){
        User userToRunTest = [SELECT Id FROM User WHERE UserName =: 'emailtelceltst@email.com' limit 1];
        System.runAs(userToRunTest){
            String strConfigName = 'TLCL_ForTestingService0';
            Map<String,Object> mapRequest = new Map<String,Object>{
                'TLCL_TestService' => new Map<String,Object>{
                    'extraAttrib' => 'extraValue'   
                }
            };
            Map<String,String> mapExtraHeaders = new Map<String,String>{
                'Accept' => 'application / json'
            };
            String strRequestBody = JSON.serializePretty(mapRequest);
            Test.startTest();
                DCT_GenericCallout_cls.intTestMode = 4;
                DCT_GenericCallout_cls.strTestConfigName = 'TestFourthService';
                DCT_GenericCallout_cls.fn_runCallout(strRequestBody, strConfigName, mapExtraHeaders);
                DCT_GenericCallout_cls.intTestMode = 13;
                DCT_GenericCallout_cls.strTestConfigName = 'TestThirteenthService';
                try{DCT_GenericCallout_cls.fn_runCallout(strRequestBody, strConfigName, mapExtraHeaders);}catch(Exception e){
                    try{
                        throw new DCT_WebServiceException(TLCL_Utils_cls.getEndpointSetting(strConfigName),'Hubo un error debido a que no se obtuvo una respuesta del servicio','request','response');
                    }catch(Exception eX){

                    }
                }
            Test.stopTest();
        }
    }

    @isTest static void shouldAnswerCorrectly(){
        User userToRunTest = [SELECT Id FROM User WHERE UserName =: 'emailtelceltst@email.com' limit 1];
        System.runAs(userToRunTest){
            Map<String,Object> mapRequest = new Map<String,Object>{
                'DCT_TestService' => new Map<String,Object>{
                    'extraAttrib' => 'extraValue'   
                }
            };
            Map<String,String> mapExtraHeaders = new Map<String,String>{
                'Accept' => 'application / json'
            };
            String strRequestBody = JSON.serializePretty(mapRequest);
            Test.startTest();
                DCT_ServiceTokenResponse_wpr tokenWrapper = new DCT_ServiceTokenResponse_wpr();
                String strConfigName = 'DCT_ForTestingService0';
                DCT_GenericCallout_cls.intTestMode = 1;
                DCT_GenericCallout_cls.strTestConfigName = 'TestFirstService';
                DCT_GenericCallout_cls.fn_runCallout(strRequestBody, strConfigName, mapExtraHeaders);
                strConfigName = 'DCT_ForTestingService1';
                DCT_GenericCallout_cls.intTestMode = 2;
                DCT_GenericCallout_cls.strTestConfigName = 'TestSecondService';
                DCT_GenericCallout_cls.fn_runCallout(strRequestBody, strConfigName, mapExtraHeaders);
                strConfigName = 'DCT_ForTestingService2';
                DCT_GenericCallout_cls.intTestMode = 3;
                DCT_GenericCallout_cls.strTestConfigName = 'TestThirdService';
                DCT_GenericCallout_cls.fn_runCallout(strRequestBody, strConfigName, mapExtraHeaders);
            Test.stopTest();
        }
    }
}