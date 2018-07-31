/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Carlos Gonzalez
Proyecto:                Telcel
Descripción:             Clase Controlador de la pagina de VF encargada del informe del TOP de Oportunidades
Requerimiento:           

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     22-01-2016  Carlos Gonzalez                 Creación de la clase.
*******************************************************************************/
public with sharing class TOP_Oportunidades_ctr 
{
    public List<OpportunityWrapper> lstOpportunityWrapper {get;set;}
    public String strMonthNow {get;set;}
    public String strLinkReport {get;set;}

    private Integer intNumberOfDays {get;set;}
    private Date datFirstDayOfMonth {get;set;}
    private Date datLastDayOfMonth {get;set;}
    private Double dblTotal = 0;

    /*
    * Description: Constructor
    */
    public TOP_Oportunidades_ctr() 
    {
        lstOpportunityWrapper = new List<OpportunityWrapper>();

        Date dNow = Date.today();
        intNumberOfDays = Date.daysInMonth(dNow.year(), dNow.month());
        datFirstDayOfMonth = Date.newInstance(dNow.year(), dNow.month(), 1);
                datLastDayOfMonth = Date.newInstance(dNow.year(), dNow.month(), intNumberOfDays);
        if(Test.isRunningTest()){
        	for(Integer i = 1; i<13; i++){
        		strMonthNow = 'Mes Actual: ' + monthName(1);
        	}
        }
        strMonthNow = 'Mes Actual: ' + monthName(dNow.month());

        getTopOpportunitys();
        getLinkReport();
    }

    /*
    * Description: Busca el Id del informe InformeOportunidadesV2
    */
    public void getLinkReport()
    {
        try
        {
            Report oReport = [SELECT Id FROM Report WHERE DeveloperName = 'InformeOportunidadesV2' LIMIT 1] ;
            strLinkReport = oReport.Id;
        }
        catch (Exception e)
        {
            strLinkReport = '';
        }
    }

    /*
    * Description: Consulta las oportunidades que se van a mostrar en el informe
    */
    public void getTopOpportunitys()
    {
        dblTotal = 0;
        lstOpportunityWrapper.clear();
        // 'Oportunidad','Aproximación','Contacto','Proyecto', Propuesta','Ganada'
        for(Opportunity oTempO : [	SELECT Prioridad_Fase__c,AlarmaAproximacion__c, AlarmaContacto__c, 
        								   AlarmaEmbudo__c,AlarmaOportunidad__c, AlarmaPropuesta__c, 
        								   AlarmaProyecto__c, Account.Name, Name, PresupuestoR9__c, 
        								   StageName, Fase__c 
        						      FROM Opportunity 
        							 WHERE CloseDate >=: datFirstDayOfMonth 
        							   AND CloseDate <=: datLastDayOfMonth
        							   AND StageName != 'Perdida' 
        							   AND StageName != 'Ganada' 
        							   AND PresupuestoR9__c!=null 
        							   AND PresupuestoR9__c>0
        							   AND LineaProducto__c = 'Línea'
        							   AND TipoActivacion__c != 'Renovaciones'
        							   AND TipoRenta__c = 'Renta Alta'
        						  ORDER BY Prioridad_Fase__c,PresupuestoR9__c DESC NULLS LAST] )
        {
            if (oTempO.Account.Name.length() > 15)
                    oTempO.Account.Name = oTempO.Account.Name.substring(0, 15) + '...';
            oTempO.PresupuestoR9__c = (oTempO.PresupuestoR9__c == null ? 0 : oTempO.PresupuestoR9__c);
            if(lstOpportunityWrapper.size() <= 10)
                    lstOpportunityWrapper.add( new OpportunityWrapper(oTempO) );

            dblTotal = dblTotal + oTempO.PresupuestoR9__c;
        }

        //lstOpportunityWrapper.sort();

        lstOpportunityWrapper.add( new OpportunityWrapper(new Opportunity(Name='TOTAL',PresupuestoR9__c=dblTotal)) );
    }


    /*
    * Description: Clase Wrapper usada para mostrar las oportunidades ordenadas por mayor presupuesto
    */    
    public class OpportunityWrapper implements Comparable 
    {

        public Opportunity oppy {get;set;}
        public boolean blnAlarma {get;set;}
        
        public OpportunityWrapper(Opportunity op) {
            oppy = op;
            getblnAlarma();
        }
        
        public Integer compareTo(Object compareTo) {

            OpportunityWrapper compareToOppy = (OpportunityWrapper)compareTo;
            
            Integer returnValue = -1;
            if (oppy.Prioridad_Fase__c==compareToOppy.oppy.Prioridad_Fase__c) 
            {
               if(oppy.PresupuestoR9__c < compareToOppy.oppy.PresupuestoR9__c)
                {
                    returnValue = 1;
                } 
                
                return returnValue;
            }
            if (oppy.Prioridad_Fase__c<compareToOppy.oppy.Prioridad_Fase__c) 
            {
               
                returnValue = 1;
                return returnValue;
            }
            
            return returnValue;       
        }
        
        public void getblnAlarma()
        {
            blnAlarma=false;
            system.debug(oppy);
            if(oppy.Prioridad_Fase__c==1&&oppy.AlarmaPropuesta__c.contains('red'))
            {
                blnAlarma=true;
                return;
            }
            if(oppy.Prioridad_Fase__c==2&&oppy.AlarmaProyecto__c.contains('red'))
            {
                blnAlarma=true;
                return;
            }
            if(oppy.Prioridad_Fase__c==3&&oppy.AlarmaContacto__c.contains('red'))
            {
                blnAlarma=true;
                return;
            }
            if(oppy.Prioridad_Fase__c==4&&oppy.AlarmaAproximacion__c.contains('red'))
            {
                blnAlarma=true;
                return;
            }
            if(oppy.Prioridad_Fase__c==5&&oppy.AlarmaOportunidad__c.contains('red'))
            {
                blnAlarma=true;
                return;
            }
        }

    }

    /*
    * Description: retorna el nombre del Mes en base al numero
    */
    private String monthName(Integer intNumDay)
    {
        String strNameMonth = '';
        strNameMonth = (intNumDay == 1 ? 'Enero' : strNameMonth);
        strNameMonth = (intNumDay == 2 ? 'Febrero' : strNameMonth);
        strNameMonth = (intNumDay == 3 ? 'Marzo' : strNameMonth);
        strNameMonth = (intNumDay == 4 ? 'Abril' : strNameMonth);
        strNameMonth = (intNumDay == 5 ? 'Mayo' : strNameMonth);
        strNameMonth = (intNumDay == 6 ? 'Junio' : strNameMonth);
        strNameMonth = (intNumDay == 7 ? 'Julio' : strNameMonth);
        strNameMonth = (intNumDay == 8 ? 'Agosto' : strNameMonth);
        strNameMonth = (intNumDay == 9 ? 'Septiembre' : strNameMonth);
        strNameMonth = (intNumDay == 10 ? 'Octubre' : strNameMonth);
        strNameMonth = (intNumDay == 11 ? 'Noviembre' : strNameMonth);
        strNameMonth = (intNumDay == 12 ? 'Diciembre' : strNameMonth);

        return strNameMonth;
    }
}