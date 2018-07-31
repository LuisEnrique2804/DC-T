public with sharing class PrevisionesChart_ctr 
{

    private Integer intNumberOfDays {get;set;}
    private Integer intNumberOfDaysAfter {get;set;}
    private Date datFirstDayBefore {get;set;}
    private Date datFirstDayOfMonth {get;set;}
    private Date datLastDayOfMonth {get;set;}
    private Date datFirstDayOfAfter {get;set;}
    private Date datLastDayOfAfter {get;set;}
    private Date datFirstDayOfAfter2 {get;set;}
    private Date datLastDayOfAfter2 {get;set;}
    private String strLabelMonthsBefore {get;set;}
    private Integer intMeses;
    public String strTipoInforme{get;set;}
    public String strURL{get;set;}

    public PrevisionesChart_ctr()
    {        
        strTipoInforme='';
        // MesesPrevision__c
        intMeses = 6;
        strURL='';
        List<MesesPrevision__c> lstMesesPrevision = MesesPrevision__c.getall().values();

        if(lstMesesPrevision.size() > 0)
        {
            if (lstMesesPrevision[0].Name != null) 
            {
                intMeses = Integer.valueof(lstMesesPrevision[0].Name);
            }
        }
        intMeses = intMeses * -1;
        
        strLabelMonthsBefore = 'Meses Ant.';

        // Mes Actual
        Date dNow = Date.today();        
        intNumberOfDays = Date.daysInMonth(dNow.year(), dNow.month());
        datFirstDayOfMonth = Date.newInstance(dNow.year(), dNow.month(), 1);
        datLastDayOfMonth = Date.newInstance(dNow.year(), dNow.month(), intNumberOfDays);

        // Meses Anteriores
        datFirstDayBefore = datFirstDayOfMonth;
        datFirstDayBefore = datFirstDayBefore.addMonths(intMeses); // Se requiere Conf. Personalizada        

        // Mes Futuro
        datFirstDayOfAfter = Date.newInstance(dNow.year(), dNow.month(), 1);
        datFirstDayOfAfter = datFirstDayOfAfter.addMonths(1);
        intNumberOfDaysAfter = Date.daysInMonth(datFirstDayOfAfter.year(), datFirstDayOfAfter.month());
        datLastDayOfAfter = Date.newInstance(datFirstDayOfAfter.year(), datFirstDayOfAfter.month(), intNumberOfDaysAfter);        

        // Mes Futuro 2
        datFirstDayOfAfter2 = Date.newInstance(dNow.year(), dNow.month(), 1);
        datFirstDayOfAfter2 = datFirstDayOfAfter.addMonths(1);
        intNumberOfDaysAfter = Date.daysInMonth(datFirstDayOfAfter2.year(), datFirstDayOfAfter2.month());
        datLastDayOfAfter2 = Date.newInstance(datFirstDayOfAfter2.year(), datFirstDayOfAfter2.month(), intNumberOfDaysAfter);        

    }
    
    public class PrevisionesWrapper
    {
        public String strLabelCol {get; set;} 
        public Decimal decCol1 {get; set;}
        public Decimal decCol2 {get; set;}
        public Decimal decCol3 {get;set;}
        public String strTipoInforme {get;set;}

        PrevisionesWrapper(String strP1, Decimal decP2, Decimal decP3, Decimal decP4,String strTipo)
        {
            strLabelCol = strP1;
            decCol1 = (decP2 == null ? 0 : decP2);
            decCol2 = (decP3 == null ? 0 : decP3);
            decCol3 = (decP4 == null ? 0 : decP4);
            strTipoInforme=strTipo;
        }

        public void addValues(Decimal decP2, Decimal decP3, Decimal decP4)
        {
            decCol1 = decCol1 + (decP2 == null ? 0 : decP2);
            decCol2 = decCol2 + (decP3 == null ? 0 : decP3);
            decCol3 = decCol3 + (decP4 == null ? 0 : decP4);
        }

    }
    public void getInforme()
    {
        System.debug('... entro');
        String strIdReporte=getLinkReport();
        system.debug(ApexPages.CurrentPage().getParameters());
        //strTipoInforme=ApexPages.CurrentPage().getParameters().get('param1');
        PageReference objPageReference=new PageReference('/'+strIdReporte);
        if(strTipoInforme.equalsIgnoreCase('MesesAnteriores'))
        {
            objPageReference.getParameters().put('pv0','LAST_N_MONTHS:'+intMeses*-1);
            objPageReference.getParameters().put('pv2','THIS_MONTH');
        }
        if(strTipoInforme.equalsIgnoreCase('EsteMes'))
        {
            objPageReference.getParameters().put('pv0','THIS_MONTH');
            objPageReference.getParameters().put('pv2','NEXT_MONTH');
        }
        if(strTipoInforme.equalsIgnoreCase('SiguienteMes'))
        {
            objPageReference.getParameters().put('pv0','NEXT_MONTH');
            objPageReference.getParameters().put('pv2','NEXT_N_MONTHS:2');
        }
        if(strTipoInforme.equalsIgnoreCase('2Meses'))
        {
            objPageReference.getParameters().put('pv0','NEXT_N_MONTHS:2');
            objPageReference.getParameters().put('pv2','NEXT_N_MONTHS:3');
        }
        strURL=objPageReference.getURL();
        system.debug(strURL);
        //objPageReference.setRedirect(true);
        
        //return objPageReference;
    }
    public PrevisionesWrapper[] getDataChart() 
    {
        map<String,String> mapMes = new map<String,String>{
                                                                'Enero'     => 'Ene',  
                                                                'Febrero'   => 'Feb',
                                                                'Marzo'     => 'Mar',
                                                                'Abril'     => 'Abr',
                                                                'Mayo'      => 'May',
                                                                'Junio'     => 'Jun',
                                                                'Julio'     => 'Jul',
                                                                'Agosto'    => 'Ago',
                                                                'Septiembre'=> 'Sep',
                                                                'Octubre'   => 'Oct',
                                                                'Noviembre' => 'Nov',
                                                                'Diciembre' => 'Dic'
                                                            };
        PrevisionesWrapper[] lstPrevisionesWrapper = new PrevisionesWrapper[] {};

        Map<String,PrevisionesWrapper> mapPrevisionesWrapper = new Map<String,PrevisionesWrapper>();

        mapPrevisionesWrapper.put(strLabelMonthsBefore, new PrevisionesWrapper(strLabelMonthsBefore, 
        0, 
        0,
        0,'MesesAnteriores' ));
       
        for (AggregateResult ar : [SELECT Anio__c y, Mes__c m,
         SUM(R9__c) c1 ,SUM(PrevisionR9__c) c2 ,SUM(GanadaR9__c) c3 FROM Presupuesto__c 
        WHERE FechaRealPresupuesto__c >=: datFirstDayBefore AND FechaRealPresupuesto__c <: datFirstDayOfMonth
        group by Anio__c, Mes__c
        order by Anio__c, Mes__c
        ])
        {       
            Decimal Previosiones = ar.get('c2') != null ? (Decimal) ar.get('c2') : 0;
            Decimal Ganadas = ar.get('c3') != null ? (Decimal) ar.get('c3') : 0;
            Decimal R9 = Previosiones - Ganadas;
            mapPrevisionesWrapper.get(strLabelMonthsBefore).addValues(
                0, //(Decimal) ar.get('c1'), 
                R9,
                0 //(Decimal) ar.get('c3') 
                );
        }


        for (AggregateResult ar : [SELECT Anio__c y, Mes__c m,
         SUM(R9__c) c1 ,SUM(PrevisionR9__c) c2 ,SUM(GanadaR9__c) c3 FROM Presupuesto__c 
        WHERE FechaRealPresupuesto__c >=: datFirstDayOfMonth AND FechaRealPresupuesto__c <=: datLastDayOfMonth
        group by Anio__c, Mes__c
        order by Anio__c, Mes__c
        ])
        {            
            String sM = mapMes.get((String) ar.get('m'));
            String sY = (String) ar.get('y');
            if(!mapPrevisionesWrapper.containsKey(sM + ' ' + sY))
            {
                mapPrevisionesWrapper.put(sM + ' ' + sY, new PrevisionesWrapper(sM + ' ' + sY, 
                    (Decimal) ar.get('c1'), 
                    (Decimal) ar.get('c2'),
                    (Decimal) ar.get('c3'),'EsteMes' ));
            }            
        }

        for (AggregateResult ar : [SELECT Anio__c y, Mes__c m,
         SUM(R9__c) c1 ,SUM(PrevisionR9__c) c2 ,SUM(GanadaR9__c) c3 FROM Presupuesto__c 
        WHERE FechaRealPresupuesto__c >=: datFirstDayOfAfter AND FechaRealPresupuesto__c <=: datLastDayOfAfter
        group by Anio__c, Mes__c
        order by Anio__c, Mes__c
        ])
        {            
            String sM = mapMes.get((String) ar.get('m'));
            String sY = (String) ar.get('y');
            if(!mapPrevisionesWrapper.containsKey(sM + ' ' + sY))
            {
                mapPrevisionesWrapper.put(sM + ' ' + sY, new PrevisionesWrapper(sM + ' ' + sY, 
                    (Decimal) ar.get('c1'), 
                    (Decimal) ar.get('c2'),
                    (Decimal) ar.get('c3'),'SiguienteMes' ));
            }            
        }


        for (AggregateResult ar : [SELECT Anio__c y, Mes__c m,
         SUM(R9__c) c1 ,SUM(PrevisionR9__c) c2 ,SUM(GanadaR9__c) c3 FROM Presupuesto__c 
        WHERE FechaRealPresupuesto__c >=: datFirstDayOfAfter2 AND FechaRealPresupuesto__c <=: datLastDayOfAfter2
        group by Anio__c, Mes__c
        order by Anio__c, Mes__c
        ])
        {            
            String sM = mapMes.get((String) ar.get('m'));
            String sY = (String) ar.get('y');
            if(!mapPrevisionesWrapper.containsKey(sM + ' ' + sY))
            {
                mapPrevisionesWrapper.put(sM + ' ' + sY, new PrevisionesWrapper(sM + ' ' + sY, 
                    (Decimal) ar.get('c1'), 
                    (Decimal) ar.get('c2'),
                    (Decimal) ar.get('c3'),'2Meses' ));
            }            
        }


        for(String strCloseDate : mapPrevisionesWrapper.keySet())
        {
            lstPrevisionesWrapper.add(mapPrevisionesWrapper.get(strCloseDate));
        }


        return lstPrevisionesWrapper;
    }

    public String getLinkReport()
    {
        try
        {
            Report oReport = [SELECT Id FROM Report WHERE DeveloperName = 'Previsiones_mes_actual' LIMIT 1] ;
            return oReport.Id;
        }
        catch (Exception e)
        {
            return '';
        }
    }

}