/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Usiel P. Huerta
Proyecto:                Telcel
Descripción:             Clase de TEST encargada del informe de previsiones
Requerimiento:           

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  -----------------               ---------------
1.0     12-04-2016  USIEL P. HUERTA                 Creación de la clase.
*******************************************************************************/
@isTest (SeeAllData = true)
public class TOP_Previsiones_tst
{
	@IsTest static void myUnitTest() {
		test.startTest();
		TOP_Previsiones_ctr objController = new TOP_Previsiones_ctr();
		objController.getLinkReport();
		objController.getPresupuesto();
		objController.roleLevel();
		for (Integer i = 1; i < 13; i++){
			objController.dayName(i);
		}
		
		TOP_Previsiones_ctr.PresupuestoWrapper obj = new TOP_Previsiones_ctr.PresupuestoWrapper('Test', 1.0, 1.0, 1.0, 'T');
		test.stopTest();
	}
}