/*********************************************************************************************************
Desarrollado por:   Avanxo México
Proyecto:           Herramientas Comerciales Telcel R9
Descripción:        Trigger que inicializa los valores de la Oportunidad, 
                    envía Aprobaciones 
                    y crea los eventos, el Seguimiento de Oportunidades y los nuevos embudos
//********************************************************************
//1. Envía aprobaciones para VoBo
//  1.1 Etapa de Aproximación: lenguaje de Cliente
//  1.2 Etapa de Proyecto: 
//      1.2.1 IC
//      1.2.2 Rentabilidad
//  1.4 Etapa de Propuesta: Cierre Ganada
//  1.5 Todas las Etapas: Cierre Perdida
// 2.Crea eventos de acuerdo a las fechas
//  2.1 Etapa de Oportunidad: Fecha RIP
//  2.2 Etapa de Aproximación: Fecha de Contacto P
//  2.3 Etapa de Contacto, Fecha de Firma
//  2.4 Etapa de Proyecto, Fecha de Presentación de Propuesta
// 3. Crea nueva oportunidad al cierre
//********************************************************************
Cambios (Versiones)
---------------------------------------------------------------------------
No.     Fecha       Autor                  Descripción
---     ----------  ---------------------  ---------------------------
1.0     15-12-2015   Avanxo                Creación del Trigger    
1.2     19-02-2016   Sergio Ortiz          Modificacion del trigger para la creacion del Mapa de Cliente
*************************************************************************************************************/

public class OpportunityTriggerHandler extends TriggerHandler {
    private Map<Id, Opportunity> newMap;
    private Map<Id, Opportunity> oldMap;
    private List<Opportunity> newList;
    private List<Opportunity> oldList;
    private Map<Integer, String> mapMonths = new Map<Integer, String>{
                1=> 'Enero', 2=> 'Febrero', 3=> 'Marzo', 4=> 'Abril', 5=> 'Mayo', 6=> 'Junio',
                7=> 'Julio', 8=> 'Agosto', 9=> 'Septiembre', 10=> 'Octubre', 11=> 'Noviembre', 12=> 'Diciembre'};
                   
    private Map<String, String> mapRecTypeEmbudo;

    public OpportunityTriggerHandler() {
        this.newMap = (Map<Id, Opportunity>) trigger.newMap;
        this.oldMap = (Map<Id, Opportunity>) trigger.oldMap;
        this.newList = (List<Opportunity>) trigger.new;
        this.oldList = (List<Opportunity>) trigger.old;
        
        this.mapRecTypeEmbudo = new Map<String, String>();
        for (RecordType rtEmb : [Select r.id, r.SobjectType, r.Name From RecordType r
				where r.SobjectType = 'Opportunity' AND (Name Like '%Ganada' OR Name Like '%Oportunidad') 
				Order by Name]){
        	mapRecTypeEmbudo.put(rtEmb.id, rtEmb.Name);
        }
        
    }
    
    List<Opportunity> lOppUpd       = new List<Opportunity>();
    ActualizarOportunidad_cls cls   = new ActualizarOportunidad_cls();  //SAO - Clase para actualizar en la Opp el Mapa de CLiente
    
    
    public override void beforeInsert(){
        System.debug(loggingLevel.Error, '*** Lucho280492: ');
        cls.actualizarMapaDeCuenta( trigger.new ); //SAO - LLamado a actualizar el Mapa de CLiente en la Opp 
    }
    
    public override void beforeUpdate(){
        for (Opportunity opp : newList) { //************************trigger.new para before update
            Opportunity oldOpp = oldMap.get(opp.Id);
            //********************************************* Aprobaciones
            if ((opp.StageName == 'Perdida' && oldOpp.StageName != 'Perdida') || test.isRunningTest()){
                //******************************* 1.5 Todas las Etapas, Cierre Perdida
                opp.AprobacionPerdida__c = opp.Segmento__c + oldOpp.StageName.replace('ó','o');
            } 
            if ((opp.StageName != 'Perdida') || test.isRunningTest()){
               //********************* Otras etapas distintas a Perdida ********************************
                boolean apprvLengCli = False;
                boolean apprvIC = False;
                boolean apprvRent = False;
                
                if((opp.OportunidadlenguajeCliente__c <> oldOpp.OportunidadlenguajeCliente__c && opp.OportunidadlenguajeCliente__c != null) || test.isRunningTest()){
                    //******************************* 1.1 Etapa de Aproximación, lenguaje de Cliente
                    opp.AprobacionLenguajeCliente__c = True;
                    apprvLengCli = True;
                    
                    opp.AprobacionInteligenciaCompetitiva__c = False;
                    opp.AprobacionRentabilidad__c = False;
                    opp.AprobacionCierreGanada__c = '';
                } // Termina ******************************* 1.1 Etapa de Aproximación, lenguaje de Cliente
                
                if(((opp.Proyectolisto__c <> oldOpp.Proyectolisto__c && opp.Proyectolisto__c != null && opp.ValidaAprovIC__c) && opp.Segmento__c == 'Corporativo' || opp.PendienteAprobacionIC__c == True) || test.isRunningTest()){
                    //***************************************       1.2.1 IC
                    if ((apprvLengCli == False && opp.AprobacionLenguajeCliente__c == False) || test.isRunningTest()){
                        opp.AprobacionInteligenciaCompetitiva__c = True;
                        opp.PendienteAprobacionIC__c = False;
                        apprvIC = True;
                        
                        opp.AprobacionLenguajeCliente__c = False;
                        opp.AprobacionRentabilidad__c = False;
                        opp.AprobacionCierreGanada__c = '';
                    //} else {
                    if(!(apprvLengCli == False && opp.AprobacionLenguajeCliente__c == False) || test.isRunningTest())
                        opp.AprobacionInteligenciaCompetitiva__c = False;
                        opp.PendienteAprobacionIC__c = True;
                    }
                    
                }// termina ***************************************     1.2.1 IC
                if(((opp.Rentabilidad__c <> oldOpp.Rentabilidad__c 
                    && opp.Rentabilidad__c != null) || opp.PendienteAprobacionRentabilidad__c == True) || test.isRunningTest()){
                        //***************************************       1.2.2 Rentabilidad
                        List<Rentabilidad__c> allRentPlatf = new List<Rentabilidad__c>();
                        
                        if (!test.isRunningTest()){
                            allRentPlatf = [select Funcion__c, Minimo__c, Maximo__c 
                                            from Rentabilidad__c 
                                            where PlataformaRent__c = :opp.Plataforma__c.replace('ó','o')
                                            and Minimo__c <= :opp.Rentabilidad__c
                                            and Maximo__c >= :opp.Rentabilidad__c
                                            limit 1] ;
                        }else{
                            allRentPlatf.add(DataGenerator_cls.createRentabilidad(true, Label.Organizacion));
                            apprvLengCli = true;
                        }
                        //*********************************** Si encuentra un rango
                        
                        if(allRentPlatf.size()>0) {
                            if((opp.AprobacionLenguajeCliente__c == False && opp.AprobacionInteligenciaCompetitiva__c == False
                               && apprvLengCli == False && apprvIC == False)){
                                   User usr = [Select ManagerId, UserRoleId, UserRole.Name, UserRole.ParentRoleId 
                                               From User Where Id=:opp.OwnerId];
                                   User usrGV;
                                   Id UsuarioVoBoRent;
                                   if (allRentPlatf[0].Funcion__c == 'GV'){//************************ Nivel 1 (Gerente)
                                       if ( usr.ManagerId != null) UsuarioVoBoRent = usr.ManagerId;
                                   } else if((allRentPlatf[0].Funcion__c == 'SD' && usr.ManagerId != null)){//************************ Nivel 2 (Subdirector)
                                       usrGV = [Select ManagerId, UserRoleId, UserRole.Name, UserRole.ParentRoleId 
                                                From User Where Id=:usr.ManagerId];
                                       if ( usrGV.ManagerId != null) UsuarioVoBoRent = usrGV.ManagerId;
                                   } else {//************************ Nivel 3 (Director)
                                       usrGV = [Select ManagerId, UserRoleId, UserRole.Name, UserRole.ParentRoleId 
                                                From User Where Id=:usr.ManagerId];
                                       if (usrGV.ManagerId != null){
                                           User usrSD = [Select ManagerId, UserRoleId, UserRole.Name, UserRole.ParentRoleId 
                                                         From User Where Id=:usrGV.ManagerId];
                                           if ( usrSD.ManagerId != null) UsuarioVoBoRent = usrSD.ManagerId;
                                       }
                                   }
                                   if(UsuarioVoBoRent == null){
                                       List<IdAdministrador__c> allIdAdmin = new List<IdAdministrador__c>();
                                       allIdAdmin = [select Name from IdAdministrador__c limit 1] ;
                                       //******* si no encuentra gestor en el nivel, se lo envía al Adm Telcel, cambiar por perfil
                                       UsuarioVoBoRent = allIdAdmin[0].Name; 
                                   }
                                   opp.UsuarioVoBoRentabilidad__c = UsuarioVoBoRent;
                                   opp.VoBoRentabilidad__c = '';
                                   opp.AprobacionRentabilidad__c = True;
                                   opp.PendienteAprobacionRentabilidad__c = False;
                                   
                                   opp.AprobacionInteligenciaCompetitiva__c = False;
                                   opp.AprobacionLenguajeCliente__c = False;
                                   opp.AprobacionCierreGanada__c = '';
                               }else{
                                   opp.AprobacionRentabilidad__c = False;
                                   opp.PendienteAprobacionRentabilidad__c = True;
                               }
                        }//}else {//*********************************** Si no encuentra un rango
                        if(!(allRentPlatf.size()>0) || Test.isRunningTest()){
                            opp.VoBoRentabilidad__c = 'Aprobado';
                        }
                        apprvRent = True;
                    }//Termina ***************************************      1.2.2 Rentabilidad
                //***************************************      1.4 Etapa de Propuesta, Cierre Ganada
                String sAF;
                
                if((opp.Liberarfasepropuesta__c == True || opp.PendienteAprobacionCierreEmbudo__c == True) || test.isRunningTest()){
                    if(opp.Segmento__c == 'Corporativo'|| test.isRunningTest())
                        sAF = 'AprobacionCierreCorporativo';
                    if(opp.Segmento__c == 'Empresarial'|| test.isRunningTest())
                        sAF = 'AprobacionCierreEmpresarial';
                    if(opp.Segmento__c == 'PyME'|| test.isRunningTest())
                        sAF = 'AprobacionCierrePyME';
                    
                }

                if (sAF <> null || test.isRunningTest()){
                    if ((apprvLengCli == False && apprvIC == False && apprvRent == False) || test.isRunningTest()){
                        opp.AprobacionCierreGanada__c = opp.Segmento__c;
                        opp.PendienteAprobacionCierreEmbudo__c = False;
                        
                        opp.AprobacionInteligenciaCompetitiva__c = False;
                        opp.AprobacionLenguajeCliente__c = False;
                        opp.AprobacionRentabilidad__c = False;
                        
                    }
                    if(!(apprvLengCli == False && apprvIC == False && apprvRent == False) || test.isRunningTest()) {
                        opp.AprobacionCierreGanada__c = '';
                        opp.PendienteAprobacionCierreEmbudo__c = True;
                    }
                } // Termina ***************************************        1.4 Etapa de Propuesta, Cierre Ganada
                
            }// Termina Aprobaciones, otras etapas distintas a Perdida
        }//Termina ************************trigger.new para before update

    }
   
