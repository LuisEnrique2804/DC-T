public class DCT_SendEmailByDays_cls {
	public static void sendEmail(List<Cliente__c> lstClient){
		System.debug(loggingLevel.Error, '*** lstClient: ' + lstClient);
		// DCT_Bonificcion_en_Dias_Notificaci_n_a_Gerente_de_Cobranza	
		Map<String, String> mapEmailSend90 = new Map<String, String>();
  		Map<String, String> mapIdUsrEmail = new Map<String, String>();
  		Map<String, String> mapIdUsrEmail2 = new Map<String, String>();
  		Map<String, List<User>> mapEmailDatosUsr = new Map<String, List<User>>();  	
  		Map<String, List<User>> mapEmailDatosUsr2 = new Map<String, List<User>>();  		
  		Map<String, String> mapContactEmail = new Map<String, String>();
  		Map<String, String> mapContactEmail2 = new Map<String, String>();
  		Map<String, Contact> mapContactUps = new Map<String, Contact>();
  		Map<String, Contact> mapContactUps2 = new Map<String, Contact>();
        Set<String> setIdContaUps = new Set<String>();
        Set<String> setIdContaUps2 = new Set<String>();
		List<Messaging.SendEmailResult> lRepuestaReceiver = new List<Messaging.SendEmailResult>();
		List<Messaging.singleemailMessage> lSingleemailMessage = new List<Messaging.singleemailMessage>();

		if(lstClient.size()>0) {
			for(Cliente__c clienteIterator: lstClient) {
				mapEmailSend90.put(clienteIterator.id, clienteIterator.OwnerId);
			}
		}


		//Ve si tiene algo setIdUsr
		if (!mapEmailSend90.isEmpty()){
			//Los datos del usuario
			for (User usuario : [SELECT id, Email, Name, LastName, FirstName 
				FROM User WHERE ID IN: mapEmailSend90.values()]){
				if (usuario.Email != NULL){
					mapIdUsrEmail.put(usuario.id, usuario.Email);
					if (mapEmailDatosUsr.containsKey(usuario.Email))
						mapEmailDatosUsr.get(usuario.Email).Add(usuario);
					if (!mapEmailDatosUsr.containsKey(usuario.Email))							
						mapEmailDatosUsr.put(usuario.Email, new List<User>{usuario});
				}//Fin si usuario.Email != NULL
			}
			System.debug('EN DCT_assignmentNewOwner_bch.finish mapIdUsrEmail: ' + mapIdUsrEmail);
			System.debug('EN DCT_assignmentNewOwner_bch.finish mapEmailDatosUsr: ' + mapEmailDatosUsr);				
								
			//Los datos de los contactos asociados a los usuarios
			for (Contact contacto : [SELECT id, Email FROM Contact WHERE Email IN: mapIdUsrEmail.values()]){
				mapContactEmail.put(contacto.Email, contacto.id);
			}
			//Ve si existen todos los contactos asociados a los usuarios y si no crealos
			for (String sEmailUsr : mapIdUsrEmail.values()){
				//Crea el nuevo contacto apartir de los datos del usuario si no existe en mapContactEmail
				if (!mapContactEmail.containsKey(sEmailUsr)){
					mapContactUps.put(sEmailUsr, new Contact(
							FirstName = mapEmailDatosUsr.get(sEmailUsr).get(0).FirstName,
							LastName = mapEmailDatosUsr.get(sEmailUsr).get(0).LastName,
							Email = sEmailUsr
						)
					);
				}///Fin si !mapContactEmail.contaisnKey(sEmailUsr)
			}//Fin del for para mapIdUsrEmail.values()
			//Ve si hay nuevos contacto que agregar
			if (!mapContactUps.isEmpty()){
				List<Database.Upsertresult> lDtupr = Database.upsert(mapContactUps.values(), Contact.id, false);
				for (Database.Upsertresult dtupr : lDtupr){
					if (dtupr.isSuccess()) 
						setIdContaUps.add(dtupr.getId());
					if (!dtupr.isSuccess())
    					System.debug('EN DCT_assignmentNewOwner_bch.finish ERROR al crear el contacto: ' + dtupr.getErrors()[0].getMessage());
				}//Fin del for para lDtupr
			}//Fin si !mapContactUps.isEmpty()
			//Consulta los contactos recien creados
			for(Contact NvoContc : [Select id, Email From Contact Where id IN:setIdContaUps
				And Email != null]){
				mapContactEmail.put(NvoContc.Email, NvoContc.id);					
			}
		}//Fin si !setIdUsr.isempty()
		System.debug('EN DCT_assignmentNewOwner_bch.finish mapContactEmail2: ' + mapContactEmail2);
		Integer cNoReg = 0;
		String strEmailTemplateName = system.Label.DCT_strEmailTemplateName_lbl;
		EmailTemplate et=[Select id from EmailTemplate WHERE name = 'DCT Bonificcion en Dias - Notificación a Gerente de Cobranza' limit 1];//DCT_Bonificcion_en_Dias_Notificaci_n_a_Gerente_de_Cobranza
		for (String sIdClientePaso : mapEmailSend90.KeySet()){
			System.debug('EN DCT_assignmentNewOwner_bch.finish sIdClientePaso: ' + sIdClientePaso + ' Contacto: ' + mapContactEmail.get(mapIdUsrEmail.get(mapEmailSend90.get(sIdClientePaso))));					
			//Crea el mensaje
        	Messaging.SingleEmailMessage mailUsrReceiver = new Messaging.SingleEmailMessage();
	        mailUsrReceiver.setSenderDisplayName('TELCEL'); 
	        mailUsrReceiver.setUseSignature(false);  
	        mailUsrReceiver.setSaveAsActivity(false); 
			mailUsrReceiver.setTargetObjectId( mapContactEmail.get(mapIdUsrEmail.get(mapEmailSend90.get(sIdClientePaso))) );			        
    		mailUsrReceiver.setWhatId(sIdClientePaso);					
			mailUsrReceiver.setTemplateId(et.id);			        
			//Metelo a la lista				
			lSingleemailMessage.add(mailUsrReceiver);				
			cNoReg++;				    
		}//Fin del for para mapEmailSend90
        //Messaging.SendEmailResult[] repuestaReceiver = Messaging.sendEmail(new Messaging.singleemailMessage[] {mailUsrReceiver});
        Messaging.SendEmailResult[] repuestaReceiver = Messaging.sendEmail(lSingleemailMessage);	        
        //Ve si hubo error
		if (repuestaReceiver[0].success)
		    System.debug('El correo para el usuario. ');
		else
		    System.debug('Hubo error a la hora del enviar el correo al usuario Error: ' + repuestaReceiver[0].errors[0].message);	
	}
}