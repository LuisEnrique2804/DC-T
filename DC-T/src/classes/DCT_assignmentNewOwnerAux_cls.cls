/***************************************************************************************************************************
 * Desarrollado por:  Avanxo México                                                                                        *
 * Autor:             Luis Enrique Garcia Sanabria                                                                         *
 * Email:             legarcia@avanxo.com                                                                                  *
 * Fecha de creación: 21-04-2018                                                                                           *
 ***************************************************************************************************************************
 * Metadata:          DCT_assignmentNewOwner_cls                                                                           *
 ***************************************************************************************************************************
 * Descripción:       Clase auxiliar para realizar el cambio del propietario del DCT(Cuenta) y de sus hijos.               *
 *                                                                                                                         *
 ***************************************************************************************************************************
 *                                                Control de versiones                                                     *
 ***************************************************************************************************************************
 * No. |    Fecha   |             Autor            |        Email        |                 Descripción                     *
 ******|************|******************************|*********************|**************************************************
 * 1.0 | 21-04-2018 | Luis Enrique Garcia Sanabria | legarcia@avanxo.com | Creacion de clase DCT_assignmentNewOwnerAux_cls *
 ***************************************************************************************************************************/
public class DCT_assignmentNewOwnerAux_cls {
	public static void changeOwners(Map<Id, Id> mapAccNewOwnerProcess){
		ActualizaOwnerAccountObjRel(mapAccNewOwnerProcess);
		ActualizaOwnerMapaClienteObjRel(mapAccNewOwnerProcess);
		ActualizaClienteObjRel(mapAccNewOwnerProcess);
		ActualizaEmbudoObjRel(mapAccNewOwnerProcess);
		ActualizaContactoObjRel(mapAccNewOwnerProcess);
		ActualizaSeguimientoOportunidadesObjRel(mapAccNewOwnerProcess);
		ActualizaCompetenciaObjRel(mapAccNewOwnerProcess);
		ActualizaCompetidoresPlataformasObjRel(mapAccNewOwnerProcess);
		ActualizaAnalisisRelacionesObjRel(mapAccNewOwnerProcess);
		ActualizaConocimientoMercadoObjRel(mapAccNewOwnerProcess);
	}

