/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Carlos Gonzalez
Proyecto:                Telcel
Descripción:             Clase de TEST encargada del informe del TOP de Oportunidades
Requerimiento:           

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     28-01-2016  Carlos Gonzalez                 Creación de la clase.
*******************************************************************************/
@isTest 
public class TOP_Oportunidades_tst
{	
	public static List<TOP_Oportunidades_ctr.OpportunityWrapper> lstOpportunityWrapper;
	public static Opportunity[] lstOpportunity;
	public static String strMonthNow;
	public static String strLinkReport;
	public static String[] strNomOportunidades;
	public static String[] strStagename;

	public static void generateData(Boolean blnCreate) 
    {
		String 					rtCliente 				= '';
		String 					rtMapa					= '';
		
		for(RecordType rt : [SELECT DeveloperName,Name,SobjectType FROM RecordType])
		{
			if (rt.SobjectType == 'Account' && rt.developerName == 'PlanClienteTelcelPyME'){
				rtCliente = rt.id;
			}
			if (rt.SobjectType == 'MapaCliente__c' && rt.developerName == 'Corporativo'){
				rtMapa = rt.id;
			}
		}
        Account objAccount =
    	DataGenerator_cls.createAccount( true, 'Test Acount', 'Corporativo',rtCliente);
        
        Contact objContact =
    	DataGenerator_cls.createContact( true, objAccount, 'LastName', 'FirstName' );

    	strNomOportunidades = new String[]{'RUTA 18','FP','AVICOLA SAN ANDRES SA DE CV','MEDICUS','BLM'};
    	strStagename = new String[]{'Oportunidad','Aproximación','Contacto','Proyecto','Propuesta'};
    	lstOpportunity = new List<Opportunity>();
    	lstOpportunityWrapper = new List<TOP_Oportunidades_ctr.OpportunityWrapper>();
    	for(Integer i = 0; i < strNomOportunidades.size(); i++)
    	{

	    	Opportunity objOpportunity =
        	DataGenerator_cls.createOpportunity( true, 'Opportunity Test',
        	objAccount, objContact, 'Oportunidad' );

	    	//objOpportunity.Name = strNomOportunidades[i];
	    	objOpportunity.PresupuestoR9__c = (i+1) * 100000;
	    	objOpportunity.StageName = strStagename[i];	
	    	//objOpportunity.CloseDate = Date.newInstance(System.today().year(),System.today().month(),System.today().day());

	    	lstOpportunity.add(objOpportunity);    

	    	lstOpportunityWrapper.add(new TOP_Oportunidades_ctr.OpportunityWrapper(objOpportunity) );
    	}

    	if(blnCreate)
    	{
    		if(lstOpportunity.size() > 0){
    			update lstOpportunity;
    		
    			lstOpportunity[0].DAT__c = DataGenerator_cls.createDAT(true).Id;
	    		lstOpportunity[0].PresupuestoR9__c = 100;
	         	lstOpportunity[0].PresupuestoR18__c = 100;
	         	lstOpportunity[0].PresupuestoDAT__c = 100;
				lstOpportunity[0].Rentabilidad__c = 100;
				update lstOpportunity;
				lstOpportunity[0].FechacontactoP__c = date.today().addDays(1);
				lstOpportunity[0].PersonaRIP__c = objContact.Id;
				lstOpportunity[0].FechaRIP__c = date.today().addDays(1);
				lstOpportunity[0].Fechafirma__c = date.today().addDays(1);
				lstOpportunity[0].OportunidadlenguajeCliente__c = 'Negocios';
				lstOpportunity[0].Proyectolisto__c = 'Fase terminal';
				lstOpportunity[0].ValidaAprovIC__c = true;
				lstOpportunity[0].PendienteAprobacionIC__c = false;
				lstOpportunity[0].PendienteAprobacionRentabilidad__c = false;
				lstOpportunity[0].LineaProducto__c = 'Línea';
	        	lstOpportunity[0].TipoActivacion__c = 'Nueva';
	         	lstOpportunity[0].TipoPlataforma__c = 'Voz';
	         	lstOpportunity[0].CompaniaOrigen__c = 'IUSACELL0';
	         	lstOpportunity[0].Importante__c = 'No'; 
	         	lstOpportunity[0].Riesgo__c = 'No';
	         	update lstOpportunity;
    		
    		
    		}
    	}
    	
    	


	}

    /*
    * Description: Test para mostrar generar un informe a satisfacción
    */
	@isTest 
	public static void test_generarInforme_caso1() 
    {
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('PlanCliente');
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('Contact_tgr'); 
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');
    	Integer i = 1;
    	generateData(true);

    	i = (lstOpportunity.size() == 0 ? i : lstOpportunity.size());
        Date dNow = Date.today();
        Integer intNumberOfDays = Date.daysInMonth(dNow.year(), dNow.month());
        Date datFirstDayOfMonth = Date.newInstance(dNow.year(), dNow.month(), 1);
        Date datLastDayOfMonth = Date.newInstance(dNow.year(), dNow.month(), intNumberOfDays);
		Test.startTest();
        System.debug('... query: ' +[SELECT Prioridad_Fase__c,AlarmaAproximacion__c, AlarmaContacto__c, AlarmaEmbudo__c,
            AlarmaOportunidad__c, AlarmaPropuesta__c, AlarmaProyecto__c, Account.Name, Name, PresupuestoR9__c, StageName, Fase__c,CloseDate FROM Opportunity 
        WHERE  StageName != 'Perdida' AND StageName != 'Ganada' AND PresupuestoR9__c!=null AND PresupuestoR9__c>0
        ORDER BY Prioridad_Fase__c,PresupuestoR9__c DESC NULLS LAST]);
        DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_Opportunity');
    	TOP_Oportunidades_ctr ctrTOP_Oportunidades = new TOP_Oportunidades_ctr();
    	ctrTOP_Oportunidades.getLinkReport();
    	ctrTOP_Oportunidades.getTopOpportunitys();
    

    	//System.assertNotEquals(ctrTOP_Oportunidades.lstOpportunityWrapper,null);
    	//System.assertEquals(ctrTOP_Oportunidades.lstOpportunityWrapper.size(), i);

    	lstOpportunityWrapper.sort();

    	Test.stopTest();
    }
}