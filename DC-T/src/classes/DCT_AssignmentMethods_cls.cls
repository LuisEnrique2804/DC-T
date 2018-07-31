/*******************************************************************************
Desarrollado por:        Avanxo México
Autor:                   Mario Chaves
Proyecto:                Telcel
Descripción:             clase para actulizar los mapas de cliente en el contacto
Requerimiento:           

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     01-03-2018  Rene Ayala  RAM                 Creación de la clase.
1.0     20-03-2018  Héctor Figueroa HFA             Actualización de la clase.
*******************************************************************************/

public class DCT_AssignmentMethods_cls {

    public static String VaRtCorpPCT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Corporativo').getRecordTypeId();	
    public static String VaRtEmpPCT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel Empresarial').getRecordTypeId();
    public static String VaRtPmePCT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Plan Cliente Telcel PyME').getRecordTypeId();

    public static String VaRtCorpMC = Schema.SObjectType.MapaCliente__c.getRecordTypeInfosByName().get('Corporativo').getRecordTypeId();	
    public static String VaRtEmpMC = Schema.SObjectType.MapaCliente__c.getRecordTypeInfosByName().get('Empresarial').getRecordTypeId();
    public static String VaRtPmeMC = Schema.SObjectType.MapaCliente__c.getRecordTypeInfosByName().get('PyME').getRecordTypeId();

    public static String VaRtCorpCI = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Corporativo Inicio').getRecordTypeId();	
    public static String VaRtEmpEP = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Empresarial Propuesta').getRecordTypeId();
    public static String VaRtPmePC = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('PyME Contacto').getRecordTypeId();

	public static Map<String, String> mapIdAccSegmento  {get;set;}
	public static Map<String, String> mapNomRTOppIdRtOpp {get;set;}
	public static Map<String, String> mapIdRtOppNomRTOpp {get;set;}	
	
