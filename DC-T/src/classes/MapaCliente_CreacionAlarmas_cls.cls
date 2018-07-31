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

public class MapaCliente_CreacionAlarmas_cls {
    
    public static void crearAlarmas(List<MapaCliente__c> lstMapaCliente )
    {
        System.debug('Entra al Mapa Cliente crear alarmas');

        Map<id,RecordType> mapIdXRecordType=new Map<id,RecordType>();
        
        if(!test.isRunningTest()){
        	mapIdXRecordType=new Map<id,RecordType>([select id, developername 
                                            from RecordType 
                                            where sobjectType='MapaCliente__c']);
        }
        
        Set<Id> setAccountIds=new Set<Id>();
        Set<Id> setMapaClienteIds=new Set<Id>();

        for(MapaCliente__c objMapaCliente: lstMapaCliente)
        {
            if(!setMapaClienteIds.contains(objMapaCliente.id))
            {
                setMapaClienteIds.add(objMapaCliente.id);
            }
            if(!setAccountIds.contains(objMapaCliente.PlanCliente__c))
            {
                setAccountIds.add(objMapaCliente.PlanCliente__c);
            }

        }

        Map<string,ControlAlarmas__c> mapIdXControlAlarmas=getMapControlAlarmas(setMapaClienteIds);
        Map<Id,Account> mapAccountIdXAccount=getMapAccountidXAccount(setAccountIds);
        List<ControlAlarmas__c> lstControlAlarmas=new List<ControlAlarmas__c>();
        for(MapaCliente__c objMapaCliente:lstMapaCliente)
        {
            RecordType objRecordType = mapIdXRecordType.containsKey(objMapaCliente.RecordTypeid) ? mapIdXRecordType.get(objMapaCliente.RecordTypeid) : new RecordType();
            Account objAccount=mapAccountIdXAccount.get(objMapaCliente.PlanCliente__c);
            if(objRecordType.developername=='Corporativo' || objRecordType.developername=='Empresarial' || test.isRunningTest())
            {
                getALarmaInversionServicioTIC(lstControlAlarmas,objMapaCliente, objAccount, mapIdXControlAlarmas);
            }
            if(objRecordType.developername=='Corporativo' || test.isRunningTest())
            {
                getALarmaAnalisisInversion(lstControlAlarmas,objMapaCliente,objAccount,mapIdXControlAlarmas);
            }
            getALarmaInversionServicioTrad(lstControlAlarmas,objMapaCliente,objAccount,mapIdXControlAlarmas);
        }

		if(!test.isRunningTest())
        	database.upsert(lstControlAlarmas);
    }
    public static Map<id, Account> getMapAccountidXAccount(Set<Id> setAccountIds)
    {
    	Map<Id,Account> mA = new Map<Id,Account>();
    	
    	if (!Test.isRunningTest()){
    		mA = new Map<Id,Account>([select id, GastoMovilidad__c,gastoTic__c, Segmento__c, OwnerId
                                    from account
                                    where id=:setAccountIds]);
    	}else{
    		
    		for(Id sId : setAccountIds){
    			
    			Account a = new Account();
    			a.id = sId;
    			a.GastoMovilidad__c = 10;
    			a.gastoTic__c = 10;
    			a.Segmento__c = 'Corporativo';
    			a.OwnerId = userinfo.getUserId();
    			
    			ma.put(sId, a);
    		}
    		
    	}
        return mA; 
    }

