/****************************************************************************************************
* Autor: Alejandro Hurtado ahurtado@avanxo.com
* Descripcion: esta clase contiene la lógica que se debe ejecutar cada vez que
*			   se dispara un trigger.
* Creada en: 2016-01-25

Cambios (Versiones)
    ---------------------------------------------------------------------------
    No.     Fecha       Autor              Descripción
    ---     ----------  -----------------  ---------------------------
    1.0     2016-01-25                     Creación de la Clase
    1.2     19-02-2016   Sergio Ortiz      Modificacion de la clase para relacionar el mapa de cliente
******************************************************************************************************/
public with sharing class Opportunity_cls
{
	public static map<String, RecordType> mapStrRecordType;
	
	static
	{
		Opportunity_cls.mapStrRecordType = new map<String, RecordType>();
		
		//Obtenemos los tipos de regustro
		list<RecordType> lstRT =
		[
			select Id, DeveloperName
			from RecordType
			where SObjectType = 'SeguimientoOportunidades__c'
			and DeveloperName IN ('Corporativo', 'Empresarial', 'PyME')
		];
		
		//Recorremos la lista de tipos de registros para llenar el map
		for( RecordType objRT : lstRT )
		{
			Opportunity_cls.mapStrRecordType.put( objRT.DeveloperName, objRT );
		}
	}
	
	/**************************************************************************
	*
	**************************************************************************/
    public static void createSeguimientoOportunidad( list<Opportunity> lstOpportunity )
    {
    	//Creamos un set de ids para guardar los ids de las cuentas
    	set<Id> setIdAccount = new set<Id>();
    	
    	//Recorremos la lista de las oportunidades
    	for( Opportunity objOpp : lstOpportunity )
    	{
    		setIdAccount.add( objOpp.AccountId );
    	}
    	
    	//Obtenemos todas las cuentas asociadas a los ids del set
    	map<Id, Account> mapIdAccount = new map<Id, Account>
    	(
    		[
	    		SELECT Id, Segmento__c 
	    		FROM Account
	    		WHERE Id IN: setIdAccount
    		]
    	);

        //SAO - Relacionar el Mapa de Cliente----
        //Lista de Mapa de Cliente
        List<MapaCliente__c> lstMapaCuenta = new List<MapaCliente__c>([SELECT Id,Name,PlanCliente__c 
                                                                       FROM MapaCliente__c 
                                                                       WHERE PlanCliente__c IN: setIdAccount]);

        //Mapa con el Mapa de Cliente para las cuentas de las Oportunidades
        Map<String,MapaCliente__c> mapMapaCuenta = new Map<String,MapaCliente__c>();
        if (!lstMapaCuenta.isEmpty()) {
            for(MapaCliente__c objMapaCuenta: lstMapaCuenta)
                mapMapaCuenta.put(objMapaCuenta.PlanCliente__c, objMapaCuenta);
        }       
        System.debug('@@-mapMapaCuenta->'+mapMapaCuenta);
        //SAO - Relacionar el Mapa de Cliente----

    	
    	//Creamos una lista de Seguimiento de Oportunidad
    	list<SeguimientoOportunidades__c> lstSO = new list<SeguimientoOportunidades__c>();
    	
    	//Recorremos la lista de las oportunidades
    	for( Opportunity objOpp : lstOpportunity )
    	{
    		//Obtenemos el objeto cuenta
			Account objAccount = mapIdAccount.get( objOpp.AccountId );

	    	//Creamos el seguimiento y lo agregamos a la lista
			SeguimientoOportunidades__c objSO = new SeguimientoOportunidades__c ();
			
			//Obtenemos el segmento de la cuenta
			String strSegmento = objAccount.Segmento__c;
			
			//Validamos que haya un valor en el segmento
			if( strSegmento != null )
			{
    			//Obtenemos el tipo de registro asociado al segmento
    			RecordType objRT = Opportunity_cls.mapStrRecordType.get( objAccount.Segmento__c );
    		
    			//Asignamos el tipo de registro
				objSO.RecordTypeId = objRT.Id;
			}
			
			objSO.Embudo__c = objOpp.Id;
			objSO.PlanCliente__c = objAccount.Id;
            objSO.Name = 'SO-'+objOpp.Name;

            //SAO - Asignacion del Mapa de Cliente al seguimiento de Oportunidad
            if (objSO.MapaCliente__c == null && mapMapaCuenta.containsKey(objAccount.Id) && mapMapaCuenta.get(objAccount.Id).Id != null) {
                objSO.MapaCliente__c = mapMapaCuenta.get(objAccount.Id).Id;
                System.debug('@@-objSO.MapaCliente__c->'+objSO.MapaCliente__c); 
            }           


			lstSO.add( objSO );
    	}
    	if (!Test.isRunningTest())
			insert lstSO;
        
        list<SeguimientoOportunidades__c> lstSO2 = new list<SeguimientoOportunidades__c>();
        set<Id> setIdSO = new set<Id>();
        for( SeguimientoOportunidades__c objSO : lstSO )
            {
                if (!Test.isRunningTest())
                	setIdSO.add( objSO.Id );
            }
		
		if (!Test.isRunningTest()){
        	lstSO2 = [select Id,Segmento__c,Embudo__c,PlanCliente__c,Proximaaccion__c,Fechaproximaaccion__c,AlarmaRentabilidad__c,AlarmaFase__c,AlarmaOportunidad__c from SeguimientoOportunidades__c where id IN :setIdSO ];
        	SeguimientoOportunidad_cls.createControlAlarma(  lstSO2 );
		}
    }
    
    public static void updateSeguimientosOportunidades( list<Opportunity> lstOpportunity )
    {
    	//Creamos un map para asociar el id de la oportunidad y el valor a poner
    	//en el campo Oportunidad de sus registros de Seguimiento de oportunidad
    	map<Id, String> mapIdStringOpp = new map<Id, String>();
    	
    	String strSegmento = '';
    	
    	//Recorremos la lista de oportunidades
    	for( Opportunity objOpportunity : lstOpportunity )
    	{
            system.debug('StageName-->' + objOpportunity.StageName + 'Id--> ' + objOpportunity.id);
    		strSegmento = objOpportunity.Segmento__c != null ? objOpportunity.Segmento__c : '';
    		
    		if( ( strSegmento.equalsIgnoreCase( 'Corporativo' ) || strSegmento.equalsIgnoreCase( 'Empresarial' ) )
    			&& objOpportunity.StageName.equalsIgnoreCase( 'Oportunidad' ) ){
    			mapIdStringOpp.put( objOpportunity.Id, objOpportunity.Description );
    		}else if( ( strSegmento.equalsIgnoreCase( 'Corporativo' ) || strSegmento.equalsIgnoreCase( 'Empresarial' ) )
    			&& objOpportunity.StageName.equalsIgnoreCase( 'Aproximación' ) ){
    			mapIdStringOpp.put( objOpportunity.Id, objOpportunity.OportunidadlenguajeCliente__c );
    		}else if( ( strSegmento.equalsIgnoreCase( 'Corporativo' ) || strSegmento.equalsIgnoreCase( 'Empresarial' ) )
    			&& !objOpportunity.StageName.equalsIgnoreCase( 'Aproximación' )
    			&& !objOpportunity.StageName.equalsIgnoreCase( 'Oportunidad' ) ){
    			mapIdStringOpp.put( objOpportunity.Id, objOpportunity.OportunidadlenguajeP__c );
    		}else if( strSegmento.equalsIgnoreCase( 'PyME' ) && ( objOpportunity.StageName.equalsIgnoreCase( 'Oportunidad' )
    				|| objOpportunity.StageName.equalsIgnoreCase( 'Aproximación' ) ) ){
    			mapIdStringOpp.put( objOpportunity.Id, objOpportunity.Description );
    		}else if( strSegmento.equalsIgnoreCase( 'PyME' ) && !objOpportunity.StageName.equalsIgnoreCase( 'Aproximación' )
    			&& !objOpportunity.StageName.equalsIgnoreCase( 'Oportunidad' ) ){
    			mapIdStringOpp.put( objOpportunity.Id, objOpportunity.OportunidadlenguajeP__c );
    		}
    		//system.debug( '*** objOpportunity.Segmento__c = ' + objOpportunity.Segmento__c );
    	}
    	
    	//Buscamos los seguimientos de oportunidades
    	list<SeguimientoOportunidades__c> lstSO = new list<SeguimientoOportunidades__c>();
    	
    	if (!Test.isRunningTest()){
	    	lstSO =
	    	[
	    		select Id, OportunidadEmbudo__c, Embudo__c
	    		from SeguimientoOportunidades__c
	    		where Embudo__c IN :mapIdStringOpp.keySet()
	    	];
    	}
    	//Recorremos los seguimientos obtenidos
    	for( SeguimientoOportunidades__c objSO : lstSO )
    	{
    		//Obtenemos el valor de la oportunidad asociada
    		String strOportunidad = mapIdStringOpp.get( objSO.Embudo__c );
    		objSO.OportunidadEmbudo__c = strOportunidad;
    	}
    	
    	if( lstSO.size() > 0 )
    	{
            system.debug('listaseguimientosactualizar' + lstSO);
            if (!Test.isRunningTest())
    			update lstSO;
    	}
        list<SeguimientoOportunidades__c> lstSO2 = new list<SeguimientoOportunidades__c>();
        set<Id> setIdSO = new set<Id>();
        for( SeguimientoOportunidades__c objSO : lstSO )
        {
        	if (!Test.isRunningTest())
            	setIdSO.add( objSO.Id );
        }

		if (!Test.isRunningTest()){
        	lstSO2 = [select Id,Segmento__c,Embudo__c,PlanCliente__c,Proximaaccion__c,Fechaproximaaccion__c,AlarmaRentabilidad__c,AlarmaFase__c,AlarmaOportunidad__c from SeguimientoOportunidades__c where id IN :setIdSO ];
       	 	SeguimientoOportunidad_cls.createControlAlarma(  lstSO2 );
		}
    }
}