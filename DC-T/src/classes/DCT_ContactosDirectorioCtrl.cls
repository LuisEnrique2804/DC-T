public with sharing class DCT_ContactosDirectorioCtrl {
	
	public String sIdDir {get;set;}
	public List<Contact> lContactos {get;set;}
	
	//Un StandardControler para la clase
    public DCT_ContactosDirectorioCtrl(ApexPages.StandardController stdCtr){
    	System.debug('EN DCT_ContactosDirectorioCtrl...');
    	sIdDir = stdCtr.getId();
		lContactos = new List<Contact>();     	
    	//Consulta sus contactos asociados del tipo directorio
    	ConsultaContactosDirectorio(sIdDir);
    }

    public PageReference ConsultaContactosDirectorio(String sIdDirPaso){
        System.debug('EN DCT_ContactosDirectorioCtrl.ConsultaContactosDirectorio slConsecCons: ' + sIdDirPaso);
		
		//Antes de consultar los datos de los resonsables eliminalos de contactos
		for (Contact Contacto : [Select  c.Posicion__c, c.Phone, c.Nivel__c, c.Name, c.MobilePhone, c.Estructura__c, 
			c.Estatus__c, c.Email, c.DCT_ContactoDirectorio__c, c.DCTTypeContact__c
			, c.DCTReceiveInformation__c
			, c.DCTNIP__c, c.DCTHobbies__c, c.DCTExtension__c, c.AccountId
		 	From Contact c Where Directorio_Comercial__c = :sIdDirPaso 
		 	And DCT_ContactoDirectorio__c = true And PCT_IdExterno__c = null]){		 		
			System.debug('EN DCT_ContactosDirectorioCtrl.ConsultaContactosDirectorio Contacto.id: ' + Contacto.id + ' AccountId: ' + Contacto.AccountId);
			lContactos.add(Contacto);			
		}					    		
		
		return null;
    }	
	
}