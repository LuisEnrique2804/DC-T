/*******************************************************************************
Desarrollado por: Avanxo México
Autor: René Ayala
Proyecto: Telcel Directorio Comercial
Descripción: Clase que contiene los métodos de utilidad para todos los procesos de la organización.

Cambios (Versiones)
-------------------------------------
No.    Fecha      Autor                       Descripción
------ ---------- --------------------------  -----------   
0.1    01-02-2018 René Ayala Medina RAM       Creación
0.2    01-02-2018 René Ayala Medina RAM       Construcción         
*******************************************************************************/
global class TLCL_Utils_cls {

    /**
     * Obtener mapa de todos los tipos de registro usando un campo especificado como llave
     * de los elementos del mapa.
     * @param      keyField  Campo llave a utilizar en el mapa.
     * @return     Mapa de tipos de registro (Ej. <SObjectName, Map<Key, RecordType>>)
    **/

    public static Map<String, Map<String, RecordType>> getRecordTypes(String keyField) {
        Map<String, Map<String, RecordType>> mapRecordTypes = new Map<String, Map<String, RecordType>>();
        List<RecordType> lstRecordTypes = new List<RecordType>();
        String strQueryOverRTsStatement = 'SELECT '+String.join(new List<String>(SObjectType.RecordType.Fields.getMap().keySet()),', ')+' FROM RecordType WHERE IsActive = true';
        try{lstRecordTypes = Database.query(strQueryOverRTsStatement);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        for (RecordType recType : lstRecordTypes) {
            String objType = recType.SobjectType;
            if (!mapRecordTypes.containsKey(objType)) {
                mapRecordTypes.put(objType, new Map<String, RecordType>());
            }
            if(mapRecordTypes.containsKey(objType)){
                mapRecordTypes.get(objType).put((String)recType.get(keyField), recType);
            }
        }
        return mapRecordTypes;
    }

    /**
     * Genera un mapa de cualquier lista de objetos usando como llave un campo especificado.
     * @param  lstObjects Lista de objetos para generar el mapa
     * @param  keyField   Nombre del campo llave a utilizar
     * @return            Mapa de objetos generado
    **/

    public static Map<String, SObject> generateMapWithCustomKey(SObject[] lstObjects, String keyField) {
        Map<String, SObject> mapObjects = new Map<String, SObject>();
        for (SObject obj : lstObjects) {
            mapObjects.put((String)obj.get(keyField), obj);
        }
        return mapObjects;
    }

    /**
     * Obtener información del usuario actual (solo cuando la clase UserInfo no contiene la información requerida)
     * @param  userId Id del usuario
     * @return        Usuario encontrado
    **/

    public static User getUserCustomInfo(Id userId) {
        String query = 'SELECT ' + String.join(new List<String>(SObjectType.User.Fields.getMap().keySet()),', ') + ' FROM User WHERE Id = \'' + userId + '\' LIMIT 1';
        User usr = new User();
        try{usr = Database.query(query);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        return usr;
    }

    /**
     * Obtener configuración de mapeo de campos sin incluir mapeos de campos
     * @param  strSetupCode Código de configuración
     * @return              Objeto de configuración de Endpoing
    **/
   
    public static EndpointSetting__mdt getEndpointSetting(String strSetupCode){ 
        System.debug(loggingLevel.Error, '*** strSetupCode: ' + strSetupCode); 
        EndpointSetting__mdt objEndpointSetting = new EndpointSetting__mdt();
        String strQueryOverEndpointSetting = 'SELECT '+String.join(new List<String>(SObjectType.EndpointSetting__mdt.Fields.getMap().keySet()),', ')+' FROM EndpointSetting__mdt WHERE DeveloperName = \''+strSetupCode+'\' LIMIT 1';
        System.debug(loggingLevel.Error, '*** strQueryOverEndpointSetting: ' + strQueryOverEndpointSetting);
        try{objEndpointSetting = Database.query(strQueryOverEndpointSetting);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        System.debug(loggingLevel.Error, '*** objEndpointSetting: ' + objEndpointSetting);
        return objEndpointSetting;
    }

    /**
     * Obtener configuración de mapeo de campos sin incluir mapeos de campos
     * @param  strSetupCode Código de configuración
     * @param  mappingType  Tipo de mapeo (REQUEST/RESPONSE)
     * @return              Objeto de configuración de Endpoing
    **/
    
    public static EndpointSetting__mdt getEndpointSetting(String strSetupCode, String mappingType){
        /*Revisión René: Meter query en try catch pero antes inicializar el objeto objEndpointSetting*/
        mappingType = mappingType.toUpperCase();
        String strQueryOverEndpointAndRelatedSettings = 'SELECT '+String.join(new List<String>(SObjectType.EndpointSetting__mdt.Fields.getMap().keySet()),', ')+', (SELECT '+String.join(new List<String>(SObjectType.ServiceMapping__mdt.Fields.getMap().keySet()),', ')+' FROM ServiceMapping__r WHERE Component__c = \''+mappingType+'\' AND IsActive__c = true) FROM EndpointSetting__mdt WHERE DeveloperName = \''+strSetupCode+'\' limit 1';
        EndpointSetting__mdt objEndpointSetting = Database.query(strQueryOverEndpointAndRelatedSettings);
        return objEndpointSetting;
    }

    /**
     * Convierte una fecha en formato "2017-02-01T10:14:58.421-06:00" a "2017-02-01 10:14:58"
     * @param  strDatetime Cadena de fecha a convertir
     * @return             Fecha/Hora generada
    **/

    public static Datetime strToDatetime(String strDatetime) {
        Datetime dt = null;
        try {
            strDatetime      = strDatetime.trim().replace('T', ' ').substring(0, 16); 
            String strDate   = strDatetime.substringBeforeLast(' ');
            String[] lstTime = strDatetime.substringAfterLast(' ').split(':');
            Date mDate = Date.valueOf(strDate);
            Time mTime = Time.newInstance(Integer.valueOf(lstTime[0]), Integer.valueOf(lstTime[1]), 0, 0);
            dt = Datetime.newInstance(mDate, mTime);
        } catch (Exception e){}
        return dt;
    }


    public static Datetime getDateTimeByUserTimeZone(Datetime datTmToConvert, User currentUserInstance)
    {
        Timezone tz = Timezone.getTimeZone(currentUserInstance.TimeZoneSidKey); 
        Integer offsetSeconds = (tz.getOffset(DateTime.now())/1000);
        datTmToConvert = datTmToConvert.addSeconds(offsetSeconds);
        return datTmToConvert;
    }
    
}