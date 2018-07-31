/*******************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Sergio Ortiz
Proyecto:           Telcel
Descripción:        Clase con la logica para crear la relacion al Mapa de Cliente
					en la Oportunidad
Cambios (Versiones)
    ---------------------------------------------------------------------------
    No.     Fecha       Autor                       Descripción
    ---     ----------  --------------------------  ---------------------------
    1.0     19-02-2016   Sergio Ortiz                Creación de la Clase
*******************************************************************************/

public with sharing class ActualizarOportunidad_cls {
	
	//Metodo con la logica para actualizar el mapa de Cliente en la Oportunidad
	public void actualizarMapaDeCuenta(List<Opportunity> lstOpp) {

		//Crear un Set para los Ids de las Cuentas
		Set<String> idsCuenta = new Set<String>();
		for(Opportunity objOpp: lstOpp) 
			idsCuenta.add(objOpp.AccountId);
		System.debug('@@-idsCuenta->'+idsCuenta);

		//Lista de Mapa de Cliente
		List<MapaCliente__c> lstMapaCuenta = new List<MapaCliente__c>([SELECT Id,Name,PlanCliente__c 
																	   FROM MapaCliente__c 
																	   WHERE PlanCliente__c IN: idsCuenta]);

		//Mapa con el Mapa de Cliente para las cuentas de las Oportunidades
		Map<String,MapaCliente__c> mapMapaCuenta = new Map<String,MapaCliente__c>();
		if (!lstMapaCuenta.isEmpty()) {
			for(MapaCliente__c objMapaCuenta: lstMapaCuenta)
				mapMapaCuenta.put(objMapaCuenta.PlanCliente__c, objMapaCuenta);
		}		
		System.debug('@@-mapMapaCuenta->'+mapMapaCuenta);

		//Actualizar el Mapa de Cliente en la Oportunidad
		for(Opportunity objOportunidad: lstOpp) {
			if (objOportunidad.MapaCliente__c == null && mapMapaCuenta.containsKey(objOportunidad.AccountId) && 
			mapMapaCuenta.get(objOportunidad.AccountId).Id != null) {
			 	objOportunidad.MapaCliente__c = mapMapaCuenta.get(objOportunidad.AccountId).Id;
				System.debug('@@-objOportunidad.MapaCliente__c->'+objOportunidad.MapaCliente__c);  
			}			
		}			
		
	}
}