@isTest
public class DCT_CreaObjetosTest_tst {

	public static DateTime dFechaPruebaPrueba = DateTime.now();
	public static String sNamePrueba = 'UserPrueba' + dFechaPruebaPrueba;
	public static String sLastNamePrueba = 'ApellidoPrueba' + dFechaPruebaPrueba.millisecondGmt();
	
    //Genera los objetos para User 
    public static List<User > CreaUsuario(Integer noUser, String sNomPerf){
    	System.debug('EN DCT_CreaObjetosTest_tst.CreaUsuario CreaUsuario: ' + noUser + ' sNomPerf: ' + sNomPerf);
    	
        //La lista para los User 
        List<User > lUser = new List<User>();
        
        //Busca al un usuario con el perfil seleccionado
		for (User usrDatos : [Select u.UserRole.Name, u.UserRoleId, u.Profile.Name, u.ProfileId, ManagerId 
			From User u where Profile.Name =: sNomPerf And ManagerId != null And isActive = true Limit 1]){
			lUser.add(usrDatos);
		}
                        
    	System.debug('EN DCT_CreaObjetosTest_tst.CreaUsuario lUser: ' + lUser);                        
        //Regresa la lista de Tarea
        return lUser;
    }
      	    
    //Genera los objetos para Account 
    public static List<Account> CreaClienteC(Integer noCliente, String strRT, String sIdUsrOwner){      

        //La lista para los Cliente 
        List<Account> lCliente = new List<Account>();
                
        //Crea los Account 
        for (Integer cnt=0; cnt < noCliente; cnt++){
        	
            String sClaveDistPaso = String.valueOf(Math.random());
            String sClaveDist = sClaveDistPaso.substring(10);
            String sNumeroCte = sClaveDistPaso.substring(10);

            Account Cliente = new Account();
            Cliente.AccountNumber = sNumeroCte;
            Cliente.RecordTypeId = strRT;
			Cliente.Name = sNamePrueba + ' ' + sLastNamePrueba;
			Cliente.DTC_LegalEntity__c = 'Física';
			Cliente.RFC__c = 'ABCD123456EFI';
			Cliente.DCTLastName__c = 'Pruebas';
			Cliente.DCTMotherLastName__c = 'Ejemplo';
			Cliente.DCTName__c = 'Test';
			Cliente.Segmento__c = 'Corporativo';
			Cliente.DCT_TypeOfProcedure__c = 'Lineas Nuevas';
			Cliente.Sector__c = 'Financiero';
			Cliente.Subsector__c = 'Afores';
			Cliente.OwnerId = sIdUsrOwner;
			Cliente.DCTDateLastassignment__c = Date.today();
			Cliente.DCTFolio__c = sNumeroCte;
			
            //Insertalo en Cliente
            lCliente.add(Cliente);
        }
        
        //Inserta los registros 
        insert lCliente;

        //Regresa la lista de lCliente  
        return lCliente;            
        
    }

    //Genera los objetos para Contact 
    public static List<Contact > CreaContacto(Integer noContacto, String sIdAccount){

		String sClaveDistPaso = String.valueOf(Math.random());
		String sClaveDist = sClaveDistPaso.substring(10);
		String sNumeroFactura = sClaveDistPaso.substring(10);
    	
        //La lista para los Contact 
        List<Contact > lContacto = new List<Contact>();
                
        //Crea los Contact 
        for (Integer cnt=0; cnt < noContacto; cnt++){
            Contact Contacto = new Contact();              
            Contacto.PCT_IdExterno__c = sNumeroFactura;            
	    	Contacto.FirstName = sNamePrueba;
	    	Contacto.LastName = sLastNamePrueba;
            Contacto.AccountId = sIdAccount;                      
            Contacto.Posicion__c = 'GERENTE';
            Contacto.Phone = '1234567890';
            Contacto.Nivel__c = 'CONTACTO 1';
            Contacto.MobilePhone = '1234567890';
            Contacto.Email = 'prueba' + sClaveDist + '@hotmail.com';            
            Contacto.DCT_ContactoDirectorio__c = true;
            Contacto.DCTTypeContact__c = 'PRINCIPAL';            
            Contacto.DCTReceiveInformation__c = false;            
            Contacto.DCTNIP__c = sNumeroFactura;            
            Contacto.DCTExtension__c = '12345';
 
            //Insertalo en lContacto
            lContacto.add(Contacto);
        }//Fin del for para los noContacto
        
        //Inserta los registros 
        upsert lContacto PCT_IdExterno__c;
        
        //Regresa la lista de Contacto
        return lContacto;
    }

