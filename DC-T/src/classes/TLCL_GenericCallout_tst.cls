@isTest
private class TLCL_GenericCallout_tst
{
    @testSetup static void createNeededRecords(){
        Test.loadData(AppMainSetting_cs__c.SObjectType, 'AppMain');
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
                TLCL_GenericCallout_cls.intTestMode = 4;
                TLCL_GenericCallout_cls.strTestConfigName = 'TestFourthService';
                TLCL_GenericCallout_cls.fn_runCallout(strRequestBody, strConfigName, mapExtraHeaders);
                TLCL_GenericCallout_cls.intTestMode = 13;
                TLCL_GenericCallout_cls.strTestConfigName = 'TestThirteenthService';
                try{TLCL_GenericCallout_cls.fn_runCallout(strRequestBody, strConfigName, mapExtraHeaders);}catch(Exception e){
                    try{
                        throw new TLCL_WebServiceException(TLCL_Utils_cls.getEndpointSetting(strConfigName),'Hubo un error debido a que no se obtuvo una respuesta del servicio','request','response');
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
                'TLCL_TestService' => new Map<String,Object>{
                    'extraAttrib' => 'extraValue'   
                }
            };
            Map<String,String> mapExtraHeaders = new Map<String,String>{
                'Accept' => 'application / json'
            };
            String strRequestBody = JSON.serializePretty(mapRequest);
            Test.startTest();
                String strConfigName = 'TLCL_ForTestingService0';
                TLCL_GenericCallout_cls.intTestMode = 1;
                TLCL_GenericCallout_cls.strTestConfigName = 'TestFirstService';
                TLCL_GenericCallout_cls.fn_runCallout(strRequestBody, strConfigName, mapExtraHeaders);
                strConfigName = 'TLCL_ForTestingService1';
                TLCL_GenericCallout_cls.intTestMode = 2;
                TLCL_GenericCallout_cls.strTestConfigName = 'TestSecondService';
                TLCL_GenericCallout_cls.fn_runCallout(strRequestBody, strConfigName, mapExtraHeaders);
                strConfigName = 'TLCL_ForTestingService2';
                TLCL_GenericCallout_cls.intTestMode = 3;
                TLCL_GenericCallout_cls.strTestConfigName = 'TestThirdService';
                TLCL_GenericCallout_cls.fn_runCallout(strRequestBody, strConfigName, mapExtraHeaders);
            Test.stopTest();
        }
    }
    
}