global class EvaluarAlarmasSegOportunidades_Schdlb implements Schedulable {
	global void execute(SchedulableContext sc) {
		EvaluarAlarmasSegOportunidadBtch objetoBatch = new EvaluarAlarmasSegOportunidadBtch();
		if (!Test.isRunningTest())Database.executeBatch(objetoBatch);		
	}
}