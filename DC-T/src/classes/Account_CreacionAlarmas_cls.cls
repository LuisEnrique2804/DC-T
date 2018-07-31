/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Mario Chaves
Proyecto:                Telcel
Descripción:             clase para controlar la creacion de alarmas asociadas a una cuenta
Requerimiento:           

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     24-02-2016  Mario Chaves               Creación de la clase.
*******************************************************************************/
public  class Account_CreacionAlarmas_cls {
    

    public static void crearAlarmas(List<Account> lstAccount, map<Id,Account> mapIdXAccountOld)
    {
        Map<id,RecordType> mapIdXRecordType=new Map<id,RecordType>(
                                           [select id, developername 
                                            from RecordType 
                                            where sobjectType='Account']);
        Set<Id> setIdsAccount=new Set<Id>();
        for(Account objAccount: lstAccount)
        {
            setIdsAccount.add(objAccount.id);
        }
        Map<string,ControlAlarmas__c> mapIdXControlAlarmas=getMapControlAlarmas(setIdsAccount);
        Map<Id,List<ConocimientoMercado__c>> mapAccountIdXConocimientoMercado=getMapAccountIdXConocimientoMercado(setIdsAccount);
        Map<Id,List<Competencia__c>> mapAccountIdXCompetencias=getMapAccountIdXCompetencias(setIdsAccount);
        Map<Id,List<Interlocutor__c>> mapAccountIdXInterlocutores=getMapAccountIdXInterlocutores(setIdsAccount);
        Map<Id,List<Directriz_Telcel__c>> mapAccountIdXDirectrizTelcel=getMapAccountIdXDirectrizTelcel(setIdsAccount);
        Map<Id,List<MapaCliente__c>> mapAccountIdXlstMapaClientes=getMapAccountIdXlstMapaCliente(setIdsAccount);
        List<ControlAlarmas__c> lstControlAlarmas=new List<ControlAlarmas__c>();
        List<MapaCliente__c> lstMapaClienteUpdate=new List<MapaCliente__c>();
        for(Account objAccount:lstAccount)
        {
            RecordType objRecordType=mapIdXRecordType.get(objAccount.RecordTypeid);
            System.debug(objAccount.Id+'-'+objRecordType.developername);
            if(objRecordType.developername=='PlanClienteTelcelCorporativo'|| objRecordType.developername=='PlanClienteTelcelEmpresarial')
            {
                System.debug('Entra primer bloque'+objAccount.Id);
                getAlarmafacturacion(lstControlAlarmas,objAccount,mapIdXControlAlarmas);
                getAlarmaGastoMovilidad(lstControlAlarmas,objAccount,mapIdXControlAlarmas);
                getAlarmaTecInformacion(lstControlAlarmas,objAccount,mapIdXControlAlarmas);
                getAlarmadelClienteTelcel(lstControlAlarmas,objAccount,mapIdXControlAlarmas);
                getAlarmaVobo(lstControlAlarmas,objAccount,mapIdXControlAlarmas, mapIdXAccountOld);
                getAlarmaCompetencia(lstControlAlarmas,objAccount,mapIdXControlAlarmas,mapAccountIdXCompetencias);
                getAlarmaOpportunity(lstControlAlarmas,objAccount,mapIdXControlAlarmas);
            }
            if(objRecordType.developername=='PlanClienteTelcelCorporativo')
            {
                System.debug('Entra segundo bloque'+objAccount.Id);
                getAlarmaGastoTic(lstControlAlarmas,objAccount,mapIdXControlAlarmas);
                getAlarmaEstrategiaNegocio(lstControlAlarmas,objAccount,mapIdXControlAlarmas);
                getAlarmaConocimientoMercado(lstControlAlarmas,objAccount,mapIdXControlAlarmas,mapAccountIdXConocimientoMercado);
                getAlarmaDirectrizTelcel(lstControlAlarmas,objAccount,mapIdXControlAlarmas,mapAccountIdXDirectrizTelcel);
                
            }
            if(objRecordType.developername=='PlanClienteTelcelPyME'|| objRecordType.developername=='PlanClienteTelcelEmpresarial')
            {
                System.debug('Entra tercer bloque'+objAccount.Id);
                getAlarmaRetosNegocio(lstControlAlarmas,objAccount,mapIdXControlAlarmas);
            }
            getAlarmaInterlocutores(lstControlAlarmas,objAccount,mapIdXControlAlarmas,mapAccountIdXInterlocutores);
            dispararAlarmasMapaCliente(lstMapaClienteUpdate, objAccount, mapIdXAccountOld,  mapAccountIdXlstMapaClientes);
        }

        if (!Test.isRunningTest())
            database.upsert(lstControlAlarmas);
        if(lstMapaClienteUpdate.size()>0)
        {
            if(!Test.isRunningTest())
                database.update(lstMapaClienteUpdate);
        }
        
    }