	public static void performAssigmentIfApplies(Map<Id,DCTAssignment__c> mapOldAssigs, Map<Id,DCTAssignment__c> mapNewAssigs){
		System.debug('EN DCT_AssignmentMethods_cls.performAssigmentIfApplies...');
								
		Set<Id> setAssignmentsToPerform = new Set<Id>();
		Set<String> setIdAccountFinal = new Set<String>();
		Set<String> setIdUsrFinal = new Set<String>();
		Map<String, Set<String>> mapIdNuePropIdAcc = new Map<String, Set<String>>(); 
		Map<String, String> mapDtcAsinApro = new Map<String, String>();
				
		Map<Id, Account> mapAccountsToUpdateOwner = new Map<Id, Account>();
		Map<String, String> mapIdAccSegmento = new 	Map<String, String>();
		mapNomRTOppIdRtOpp = new Map<String, String>();
		mapIdRtOppNomRTOpp = new Map<String, String>();		
								
		for(String iterator : mapOldAssigs.keySet()){
			if(determinateWhetherAssignmentApplies(mapOldAssigs.get(iterator),mapNewAssigs.get(iterator))){
				setAssignmentsToPerform.add(iterator);
				mapDtcAsinApro.put(iterator, 'Aprobado');
			}
		}
		
		//Consulta todos los tipos de reg de la Opp
		for(RecordType objRecordTypeOpp : [Select r.id, r.SobjectType, r.Name From RecordType r
			where r.SobjectType = 'Opportunity' AND (NOT Name Like '%Perdida') Order by Name]){
			mapNomRTOppIdRtOpp.put(objRecordTypeOpp.Name, objRecordTypeOpp.id);
			mapIdRtOppNomRTOpp.put(objRecordTypeOpp.id, objRecordTypeOpp.Name);
		}

		System.debug('EN DCT_AssignmentMethods_cls.performAssigmentIfApplies setAssignmentsToPerform: ' + setAssignmentsToPerform);		
		//Recorre la lista de setAssignmentsToPerform
		if(!setAssignmentsToPerform.isEmpty()){
			Map<Id, List<DCTClientsProspectstoAssigned__c>> mapIndividualAssigmentsByMainAssignment = getIndividualAssignments(setAssignmentsToPerform);
			if(!mapIndividualAssigmentsByMainAssignment.isEmpty()){
				for(String iterator0 : mapIndividualAssigmentsByMainAssignment.keySet()){
					for(DCTClientsProspectstoAssigned__c iterator1:mapIndividualAssigmentsByMainAssignment.get(iterator0)){
						System.debug('EN DCT_AssignmentMethods_cls.performAssigmentIfApplies iterator1.UserReceiver__c: ' + iterator1.UserReceiver__c + ' AccountName__c: ' + iterator1.AccountName__c + ' Status__c: ' + iterator1.Status__c + ' Segmento__c: ' + iterator1.Segmento__c);
						
						//Ve si existe el iterator1.Status__c == 'Pendiente'						
						if (iterator1.Status__c == 'Pendiente' && mapDtcAsinApro.containsKey(iterator1.AssignmentNumber__c))
							iterator1.Status__c = 'Aprobado';
						System.debug('EN DCT_AssignmentMethods_cls.performAssigmentIfApplies iterator1.Status__c: ' + iterator1.Status__c);
						
						//Mete los datos de la cuenta y su nuevo propietario el mapa de mapIdNuePropIdAcc
						if (iterator1.UserReceiver__c != null && iterator1.AccountName__c != null && iterator1.Status__c == 'Aprobado'){ 
							if (mapIdNuePropIdAcc.containsKey(iterator1.UserReceiver__c))
								mapIdNuePropIdAcc.get(iterator1.UserReceiver__c).add(iterator1.AccountName__c);
							if (!mapIdNuePropIdAcc.containsKey(iterator1.UserReceiver__c))
								mapIdNuePropIdAcc.put(iterator1.UserReceiver__c, new Set<String>{iterator1.AccountName__c});
								
							//un objeto para la cuenta que se esta actualizando
							Account cuentaPaso = new Account(
								Id = iterator1.AccountName__c,
								OwnerId = iterator1.UserReceiver__c,
								DCTDateLastassignment__c = Date.Today()
							);
							
							//Ve si tiene algo el segmento
							if (iterator1.Segmento__c != null){
								String sSeg = iterator1.Segmento__c;
								//Actualiza el tipo de reg de la cuenta
								cuentaPaso.Segmento__c = sSeg;
								/*cuentaPaso.RecordTypeId = sSeg == 'Corporativo' ? VaRtCorpPCT 
									: sSeg == 'Empresarial' ? VaRtEmpPCT 
									: sSeg == 'PyME' ? VaRtPmePCT : VaRtCorpPCT;*/
								System.debug('EN DCT_AssignmentMethods_cls.performAssigmentIfApplies cuentaPaso.Segmento__c: ' + cuentaPaso.Segmento__c);									
							}//Fin si iterator1.Segmento__c != null
							
							//Mete los datos de las cuentas al mapa de mapIdAccSegmento
							if (iterator1.Segmento__c != null)
								mapIdAccSegmento.put(iterator1.AccountName__c, iterator1.Segmento__c);
														
							//Llena el mapa de mapAccountsToUpdateOwner con las cuentas
							mapAccountsToUpdateOwner.put(iterator1.AccountName__c, cuentaPaso);
						}//Fin si iterator1.UserReceiver__c != null && iterator1.AccountName__c != null){
					}
				}
			}//Fin si !mapIndividualAssigmentsByMainAssignment.isEmpty()

			System.debug('EN DCT_AssignmentMethods_cls.performAssigmentIfApplies mapIdAccSegmento: ' + mapIdAccSegmento.KeySet());
			System.debug('EN DCT_AssignmentMethods_cls.performAssigmentIfApplies mapIdAccSegmento: ' + mapIdAccSegmento.Values());			
			
			//Ve si tiene algo el mapa de mapAccountsToUpdateOwner 
			if(!mapAccountsToUpdateOwner.isEmpty()){
				List<Logs__c> lLogsIns = new List<Logs__c>();
				Integer iCntReg = 0;
				System.debug('EN DCT_AssignmentMethods_cls.performAssigmentIfApplies mapAccountsToUpdateOwner.values(): ' + mapAccountsToUpdateOwner.values());				
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');
				List<Database.Saveresult> lDtbUpdr = Database.update(mapAccountsToUpdateOwner.values(), false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario a los reg de la Account (PCT)',
								NombreObjeto__c = 'Account',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr

				System.debug('EN DCT_AssignmentMethods_cls.performAssigmentIfApplies lLogsIns: ' + lLogsIns);			
				//Crea los reg de los logs
				if (!lLogsIns.isEmpty())
					insert lLogsIns;

			}//Fin si !mapAccountsToUpdateOwner.isEmpty()

			String sIdAccIdOwner = '';			
			for (String sIdNuvProp : mapIdNuePropIdAcc.KeySet()){
				sIdAccIdOwner += sIdNuvProp +':';
				//Recorre la lista de de las cuentas
				for (String sIdCta : mapIdNuePropIdAcc.get(sIdNuvProp)){
					sIdAccIdOwner += sIdCta + ',';
				}//Fin del for para  mapIdNuePropIdAcc.get(sIdNuvProp)
				sIdAccIdOwner += ';';				
			}//Fin del for para mapIdNuePropIdAcc.KeySet()
			System.debug('EN DCT_AssignmentMethods_cls.performAssigmentIfApplies sIdAccIdOwner: ' + sIdAccIdOwner);

			String sIdAccNomSeg = '';			
			for (String sIdNuvProp : mapIdAccSegmento.KeySet()){
				sIdAccNomSeg += sIdNuvProp +':';
				sIdAccNomSeg += mapIdAccSegmento.get(sIdNuvProp) + ',';				
			}//Fin del for para mapIdNuePropIdAcc.KeySet()
			System.debug('EN DCT_AssignmentMethods_cls.performAssigmentIfApplies sIdAccNomSeg: ' + sIdAccNomSeg);

			//Ya tienes los datos de las cuentas finales ahora consulta los reg del objeto de Account (PCT)
			//Y sus objetos relacionados
			if (!mapIdNuePropIdAcc.isEmpty())
				ActualizaOwnerAccountObjRel(sIdAccIdOwner, sIdAccNomSeg);				

			//Ya tienes los datos de las cuentas finales ahora consulta los reg del objeto de MapaCliente__c
			//Y sus objetos relacionados
			if (!mapIdNuePropIdAcc.isEmpty())
				ActualizaOwnerMapaClienteObjRel(sIdAccIdOwner, sIdAccNomSeg);				

			//Ya tienes los datos de las cuentas finales ahora consulta los reg del objeto de Opportunity
			//Y sus objetos relacionados
			if (!mapIdNuePropIdAcc.isEmpty())
				ActualizaEmbudoObjRel(sIdAccIdOwner);				

			//Ya tienes los datos de las cuentas finales ahora consulta los reg del objeto de Cliente__c
			//Y sus objetos relacionados
			if (!mapIdNuePropIdAcc.isEmpty())
				ActualizaClienteObjRel(sIdAccIdOwner, sIdAccNomSeg);				

			//Ya tienes los datos de las cuentas finales ahora consulta los reg del objeto de Contact
			//Y sus objetos relacionados
			if (!mapIdNuePropIdAcc.isEmpty())
				ActualizaContactoObjRel(sIdAccIdOwner);				

			//Ya tienes los datos de las cuentas finales ahora consulta los reg del objeto de SeguimientoOportunidades__c
			//Y sus objetos relacionados
			if (!mapIdNuePropIdAcc.isEmpty())
				ActualizaSeguimientoOportunidadesObjRel(sIdAccIdOwner);				

			//Ya tienes los datos de las cuentas finales ahora consulta los reg del objeto de Competencia__c
			//Y sus objetos relacionados
			if (!mapIdNuePropIdAcc.isEmpty())
				ActualizaCompetenciaObjRel(sIdAccIdOwner);				

			//Ya tienes los datos de las cuentas finales ahora consulta los reg del objeto de AnalisisRelaciones__c
			//Y sus objetos relacionados
			if (!mapIdNuePropIdAcc.isEmpty())
				ActualizaAnalisisRelacionesObjRel(sIdAccIdOwner);				

			//Ya tienes los datos de las cuentas finales ahora consulta los reg del objeto de ConocimientoMercado__c
			//Y sus objetos relacionados
			if (!mapIdNuePropIdAcc.isEmpty())
				ActualizaConocimientoMercadoObjRel(sIdAccIdOwner);

		}
	}

	public static Boolean determinateWhetherAssignmentApplies(DCTAssignment__c oldAssignment, DCTAssignment__c newAssignment){
		System.debug('EN determinateWhetherAssignmentApplies oldAssignment.Status__c: ' + oldAssignment.Status__c + ' newAssignment.Status__c: ' + newAssignment.Status__c);
		System.debug('EN determinateWhetherAssignmentApplies oldAssignment.DCTProccesAprobed__c: ' + oldAssignment.DCTProccesAprobed__c + ' newAssignment.DCTProccesAprobed__c: ' + newAssignment.DCTProccesAprobed__c);		
		Boolean blnAppliesForAssignment = false;
		if(oldAssignment.DCTProccesAprobed__c != newAssignment.DCTProccesAprobed__c)
			if(newAssignment.DCTProccesAprobed__c == 'Aprobado')
				blnAppliesForAssignment = true;
		//Regresa blnAppliesForAssignment
		return blnAppliesForAssignment;
	}

	public static Map<Id, List<DCTClientsProspectstoAssigned__c>> getIndividualAssignments(Set<Id> setAssignmentIds){
		Map<Id, List<DCTClientsProspectstoAssigned__c>> mapIndividualAssigmentsByMainAssignment = new Map<Id, List<DCTClientsProspectstoAssigned__c>>();
		
		String strQueryOverAssignmentSttmnt = 'SELECT '+String.join(new List<String>(SObjectType.DCTAssignment__c.Fields.getMap().keySet()),', ')+', (SELECT '+String.join(new List<String>(SObjectType.DCTClientsProspectstoAssigned__c.Fields.getMap().keySet()),', ')+' FROM NumeroAsignacion__r) FROM DCTAssignment__c WHERE Id IN (\''+String.join(new List<Id>(setAssignmentIds),'\',\'')+'\')';
        List<DCTAssignment__c> lstAssignmentProcesses = new List<DCTAssignment__c>();
        try{
        	lstAssignmentProcesses = Database.query(strQueryOverAssignmentSttmnt);
        }catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}        
        for(DCTAssignment__c iterator0:lstAssignmentProcesses){
        	if(iterator0.NumeroAsignacion__r != null){
        		if(!iterator0.NumeroAsignacion__r.isEmpty()){
        			mapIndividualAssigmentsByMainAssignment.put(iterator0.Id,iterator0.NumeroAsignacion__r);
        		}
        	}      	
        }
        return mapIndividualAssigmentsByMainAssignment;
	}


