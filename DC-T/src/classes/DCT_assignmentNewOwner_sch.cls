/***************************************************************************************************************************
   Desarrollado por: Avanxo México                                                                                        
   Autor: Luis Enrique Garcia Sanabria                                                                         
   Email: legarcia@avanxo.com                                                                                  
   Fecha de creación: 18-04-2018                                                                                           
 ***************************************************************************************************************************
   Metadata:                                                                                                               
 ***************************************************************************************************************************
   Descripción: Clase batch para realizar el cambio del propietario del DCT(Cuenta) y de y de sus hijos.             
                                                                                                                           
 ***************************************************************************************************************************
                                                  Control de versiones                                                     
 ***************************************************************************************************************************
   No.      Fecha                 Autor                    Email                          Descripción                     
 ***************************************************************************************************************************
   1.0   18-04-2018   Luis Enrique Garcia Sanabria   legarcia@avanxo.com   Creacion de la clase DCT_assignmentNewOwner_cls 
 ***************************************************************************************************************************/
global class DCT_assignmentNewOwner_sch implements Schedulable {
	global void execute(SchedulableContext sc) {
		String stgStageName = system.Label.DCT_stgStageName_lbl;//Ganada
		String stgStageName2 = system.Label.DCT_stgStageName2_lbl;//Perdida
		String stgStageName3 = system.Label.DCT_stgStageName3_lbl;//Oportunidad
		String stgRecordType = system.Label.DCT_stgRecordType_lbl;//Lead
		String strQueryOverCases = 'SELECT Id, OwnerId, Name, RecordType.DeveloperName, DCTRegistrationDate__c,'+ 
		'DCTExtensionValidity__c, Cliente__r.DCT_RegistrationDate__c, Cliente__c, Cliente__r.OwnerId,'+
		' (SELECT Id, StageName FROM DirectorioComercial_Embudo__r WHERE StageName !=\''+stgStageName+
		'\' AND StageName !=\''+stgStageName2+'\' AND StageName !=\''+stgStageName3+'\') FROM Cliente__c '+
		'WHERE RecordType.DeveloperName = \''+stgRecordType+'\'';
		system.debug('***strQueryOverCases: '+strQueryOverCases);
		DCT_assignmentNewOwner_bch bchInstace = new DCT_assignmentNewOwner_bch(strQueryOverCases);
		database.executebatch(bchInstace,300);
		scheduledNextExecution();
	}

	global void scheduledNextExecution(){
		DCT_assignmentNewOwner_sch schInstance = new DCT_assignmentNewOwner_sch();
		Datetime dateToExecute = System.now().addDays(1);
		String stringSch = '0 '+dateToExecute.minute()+' '+dateToExecute.hour()+' '+dateToExecute.day()+' '+dateToExecute.month()+
			' ? '+dateToExecute.year();
		String strJobID = system.schedule(
			'Change Owner '+dateToExecute.year()+'/'+dateToExecute.month()+'/'+dateToExecute.day()+' '+dateToExecute.hour()+':'
			+dateToExecute.minute(), 
			stringSch, 
			schInstance
		);
	}
}