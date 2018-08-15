/*******************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Sergio Ortiz
Proyecto:           Telcel
Descripción:        Clase con la logica para crear el Mapa de Cliente Una vez la
                    cuenta es creada
Cambios (Versiones)
    ---------------------------------------------------------------------------
    No.     Fecha       Autor                       Descripción
    ---     ----------  --------------------------  ---------------------------
    1.0     19-02-2016   Sergio Ortiz               Creación de la Clase
    2.0     02-04-2018   Héctor Figueroa  HFA       Se pone entre comentarios la linea 112    
*******************************************************************************/

public with sharing class MapaDeCliente_cls {
    
    //Metodo para crear el Mapa de Cliente para la lista de cuentas
    public void crearMapaCliente(List<Account> lstCuentas) { 

        //mapa con los tipos de registro para Mapa Cliente
        Map<string,Schema.RecordTypeInfo> mapTipoRegistro = Schema.SObjectType.MapaCliente__c.getRecordTypeInfosByName();
        //System.debug('@@-mapTipoRegistro->'+mapTipoRegistro);
        List<MapaCliente__c> lstMapaCliente = new List<MapaCliente__c>();
        
        for(Account objCuenta: lstCuentas) {
            MapaCliente__c objMapaCliente = new MapaCliente__c();
            objMapaCliente.PlanCliente__c = objCuenta.Id;
            if(mapTipoRegistro.containsKey(objCuenta.Segmento__c))
            {
                objMapaCliente.RecordTypeId = mapTipoRegistro.get(objCuenta.Segmento__c).getRecordTypeId();    
            }
            lstMapaCliente.add(objMapaCliente);
        }
        
        System.debug('@@-lstMapaCliente->' + lstMapaCliente);
        //insertar los registros para Mapa de Cliente
        if(!lstMapaCliente.isEmpty()){
            insert lstMapaCliente;
            for(MapaCliente__c mCIterator:lstMapaCliente)
            {
                crearInvServTICFact(mCIterator.Id);
                crearInvServTradicionales(mCIterator.Id);
            }
        }
    }
    
    //RGR - 03Mar2016 Crea registros en InversionServicioTICFacturacion__c 
    //a partir de CatalogoPlataformaTIC__c 
    public void crearInvServTICFact(Id MapaClienteId){
        list<CatalogoPlataformaTIC__c> lstCatPlatTIC = 
            [SELECT Id, PlataformaTIC__c, ProductosServiciosSolucionesTelcel__c
             FROM CatalogoPlataformaTIC__c
             where Activo__c = true];
        
        List<InversionServicioTICFacturacion__c> lstInvServTICFact = new List<InversionServicioTICFacturacion__c>();
           
        for(CatalogoPlataformaTIC__c catPlatTIC : lstCatPlatTIC){
            
            lstInvServTICFact.add(
                new InversionServicioTICFacturacion__c(
                    MapaCliente__c = MapaClienteId,
                    PlataformasTIC__c = catPlatTIC.PlataformaTIC__c,
                    ProductosServiciosSolucionesTelcel__c = catPlatTIC.ProductosServiciosSolucionesTelcel__c
                )
            );
        }
        insert lstInvServTICFact;
    }

    public void crearInvServTradicionales(Id mapaClienteId){
		System.debug('EN MapaDeCliente_cls.crearInvServTradicionales...');

		
		Set<String> setIdCompPlat = new Set<String>();    	
        //Insertar los padres
        map<Id, CatalogoServiciosTradicionales__c> mapServTradPadres = new map<Id, CatalogoServiciosTradicionales__c>();
        List<CatalogoServiciosTradicionales__c> lstCatServTrad = new List<CatalogoServiciosTradicionales__c>();
        for(CatalogoServiciosTradicionales__c c : [SELECT Id, PlataformaServiciosTradicionales__c, Competidor__c FROM CatalogoServiciosTradicionales__c where Activo__c = true]){
        	lstCatServTrad.add(c);
        	mapServTradPadres.put(c.Id, c);
        }
        
        List<ServiciosTradicionales__c> lstInvServTradicionales = new List<ServiciosTradicionales__c>();  
           
        for(CatalogoServiciosTradicionales__c catSTrad : lstCatServTrad){
            
            lstInvServTradicionales.add(
                new ServiciosTradicionales__c(
                    MapaCliente__c = mapaClienteId,
                    Plataforma__c = catSTrad.PlataformaServiciosTradicionales__c
                    //Competidor__c = catSTrad.Competidor__c
                )
            );
        }
        insert lstInvServTradicionales;
		System.debug('EN MapaDeCliente_cls.crearInvServTradicionales lstInvServTradicionales: ' + lstInvServTradicionales);
		        
        //Insertar los hijos.
        //Ya no se usa este catalogo        
        /*set<Id> setSerTrad = new set<Id>();
        for(CatalogoServiciosTradicionales__c catSTrad : lstCatServTrad){
        	setSerTrad.add(catSTrad.Id); 
        }*/
        
        //Ya no se usa este catalogo
        //list<CatalgoCompetidoresPlataformas__c> lstCatCompPlat = new list<CatalgoCompetidoresPlataformas__c>([Select Id, Name, CatalogoServiciosTradicionales__c From CatalgoCompetidoresPlataformas__c Where CatalogoServiciosTradicionales__c in: setSerTrad]);
        
        //Ahora se usa este otro catalogo
        list<DCTCompetitors__c> lstCatCompPlat = new list<DCTCompetitors__c>([Select Id, Name From DCTCompetitors__c Where IsActive__c = true]);        
		System.debug('EN MapaDeCliente_cls.crearInvServTradicionales lstCatCompPlat: ' + lstCatCompPlat);        
        
        //list<CompetidoresPlataformas__c> lstCompPlat = new list<CompetidoresPlataformas__c>();
        //CompetidoresPlataformas__c objCP = new CompetidoresPlataformas__c();
        //CatalogoServiciosTradicionales__c objCST = new CatalogoServiciosTradicionales__c();
       
		//Recorre la lista de competidores       	
        for(DCTCompetitors__c newEntity : lstCatCompPlat){
			System.debug('EN MapaDeCliente_cls.crearInvServTradicionales newEntity: ' + newEntity);
			for (CatalogoServiciosTradicionales__c objCST: mapServTradPadres.Values()){
				System.debug('EN MapaDeCliente_cls.crearInvServTradicionales objCST: ' + objCST);				
				//Crea la lista del tipo  CompetidoresPlataformas__c
				List<CompetidoresPlataformas__c> lstCompPlat = new List<CompetidoresPlataformas__c>();
				//Recorre la lista de mapST
				for (ServiciosTradicionales__c st : lstInvServTradicionales){
					System.debug('EN MapaDeCliente_cls.crearInvServTradicionales st.Plataforma__c: ' + st.Plataforma__c + ' PlataformaServiciosTradicionales__c: ' + objCST.PlataformaServiciosTradicionales__c);
					if(objCST.PlataformaServiciosTradicionales__c == st.Plataforma__c){
						CompetidoresPlataformas__c objCP = new CompetidoresPlataformas__c();
						objCP.ServiciosTradicionales__c = st.Id;
						objCP.Name = newEntity.Name;
						objCP.DCTCompetitors__c = newEntity.id;
						lstCompPlat.add(objCP); 
					}//Fin si objCST.PlataformaServiciosTradicionales__c == st.Plataforma__c
				}//Fin del for para mapST.Values()

				//Ve si tiene algo para agregar la lista de lstCompPlat
				System.debug('EN DCT_CompetitorsTriggerHandler.afterInsert lstCompPlat: ' + lstCompPlat);
				if (lstCompPlat.size() > 0){
					List<Database.Saveresult> lObjDtsv = Database.insert(lstCompPlat, true);
					
					/*//mete los id a un set para que despues los elimines
					for (Database.Saveresult objDtsv : lObjDtsv){
						if (objDtsv.isSuccess())
							setIdCompPlat.add(objDtsv.getId());
					}
					//Ve si tiene algo el set de setIdCompPlat
					if (!setIdCompPlat.isEmpty()){
						List<Logs__c> lLogsIns = new List<Logs__c>();
						for (String sIdCompPlan : setIdCompPlat){
							lLogsIns.add(new Logs__c(
									NombreProceso__c = 'Creacion de Competidores',
									NombreSubpoceso__c = 'Creacion de Competidores Plataformas',								
									NombreObjeto__c = sIdCompPlan
								)
							);
						}//Fin del for para setIdCompPlat
						//Crea los registros en lLogsIns
						insert lLogsIns;
					}//Fin si !setIdCompPlat.isEmpty()*/
				}//Fin si lstCompPlat.size() > 0
				
			}//Fin del for para mapServTradPadres.Values()
        	
        	/*objCST = mapServTradPadres.get(newEntity.CatalogoServiciosTradicionales__c);
        	for(ServiciosTradicionales__c st : lstInvServTradicionales){
        		if (objCST.PlataformaServiciosTradicionales__c == st.Plataforma__c){
        			objCP = new CompetidoresPlataformas__c();
					objCP.ServiciosTradicionales__c = st.Id;
					//HFA 02042018
					objCP.Name = newEntity.Name;
					lstCompPlat.add(objCP); 
        		}
        	}*/
        	
		}

		/*Ya no sirve esto se cambio la logica
		if (lstCompPlat.size() > 0){
			insert lstCompPlat;
		}*/
                
    }
}