    //Genera los objetos para Cliente__c 
    public static List<Cliente__c> CreaDirCom(Integer noDirCom, String sIdUsrOwner, Account PCT){
    	
        //La lista para los Cliente__c 
        List<Cliente__c> lDirCom = new List<Cliente__c>();
                
        //Crea los Cliente__c 
        for (Integer cnt=0; cnt < noDirCom; cnt++){
            Cliente__c DirCom = new Cliente__c();
            
			DirCom.Name = sNamePrueba;
			DirCom.OwnerId = sIdUsrOwner;
			//Se agrega el RFc a la creacion de directorio comercial
			DirCom.RFC1__c = PCT.RFC__c;
			DirCom.OwnerId = PCT.OwnerId;
			DirCom.DCTFolio__c = PCT.DCTFolio__c;
            DirCom.DCTCustomerFrom__c = Date.today().addDays(-50);
            						                        
            //Insertalo en lDirCom
            lDirCom.add(DirCom);
        }//Fin del for para los noDirCom
        
        //Inserta los registros 
        insert lDirCom;
        
        //Regresa la lista de DirCom
        return lDirCom;
    }

    //Genera los objetos para DCTAssignment__c 
    public static List<DCTAssignment__c> CreaAssignment(Integer noAssignment){
    	
        //La lista para los DCTAssignment__c 
        List<DCTAssignment__c> lAssignment = new List<DCTAssignment__c>();
                
        //Crea los DCTAssignment__c 
        for (Integer cnt=0; cnt < noAssignment; cnt++){
            DCTAssignment__c Assignment = new DCTAssignment__c();
            
			Assignment.Status__c = 'Pendiente';							
			Assignment.TypeAssignment__c = 'Gerencia';
			Assignment.PreviousManagement__c = UserInfo.getUserId();
			Assignment.Aprobador__c = UserInfo.getUserId();
			Assignment.Segment__c = 'Corporativo';
            
            //Insertalo en lAssignment
            lAssignment.add(Assignment);
        }//Fin del for para los noAssignment
        
        //Inserta los registros 
        insert lAssignment;
        
        //Regresa la lista de Assignment
        return lAssignment;
    }

    //Genera los objetos para Case 
    public static List<Case> CreaOppVta(Integer noOppVta, String iIdCte){
        //La lista para los Case 
        List<Case> lOppVta = new List<Case>();
                
        //Crea los Case 
        for (Integer cnt=0; cnt < noOppVta; cnt++){
            Case OppVta = new Case();
            
            OppVta.Status = 'New';
            OppVta.Origin = 'Phone'; 
            OppVta.Priority = 'Medium';
            OppVta.AccountId = iIdCte != null ? iIdCte : null;
            
            //Insertalo en lOppVta
            lOppVta.add(OppVta);
        }//Fin del for para los noOppVta
        
        //Inserta los registros 
        insert lOppVta;
        
        //Regresa la lista de OppVta
        return lOppVta;
    }

    //Genera los objetos para Task 
    public static List<Task > CreaTarea(Integer noTarea, String sIdCaso, String sSubject){
        //La lista para los Task 
        List<Task > lTarea = new List<Task>();
                
        //Crea los Task 
        for (Integer cnt=0; cnt < noTarea; cnt++){
            Task Tarea = new Task();            
            Tarea.Description = 'Call';
            Tarea.Priority = 'Normal';
            Tarea.Status = 'No Iniciado';
            Tarea.Subject = sSubject;
            Tarea.IsReminderSet = false;
            Tarea.WhatId = sIdCaso;  
              
            //Insertalo en lTarea
            lTarea.add(Tarea);
        }//Fin del for para los noTarea
        
        //Inserta los registros 
        insert lTarea;
        
        //Regresa la lista de Tarea
        return lTarea;
    }

