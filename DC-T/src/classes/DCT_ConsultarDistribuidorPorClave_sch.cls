global class DCT_ConsultarDistribuidorPorClave_sch implements Schedulable{

	global String sQuery {get;set;}
		
    global void execute(SchedulableContext ctx){
		System.debug('EN DCT_ConsultarDistribuidorPorClave_sch.execute...');

		this.sQuery = 'Select id From User Where isActive = true ';		

		//No es una prueba
		if (!Test.isRunningTest())
			this.sQuery += ' LIMIT 1';
		
		//Si es una prueba
		if (Test.isRunningTest())
			this.sQuery += ' LIMIT 1';

		System.debug('EN DCT_ConsultarDistribuidorPorClave_sch.execute sQuery: ' + sQuery);
		
		//Crea el objeto de  DCT_AdminCartera_bch   	
        DCT_ConsultarDistribuidorPorClave_bch objDepRegCls = new DCT_ConsultarDistribuidorPorClave_bch(sQuery);
        
        //No es una prueba entonces procesa de 1 en 1
       	Id batchInstanceId = Database.executeBatch(objDepRegCls, 1);
			    	 
    }
    
}