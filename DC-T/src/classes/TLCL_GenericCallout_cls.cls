/*******************************************************************************
Desarrollado por: Avanxo México
Autor: René Ayala
Proyecto: Telcel Directorio Comercial
Descripción: Clase genérica de consumo de servicios. Permite que -para todos los servicios que se consuman en la organización.

Cambios (Versiones)
-------------------------------------
No.    Fecha      Autor                       Descripción
------ ---------- --------------------------  -----------   
0.1    04-02-2018 René Ayala Medina RAM       Creación
0.2    04-02-2018 René Ayala Medina RAM       Construcción
*******************************************************************************/

public class TLCL_GenericCallout_cls {

    /**
     * Método principal de ejecución de llamado a servicios web.
     * @param  strJsonRequest  Cadena JSON del cuerpo de la petición HTTP
     * @param  strConfigName   Nombre de l objeto de metadatos con la configuración a utilizar
     * @param  mapExtraHeaders Cabeceras HTTP adicionales
     * @param  isLastCallout   Indica si el callout es el último en la transacción
     * @return                 Cadena JSON con el cuerpo de la respuesta del servicio web
    **/

    public static Integer intTestMode;         //Variables que establecen el web service a probar en las pruebas unitarias de APEX / test methods
    public static String productCategory;
    public static String productType;
    public static String strTestConfigName;

    public static String fn_runCallout(String strRequestBody, String strConfigName, Map<String, String> mapExtraHeaders, Boolean isLastCallout)
    {
        String strJsonResponse = null;
        AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();
        EndpointSetting__mdt objEndpointSetting = TLCL_Utils_cls.getEndpointSetting(strConfigName);
        Http httpClient = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(TLCL_GenericCallout_cls.getEndpoint(objEndpointSetting));
        request.setMethod(objEndpointSetting.ServiceMethod__c);
		request.setTimeout(120000);
        if (objEndpointSetting.RequiresBodyEncryption__c) { //Si se requiere encripción, se encripta el cuerpo del mensaje.
            strRequestBody = TLCL_SecurityServices_cls.encryptResource(
                strRequestBody, mainSettings.PasswordEncryptionKey__c, mainSettings.PasswordEncryptionAlgorithm__c);
            request.setHeader('Content-Type', 'text/plain');
            request.setHeader('Accept'      , 'text/plain');
        } else {
            request.setHeader('Content-Type', objEndpointSetting.RequestBodyType__c);
            request.setHeader('Accept'      , objEndpointSetting.ResponseBodyType__c);
        }
        System.debug('Body enviado : '+strRequestBody);
        request.setBody(strRequestBody);
        request.setHeader('Cache-Control', 'no-cache');
        request.setHeader('Content-Length', String.valueOf(strRequestBody.length()));
        request.setHeader('accessType', 'application');
        request.setHeader('system', 'SALESFORCETLCL');
        if (mapExtraHeaders != null && !mapExtraHeaders.isEmpty()) {
            for (String headerName : mapExtraHeaders.keySet()) {
                request.setHeader(headerName, mapExtraHeaders.get(headerName));
            }
        }
        if(Test.isRunningTest()){
            setTestMock();
        }
        HttpResponse response = httpClient.send(request);
        Integer statusCode = response.getStatusCode();
        String responseBody = response.getBody(); 

        System.debug('request url endpoint : '+request.getEndpoint());
        System.debug('request body sin cifrar : '+strRequestBody);
        System.debug('request body cifrado : '+request.getBody());
        System.debug('responseBody : '+responseBody);
        System.debug('response status : '+statusCode);

        if (String.isNotBlank(responseBody) && (statusCode == 200 || statusCode == 201)) {
            strJsonResponse = responseBody;
        } else {
            throw new TLCL_WebServiceException('No se obtuvo una respuesta correcta del servicio: ' + objEndpointSetting.MasterLabel.toUpperCase());
        }
        if (objEndpointSetting.RequiresBodyEncryption__c) {
            try { //Si lleva encripción, se desencripta el cuerpo del mensaje.
                
                strJsonResponse = TLCL_SecurityServices_cls.decryptResource(
                    strJsonResponse, mainSettings.PasswordEncryptionKey__c, mainSettings.PasswordEncryptionAlgorithm__c);

            } catch (Exception e) {
                e.setMessage('No se obtuvo una respuesta correcta del servicio: ' + objEndpointSetting.MasterLabel.toUpperCase());
            }
        }
        return strJsonResponse;
    } 

    /**
     * Método principal de ejecución de llamado a servicios web (con parámetro isLastCallout en "true" por defecto).
     * @param  strRequestBody  Cadena JSON del cuerpo de la petición HTTP
     * @param  strConfigName   Nombre de l objeto de metadatos con la configuración a utilizar
     * @param  mapExtraHeaders Cabeceras HTTP adicionales
     * @return                 Cadena JSON con el cuerpo de la respuesta del servicio web
    **/