	//El proceso a futuro que actualiza los propietarios de los reg asociados a Account (PCT)
    @future(callout=true)   
	public static void ActualizaOwnerAccountObjRel(String sIdPropFinal, String sIdAccNomSeg){
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel sIdPropFinal: ' + sIdPropFinal);
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel sIdAccNomSeg: ' + sIdAccNomSeg);
				
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		List<ControlAlarmas__c> lCtrolAlamUpd = new List<ControlAlarmas__c>();			
		List<Opportunity> lOppUpd = new List<Opportunity>();
		List<Contact> lContactUpd = new List<Contact>();
		List<Cliente__c> lClienteUpd = new List<Cliente__c>();
		List<MapaCliente__c> lMapCtes = new List<MapaCliente__c>();
		List<SeguimientoOportunidades__c> lSegOpp = new List<SeguimientoOportunidades__c>();

		Map<String, String> mapNomRTOppIdRtOpp = new Map<String, String>(); 
		Map<String, String> mapIdRtOppNomRTOpp = new Map<String, String>(); 	

		//Consulta todos los tipos de reg de la Opp
		for(RecordType objRecordTypeOpp : [Select r.id, r.SobjectType, r.Name From RecordType r
			where r.SobjectType = 'Opportunity' AND (NOT Name Like '%Perdida') Order by Name]){
			mapNomRTOppIdRtOpp.put(objRecordTypeOpp.Name, objRecordTypeOpp.id);
			mapIdRtOppNomRTOpp.put(objRecordTypeOpp.id, objRecordTypeOpp.Name);
		}
		
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		//Destripa la cadena de sIdPropFinal y toma los datos de la cuenta
		List<String> lAccNvoProp = sIdPropFinal.split(';');
		Boolean bSeleccionoSegmento = false;

		//Todo esto para el segmento
		List<String> lAccNomSegm = new List<String>();
		if (sIdAccNomSeg!= null && sIdAccNomSeg != ''){
			lAccNomSegm = sIdAccNomSeg.split(',');
			bSeleccionoSegmento = true;
		}//Fin si sIdAccNomSeg!= null && sIdAccNomSeg != ''
		Map<String, String> mapIdCteNomSeg = new Map<String, String>();
		//Recorre la lista de lAccNomSegm y metelo al mapa de
		for (String sIdCtaNom : lAccNomSegm){
			List<String> lCtaSeg = sIdCtaNom.split(':');
			System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel lCtaSeg: ' + lCtaSeg);			
			mapIdCteNomSeg.put(lCtaSeg.get(0), lCtaSeg.get(1));
		}
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel mapIdCteNomSeg: ' + mapIdCteNomSeg.KeySet());
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel mapIdCteNomSeg: ' + mapIdCteNomSeg.Values());		

		//Ve si tiene algo la lista de lAccNvoProp						
		if (!lAccNvoProp.isEmpty()){
			for (String sIdNvoPropPaso : lAccNvoProp){
				List<String> lAccNvoPropFinal = sIdNvoPropPaso.split(':');
				//Toma el id del propietario
				String sIdNvoProp = lAccNvoPropFinal.get(0);
				List<String> lAccuntsFinal = lAccNvoPropFinal.get(1).split(',');
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel lAccuntsFinal: ' + lAccuntsFinal);				
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (Account objPCT : [Select id
						//Task	
						,(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
						//ControlAlarmas__c
						,(Select OwnerId, Cuenta__c From Control_de_Alarmas__r)
						//Opportunity (Embudo)						
						,(Select OwnerId, MapaCliente__c, RecordTypeId From Oportunidades__r
							Where NOT RecordType.Name Like '%Perdida')
						//Contacts (Contacto - Organigrama)
						,(Select OwnerId, AccountId From Contacts)
						//Cliente__c (Directorio Comercial)
						,(Select OwnerId, Cliente__c From Clientes__r)
						//MapaClientes__c (Mapa del Cliente)
						,(Select RecordTypeId From MapaClientes__r)
						//Seguimientos_de_Oportunidades__c
						,(Select RecordTypeId From Seguimientos_de_Oportunidades__r)
					//Los datos de la cuenta	
					From Account Where ID IN :lAccuntsFinal]){
					//Task
					if (!objPCT.Tasks.isEmpty()){
						for (Task tarea : objPCT.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para las Task
					//Events
					if (!objPCT.Events.isEmpty()){
						for (Event evento : objPCT.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
					//ControlAlarmas__c
					if (!objPCT.Control_de_Alarmas__r.isEmpty()){
						for (ControlAlarmas__c CtolAlarm : objPCT.Control_de_Alarmas__r){ 
							lCtrolAlamUpd.add(new ControlAlarmas__c(id = CtolAlarm.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
					//Opportunity
					if (!objPCT.Oportunidades__r.isEmpty()){
						//mapNomRTOppIdRtOpp.put(objRecordTypeOpp.Name, objRecordTypeOpp.id);
						//mapIdRtOppNomRTOpp.put(objRecordTypeOpp.id, objRecordTypeOpp.Name);
						//Recorre la oportunidades asociadas a la cuenta
						for (Opportunity objOpp : objPCT.Oportunidades__r){
							String sRtFinal = objOpp.RecordTypeId;
							//Una variable para el segmento
							String sSeg = mapIdCteNomSeg.containsKey(objPCT.id) ? mapIdCteNomSeg.get(objPCT.id) : 'Corporativo';
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel sSeg: ' + sSeg);							
							String sIdRtOpp = mapIdRtOppNomRTOpp.get(objOpp.RecordTypeId); 
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel sIdRtOpp: ' + sIdRtOpp);							
							//Ve de que tipo de reg se trata
							if (sIdRtOpp.contains('Corporativo') && !sIdRtOpp.contains(sSeg)){
								sIdRtOpp = sIdRtOpp.replaceAll('Corporativo', sSeg);
								System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel Val1: ' + sIdRtOpp + ' sSeg: ' + sSeg);								
							}
							if (sIdRtOpp.contains('Empresarial') && !sIdRtOpp.contains(sSeg)){
								sIdRtOpp = sIdRtOpp.replaceAll('Empresarial', sSeg);
								System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel Val2: ' + sIdRtOpp + ' sSeg: ' + sSeg);								
							}
							if (sIdRtOpp.contains('PyME') && !sIdRtOpp.contains(sSeg)){
								sIdRtOpp = sIdRtOpp.replaceAll('PyME', sSeg);
								System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel Val3: ' + sIdRtOpp + ' sSeg: ' + sSeg);								
							}
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel sIdRtOpp2: ' + sIdRtOpp);
							//Ya tienes el tipo de reg que se va a utilizar obten el id del mapa mapNomRTOppIdRtOpp
							sRtFinal = mapNomRTOppIdRtOpp.containsKey(sIdRtOpp) ? mapNomRTOppIdRtOpp.get(sIdRtOpp) : sRtFinal;							
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel sSeg2: ' + sSeg + ' sIdRtOpp3: ' + sIdRtOpp + ' sRtFinal2: ' + sRtFinal);
							Opportunity objOppPaso = new Opportunity(id = objOpp.id, OwnerId = sIdNvoProp);							
							if (bSeleccionoSegmento)
								objOppPaso.RecordTypeId = sRtFinal;												
							//Agrega el reg en la lista de 	lOppUpd							 
							lOppUpd.add(objOppPaso);
						}
					}//Fin del for para los Events
					//Contact
					if (!objPCT.Contacts.isEmpty()){
						for (Contact CtolAlarm : objPCT.Contacts){ 
							lContactUpd.add(new Contact(id = CtolAlarm.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
					//Cliente__c
					if (!objPCT.Clientes__r.isEmpty()){
						for (Cliente__c CtolAlarm : objPCT.Clientes__r){ 
							lClienteUpd.add(new Cliente__c(id = CtolAlarm.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
					//MapaCliente__c (Mapa Clientes)
					if (!objPCT.MapaClientes__r.isEmpty()){
						for (MapaCliente__c objMapCtes : objPCT.MapaClientes__r){
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel1 objPCT.id: ' + objPCT.id + ' ' + mapIdCteNomSeg.KeySet());							
							String sSegm = mapIdCteNomSeg.containsKey(objPCT.id) ? mapIdCteNomSeg.get(objPCT.id) : 'Corporativo';
							String sRecTypId = sSegm == 'Corporativo' ? VaRtCorpMC 
									: sSegm == 'Empresarial' ? VaRtEmpMC 
									: sSegm == 'PyME' ? VaRtPmeMC : VaRtCorpMC;
							//Crea el objeto para MapaCliente__c
							lMapCtes.add(new MapaCliente__c(id = objMapCtes.id, RecordTypeId = sRecTypId));
						}
					}//Fin del for para los Events
					//SeguimientoOportunidades__c (Seguimiento Oportunidades)
					if (!objPCT.Seguimientos_de_Oportunidades__r.isEmpty()){
						for (SeguimientoOportunidades__c objSegOpp : objPCT.Seguimientos_de_Oportunidades__r){
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel2 objPCT.id: ' + objPCT.id + ' ' + mapIdCteNomSeg.KeySet());							
							String sSegm = mapIdCteNomSeg.containsKey(objPCT.id) ? mapIdCteNomSeg.get(objPCT.id) : 'Corporativo';
							String sRecTypId = sSegm == 'Corporativo' ? VaRtCorpMC 
									: sSegm == 'Empresarial' ? VaRtEmpMC 
									: sSegm == 'PyME' ? VaRtPmeMC : VaRtCorpMC;
							//Crea el objeto para SeguimientoOportunidades__c
							lSegOpp.add(new SeguimientoOportunidades__c(id = objSegOpp.id, RecordTypeId = sRecTypId));
						}
					}//Fin del for para los Events					
				}//Fin del for para 
			}//Fin del for para lAccNvoProp

			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Account (PCT)',
								NombreObjeto__c = 'Task',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Account (PCT)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lCtrolAlamUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel lCtrolAlamUpd: ' + lCtrolAlamUpd);
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ControlAlarmas_tgr');				
				List<Database.Saveresult> lDtbUpdr = Database.update(lCtrolAlamUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Account (PCT)',								
								NombreObjeto__c = 'ControlAlarmas__c',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr				
				//update lCtrolAlamUpd;					
			}//Fin si !lCtrolAlamUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lOppUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel lOppUpd: ' + lOppUpd);
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');				
				List<Database.Saveresult> lDtbUpdr = Database.update(lOppUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Account (PCT)',								
								NombreObjeto__c = 'Opportunity',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lOppUpd;					
			}//Fin si !lOppUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lContactUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel lContactUpd: ' + lContactUpd);				
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('Contact_tgr');
				List<Database.Saveresult> lDtbUpdr = Database.update(lContactUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Account (PCT)',								
								NombreObjeto__c = 'Contact',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lContactUpd;					
			}//Fin si !lContactUpd.isEmpty()

			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lClienteUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel lClienteUpd: ' + lClienteUpd);
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');
				List<Database.Saveresult> lDtbUpdr = Database.update(lClienteUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Account (PCT)',								
								NombreObjeto__c = 'Cliente__c',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lContactUpd;					
			}//Fin si !lContactUpd.isEmpty()

			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lMapCtes.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel lMapCtes: ' + lMapCtes);
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('MapaCliente_tgr');
				List<Database.Saveresult> lDtbUpdr = Database.update(lMapCtes, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Account (PCT)',								
								NombreObjeto__c = 'MapaCliente__c',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lContactUpd;					
			}//Fin si !lContactUpd.isEmpty()

			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lSegOpp.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel lSegOpp: ' + lSegOpp);
				List<Database.Saveresult> lDtbUpdr = Database.update(lSegOpp, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Account (PCT)',								
								NombreObjeto__c = 'SeguimientoOportunidades__c',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lContactUpd;					
			}//Fin si !lContactUpd.isEmpty()

			System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel lLogsIns: ' + lLogsIns);			
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;
						
		}//Fin si !lAccNvoProp.isEmpty()
		
	}

	//El proceso a futuro que actualiza los propietarios de los reg asociados a MapaCliente__c
    @future(callout=true)   
	public static void ActualizaOwnerMapaClienteObjRel(String sIdPropFinal, String sIdAccNomSeg){
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerMapaClienteObjRel sIdPropFinal: ' + sIdPropFinal);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		List<ControlAlarmas__c> lCtrolAlamUpd = new List<ControlAlarmas__c>();			
		List<Opportunity> lOppUpd = new List<Opportunity>();
		List<Contact> lContactUpd = new List<Contact>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;

		Map<String, String> mapNomRTOppIdRtOpp = new Map<String, String>(); 
		Map<String, String> mapIdRtOppNomRTOpp = new Map<String, String>(); 	

		//Consulta todos los tipos de reg de la Opp
		for(RecordType objRecordTypeOpp : [Select r.id, r.SobjectType, r.Name From RecordType r
			where r.SobjectType = 'Opportunity' AND (NOT Name Like '%Perdida') Order by Name]){
			mapNomRTOppIdRtOpp.put(objRecordTypeOpp.Name, objRecordTypeOpp.id);
			mapIdRtOppNomRTOpp.put(objRecordTypeOpp.id, objRecordTypeOpp.Name);
		}
		
		//Destripa la cadena de sIdPropFinal y toma los datos de la cuenta
		List<String> lAccNvoProp = sIdPropFinal.split(';');
		Boolean bSeleccionoSegmento = false;

		//Todo esto para el segmento
		List<String> lAccNomSegm = new List<String>();
		if (sIdAccNomSeg != null && sIdAccNomSeg != ''){		
			lAccNomSegm = sIdAccNomSeg.split(',');
			bSeleccionoSegmento = true;
		}//Fin si sIdAccNomSeg != null && sIdAccNomSeg != ''
		
		Map<String, String> mapIdCteNomSeg = new Map<String, String>();
		//Recorre la lista de lAccNomSegm y metelo al mapa de
		for (String sIdCtaNom : lAccNomSegm){
			List<String> lCtaSeg = sIdCtaNom.split(':');
			System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel lCtaSeg: ' + lCtaSeg);			
			mapIdCteNomSeg.put(lCtaSeg.get(0), lCtaSeg.get(1));
		}
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel mapIdCteNomSeg: ' + mapIdCteNomSeg.KeySet());
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel mapIdCteNomSeg: ' + mapIdCteNomSeg.Values());		

		//Ve si tiene algo la lista de 	lAccNvoProp
		if (!lAccNvoProp.isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : lAccNvoProp){
				List<String> lAccNvoPropFinal = sIdNvoPropPaso.split(':');
				//Toma el id del propietario
				String sIdNvoProp = lAccNvoPropFinal.get(0);
				List<String> lAccuntsFinal = lAccNvoPropFinal.get(1).split(',');
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (MapaCliente__c objMapaCliente : [Select id, PlanCliente__c,
						//Task	
						(Select OwnerId, Cliente__c From Tasks),
						//Events
						(Select OwnerId, Cliente__c From Events),
						//ControlAlarmas__c
						(Select OwnerId, MapaCliente__c From ControlAlarmas__r),
						//Opportunity (Embudo)						
						(Select OwnerId, MapaCliente__c, RecordTypeId From Oportunidades__r
							Where NOT RecordType.Name Like '%Perdida'),
						//Contact (Organigrama)
						(Select OwnerId, MapaCliente__c From Organigrama__r)   
					From MapaCliente__c Where PlanCliente__c IN :lAccuntsFinal]){
						
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para las Task
					
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
						//ControlAlarmas__c
					if (!objMapaCliente.ControlAlarmas__r.isEmpty()){
						for (ControlAlarmas__c CtolAlarm : objMapaCliente.ControlAlarmas__r){ 
							lCtrolAlamUpd.add(new ControlAlarmas__c(id = CtolAlarm.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
						//Opportunity
					if (!objMapaCliente.Oportunidades__r.isEmpty()){
						for (Opportunity objOpp : objMapaCliente.Oportunidades__r){
							String sRtFinal = objOpp.RecordTypeId;
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerMapaClienteObjRel sRtFinal: ' + sRtFinal);							
							//Una variable para el segmento
							String sSeg = mapIdCteNomSeg.containsKey(objMapaCliente.PlanCliente__c) ? mapIdCteNomSeg.get(objMapaCliente.PlanCliente__c) : 'Corporativo';
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerMapaClienteObjRel sSeg: ' + sSeg);							
							String sIdRtOpp = mapIdRtOppNomRTOpp.get(objOpp.RecordTypeId); 
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerMapaClienteObjRel sIdRtOpp: ' + sIdRtOpp);							
							//Ve de que tipo de reg se trata
							if (sIdRtOpp.contains('Corporativo') && !sIdRtOpp.contains(sSeg)){
								sIdRtOpp = sIdRtOpp.replaceAll('Corporativo', sSeg);
								System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerMapaClienteObjRel Val1: ' + sIdRtOpp + ' sSeg: ' + sSeg);								
							}
							if (sIdRtOpp.contains('Empresarial') && !sIdRtOpp.contains(sSeg)){
								sIdRtOpp = sIdRtOpp.replaceAll('Empresarial', sSeg);
								System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerMapaClienteObjRel Val2: ' + sIdRtOpp + ' sSeg: ' + sSeg);								
							}
							if (sIdRtOpp.contains('PyME') && !sIdRtOpp.contains(sSeg)){
								sIdRtOpp = sIdRtOpp.replaceAll('PyME', sSeg);
								System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerMapaClienteObjRel Val3: ' + sIdRtOpp + ' sSeg: ' + sSeg);								
							}
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerMapaClienteObjRel sIdRtOpp2: ' + sIdRtOpp);
							//Ya tienes el tipo de reg que se va a utilizar obten el id del mapa mapNomRTOppIdRtOpp
							sRtFinal = mapNomRTOppIdRtOpp.containsKey(sIdRtOpp) ? mapNomRTOppIdRtOpp.get(sIdRtOpp) : sRtFinal;							
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel sSeg2: ' + sSeg + ' sIdRtOpp3: ' + sIdRtOpp + ' sRtFinal2: ' + sRtFinal);

							Opportunity objOppPaso = new Opportunity(id = objOpp.id, OwnerId = sIdNvoProp);							
							if (bSeleccionoSegmento)
								objOppPaso.RecordTypeId = sRtFinal;												
							//Agrega el reg en la lista de 	lOppUpd							 
							lOppUpd.add(objOppPaso);
																						
							//lOppUpd.add(new Opportunity(id = CtolAlarm.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
						//Organigrama__r
					if (!objMapaCliente.Organigrama__r.isEmpty()){
						for (Contact CtolAlarm : objMapaCliente.Organigrama__r){ 
							lContactUpd.add(new Contact(id = CtolAlarm.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerMapaClienteObjRel lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Mapa del Cliente (MapaCliente__c)',
								NombreObjeto__c = 'Task',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerMapaClienteObjRel lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Mapa del Cliente (MapaCliente__c)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lCtrolAlamUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerMapaClienteObjRel lCtrolAlamUpd: ' + lCtrolAlamUpd);
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ControlAlarmas_tgr');				
				List<Database.Saveresult> lDtbUpdr = Database.update(lCtrolAlamUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Mapa del Cliente (MapaCliente__c)',								
								NombreObjeto__c = 'ControlAlarmas__c',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr				
				//update lCtrolAlamUpd;					
			}//Fin si !lCtrolAlamUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lOppUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerMapaClienteObjRel lOppUpd: ' + lOppUpd);
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');				
				List<Database.Saveresult> lDtbUpdr = Database.update(lOppUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Mapa del Cliente (MapaCliente__c)',								
								NombreObjeto__c = 'Opportunity',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lOppUpd;					
			}//Fin si !lOppUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lContactUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerMapaClienteObjRel lContactUpd: ' + lContactUpd);
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('Contact_tgr');				
				List<Database.Saveresult> lDtbUpdr = Database.update(lContactUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Mapa del Cliente (MapaCliente__c)',								
								NombreObjeto__c = 'Contact',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lContactUpd;					
			}//Fin si !lContactUpd.isEmpty()

			System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerMapaClienteObjRel lLogsIns: ' + lLogsIns);			
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;
					
		}//Fin si !lAccNvoProp.isEmpty()
			
	}

	//El proceso a futuro que actualiza los propietarios de los reg asociados a MapaCliente__c
    @future(callout=true)   
	public static void ActualizaClienteObjRel(String sIdPropFinal, String sIdAccNomSeg){
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel sIdPropFinal: ' + sIdPropFinal);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		List<Contact> lContactUpd = new List<Contact>();
		List<Opportunity> lOppUpd = new List<Opportunity>();
		List<DCTDedicatedLinks__c> lDCTDedicatedLinksUpd = new List<DCTDedicatedLinks__c>();			
		List<DCTProduct__c> lDCTProductUpd = new List<DCTProduct__c>();
		List<HistoryMovement__c> lHistoryMovementUpd = new List<HistoryMovement__c>();

		Map<String, String> mapNomRTOppIdRtOpp = new Map<String, String>(); 
		Map<String, String> mapIdRtOppNomRTOpp = new Map<String, String>(); 	

		//Consulta todos los tipos de reg de la Opp
		for(RecordType objRecordTypeOpp : [Select r.id, r.SobjectType, r.Name From RecordType r
			where r.SobjectType = 'Opportunity' AND (NOT Name Like '%Perdida') Order by Name]){
			mapNomRTOppIdRtOpp.put(objRecordTypeOpp.Name, objRecordTypeOpp.id);
			mapIdRtOppNomRTOpp.put(objRecordTypeOpp.id, objRecordTypeOpp.Name);
		}
				
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		//Destripa la cadena de sIdPropFinal y toma los datos de la cuenta
		List<String> lAccNvoProp = sIdPropFinal.split(';');
		Boolean bSeleccionoSegmento = false;
		
		//Todo esto para el segmento
		List<String> lAccNomSegm = new List<String>();
		if (sIdAccNomSeg != null && sIdAccNomSeg != ''){		
			lAccNomSegm = sIdAccNomSeg.split(',');
			bSeleccionoSegmento = true;
		}//Fin si sIdAccNomSeg != null && sIdAccNomSeg != ''
		
		Map<String, String> mapIdCteNomSeg = new Map<String, String>();
		//Recorre la lista de lAccNomSegm y metelo al mapa de
		for (String sIdCtaNom : lAccNomSegm){
			List<String> lCtaSeg = sIdCtaNom.split(':');
			System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel lCtaSeg: ' + lCtaSeg);			
			mapIdCteNomSeg.put(lCtaSeg.get(0), lCtaSeg.get(1));
		}
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel mapIdCteNomSeg: ' + mapIdCteNomSeg.KeySet());
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel mapIdCteNomSeg: ' + mapIdCteNomSeg.Values());		

		//Ve si tiene algo la lista de lAccNvoProp
		if (!lAccNvoProp.isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : lAccNvoProp){
				List<String> lAccNvoPropFinal = sIdNvoPropPaso.split(':');
				//Toma el id del propietario
				String sIdNvoProp = lAccNvoPropFinal.get(0);
				List<String> lAccuntsFinal = lAccNvoPropFinal.get(1).split(',');
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (Cliente__c objMapaCliente : [Select id, Cliente__c,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
						//Contact (Organigrama)
						,(Select OwnerId, MapaCliente__c From DirectorioComercial_Contactos__r)
						//Opportunity (Embudo)						
						,(Select OwnerId, MapaCliente__c, RecordTypeId From DirectorioComercial_Embudo__r
							Where NOT RecordType.Name Like '%Perdida')
						//DCTDedicatedLinks__c
						,(Select OwnerId, ClientName__c From NombreCliente__r)
						//DCTProduct__c
						,(Select OwnerId, Product__c From Productos__r)
						//HistoryMovement__c
						,(Select OwnerId, Directorio_Comercial__c From Historicos_de_movimientos__r)						
					From Cliente__c Where Cliente__c IN :lAccuntsFinal]){
						
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
					//DirectorioComercial_Contactos__r
					if (!objMapaCliente.DirectorioComercial_Contactos__r.isEmpty()){
						for (Contact CtolAlarm : objMapaCliente.DirectorioComercial_Contactos__r){ 
							lContactUpd.add(new Contact(id = CtolAlarm.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
					//Opportunity
					if (!objMapaCliente.DirectorioComercial_Embudo__r.isEmpty()){
						for (Opportunity objOpp : objMapaCliente.DirectorioComercial_Embudo__r){
							String sRtFinal = objOpp.RecordTypeId;
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel sRtFinal: ' + sRtFinal);							
							//Una variable para el segmento
							String sSeg = mapIdCteNomSeg.containsKey(objMapaCliente.Cliente__c) ? mapIdCteNomSeg.get(objMapaCliente.Cliente__c) : 'Corporativo';
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel sSeg: ' + sSeg);							
							String sIdRtOpp = mapIdRtOppNomRTOpp.get(objOpp.RecordTypeId); 
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel sIdRtOpp: ' + sIdRtOpp);							
							//Ve de que tipo de reg se trata
							if (sIdRtOpp.contains('Corporativo') && !sIdRtOpp.contains(sSeg)){
								sIdRtOpp = sIdRtOpp.replaceAll('Corporativo', sSeg);
								System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel Val1: ' + sIdRtOpp + ' sSeg: ' + sSeg);								
							}
							if (sIdRtOpp.contains('Empresarial') && !sIdRtOpp.contains(sSeg)){
								sIdRtOpp = sIdRtOpp.replaceAll('Empresarial', sSeg);
								System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel Val2: ' + sIdRtOpp + ' sSeg: ' + sSeg);								
							}
							if (sIdRtOpp.contains('PyME') && !sIdRtOpp.contains(sSeg)){
								sIdRtOpp = sIdRtOpp.replaceAll('PyME', sSeg);
								System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel Val3: ' + sIdRtOpp + ' sSeg: ' + sSeg);								
							}
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel sIdRtOpp2: ' + sIdRtOpp);
							//Ya tienes el tipo de reg que se va a utilizar obten el id del mapa mapNomRTOppIdRtOpp
							sRtFinal = mapNomRTOppIdRtOpp.containsKey(sIdRtOpp) ? mapNomRTOppIdRtOpp.get(sIdRtOpp) : sRtFinal;							
							System.debug('EN DCT_AssignmentMethods_cls.ActualizaOwnerAccountObjRel sSeg2: ' + sSeg + ' sIdRtOpp3: ' + sIdRtOpp + ' sRtFinal2: ' + sRtFinal);
							
							Opportunity objOppPaso = new Opportunity(id = objOpp.id, OwnerId = sIdNvoProp);							
							if (bSeleccionoSegmento)
								objOppPaso.RecordTypeId = sRtFinal;												
							//Agrega el reg en la lista de 	lOppUpd							 
							lOppUpd.add(objOppPaso);
							//lOppUpd.add(new Opportunity(id = CtolAlarm.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
					//DCTDedicatedLinks__c
					if (!objMapaCliente.NombreCliente__r.isEmpty()){
						for (DCTDedicatedLinks__c CtolAlarm : objMapaCliente.NombreCliente__r){ 
							lDCTDedicatedLinksUpd.add(new DCTDedicatedLinks__c(id = CtolAlarm.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
					//DCTProduct__c
					if (!objMapaCliente.Productos__r.isEmpty()){
						for (DCTProduct__c CtolAlarm : objMapaCliente.Productos__r){ 
							lDCTProductUpd.add(new DCTProduct__c(id = CtolAlarm.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
					//HistoryMovement__c
					if (!objMapaCliente.Historicos_de_movimientos__r.isEmpty()){
						for (HistoryMovement__c CtolAlarm : objMapaCliente.Historicos_de_movimientos__r){ 
							lHistoryMovementUpd.add(new HistoryMovement__c(id = CtolAlarm.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Directorio Comercial (Cliente__c)',								
								NombreObjeto__c = 'Task',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Directorio Comercial (Cliente__c)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()

			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lContactUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel lContactUpd: ' + lContactUpd);
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('Contact_tgr');				
				List<Database.Saveresult> lDtbUpdr = Database.update(lContactUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Directorio Comercial (Cliente__c)',								
								NombreObjeto__c = 'Contact',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lContactUpd;					
			}//Fin si !lContactUpd.isEmpty()

			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lOppUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel lOppUpd: ' + lOppUpd);
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');				
				List<Database.Saveresult> lDtbUpdr = Database.update(lOppUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel ERROR: ' + objDtbUpdr.getErrors()[0].getMessage());						
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Directorio Comercial (Cliente__c)',								
								NombreObjeto__c = 'Opportunity',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lOppUpd;					
			}//Fin si !lOppUpd.isEmpty()
						
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lDCTDedicatedLinksUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel lDCTDedicatedLinksUpd: ' + lDCTDedicatedLinksUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lDCTDedicatedLinksUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Directorio Comercial (Cliente__c)',								
								NombreObjeto__c = 'DCTDedicatedLinks__c',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr				
				//update lDCTDedicatedLinksUpd;					
			}//Fin si !lDCTDedicatedLinksUpd.isEmpty()

			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lDCTProductUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel lDCTProductUpd: ' + lDCTProductUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lDCTProductUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Directorio Comercial (Cliente__c)',								
								NombreObjeto__c = 'DCTProduct__c',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr				
				//update lDCTProductUpd;					
			}//Fin si !lDCTProductUpd.isEmpty()

			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lHistoryMovementUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel lHistoryMovementUpd: ' + lHistoryMovementUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lHistoryMovementUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Directorio Comercial (Cliente__c)',								
								NombreObjeto__c = 'HistoryMovement__c',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr				
				//update lHistoryMovementUpd;					
			}//Fin si !lHistoryMovementUpd.isEmpty()
			
			System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel lLogsIns: ' + lLogsIns);			
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;			
			
		}//Fin si !lAccNvoProp.isEmpty()
			
	}
	
	//El proceso a futuro que actualiza los propietarios de los reg asociados a MapaCliente__c
    @future(callout=true)   
	public static void ActualizaEmbudoObjRel(String sIdPropFinal){
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaEmbudoObjRel sIdPropFinal: ' + sIdPropFinal);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		List<ControlAlarmas__c> lCtrolAlamUpd = new List<ControlAlarmas__c>();			
		List<Opportunity> lOppUpd = new List<Opportunity>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		//Destripa la cadena de sIdPropFinal y toma los datos de la cuenta
		List<String> lAccNvoProp = sIdPropFinal.split(';');
		if (!lAccNvoProp.isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : lAccNvoProp){
				List<String> lAccNvoPropFinal = sIdNvoPropPaso.split(':');
				//Toma el id del propietario
				String sIdNvoProp = lAccNvoPropFinal.get(0);
				List<String> lAccuntsFinal = lAccNvoPropFinal.get(1).split(',');
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (Opportunity objMapaCliente : [Select id, OwnerId, AccountId,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
						//ControlAlarmas__c
						,(Select OwnerId, MapaCliente__c From ControlAlarmas__r)
						//Opportunity (Embudo)						
						,(Select Id, OwnerId, AccountId From Oportunidades__r
							Where NOT RecordType.Name Like '%Perdida')
					From Opportunity Where AccountId IN :lAccuntsFinal]){
						
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
					//ControlAlarmas__c
					if (!objMapaCliente.ControlAlarmas__r.isEmpty()){
						for (ControlAlarmas__c CtolAlarm : objMapaCliente.ControlAlarmas__r){ 
							lCtrolAlamUpd.add(new ControlAlarmas__c(id = CtolAlarm.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
					//Opportunity
					if (!objMapaCliente.Oportunidades__r.isEmpty()){
						for (Opportunity CtolAlarm : objMapaCliente.Oportunidades__r){ 
							lOppUpd.add(new Opportunity(id = CtolAlarm.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
										
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaEmbudoObjRel lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Embudo (Opportunity)',
								NombreObjeto__c = 'Task',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaEmbudoObjRel lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Embudo (Opportunity)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lCtrolAlamUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaEmbudoObjRel lCtrolAlamUpd: ' + lCtrolAlamUpd);
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ControlAlarmas_tgr');				
				List<Database.Saveresult> lDtbUpdr = Database.update(lCtrolAlamUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Embudo (Opportunity)',								
								NombreObjeto__c = 'ControlAlarmas__c',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr				
				//update lCtrolAlamUpd;					
			}//Fin si !lCtrolAlamUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lOppUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaEmbudoObjRel lOppUpd: ' + lOppUpd);
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');
				List<Database.Saveresult> lDtbUpdr = Database.update(lOppUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Embudo (Opportunity)',								
								NombreObjeto__c = 'Opportunity',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lOppUpd;					
			}//Fin si !lOppUpd.isEmpty()

			System.debug('EN DCT_AssignmentMethods_cls.ActualizaEmbudoObjRel lLogsIns: ' + lLogsIns);			
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;

		}//Fin si !lAccNvoProp.isEmpty()
			
	}


	//El proceso a futuro que actualiza los propietarios de los reg asociados a MapaCliente__c
    @future(callout=true)   
	public static void ActualizaContactoObjRel(String sIdPropFinal){
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaEmbudoObjRel sIdPropFinal: ' + sIdPropFinal);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		//Destripa la cadena de sIdPropFinal y toma los datos de la cuenta
		List<String> lAccNvoProp = sIdPropFinal.split(';');
		if (!lAccNvoProp.isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : lAccNvoProp){
				List<String> lAccNvoPropFinal = sIdNvoPropPaso.split(':');
				//Toma el id del propietario
				String sIdNvoProp = lAccNvoPropFinal.get(0);
				List<String> lAccuntsFinal = lAccNvoPropFinal.get(1).split(',');
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (Contact  objMapaCliente : [Select id,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
					From Contact  Where AccountId IN :lAccuntsFinal]){
						
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaEmbudoObjRel lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Contacto (Contact)',
								NombreObjeto__c = 'Task',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaEmbudoObjRel lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Contacto (Contact)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()

			System.debug('EN DCT_AssignmentMethods_cls.ActualizaEmbudoObjRel lLogsIns: ' + lLogsIns);			
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;
											
		}//Fin si !lAccNvoProp.isEmpty()
			
	}

	//El proceso a futuro que actualiza los propietarios de los reg asociados a MapaCliente__c
    @future(callout=true)   
	public static void ActualizaSeguimientoOportunidadesObjRel(String sIdPropFinal){
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaSeguimientoOportunidadesObjRel sIdPropFinal: ' + sIdPropFinal);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		//Destripa la cadena de sIdPropFinal y toma los datos de la cuenta
		List<String> lAccNvoProp = sIdPropFinal.split(';');
		
		/*//Todo esto para el segmento
		List<String> lAccNomSegm = sIdAccNomSeg.split(',');
		Map<String, String> mapIdCteNomSeg = new Map<String, String>();
		//Recorre la lista de lAccNomSegm y metelo al mapa de
		for (String sIdCtaNom : lAccNomSegm){
			List<String> lCtaSeg = sIdCtaNom.split(':');
			System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel lCtaSeg: ' + lCtaSeg);			
			mapIdCteNomSeg.put(lCtaSeg.get(0), lCtaSeg.get(1));
		}
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel mapIdCteNomSeg: ' + mapIdCteNomSeg.KeySet());
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel mapIdCteNomSeg: ' + mapIdCteNomSeg.Values());*/		

		//Ve si tiene algo la lista de lAccNvoProp
		if (!lAccNvoProp.isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : lAccNvoProp){
				List<String> lAccNvoPropFinal = sIdNvoPropPaso.split(':');
				//Toma el id del propietario
				String sIdNvoProp = lAccNvoPropFinal.get(0);
				List<String> lAccuntsFinal = lAccNvoPropFinal.get(1).split(',');
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (SeguimientoOportunidades__c  objMapaCliente : [Select id,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
					From SeguimientoOportunidades__c Where PlanCliente__c IN :lAccuntsFinal]){
						
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaSeguimientoOportunidadesObjRel lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Seguimiento de Oportunidades (SeguimientoOportunidades__c)',
								NombreObjeto__c = 'Task',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaSeguimientoOportunidadesObjRel lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Seguimiento de Oportunidades (SeguimientoOportunidades__c)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty() La fecha fin no debe ser menor que la fecha actual

			System.debug('EN DCT_AssignmentMethods_cls.ActualizaSeguimientoOportunidadesObjRel lLogsIns: ' + lLogsIns);											
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;

		}//Fin si !lAccNvoProp.isEmpty()
			
	}

	//El proceso a futuro que actualiza los propietarios de los reg asociados a MapaCliente__c
    @future(callout=true)   
	public static void ActualizaCompetenciaObjRel(String sIdPropFinal){
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaCompetenciaObjRel sIdPropFinal: ' + sIdPropFinal);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();			
		List<Opportunity> lOppUpd = new List<Opportunity>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		//Destripa la cadena de sIdPropFinal y toma los datos de la cuenta
		List<String> lAccNvoProp = sIdPropFinal.split(';');
		if (!lAccNvoProp.isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : lAccNvoProp){
				List<String> lAccNvoPropFinal = sIdNvoPropPaso.split(':');
				//Toma el id del propietario
				String sIdNvoProp = lAccNvoPropFinal.get(0);
				List<String> lAccuntsFinal = lAccNvoPropFinal.get(1).split(',');
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (Competencia__c  objMapaCliente : [Select id,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
						//Opportunity (Embudo)						
						,(Select Id, OwnerId, AccountId From Embudos__r
							Where NOT RecordType.Name Like '%Perdida')
					From Competencia__c Where PlanCliente__c IN :lAccuntsFinal]){
						
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
					//Opportunity
					if (!objMapaCliente.Embudos__r.isEmpty()){
						for (Opportunity Embudo : objMapaCliente.Embudos__r){ 
							lOppUpd.add(new Opportunity(id = Embudo.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaCompetenciaObjRel lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Competencia (Competencia__c)',
								NombreObjeto__c = 'Task',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaCompetenciaObjRel lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Competencia (Competencia__c)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()

			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lOppUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaCompetenciaObjRel lOppUpd: ' + lOppUpd);
				DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');				
				List<Database.Saveresult> lDtbUpdr = Database.update(lOppUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Competencia (Competencia__c)',								
								NombreObjeto__c = 'Opportunity',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lOppUpd.isEmpty()

			System.debug('EN DCT_AssignmentMethods_cls.ActualizaCompetenciaObjRel lLogsIns: ' + lLogsIns);														
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;
														
		}//Fin si !lAccNvoProp.isEmpty()
			
	}


	//El proceso a futuro que actualiza los propietarios de los reg asociados a MapaCliente__c
    @future(callout=true)   
	public static void ActualizaCompetidoresPlataformasObjRel(String sIdPropFinal){
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaCompetidoresPlataformasObjRel sIdPropFinal: ' + sIdPropFinal);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();			
		List<Opportunity> lOppUpd = new List<Opportunity>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		//Destripa la cadena de sIdPropFinal y toma los datos de la cuenta
		List<String> lAccNvoProp = sIdPropFinal.split(';');
		if (!lAccNvoProp.isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : lAccNvoProp){
				List<String> lAccNvoPropFinal = sIdNvoPropPaso.split(':');
				//Toma el id del propietario
				String sIdNvoProp = lAccNvoPropFinal.get(0);
				List<String> lAccuntsFinal = lAccNvoPropFinal.get(1).split(',');
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (Competencia__c  objMapaCliente : [Select id,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
					From Competencia__c Where PlanCliente__c IN :lAccuntsFinal]){
						
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaCompetidoresPlataformasObjRel lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a los Competidores de Plataformas (CompetidoresPlataformas__c)',
								NombreObjeto__c = 'Task',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaCompetidoresPlataformasObjRel lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a los Competidores de Plataformas (CompetidoresPlataformas__c)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()

			System.debug('EN DCT_AssignmentMethods_cls.ActualizaCompetidoresPlataformasObjRel lLogsIns: ' + lLogsIns);
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;
														
		}//Fin si !lAccNvoProp.isEmpty()
			
	}

	//El proceso a futuro que actualiza los propietarios de los reg asociados a AnalisisRelaciones__c
    @future(callout=true)   
	public static void ActualizaAnalisisRelacionesObjRel(String sIdPropFinal){
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaAnalisisRelacionesObjRel sIdPropFinal: ' + sIdPropFinal);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();			
		List<Opportunity> lOppUpd = new List<Opportunity>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		//Destripa la cadena de sIdPropFinal y toma los datos de la cuenta
		List<String> lAccNvoProp = sIdPropFinal.split(';');
		if (!lAccNvoProp.isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : lAccNvoProp){
				List<String> lAccNvoPropFinal = sIdNvoPropPaso.split(':');
				//Toma el id del propietario
				String sIdNvoProp = lAccNvoPropFinal.get(0);
				List<String> lAccuntsFinal = lAccNvoPropFinal.get(1).split(',');
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (AnalisisRelaciones__c objMapaCliente : [Select id,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
					From AnalisisRelaciones__c Where PlanCliente__c IN :lAccuntsFinal]){
						
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaAnalisisRelacionesObjRel lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Anàlisis de Relaciones (AnalisisRelaciones__c)',
								NombreObjeto__c = 'Task',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaAnalisisRelacionesObjRel lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Anàlisis de Relaciones (AnalisisRelaciones__c)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()

			System.debug('EN DCT_AssignmentMethods_cls.ActualizaAnalisisRelacionesObjRel lLogsIns: ' + lLogsIns);
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;
														
		}//Fin si !lAccNvoProp.isEmpty()
			
	}

	//El proceso a futuro que actualiza los propietarios de los reg asociados a ConocimientoMercado__c
    @future(callout=true)   
	public static void ActualizaConocimientoMercadoObjRel(String sIdPropFinal){
		System.debug('EN DCT_AssignmentMethods_cls.ActualizaAnalisisRelacionesObjRel sIdPropFinal: ' + sIdPropFinal);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();			
		List<Opportunity> lOppUpd = new List<Opportunity>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		//Destripa la cadena de sIdPropFinal y toma los datos de la cuenta
		List<String> lAccNvoProp = sIdPropFinal.split(';');
		if (!lAccNvoProp.isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : lAccNvoProp){
				List<String> lAccNvoPropFinal = sIdNvoPropPaso.split(':');
				//Toma el id del propietario
				String sIdNvoProp = lAccNvoPropFinal.get(0);
				List<String> lAccuntsFinal = lAccNvoPropFinal.get(1).split(',');
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (ConocimientoMercado__c  objMapaCliente : [Select id,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
					From ConocimientoMercado__c Where PlanCliente__c IN :lAccuntsFinal]){
						
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = sIdNvoProp));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaAnalisisRelacionesObjRel lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados del Conocimiento de Mercado (ConocimientoMercado__c)',
								NombreObjeto__c = 'Task',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaAnalisisRelacionesObjRel lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, false);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados del Conocimiento de Mercado (ConocimientoMercado__c)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = objDtbUpdr.getErrors()[0].getMessage() 
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()

			System.debug('EN DCT_AssignmentMethods_cls.ActualizaAnalisisRelacionesObjRel lLogsIns: ' + lLogsIns);
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;
														
		}//Fin si !lAccNvoProp.isEmpty()
			
	}

    @future(callout=true)
	public static void actCtasAproRech(String idAsignasdo, String sEstatus){
		System.debug('En actCtasAproRech idAsignasdo: ' + idAsignasdo + ' sEstatus: ' + sEstatus);
		
		List<DCTClientsProspectstoAssigned__c> lCtaAsigUpd = new List<DCTClientsProspectstoAssigned__c>();
		//Consulta los reg de las cuentas asociadas a idAsignasdo
		for (DCTClientsProspectstoAssigned__c objCtaAsig : [Select id, Status__c 
			From DCTClientsProspectstoAssigned__c Where AssignmentNumber__c = :idAsignasdo]){
			lCtaAsigUpd.add(new DCTClientsProspectstoAssigned__c(id = objCtaAsig.id, Status__c = sEstatus));
		}
		
		if (!lCtaAsigUpd.isEmpty()){
			System.debug('En actCtasAproRech idAsignasdo: ' + idAsignasdo + ' sEstatus: ' + sEstatus);			
			update lCtaAsigUpd;
		}//Fin si !lCtaAsigUpd.isEmpty()
		
	}

}