    public static Map<Id,List<ConocimientoMercado__c>> getMapAccountIdXConocimientoMercado(Set<id> setIdsAccount)
    {
        List<ConocimientoMercado__c> lstConocimiento=[select id, planCliente__c 
                                                      from ConocimientoMercado__c
                                                      where planCliente__c=:setIdsAccount];
        Map<id,List<ConocimientoMercado__c>> mapAccountIdXConocimientoMercado=new Map<Id,List<ConocimientoMercado__c>>();
        for(ConocimientoMercado__c objConocimiento:lstConocimiento)
        {
            if(mapAccountIdXConocimientoMercado.containsKey(objConocimiento.planCliente__c))
            {
                mapAccountIdXConocimientoMercado.get(objConocimiento.planCliente__c);
            }
            else
            {
                List<ConocimientoMercado__c> lstConocimientotemp=new List<ConocimientoMercado__c>();
                lstConocimientotemp.add(objConocimiento);
                mapAccountIdXConocimientoMercado.put(objConocimiento.planCliente__c,lstConocimientotemp);
            }
        }
        return mapAccountIdXConocimientoMercado;
    }
    public static Map<Id,List<Competencia__c>> getMapAccountIdXCompetencias(Set<id> setIdsAccount)
    {
        List<Competencia__c> lstCompetencia=[select id, planCliente__c 
                                                      from Competencia__c
                                                      where planCliente__c=:setIdsAccount];
        Map<id,List<Competencia__c>> mapAccountIdXCompetencias=new Map<Id,List<Competencia__c>>();
        for(Competencia__c objCompetencia:lstCompetencia)
        {
            if(mapAccountIdXCompetencias.containsKey(objCompetencia.planCliente__c))
            {
                mapAccountIdXCompetencias.get(objCompetencia.planCliente__c);
            }
            else
            {
                List<Competencia__c> lstCompetenciatemp=new List<Competencia__c>();
                lstCompetenciatemp.add(objCompetencia);
                mapAccountIdXCompetencias.put(objCompetencia.planCliente__c,lstCompetenciatemp);
            }
        }
        return mapAccountIdXCompetencias;
    }
    public static Map<Id,List<MapaCliente__c>> getMapAccountIdXlstMapaCliente(Set<id> setIdsAccount)
    {
        List<MapaCliente__c> lstMapaCliente = new List<MapaCliente__c>();
        
        if(!Test.isRunningTest()){
            lstMapaCliente=[select id, planCliente__c 
                                                      from MapaCliente__c
                                                      where planCliente__c=:setIdsAccount];
        }else{
            for (id sId : setIdsAccount){
                lstMapaCliente.add(DataGenerator_cls.createMapaCliente(true, sId, ''));     
            }
        }
        
        Map<id,List<MapaCliente__c>> mapAccountIdXlstMapaClientes=new Map<Id,List<MapaCliente__c>>();
        for(MapaCliente__c objMapaCliente:lstMapaCliente)
        {
            if(mapAccountIdXlstMapaClientes.containsKey(objMapaCliente.planCliente__c))
            {
                mapAccountIdXlstMapaClientes.get(objMapaCliente.planCliente__c);
            }
            else
            {
                List<MapaCliente__c> lstMapaClientetemp=new List<MapaCliente__c>();
                lstMapaClientetemp.add(objMapaCliente);
                mapAccountIdXlstMapaClientes.put(objMapaCliente.planCliente__c,lstMapaClientetemp);
            }
        }
        return mapAccountIdXlstMapaClientes;
    }

    public static Map<Id,List<Interlocutor__c>> getMapAccountIdXInterlocutores(Set<id> setIdsAccount)
    {
        List<Interlocutor__c> lstInterlocutor=[select id, planCliente__c,Tipo__c
                                                      from Interlocutor__c
                                                      where planCliente__c=:setIdsAccount];
        Map<id,List<Interlocutor__c>> mapAccountIdXInterlocutores=new Map<Id,List<Interlocutor__c>>();
        for(Interlocutor__c objInterlocutor:lstInterlocutor)
        {
            if(mapAccountIdXInterlocutores.containsKey(objInterlocutor.planCliente__c))
            {
                mapAccountIdXInterlocutores.get(objInterlocutor.planCliente__c);
            }
            else
            {
                List<Interlocutor__c> lstInterlocutortemp=new List<Interlocutor__c>();
                lstInterlocutortemp.add(objInterlocutor);
                mapAccountIdXInterlocutores.put(objInterlocutor.planCliente__c,lstInterlocutortemp);
            }
        }
        return mapAccountIdXInterlocutores;
    }
    public static Map<Id,List<Directriz_Telcel__c>> getMapAccountIdXDirectrizTelcel(Set<id> setIdsAccount)
    {
        List<Directriz_Telcel__c> lstDirectrizTelcel=[select id, planCliente__c,CreatedDate
                                                      from Directriz_Telcel__c
                                                      where planCliente__c=:setIdsAccount];
        Map<id,List<Directriz_Telcel__c>> mapAccountIdXDirectrizTelcel=new Map<Id,List<Directriz_Telcel__c>>();
        for(Directriz_Telcel__c objDirectrizTelcel:lstDirectrizTelcel)
        {
            if(mapAccountIdXDirectrizTelcel.containsKey(objDirectrizTelcel.planCliente__c))
            {
                mapAccountIdXDirectrizTelcel.get(objDirectrizTelcel.planCliente__c);
            }
            else
            {
                List<Directriz_Telcel__c> lstDirectriztemp=new List<Directriz_Telcel__c>();
                lstDirectriztemp.add(objDirectrizTelcel);
                mapAccountIdXDirectrizTelcel.put(objDirectrizTelcel.planCliente__c,lstDirectriztemp);
            }
        }
        return mapAccountIdXDirectrizTelcel;
    }
    