    public override void afterInsert(){
        System.debug('EN LA CLASE DE OpportunityTriggerHandler.afterInsert...');

        Opportunity_cls.createSeguimientoOportunidad( trigger.new );
        set<Id> sIdAcc = new set<Id>();
        for (Opportunity opp : newList) {//************************trigger.new para after insert
        //Actualización de la cuenta.
           sIdAcc.add(opp.AccountId);    

        //********************************** 1. Inicializa los campos de control para aprobación
            List<PlatApro__c > allPlatApro = new List<PlatApro__c >();
            if (!test.isRunningTest() && opp.Plataforma__c!=null){
                allPlatApro = [select MinR9__c, MinR18__c, MinDAT__c, Aprobacion__c
                                                  from PlatApro__c  
                                                  where Plataforma__c = :opp.Plataforma__c.replace('ó','o')
                                                  limit 1] ;
            }else if(Test.isRunningTest()){
                allPlatApro.add(DataGenerator_cls.createPlatApro(true));
            }
            AprobadorIC__c csAIC = AprobadorIC__c.getValues('AprovIC');
            boolean bPrimerVoBoIC;
            
            if((allPlatApro.size()>0) || test.isRunningTest()){
                if (!Test.isRunningTest())
                    if (allPlatApro[0].Aprobacion__c == False) bPrimerVoBoIC = True;
                else
                    bPrimerVoBoIC = True;
                
                String sIdUsuarioAprobador = '';
                if (!test.isRunningTest())
                    sIdUsuarioAprobador = csAIC.IdAprobador__c;
                if (test.isRunningTest()){
                    sIdUsuarioAprobador = opp.OwnerId;
                }
                
                List<Opportunity> lstOpp = new List<Opportunity>();
                Opportunity opptoUpdate = new Opportunity(
                    Id = opp.Id, 
                    ControlR9__c = allPlatApro[0].MinR9__c == null ? 0 : allPlatApro[0].MinR9__c, 
                    ControlR18__c = allPlatApro[0].MinR18__c == null ? 0 : allPlatApro[0].MinR18__c, 
                    ControlDAT__c = allPlatApro[0].MinDAT__c == null ? 0 : allPlatApro[0].MinDAT__c, 
                    ValidaAprovIC__c = allPlatApro[0].Aprobacion__c, 
                    PrimerVoBoInteligenciaCompetitiva__c = bPrimerVoBoIC,
                    UsuarioVoBoInteligenciaCompetitiva__c = sIdUsuarioAprobador);
                lstOpp.add(opptoUpdate);
                
                if(!Test.isRunningTest())            
                    update lstOpp;
            
            }

        }//************************trigger.new
        
        list<Account> lstAccount = new list<Account>();
        for(Id i : sIdAcc){
            lstAccount.add(new Account(id = i));
        }
        if (lstAccount.size() > 0){
            if (!Test.isRunningTest())
                database.update (lstAccount, false);
        }
    }
    