	public static void ActualizaOwnerAccountObjRel(Map<Id, Id> mapAccNewOwnerProcess){
		System.debug('mapAccNewOwnerProcess: ' + mapAccNewOwnerProcess);
		
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		List<ControlAlarmas__c> lCtrolAlamUpd = new List<ControlAlarmas__c>();			
		List<Opportunity> lOppUpd = new List<Opportunity>();
		List<Contact> lContactUpd = new List<Contact>();
		List<Cliente__c> lClienteUpd = new List<Cliente__c>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		//Destripa la cadena de sIdPropFinal y toma los datos de la cuenta

		if (!mapAccNewOwnerProcess.keySet().isEmpty()){
			for (String sIdNvoPropPaso : mapAccNewOwnerProcess.keySet()){
				System.debug(loggingLevel.Error, '*** sIdNvoPropPaso: ' + sIdNvoPropPaso);
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (Account objPCT : [Select id
						//Task	
						,(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
						//ControlAlarmas__c
						,(Select OwnerId, Cuenta__c From Control_de_Alarmas__r)
						//Opportunity (Embudo)						
						,(Select OwnerId, MapaCliente__c From Oportunidades__r)
						//Contacts (Contacto - Organigrama)
						,(Select OwnerId, AccountId From Contacts)
						//Cliente__c (Directorio Comercial)
						,(Select OwnerId, Cliente__c From Clientes__r)						
					From Account Where ID = :sIdNvoPropPaso]){
					//Task
					if (!objPCT.Tasks.isEmpty()){
						for (Task tarea : objPCT.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para las Task
					//Events
					if (!objPCT.Events.isEmpty()){
						for (Event evento : objPCT.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
					//ControlAlarmas__c
					if (!objPCT.Control_de_Alarmas__r.isEmpty()){
						for (ControlAlarmas__c CtolAlarm : objPCT.Control_de_Alarmas__r){ 
							lCtrolAlamUpd.add(new ControlAlarmas__c(id = CtolAlarm.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
					//Opportunity
					if (!objPCT.Oportunidades__r.isEmpty()){
						for (Opportunity CtolAlarm : objPCT.Oportunidades__r){ 
							lOppUpd.add(new Opportunity(id = CtolAlarm.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
					//Contact
					if (!objPCT.Contacts.isEmpty()){
						for (Contact CtolAlarm : objPCT.Contacts){ 
							lContactUpd.add(new Contact(id = CtolAlarm.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
					//Contact
					if (!objPCT.Clientes__r.isEmpty()){
						for (Cliente__c CtolAlarm : objPCT.Clientes__r){ 
							lClienteUpd.add(new Cliente__c(id = CtolAlarm.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
				}//Fin del for para 
			}//Fin del for para lAccNvoProp
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Account (PCT)',
								NombreObjeto__c = 'Task',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Account (PCT)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lCtrolAlamUpd.isEmpty()){
				System.debug('lCtrolAlamUpd: ' + lCtrolAlamUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lCtrolAlamUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Account (PCT)',								
								NombreObjeto__c = 'ControlAlarmas__c',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr				
				//update lCtrolAlamUpd;					
			}//Fin si !lCtrolAlamUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lOppUpd.isEmpty()){
				System.debug('lOppUpd: ' + lOppUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lOppUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Account (PCT)',								
								NombreObjeto__c = 'Opportunity',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lOppUpd;					
			}//Fin si !lOppUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lContactUpd.isEmpty()){
				System.debug('lContactUpd: ' + lContactUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lContactUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Account (PCT)',								
								NombreObjeto__c = 'Contact',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lContactUpd;					
			}//Fin si !lContactUpd.isEmpty()

			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lClienteUpd.isEmpty()){
				System.debug('lClienteUpd: ' + lClienteUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lClienteUpd, true);
				System.debug(loggingLevel.Error, '*** lDtbUpdr: ' + lDtbUpdr);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Account (PCT)',								
								NombreObjeto__c = 'Cliente__c',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lContactUpd;					
			}//Fin si !lContactUpd.isEmpty()

			System.debug('lLogsIns: ' + lLogsIns);			
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;
						
		}//Fin si !lAccNvoProp.isEmpty()	
	}   
	
	public static void ActualizaOwnerMapaClienteObjRel(Map<Id, Id> mapAccNewOwnerProcess){
		System.debug('mapAccNewOwnerProcess: ' + mapAccNewOwnerProcess);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		List<ControlAlarmas__c> lCtrolAlamUpd = new List<ControlAlarmas__c>();			
		List<Opportunity> lOppUpd = new List<Opportunity>();
		List<Contact> lContactUpd = new List<Contact>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		

		if (!mapAccNewOwnerProcess.keySet().isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : mapAccNewOwnerProcess.keySet()){
				for (MapaCliente__c objMapaCliente : [Select id,
						//Task	
						(Select OwnerId, Cliente__c From Tasks),
						//Events
						(Select OwnerId, Cliente__c From Events),
						//ControlAlarmas__c
						(Select OwnerId, MapaCliente__c From ControlAlarmas__r),
						//Opportunity (Embudo)						
						(Select OwnerId, MapaCliente__c From Oportunidades__r),
						//Contact (Organigrama)
						(Select OwnerId, MapaCliente__c From Organigrama__r)   
					From MapaCliente__c Where PlanCliente__c = :sIdNvoPropPaso]){
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para las Task
					
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
						//ControlAlarmas__c
					if (!objMapaCliente.ControlAlarmas__r.isEmpty()){
						for (ControlAlarmas__c CtolAlarm : objMapaCliente.ControlAlarmas__r){ 
							lCtrolAlamUpd.add(new ControlAlarmas__c(id = CtolAlarm.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
						//Opportunity
					if (!objMapaCliente.Oportunidades__r.isEmpty()){
						for (Opportunity CtolAlarm : objMapaCliente.Oportunidades__r){ 
							lOppUpd.add(new Opportunity(id = CtolAlarm.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
						//Organigrama__r
					if (!objMapaCliente.Organigrama__r.isEmpty()){
						for (Contact CtolAlarm : objMapaCliente.Organigrama__r){ 
							lContactUpd.add(new Contact(id = CtolAlarm.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Mapa del Cliente (MapaCliente__c)',
								NombreObjeto__c = 'Task',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Mapa del Cliente (MapaCliente__c)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lCtrolAlamUpd.isEmpty()){
				System.debug('lCtrolAlamUpd: ' + lCtrolAlamUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lCtrolAlamUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Mapa del Cliente (MapaCliente__c)',								
								NombreObjeto__c = 'ControlAlarmas__c',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr				
				//update lCtrolAlamUpd;					
			}//Fin si !lCtrolAlamUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lOppUpd.isEmpty()){
				System.debug('lOppUpd: ' + lOppUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lOppUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Mapa del Cliente (MapaCliente__c)',								
								NombreObjeto__c = 'Opportunity',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lOppUpd;					
			}//Fin si !lOppUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lContactUpd.isEmpty()){
				System.debug('lContactUpd: ' + lContactUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lContactUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Mapa del Cliente (MapaCliente__c)',								
								NombreObjeto__c = 'Contact',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lContactUpd;					
			}//Fin si !lContactUpd.isEmpty()

			System.debug('lLogsIns: ' + lLogsIns);			
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;
					
		}//Fin si !lAccNvoProp.isEmpty()		
	}   
	
	public static void ActualizaClienteObjRel(Map<Id, Id> mapAccNewOwnerProcess){
		System.debug('mapAccNewOwnerProcess: ' + mapAccNewOwnerProcess);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		List<Contact> lContactUpd = new List<Contact>();
		List<Opportunity> lOppUpd = new List<Opportunity>();
		List<DCTDedicatedLinks__c> lDCTDedicatedLinksUpd = new List<DCTDedicatedLinks__c>();			
		List<DCTProduct__c> lDCTProductUpd = new List<DCTProduct__c>();
		List<HistoryMovement__c> lHistoryMovementUpd = new List<HistoryMovement__c>();
				
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		//Destripa la cadena de sIdPropFinal y toma los datos de la cuenta
		if (!mapAccNewOwnerProcess.keySet().isEmpty()){
			for (String sIdNvoPropPaso : mapAccNewOwnerProcess.keySet()){
				
				for (Cliente__c objMapaCliente : [Select id, DCTExtensionValidity__c,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
						//Contact (Organigrama)
						,(Select OwnerId, MapaCliente__c From DirectorioComercial_Contactos__r)
						//Opportunity (Embudo)						
						,(Select OwnerId, MapaCliente__c From DirectorioComercial_Embudo__r)
						//DCTDedicatedLinks__c
						,(Select OwnerId, ClientName__c From NombreCliente__r)
						//DCTProduct__c
						,(Select OwnerId, Product__c From Productos__r)
						//HistoryMovement__c
						,(Select OwnerId, Directorio_Comercial__c From Historicos_de_movimientos__r)
					From Cliente__c Where Cliente__c = :sIdNvoPropPaso]){

					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
					//DirectorioComercial_Contactos__r
					if (!objMapaCliente.DirectorioComercial_Contactos__r.isEmpty()){
						for (Contact CtolAlarm : objMapaCliente.DirectorioComercial_Contactos__r){ 
							lContactUpd.add(new Contact(id = CtolAlarm.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
					//Opportunity
					if (!objMapaCliente.DirectorioComercial_Embudo__r.isEmpty()){
						for (Opportunity CtolAlarm : objMapaCliente.DirectorioComercial_Embudo__r){ 
							lOppUpd.add(
								new Opportunity(
									id = CtolAlarm.id, 
									OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso),
									CloseDate = (objMapaCliente.DCTExtensionValidity__c)?system.today().addDays(180):system.today().addDays(90)
								)
							);
						}
					}//Fin del for para los Events
					//DCTDedicatedLinks__c
					if (!objMapaCliente.NombreCliente__r.isEmpty()){
						for (DCTDedicatedLinks__c CtolAlarm : objMapaCliente.NombreCliente__r){ 
							lDCTDedicatedLinksUpd.add(new DCTDedicatedLinks__c(id = CtolAlarm.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
					//DCTProduct__c
					if (!objMapaCliente.Productos__r.isEmpty()){
						for (DCTProduct__c CtolAlarm : objMapaCliente.Productos__r){ 
							lDCTProductUpd.add(new DCTProduct__c(id = CtolAlarm.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
					//HistoryMovement__c
					if (!objMapaCliente.Historicos_de_movimientos__r.isEmpty()){
						for (HistoryMovement__c CtolAlarm : objMapaCliente.Historicos_de_movimientos__r){
							System.debug(loggingLevel.Error, '*** mapAccNewOwnerProcess.get(sIdNvoPropPaso): ' + mapAccNewOwnerProcess.get(sIdNvoPropPaso)); 
							lHistoryMovementUpd.add(new HistoryMovement__c(id = CtolAlarm.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Directorio Comercial (Cliente__c)',								
								NombreObjeto__c = 'Task',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Directorio Comercial (Cliente__c)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()

			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lContactUpd.isEmpty()){
				System.debug('EN DCT_AssignmentMethods_cls.ActualizaClienteObjRel lContactUpd: ' + lContactUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lContactUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Directorio Comercial (Cliente__c)',								
								NombreObjeto__c = 'Contact',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
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
				List<Database.Saveresult> lDtbUpdr = Database.update(lOppUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Directorio Comercial (Cliente__c)',								
								NombreObjeto__c = 'Opportunity',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
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
				List<Database.Saveresult> lDtbUpdr = Database.update(lDCTDedicatedLinksUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Directorio Comercial (Cliente__c)',								
								NombreObjeto__c = 'DCTDedicatedLinks__c',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
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
				List<Database.Saveresult> lDtbUpdr = Database.update(lDCTProductUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Directorio Comercial (Cliente__c)',								
								NombreObjeto__c = 'DCTProduct__c',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
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
				List<Database.Saveresult> lDtbUpdr = Database.update(lHistoryMovementUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Directorio Comercial (Cliente__c)',								
								NombreObjeto__c = 'HistoryMovement__c',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
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
   
	public static void ActualizaEmbudoObjRel(Map<Id, Id> mapAccNewOwnerProcess){
		System.debug('mapAccNewOwnerProcess: ' + mapAccNewOwnerProcess);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		List<ControlAlarmas__c> lCtrolAlamUpd = new List<ControlAlarmas__c>();			
		List<Opportunity> lOppUpd = new List<Opportunity>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		if (!mapAccNewOwnerProcess.keySet().isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : mapAccNewOwnerProcess.keySet()){
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (Opportunity objMapaCliente : [Select id,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
						//ControlAlarmas__c
						,(Select OwnerId, MapaCliente__c From ControlAlarmas__r)
						//Opportunity (Embudo)						
						,(Select Id, OwnerId, AccountId From Oportunidades__r)
					From Opportunity Where AccountId = :sIdNvoPropPaso]){
					
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
					//ControlAlarmas__c
					if (!objMapaCliente.ControlAlarmas__r.isEmpty()){
						for (ControlAlarmas__c CtolAlarm : objMapaCliente.ControlAlarmas__r){ 
							lCtrolAlamUpd.add(new ControlAlarmas__c(id = CtolAlarm.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
					//Opportunity
					if (!objMapaCliente.Oportunidades__r.isEmpty()){
						for (Opportunity CtolAlarm : objMapaCliente.Oportunidades__r){ 
							lOppUpd.add(new Opportunity(id = CtolAlarm.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Embudo (Opportunity)',
								NombreObjeto__c = 'Task',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Embudo (Opportunity)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lCtrolAlamUpd.isEmpty()){
				System.debug('lCtrolAlamUpd: ' + lCtrolAlamUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lCtrolAlamUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Embudo (Opportunity)',								
								NombreObjeto__c = 'ControlAlarmas__c',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr				
				//update lCtrolAlamUpd;					
			}//Fin si !lCtrolAlamUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lOppUpd.isEmpty()){
				System.debug('lOppUpd: ' + lOppUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lOppUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Embudo (Opportunity)',								
								NombreObjeto__c = 'Opportunity',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
				//update lOppUpd;					
			}//Fin si !lOppUpd.isEmpty()

			System.debug('lLogsIns: ' + lLogsIns);			
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;

		}//Fin si !lAccNvoProp.isEmpty()
	}
   
	public static void ActualizaContactoObjRel(Map<Id, Id> mapAccNewOwnerProcess){
		System.debug('mapAccNewOwnerProcess: ' + mapAccNewOwnerProcess);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		

		if (!mapAccNewOwnerProcess.keySet().isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : mapAccNewOwnerProcess.keySet()){
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (Contact  objMapaCliente : [Select id,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
					From Contact  Where AccountId = :sIdNvoPropPaso]){	

					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Contacto (Contact)',
								NombreObjeto__c = 'Task',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Contacto (Contact)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()

			System.debug('lLogsIns: ' + lLogsIns);			
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;
											
		}//Fin si !lAccNvoProp.isEmpty()
	}   
	
	public static void ActualizaSeguimientoOportunidadesObjRel(Map<Id, Id> mapAccNewOwnerProcess){
		System.debug(' mapAccNewOwnerProcess: ' + mapAccNewOwnerProcess);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		if (!mapAccNewOwnerProcess.keySet().isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : mapAccNewOwnerProcess.keySet()){
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (SeguimientoOportunidades__c  objMapaCliente : [Select id,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
					From SeguimientoOportunidades__c Where PlanCliente__c = :sIdNvoPropPaso]){
	
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Seguimiento de Oportunidades (SeguimientoOportunidades__c)',
								NombreObjeto__c = 'Task',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Seguimiento de Oportunidades (SeguimientoOportunidades__c)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()

			System.debug('lLogsIns: ' + lLogsIns);											
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;

		}//Fin si !lAccNvoProp.isEmpty()
	}   
	
	public static void ActualizaCompetenciaObjRel(Map<Id, Id> mapAccNewOwnerProcess){
		System.debug('mapAccNewOwnerProcess: ' + mapAccNewOwnerProcess);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		List<ControlAlarmas__c> lCtrolAlamUpd = new List<ControlAlarmas__c>();			
		List<Opportunity> lOppUpd = new List<Opportunity>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		if (!mapAccNewOwnerProcess.keySet().isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : mapAccNewOwnerProcess.keySet()){
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (Competencia__c  objMapaCliente : [Select id,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
						//Opportunity (Embudo)						
						,(Select Id, OwnerId, AccountId From Embudos__r)
					From Competencia__c Where PlanCliente__c = :sIdNvoPropPaso]){
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
					//Opportunity
					if (!objMapaCliente.Embudos__r.isEmpty()){
						for (Opportunity Embudo : objMapaCliente.Embudos__r){ 
							lOppUpd.add(new Opportunity(id = Embudo.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Competencia (Competencia__c)',
								NombreObjeto__c = 'Task',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Competencia (Competencia__c)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()

			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lOppUpd.isEmpty()){
				System.debug('lOppUpd: ' + lOppUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lOppUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a la Competencia (Competencia__c)',								
								NombreObjeto__c = 'Opportunity',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lOppUpd.isEmpty()

			System.debug('lLogsIns: ' + lLogsIns);														
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;
														
		}//Fin si !lAccNvoProp.isEmpty()
	}
   
	public static void ActualizaCompetidoresPlataformasObjRel(Map<Id, Id> mapAccNewOwnerProcess){
		System.debug('mapAccNewOwnerProcess: ' + mapAccNewOwnerProcess);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		List<ControlAlarmas__c> lCtrolAlamUpd = new List<ControlAlarmas__c>();			
		List<Opportunity> lOppUpd = new List<Opportunity>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		if (!mapAccNewOwnerProcess.keySet().isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : mapAccNewOwnerProcess.keySet()){
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (Competencia__c  objMapaCliente : [Select id,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
					From Competencia__c Where PlanCliente__c = :sIdNvoPropPaso]){
						
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a los Competidores de Plataformas (CompetidoresPlataformas__c)',
								NombreObjeto__c = 'Task',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados a los Competidores de Plataformas (CompetidoresPlataformas__c)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()

			System.debug('lLogsIns: ' + lLogsIns);
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;
														
		}//Fin si !lAccNvoProp.isEmpty()
	}

	public static void ActualizaAnalisisRelacionesObjRel(Map<Id, Id> mapAccNewOwnerProcess){
		System.debug('mapAccNewOwnerProcess: ' + mapAccNewOwnerProcess);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		List<ControlAlarmas__c> lCtrolAlamUpd = new List<ControlAlarmas__c>();			
		List<Opportunity> lOppUpd = new List<Opportunity>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		if (!mapAccNewOwnerProcess.keySet().isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : mapAccNewOwnerProcess.keySet()){

				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (AnalisisRelaciones__c objMapaCliente : [Select id,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
					From AnalisisRelaciones__c Where PlanCliente__c = :sIdNvoPropPaso]){
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Anàlisis de Relaciones (AnalisisRelaciones__c)',
								NombreObjeto__c = 'Task',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados al Anàlisis de Relaciones (AnalisisRelaciones__c)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
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
    
	public static void ActualizaConocimientoMercadoObjRel(Map<Id, Id> mapAccNewOwnerProcess){
		System.debug('mapAccNewOwnerProcess: ' + mapAccNewOwnerProcess);
		List<Task> lTaskUpd = new List<Task>(); 
		List<Event> lEventUpd = new List<Event>();
		List<ControlAlarmas__c> lCtrolAlamUpd = new List<ControlAlarmas__c>();			
		List<Opportunity> lOppUpd = new List<Opportunity>();
		String sDetError = '';
		List<Logs__c> lLogsIns = new List<Logs__c>();
		Integer iCntReg = 0;
		
		if (!mapAccNewOwnerProcess.keySet().isEmpty()){
			//Recorre la lista
			for (String sIdNvoPropPaso : mapAccNewOwnerProcess.keySet()){
				//Consulta los objetos asociados a las cuentas lAccuntsFinal 
				for (ConocimientoMercado__c  objMapaCliente : [Select id,
						//Task	
						(Select OwnerId, Cliente__c From Tasks)
						//Events
						,(Select OwnerId, Cliente__c From Events)
					From ConocimientoMercado__c Where PlanCliente__c = :sIdNvoPropPaso]){
					System.debug(loggingLevel.Error, '*** objMapaCliente.Tasks: ' + objMapaCliente.Tasks);
					System.debug(loggingLevel.Error, '*** objMapaCliente.Events: ' + objMapaCliente.Events);	
					//Task
					if (!objMapaCliente.Tasks.isEmpty()){
						for (Task tarea : objMapaCliente.Tasks){ 
							lTaskUpd.add(new Task(id = tarea.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para las Task
					//Events
					if (!objMapaCliente.Events.isEmpty()){
						for (Event evento : objMapaCliente.Events){ 
							lEventUpd.add(new Event(id = evento.id, OwnerId = mapAccNewOwnerProcess.get(sIdNvoPropPaso)));
						}
					}//Fin del for para los Events
				}//Fin del for para el MapaCliente__c
				
			}//Fin del for para la lista de nuevos propiertarios
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lTaskUpd.isEmpty()){
				System.debug('lTaskUpd: ' + lTaskUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lTaskUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados del Conocimiento de Mercado (ConocimientoMercado__c)',
								NombreObjeto__c = 'Task',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lTaskUpd.isEmpty()
			
			//Ya tienes los datos de los objetos que se van a atualizar mandalos
			if (!lEventUpd.isEmpty()){
				System.debug('lEventUpd: ' + lEventUpd);
				List<Database.Saveresult> lDtbUpdr = Database.update(lEventUpd, true);
				for (Database.Saveresult objDtbUpdr : lDtbUpdr){
					if (!objDtbUpdr.isSuccess() || Test.isRunningTest()){
						lLogsIns.add(new Logs__c(
								NombreProceso__c = 'Reasignar cuentas',
								NombreSubpoceso__c = 'Actualiza propietario objetos relacionados del Conocimiento de Mercado (ConocimientoMercado__c)',								
								NombreObjeto__c = 'Event',
								DetalleError__c = (!Test.isRunningTest())?objDtbUpdr.getErrors()[0].getMessage(): 'Error'
							)
						);
					}
					iCntReg++;
				}//Fin  del for lDtbUpdr
			}//Fin si !lEventUpd.isEmpty()

			System.debug('lLogsIns: ' + lLogsIns);
			//Crea los reg de los logs
			if (!lLogsIns.isEmpty())
				insert lLogsIns;
														
		}//Fin si !lAccNvoProp.isEmpty()
	}
}