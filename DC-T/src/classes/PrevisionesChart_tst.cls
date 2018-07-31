/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Mario Chaves
Proyecto:                Telcel
Descripción:             Clase de TEST encargada de la grafica del previsiones
Requerimiento:           

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     08-02-2016  Mario Chaves               Creación de la clase.
*******************************************************************************/
@isTest
public class PrevisionesChart_tst
{
	@isTest 
	public static void test_generarInforme_caso1() 
    {
    	test.startTest();
    	MesesPrevision__c objMeses=new MesesPrevision__c();
    	objMeses.name='6';
    	database.insert(objMeses);
    	List<Presupuesto__c> lstPresupuesto=new List<Presupuesto__c>();
    	for(Integer intCont=-1;intCont<4;intCont++)
    	{
	    	Presupuesto__c objPresupuesto=new Presupuesto__c();
	    	dateTime objDate=System.now().addMonths(intCont);
	    	objPresupuesto.mes__c=String.valueOf(objDate.month());
	    	objPresupuesto.anio__c=String.valueOf(objDate.year());
	    	objPresupuesto.R9__c=1;
	    	objPresupuesto.PrevisionR9__c=1;
	    	objPresupuesto.GanadaR9__c=1;
	    	lstPresupuesto.add(objPresupuesto);
	    }	

    	database.insert(lstPresupuesto);
    	PrevisionesChart_ctr objPrevisionesctr=new PrevisionesChart_ctr();
		objPrevisionesctr.strTipoInforme='MesesAnteriores';
    	objPrevisionesctr.getInforme();
    	objPrevisionesctr.strTipoInforme='EsteMes';
    	objPrevisionesctr.getInforme();
    	objPrevisionesctr.strTipoInforme='SiguienteMes';
    	objPrevisionesctr.getInforme();
    	objPrevisionesctr.strTipoInforme='2Meses';
    	objPrevisionesctr.getInforme();
    	PrevisionesChart_ctr.PrevisionesWrapper[] getDataChart=objPrevisionesctr.getDataChart();

		test.stopTest();

    }	
}