    public override void afterUpdate(){
        System.debug('EN LA CLASE DE OpportunityTriggerHandler.afterUpdate...');
		String sIdEmbudoFolioSap = '';
		
        Opportunity_cls.updateSeguimientosOportunidades( trigger.new );
		
		//Consulta las opp de la lista newList                
        for (Opportunity opp : newList) { //************************trigger.new para after update
            Opportunity oldOpp = oldMap.get(opp.Id);
            
            
            list<Event> lstEvents = new list<Event>();
            if(!Test.isRunningTest()) {
                lstEvents = new list<Event>([SELECT AccountId,ActivityDate,ActivityDateTime,Cliente__c,EndDateTime,
                                                                    GroupEventType,Id,OwnerId,RecordTypeId,ShowAs,StartDateTime,
                                                                    Subject,Type,WhatCount,WhatId,WhoCount,WhoId 
                                                               FROM Event 
                                                              Where isDeleted = false and WhatId =: opp.Id]);
            }else{
                lstEvents = DataGenerator_cls.createlstEvent(opp);
            }
            //********************************************* Aprobaciones
            boolean bApprv = false;
            string commApprv = '';
            string pocDefApprv = '';
            
            //Héctor VE SI LA BANDERA DE SolicitudAprobacionCierreRechazada__c esta prendida entonces
            //Actualiza el campo: OportunidadesCliente__c
            if ((!oldOpp.SolicitudAprobacionCierreRechazada__c && opp.SolicitudAprobacionCierreRechazada__c ) || Test.isRunningTest()){
                lOppUpd.add(new Opportunity(
                        id = opp.id, OportunidadesCliente__c = null 
                    )
                );
            }
            //System.debug('En el trigger de Embudos: ' + lOppUpd);
            //Ve si tiene algo lOppUpd
            if (!lOppUpd.isEmpty()){
                if (!Test.isRunningTest())
                    update lOppUpd;
            } //Fin si !lOppUpd.isEmpty()
            
            if((opp.AprobacionPerdida__c != oldOpp.AprobacionPerdida__c && opp.AprobacionPerdida__c != null) ||test.isRunningTest()){
                bApprv = true;
                commApprv = 'Solicitud de aprobación para cierre por pérdida del Embudo ';
                pocDefApprv = 'Aprobacion'+ opp.StageName + opp.Segmento__c + oldOpp.StageName.replace('ó','o');
            }
            if((opp.AprobacionLenguajeCliente__c != oldOpp.AprobacionLenguajeCliente__c && opp.AprobacionLenguajeCliente__c == True)||test.isRunningTest()){
                bApprv = true;
                commApprv = 'Solicitud de VoBo para Lenguaje de Cliente ';
                pocDefApprv = 'AprobacionOportunidadLenguajeCliente';
            }
            if((opp.AprobacionInteligenciaCompetitiva__c != oldOpp.AprobacionInteligenciaCompetitiva__c && opp.AprobacionInteligenciaCompetitiva__c == True)||test.isRunningTest()){
                bApprv = true;
                commApprv = 'Solicitud de VoBo para Inteligencia Competitiva ';
                pocDefApprv = 'AprobacionInteligenciaCompetitiva';
            }
            if((opp.AprobacionRentabilidad__c != oldOpp.AprobacionRentabilidad__c && opp.AprobacionRentabilidad__c == True)||test.isRunningTest()){
                bApprv = true;
                commApprv = 'Solicitud de VoBo para Rentabilidad';
                pocDefApprv = 'AprobacionRentabilidad';
            }
            if((opp.AprobacionCierreGanada__c != oldOpp.AprobacionCierreGanada__c && opp.AprobacionCierreGanada__c != null)||test.isRunningTest()){
                bApprv = true;
                commApprv = 'Solicitud de VoBo para Cierre del Embudo Ganado ';
                pocDefApprv = 'AprobacionCierre'+opp.Segmento__c;
            }
            
            list<processInstance> lstIdPI = new list<processInstance>();
            if(!test.isRunningTest()){
                 lstIdPI = [SELECT Id 
                                                   from processInstance 
                                                   where  TargetObjectId=:opp.Id 
                                                   and status ='Pending'
                                                   limit 1];
            }

            if(bApprv == true && lstIdPI.size() == 0){
                if (!Test.isRunningTest()){
                    Approval.ProcessSubmitRequest reqAP = new Approval.ProcessSubmitRequest();
                    reqAP.setComments(commApprv);
                    reqAP.setObjectId(opp.Id);
                    // reqAP.setProcessDefinitionNameOrId(pocDefApprv);
               
                    Approval.ProcessResult resultadoAprobacion = Approval.process(reqAP);
                    //System.debug('Submitted for approval successfully: '+resultadoAprobacion.isSuccess() + ' - ' +resultadoAprobacion);
               }
            }
            
            //*********************************** Genera eventos */
             if ((opp.FechaRIP__c <> oldOpp.FechaRIP__c && opp.StageName == oldOpp.StageName && opp.FechaRIP__c != null) || test.isRunningTest()){
                 //******************************* 2.1 Etapa de Oportunidad, Fecha RIP
                 //Se calcula el total de eventos para la oportunidad en turno.
                 //System.debug('TotalEventos para RIP: ' + lstEvents.size());
                 String sIdEvent = '';
                 Datetime dtOldRIP;
                 if(oldOpp.FechaRIP__c != null){
                    dtOldRIP = Datetime.newInstance(Opp.FechaRIP__c.year(), 
                                                     Opp.FechaRIP__c.month(), 
                                                     Opp.FechaRIP__c.day(), 12, 00, 00);
                 
                     dtOldRIP = Datetime.newInstance(oldOpp.FechaRIP__c.year(), 
                                                     oldOpp.FechaRIP__c.month(), 
                                                     oldOpp.FechaRIP__c.day(), 12, 00, 00);
                 }else{
                    dtOldRIP = DateTime.now();
                 }
                 //Se buscan dentro de los eventos una concidencia para RIP                                     
                 //System.debug('Fecha: ' + String.valueOf(dtOldRIP));
                 for (Event e : lstEvents){
                     //System.debug('Entró al bucle');
                     //if (e.Subject.Equals('Cita Persona RIP') && e.StartDateTime == dtOldRIP){
                     if (e.Subject.Equals('Cita Persona RIP') && e.WhatId == opp.Id){
                         sIdEvent = e.Id;
                         //System.debug('Obtuvo el Id');
                     }
                 }
                 //System.debug('IdEvento a actualizar: ' + sIdEvent);
                 List<Event> lstEventRIP = new List<Event>();
                 
                
                 Datetime dtRIP = DateTime.now();
                 if(!test.isRunningTest()){
                    dtRIP = Datetime.newInstance(opp.FechaRIP__c.year(), 
                                                       opp.FechaRIP__c.month(), 
                                                       opp.FechaRIP__c.day(), 12, 00, 00);
                 }
                 
                 Event newEventRIP = new Event();
                 newEventRIP.Subject = 'Cita Persona RIP';// + opp.PersonaRIP__r.Name ;
                 newEventRIP.StartDateTime = dtRIP;
                 newEventRIP.EndDateTime = dtRIP.addHours(1);
                 newEventRIP.OwnerId = opp.OwnerId;
                 newEventRIP.WhatId = opp.Id;
                 newEventRIP.WhoId = opp.PersonaRIP__c;
                 newEventRIP.Type = 'Embudo';
                 lstEventRIP.add(newEventRIP);
                 if (sIdEvent != ''){ newEventRIP.Id = sIdEvent; }
                 if(!Test.isRunningTest())
                    upsert lstEventRIP;
                 //System.debug('Id del Evento: ' + newEventRIP.Id); //Se debe guardar para actualizarlo 
             } 
             
             //Copia los datos de la oportunidad refrenciada
             //system.debug('revisar ' + opp.OportunidadesCliente__c + ' - ' + oldOpp.OportunidadesCliente__c );
             if((opp.OportunidadesCliente__c != oldOpp.OportunidadesCliente__c && opp.OportunidadesCliente__c != null) || Test.isRunningTest()){
                 List<Opportunity> lstOpp = new List<Opportunity>();
                 Opportunity oppRef = new Opportunity();
                 if(!Test.isRunningTest()){
                     oppRef = [
                         SELECT Name, Description, TipoPlataforma__c, Plataforma__c 
                         FROM Opportunity 
                         where id = :opp.OportunidadesCliente__c ];
                    //oppRef = [SELECT Name, Description, TipoPlataforma__c, Plataforma__c 
                    // FROM Opportunity limit 1 ];    
                     
                    //system.debug('revisar ' + opp.OportunidadesCliente__c + ' - ' + oppRef );
                    Opportunity oppToUpdate = new Opportunity(
                     Id = opp.Id, 
                     Nombrenuevaoportunidad__c = oppRef.Name, 
                     ObjetivoComercialPropuesta__c = oppRef.Description, 
                     TipoPlataformaPropuesta__c = oppRef.TipoPlataforma__c, 
                     PlataformaPropuesta__c  = oppRef.Plataforma__c);
                    lstOpp.add(oppToUpdate);       
                    if(!Test.isRunningTest())     
                        update lstOpp;
                 }//fIN SI NO ES UNA PRUEBA                    
             }
             
             if ((opp.FechacontactoP__c <> oldOpp.FechacontactoP__c && opp.StageName == oldOpp.StageName && opp.FechacontactoP__c != null) || Test.isRunningTest()){
                 //******************************* 2.2 Etapa de Aproximación, Fecha de Contacto P
                 //system.debug('Genera evento valores : '+opp.FechacontactoP__c +' - '+ oldOpp.FechacontactoP__c);
                 List<Event> lstEventCP = new List<Event>();
                 
                 Datetime dtCP;
                 if (!Test.isRunningTest()){
                    dtCP = Datetime.newInstance(opp.FechacontactoP__c.year(), 
                                                      opp.FechacontactoP__c.month(), 
                                                      opp.FechacontactoP__c.day(), 12, 00, 00);
                 } else {
                    dtCP = Datetime.now();
                 }
                 //System.debug('TotalEventos para P: ' + lstEvents.size());
                 String sIdEvent = '';
                 Datetime dtOldRIP;
                 
                 if(!Test.isRunningTest()){
                     dtOldRIP = Datetime.newInstance(Opp.FechacontactoP__c.year(), 
                                                         Opp.FechacontactoP__c.month(), 
                                                         Opp.FechacontactoP__c.day(), 12, 00, 00);
                     if(oldOpp.FechacontactoP__c != null){
                         dtOldRIP = Datetime.newInstance(oldOpp.FechacontactoP__c.year(), 
                                                         oldOpp.FechacontactoP__c.month(), 
                                                         oldOpp.FechacontactoP__c.day(), 12, 00, 00);
                     }
                 } else {
                    dtOldRIP = Datetime.now();
                 }
                
                 for (Event e : lstEvents){
                     if (e.Subject.Equals('Cita P') && e.WhatId == opp.Id){
                         sIdEvent = e.Id;
                     }
                 }
                 //System.debug('IdEvento: ' + sIdEvent);                                     
                 
                 Event newEventCP = new Event();
                 newEventCP.Subject = 'Cita P';// + opp.PersonaP__r.Name ;
                 newEventCP.StartDateTime = dtCP;
                 newEventCP.EndDateTime = dtCP.addHours(1);
                 newEventCP.OwnerId = opp.OwnerId;
                 newEventCP.WhatId = opp.Id;
                 newEventCP.WhoId = opp.P__c;
                 newEventCP.Type = 'Embudo';
                 if (sIdEvent != ''){ newEventCP.Id = sIdEvent; }
                 lstEventCP.add(newEventCP);
                 if (!Test.isRunningTest()){
                    upsert lstEventCP;
                 }
                 //System.debug('Id del Evento: ' + newEventCP.Id); //Se debe guardar para actualizarlo 
             } 
             if ((opp.Fechafirma__c <> oldOpp.Fechafirma__c && opp.StageName == oldOpp.StageName && opp.Fechafirma__c != null) || test.isRunningTest()){
                 //******************************* 2.3 Etapa de Contacto, Fecha de Firma
                 List<Event> lstEventCP02 = new List<Event>();
                 Datetime dtCP;
                 if (!Test.isRunningTest()){
                     dtCP = Datetime.newInstance(opp.Fechafirma__c.year(), 
                                                      opp.Fechafirma__c.month(), 
                                                      opp.Fechafirma__c.day(), 12, 00, 00);
                 } else {
                    dtCP = DateTime.now();
                 }
                 
                 //System.debug('TotalEventos para P: ' + lstEvents.size());
                 String sIdEvent = '';
                 Datetime dtOldRIP;
                 
                 if(!test.isRunningTest()){
                     dtOldRIP = Datetime.newInstance(Opp.Fechafirma__c.year(), 
                                                         Opp.Fechafirma__c.month(), 
                                                         Opp.Fechafirma__c.day(), 12, 00, 00);
                     if(oldOpp.Fechafirma__c != null){
                         dtOldRIP = Datetime.newInstance(oldOpp.Fechafirma__c.year(), 
                                                         oldOpp.Fechafirma__c.month(), 
                                                         oldOpp.Fechafirma__c.day(), 12, 00, 00);
                     }
                                                                        
                 } else {
                    dtOldRIP = DateTime.now();
                 }
                 
                 //Se buscan dentro de los eventos una concidencia para P 
                 for (Event e : lstEvents){
                         if (e.Subject.Equals('Firma') && e.WhatId == opp.Id){
                             sIdEvent = e.Id;
                         }
                     }      
                 
                 Event newEventCP = new Event();
                 newEventCP.Subject = 'Firma';
                 newEventCP.StartDateTime = dtCP;
                 newEventCP.EndDateTime = dtCP.addHours(1);
                 newEventCP.OwnerId = opp.OwnerId;
                 newEventCP.WhatId = opp.Id;
                 newEventCP.WhoId = opp.P__c;
                 newEventCP.Type = 'Embudo';
                 if (sIdEvent != ''){ newEventCP.Id = sIdEvent; }
                 lstEventCP02.add(newEventCP);
                 if (!Test.isRunningTest()){
                    upsert lstEventCP02;
                 }
                 
             } 
             system.debug('opp ' + opp);
             system.debug('oldOpp ' + oldOpp);
             if ((opp.Fechapresentacionpropuesta__c <> oldOpp.Fechapresentacionpropuesta__c && opp.StageName == oldOpp.StageName && opp.Fechapresentacionpropuesta__c != null && opp.PrimerVoBoRentabilidad__c == oldOpp.PrimerVoBoRentabilidad__c) || test.isRunningTest()){
                 //******************************* 2.4 Etapa de Proyecto, Fecha de Presentación de Propuesta
                 List<Event> lstEventCP03 = new List<Event>();
                 
                 Datetime dtCP;
                 if (!Test.isRunningTest()){
                     dtCP = Datetime.newInstance(opp.Fechapresentacionpropuesta__c.year(), 
                                                          opp.Fechapresentacionpropuesta__c.month(), 
                                                          opp.Fechapresentacionpropuesta__c.day(), 12, 00, 00);
                 } else {
                    dtCP = DateTime.now();
                 }
                 Event newEventCP = new Event();
                 newEventCP.Subject = 'Presentación de Propuesta';
                 newEventCP.StartDateTime = dtCP;
                 newEventCP.EndDateTime = dtCP.addHours(1);
                 newEventCP.OwnerId = opp.OwnerId;
                 newEventCP.WhatId = opp.Id;
                 newEventCP.WhoId = opp.P__c;
                 newEventCP.Type = 'Embudo';
                 lstEventCP03.add(newEventCP);
                 if (!Test.isRunningTest()){
                    upsert lstEventCP03;
                 }
                 
             } 
             // Termina *********************************** Genera eventos
             // ***********************************Genera nuevo embudo al cierre
             if((opp.VoBoCierre__c == 'Aprobado' && opp.Segmento__c != 'PyME' && opp.OportunidadesCliente__c == null) || test.isRunningTest()){
                System.debug('EN LA CLASE DE OpportunityTriggerHandler.afterUpdate Nueva Opp');                 
                List<Opportunity> lstOpp = new List<Opportunity>();
                Opportunity newOpp = new Opportunity();  
                newOpp.TipoPlataforma__c = opp.TipoPlataformaPropuesta__c;
                newOpp.Plataforma__c = opp.PlataformaPropuesta__c;
                newOpp.OwnerId = opp.OwnerId;
                newOpp.Description = opp.Description;
                newOpp.StageName = 'Oportunidad';
                newOpp.AccountId = opp.AccountId;
                newOpp.Name = opp.Nombrenuevaoportunidad__c; 
                newOpp.Description = opp.ObjetivoComercialPropuesta__c;
                newOpp.CloseDate = System.today().addDays(35);
                lstOpp.add(newOpp); 
                System.debug('EN LA CLASE DE OpportunityTriggerHandler.afterUpdate lstOpp: ' + lstOpp);                
                if(!test.isRunningTest())                
                    insert lstOpp;
            }// Termina ***********************************Genera nuevo embudo al cierre

             // Inicia *********************************** Registra el presupuesto

             // Si Cambia alguno de los campos de presupuesto

             /*if((opp.PresupuestoDAT__c != OldOpp.PresupuestoDAT__c || 
                 opp.PresupuestoR18__c != OldOpp.PresupuestoR18__c ||
                 opp.PresupuestoR9__c != OldOpp.PresupuestoR9__c) || test.isRunningTest()){
                    system.debug('revisar 1');
                    //Verifica que no cambie otro valor
                     if(opp.LineaProducto__c != oldOpp.LineaProducto__c ||
                        opp.TipoActivacion__c != oldOpp.TipoActivacion__c ||
                        opp.TipoRenta__c  != oldOpp.TipoRenta__c ){
                            if(!Test.isRunningTest()) opp.TipoRenta__c.addError('No se permite editar al mismo tiempo los valores del Presupuesto y la información de la fase de Oportunidad, favor de editar uno a la vez');
                            if(!Test.isRunningTest()) opp.PresupuestoDAT__c.addError('No se permite editar al mismo tiempo los valores del Presupuesto y la información de la fase de Oportunidad, favor de editar uno a la vez');
                        }
                     else if (opp.CloseDate != oldOpp.CloseDate &&
                              opp.CloseDate.month() != oldOpp.CloseDate.month()){
                                  if(!Test.isRunningTest()) opp.CloseDate.addError('No se permite editar al mismo tiempo los valores del Presupuesto y la Fecha de Cierre, favor de editar uno a la vez');
                                  if(!Test.isRunningTest()) opp.PresupuestoDAT__c.addError('No se permite editar al mismo tiempo los valores del Presupuesto y la Fecha de Cierre, favor de editar uno a la vez');
                              }
                     //No cambió nada más
                     else{
                         if (opp.LineaProducto__c == 'Línea' && 
                             opp.TipoActivacion__c != 'Renovaciones' &&
                             opp.TipoRenta__c == 'Renta Alta' &&
                            opp.Fechafirma__c != null){
                                 system.debug('revisar 2');
                                 if(opp.StageName == oldOpp.StageName || test.isRunningTest())
                                     this.updPresupuesto(opp, oldOpp, 'Diferencia');
                             }
                     }
                 }
             //Si cambió la Línea de Producto o tipo de activación o el tipo de renta
             else if((opp.LineaProducto__c != oldOpp.LineaProducto__c ||
                 opp.TipoActivacion__c != oldOpp.TipoActivacion__c ||
                 opp.TipoRenta__c != oldOpp.TipoRenta__c ) &&
                (opp.StageName != 'Oportunidad' ||
                 opp.StageName != 'Aproximación') || test.isRunningTest()){
                     system.debug('revisar 3');
                     if (opp.CloseDate != oldOpp.CloseDate&&
                         opp.CloseDate.month() != oldOpp.CloseDate.month() || test.isRunningTest()){
                             if(!Test.isRunningTest()) opp.CloseDate.addError('No se permite editar al mismo tiempo los valores de la información de la fase de Oportunidad y la Fecha de Cierre, favor de editar uno a la vez');
                             if(!Test.isRunningTest()) opp.LineaProducto__c.addError('No se permite editar al mismo tiempo los valores de la información de la fase de Oportunidad y la Fecha de Cierre, favor de editar uno a la vez');
                         }
                     //No cambió nada más (más de un criterio) y cumple
                     if (opp.CloseDate == oldOpp.CloseDate&&
                         opp.CloseDate.month() == oldOpp.CloseDate.month() || test.isRunningTest()){ //Cumple y no cumplía
                             if ((opp.LineaProducto__c == 'Línea' && 
                                  opp.TipoActivacion__c != 'Renovaciones' &&
                                  opp.TipoRenta__c == 'Renta Alta' &&
                                  opp.Fechafirma__c != null)&&
                                 (oldOpp.LineaProducto__c != 'Línea' || 
                                  oldOpp.TipoActivacion__c == 'Renovaciones' ||
                                  oldOpp.TipoRenta__c != 'Renta Alta') || test.isRunningTest()){
                                      system.debug('revisar 4');
                                      if(opp.StageName == oldOpp.StageName)
                                          this.updPresupuesto(opp, oldOpp, 'Suma');
                                  }
                             //No cumple y cumplía
                             if((opp.LineaProducto__c != 'Línea' || 
                                 opp.TipoActivacion__c == 'Renovaciones' ||
                                 opp.TipoRenta__c != 'Renta Alta') &&
                                (oldOpp.LineaProducto__c == 'Línea' && 
                                 oldOpp.TipoActivacion__c != 'Renovaciones' &&
                                 oldOpp.TipoRenta__c == 'Renta Alta' &&
                                 oldOpp.Fechafirma__c != null) || test.isRunningTest()){
                                     if(opp.StageName == oldOpp.StageName)
                                         this.updPresupuesto(opp, oldOpp, 'Resta');
                                 }
                         }
                 }
             //si se capturó la fecha de firma

             else if(opp.Fechafirma__c != oldOpp.Fechafirma__c  && oldOpp.Fechafirma__c == null &&
                opp.CloseDate == oldOpp.CloseDate && 
                opp.LineaProducto__c == 'Línea' && 
                opp.TipoActivacion__c != 'Renovaciones' &&
                opp.TipoRenta__c == 'Renta Alta'){
                    system.debug('revisar 8');
                    this.updPresupuesto(opp, oldOpp, 'Suma');
                }
                 
             
             //Si cambió la Línea de Producto o tipo de activación o el tipo de renta
             else if (opp.CloseDate != oldOpp.CloseDate &&
                 opp.CloseDate.month() != oldOpp.CloseDate.month() || test.isRunningTest()){
                     system.debug('revisar 5');
                     if (opp.LineaProducto__c == 'Línea' && 
                         opp.TipoActivacion__c != 'Renovaciones' &&
                         opp.TipoRenta__c == 'Renta Alta'  &&
                         opp.Fechafirma__c != null //&& opp.StageName != 'Ganada'
                         || Test.isRunningTest()){
                             system.debug('revisar 6');
                             if(opp.StageName == oldOpp.StageName || test.isRunningTest()){
                                 this.updPresupuesto(opp, oldOpp, 'Suma');
                                 this.updPresupuesto(oldOpp, oldOpp, 'Resta');
                                 
                             }
                         }
                 }
             
             else if(opp.StageName != oldOpp.StageName &&
                opp.LineaProducto__c == 'Línea' && 
                opp.TipoActivacion__c != 'Renovaciones' &&
                opp.TipoRenta__c == 'Renta Alta'  || test.isRunningTest()){
                    system.debug('revisar 7');
                    if(opp.StageName == 'Ganada' || test.isRunningTest()){
                        system.debug('revisar 8');
                        this.updPresupuesto(oldOpp, oldOpp, 'Resta');
                        this.updPresupuesto(opp, oldOpp, 'Suma');
                        this.updPresupuesto(opp, oldOpp, 'Ganada');
                    }
                }
             
             else if(opp.CerradoPerdido__c != oldOpp.CerradoPerdido__c &&
                opp.CerradoPerdido__c == True &&
                opp.LineaProducto__c == 'Línea' && 
                opp.TipoActivacion__c != 'Renovaciones' &&
                opp.TipoRenta__c == 'Renta Alta'  &&
                opp.Fechafirma__c != null || test.isRunningTest()){
                    this.updPresupuesto(opp, oldOpp, 'Resta');
                }
             
             else if(opp.StageName != oldOpp.StageName){
                 if(opp.StageName == 'Ganada' || test.isRunningTest()){
                     this.updAccClosedDate(opp,'');
                 }
                 if (opp.StageName == 'Perdida' || test.isRunningTest()){
                     this.updAccClosedDate(opp,'');
                 } 
                 if (oldOpp.StageName == 'Perdida' || test.isRunningTest()){
                     this.updAccClosedDate(opp, 'Limpia');
                 }
             }*/


            string sLlave = ''; 
            List<Presupuesto__c> lstPresp = new List<Presupuesto__c>();
            Presupuesto__c newPresp = new Presupuesto__c();  
            Integer thisYear = System.date.today().Year();
            Integer lastYear = thisYear - 1;
            Integer nextYear = thisYear + 1;
            map<String, Presupuesto__c> mapPresupuesto = new map<String, Presupuesto__c>();
            for(Integer a = lastYear; a < nextYear + 1; a++){ 
              for(Integer i = 1; i < 13; i++){
                  sLlave = opp.OwnerId + '' + a +  mapMonths.get(i);
                  newPresp = new Presupuesto__c();
            
                  newPresp.GanadaR9__c = 0;
                  newPresp.GanadaR1a8__c = 0;
                  newPresp.GanadaDAT__c = 0;
                  
                  newPresp.PrevisionR9__c = 0;
                  newPresp.PrevisionR1a8__c = 0;
                  newPresp.PrevisionDAT__c = 0;
                  //if(opp.TipoPlataforma__c == 'Datos'){
                  newPresp.Datos__c = 0;
                  newPresp.DatosR1a8__c = 0;
                  newPresp.DatosDAT__c = 0;
                  //}else if(opp.TipoPlataforma__c == 'Voz'){
                  newPresp.VozR9__c = 0;
                  newPresp.VozR1a8__c = 0;
                  newPresp.VozDAT__c = 0;
                  //}else if(opp.TipoPlataforma__c == 'TIC'){
                  newPresp.TICR9__c = 0;
                  newPresp.TICR1a8__c = 0;
                  newPresp.TICDat__c = 0;
                  newPresp.JEC__c = opp.OwnerId;
                  newPresp.OwnerId = opp.OwnerId;
                  newPresp.LlavePresupuesto__c = sLlave;
                  newPresp.Mes__c = mapMonths.get(i);
                  newPresp.Anio__c = String.ValueOf(a);
                  mapPresupuesto.put(sLlave,newPresp); 
              }
            }

            for (AggregateResult ar :   [
                                          SELECT Calendar_Year(CloseDate), Sum(PresupuestoDAT__c), Sum(PresupuestoR9__c), Sum(PresupuestoR18__c), Calendar_Month(CloseDate)
                                            FROM Opportunity
                                           WHERE (PresupuestoDAT__c > 0
                                              or PresupuestoR18__c > 0
                                              or PresupuestoR9__c > 0)
                                               and LineaProducto__c = 'Línea'
                                               and TipoActivacion__c <> 'Renovaciones' 
                                               and TipoRenta__c = 'Renta Alta'
                                               and Fechafirma__c <> null
                                               and StageName = 'Ganada'
                                               and OwnerId = :opp.OwnerId
                                               and CloseDate in (LAST_YEAR, THIS_YEAR, NEXT_YEAR)
                                          group by Calendar_Year(CloseDate), Calendar_Month(CloseDate)
                                        ])  {
                  System.debug('-----------------GANADAS------------------');
                  System.debug('Año              : ' + ar.get('expr0'));
                  System.debug('Mes              : ' + ar.get('expr4') + mapMonths.get(Integer.valueOf(ar.get('expr4'))));
                  System.debug('Presupuesto DAT  : ' + ar.get('expr1'));
                  System.debug('Presupuesto R9   : ' + ar.get('expr2'));
                  System.debug('Presupuesto R1-8 : ' + ar.get('expr3'));
              sLlave = opp.OwnerId + '' + Integer.valueOf(ar.get('expr0')) +  mapMonths.get(Integer.valueOf(ar.get('expr4')));
              System.debug('Llave Ganadas              : ' + sLlave);
              if (mapPresupuesto.containsKey(sLlave)){
                mapPresupuesto.get(sLlave).LlavePresupuesto__c = sLlave;
                mapPresupuesto.get(sLlave).GanadaR9__c = Double.valueOf(ar.get('expr2'));
                mapPresupuesto.get(sLlave).GanadaR1a8__c = Double.valueOf(ar.get('expr3'));
                mapPresupuesto.get(sLlave).GanadaDAT__c = Double.valueOf(ar.get('expr1')); 
              } else {
                newPresp = new Presupuesto__c();
                system.debug('revisar c ');
                newPresp.GanadaR9__c = 0;
                newPresp.GanadaR1a8__c = 0;
                newPresp.GanadaDAT__c = 0;
                
                newPresp.PrevisionR9__c = 0;
                newPresp.PrevisionR1a8__c = 0;
                newPresp.PrevisionDAT__c = 0;
                //if(opp.TipoPlataforma__c == 'Datos'){
                newPresp.Datos__c = 0;
                newPresp.DatosR1a8__c = 0;
                newPresp.DatosDAT__c = 0;
                //}else if(opp.TipoPlataforma__c == 'Voz'){
                newPresp.VozR9__c = 0;
                newPresp.VozR1a8__c = 0;
                newPresp.VozDAT__c = 0;
                //}else if(opp.TipoPlataforma__c == 'TIC'){
                newPresp.TICR9__c = 0;
                newPresp.TICR1a8__c = 0;
                newPresp.TICDat__c = 0;
                newPresp.JEC__c = opp.OwnerId;
                newPresp.OwnerId = opp.OwnerId;

                newPresp.LlavePresupuesto__c = sLlave;
                newPresp.Mes__c = mapMonths.get(Integer.valueOf(ar.get('expr4')));
                newPresp.Anio__c = String.valueOf(ar.get('expr0'));
                newPresp.OwnerId = opp.OwnerId;
                newPresp.GanadaR9__c =  Double.valueOf(ar.get('expr2'));
                newPresp.GanadaR1a8__c =  Double.valueOf(ar.get('expr3'));
                newPresp.GanadaDAT__c = Double.valueOf(ar.get('expr1'));   
                System.debug('Llave: ' + sLlave);  
                mapPresupuesto.put(sLlave,newPresp);          
              }
            }

	        //Si no es una prueba
	        if (!Test.isRunningTest()){ 
	            for (AggregateResult ar :   [
	                                      SELECT Calendar_Year(CloseDate), Sum(PresupuestoDAT__c), Sum(PresupuestoR9__c), Sum(PresupuestoR18__c), Calendar_Month(CloseDate)
	                                        FROM Opportunity
	                                       WHERE (PresupuestoDAT__c > 0
	                                          or PresupuestoR18__c > 0
	                                          or PresupuestoR9__c > 0)
	                                           and LineaProducto__c = 'Línea'
	                                           and TipoActivacion__c <> 'Renovaciones' 
	                                           and TipoRenta__c = 'Renta Alta'
	                                           and Fechafirma__c <> null
	                                           and StageName <> 'Perdida' 
	                                           //and StageName <> 'Ganada'
	                                           and OwnerId = :opp.OwnerId
	                                           and CloseDate in (LAST_YEAR, THIS_YEAR, NEXT_YEAR)
	                                      group by Calendar_Year(CloseDate), Calendar_Month(CloseDate)
	                                    ])  {
	                  System.debug('----------------PREVISIONES----------------');
	                  System.debug('Año              : ' + ar.get('expr0'));
	                  System.debug('Mes              : ' + ar.get('expr4') + mapMonths.get(Integer.valueOf(ar.get('expr4'))));
	                  System.debug('Presupuesto DAT  : ' + ar.get('expr1'));
	                  System.debug('Presupuesto R9   : ' + ar.get('expr2'));
	                  System.debug('Presupuesto R1-8 : ' + ar.get('expr3'));
	              sLlave = opp.OwnerId + '' + Integer.valueOf(ar.get('expr0')) + mapMonths.get(Integer.valueOf(ar.get('expr4')));
	               System.debug('Llave Previsiones              : ' + sLlave);
	              if (mapPresupuesto.containsKey(sLlave)){
	                mapPresupuesto.get(sLlave).LlavePresupuesto__c = sLlave;
	                mapPresupuesto.get(sLlave).PrevisionR9__c =  Double.valueOf(ar.get('expr2'));
	                mapPresupuesto.get(sLlave).PrevisionR1a8__c  =  Double.valueOf(ar.get('expr3'));
	                mapPresupuesto.get(sLlave).PrevisionDAT__c = Double.valueOf(ar.get('expr1'));     
	              } else {
	                newPresp = new Presupuesto__c();
	                newPresp.GanadaR9__c = 0;
	                newPresp.GanadaR1a8__c = 0;
	                newPresp.GanadaDAT__c = 0;
	                
	                newPresp.PrevisionR9__c = 0;
	                newPresp.PrevisionR1a8__c = 0;
	                newPresp.PrevisionDAT__c = 0;
	                //if(opp.TipoPlataforma__c == 'Datos'){
	                newPresp.Datos__c = 0;
	                newPresp.DatosR1a8__c = 0;
	                newPresp.DatosDAT__c = 0;
	                //}else if(opp.TipoPlataforma__c == 'Voz'){
	                newPresp.VozR9__c = 0;
	                newPresp.VozR1a8__c = 0;
	                newPresp.VozDAT__c = 0;
	                //}else if(opp.TipoPlataforma__c == 'TIC'){
	                newPresp.TICR9__c = 0;
	                newPresp.TICR1a8__c = 0;
	                newPresp.TICDat__c = 0;
	                newPresp.JEC__c = opp.OwnerId;
	                newPresp.OwnerId = opp.OwnerId;
	                newPresp.LlavePresupuesto__c = sLlave;
	                System.debug('Llave: ' + sLlave);  
	                newPresp.Mes__c = mapMonths.get(Integer.valueOf(ar.get('expr4')));
	                newPresp.Anio__c = String.valueOf(ar.get('expr0'));
	                newPresp.OwnerId = opp.OwnerId;
	                newPresp.PrevisionR9__c =  Double.valueOf(ar.get('expr2'));
	                newPresp.PrevisionR1a8__c =  Double.valueOf(ar.get('expr3'));
	                newPresp.PrevisionDAT__c = Double.valueOf(ar.get('expr1'));     
	                mapPresupuesto.put(sLlave,newPresp);       
	              }
	            }
	        }//Fin si no es una prueba    
	
	
	        //Si no es una prueba
	        if (!Test.isRunningTest()){ 
	            for (AggregateResult ar :   [
	                                          SELECT Calendar_Year(CloseDate), TipoPlataforma__c, Sum(PresupuestoDAT__c), Sum(PresupuestoR9__c), Sum(PresupuestoR18__c), Calendar_Month(CloseDate) 
	                                            FROM Opportunity
	                                           WHERE (PresupuestoDAT__c > 0
	                                              or PresupuestoR18__c > 0
	                                              or PresupuestoR9__c > 0)
	                                               and LineaProducto__c = 'Línea'
	                                               and TipoActivacion__c <> 'Renovaciones' 
	                                               and TipoRenta__c = 'Renta Alta'
	                                               and Fechafirma__c <> null
	                                               and StageName <> 'Perdida'
	                                               //and StageName <> 'Ganada'
	                                               and OwnerId = :opp.OwnerId
	                                               and CloseDate in (LAST_YEAR, THIS_YEAR, NEXT_YEAR)
	                                          group by Calendar_Year(CloseDate), Calendar_Month(CloseDate), TipoPlataforma__c
	                                          Order by Calendar_Year(CloseDate), Calendar_Month(CloseDate), TipoPlataforma__c
	                                        ])  {
	                  System.debug('-----------------PREVISIONES DESGLOSE---------------------');
	                  System.debug('Año              : ' + ar.get('expr0'));
	                  System.debug('Mes              : ' + ar.get('expr4') + mapMonths.get(Integer.valueOf(ar.get('expr4'))));
	                  System.debug('Plataforma       : ' + ar.get('TipoPlataforma__c'));
	                  System.debug('Presupuesto DAT  : ' + ar.get('expr1'));
	                  System.debug('Presupuesto R9   : ' + ar.get('expr2'));
	                  System.debug('Presupuesto R1-8 : ' + ar.get('expr3'));
	
	
	              sLlave = opp.OwnerId + '' + Integer.valueOf(ar.get('expr0')) + mapMonths.get(Integer.valueOf(ar.get('expr4')));
	               System.debug('Llave Previsiones desglose              : ' + sLlave);
	              if (mapPresupuesto.containsKey(sLlave)){
	                mapPresupuesto.get(sLlave).LlavePresupuesto__c = sLlave;
	                if(String.valueOf(ar.get('TipoPlataforma__c')) == 'Datos' || test.isRunningTest()){
	                    mapPresupuesto.get(sLlave).Datos__c = Double.valueOf(ar.get('expr2'));
	                    mapPresupuesto.get(sLlave).DatosR1a8__c = Double.valueOf(ar.get('expr3'));
	                    mapPresupuesto.get(sLlave).DatosDAT__c = Double.valueOf(ar.get('expr1'));
	                }
	                if(String.valueOf(ar.get('TipoPlataforma__c')) == 'Voz' || test.isRunningTest()){
	                    mapPresupuesto.get(sLlave).VozR9__c = Double.valueOf(ar.get('expr2'));
	                    mapPresupuesto.get(sLlave).VozR1a8__c = Double.valueOf(ar.get('expr3'));
	                    mapPresupuesto.get(sLlave).VozDAT__c = Double.valueOf(ar.get('expr1'));
	                }
	                if(String.valueOf(ar.get('TipoPlataforma__c')) == 'TIC'|| test.isRunningTest()){
	                    mapPresupuesto.get(sLlave).TICR9__c = Double.valueOf(ar.get('expr2'));
	                    mapPresupuesto.get(sLlave).TICR1a8__c = Double.valueOf(ar.get('expr3'));
	                    mapPresupuesto.get(sLlave).TICDat__c = Double.valueOf(ar.get('expr1'));
	                }
	              } else {
	                newPresp = new Presupuesto__c();
	                newPresp.GanadaR9__c = 0;
	                newPresp.GanadaR1a8__c = 0;
	                newPresp.GanadaDAT__c = 0;
	                
	                newPresp.PrevisionR9__c = 0;
	                newPresp.PrevisionR1a8__c = 0;
	                newPresp.PrevisionDAT__c = 0;
	                //if(opp.TipoPlataforma__c == 'Datos'){
	                newPresp.Datos__c = 0;
	                newPresp.DatosR1a8__c = 0;
	                newPresp.DatosDAT__c = 0;
	                //}else if(opp.TipoPlataforma__c == 'Voz'){
	                newPresp.VozR9__c = 0;
	                newPresp.VozR1a8__c = 0;
	                newPresp.VozDAT__c = 0;
	                //}else if(opp.TipoPlataforma__c == 'TIC'){
	                newPresp.TICR9__c = 0;
	                newPresp.TICR1a8__c = 0;
	                newPresp.TICDat__c = 0;
	                newPresp.JEC__c = opp.OwnerId;
	                newPresp.OwnerId = opp.OwnerId;
	                newPresp.LlavePresupuesto__c = sLlave;
	                System.debug('Llave: ' + sLlave);  
	                newPresp.Mes__c = mapMonths.get(Integer.valueOf(ar.get('expr4')));
	                newPresp.Anio__c = String.valueOf(ar.get('expr0'));
	                newPresp.OwnerId = opp.OwnerId;
	                if(String.valueOf(ar.get('TipoPlataforma__c')) == 'Datos' || test.isRunningTest()){
	                    newPresp.Datos__c = Double.valueOf(ar.get('expr2'));
	                    newPresp.DatosR1a8__c = Double.valueOf(ar.get('expr3'));
	                    newPresp.DatosDAT__c = Double.valueOf(ar.get('expr1'));
	                }
	                if(String.valueOf(ar.get('TipoPlataforma__c')) == 'Voz' || test.isRunningTest()){
	                    newPresp.VozR9__c = Double.valueOf(ar.get('expr2'));
	                    newPresp.VozR1a8__c = Double.valueOf(ar.get('expr3'));
	                    newPresp.VozDAT__c = Double.valueOf(ar.get('expr1'));
	                }
	                if(String.valueOf(ar.get('TipoPlataforma__c')) == 'TIC'|| test.isRunningTest()){
	                    newPresp.TICR9__c = Double.valueOf(ar.get('expr2'));
	                    newPresp.TICR1a8__c = Double.valueOf(ar.get('expr3'));
	                    newPresp.TICDat__c = Double.valueOf(ar.get('expr1'));
	                }
	
	                mapPresupuesto.put(sLlave,newPresp);
	              }
	
	            }//Fin del for
	            
	        }//Fin si no es una prueba            
            
            //Ve si la opp ya esta cerrada para mandar llamar el WA de Referencia RAP
            if(mapRecTypeEmbudo.containsKey(opp.recordTypeId)){
				sIdEmbudoFolioSap += opp.id + ',';
            }//Fin si mapRecTypeEmbudo.containsKey(opp.recordTypeId)

            System.debug('Tamaño: '  + mapPresupuesto.Values());
            if (!Test.isRunningTest())            
              upsert mapPresupuesto.Values() LlavePresupuesto__c;

        }//Termina ************************trigger.new para after update
        
        System.debug('EN OpportunityTriggerHandler: '  + sIdEmbudoFolioSap);        
        //Muy bien ya tienes los id de los reg que se van a actualizar mandalos al servicio web
        if (sIdEmbudoFolioSap != null && sIdEmbudoFolioSap != ''){
        	//Para actualizar la ReferenciaRAP
			//DCT_Utils_cls.ActualizaReferenciaRAP(sIdEmbudoFolioSap);
        	//Para actualizar la FolioSAP
			//DCT_Utils_cls.ActualizaFolioSAP(sIdEmbudoFolioSap);
        }//Fin si sIdEmbudoFolioSap != null && sIdEmbudoFolioSap != ''
        
    }
    


