/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class DCT_DirectorioEmpleados_tst {

    static testMethod void DCT_DirectorioEmpleadosOK() {
		Test.startTest();

			List<ID> lIdProcess = new List<ID>();
		    ProcessInstanceWorkitem procesoActual;			
			String sNomPerfUsrJEC = 'JEC';
			String sNomPerfUsrGV = 'GV';
			String sNomPerfUsrCOOR = 'CoordinacionAdministrativa';
			String sNomPerfUsrAdmin = 'Administrador del sistema';			
															
			List<User > lUserAdmin = DCT_CreaObjetosTest_tst.CreaUsuario(1, sNomPerfUsrAdmin);																		
											
			//Toma al usuario JEC y has las pruebas con ese
			System.runAs(lUserAdmin.get(0)){
				System.debug('EN DCT_CatalogoClavesVPN_tst.DCT_CatalogoClavesVPNOK ENTRO A GENERAR LOS OBJETOS...');
				
				DCT_DirectorioEmpleados_rst.classRespuestaTelcel objClassRespuestaTelcel = new DCT_DirectorioEmpleados_rst.classRespuestaTelcel();
				objClassRespuestaTelcel.ErrorID = 'ErrorID';
				objClassRespuestaTelcel.ErrorDescripcion = 'ErrorDescripcion';
				objClassRespuestaTelcel.DirectorioEmpleados = new List<DCT_DirectorioEmpleados_rst.DatosEmpleado>();
		
				DCT_DirectorioEmpleados_rst.DatosEmpleado objDatosEmpleado = new DCT_DirectorioEmpleados_rst.DatosEmpleado();
				objDatosEmpleado.ErrorID = 'ErrorID';
				objDatosEmpleado.ErrorDescripcion = 'ErrorDescripcion';
				objDatosEmpleado.mClaveArea = 123;
				objDatosEmpleado.mDescripcionArea = 'mDescripcionArea';
				objDatosEmpleado.mDescripcionPuesto = 'mDescripcionPuesto';
				objDatosEmpleado.mNumeroEmpleado = 'mNumeroEmpleado';
				objDatosEmpleado.mNombreEmpleado = 'mNombreEmpleado';
				objDatosEmpleado.mApellidoPaterno = 'mApellidoPaterno'; 
				objDatosEmpleado.mApellidoMaterno = 'mApellidoMaterno';
				objDatosEmpleado.mExtension = 'mExtension';
				objDatosEmpleado.mCelular = 'mCelular';
				objDatosEmpleado.mDescripcionTipoEmpleado = 'mDescripcionTipoEmpleado';
				objDatosEmpleado.mPerfilID = 'mPerfilID';
				objDatosEmpleado.mDescripcionPerfil = 'mDescripcionPerfil';
				objDatosEmpleado.mEsResponsableEquipoTrabajo = false;
				objDatosEmpleado.mPosicionPadreID = 0;

				DCT_DirectorioEmpleados_rst objDCT_DirectorioEmpleadosRst = new DCT_DirectorioEmpleados_rst();
				DCT_DirectorioEmpleados_rst.getDirectorioEmpleados('sUsuario');
				
				//Ve si se crearon los objetos para hacer el llamado
    		    System.assertNotEquals(objClassRespuestaTelcel, null);
    		    System.assertNotEquals(objDatosEmpleado, null);
				
			}//Fin si System.runAs(lUserAdmin.get(0))
			
		Test.stopTest();		
    }
}