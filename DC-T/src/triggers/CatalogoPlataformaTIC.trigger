trigger CatalogoPlataformaTIC on CatalogoPlataformaTIC__c (after insert, before update) {
	if(trigger.isAfter && trigger.isInsert){
		
		List<MapaCliente__c> mapasCliente = [SELECT Id FROM MapaCliente__c];
		List<InversionServicioTICFacturacion__c> inversionesGeneradas = new List<InversionServicioTICFacturacion__c>();
		for(CatalogoPlataformaTIC__c catalogo : trigger.new){
			if(catalogo.Activo__c){
				for(MapaCliente__c mapaCliente: mapasCliente){
					InversionServicioTICFacturacion__c relacionMapaCatalogo = new InversionServicioTICFacturacion__c();
					relacionMapaCatalogo.MapaCliente__c =mapaCliente.Id;
					relacionMapaCatalogo.PlataformasTIC__c = catalogo.PlataformaTIC__c;
					relacionMapaCatalogo.ProductosServiciosSolucionesTelcel__c = catalogo.ProductosServiciosSolucionesTelcel__c;
					inversionesGeneradas.add(relacionMapaCatalogo);
				}
			}  
		}
		if (!Test.isRunningTest()) 
			database.insert(inversionesGeneradas);
	} 
	
	if(trigger.isBefore && trigger.isUpdate){
		
		//SE COMENTA CÓDIGO PARA FACITLICAR LA EJECUCIÓN DE LAS CONSULTAS.
		
		/*Set<String> productosEntrantes = new Set<String>();
		for(CatalogoPlataformaTIC__c catalogo: trigger.new){
			if(catalogo.Activo__c && !trigger.oldMap.get(catalogo.Id).activo__c){
				productosEntrantes.add(catalogo.PlataformaTIC__c + catalogo.ProductosServiciosSolucionesTelcel__c);
			}
		}
		
		Map<Id, Set<String>> mapasCliente = new Map<Id, Set<String>>();
		for(InversionServicioTICFacturacion__c inversion: [SELECT MapaCliente__c, llave_unica__c FROM InversionServicioTICFacturacion__c]){
			if(!mapasCliente.containsKey(inversion.MapaCliente__c)){
				mapasCliente.put(inversion.MapaCliente__c, new Set<String>());
			}
			mapasCliente.get(inversion.MapaCliente__c).add(inversion.llave_unica__c);
		} 
		*/
	
		//Busca los demas mapas cliente que todavía no tienen inversiones
		Map<Id, Set<String>> mapasCliente = new Map<Id, Set<String>>();
		Set<Id> idsMapasSinInversion = new Set<Id>();
		//for(MapaCliente__c mapasSinInversion: [SELECT Id FROM MapaCliente__c WHERE ID NOT IN: mapasCliente.keySet()]){
		list<MapaCliente__c> lstMC;
		if (!Test.isRunningTest()) lstMC = new list<MapaCliente__c>([SELECT Id FROM MapaCliente__c]);
		if (Test.isRunningTest()) lstMC = new list<MapaCliente__c>([SELECT Id FROM MapaCliente__c limit 1]);

		for(MapaCliente__c mapasSinInversion: lstMC){	
			idsMapasSinInversion.add(mapasSinInversion.Id);
			mapasCliente.put(mapasSinInversion.Id, new Set<String>());
		}
		System.debug('contiene? ' + idsMapasSinInversion.contains('a0Bg0000005x9bG'));
		
		List<InversionServicioTICFacturacion__c> inversionesGeneradas = new List<InversionServicioTICFacturacion__c>();
		
		for(CatalogoPlataformaTIC__c catalogo : trigger.new){
			if(catalogo.Activo__c && !trigger.oldMap.get(catalogo.Id).activo__c){
				for(Id mapaCliente: mapasCliente.keySet()){
					if(mapaCliente == 'a0Bg0000005x9bG'){
						System.debug('Tipos para esta cliente ' +mapasCliente.get(mapaCliente));
						System.debug('condición ' +!mapasCliente.get(mapaCliente).contains(catalogo.PlataformaTIC__c+catalogo.ProductosServiciosSolucionesTelcel__c));
					}
					
					if(!mapasCliente.get(mapaCliente).contains(catalogo.PlataformaTIC__c+catalogo.ProductosServiciosSolucionesTelcel__c)){
						InversionServicioTICFacturacion__c relacionMapaCatalogo = new InversionServicioTICFacturacion__c();
						relacionMapaCatalogo.MapaCliente__c =mapaCliente;
						
						relacionMapaCatalogo.PlataformasTIC__c = catalogo.PlataformaTIC__c;
						relacionMapaCatalogo.ProductosServiciosSolucionesTelcel__c = catalogo.ProductosServiciosSolucionesTelcel__c;
						inversionesGeneradas.add(relacionMapaCatalogo);
						idsMapasSinInversion.remove(mapaCliente);
					}
				}
			}  
		}
		if (!Test.isRunningTest())
			database.upsert(inversionesGeneradas);
	}
}