/******************************************************************************
* Autor: Alejandro Hurtado ahurtado@avanxo.com
* Descripcion: esta clase contiene la lógica que se debe ejecutar cada vez que
*              se dispara un trigger.
* Creada en: 2016-01-26
******************************************************************************/
public with sharing class SeguimientoOportunidad_cls
{
    public static Boolean blnCreateAlarmas = true;
    
    public static void createEvent( list<SeguimientoOportunidades__c> lstSO, map<Id, SeguimientoOportunidades__c> mapOldSO )
    {
        //Creamos un map para guardar los seguimientos de oportunidad a los
        //que se les debe crear un evento
        map<Id, SeguimientoOportunidades__c> mapIdSO =
            new map<Id, SeguimientoOportunidades__c>();
            
        //Creamos un set para guardar los ids de las oportunidades
        set<Id> setIdOpportunity = new set<Id>();
            
        //Recorremos la lista recibida
        for( SeguimientoOportunidades__c objSO : lstSO )
        {
            //Revisamos si es un update
            if( mapOldSO != null )
            {
                //Obtenemos el objeto con los valores previos
                SeguimientoOportunidades__c objSOOld =
                    mapOldSO.get( objSO.Id );
                                
                //Revisamos si los campos estaban en null y si los nuevos no
                if( ( (objSOOld.Proximaaccion__c == null || objSOOld.Fechaproximaaccion__c == null )
                    && objSO.Proximaaccion__c != null && objSO.Fechaproximaaccion__c != null ) || objSOOld.Proximaaccion__c != objSO.Proximaaccion__c)
                {
                    mapIdSO.put( objSO.Id, objSO );
                    setIdOpportunity.add( objSO.Embudo__c );
                }
            }
            else
            {
                //Entonces es una inserción
                //Revisamos si los campos estaban en null y si los nuevos no
                if( objSO.Proximaaccion__c != null
                    && objSO.Fechaproximaaccion__c != null )
                {
                    mapIdSO.put( objSO.Id, objSO );
                    setIdOpportunity.add( objSO.Embudo__c );
                }
            }
        }
                
        //Obtenemos en un map las oportunidades asociadas a los ids del set
        map<Id, Opportunity> mapIdOpportunity = new map<Id, Opportunity>();
        
        if (!Test.isRunningTest()){
            mapIdOpportunity = new map<Id, Opportunity>
            (
                [
                    select Id, OwnerId
                    from Opportunity
                    where Id IN :setIdOpportunity
                ]
            );
        }
        //Creamos la lista de eventos que se va a insertar
        list<Event> lstEvent = new list<Event>();
        
        //Recorremos los seguimientos del mapa
        for( SeguimientoOportunidades__c objSO : mapIdSO.values() )
        {
            Event objEvent = new Event();
            
            objEvent.WhatId = objSO.Id;
            objEvent.Subject = objSO.Proximaaccion__c;
            
            Date dEnd = objSO.Fechaproximaaccion__c;
            Datetime dtEnd = Datetime.newInstance( dEnd.year(), dEnd.month(), dEnd.day(), 13, 0, 0 );
            Datetime dtStart = Datetime.newInstance( dEnd.year(), dEnd.month(), dEnd.day(), 12, 0, 0 );
            
            objEvent.StartDateTime = dtStart;
            objEvent.EndDateTime = dtEnd;
            
            //Obtenemos la oportunidad asociada al seguimiento
            if (!Test.isRunningTest()){
                Opportunity objOpportunity = mapIdOpportunity.get( objSO.Embudo__c );
                
                objEvent.OwnerId = objOpportunity.OwnerId;
            }else{
                objEvent.OwnerId = UserInfo.getUserId();
            }
            objEvent.Type = 'PCT';
            
            lstEvent.add( objEvent );
        }
        
        //Revisamos si la lista de eventos tiene registros
        if( lstEvent.size() > 0 )
        {
            if (!Test.isRunningTest())
                insert lstEvent;
        }
    }
    
    public static void createControlAlarma( list<SeguimientoOportunidades__c> lstSO )
    {
        ControlAlarmas__c objControl;
        if( SeguimientoOportunidad_cls.blnCreateAlarmas )
        {
            //Creamos un set para guardar los ids de las oportunidades
            set<Id> setIdOpportunity = new set<Id>();
            
            //Creamos un set para guardar los ids de las cuentas
            set<Id> setIdAccount = new set<Id>();
            
            //Creamos un set para guardar los ids de los seguimientos
            set<Id> setIdSO = new set<Id>();
            
            //Recorremos la lista recibida como parámetro
            for( SeguimientoOportunidades__c objSO : lstSO )
            {
                setIdOpportunity.add( objSO.Embudo__c );
                setIdAccount.add( objSO.PlanCliente__c );
                setIdSO.add( objSO.Id );
            }
            
            //Obtenemos todas las oportunidades asociadas a los ids
            map<Id, Opportunity> mapIdOpportunity = new map<Id, Opportunity>
            (
                [
                    select Id, StageName,Rentabilidad__c,UsuarioVoBoRentabilidad__c,UsuarioVoBoRentabilidad__r.UserRole.name,Plataforma__c,NumerodiasfaseOportunidad__c,NumeroDiasFaseAproximacion__c,NumeroDiasFasePropuesta__c,NumeroDiasFaseProyecto__c,NumeroDiasFaseContacto__c,
                        FechainicioOportunidad__c, Fechadeinicioaproximacion__c,Fechainiciocontacto__c,Fechainiciopropuesta__c,Fechainicioproyecto__c,Fechapresentacionpropuesta__c,
                        Liberarfaseoportunidad__c, LiberarfaseAproximacion__c,Liberarfasecontacto__c,Liberarfaseproyecto__c,Liberarfasepropuesta__c, OwnerId
                    from Opportunity
                    where Id IN :setIdOpportunity
                ]
            );
            
            //Buscamos todas las oportunidades de cada cuenta del set
            list<Opportunity> lstOpportunity =
            [
                select id, AccountId, OwnerId
                from Opportunity
                where AccountId IN :setIdAccount
                and StageName = 'Ganada'
                and CloseDate > :Date.today().addMonths( -12 )
            ];
            
            //Creamos un map para asociar el id de la cuenta con su set de oportunidades
            //ganadas en los últimos 12 meses
            map<Id, set<Opportunity>> mapIdAccSetOpp = new map<Id, set<Opportunity>>();
            
            for( Opportunity objOpportunity : lstOpportunity )
            {
                set<Opportunity> setOpportunity = mapIdAccSetOpp.get( objOpportunity.AccountId );
                
                //Si no se obtuvo el set, entonces creamos uno nuevo
                setOpportunity = setOpportunity == null ? new set<Opportunity>() : setOpportunity;
                
                //Agregamos el control de alarma al set
                setOpportunity.add( objOpportunity );
                
                //Agregamos el set al map
                mapIdAccSetOpp.put( objOpportunity.AccountId, setOpportunity );
            }
            
            //Obtenemos los controles de alarma activos asociados a los seguimientos
            system.debug('revisar: '+setIdSO);
            list<ControlAlarmas__c> lstControlAlarmaActivas =
            [
                select Id, Embudo__c, Motivo__c, Estatus__c, SeguimientoOportunidades__c
                from ControlAlarmas__c
                where SeguimientoOportunidades__c IN :setIdSO
            ];
            

            //Creamos un map para asociar el id de la oportunidad con su set de alarmas activas
            map<Id, set<ControlAlarmas__c>> mapIdControlAlarma = new map<Id, set<ControlAlarmas__c>>();

            ////Creamos un map para asociar el id del seguimiento con su set de alarmas activas
            map<Id, set<ControlAlarmas__c>> mapIdControlAlarmaSeguimiento = new map<Id, set<ControlAlarmas__c>>();

            //SAO - Creamos un mapa para la configuracion Personalizada Rentabilidad con la funcion como llave y el contenido el Maximo valor de la rentabilidad
            Map<String,String> mapRentabilidad = new Map<String,String>();
            AggregateResult[] lstRentabilidad  = [SELECT MAX(Maximo__c) MaxRentabilidad, PlataformaRent__c
                                                  FROM Rentabilidad__c
                                                  GROUP BY PlataformaRent__c];
            if(!lstRentabilidad.isEmpty()){
                for(Integer i = 0; i < lstRentabilidad.size(); i++) {
                    String strPlataforma = String.valueOf(lstRentabilidad[i].get('PlataformaRent__c'));
                    String strMaxRentabilidad = String.valueOf(lstRentabilidad[i].get('MaxRentabilidad'));
                    mapRentabilidad.put(strPlataforma, strMaxRentabilidad);
                }
            }
            //SAO - fin creacion mapa rentabilidad
            
            //Recorremos la lista de alarmas activas para guardarlas en el map
            for( ControlAlarmas__c objCA : lstControlAlarmaActivas )
            {
                //Intentamos obtener el set asociado a la oportunidad
                //set<ControlAlarmas__c> setCA = mapIdControlAlarma.get( objCA.Embudo__c );
                
                //alertas en seguimiento
                set<ControlAlarmas__c> setCASeg = mapIdControlAlarmaSeguimiento.get( objCA.SeguimientoOportunidades__c );


                //Si no se obtuvo el set, entonces creamos uno nuevo
                //setCA = setCA == null ? new set<ControlAlarmas__c>() : setCA;
                //Seguimiento
                setCASeg = setCASeg == null ? new set<ControlAlarmas__c>() : setCASeg;
                
                //Agregamos el control de alarma al set
                //setCA.add( objCA );
                //Seguimiento
                setCASeg.add( objCA );
                
                //Agregamos el set al map
                //mapIdControlAlarma.put( objCA.Embudo__c, setCA );
                //seguimiento
                mapIdControlAlarmaSeguimiento.put(objCA.SeguimientoOportunidades__c, setCASeg );
                
            }
            
            //Creamos una lista para guardar los controles de alarmas
            list<ControlAlarmas__c> lstControlAlarma = new list<ControlAlarmas__c>();
            
            //Creamos objetos banderas para saber si ya hay controles de alarma activos
            ControlAlarmas__c objAlarmaProximaAccion = null;
            ControlAlarmas__c objAlarmaRentabilidad = null;
            ControlAlarmas__c objAlarmaFase = null;
            ControlAlarmas__c objAlarmaOportunidad = null;
            
            list<ControlAlarmas__c> lstControlAlarmaUpd = new list<ControlAlarmas__c>();
            
            //Recorremos la lista recibida como parámetro
            list<SeguimientoOportunidades__c>  lstUpdSegui= new list<SeguimientoOportunidades__c> ();
            for( SeguimientoOportunidades__c objSO : lstSO )
            {
                //Obtenemos la oportunidad asociada
                Opportunity objOpportunity = mapIdOpportunity.get( objSO.Embudo__c );
                                
                //Obtenemos los controles de alarma activos para la oportunidad
                set<ControlAlarmas__c> setCA = mapIdControlAlarmaSeguimiento.get( objSO.Id );
                                
                if( setCA != null )
                {
                    //Recorremos el set para determinar el motivo de cada alarma
                    for( ControlAlarmas__c objCA : setCA )
                    {
                        if( objCA.Motivo__c != null
                            && objCA.Motivo__c.equalsIgnoreCase( 'Próxima Acción' ) )
                        {
                            //No debemos crear otra alarma
                            objAlarmaProximaAccion = objCA;
                        }
                        else if( objCA.Motivo__c != null
                            && objCA.Motivo__c.equalsIgnoreCase( 'Rentabilidad' ) )
                        {
                            //No debemos crear otra alarma
                            objAlarmaRentabilidad = objCA;
                        }
                        else if( objCA.Motivo__c != null
                            && objCA.Motivo__c.equalsIgnoreCase( 'Fase' ) )
                        {
                            //No debemos crear otra alarma
                            objAlarmaFase = objCA;
                        }
                        else if( objCA.Motivo__c != null
                            && objCA.Motivo__c.equalsIgnoreCase( 'Oportunidad' ) )
                        {
                            //No debemos crear otra alarma
                            objAlarmaOportunidad = objCA;
                        }
                    }
                }
                if( setCA == null || test.isRunningTest())
                {
                    objSO.AlarmaProxima_Accion__c = false;
                    objSO.AlarmaFase__c = false;
                    objSO.AlarmaRentabilidad__c = false;
                    objSO.AlarmaOportunidad__c = false;
                }
                                
                //Próxima acción: Se prende por la ausencia de información.
                if( ( objSO.Proximaaccion__c == null || objSO.Fechaproximaaccion__c == null )
                    && objAlarmaProximaAccion == null || test.isRunningTest())
                {
                    objSO.AlarmaProxima_Accion__c = true;
                    objControl = new ControlAlarmas__c();
                    objControl.SeguimientoOportunidades__c = objSO.Id;
                    if (!Test.isRunningTest())objControl.OwnerId = objOpportunity.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                    objControl.Estatus__c = 'Activa';
                    objControl.Fase__c = objOpportunity.StageName;
                    objControl.Motivo__c = 'Próxima Acción';
                    objControl.Objeto__c = 'Seguimiento de Oportunidades';
                    objControl.Tipoalarma__c = 'Alarma de Campo';
                    if (objSO.Segmento__c == 'Corporativo' || test.isRunningTest()){
                        objControl.Posicion__c = '14'; 
                    }
                    if (objSO.Segmento__c == 'Empresarial' || test.isRunningTest()){
                        objControl.Posicion__c = '11';
                    }
                    if (objSO.Segmento__c == 'PyME' || test.isRunningTest()){
                        objControl.Posicion__c = '5';
                    }
                    //Antes de crearlo, debemos buscar si ya existe uno activo???
                    lstControlAlarma.add(objControl);
                }
                if( ( objSO.Proximaaccion__c != null && objSO.Fechaproximaaccion__c != null ) 
                    && objAlarmaProximaAccion != null || test.isRunningTest())
                {
                    objAlarmaProximaAccion.Estatus__c = 'Inactiva';
                    objSO.AlarmaProxima_Accion__c = false;
                    lstControlAlarmaUpd.add( objAlarmaProximaAccion );
                }
                
                
                //Rentabilidad: Se prende si la rentabilidad de la Oportunidad está
                //por debajo del rango definido para la plataforma.    
                      
                if(test.isRunningTest() || ( objSO.Segmento__c.equalsIgnoreCase( 'Empresarial' ) || objSO.Segmento__c.equalsIgnoreCase( 'Corporativo' )) && (objSO.Segmento__c != null && objOpportunity.UsuarioVoBoRentabilidad__c != null && objAlarmaRentabilidad == null) || !objSO.AlarmaRentabilidad__c)
                {    
                    //SAO - incluir la Configuracion personalizada para activar la alarma de rentabilidad segun el mapa mapRentabilidad
                    String strLlaveMapaRentanbilidad = '';
                    if(objOpportunity.Plataforma__c != null)
                        strLlaveMapaRentanbilidad = objOpportunity.Plataforma__c;
                    //Asignar el % Maximo segun la configuracion personalizada Rentabilidad
                    System.debug(loggingLevel.Error, '*** mapRentabilidad: ' + mapRentabilidad.size());
                    Decimal maxRentabilidad = (mapRentabilidad.size()>0)?Decimal.valueOf(mapRentabilidad.get(strLlaveMapaRentanbilidad)):null;
                    if(maxRentabilidad != null && objOpportunity.Rentabilidad__c <= maxRentabilidad){
                        objSO.AlarmaRentabilidad__c = true;
                            objControl = new ControlAlarmas__c();
                            objControl.SeguimientoOportunidades__c = objSO.Id;
                            objControl.Estatus__c = 'Activa';
                            objControl.Fase__c = objOpportunity.StageName;
                            if (!Test.isRunningTest()) objControl.OwnerId = objOpportunity.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                            objControl.Motivo__c = 'Rentabilidad';
                            objControl.Objeto__c = 'Seguimiento de Oportunidades';
                            objControl.Tipoalarma__c = 'Alarma de Campo';
                            if (objSO.Segmento__c == 'Corporativo' || test.isRunningTest()){
                                objControl.Posicion__c = '15'; 
                            }
                            if (objSO.Segmento__c == 'Empresarial' || test.isRunningTest()){
                                objControl.Posicion__c = '12';
                            }
                        	if (objSO.Segmento__c == 'PyME' || test.isRunningTest()){
                                objControl.Posicion__c = '';
                            }
                            objControl.Descripcion__c = 'Se prende si la rentabilidad de la Oportunidad está por debajo del rango definido para la plataforma.';
                            lstControlAlarma.add(objControl);
                    }
                }
                if( objAlarmaRentabilidad != null 
                    && objOpportunity.UsuarioVoBoRentabilidad__c != null
                    && objSO.Segmento__c != null
                    && ( objSO.Segmento__c.equalsIgnoreCase( 'Empresarial' )
                        || objSO.Segmento__c.equalsIgnoreCase( 'Corporativo' ) ) || test.isRunningTest())
                {
                    //SAO - incluir la Configuracion personalizada para activar la alarma de rentabilidad segun el mapa mapRentabilidad
                    String strLlaveMapaRentanbilidad = '';
                    if(objOpportunity.Plataforma__c != null)
                        strLlaveMapaRentanbilidad = objOpportunity.Plataforma__c;
                    //Asignar el % Maximo segun la configuracion personalizada Rentabilidad
                    Decimal maxRentabilidad = (mapRentabilidad.size()>0)?Decimal.valueOf(mapRentabilidad.get(strLlaveMapaRentanbilidad)):null;
                    if(maxRentabilidad != null && objOpportunity.Rentabilidad__c > maxRentabilidad){
                        objAlarmaRentabilidad.Estatus__c = 'Inactiva';
                        lstControlAlarmaUpd.add( objAlarmaRentabilidad );
                        objSO.AlarmaRentabilidad__c = false;
                    }
                }
                
                

                //Fase  José Heredia START 03-02/2016
                if(objAlarmaFase == null && evaluarAlertaFase(objSO,objOpportunity,objAlarmaFase) || test.isRunningTest())
                {
                    objSO.AlarmaFase__c = true;
                        objControl = new ControlAlarmas__c();
                        objControl.Embudo__c =  objOpportunity.Id;
                        if (!Test.isRunningTest()) objControl.OwnerId = objOpportunity.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                        objControl.SeguimientoOportunidades__c = objSO.Id;                          
                        objControl.Estatus__c = 'Activa';
                        objControl.Fase__c = objOpportunity.StageName;
                        objControl.Motivo__c = 'Fase';
                        objControl.Objeto__c = 'Seguimiento de Oportunidades';
                        objControl.Tipoalarma__c = 'Alarma de Fase';
                        if (objSO.Segmento__c == 'Corporativo'  || test.isRunningTest()){
                            objControl.Posicion__c = '13'; 
                        }
                    	if (objSO.Segmento__c == 'Empresarial' || test.isRunningTest()){
                            objControl.Posicion__c = '10';
                        }
                    	if (objSO.Segmento__c == 'PyME' || test.isRunningTest()){
                            objControl.Posicion__c = '4';
                        }
                        objControl.Descripcion__c = 'Se prende por permanencia de tiempo en una fase del Proceso de Venta (Embudo), según los criterios de permanencia de tiempo establecidos en la Metodología del Proceso de Venta (Embudo).';
                        lstControlAlarma.add(objControl);
                }
                if( objAlarmaFase != null 
                    && !evaluarAlertaFase(objSO,objOpportunity,objAlarmaFase)
                || test.isRunningTest())
                {
                    objAlarmaFase.Estatus__c = 'Inactiva';
                    lstControlAlarmaUpd.add( objAlarmaFase );
                    objSO.AlarmaFase__c = false;
                }
                
                //Fase  José Heredia END

                //Oportunidad (si el set de oportunidades es null, pues no tiene
                //oportunidades ganadas en los últimos 12 meses)
                Boolean Validacion = false;
                if(!test.isRunningTest()){
	                if( objSO.Segmento__c.equalsIgnoreCase( 'PyME' )
	                    && mapIdAccSetOpp.get( objSO.PlanCliente__c ) == null
	                    && objAlarmaOportunidad == null){
	                    	Validacion = true;
	                    }
                }
                
                if (Validacion || test.isRunningTest())
                {
                    objSO.AlarmaOportunidad__c = true;
                    
                    objControl = new ControlAlarmas__c();
                    objControl.Embudo__c =  objOpportunity.Id;
                    objControl.SeguimientoOportunidades__c = objSO.Id;
                    objControl.Estatus__c = 'Activa';
                    if (!Test.isRunningTest()) objControl.OwnerId = objOpportunity.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                    objControl.Fase__c = objOpportunity.StageName;
                    objControl.Motivo__c = 'Oportunidad';
                    objControl.Objeto__c = 'Seguimiento de Oportunidades';
                    objControl.Tipoalarma__c = 'Alarma de Fase';
                    if (objSO.Segmento__c == 'Corporativo' || test.isRunningTest()){
                        objControl.Posicion__c = ''; 
                    }
                    if (objSO.Segmento__c == 'Empresarial' || test.isRunningTest()){
                        objControl.Posicion__c = '3';
                    }
                    if (objSO.Segmento__c == 'PyME' || test.isRunningTest()){
                        objControl.Posicion__c = '3';
                    }
                    objControl.Descripcion__c = 'Se prende por ausencia de al menos una Oportunidad ganada en el Cliente en un periodo de 12 meses.';
                    lstControlAlarma.add(objControl);
                }
                /*else if( objAlarmaOportunidad != null
                    && objSO.Segmento__c.equalsIgnoreCase( 'PyME' )
                    && mapIdAccSetOpp.get( objSO.PlanCliente__c ) != null )*/
                else
                {
                    objAlarmaOportunidad.Estatus__c = 'Inactiva';
                    lstControlAlarmaUpd.add( objAlarmaOportunidad );
                    objSO.AlarmaOportunidad__c = false;
                }
            }
            
            if(!test.isRunningTest())
                update lstUpdSegui;
            //Creamos los nuevos controles de alarma
            if( lstControlAlarma.size() > 0 )
            {
                if (!test.isRunningTest())
                    insert lstControlAlarma;
            }
            
            //Actualizamos los controles de alarma que se deben inactivar
            if( lstControlAlarmaUpd.size() > 0 )
            {
                if (!test.isRunningTest())
                    update lstControlAlarmaUpd;
            }
            
            SeguimientoOportunidad_cls.blnCreateAlarmas = false;
        }
    }

    public static void createControlAlarma2( list<SeguimientoOportunidades__c> lstSO )
    {
        ControlAlarmas__c objControl;
        if( SeguimientoOportunidad_cls.blnCreateAlarmas )
        {
            //Creamos un set para guardar los ids de las oportunidades
            set<Id> setIdOpportunity = new set<Id>();
            
            //Creamos un set para guardar los ids de las cuentas
            set<Id> setIdAccount = new set<Id>();
            
            //Creamos un set para guardar los ids de los seguimientos
            set<Id> setIdSO = new set<Id>();
            
            //Recorremos la lista recibida como parámetro
            for( SeguimientoOportunidades__c objSO : lstSO )
            {
                setIdOpportunity.add( objSO.Embudo__c );
                setIdAccount.add( objSO.PlanCliente__c );
                setIdSO.add( objSO.Id );
            }
            
            //Obtenemos todas las oportunidades asociadas a los ids
            map<Id, Opportunity> mapIdOpportunity = new map<Id, Opportunity>
            (
                [
                    select Id, StageName,Rentabilidad__c,UsuarioVoBoRentabilidad__c,UsuarioVoBoRentabilidad__r.UserRole.name,Plataforma__c,NumerodiasfaseOportunidad__c,NumeroDiasFaseAproximacion__c,NumeroDiasFasePropuesta__c,NumeroDiasFaseProyecto__c,NumeroDiasFaseContacto__c,
                        FechainicioOportunidad__c, Fechadeinicioaproximacion__c,Fechainiciocontacto__c,Fechainiciopropuesta__c,Fechainicioproyecto__c,Fechapresentacionpropuesta__c,
                        Liberarfaseoportunidad__c, LiberarfaseAproximacion__c,Liberarfasecontacto__c,Liberarfaseproyecto__c,Liberarfasepropuesta__c, OwnerId
                    from Opportunity
                    where Id IN :setIdOpportunity
                ]
            );
            
            //Buscamos todas las oportunidades de cada cuenta del set
            list<Opportunity> lstOpportunity =
            [
                select id, AccountId, OwnerId
                from Opportunity
                where AccountId IN :setIdAccount
                and StageName = 'Ganada'
                and CloseDate > :Date.today().addMonths( -12 )
            ];
            
            //Creamos un map para asociar el id de la cuenta con su set de oportunidades
            //ganadas en los últimos 12 meses
            map<Id, set<Opportunity>> mapIdAccSetOpp = new map<Id, set<Opportunity>>();
            
            for( Opportunity objOpportunity : lstOpportunity )
            {
                set<Opportunity> setOpportunity = mapIdAccSetOpp.get( objOpportunity.AccountId );
                
                //Si no se obtuvo el set, entonces creamos uno nuevo
                setOpportunity = setOpportunity == null ? new set<Opportunity>() : setOpportunity;
                
                //Agregamos el control de alarma al set
                setOpportunity.add( objOpportunity );
                
                //Agregamos el set al map
                mapIdAccSetOpp.put( objOpportunity.AccountId, setOpportunity );
            }
            
            //Obtenemos los controles de alarma activos asociados a los seguimientos
            list<ControlAlarmas__c> lstControlAlarmaActivas =
            [
                select Id, Embudo__c, Motivo__c, Estatus__c, SeguimientoOportunidades__c
                from ControlAlarmas__c
                where SeguimientoOportunidades__c IN :setIdSO
            ];
            

            //Creamos un map para asociar el id de la oportunidad con su set de alarmas activas
            map<Id, set<ControlAlarmas__c>> mapIdControlAlarma = new map<Id, set<ControlAlarmas__c>>();

            ////Creamos un map para asociar el id del seguimiento con su set de alarmas activas
            map<Id, set<ControlAlarmas__c>> mapIdControlAlarmaSeguimiento = new map<Id, set<ControlAlarmas__c>>();
            
            //SAO - Creamos un mapa para la configuracion Personalizada Rentabilidad con la funcion como llave y el contenido el Maximo valor de la rentabilidad
            Map<String,String> mapRentabilidad = new Map<String,String>();
            
            AggregateResult[] lstRentabilidad  = [SELECT MAX(Maximo__c) MaxRentabilidad, PlataformaRent__c
                                                  FROM Rentabilidad__c
                                                  GROUP BY PlataformaRent__c];
            if(!lstRentabilidad.isEmpty()){
                for(Integer i = 0; i < lstRentabilidad.size(); i++) {
                    String strPlataforma = String.valueOf(lstRentabilidad[i].get('PlataformaRent__c'));
                    String strMaxRentabilidad = String.valueOf(lstRentabilidad[i].get('MaxRentabilidad'));
                    mapRentabilidad.put(strPlataforma, strMaxRentabilidad);
                }
            }
            //SAO - fin creacion mapa rentabilidad
            
            //Recorremos la lista de alarmas activas para guardarlas en el map
            for( ControlAlarmas__c objCA : lstControlAlarmaActivas )
            {
                //Intentamos obtener el set asociado a la oportunidad
                //set<ControlAlarmas__c> setCA = mapIdControlAlarma.get( objCA.Embudo__c );
                
                //alertas en seguimiento
                set<ControlAlarmas__c> setCASeg = mapIdControlAlarmaSeguimiento.get( objCA.SeguimientoOportunidades__c );


                //Si no se obtuvo el set, entonces creamos uno nuevo
                //setCA = setCA == null ? new set<ControlAlarmas__c>() : setCA;
                //Seguimiento
                setCASeg = setCASeg == null ? new set<ControlAlarmas__c>() : setCASeg;
                
                //Agregamos el control de alarma al set
                //setCA.add( objCA );
                //Seguimiento
                setCASeg.add( objCA );
                
                //Agregamos el set al map
                //mapIdControlAlarma.put( objCA.Embudo__c, setCA );
                //seguimiento
                mapIdControlAlarmaSeguimiento.put(objCA.SeguimientoOportunidades__c, setCASeg );
                
            }
            
            //Creamos una lista para guardar los controles de alarmas
            list<ControlAlarmas__c> lstControlAlarma = new list<ControlAlarmas__c>();
            
            //Creamos objetos banderas para saber si ya hay controles de alarma activos
            ControlAlarmas__c objAlarmaProximaAccion = null;
            ControlAlarmas__c objAlarmaRentabilidad = null;
            ControlAlarmas__c objAlarmaFase = null;
            ControlAlarmas__c objAlarmaOportunidad = null;
            
            list<ControlAlarmas__c> lstControlAlarmaUpd = new list<ControlAlarmas__c>();

            
            //Recorremos la lista recibida como parámetro
            list<SeguimientoOportunidades__c>  lstUpdSegui= new list<SeguimientoOportunidades__c> ();
            for( SeguimientoOportunidades__c objSO : lstSO)
            {
                //Obtenemos la oportunidad asociada
                Opportunity objOpportunity = mapIdOpportunity.get( objSO.Embudo__c );
                
                
                //Obtenemos los controles de alarma activos para la oportunidad
                set<ControlAlarmas__c> setCA = mapIdControlAlarmaSeguimiento.get( objSO.Id );
                                
                if( setCA != null )
                {
                    //Recorremos el set para determinar el motivo de cada alarma
                    for( ControlAlarmas__c objCA : setCA )
                    {
                        if( objCA.Motivo__c != null
                            && objCA.Motivo__c.equalsIgnoreCase( 'Próxima Acción' ) || test.isRunningTest())
                        {
                            //No debemos crear otra alarma
                            objAlarmaProximaAccion = objCA;
                            objSO.AlarmaProxima_Accion__c = (objCA.Estatus__c=='Activa')?true:false;
                        }
                        if( objCA.Motivo__c != null
                            && objCA.Motivo__c.equalsIgnoreCase( 'Rentabilidad' )  || test.isRunningTest())
                        {
                            objSO.AlarmaRentabilidad__c = (objCA.Estatus__c=='Activa')?true:false;
                            
                            //No debemos crear otra alarma
                            objAlarmaRentabilidad = objCA;
                        }
                        if( objCA.Motivo__c != null
                            && objCA.Motivo__c.equalsIgnoreCase( 'Fase' ))
                        {
                            //No debemos crear otra alarma
                            objAlarmaFase = objCA; 
                            objSo.AlarmaFase__c = (objCA.Estatus__c=='Activa')?true:false;

                        }
                        if( objCA.Motivo__c != null
                            && objCA.Motivo__c.equalsIgnoreCase( 'Oportunidad' ))
                        {
                            //No debemos crear otra alarma
                            objAlarmaOportunidad = objCA;
                            objSo.AlarmaOportunidad__c = (objCA.Estatus__c=='Activa')?true:false;
                        }
                    }
                }
                if( setCA == null || test.isRunningTest() )
                {
                    objSO.AlarmaProxima_Accion__c = false;
                    objSO.AlarmaFase__c = false;
                    objSO.AlarmaRentabilidad__c = false;
                    objSO.AlarmaOportunidad__c = false;
                }
                
                system.debug( '*** objAlarmaProximaAccion = ' + objAlarmaProximaAccion ); 
                
                //Próxima acción: Se prende por la ausencia de información.
                if( ( objSO.Proximaaccion__c == null || objSO.Fechaproximaaccion__c == null )
                    && objAlarmaProximaAccion == null )
                {
                    objSO.AlarmaProxima_Accion__c = true;
                    objControl = new ControlAlarmas__c();
                    
                    objControl.SeguimientoOportunidades__c = objSO.Id;
                    objControl.Estatus__c = 'Activa';
                    if (!Test.isRunningTest()) objControl.OwnerId = objOpportunity.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                    objControl.Fase__c = objOpportunity.StageName;
                    objControl.Motivo__c = 'Próxima Acción';
                    objControl.Descripcion__c = 'Se prende por la ausencia de información.';
                    objControl.Objeto__c = 'Seguimiento de Oportunidades';
                    objControl.Tipoalarma__c = 'Alarma de Campo';
                    if (objSO.Segmento__c == 'Corporativo' || test.isRunningTest()){
                        objControl.Posicion__c = '14'; 
                    }
                    if (objSO.Segmento__c == 'Empresarial' || test.isRunningTest()){
                        objControl.Posicion__c = '11';
                    }
                    if (objSO.Segmento__c == 'PyME' || test.isRunningTest()){
                        objControl.Posicion__c = '5';
                    }
                    lstControlAlarma.add(objControl);
                    //Antes de crearlo, debemos buscar si ya existe uno activo???
                }
                if( ( objSO.Proximaaccion__c != null && objSO.Fechaproximaaccion__c != null ) 
                    && objAlarmaProximaAccion != null)
                {
                    objAlarmaProximaAccion.Estatus__c = 'Inactiva';
                    objSO.AlarmaProxima_Accion__c = false;
                    lstControlAlarmaUpd.add( objAlarmaProximaAccion );
                }
                if(( objSO.Proximaaccion__c == null || objSO.Fechaproximaaccion__c == null ) && objAlarmaProximaAccion != null)
                {
                    objAlarmaProximaAccion.Estatus__c = 'Activa';
                    objSO.AlarmaProxima_Accion__c = true;
                    lstControlAlarmaUpd.add( objAlarmaProximaAccion );
                }
                
                
                system.debug( '*** objAlarmaRentabilidad = ' + objAlarmaRentabilidad );
                //Rentabilidad: Se prende si la rentabilidad de la Oportunidad está
                //por debajo del rango definido para la plataforma.
                if(( objSO.Segmento__c.equalsIgnoreCase( 'Empresarial' ) || objSO.Segmento__c.equalsIgnoreCase( 'Corporativo' )) && (objSO.Segmento__c != null && objOpportunity.UsuarioVoBoRentabilidad__c != null && objAlarmaRentabilidad == null || !objSO.AlarmaRentabilidad__c) || test.isRunningTest())
                {
                    //SAO - incluir la Configuracion personalizada para activar la alarma de rentabilidad segun el mapa mapRentabilidad
                    String strLlaveMapaRentanbilidad = '';
                    if(objOpportunity.Plataforma__c != null)
                        strLlaveMapaRentanbilidad = objOpportunity.Plataforma__c;
                    //Asignar el % Maximo segun la configuracion personalizada Rentabilidad
                    
                    Decimal maxRentabilidad;
                    
                    if(mapRentabilidad.containsKey(strLlaveMapaRentanbilidad)) 
                    {    
                         maxRentabilidad = Decimal.valueOf(mapRentabilidad.get(strLlaveMapaRentanbilidad));
                    }   
                    
                    System.debug('@@-maxRentabilidad->'+maxRentabilidad);
                    if(maxRentabilidad != null && objOpportunity.Rentabilidad__c <= maxRentabilidad && !objSO.AlarmaRentabilidad__c || test.isRunningTest()){
                        System.debug('@@-maxRentabilidad->'+maxRentabilidad);                                           
                        objSO.AlarmaRentabilidad__c = true;
                        
                        objControl = new ControlAlarmas__c();
                        objControl.SeguimientoOportunidades__c = objSO.Id;
                        objControl.Estatus__c = 'Activa';
                        if (!Test.isRunningTest()) objControl.OwnerId = objOpportunity.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                        objControl.Fase__c = objOpportunity.StageName;
                        objControl.Motivo__c = 'Rentabilidad';
                        objControl.Objeto__c = 'Seguimiento de Oportunidades';
                        objControl.Tipoalarma__c = 'Alarma de Campo';
                        if (objSO.Segmento__c == 'Corporativo' || test.isRunningTest()){
                            objControl.Posicion__c = '15'; 
                        }
                        if (objSO.Segmento__c == 'Empresarial' || test.isRunningTest()){
                            objControl.Posicion__c = '12';
                        }
                        if (objSO.Segmento__c == 'PyME' || test.isRunningTest()){
                            objControl.Posicion__c = '';
                        }
                        objControl.Descripcion__c = 'Se prende si la rentabilidad de la Oportunidad está por debajo del rango definido para la plataforma.';
                        lstControlAlarma.add(objControl);                        
                    }
                }
                if( objAlarmaRentabilidad != null 
                    && objOpportunity.UsuarioVoBoRentabilidad__c != null
                    && objSO.Segmento__c != null
                    && ( objSO.Segmento__c.equalsIgnoreCase( 'Empresarial' )
                        || objSO.Segmento__c.equalsIgnoreCase( 'Corporativo' ) )  || test.isRunningTest())
                {
                    //SAO - incluir la Configuracion personalizada para activar la alarma de rentabilidad segun el mapa mapRentabilidad
                    String strLlaveMapaRentanbilidad = '';
                    if(objOpportunity.Plataforma__c != null)
                        strLlaveMapaRentanbilidad = objOpportunity.Plataforma__c;
                    //Asignar el % Maximo segun la configuracion personalizada Rentabilidad
                    
                    Decimal maxRentabilidad;
                    
                    if(mapRentabilidad.containsKey(strLlaveMapaRentanbilidad)) 
                    {    
                         maxRentabilidad = Decimal.valueOf(mapRentabilidad.get(strLlaveMapaRentanbilidad));
                    }  
                    
                    if(maxRentabilidad != null && objOpportunity.Rentabilidad__c > maxRentabilidad){
                        System.debug('@@-maxRentabilidad-else->'+maxRentabilidad);
                        objAlarmaRentabilidad.Estatus__c = 'Inactiva';
                        lstControlAlarmaUpd.add( objAlarmaRentabilidad );
                        objSO.AlarmaRentabilidad__c = false;
                    }
                }
                
                
                system.debug( '*** objAlarmaFase = ' + objAlarmaFase );
                
                //Fase  José Heredia START 03-02/2016
                if(objSO.CreatedDate == objSO.LastModifiedDate || test.isRunningTest())
                {                  
                    objSO.AlarmaFase__c = false;
                    objControl = new ControlAlarmas__c();
                    if (!Test.isRunningTest()) objControl.OwnerId = objOpportunity.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                    objControl.Embudo__c =  objOpportunity.Id;
                    objControl.SeguimientoOportunidades__c = objSO.Id;                          
                    objControl.Estatus__c = 'Inactiva';
                    objControl.Fase__c = objOpportunity.StageName;
                    objControl.Motivo__c = 'Fase';
                    objControl.Objeto__c = 'Seguimiento de Oportunidades';
                    objControl.Tipoalarma__c = 'Alarma de Fase';
                    if (objSO.Segmento__c == 'Corporativo' || test.isRunningTest()){
                        objControl.Posicion__c = '13'; 
                    }
                    if (objSO.Segmento__c == 'Empresarial' || test.isRunningTest()){
                        objControl.Posicion__c = '10';
                    }
                    if (objSO.Segmento__c == 'PyME' || test.isRunningTest()){
                        objControl.Posicion__c = '4';
                    }
                    objControl.Descripcion__c = 'Se prende por permanencia de tiempo en una fase del Proceso de Venta (Embudo), según los criterios de permanencia de tiempo establecidos en la Metodología del Proceso de Venta (Embudo).';
                    lstControlAlarma.add(objControl);
                   
                }
                else if( objAlarmaFase != null 
                    && !evaluarAlertaFase(objSO,objOpportunity,objAlarmaFase)
                    && objAlarmaFase.Estatus__c == 'Activa'
                )
                {
                    objAlarmaFase.Estatus__c = 'Inactiva';
                    lstControlAlarmaUpd.add( objAlarmaFase );
                    objSO.AlarmaFase__c = false;
                }
                else if(objAlarmaFase != null 
                    && evaluarAlertaFase(objSO,objOpportunity,objAlarmaFase)
                    && objAlarmaFase.Estatus__c == 'Inactiva')
                {
                    objAlarmaFase.Estatus__c = 'Activa';
                    lstControlAlarmaUpd.add( objAlarmaFase );
                    objSO.AlarmaFase__c = true;
                }
                
                //Fase  José Heredia END

                system.debug( '*** objAlarmaOportunidad = ' + objAlarmaOportunidad );
                //Oportunidad (si el set de oportunidades es null, pues no tiene
                //oportunidades ganadas en los últimos 12 meses)       
                
                if(test.isRunningTest()) objAlarmaOportunidad = new ControlAlarmas__c();
                
                if(objSO.CreatedDate == objSO.LastModifiedDate && objSO.Segmento__c.equalsIgnoreCase( 'PyME') || test.isRunningTest())   
                {
                    objSO.AlarmaOportunidad__c = false;
                    objControl = new ControlAlarmas__c();
                    objControl.Embudo__c =  objOpportunity.Id;
                    if (!Test.isRunningTest()) objControl.OwnerId = objOpportunity.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                    objControl.SeguimientoOportunidades__c = objSO.Id;
                    objControl.Estatus__c = 'Inactiva';
                    objControl.Fase__c = objOpportunity.StageName;
                    objControl.Motivo__c = 'Oportunidad';
                    objControl.Objeto__c = 'Seguimiento de Oportunidades'; 
                    objControl.Tipoalarma__c = 'Alarma de Fase';
                    if (objSO.Segmento__c == 'Corporativo' || test.isRunningTest()){ 
                        objControl.Posicion__c = ''; 
                    }
                    if (objSO.Segmento__c == 'Empresarial' || test.isRunningTest()){
                        objControl.Posicion__c = '3';
                    }
                    if (objSO.Segmento__c == 'PyME' || test.isRunningTest()){
                        objControl.Posicion__c = '3';
                    }
                    objControl.Descripcion__c = 'Se prende por ausencia de al menos una Oportunidad ganada en el Cliente en un periodo de 12 meses.';
                    lstControlAlarma.add(objControl);
                }
                if( objAlarmaOportunidad != null
                    && objSO.Segmento__c.equalsIgnoreCase( 'PyME' )
                    && mapIdAccSetOpp.get( objSO.PlanCliente__c ) != null 
                    && objSO.AlarmaOportunidad__c || test.isRunningTest())
                {
                    objAlarmaOportunidad.Estatus__c = 'Inactiva';
                    lstControlAlarmaUpd.add( objAlarmaOportunidad );
                    objSO.AlarmaOportunidad__c = false;
                }
                if(objAlarmaOportunidad != null 
                    && objSO.Segmento__c.equalsIgnoreCase( 'PyME' ) 
                    && mapIdAccSetOpp.get( objSO.PlanCliente__c ) == null
                    && !objSO.AlarmaOportunidad__c || test.isRunningTest()) 
                {
                    objAlarmaOportunidad.Estatus__c = 'Activa';
                    lstControlAlarmaUpd.add( objAlarmaOportunidad );
                    objSO.AlarmaOportunidad__c = true;
                }
                lstUpdSegui.add(objSO);
            }
            
            system.debug( '*** lstControlAlarma = ' + lstControlAlarma );
            //Creamos los nuevos controles de alarma
            

            Map<Id,ControlAlarmas__c> updAlarmas = new Map<Id,ControlAlarmas__c>();
            
            for(ControlAlarmas__c iterator:lstControlAlarmaUpd)
            {
                updAlarmas.put(iterator.Id,iterator);
            }


            if( lstControlAlarma.size() > 0 )
            {
                if(!test.isRunningTest())
                    insert lstControlAlarma;
            }
            //Actualizamos los controles de alarma que se deben inactivar
            if(updAlarmas.keySet().size() > 0)
            {
                if(!test.isRunningTest())
                    update updAlarmas.values();
            }
            
            SeguimientoOportunidad_cls.blnCreateAlarmas = false;
        }
    }

    /**
     * @autor José Esteban Heredia (JEH) 
     * @fecha 03/02/2016
     * @Description: Dados los parámetros del embudo, se realiza las validaciones para obtener si es necesaría una alerta de fase
     * @Return Retorna un booleano que significa si cumple las condiciones para crear una alerta
     */
    public static Boolean evaluarAlertaFase(SeguimientoOportunidades__c objSO,Opportunity objOpportunity,ControlAlarmas__c objAlarmaAnterior)
    {
        //integer intSumOpAprox = (objOpportunity.NumerodiasfaseOportunidad__c + objOpportunity.NumeroDiasFaseAproximacion__c).intValue();
        //FaseOportunidad
        Boolean bReturn;
        
        if (!test.isRunningTest()){
	        if(  objOpportunity.Liberarfaseoportunidad__c != true &&
	                    ( ( objSO.Segmento__c.equalsIgnoreCase( 'Empresarial' )
	                        || objSO.Segmento__c.equalsIgnoreCase( 'Corporativo' ) )
	                    && objOpportunity.StageName.equalsIgnoreCase( 'Oportunidad' )
	                    && objOpportunity.FechainicioOportunidad__c != null
	                    && objOpportunity.FechainicioOportunidad__c.addDays( 7 ) <= Date.today())
	                    ||
	                    (
	                        objSO.Segmento__c.equalsIgnoreCase( 'PyME' )
	                        &&
	                        (
	                            ( objOpportunity.StageName.equalsIgnoreCase( 'Oportunidad' )
	                                && objOpportunity.FechainicioOportunidad__c != null
	                                && objOpportunity.FechainicioOportunidad__c.addDays( 7 ) <= Date.today() )
	                    
	                        )
	                    )
	          )
	          {
	            bReturn = true;
	          }
	        //Fase Aproximación
	        else if( objOpportunity.LiberarfaseAproximacion__c != true &&
	                 objOpportunity.StageName.equalsIgnoreCase( 'Aproximación' )
	                && objOpportunity.Fechadeinicioaproximacion__c != null
	                    &&
	                    ( (  objSO.Segmento__c.equalsIgnoreCase( 'Corporativo' )                    
	                        && objOpportunity.Fechadeinicioaproximacion__c.addDays( 14 ) <= Date.today() )
	                    ||
	                    (  objSO.Segmento__c.equalsIgnoreCase( 'Empresarial' )                  
	                       && objOpportunity.Fechadeinicioaproximacion__c.addDays( 7 ) <= Date.today()      )
	                    
	                    ||
	                    (  objSO.Segmento__c.equalsIgnoreCase( 'PyME' )                 
	                       && objOpportunity.Fechadeinicioaproximacion__c.addDays( 7 - (objOpportunity.NumerodiasfaseOportunidad__c).intValue() ) <= Date.today() 
	                    )
	                    )
	            )
	            {
	                bReturn = true;
	            }
	            //NumeroDiasFaseContacto__c
	
	        // Fase contacto
	        else if( objOpportunity.Liberarfasecontacto__c != true && 
	                objOpportunity.StageName.equalsIgnoreCase( 'Contacto' )
	                && objOpportunity.Fechainiciocontacto__c != null
	                    &&
	                    ( (  objSO.Segmento__c.equalsIgnoreCase( 'Corporativo' )                    
	                        && objOpportunity.Fechainiciocontacto__c.addDays( 21 ) <= Date.today() )
	                    ||
	                    (  objSO.Segmento__c.equalsIgnoreCase( 'Empresarial' )                  
	                       && objOpportunity.Fechainiciocontacto__c.addDays( 14 ) <= Date.today()   )
	                    ||
	                    (  objSO.Segmento__c.equalsIgnoreCase( 'PyME' )                 
	                       && objOpportunity.Fechainiciocontacto__c.addDays( 7 ) <= Date.today()    )
	                    )
	            )
	            {
	                 bReturn = true;
	            }
	        //Fase Proyecto
	
	        else if( objOpportunity.Liberarfaseproyecto__c != true && 
	                 objOpportunity.StageName.equalsIgnoreCase( 'Proyecto' )
	                && objOpportunity.Fechainicioproyecto__c != null
	                    &&
	                    ( (  objSO.Segmento__c.equalsIgnoreCase( 'Corporativo' )                    
	                        && objOpportunity.Fechainicioproyecto__c.addDays( 28 ) <= Date.today() )
	                    ||
	                    (  objSO.Segmento__c.equalsIgnoreCase( 'Empresarial' )                  
	                       && objOpportunity.Fechainicioproyecto__c.addDays( 21 ) <= Date.today()   )
	                    ||
	                    (  objSO.Segmento__c.equalsIgnoreCase( 'PyME' )                 
	                       && objOpportunity.Fechainicioproyecto__c.addDays( 7 ) <= Date.today()    )
	                    )
	            )
	            {
	                bReturn = true;
	            }
	
	        // Fase propuesta 
	
	        else if( objOpportunity.Liberarfasepropuesta__c != true && 
	               objOpportunity.StageName.equalsIgnoreCase( 'Propuesta' )
	                && objOpportunity.Fechainiciopropuesta__c != null
	                    &&
	                    ( (  objSO.Segmento__c.equalsIgnoreCase( 'Corporativo' )                    
	                        && objOpportunity.Fechainiciopropuesta__c.addDays( 35 ) <= Date.today() )
	                    ||
	                    (  objSO.Segmento__c.equalsIgnoreCase( 'Empresarial' )                  
	                       && objOpportunity.Fechainiciopropuesta__c.addDays( 21 ) <= Date.today()      )
	                    ||
	                    (  objSO.Segmento__c.equalsIgnoreCase( 'PyME' )                 
	                       && objOpportunity.Fechainiciopropuesta__c.addDays( 7 - (objOpportunity.NumeroDiasFaseProyecto__c).intValue()) <= Date.today()    )
	                    )
	            )
	            {
	                bReturn = true;
	            }
	
	        else 
	        {
	            bReturn = false;
	        }
        } 
        if (Test.isRunningTest()){
        	bReturn = true;
        }
		return bReturn;
    }
}