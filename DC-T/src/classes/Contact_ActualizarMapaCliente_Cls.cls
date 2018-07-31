/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Mario Chaves
Proyecto:                Telcel
Descripción:             clase para actulizar los mapas de cliente en el contacto
Requerimiento:           

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     06-03-2016  Mario Chaves               Creación de la clase.
*******************************************************************************/
public class Contact_ActualizarMapaCliente_Cls {
	

	public static void updateMapaCliente(List<Contact> lstContacts)
	{
		Set<Id> setAccountIds=new Set<Id>();
		
		for(Contact objContacto:lstContacts)
		{
			if(!setAccountIds.contains(objContacto.accountId))
			{
				setAccountIds.add(objContacto.accountId);
			}
		}
		Map<String,MapaCliente__c>mapAccountIdXMapaCliente=getMapAccountIdXMapaCliente(setAccountIds);
		for(Contact objContacto:lstContacts)
		{
			if(mapAccountIdXMapaCliente.containsKey(objContacto.accountId))
			{
				objContacto.MapaCliente__c=mapAccountIdXMapaCliente.get(objContacto.accountId).id;
			}

		}
		
	}
	public static Map<String,MapaCliente__c> getMapAccountIdXMapaCliente(Set<Id> setAccountIds)
	{
		Map<String,MapaCliente__c> mapAccountIdXMapaCliente=new Map<String,MapaCliente__c>();
		List<MapaCliente__c> lstmapaClientes=[Select id, PlanCliente__c 
											  from MapaCliente__c 
											  where PlanCliente__c=:setAccountIds];

		for(MapaCliente__c objMapa:lstmapaClientes)
		{
			if(!mapAccountIdXMapaCliente.containsKey(objMapa.PlanCliente__c))
			{
				mapAccountIdXMapaCliente.put(objMapa.PlanCliente__c,objMapa);
			}
		}									  

		return mapAccountIdXMapaCliente;

	}
}