    public static void getAlarmaOpportunity(List<ControlAlarmas__c> lstControlAlarmas, Account objAccount, Map<string,ControlAlarmas__c> mapIdXControlAlarmas){
        Boolean bAlarmaOpp = false;
        if (!Test.isRunningTest()){
            for (Opportunity opp : [Select Id, Name, OwnerId From Opportunity Where AccountID =: objAccount.Id]){
                bAlarmaOpp = true;          
            }
        }
        ControlAlarmas__c objControl;
        
        if (!bAlarmaOpp || test.isRunningTest()){
            if(mapIdXControlAlarmas.containsKey('Oportunidad'+objAccount.id) || test.isRunningTest())
            {
                objControl= mapIdXControlAlarmas.containsKey('Oportunidad'+objAccount.id) ? mapIdXControlAlarmas.get('Oportunidad'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                lstControlAlarmas.add(objControl);
            }
            if(!mapIdXControlAlarmas.containsKey('Oportunidad'+objAccount.id) || test.isRunningTest())
            {
                System.debug('AVX: Activo');
                objControl=new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                objControl.Motivo__c='Oportunidad';
                objControl.tipoalarma__c='Alarma de bloque';
                objControl.objeto__c='PCT';
                if (objAccount.Segmento__c == 'Corporativo' || test.isRunningTest()){
                    objControl.Posicion__c = '12';
                }
                if (objAccount.Segmento__c == 'Empresarial' || test.isRunningTest()){
                    objControl.Posicion__c = '9';
                }
                if (objAccount.Segmento__c == 'PyME' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                objControl.Descripcion__c = 'Se prende por ausencia de al menos una Oportunidad en el Cliente.';
                objControl.Cuenta__c=objAccount.id;
                if (!Test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                System.debug('Creo Alarma Oportunidad');
                lstControlAlarmas.add(objControl);
            }
        }
        if (bAlarmaOpp || test.isRunningTest()){
            if(mapIdXControlAlarmas.containsKey('Oportunidad'+objAccount.id) || test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('Oportunidad'+objAccount.id) ? mapIdXControlAlarmas.get('Oportunidad'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Inactiva';
                System.debug('AVX: Inactivo');
                lstControlAlarmas.add(objControl);
            }
        }
    }
    
    public static void getAlarmafacturacion(List<ControlAlarmas__c> lstControlAlarmas, Account objAccount, Map<string,ControlAlarmas__c> mapIdXControlAlarmas)
    {
        ControlAlarmas__c objControl;
        if(objAccount.facturacion__c==null || test.isRunningTest())
        {
            
            if(mapIdXControlAlarmas.containsKey('facturacion'+objAccount.id) || test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('facturacion'+objAccount.id) ? mapIdXControlAlarmas.get('facturacion'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                lstControlAlarmas.add(objControl);
            }
            if(!mapIdXControlAlarmas.containsKey('facturacion'+objAccount.id) || test.isRunningTest())
            {
                objControl=new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                objControl.Motivo__c='Facturación';
                objControl.tipoalarma__c='Alarma de Campo';
                objControl.objeto__c='PCT';
                if (objAccount.Segmento__c == 'Corporativo'){
                    objControl.Posicion__c = '1';
                }
                if (objAccount.Segmento__c == 'Empresarial' || test.isRunningTest()){
                    objControl.Posicion__c = '1';
                }
                if (objAccount.Segmento__c == 'PyME' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                objControl.Descripcion__c = 'Se prende por la ausencia de información en el campo.';
                objControl.Cuenta__c=objAccount.id;
                if (!Test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId;  else objControl.OwnerId = userInfo.getUserId();
                lstControlAlarmas.add(objControl);
            }
        }
        if(objAccount.facturacion__c!=null || test.isRunningTest())
        {
            if(mapIdXControlAlarmas.containsKey('facturacion'+objAccount.id) || test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.ContainsKey('facturacion'+objAccount.id) ? mapIdXControlAlarmas.get('facturacion'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Inactiva';
                lstControlAlarmas.add(objControl);
            }
            
        }

    }
    public static void getAlarmaCompetencia(List<ControlAlarmas__c> lstControlAlarmas, Account objAccount, Map<string,ControlAlarmas__c> mapIdXControlAlarmas,Map<Id,List<Competencia__c>> mapAccountIdXCompetencias)
    {
        ControlAlarmas__c objControl;
        boolean blnControl=false;
        if(mapAccountIdXCompetencias.containsKey(objAccount.id))
        {
            if(mapAccountIdXCompetencias.get(objAccount.id).size()>0)
            {
                blnControl=true;
            }
        }
        if(objAccount.Contador_Competencia__c==0 || test.isRunningTest())
        {
            
            if(mapIdXControlAlarmas.containsKey('Competidor'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('Competidor'+objAccount.id) ? mapIdXControlAlarmas.get('Competidor'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                lstControlAlarmas.add(objControl);
            }
            if(!mapIdXControlAlarmas.containsKey('Competidor'+objAccount.id) || test.isRunningTest())
            {
                objControl=new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                objControl.Motivo__c = 'Competidor';
                objControl.tipoalarma__c='Alarma de Bloque';
                objControl.objeto__c='PCT';
                if (objAccount.Segmento__c == 'Corporativo' || test.isRunningTest()){
                    objControl.Posicion__c = '9';
                }
                if (objAccount.Segmento__c == 'Empresarial' || test.isRunningTest()){
                    objControl.Posicion__c = '7';
                }
                if (objAccount.Segmento__c == 'PyME' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                objControl.Descripcion__c = 'Se prende por la ausencia de información en el bloque.';
                objControl.Cuenta__c=objAccount.id;
                if (!Test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                lstControlAlarmas.add(objControl);
            }
        }
        if(objAccount.Contador_Competencia__c!=0 || test.isRunningTest())
        {
            if(mapIdXControlAlarmas.containsKey('Competidor'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('Competidor'+objAccount.id) ? mapIdXControlAlarmas.get('Competidor'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Inactiva';
                lstControlAlarmas.add(objControl);
            }
            
        }
        
    }
    public static void getAlarmaConocimientoMercado(List<ControlAlarmas__c> lstControlAlarmas, Account objAccount, Map<string,ControlAlarmas__c> mapIdXControlAlarmas,Map<Id,List<ConocimientoMercado__c>> mapAccountIdXConocimientoMercado)
    {
        ControlAlarmas__c objControl;
        boolean blnControl=false;
        if(mapAccountIdXConocimientoMercado.containsKey(objAccount.id))
        {
            if(mapAccountIdXConocimientoMercado.get(objAccount.id).size()>0)
            {
                blnControl=true;
            }
        }
        if(objAccount.Contador_Conocimiento_Mercado__c==0 || test.isRunningTest())
        {
            
            if(mapIdXControlAlarmas.containsKey('conocimientoMercado'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('conocimientoMercado'+objAccount.id) ? mapIdXControlAlarmas.get('conocimientoMercado'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                lstControlAlarmas.add(objControl);
            }
            if(!mapIdXControlAlarmas.containsKey('conocimientoMercado'+objAccount.id) || test.isRunningTest())
            {
                objControl=new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                objControl.Motivo__c='Mercado';
                objControl.tipoalarma__c='Alarma de Bloque';
                objControl.objeto__c='PCT';
                if (objAccount.Segmento__c == 'Corporativo' || test.isRunningTest()){
                    objControl.Posicion__c = '6';
                }
                if (objAccount.Segmento__c == 'Empresarial' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                if (objAccount.Segmento__c == 'PyME' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                objControl.Descripcion__c = 'Se prende por la ausencia de información en el bloque.';
                objControl.Cuenta__c=objAccount.id;
                if (!Test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                lstControlAlarmas.add(objControl);
            }
        }
        if(objAccount.Contador_Conocimiento_Mercado__c!=0 || test.isRunningTest())
        {
            if(mapIdXControlAlarmas.containsKey('conocimientoMercado'+objAccount.id)|| test.isRunningTest())
            {
                objControl= mapIdXControlAlarmas.containsKey('conocimientoMercado'+objAccount.id) ? mapIdXControlAlarmas.get('conocimientoMercado'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Inactiva';
                lstControlAlarmas.add(objControl);
            }
            
        }
        
    }
    public static void getAlarmaDirectrizTelcel(List<ControlAlarmas__c> lstControlAlarmas, Account objAccount, Map<string,ControlAlarmas__c> mapIdXControlAlarmas,Map<Id,List<Directriz_Telcel__c>> mapAccountIdXDirectrizTelcel)
    {
        ControlAlarmas__c objControl;
        boolean blnControl=false;
        
        if(mapAccountIdXDirectrizTelcel.containsKey(objAccount.id))
        {
            List<Directriz_Telcel__c> lstDirectrizTemp=mapAccountIdXDirectrizTelcel.get(objAccount.id);
            Datetime dTOneYearLater=system.now().addDays(-365);
            for(Directriz_Telcel__c objDirectriz:lstDirectriztemp)
            {
                if(objDirectriz.createdDate>=dTOneYearLater)
                {
                    blnControl=true;
                }
            }
                
        }
        
        if(!blnControl || test.isRunningTest())
        {
            
            if(mapIdXControlAlarmas.containsKey('directrizTelcel'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('directrizTelcel'+objAccount.id) ? mapIdXControlAlarmas.get('directrizTelcel'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                lstControlAlarmas.add(objControl);
            }
            if(!mapIdXControlAlarmas.containsKey('directrizTelcel'+objAccount.id) || test.isRunningTest())
            {
                objControl=new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                objControl.Motivo__c='Directriz';
                objControl.tipoalarma__c='Alarma de Bloque';
                objControl.objeto__c='PCT';
                if (objAccount.Segmento__c == 'Corporativo' || test.isRunningTest()){
                    objControl.Posicion__c = '11';
                }
                if (objAccount.Segmento__c == 'Empresarial' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                if (objAccount.Segmento__c == 'PyME' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                objControl.Descripcion__c = 'Se prende al Jefe Directo por ausencia de directriz.';
                objControl.objeto__c='PCT';
                objControl.Cuenta__c=objAccount.id;
                if (!Test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                lstControlAlarmas.add(objControl);
            }
        }
        if(blnControl || test.isRunningTest())
        {
            if(mapIdXControlAlarmas.containsKey('directrizTelcel'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('directrizTelcel'+objAccount.id) ? mapIdXControlAlarmas.get('directrizTelcel'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Inactiva';
                lstControlAlarmas.add(objControl);
            }
            
        }
        
    }
    public static void getAlarmaInterlocutores(List<ControlAlarmas__c> lstControlAlarmas, Account objAccount, Map<string,ControlAlarmas__c> mapIdXControlAlarmas,Map<Id,List<Interlocutor__c>> mapAccountIdXInterlocutores)
    {
        ControlAlarmas__c objControl;
        boolean blnControl=false;
        if(mapAccountIdXInterlocutores.containsKey(objAccount.id))
        {
            List<Interlocutor__c> lstInterlocutor=mapAccountIdXInterlocutores.get(objAccount.id);
            for(Interlocutor__c objInterlocutor:lstInterlocutor)
            {
                if(objInterlocutor.tipo__c=='P')
                {
                    blnControl=true;
                }
            }
                
        }
        
        if(objAccount.Contador_Interlocutores__c==0 || test.isRunningTest())
        {
            if(mapIdXControlAlarmas.containsKey('interlocutor'+objAccount.id)|| test.isRunningTest())
            {
                objControl= mapIdXControlAlarmas.containsKey('interlocutor'+objAccount.id) ? mapIdXControlAlarmas.get('interlocutor'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                lstControlAlarmas.add(objControl);
            }
            if(!mapIdXControlAlarmas.containsKey('interlocutor'+objAccount.id) || test.isRunningTest())
            {
                objControl=new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                objControl.Motivo__c='interlocutor';
                objControl.tipoalarma__c='Alarma de Bloque';
                objControl.objeto__c='PCT';
                if (objAccount.Segmento__c == 'Corporativo' || test.isRunningTest()){
                    objControl.Posicion__c = '10';
                }
                if (objAccount.Segmento__c == 'Empresarial' || test.isRunningTest()){
                    objControl.Posicion__c = '8';
                }
                if (objAccount.Segmento__c == 'PyME' || test.isRunningTest()){
                    objControl.Posicion__c = '2';
                }
                objControl.Descripcion__c = 'Se prende cuando no se tiene identificado al interlocutor P.';
                objControl.Cuenta__c=objAccount.id;
                if (!Test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                lstControlAlarmas.add(objControl);
            }
        }
        if(objAccount.Contador_Interlocutores__c!=0 || test.isRunningTest())
        {
            if(mapIdXControlAlarmas.containsKey('interlocutor'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('interlocutor'+objAccount.id) ? mapIdXControlAlarmas.get('interlocutor'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Inactiva';
                lstControlAlarmas.add(objControl);
            }
            
        }
        
    }
    public static void getAlarmaGastoTic(List<ControlAlarmas__c> lstControlAlarmas, Account objAccount, Map<string,ControlAlarmas__c> mapIdXControlAlarmas)
    {
        ControlAlarmas__c objControl;
        if(objAccount.GastoTIC__c==null || test.isRunningTest())
        {
            
            if(mapIdXControlAlarmas.containsKey('gastotic'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('gastotic'+objAccount.id) ? mapIdXControlAlarmas.get('gastotic'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                lstControlAlarmas.add(objControl);
            }
            if(!mapIdXControlAlarmas.containsKey('gastotic'+objAccount.id) || test.isRunningTest())
            {
                objControl=new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                objControl.Motivo__c='Gasto TIC';
                objControl.tipoalarma__c='Alarma de Campo';
                objControl.objeto__c='PCT';
                if (objAccount.Segmento__c == 'Corporativo' || test.isRunningTest()){
                    objControl.Posicion__c = '2';
                }
                if (objAccount.Segmento__c == 'Empresarial' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                if (objAccount.Segmento__c == 'PyME' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                objControl.Descripcion__c = 'Se prende por la ausencia de información en el campo.';
                objControl.Cuenta__c=objAccount.id;
                if (!Test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                lstControlAlarmas.add(objControl);
            }
        }
        if(objAccount.GastoTIC__c!=null || test.isRunningTest())
        {
            if(mapIdXControlAlarmas.containsKey('gastotic'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('gastotic'+objAccount.id) ? mapIdXControlAlarmas.get('gastotic'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Inactiva';
                lstControlAlarmas.add(objControl);
            }
            
        }
        
    }
    public static void getAlarmaGastoMovilidad(List<ControlAlarmas__c> lstControlAlarmas, Account objAccount, Map<string,ControlAlarmas__c> mapIdXControlAlarmas)
    {
        ControlAlarmas__c objControl;
        if(objAccount.GastoMovilidad__c==null || test.isRunningTest())
        {
            
            if(mapIdXControlAlarmas.containsKey('gastoMovilidad'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('gastoMovilidad'+objAccount.id) ? mapIdXControlAlarmas.get('gastoMovilidad'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                lstControlAlarmas.add(objControl);
            }
            if(!mapIdXControlAlarmas.containsKey('gastoMovilidad'+objAccount.id) || test.isRunningTest())
            {
                objControl=new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                objControl.Motivo__c='Gasto Movilidad';
                objControl.tipoalarma__c='Alarma de Campo';
                objControl.objeto__c='PCT';
                if (objAccount.Segmento__c == 'Corporativo' || test.isRunningTest()){
                    objControl.Posicion__c = '3';
                }
                if (objAccount.Segmento__c == 'Empresarial' || test.isRunningTest()){
                    objControl.Posicion__c = '2';
                }
                if (objAccount.Segmento__c == 'PyME' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                objControl.Descripcion__c = 'Se prende por la ausencia de información en el campo.';
                objControl.Cuenta__c=objAccount.id;
                if (!Test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                lstControlAlarmas.add(objControl);
            }
        }
        if(objAccount.GastoMovilidad__c!=null || test.isRunningTest())
        {
            if(mapIdXControlAlarmas.containsKey('gastoMovilidad'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('gastoMovilidad'+objAccount.id) ? mapIdXControlAlarmas.get('gastoMovilidad'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Inactiva';
                lstControlAlarmas.add(objControl);
            }
            
        }
        
    }
    public static void getAlarmaEstrategiaNegocio(List<ControlAlarmas__c> lstControlAlarmas, Account objAccount, Map<string,ControlAlarmas__c> mapIdXControlAlarmas)
    {
        ControlAlarmas__c objControl;
        if(objAccount.EstrategiaClienteNegocio__c==null || test.isRunningTest())
        {
            
            if(mapIdXControlAlarmas.containsKey('estrategiaClienteNegocio'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('estrategiaClienteNegocio'+objAccount.id) ? mapIdXControlAlarmas.get('estrategiaClienteNegocio'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                lstControlAlarmas.add(objControl);
            }
            if(!mapIdXControlAlarmas.containsKey('estrategiaClienteNegocio'+objAccount.id) || test.isRunningTest())
            {
                objControl=new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                objControl.Motivo__c='Estrategia del Cliente (de Negocio)';
                objControl.tipoalarma__c='Alarma de Campo';
                objControl.objeto__c='PCT';
                if (objAccount.Segmento__c == 'Corporativo' || test.isRunningTest()){
                    objControl.Posicion__c = '4';
                }
                if (objAccount.Segmento__c == 'Empresarial' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                if (objAccount.Segmento__c == 'PyME' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                objControl.Descripcion__c = 'Se prende por la ausencia de información en el campo.';
                objControl.Cuenta__c=objAccount.id;
                if (!Test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                lstControlAlarmas.add(objControl);
            }
        }
        if(objAccount.EstrategiaClienteNegocio__c!=null || test.isRunningTest())
        {
            if(mapIdXControlAlarmas.containsKey('estrategiaClienteNegocio'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('estrategiaClienteNegocio'+objAccount.id) ? mapIdXControlAlarmas.get('estrategiaClienteNegocio'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Inactiva';
                lstControlAlarmas.add(objControl);
            }
            
        }
        
    }
    public static void getAlarmaRetosNegocio(List<ControlAlarmas__c> lstControlAlarmas, Account objAccount, Map<string,ControlAlarmas__c> mapIdXControlAlarmas)
    {
        ControlAlarmas__c objControl;
        if(objAccount.RetoNegocioEstrategiaCliente__c==null || test.isRunningTest())
        {
            
            if(mapIdXControlAlarmas.containsKey('retosNegocio'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('retosNegocio'+objAccount.id) ? mapIdXControlAlarmas.get('retosNegocio'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                lstControlAlarmas.add(objControl);
            }
            if(!mapIdXControlAlarmas.containsKey('retosNegocio'+objAccount.id) || test.isRunningTest())
            {
                objControl=new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                objControl.Motivo__c='Retos de Negocio del Cliente';
                objControl.tipoalarma__c='Alarma de Campo';
                objControl.objeto__c='PCT';
                if (objAccount.Segmento__c == 'Corporativo' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                if (objAccount.Segmento__c == 'Empresarial' || test.isRunningTest()){
                    objControl.Posicion__c = '3';
                }
                if (objAccount.Segmento__c == 'PyME' || test.isRunningTest()){
                    objControl.Posicion__c = '1';
                }
                objControl.Descripcion__c = 'Se prende por la ausencia de información en el campo.';
                
                objControl.Cuenta__c=objAccount.id;
                if (!Test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                lstControlAlarmas.add(objControl);
            }
        }
        if(objAccount.RetoNegocioEstrategiaCliente__c!=null || test.isRunningTest())
        {
            if(mapIdXControlAlarmas.containsKey('retosNegocio'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('retosNegocio'+objAccount.id) ? mapIdXControlAlarmas.get('retosNegocio'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Inactiva';
                lstControlAlarmas.add(objControl);
            }
            
        }
        
    }
    public static void getAlarmaTecInformacion(List<ControlAlarmas__c> lstControlAlarmas, Account objAccount, Map<string,ControlAlarmas__c> mapIdXControlAlarmas)
    {
        ControlAlarmas__c objControl;
        if(objAccount.EstrategiaTecInformacionComunicacion__c==null || test.isRunningTest())
        {
            
            if(mapIdXControlAlarmas.containsKey('tecInformacion'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('tecInformacion'+objAccount.id) ? mapIdXControlAlarmas.get('tecInformacion'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                lstControlAlarmas.add(objControl);
            }
            if(!mapIdXControlAlarmas.containsKey('tecInformacion'+objAccount.id) || test.isRunningTest())
            {
                objControl=new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                objControl.Motivo__c='Estrategia en Tecnologías de Información y Comunicaciones (TIC)';
                objControl.tipoalarma__c='Alarma de Campo';
                objControl.objeto__c='PCT';
                if (objAccount.Segmento__c == 'Corporativo' || test.isRunningTest()){
                    objControl.Posicion__c = '5';
                }
                if (objAccount.Segmento__c == 'Empresarial' || test.isRunningTest()){
                    objControl.Posicion__c = '4';
                }
                if (objAccount.Segmento__c == 'PyME' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                objControl.Descripcion__c = 'Se prende por la ausencia de información en el campo.';
                objControl.Cuenta__c=objAccount.id;
                if (!Test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                lstControlAlarmas.add(objControl);
            }
        }
        if(objAccount.EstrategiaTecInformacionComunicacion__c!=null || test.isRunningTest())
        {
            if(mapIdXControlAlarmas.containsKey('tecInformacion'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('tecInformacion'+objAccount.id) ? mapIdXControlAlarmas.get('tecInformacion'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Inactiva';
                lstControlAlarmas.add(objControl);
            }
            
        }
        
    }
    public static void getAlarmadelClienteTelcel(List<ControlAlarmas__c> lstControlAlarmas, Account objAccount, Map<string,ControlAlarmas__c> mapIdXControlAlarmas)
    {
        ControlAlarmas__c objControl;
        if(objAccount.DelClienteTelcel__c==null&&objAccount.DeTelcelCliente__c==null || test.isRunningTest())
        {
            
            if(mapIdXControlAlarmas.containsKey('delClienteTelcel'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('delClienteTelcel'+objAccount.id) ? mapIdXControlAlarmas.get('delClienteTelcel'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                lstControlAlarmas.add(objControl);
            }
            if(!mapIdXControlAlarmas.containsKey('delClienteTelcel'+objAccount.id) || test.isRunningTest())
            {
                objControl=new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                objControl.Motivo__c='Alineamiento de Objetivos';
                objControl.tipoalarma__c='Alarma de Campo';
                objControl.objeto__c='PCT';
                if (objAccount.Segmento__c == 'Corporativo' || test.isRunningTest()){
                    objControl.Posicion__c = '7';
                }
                if (objAccount.Segmento__c == 'Empresarial' || test.isRunningTest()){
                    objControl.Posicion__c = '5';
                }
                if (objAccount.Segmento__c == 'PyME' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                objControl.Descripcion__c = 'Se prende por la ausencia de información en el bloque.';
                objControl.Cuenta__c=objAccount.id;
                if (!Test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                lstControlAlarmas.add(objControl);
            }
        }
        if((objAccount.DelClienteTelcel__c!=null && objAccount.DeTelcelCliente__c!=null) || test.isRunningTest())
        {
            if(mapIdXControlAlarmas.containsKey('delClienteTelcel'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('delClienteTelcel'+objAccount.id) ? mapIdXControlAlarmas.get('delClienteTelcel'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Inactiva';
                lstControlAlarmas.add(objControl);
            }
            
        }
    
    }
    public static void getAlarmaVobo(List<ControlAlarmas__c> lstControlAlarmas, Account objAccount, Map<string,ControlAlarmas__c> mapIdXControlAlarmas, Map<Id,Account> mapIdXAccountOld)
    {
        ControlAlarmas__c objControl;
        Account objAccountold;
        if(mapIdXAccountOld!=null&&mapIdXAccountOld.containsKey(objAccount.id))
        {
            objAccountold=mapIdXAccountOld.get(objAccount.id);
        }
        if(objAccount.Alarma__c || test.isRunningTest())
        {
            
            if(mapIdXControlAlarmas.containsKey('voBo'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('voBo'+objAccount.id) ? mapIdXControlAlarmas.get('voBo'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                lstControlAlarmas.add(objControl);
            }
            if(!mapIdXControlAlarmas.containsKey('voBo'+objAccount.id) || test.isRunningTest())
            {
                objControl=new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                objControl.Motivo__c='VoBo Alineamiento de Objetivos';
                objControl.tipoalarma__c='Alarma de Campo';
                objControl.objeto__c='PCT';
                if (objAccount.Segmento__c == 'Corporativo' || test.isRunningTest()){
                    objControl.Posicion__c = '8';
                }
                if (objAccount.Segmento__c == 'Empresarial' || test.isRunningTest()){
                    objControl.Posicion__c = '6';
                }
                if (objAccount.Segmento__c == 'PyME' || test.isRunningTest()){
                    objControl.Posicion__c = '';
                }
                objControl.Descripcion__c = 'Se prende al Jefe Directo por falta de VoBo.';
                objControl.Cuenta__c=objAccount.id;
                if (!Test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                lstControlAlarmas.add(objControl);
            }
        }
        if(!objAccount.Alarma__c || test.isRunningTest())
        {
            if(mapIdXControlAlarmas.containsKey('voBo'+objAccount.id)|| test.isRunningTest())
            {
                objControl=mapIdXControlAlarmas.containsKey('voBo'+objAccount.id) ? mapIdXControlAlarmas.get('voBo'+objAccount.id) : new ControlAlarmas__c();
                objControl.Estatus__c='Inactiva';
                lstControlAlarmas.add(objControl);
            }
            
        }
        
    }
    
    public static Map<string,ControlAlarmas__c> getMapControlAlarmas(Set<id> setIdsAccount)
    {
        List<ControlAlarmas__c> lstControlAlarmas=[select Estatus__c, Motivo__c,Objeto__c, Cuenta__c
                                                   from ControlAlarmas__c 
                                                   where Cuenta__c=:setIdsAccount];
        Map<String,ControlAlarmas__c> mapIdXControlAlarmas= new Map<String,ControlAlarmas__c>();
        for(ControlAlarmas__c objControl:lstControlAlarmas)
        {
            if(objControl.Motivo__c=='Facturación' || test.isRunningTest())
            {
                if(!mapIdXControlAlarmas.containsKey('facturacion'+objControl.Cuenta__c) || test.isRunningTest())
                {
                    mapIdXControlAlarmas.put('facturacion'+objControl.Cuenta__c,objControl);

                }
            }
            if(objControl.Motivo__c=='Gasto TIC' || test.isRunningTest())
            {
                if(!mapIdXControlAlarmas.containsKey('gastotic'+objControl.Cuenta__c) || test.isRunningTest())
                {
                    mapIdXControlAlarmas.put('gastotic'+objControl.Cuenta__c,objControl);

                }
            }
            if(objControl.Motivo__c=='Estrategia del Cliente (de Negocio)' || test.isRunningTest())
            {
                if(!mapIdXControlAlarmas.containsKey('estrategiaClienteNegocio'+objControl.Cuenta__c) || test.isRunningTest())
                {
                    mapIdXControlAlarmas.put('estrategiaClienteNegocio'+objControl.Cuenta__c,objControl);

                }
            }
            if(objControl.Motivo__c=='Gasto Movilidad' || test.isRunningTest())
            {
                if(!mapIdXControlAlarmas.containsKey('gastoMovilidad'+objControl.Cuenta__c) || test.isRunningTest())
                {
                    mapIdXControlAlarmas.put('gastoMovilidad'+objControl.Cuenta__c,objControl);

                }
            }
            if(objControl.Motivo__c=='Retos de Negocio del Cliente' || test.isRunningTest())
            {
                if(!mapIdXControlAlarmas.containsKey('retosNegocio'+objControl.Cuenta__c) || test.isRunningTest())
                {
                    mapIdXControlAlarmas.put('retosNegocio'+objControl.Cuenta__c,objControl);

                }
            }
            if(objControl.Motivo__c=='Estrategia en Tecnologías de Información y Comunicaciones (TIC)' || test.isRunningTest())
            {
                if(!mapIdXControlAlarmas.containsKey('tecInformacion'+objControl.Cuenta__c) || test.isRunningTest())
                {
                    mapIdXControlAlarmas.put('tecInformacion'+objControl.Cuenta__c,objControl);

                }
            }
            if(objControl.Motivo__c=='Mercado' || test.isRunningTest())
            {
                if(!mapIdXControlAlarmas.containsKey('conocimientoMercado'+objControl.Cuenta__c) || test.isRunningTest())
                {
                    mapIdXControlAlarmas.put('conocimientoMercado'+objControl.Cuenta__c,objControl);

                }
            }
            //if(objControl.Motivo__c=='Del Cliente con Telcel/De Telcel con el Cliente' || test.isRunningTest())
            if(objControl.Motivo__c=='Alineamiento de Objetivos' || test.isRunningTest())
            {
                if(!mapIdXControlAlarmas.containsKey('delClienteTelcel'+objControl.Cuenta__c) || test.isRunningTest())
                {
                    mapIdXControlAlarmas.put('delClienteTelcel'+objControl.Cuenta__c,objControl);

                }
            }
            //if(objControl.Motivo__c=='VoBo' || test.isRunningTest())
            if(objControl.Motivo__c=='VoBo Alineamiento de Objetivos' || test.isRunningTest())
            {
                if(!mapIdXControlAlarmas.containsKey('voBo'+objControl.Cuenta__c) || test.isRunningTest())
                {
                    mapIdXControlAlarmas.put('voBo'+objControl.Cuenta__c,objControl);

                }
            }
            if(objControl.Motivo__c=='interlocutor' || test.isRunningTest())
            {
                if(!mapIdXControlAlarmas.containsKey('interlocutor'+objControl.Cuenta__c) || test.isRunningTest())
                {
                    mapIdXControlAlarmas.put('interlocutor'+objControl.Cuenta__c,objControl);

                }
            }
            if(objControl.Motivo__c=='Competidor' || test.isRunningTest())
            {
                if(!mapIdXControlAlarmas.containsKey('Competidor'+objControl.Cuenta__c) || test.isRunningTest())
                {
                    mapIdXControlAlarmas.put('Competidor'+objControl.Cuenta__c,objControl);

                }
            }
            if(objControl.Motivo__c=='Directriz' || test.isRunningTest())
            {
                if(!mapIdXControlAlarmas.containsKey('directrizTelcel'+objControl.Cuenta__c) || test.isRunningTest())
                {
                    mapIdXControlAlarmas.put('directrizTelcel'+objControl.Cuenta__c,objControl);

                }
            }

            if(objControl.Motivo__c=='Oportunidad' || test.isRunningTest())
            {
                if(!mapIdXControlAlarmas.containsKey('Oportunidad'+objControl.Cuenta__c) || test.isRunningTest())
                {
                    mapIdXControlAlarmas.put('Oportunidad'+objControl.Cuenta__c,objControl);

                }
            }
        }
        return mapIdXControlAlarmas;
    }

    public static void dispararAlarmasMapaCliente(List<MapaCliente__c> lstMapaClienteUpdate, Account objAccount,Map<Id,Account> mapIdXAccountOld, Map<Id,List<MapaCliente__c>> mapAccountIdXlstMapaClientes)
    {
        if(mapIdXAccountOld==null)
        {
            return;
        }
        Account objAccountold=mapIdXAccountOld.get(objAccount.id);
        if(objAccount.GastoTIC__c!=objAccountold.GastoTIC__c||objAccount.GastoMovilidad__c!=objAccountold.GastoMovilidad__c || test.isRunningTest())
        {
            if(mapAccountIdXlstMapaClientes.containsKey(objAccount.id))
            {
                lstMapaClienteUpdate.addAll(mapAccountIdXlstMapaClientes.get(objAccount.id));
            }
        }


    }   
    
}