    //Genera los objetos para DCTAuthorizedLines__c 
    public static List<DCTAuthorizedLines__c > CreaDCTAuthorizedLines(Integer noDCTAuthorizedLines, 
    	String sIdDirCom, String sRecordType, String sTermino, String sAprobador){

		String sClaveDistPaso = String.valueOf(Math.random());
		String sClaveDist = sClaveDistPaso.substring(10);
		String sNumeroFactura = sClaveDistPaso.substring(10);
    		
        //La lista para los DCTAuthorizedLines__c 
        List<DCTAuthorizedLines__c > lDCTAuthorizedLines = new List<DCTAuthorizedLines__c>();
                
        //Crea los DCTAuthorizedLines__c 
        for (Integer cnt=0; cnt < noDCTAuthorizedLines; cnt++){
            DCTAuthorizedLines__c DCTAuthorizedLines = new DCTAuthorizedLines__c();            

			DCTAuthorizedLines.Name = sNamePrueba;
			DCTAuthorizedLines.Clave__c = sClaveDist;            
	 		DCTAuthorizedLines.CommercialDirectory__c = sIdDirCom;
	 		DCTAuthorizedLines.RecordTypeId = sRecordType;
			DCTAuthorizedLines.DCTTerm__c = sTermino;
			DCTAuthorizedLines.Aprobador__c = sAprobador;
			DCTAuthorizedLines.Status__c = 'AUTORIZADO';
              
            //Insertalo en lDCTAuthorizedLines
            lDCTAuthorizedLines.add(DCTAuthorizedLines);
            
        }//Fin del for para los noDCTAuthorizedLines
        
        //Inserta los registros 
        insert lDCTAuthorizedLines;
        
        //Regresa la lista de DCTAuthorizedLines
        return lDCTAuthorizedLines;
    }

    public static List<DCTPlan__c > CreaPlanes(Integer noPlanes){
    		
        //La lista para los DCTPlan__c 
        List<DCTPlan__c > lPlanes = new List<DCTPlan__c>();
                
        //Crea los DCTPlan__c 
        for (Integer cnt=0; cnt < noPlanes; cnt++){
            DCTPlan__c Planes = new DCTPlan__c();            

			Planes.Name = sNamePrueba;			            
	        Planes.DCTCode__c = '12'; //Ve si contiene un - y entonces quita los meses nada mas
	        Planes.DCTTerm__c = '12 MESES';
	        Planes.TipoMercado__c = 'CORPORAT';
			Planes.ClaveMercado__c = '2';
	        Planes.ClaveGrupoPlan__c = '123';
	        Planes.DescripcionGrupoPlan__c = 'GRUPO PLAN';
	        Planes.ClavePlazo__c = '12';
	        Planes.DescripcionPlazo__c = '12 MESES';
	        Planes.ClavePlan__c = '123';
	        Planes.DescripcionPlan__c = 'PLAN';
	        Planes.ClaveTarifa__c = 'AAA'; 
              
            //Insertalo en lPlanes
            lPlanes.add(Planes);
            
        }//Fin del for para los noPlanes
        
        //Inserta los registros 
        insert lPlanes;
        
        //Regresa la lista de Planes
        return lPlanes;
    }

    //Genera los objetos para Product2 
    public static List<Product2> CreaProducto(Integer noProducto, String sRt){
    	
        //La lista para los Product2 
        List<Product2> lProducto = new List<Product2>();
                
        //Crea los Product2 
        for (Integer cnt=0; cnt < noProducto; cnt++){

			String sClaveDistPaso = String.valueOf(Math.random());
			String sClaveDist = sClaveDistPaso.substring(10);
        	
            Product2 Producto = new Product2();
            
            Producto.Name = sNamePrueba;
            Producto.RecordTypeId = sRt; 
            Producto.Family = 'Family';
            Producto.Description = 'Family';
            Producto.DCT_IsSpecialProduct__c = false;
            Producto.DCTKey__c = sClaveDist;
            Producto.IsActive = true;
            
            //Insertalo en lProducto
            lProducto.add(Producto);
        }//Fin del for para los noProducto
        
        //Inserta los registros 
        insert lProducto;
        
        //Regresa la lista de Producto
        return lProducto;
    }    

