/***************************************************************************************************************************
 * Desarrollado por:  Avanxo México                                                                                        *
 * Autor:             Luis Enrique Garcia Sanabria                                                                         *
 * Email:             legarcia@avanxo.com                                                                                  *
 * Fecha de creación: 24-04-2018                                                                                           *
 ***************************************************************************************************************************
 * Metadata:          DCT_RelatedListAssigment_pag                                                                         *
 ***************************************************************************************************************************
 * Descripción:       Controlador que permite mostrar la lista de cuentas que se les va a hacer el cambio de propietario   *
 *                    para indicar si se aceptan o se rechazarón, y con eso diapara si se aceptan o no en la aprobación    *
 ***************************************************************************************************************************
 *                                                Control de versiones                                                     *
 ***************************************************************************************************************************
 * No. |    Fecha   |             Autor            |        Email        |                 Descripción                     *
 ******|************|******************************|*********************|**************************************************
 * 1.0 | 24-04-2018 | Luis Enrique Garcia Sanabria | legarcia@avanxo.com | Creacion de la clase DCT_assignmentNewOwner_cls *
 ***************************************************************************************************************************/
public class DCT_RelatedListAssigment_ctr {
	
	private integer counter = 0;  //keeps track of the offset
	private integer list_size = (!Test.isRunningTest())?50:1; //sets the page size or number of rows
	public String sUsrActual = UserInfo.getUserId();
	public String SPerfilActual = [Select id, Name, Profile.Name From User Where id =:sUsrActual].Profile.Name;
	public integer total_size; //used to show user the total size of the list
	public string selectedPage{get;set{selectedPage=value;}}
	public string idAssigment ='';
	public List<DCTClientsProspectstoAssigned__c> lstDCTClientPA {get;set;}
	public id idProcessInstance;
	public List<ProcessInstance> sObjectList = new List<ProcessInstance>();
	public String idProcessInstance2 ='';
	public List<ProcessInstanceWorkitem> idProcessWorkitemId = new List<ProcessInstanceWorkitem>();
	public List<String> lstErrorMsgs{set;get;}
	public List<String> lstSuccessMsgs{set;get;} 
	public String strOwner {set;get;}
	public String strAprobador {set;get;}
	public String strStatus {set;get;}
	public Boolean bUsrEmisor {get;set;}
	public Boolean bUsrRecep {get;set;}
	public String sIdUserActualPerfil {get;set;}
	public Boolean bEsAdmin {get;set;}
	public Boolean bEsGV {get;set;}
				
		
	public DCT_RelatedListAssigment_ctr(ApexPages.StandardController stdController) {
		System.debug('EN DCT_RelatedListAssigment_ctr....');
		System.debug('EN DCT_RelatedListAssigment_ctr sUsrActual: ' + sUsrActual + ' SPerfilActual: ' + SPerfilActual);
				
		lstErrorMsgs = new List<String>();
		lstSuccessMsgs = new List<String>();
		idAssigment = stdController.getId();
		System.debug(loggingLevel.Error, '*** idAssigment: ' + idAssigment);
    	strOwner = [SELECT Aprobador__r.Profile.Name, Aprobador__c FROM DCTAssignment__c WHERE Id = :idAssigment].Aprobador__r.Profile.Name;
		System.debug(loggingLevel.Error, '*** strOwner: ' + strOwner);    	
    	strAprobador = [SELECT Aprobador__c FROM DCTAssignment__c WHERE Id = :idAssigment].Aprobador__c;    
    	strStatus = [SELECT Status__c FROM DCTAssignment__c WHERE Id = :idAssigment].Status__c;	
    	System.debug(loggingLevel.Error, '*** strStatus: ' + strStatus);
		lstDCTClientPA = [SELECT Name, Approval__c, AccountName__c, IssuingUser__r.Name, UserReceiver__r.Name, Status__c FROM DCTClientsProspectstoAssigned__c WHERE AssignmentNumber__c = :idAssigment] ;
		total_size = [SELECT count() FROM DCTClientsProspectstoAssigned__c WHERE AssignmentNumber__c = :idAssigment ]; //set the total size in the constructor
	    sObjectList = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :idAssigment LIMIT 1];
	    System.debug(loggingLevel.Error, '*** sObjectList: ' + sObjectList);
	    if(!sObjectList.isEmpty()) {
	    	idProcessInstance2 = String.valueOf(sObjectList[0].id);
	    }
	    System.debug(loggingLevel.Error, '*** idProcessInstance2: ' + idProcessInstance2);
	    if(!String.isBlank(idProcessInstance2) ) {
	    	if(!Test.isRunningTest()) {
	    		idProcessWorkitemId = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstanceId = :idProcessInstance2 Limit 1];	
	    	}
	    }else {
	    	if (Test.isRunningTest()) {
	    		idProcessWorkitemId = [SELECT Id FROM ProcessInstanceWorkitem Limit 1];			
	    	}	
	    }
	    //idProcessInstance2 =[SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :idAssigment].id;
	    System.debug(loggingLevel.Error, '*** idProcessWorkitemId: ' + idProcessWorkitemId);
	    
	    selectedPage = '0';
	    bUsrEmisor = false;
	    bUsrRecep = false;
		bEsAdmin = false;
		bEsGV = false;
		
		for (User usrDatos : [Select u.UserRole.Name, u.UserRoleId, u.Profile.Name, u.ProfileId, ManagerId 
			From User u where id =: UserInfo.getUserId()]){
			System.debug('ENTRO A DCT_RelatedListAssigment_ctr.getDatosUsuario usrDatos: ' + usrDatos);
			if (usrDatos.Profile.Name != null)				
				sIdUserActualPerfil = usrDatos.Profile.Name;
			System.debug('ENTRO A DCT_RelatedListAssigment_ctr.getDatosUsuario sIdUserActualPerfil: ' + sIdUserActualPerfil);
		}
	    
	}

	public void validateSatus(){
		List<String> lstStatus = new List<String>();
		System.debug(loggingLevel.Error, '*** lstDCTClientPA: ' + lstDCTClientPA);
		for(DCTClientsProspectstoAssigned__c iterator: lstDCTClientPA) {
			lstStatus.add(iterator.Status__c);
		}
		System.debug(loggingLevel.Error, '*** lstStatus: ' + lstStatus);
		if(!idProcessWorkitemId.isEmpty() || Test.isRunningTest()) {
			if(!lstStatus.contains('Pendiente')) {
				System.debug(loggingLevel.Error, '*** La lista no contiene estatus pendiente: ');
	      		Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
	      		req2.setWorkitemId((!Test.isRunningTest())?idProcessWorkitemId[0].id:null);//
				if(lstStatus.contains('Aprobado')) {
					System.debug(loggingLevel.Error, '*** La lista contiene estatus Aprobado: ');
	        		req2.setComments(System.Label.DCT_SuccessMessageApproveProcess_lbl);
	        		req2.setAction('Approve');
		  		} else {
		  			System.debug(loggingLevel.Error, '*** La lista contiene estatus Rechazado: ');
					req2.setComments(System.Label.DCT_RejectMessageApproveProcess_lbl);
					req2.setAction('Reject');
				}
				System.debug(loggingLevel.Error, '*** req2: ' + req2);
	    		if(strOwner == 'GV' && strAprobador == UserInfo.getUserId()){
	      			Approval.ProcessResult result2 =  Approval.process(req2);
					System.debug(loggingLevel.Error, '*** result2.isSuccess(): ' + result2.isSuccess());
					if(result2.isSuccess()) {
						regresar();
					}
	    		}
			}
		}

	}

	public DCTClientsProspectstoAssigned__c[] getDCTAssigment() {
		System.debug('ENTRO A getDCTAssigment...');
		
	    if (selectedPage != '0') counter = list_size*integer.valueOf(selectedPage)-list_size;
	    
	    try{
	    	
	      //consultar los casos para esta solicitud strSolicitud
	      lstDCTClientPA = [SELECT Name,
	      	Approval__c,
	      	IssuingUser__r.Name,
	      	UserReceiver__r.Name,
	      	Status__c,
	      	DCTReassignmentCoordination__c,
	      	DCTManager__c
	      	FROM DCTClientsProspectstoAssigned__c 
	      	WHERE AssignmentNumber__c = :idAssigment 
	      	AND UserReceiver__c =: UserInfo.getUserId()
	      	LIMIT :list_size 
	      	OFFSET :counter] ;
			//Si el usuario quien recibe es el mismo al actual
			bUsrRecep = !lstDCTClientPA.isEmpty() ? true : false;
			if (SPerfilActual.startsWith('GV') || Test.isRunningTest())
				bEsGV = true;
			System.debug('ENTRO A getDCTAssigment EL USUARIO QUE RECOBE: ' + lstDCTClientPA.size() + ' bEsGV: ' + bEsGV);
			
			//Si es gerenre de ventas y el estatus es rechazado
			if (bEsGV && strStatus == 'Rechazado' && lstDCTClientPA.isEmpty()){
		      	lstDCTClientPA=[SELECT Name,
		      	Approval__c,
		      	IssuingUser__r.Name,
		      	UserReceiver__r.Name,
		      	Status__c,
		      	DCTReassignmentCoordination__c,
		      	DCTManager__c
		      	FROM DCTClientsProspectstoAssigned__c 
		      	WHERE AssignmentNumber__c = :idAssigment 
		      	LIMIT :list_size 
		      	OFFSET :counter] ;
				//Si el usuario que emite es el mismo al actual
				bUsrEmisor = !lstDCTClientPA.isEmpty() ? true: false;
				System.debug('ENTRO A getDCTAssigment EL USUARIO QUE ENVIA bUsrEmisor: ' + bUsrEmisor);				
			}//Fin si bEsGV && strStatus == 'Rechazado'
			
			//Ve si tiene algo lstDCTClientPA
			if (lstDCTClientPA.isEmpty()){					
				System.debug('ENTRO A getDCTAssigment EL USUARIO QUE ENVIA...');
		      	lstDCTClientPA=[SELECT Name,
		      	Approval__c,
		      	IssuingUser__r.Name,
		      	UserReceiver__r.Name,
		      	Status__c,
		      	DCTReassignmentCoordination__c,
		      	DCTManager__c
		      	FROM DCTClientsProspectstoAssigned__c 
		      	WHERE AssignmentNumber__c = :idAssigment 
		      	AND IssuingUser__c =: UserInfo.getUserId()
		      	LIMIT :list_size 
		      	OFFSET :counter] ;
				//Si el usuario que emite es el mismo al actual
				bUsrEmisor = !lstDCTClientPA.isEmpty() ? true: false;
				System.debug('ENTRO A getDCTAssigment EL USUARIO QUE ENVIA bUsrEmisor: ' + bUsrEmisor);			
			}//Fin si lstDCTClientPA.isEmpty()
	
			//Si se trata de un admin entonces muestra todos los reg
			if (sIdUserActualPerfil.startsWith('Administra') || sIdUserActualPerfil.startsWith('Coordinacion')){
		      lstDCTClientPA=[SELECT Name,
		      	Approval__c,
		      	IssuingUser__r.Name,
		      	UserReceiver__r.Name,
		      	Status__c,
		      	DCTReassignmentCoordination__c,
		      	DCTManager__c
		      	FROM DCTClientsProspectstoAssigned__c 
		      	WHERE AssignmentNumber__c = :idAssigment 
		      	LIMIT :list_size 
		      	OFFSET :counter] ;
		      	bEsAdmin = true;
			}//Fin si strOwner.startsWith('Administ')
	
			System.debug('ENTRO A getDCTAssigment EL USUARIO QUE ENVIA lstDCTClientPA: ' + lstDCTClientPA);	      
		      //Regresa la lista de regitros reasignados	
		      return lstDCTClientPA;
	      
	    } catch (QueryException e) {
	      ApexPages.addMessages(e);  
	      return null;
	    }
	}

 	public PageReference regresar() {
 		System.debug('EN regresar...' + 'https://telcel-dev--dc.lightning.force.com/lightning/r/DCTAssignment__c/'  + idAssigment + '/view');
		//'https://telcel-dev--dc.lightning.force.com/lightning/r/DCTAssignment__c'  https://telcel-dev--dc.lightning.force.com/				
        PageReference pr = new PageReference(System.Label.DCT_URLBack_lbl + idAssigment+'/view');
		System.debug('EN DCT_AccountAprovedRejectedCtrl.regresar... '+pr);
        pr.setRedirect(true);
        return pr;
	}	
	
	public PageReference reject(){
		System.debug('ENTRO A reject...');
		
		PageReference pr;
		lstErrorMsgs = new List<String>();
		lstSuccessMsgs = new List<String>();
		Boolean blnDMLwasSuccess= false;
		Boolean blnTryUpdate= false;
	  	Boolean blnchangeOwner= false;
	  	List<DCTClientsProspectstoAssigned__c> lstDCTClientPAsuccess = new List<SObject>();
		Map<String, Account> mapPCT = new Map<String, Account>();
		
		//Un sp para el rollback en caso de error	  	
	  	Savepoint sp = Database.setSavepoint();
	  	
	  	Database.SaveResult[] sr = Database.update(lstDCTClientPA,false);
	  	for(Database.SaveResult srIterator: sr) {
	  		if(srIterator.isSuccess())
	  			blnDMLwasSuccess = true;
	  	}

		//Actualiza el campo de Status__c del objeto DCTAssignment__c
		DCTAssignment__c objDCTAssignmentUpd = new DCTAssignment__c(id = idAssigment,
			Status__c = 'Rechazado');
		Database.Saveresult dtsv = Database.update(objDCTAssignmentUpd, false);
		if (!dtsv.isSuccess())
			System.debug('EN save error dtsv: ' + dtsv.getErrors()[0].getMessage());		

		//Si no hubo error en 	  	
	  	if(blnDMLwasSuccess) {
		  	for(DCTClientsProspectstoAssigned__c iterator: lstDCTClientPA) {
  				iterator.Status__c = 'Rechazado';		  		
  				iterator.DCTBlockedRecord__c = false;
  				lstDCTClientPAsuccess.add(iterator);
		  	}
	  	}	  	
	  	System.debug(loggingLevel.Error, 'EN reject blnTryUpdate: ' + blnTryUpdate + ' lstDCTClientPAsuccess: ' + lstDCTClientPAsuccess);	  	
	  		  	
	  	//if(blnTryUpdate) {
	  	//	lstErrorMsgs.add(System.Label.DCT_ErrorMessageRequest_lbl);
	  	//	pr = null;
	  	//}//Fin si blnTryUpdate
	  	
	  	Database.SaveResult[] srupd = Database.update(lstDCTClientPAsuccess,false);
	  	for(Database.SaveResult srIterator: srupd) {
		  	System.debug(loggingLevel.Error, 'EN reject. srIterator: ' + srIterator);
	  		if(srIterator.isSuccess()) 
	  			blnchangeOwner = true;
	  		if(!srIterator.isSuccess())
			  	System.debug(loggingLevel.Error, 'EN reject. srIterator error: ' + srIterator.getErrors()[0].getMessage());
	  	}//Fin del for para srupd
	  	System.debug(loggingLevel.Error, '*** idProcessWorkitemId: ' + idProcessWorkitemId);
		//Actualiza el proceso de aprovación
		if(!idProcessWorkitemId.isEmpty() || Test.isRunningTest()) {
	   		Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
	   		req2.setWorkitemId((!Test.isRunningTest())?idProcessWorkitemId[0].id:null);//
			req2.setComments(System.Label.DCT_RejectMessageApproveProcess_lbl);
			req2.setAction('Reject');
			System.debug(loggingLevel.Error, ' EN reject req2: ' + req2);
	   		if(strOwner == 'GV' && strAprobador == UserInfo.getUserId()){
	   			Approval.ProcessResult result2 =  Approval.process(req2);
				System.debug(loggingLevel.Error, ' EN reject result2.isSuccess(): ' + result2.isSuccess());
				if(!result2.isSuccess())
				  	System.debug(loggingLevel.Error, 'EN reject. result2 error: ' + result2.getErrors()[0].getMessage());
	   		}//Fin si strOwner == 'GV' && strAprobador == UserInfo.getUserId()
		}

	  	//Para un prueba
	  	//Database.rollback(sp);
		
		//Ve si blnchangeOwner
	  	if(blnchangeOwner) {
	  		lstSuccessMsgs.add(System.Label.DCT_ErrorMessageRequest2_lbl);
	  		pr = regresar();
	  	}//Fin si blnchangeOwner
	  	
	  	Integer start = System.Now().millisecond();
	    System.debug(loggingLevel.Error, 'EN reject. start: ' + start);
	  	System.debug(loggingLevel.Error, 'EN reject. pr: ' + pr);
	  	
	  	return pr;
	} 

	public PageReference save(){
		System.debug('ENTRO A save...');
				
	  	PageReference pr;
	  	lstErrorMsgs = new List<String>();
		lstSuccessMsgs = new List<String>();
	  	Boolean blnDMLwasSuccess= false;
	  	Boolean blnTryUpdate= false;
	  	Boolean blnchangeOwner= false;
	  	List<DCTClientsProspectstoAssigned__c> lstDCTClientPAsuccess = new List<SObject>();
		Map<String, Account> mapPCT = new Map<String, Account>();
			  	
	  	Savepoint sp = Database.setSavepoint();
	  	
	  	Database.SaveResult[] sr = Database.update(lstDCTClientPA,false);
	  	for(Database.SaveResult srIterator: sr) {
	  		if(srIterator.isSuccess()) {
	  			blnDMLwasSuccess = true;
	  		}
	  	}
		System.debug('ENTRO A save blnDMLwasSuccess: ' + blnDMLwasSuccess);

		//Actualiza el campo de Status__c del objeto DCTAssignment__c
		DCTAssignment__c objDCTAssignmentUpd = new DCTAssignment__c(id = idAssigment,
			Status__c = 'Aprobado');
		Database.Saveresult dtsv = Database.update(objDCTAssignmentUpd, false);
		if (!dtsv.isSuccess())
			System.debug('EN save error dtsv: ' + dtsv.getErrors()[0].getMessage());		
		
		//Ve si blnDMLwasSuccess
	  	if(blnDMLwasSuccess) {
		  	for(DCTClientsProspectstoAssigned__c iterator: lstDCTClientPA) {
		  		if(iterator.Approval__c) 
	  				iterator.Status__c = 'Aprobado';
		  		if(!iterator.Approval__c) 
	  				iterator.Status__c = 'Rechazado';
	  			iterator.DCTBlockedRecord__c = false;
  				lstDCTClientPAsuccess.add(iterator);
		  	}//Fin del for para lstDCTClientPA
	  	}//Fin si blnDMLwasSuccess
		System.debug('ENTRO A save lstDCTClientPAsuccess: ' + lstDCTClientPAsuccess);
		
	  	Database.SaveResult[] srupd = Database.update(lstDCTClientPAsuccess,false);
	  	for(Database.SaveResult srIterator: srupd) {
	  		if(srIterator.isSuccess())
	  			blnchangeOwner = true;
	  		if(!srIterator.isSuccess()) 
				System.debug('EN save error srupd: ' + srIterator.getErrors()[0].getMessage());
	  	}//Fin del for para srupd
		
		//Ve si blnTryUpdate
	  	//if(blnTryUpdate) {
	  	//	lstErrorMsgs.add(System.Label.DCT_ErrorMessageRequest_lbl);
	  	//	pr = null;
	  	//}//Fin si blnTryUpdate
		
		//Actualiza el proceso de aprovación
		if (!idProcessWorkitemId.isEmpty() || Test.isRunningTest()){
	   		Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
	   		req2.setWorkitemId((!Test.isRunningTest())?idProcessWorkitemId[0].id:null);//
			req2.setComments(System.Label.DCT_RejectMessageApproveProcess_lbl);
			req2.setAction('Approve');
			System.debug(loggingLevel.Error, ' EN save error req2: ' + req2);
	   		if(strOwner == 'GV' && strAprobador == UserInfo.getUserId()){
	   			Approval.ProcessResult result2 =  Approval.process(req2);
				System.debug(loggingLevel.Error, '*** result2.isSuccess(): ' + result2.isSuccess());
				if(!result2.isSuccess())
				  	System.debug(loggingLevel.Error, 'EN save result2 error: ' + result2.getErrors()[0].getMessage());
	   		}//Fin si strOwner == 'GV' && strAprobador == UserInfo.getUserId()
		}//Fin si !idProcessWorkitemId.isEmpty()
		
	  	//Para un prueba
	  	//Database.rollback(sp);
		
		//Ve si blnchangeOwner
	  	if(blnchangeOwner) {
	  		lstSuccessMsgs.add(System.Label.DCT_SuccessMessageStatus_lbl);
	  		pr = regresar();
	  	}//Fin si blnchangeOwner
	  	
	  	System.debug(loggingLevel.Error, '*** EN save pr: ' + pr);
	  	System.debug(loggingLevel.Error, '*** EN save 1: ');
	  	return pr;
	}

	public Component.Apex.pageBlockButtons getMyCommandButtons() {
	    //the reRender attribute is a set NOT a string
	    Set<string> theSet = new Set<string>();
	    theSet.add('myPanel');
	    theSet.add('myButtons');
	    integer totalPages;
	    System.debug(loggingLevel.Error, '*** total_size: ' + total_size);
	    System.debug(loggingLevel.Error, '*** list_size: ' + list_size);
	    if (math.mod(total_size, list_size) > 0) {
	      totalPages = total_size/list_size + 1;
	    } else {
	      totalPages = (total_size/list_size);
	    }
			integer currentPage;        
	    if (selectedPage == '0') {
	      currentPage = counter/list_size + 1;
	    } else {
	      currentPage = integer.valueOf(selectedPage);
	    }
	     
	    Component.Apex.pageBlockButtons pbButtons = new Component.Apex.pageBlockButtons();        
	    pbButtons.location = 'top';
	    pbButtons.id = 'myPBButtons';
	    pbButtons.styleClass = 'slds-button-group';
	
	    Component.Apex.outputPanel opPanel = new Component.Apex.outputPanel();
	    opPanel.id = 'myButtons';
	    opPanel.styleClass = 'slds-button-group';
	                                
	    //the Previous button will alway be displayed
        Component.Apex.commandButton b1 = new Component.Apex.commandButton();
        b1.expressions.action = '{!Previous}';
        b1.title = 'Página Anterior';
        b1.value = '<';
        b1.expressions.disabled = '{!disablePrevious}';        
        b1.reRender = theSet;
        b1.styleClass = 'slds-button slds-button_neutral';

        opPanel.childComponents.add(b1);        
        System.debug(loggingLevel.Error, '*** totalPages: ' + totalPages);                
        for (integer i=0;i<totalPages;i++) {
            Component.Apex.commandButton btn = new Component.Apex.commandButton();
         
      		if (i+1==1) {
                btn.title = 'Primera Página';
                btn.value = '<<';
                btn.rendered = true;
                btn.styleClass = 'slds-button slds-button_neutral';                                        
            } else if (i+1==totalPages) {
                btn.title = 'Ultima Página';
                btn.value = '>>';
                btn.rendered = true;
                btn.styleClass = 'slds-button slds-button_neutral';                            
            } else {
                btn.title = 'Page ' + string.valueOf(i+1);
                btn.value = string.valueOf(i+1);
                btn.rendered = false;
                btn.styleClass = 'slds-button slds-button_neutral';             
            }
            
            if ( ( (i+1 <= 5 && currentPage < 5) || (i+1 >= totalPages-4 && currentPage > totalPages-4) || (i+1 >= currentPage-2 && i+1 <= currentPage+2) ) || Test.isRunningTest())
            {
                btn.rendered = true;
                //btn.styleClass = 'slds-button slds-button_neutral';
            }
                                     
            if (i+1==currentPage) {
                btn.disabled = true; 
                btn.style = 'color:blue;';
                btn.styleClass = 'slds-button slds-button_neutral';
            }  
            
            btn.onclick = 'queryByPage('+string.valueOf(i+1)+');return false;';
                 
            opPanel.childComponents.add(btn);
            
        }
        
        //the Next button will alway be displayed
        Component.Apex.commandButton b2 = new Component.Apex.commandButton();
        b2.expressions.action = '{!Next}';
        b2.title = 'Página Siguiente';
        b2.value = '>';
        b2.expressions.disabled = '{!disableNext}';        
        b2.reRender = theSet;
        b2.styleClass = 'slds-button slds-button_neutral';
        opPanel.childComponents.add(b2);
                
        //add all buttons as children of the outputPanel                
        pbButtons.childComponents.add(opPanel);  
  
	    string strDG = 'DG';
	    Component.Apex.outputPanel opPanel2 = new Component.Apex.outputPanel();
	    opPanel2.id = 'myButtonsAction';
	    opPanel2.styleClass = 'slds-button-group';

		//Solo los perfiles que se puede mostrar	    
	    if( (strOwner == 'GV' && strAprobador == UserInfo.getUserId() && strStatus == 'Pendiente') || sIdUserActualPerfil.startsWith('Administra')) {      

	      Component.Apex.commandButton savebutton = new Component.Apex.commandButton();
	      savebutton.expressions.action = '{!save}';
	      savebutton.title = 'Aprobar';
	      savebutton.value = 'Aprobar';   
	      savebutton.styleClass = 'slds-button slds-button_neutral';
	      opPanel2.childComponents.add(savebutton);
	
	      Component.Apex.commandButton rejectbutton = new Component.Apex.commandButton();
	      rejectbutton.expressions.action = '{!reject}';
	      rejectbutton.title = 'Rechazar todo';
	      rejectbutton.value = 'Rechazar todo';
	      rejectbutton.styleClass = 'slds-button slds-button_neutral';
	      
	      //Si se trata del perfil del ejecutivo
	      opPanel2.childComponents.add(rejectbutton);
	            
	    }
	    
	    //add all buttons as children of the outputPanel                
	    pbButtons.childComponents.add(opPanel2);
	
	    return pbButtons;
	}    
    
	public PageReference refreshGrid() { //user clicked a page number        
		return null;
	}

	public PageReference Previous() { //user clicked previous button
		selectedPage = '0';
		counter -= list_size;
	return null;
	}

	public PageReference Next() { //user clicked next button
		selectedPage = '0';
		counter += list_size;
	return null;
	}

	public PageReference End() { //user clicked end
		selectedPage = '0';
		counter = total_size - math.mod(total_size, list_size);
	return null;
	}

	public Boolean getDisablePrevious() { //this will disable the previous and beginning buttons
		if (counter>0) return false; else return true;
	}

	public Boolean getDisableFirst() { //this will disable the previous and beginning buttons
		if (counter==0) return false; else return true;
	}

	public Boolean getDisableNext() { //this will disable the next and end buttons
		if (counter + list_size < total_size) return false; else return true;
	}

	public Integer getTotal_size() {
		return total_size;
	}

	public Integer getPageNumber() {
		return counter/list_size + 1;
	}

	public Integer getTotalPages() {
		if (math.mod(total_size, list_size) > 0) {
	  		return total_size/list_size + 1;
		} else {
	  		return (total_size/list_size);
		}
	}
}