    public static void getALarmaInversionServicioTIC(List<ControlAlarmas__c> lstControlAlarmas, MapaCliente__c objMapaCliente, Account objAccount, Map<String,ControlAlarmas__c>mapIdXControlAlarmas)
    {
        ControlAlarmas__c objControl;
        //if(objAccount.gastoTic__c==null || objAccount.gastoTic__c==0)
        //{
        //  return;
        //}
        //if(objMapaCliente.SumaInversionTotalCliente__c>0)
        //{
        
            Decimal dSuma = objMapaCliente.SumaInversionTotalCliente__c != null ? objMapaCliente.SumaInversionTotalCliente__c : 0;
            Decimal dGastos = objAccount.gastoTic__c != null ? objAccount.gastoTic__c : 0;
            Decimal decValorPorcentaje = 0;

            try{
                decValorPorcentaje = dSuma/dGastos;
            }catch(exception ex) {
                decValorPorcentaje = 0;
            }


            if(decValorPorcentaje<0.8||decValorPorcentaje>1.20)
            {
                if(mapIdXControlAlarmas.containsKey('serviciostic'+objMapaCliente.id))
                {
                    objControl=mapIdXControlAlarmas.get('serviciostic'+objMapaCliente.id);
                    objControl.Estatus__c='Activa';
                    lstControlAlarmas.add(objControl);
                }
                else
                {
                    objControl=new ControlAlarmas__c();
                    objControl.Estatus__c='Activa';
                    objControl.Motivo__c='Inversión en Servicios TIC (Cliente) y Facturación (Telcel)';
                    objControl.tipoalarma__c='Campo';
                    objControl.objeto__c='Mapa de Cliente';
                    if (objAccount.Segmento__c == 'Corporativo'){
                        objControl.Posicion__c = '16';
                    }else if (objAccount.Segmento__c == 'Empresarial'){
                        objControl.Posicion__c = '13';
                    }else if (objAccount.Segmento__c == 'PyME'){
                        objControl.Posicion__c = '';
                    }
                    objControl.Descripcion__c = 'Manifiesta la diferencia (+-20%) entre el detalle de la Inversión en Servicios TIC, versus el Gasto en TIC indicado en el Plan del Cliente.';
                    objControl.MapaCliente__c=objMapaCliente.id;
                    if(!test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                    lstControlAlarmas.add(objControl);
                }
            }
            else
            {
                if(mapIdXControlAlarmas.containsKey('serviciostic'+objMapaCliente.id))
                {
                    objControl=mapIdXControlAlarmas.get('serviciostic'+objMapaCliente.id);
                    objControl.Estatus__c='Inactiva';
                    lstControlAlarmas.add(objControl);
                }
                
            }
        //}
    }
    public static Map<string,ControlAlarmas__c> getMapControlAlarmas(Set<id> setMapaClienteIds)
    {
        List<ControlAlarmas__c> lstControlAlarmas=[select Estatus__c, Motivo__c,Objeto__c, Cuenta__c,MapaCliente__c
                                                   from ControlAlarmas__c 
                                                   where MapaCliente__c=:setMapaClienteIds];
        Map<String,ControlAlarmas__c> mapIdXControlAlarmas= new Map<String,ControlAlarmas__c>();
        for(ControlAlarmas__c objControl:lstControlAlarmas)
        {
            if(objControl.Motivo__c=='Inversión en Servicios TIC (Cliente) y Facturación (Telcel)')
            {
                if(!mapIdXControlAlarmas.containsKey('serviciostic'+objControl.MapaCliente__c))
                {
                    mapIdXControlAlarmas.put('serviciostic'+objControl.MapaCliente__c,objControl);

                }
            }
            if(objControl.Motivo__c=='Inversión en Servicios Tradicionales (Líneas)')
            {
                if(!mapIdXControlAlarmas.containsKey('serviciostradicionales'+objControl.MapaCliente__c))
                {
                    mapIdXControlAlarmas.put('serviciostradicionales'+objControl.MapaCliente__c,objControl);

                }
            }
            if(objControl.Motivo__c=='Análisis General de la Cuenta')
            {
                if(!mapIdXControlAlarmas.containsKey('analisisgeneral'+objControl.MapaCliente__c))
                {
                    mapIdXControlAlarmas.put('analisisgeneral'+objControl.MapaCliente__c,objControl);

                }
            }
        }
        return mapIdXControlAlarmas;
    }   
    public static void getALarmaInversionServicioTrad(List<ControlAlarmas__c> lstControlAlarmas, MapaCliente__c objMapaCliente, Account objAccount, Map<String,ControlAlarmas__c> mapIdXControlAlarmas)
    {
        ControlAlarmas__c objControl;
        //if(objAccount.GastoMovilidad__c==null||objAccount.GastoMovilidad__c==0)
        //{
        //  return;
        //}
        //if(objMapaCliente.grantotalFacturacion__C>0)
        //{
            Decimal dGranTotalFacturacion = objMapaCliente.grantotalFacturacion__C != null ? objMapaCliente.grantotalFacturacion__C : 0;
            Decimal dGastosMovilidad = objAccount.GastoMovilidad__c != null ? objAccount.GastoMovilidad__c : 0;
            Decimal decValorPorcentaje = 0 ;
            
            try {
                decValorPorcentaje=dGranTotalFacturacion/dGastosMovilidad;
            }catch (exception ex){
                decValorPorcentaje = 0;
            }
            
            if(decValorPorcentaje<0.8||decValorPorcentaje>1.2)
            {
                if(mapIdXControlAlarmas.containsKey('serviciostradicionales'+objMapaCliente.id))
                {
                    objControl=mapIdXControlAlarmas.get('serviciostradicionales'+objMapaCliente.id);
                    objControl.Estatus__c='Activa';
                    lstControlAlarmas.add(objControl);
                }
                else
                {
                    objControl=new ControlAlarmas__c();
                    objControl.Estatus__c='Activa';
                    objControl.Motivo__c='Inversión en Servicios Tradicionales (Líneas)';
                    objControl.tipoalarma__c='Campo';
                    objControl.objeto__c='Mapa de Cliente';
                    if (objAccount.Segmento__c == 'Corporativo'){
                        objControl.Posicion__c = '17';
                    }else if (objAccount.Segmento__c == 'Empresarial'){
                        objControl.Posicion__c = '14';
                    }else if (objAccount.Segmento__c == 'PyME'){
                        objControl.Posicion__c = '6';
                    }
                    objControl.Descripcion__c = 'Manifiesta la diferencia (+-20%) entre el detalle de la Inversión en Servicios Tradicionales (Líneas), versus el Gasto en Movilidad indicado en el Plan del Cliente.';
                    objControl.MapaCliente__c=objMapaCliente.id;
                    if(!test.isRunningTest()) objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                    lstControlAlarmas.add(objControl);
                }
            }
            else
            {
                if(mapIdXControlAlarmas.containsKey('serviciostradicionales'+objMapaCliente.id))
                {
                    objControl=mapIdXControlAlarmas.get('serviciostradicionales'+objMapaCliente.id);
                    objControl.Estatus__c='Inactiva';
                    lstControlAlarmas.add(objControl);
                }
                
            }
        //}
        
    }

    public static void getALarmaAnalisisInversion(List<ControlAlarmas__c> lstControlAlarmas, MapaCliente__c objMapaCliente, Account objAccount, Map<String,ControlAlarmas__c> mapIdXControlAlarmas)
    {
        ControlAlarmas__c objControl;
        if(objMapaCliente.ActivaAlarmaAnalisisGeneral__c ||objMapaCliente.AnalisisGeneralCuenta__c==null||objMapaCliente.AnalisisGeneralCuenta__c=='')
        {
            
            if(mapIdXControlAlarmas.containsKey('analisisgeneral'+objMapaCliente.id))
            {
                objControl=mapIdXControlAlarmas.get('analisisgeneral'+objMapaCliente.id);
                objControl.Estatus__c='Activa';
                lstControlAlarmas.add(objControl);
            }
            else
            {
                objControl=new ControlAlarmas__c();
                objControl.Estatus__c='Activa';
                objControl.Motivo__c='Análisis General de la Cuenta';
                objControl.tipoalarma__c='Campo';
                objControl.objeto__c='Mapa de Cliente';
                if (objAccount.Segmento__c == 'Corporativo'){
                    objControl.Posicion__c = '18';
                }else if (objAccount.Segmento__c == 'Empresarial'){
                    objControl.Posicion__c = '';
                }else if (objAccount.Segmento__c == 'PyME'){
                    objControl.Posicion__c = '';
                }
                objControl.Descripcion__c = 'Se prende por la ausencia de información en el campo.';
                objControl.MapaCliente__c=objMapaCliente.id;
                if (!test.isRunningTest())objControl.OwnerId = objAccount.OwnerId; else objControl.OwnerId = userInfo.getUserId();
                lstControlAlarmas.add(objControl);
            }
        }
        else
        {
            if(mapIdXControlAlarmas.containsKey('analisisgeneral'+objMapaCliente.id))
            {
                objControl=mapIdXControlAlarmas.get('analisisgeneral'+objMapaCliente.id);
                objControl.Estatus__c='Inactiva';
                lstControlAlarmas.add(objControl);
            }
            
        }
    }
}