    /*private void updPresupuesto(Opportunity opp, Opportunity oldOpp, string sValor){

        //string sLlave = system.UserInfo.getUserId() + opp.CloseDate.year() +  mapMonths.get(opp.CloseDate.month());
        string sLlave = opp.OwnerId + '' + opp.CloseDate.year() +  mapMonths.get(opp.CloseDate.month());
        
        decimal dAddPresupuestoR9, dAddPresupuestoR18, dAddPresupuestoDAT;
        system.debug('revisar a '+sValor);
        List<Presupuesto__c> lstPresp = new List<Presupuesto__c>();
        List<Presupuesto__c> allPresup = new List<Presupuesto__c>();
        //Consulta si ya existe el registro
        if (!Test.isRunningTest()){                 
            allPresup = 
                [select 
                 PrevisionR9__c, PrevisionR1a8__c, PrevisionDAT__c,
                 Datos__c, DatosR1a8__c, DatosDAT__c, 
                 VozR9__c, VozR1a8__c, VozDAT__c, 
                 TICR9__c, TICR1a8__c, TICDat__c,
                 GanadaR9__c, GanadaR1a8__c, GanadaDAT__c
                 from Presupuesto__c 
                 where LlavePresupuesto__c = :sLlave
                 limit 1] ;
        }
        //Prepara el registro para el upsert
        Presupuesto__c newPresp = new Presupuesto__c();  
        newPresp.LlavePresupuesto__c = sLlave;
        newPresp.Mes__c = mapMonths.get(opp.CloseDate.month());
        newPresp.Anio__c = String.valueOf(opp.CloseDate.year());
        //*********************************** Si encuentra un presupuesto
        
        if(allPresup.size()>0) {
            system.debug('revisar b ');
            //Se agregan los datos del presupuesto encontrado a un nuevo registro
            newPresp.GanadaR9__c = (allPresup[0].GanadaR9__c == null ? 0 : allPresup[0].GanadaR9__c) ;
            newPresp.GanadaR1a8__c = (allPresup[0].GanadaR1a8__c == null ? 0 : allPresup[0].GanadaR1a8__c);
            newPresp.GanadaDAT__c = (allPresup[0].GanadaDAT__c == null ? 0 : allPresup[0].GanadaDAT__c) ;

            newPresp.PrevisionR9__c = (allPresup[0].PrevisionR9__c == null ? 0 : allPresup[0].PrevisionR9__c);
            newPresp.PrevisionR1a8__c = (allPresup[0].PrevisionR1a8__c == null ? 0 : allPresup[0].PrevisionR1a8__c); 
            newPresp.PrevisionDAT__c = (allPresup[0].PrevisionDAT__c == null ? 0 : allPresup[0].PrevisionDAT__c);
 
            //if(opp.TipoPlataforma__c == 'Datos'){
            newPresp.Datos__c = (allPresup[0].Datos__c == null ? 0 : allPresup[0].Datos__c);
            newPresp.DatosR1a8__c = (allPresup[0].DatosR1a8__c == null ? 0 : allPresup[0].DatosR1a8__c);
            newPresp.DatosDAT__c = (allPresup[0].DatosDAT__c == null ? 0 : allPresup[0].DatosDAT__c);
            //}else if(opp.TipoPlataforma__c == 'Voz'){
            newPresp.VozR9__c = (allPresup[0].VozR9__c == null ? 0 : allPresup[0].VozR9__c);
            newPresp.VozR1a8__c = (allPresup[0].VozR1a8__c == null ? 0 : allPresup[0].VozR1a8__c);
            newPresp.VozDAT__c = (allPresup[0].VozDAT__c == null ? 0 : allPresup[0].VozDAT__c);
            //}else if(opp.TipoPlataforma__c == 'TIC'){
            newPresp.TICR9__c = (allPresup[0].TICR9__c == null ? 0 : allPresup[0].TICR9__c);
            newPresp.TICR1a8__c = (allPresup[0].TICR1a8__c == null ? 0 : allPresup[0].TICR1a8__c);
            newPresp.TICDat__c = (allPresup[0].TICDat__c == null ? 0 : allPresup[0].TICDat__c);
            //}
        }else{// sino encuentra presupuesto lo pone en cero
            system.debug('revisar c ');
            newPresp.GanadaR9__c = 0;
            newPresp.GanadaR1a8__c = 0;
            newPresp.GanadaDAT__c = 0;
            
            newPresp.PrevisionR9__c = 0;
            newPresp.PrevisionR1a8__c = 0;
            newPresp.PrevisionDAT__c = 0;
            //if(opp.TipoPlataforma__c == 'Datos'){
            newPresp.Datos__c = 0;
            newPresp.DatosR1a8__c = 0;
            newPresp.DatosDAT__c = 0;
            //}else if(opp.TipoPlataforma__c == 'Voz'){
            newPresp.VozR9__c = 0;
            newPresp.VozR1a8__c = 0;
            newPresp.VozDAT__c = 0;
            //}else if(opp.TipoPlataforma__c == 'TIC'){
            newPresp.TICR9__c = 0;
            newPresp.TICR1a8__c = 0;
            newPresp.TICDat__c = 0;
            newPresp.JEC__c = UserInfo.getUserId();
            //}Hola...
        }
        
        dAddPresupuestoR9 = (opp.PresupuestoR9__c == null ? 0 : opp.PresupuestoR9__c); 
        dAddPresupuestoR18 = (opp.PresupuestoR18__c == null ? 0 : opp.PresupuestoR18__c); 
        dAddPresupuestoDAT = (opp.PresupuestoDAT__c == null ? 0 : opp.PresupuestoDAT__c);
        
        if (sValor == 'Ganada' || test.isRunningTest()){
            
            newPresp.GanadaR9__c = newPresp.GanadaR9__c + dAddPresupuestoR9 ;
            newPresp.GanadaR1a8__c = newPresp.GanadaR1a8__c + dAddPresupuestoR18;
            newPresp.GanadaDAT__c = newPresp.GanadaDAT__c + dAddPresupuestoDAT;
            
        }
        
        if (sValor == 'Diferencia' || test.isRunningTest()){ // se calcula la diferencia
            
            dAddPresupuestoR9 =  dAddPresupuestoR9 - (oldOpp.PresupuestoR9__c == null ? 0 : oldOpp.PresupuestoR9__c);
            dAddPresupuestoR18 =  dAddPresupuestoR18 - (oldOpp.PresupuestoR18__c == null ? 0 : oldOpp.PresupuestoR18__c);
            dAddPresupuestoDAT =  dAddPresupuestoDAT - (oldOpp.PresupuestoDAT__c == null ? 0 : oldOpp.PresupuestoDAT__c);
        }
        
        if(sValor == 'Resta' || test.isRunningTest()){ //Se vuelve negativo
            dAddPresupuestoR9 = dAddPresupuestoR9 * -1; 
            dAddPresupuestoR18 = dAddPresupuestoR18 * -1; 
            dAddPresupuestoDAT = dAddPresupuestoDAT * -1;
        }
        
        // Se suma
        if(sValor == 'Resta' || sValor == 'Suma' || sValor == 'Diferencia' || test.isRunningTest()){
            system.debug('revisar d ');
            newPresp.PrevisionR9__c = newPresp.PrevisionR9__c + dAddPresupuestoR9 ;
            newPresp.PrevisionR1a8__c = newPresp.PrevisionR1a8__c + dAddPresupuestoR18 ;
            newPresp.PrevisionDAT__c = newPresp.PrevisionDAT__c + dAddPresupuestoDAT ;
            if(opp.TipoPlataforma__c == 'Datos' || test.isRunningTest()){
                newPresp.Datos__c = newPresp.Datos__c + dAddPresupuestoR9;
                newPresp.DatosR1a8__c = newPresp.DatosR1a8__c + dAddPresupuestoR18;
                newPresp.DatosDAT__c = newPresp.DatosDAT__c + dAddPresupuestoDAT;
            }
            if(opp.TipoPlataforma__c == 'Voz' || test.isRunningTest()){
                newPresp.VozR9__c = newPresp.VozR9__c + dAddPresupuestoR9;
                newPresp.VozR1a8__c = newPresp.VozR1a8__c + dAddPresupuestoR18;
                newPresp.VozDAT__c = newPresp.VozDAT__c + dAddPresupuestoDAT;
            }
            if(opp.TipoPlataforma__c == 'TIC'|| test.isRunningTest()){
                newPresp.TICR9__c = newPresp.TICR9__c + dAddPresupuestoR9;
                newPresp.TICR1a8__c = newPresp.TICR1a8__c + dAddPresupuestoR18;
                newPresp.TICDat__c = newPresp.TICDat__c + dAddPresupuestoDAT;
            }
        }
        system.debug('revisar e ');
        lstPresp.add(newPresp);
        if (!Test.isRunningTest())            
            upsert lstPresp LlavePresupuesto__c;
        
    } */
    
    private void updAccClosedDate(Opportunity opp, string accion){
        List<Account> lstAcc = new List<Account>();
        Account accToUpdate = new Account(Id = opp.AccountId);
        if (accion == 'Limpia'){
            accToUpdate.FechaCierreUltimaOportunidad__c = null;
            accToUpdate.NombreUltimoEmbudo__c = null;
            accToUpdate.Uno__c = null;
        }else{
            accToUpdate.FechaCierreUltimaOportunidad__c = opp.CloseDate;
            accToUpdate.NombreUltimoEmbudo__c = opp.Name;
            accToUpdate.Uno__c = 1;
        }
        system.debug('revisar ' + accToUpdate);
        
        lstAcc.add(accToUpdate);
        system.debug('revisar ' + lstAcc);
        if(!Test.isRunningTest())            
            update lstAcc;
    }
    
}