    public static String fn_runCallout(String strRequestBody, String strConfigName, Map<String, String> mapExtraHeaders)
    {
        return TLCL_GenericCallout_cls.fn_runCallout(strRequestBody, strConfigName, mapExtraHeaders, true);
    }

    /*
        Método que establece la respuesta mock para las puebas de APEX test methods
    */

    public static void setTestMock(){
        Boolean blnServerResponsesFine = true;
        Map<String,Object> mapResponse = new Map<String,Object>(); 
        if(intTestMode == 1){
            mapResponse.put(strTestConfigName+'_Out',new Map<String,Object>{
                'customer' => new Map<String,Object>{
                    'customerName'=>'Fernando',
                    'customerLastName'=>'Sotelo',
                    'shippingAddress' => new Map<String,Object>{
                        'shippingCity'=>'Cuernavaca'
                    },
                    'opportunities'=> new List<Object>{
                        new Map<String,Object>{
                            'isWon'=>false,
                            'closeDate'=>'2017-05-05',
                            'createdDate'=>'2017-05-05T00:00:00',
                            'amount'=>100000.19,
                            'totalOpportunityQuantity'=>2
                        }
                    },
                    'notExistingMapping1'=>'test'
                },
                'notExistingMapping0'=>'test',
                'isSuccessful'=>true
            });
        }else if(intTestMode == 2){
            mapResponse.put(strTestConfigName+'_Out',new Map<String,Object>{
                'customers' => new List<Object>{
                    new Map<String,Object>{
                        'customerName'=>'Fernando',
                        'customerLastName'=>'Sotelo'
                    },
                    new Map<String,Object>{
                        'customerName'=>'Roberto',
                        'customerLastName'=>'Álvarez'
                    }
                },
                'isSuccessful'=>true
            });
        }else if(intTestMode == 3){
            mapResponse.put(strTestConfigName+'_Out',new Map<String,Object>{
                'dummyField0'=>false,
                'dummyField1'=>'T',
                'dummyField2'=>'2017-05-05',
                'dummyField3'=>'2017-05-05T00:00:00',
                'dummyField4'=>2.0123432,
                'dummyField5'=>10,
                'dummyField6'=>10.2,
                'dummyField7'=>'Test string',
                'dummyStructure'=>new Map<String,Object>(),
                'isSuccessful'=>true
            });
        }else if(intTestMode == 4){
            mapResponse.put(strTestConfigName+'_Out',new Map<String,Object>{
                'isSuccessful'=>false,
                'errorList'=>new List<Object>{
                    new Map<String,Object>{
                        'code'=>'test code',
                        'description'=>'test description'
                    }
                }
            });
        }
        else if(intTestMode == 5){
            mapResponse.put('CrpbOpportunityStageModification_Out',new Map<String,Object>{
                'isSuccessful' => true,
                'transactionId' => 'updateStage12423209',
                'saltDateTime' => '2017-09-27T13:27:15-05:00',
                'errorList' => new List<Object>{
                    new Map<String,Object>{
                        'code' =>  '0',
                        'description' => 'Stage Updated Successfully'
                    }
                }
            });
        }
        else if(intTestMode == 6){
            mapResponse.put('CrpbOpportunityStageModification_Out',new Map<String,Object>{
                'isSuccessful' => false,
                'transactionId' => 'updateStage12423209',
                'saltDateTime' => '2017-09-27T13:27:15-05:00',
                'errorList' => new List<Object>{
                    new Map<String,Object>{
                        'code' =>  '1',
                        'description' => 'Error interno'
                    }
                }
            });
        }
        else if(intTestMode == 7){
            Date today = Date.today();
            mapResponse.put( strTestConfigName + '_Out', new Map<String,Object>{
                'isSuccessful' => true,
                'ProductDetailList' => new List<Object>{
                    new Map<String,Object>{
                        'productNumber' => '1',
                        'category' => productCategory,
                        'type' => productType,
                        'averageBalance' => 12.12,
                        'operationsQuantity' => 1,
                        'balanceIncrease' => 12.12,
                        'overDraftQuantity' => 1,
                        'monthBalance' => 1.1,
                        'isActive' => true,
                        'averageRate' => 1.1,
                        'paidInterestRate' => 1.1,
                        'branchDepositQuantity' => 1,
                        'branchDepositAmount' => 1.1,
                        'totalNumberAccounts' => 1,
                        'productiveAccountsQuantity' => 1,
                        'commisionGenerated' => 1.1,
                        'commisionPaid' => 1.1,
                        'frecuency' => 'frecuency',
                        'transactionIncreasePercentage' => 1.1,
                        'commisionIncreasePercentage' => 1.1,
                        'firstOperationDate' => today,
                        'lastOperationDate' => today,
                        'workCentersQuantity' => 1,
                        'employeeQuantity' => 1,
                        'employeeQuantityToDisperse' => 1,
                        'approvedCreditsQuantity' => 1,
                        'activeCreditsQuantity' => 1,
                        'initialCreditValue' => 1.1,
                        'currentCreditValue' => 1.1,
                        'creditTerm' => 1,
                        'creditTermUnits' => 'creditTermUnits',
                        'interestRate' => 1.1,
                        'warranty' => 'warranty',
                        'oppeningDate' => today,
                        'creditLineApproved' => 1.1,
                        'creditLineAvailable' => 1.1,
                        'creditLineUsed' => 1.1,
                        'commission' => 1.1
                    }
                }
            });
        }
        else if(intTestMode == 8){
            mapResponse.put( strTestConfigName + '_Out', new Map<String,Object>{
                'errorList' => new List<Object>{
                    new Map<String,Object>{
                        'code' =>  '1',
                        'description' => 'test error'
                    }
                }
            });
        }
        else if(intTestMode == 9){
            mapResponse.put( 'CorporateEmployeeCreditDetailQuery_Out', new Map<String,Object>{
                'isSuccessful' => true,
                'CreditDetailList' => new List<Object>{
                    new Map<String,Object>{
                        'code' =>  '1',
                        'description' => 'test'
                    }
                }
            });
        }
        else if(intTestMode == 10){
            mapResponse.put( 'CorporateDocumentsQuery_Out', new Map<String,Object>{
                'isSuccessful' => true,
                'DocumentsList' => new List<Object>{
                    new Map<String,Object>{
                        'Name' =>  'Document',
                        'Type' => 'test'
                    }
                }
            });
        }
        else if(intTestMode == 11){
            Date today = Date.today();
            mapResponse.put( 'CorporateCustomerQuery_Out', new Map<String,Object>{
                'isSuccessful' => true,
                'CustomertInfoList' => new List<Object>{
                    new Map<String,Object>{
                        'FirstName' => 'FirstName',
                        'LastName' => 'LastName',
                        'parent' => '1234567890',
                        'owner' => '1234567890',
                        'brandName' => 'brandName',
                        'bussinesName' => 'bussinesName',
                        'rfc' => 'rfc',
                        'industry' => 'industry',
                        'type' => '1',
                        'establishmentDate' => today,
                        'nationality' => 'nationality',
                        'workPlaces' => 1,
                        'directEmployees' => 1,
                        'indirectEmployees' => 1,
                        'useForeingCurrency' => false,
                        'foreingCurrency' => 'foreingCurrency',
                        'annualTurnOver' => 1.1,
                        'salesRevenue' => 1.1,
                        'annualQuantitySales' => 1,
                        'annualPaymentValue' => 1.1,
                        'annualQuantityPayment' => 1,
                        'annualTransfer' => 1.1,
                        'annualQuantityTransfer' => 1,
                        'companyID' => 'companyID',
                        'RegisteredOffice' => new Map<String,Object>{
                            'shippingAdress' => 'shippingAdress',
                            'shippingZipCode' => 'shippingZipCode',
                            'shippingExtNumber' => 'shippingExtNumber',
                            'shippingIntNumber' => 'shippingIntNumber',
                            'shippingColony' => 'shippingColony',
                            'shippingState' => 'shippingState',
                            'shippingCity' => 'shippingCity',
                            'shippingCountry' => 'shippingCountry'
                        },
                        'FiscalAddress' => new Map<String,Object>{
                            'billingStreet' => 'billingStreet',
                            'billingZipCode' => 'billingZipCode',
                            'billingCity' => 'billingCity',
                            'billingState' => 'billingState',
                            'billingCountry' => 'billingCountry',
                            'billingExtNumber' => 'billingExtNumber',
                            'billingIntNumber' => 'billingIntNumber'
                        }
                    } 
                }
            });
        }
        else if(intTestMode == 12){
            blnServerResponsesFine = false;
        }
        TLCL_GenericCallOutMock_mck mockInstance = new TLCL_GenericCallOutMock_mck(
            (blnServerResponsesFine)?200:404,
            'SUCCESS',
            JSON.serializePretty(mapResponse),
            new Map<String,String>()
        );
        Test.setMock(HttpCalloutMock.class, mockInstance);
    }


    /**
     * Obtener el endpoint del servicio dependiendo de la etapa de desarrollo
     * @param  objEndpointSetting Objeto de Configuración de Endpoint
     * @return                    Endpoint del servicio
    **/

    public static String getEndpoint(EndpointSetting__mdt objEndpointSetting) {
        String strEndpoint = '';
        if ('DEVELOPMENT'.equalsIgnoreCase(objEndpointSetting.Stage__c)) {
            strEndpoint = objEndpointSetting.DevelopmentEndpoint__c;
        } else if ('PRODUCTION'.equalsIgnoreCase(objEndpointSetting.Stage__c)) {
            strEndpoint = objEndpointSetting.ProductionEndpoint__c;
        } else if ('QA'.equalsIgnoreCase(objEndpointSetting.Stage__c)) {
            strEndpoint = objEndpointSetting.QAEndpoint__c;
        }
        return strEndpoint;
    }
    
}