    //Genera los objetos para DCTDirectoryProductRelationship__c 
    public static List<DCTDirectoryProductRelationship__c> CreaDCTDirectoryProductRel(Integer noDCTDirectoryProductRel, 
    	String sIdProd, String sIdDirCom){

		String sClaveDistPaso = String.valueOf(Math.random());
		String sClaveDist = sClaveDistPaso.substring(10);
		String sNumeroFactura = sClaveDistPaso.substring(10);
    	
        //La lista para los DCTDirectoryProductRelationship__c 
        List<DCTDirectoryProductRelationship__c> lDCTDirectoryProductRel = new List<DCTDirectoryProductRelationship__c>();
                
        //Crea los DCTDirectoryProductRelationship__c 
        for (Integer cnt=0; cnt < noDCTDirectoryProductRel; cnt++){
            DCTDirectoryProductRelationship__c DCTDirectoryProductRel = new DCTDirectoryProductRelationship__c();
            
            DCTDirectoryProductRel.DCTProduct__c = sIdProd; 
            DCTDirectoryProductRel.DCTCommercialDirectory__c = sIdDirCom;
            
            //Insertalo en lDCTDirectoryProductRel
            lDCTDirectoryProductRel.add(DCTDirectoryProductRel);
        }//Fin del for para los noDCTDirectoryProductRel
        
        //Inserta los registros 
        insert lDCTDirectoryProductRel;
        
        //Regresa la lista de DCTDirectoryProductRel
        return lDCTDirectoryProductRel;
    }

    //Genera los objetos para DirectorioProducosSeleccionados__c 
    public static List<DirectorioProducosSeleccionados__c> CreaDirectorioProducosSel(Integer noDirectorioProducosSel, 
    	String sIdProd, String sIdDirCom){
    	
        //La lista para los DirectorioProducosSeleccionados__c 
        List<DirectorioProducosSeleccionados__c> lDirectorioProducosSel = new List<DirectorioProducosSeleccionados__c>();
                
        //Crea los DirectorioProducosSeleccionados__c 
        for (Integer cnt=0; cnt < noDirectorioProducosSel; cnt++){
            DirectorioProducosSeleccionados__c DirectorioProducosSel = new DirectorioProducosSeleccionados__c();
            
            DirectorioProducosSel.Name = sNamePrueba;            
            DirectorioProducosSel.Producto__c = sIdProd; 
            DirectorioProducosSel.Prospecto__c = sIdDirCom;
            
            //Insertalo en lDirectorioProducosSel
            lDirectorioProducosSel.add(DirectorioProducosSel);
        }//Fin del for para los noDirectorioProducosSel
        
        //Inserta los registros 
        insert lDirectorioProducosSel;
        
        //Regresa la lista de DirectorioProducosSel
        return lDirectorioProducosSel;
    }

    //Genera los objetos para DCTSalesForceCatalog__c 
    public static List<DCTSalesForceCatalog__c> CreaDCTSalesForceCatalog(Integer noDCTSalesForceCatalog, 
    	String sNombre, String sClave, String sPrepId){
    	
        //La lista para los DCTSalesForceCatalog__c 
        List<DCTSalesForceCatalog__c> lDCTSalesForceCatalog = new List<DCTSalesForceCatalog__c>();
                
        //Crea los DCTSalesForceCatalog__c 
        for (Integer cnt=0; cnt < noDCTSalesForceCatalog; cnt++){
            DCTSalesForceCatalog__c DCTSalesForceCatalog = new DCTSalesForceCatalog__c();
            
            DCTSalesForceCatalog.Name = sClave;
            DCTSalesForceCatalog.DCT_RazonSocial__c = sNombre; 
            DCTSalesForceCatalog.DCT_PrepagoSiapID__c = sPrepId + '' + cnt;
            DCTSalesForceCatalog.DCT_EstatusID__c = '1';
            DCTSalesForceCatalog.DCTCode__c = sClave + '' + cnt;
            
            //Insertalo en lDCTSalesForceCatalog
            lDCTSalesForceCatalog.add(DCTSalesForceCatalog);
        }//Fin del for para los noDCTSalesForceCatalog
        
        //Inserta los registros 
        insert lDCTSalesForceCatalog;
        
        //Regresa la lista de DCTSalesForceCatalog
        return lDCTSalesForceCatalog;
    }    

}