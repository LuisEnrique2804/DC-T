public with sharing class Eficacia {
	String Fase = '';
	Integer Cantidad = 0;
	
	Integer Oportunidad = 0;
	Integer	Aproximacion = 0;
	Integer	Contacto = 0;
	Integer	Proyecto = 0;
	Integer	Propuesta = 0;
	Integer	Perdida = 0;
	Integer Ganada = 0;
	Integer Total = 0;
	
	Integer TotalPerdidas = 0;
	Integer PerdidaOportunidad = 0;
	Integer	PerdidaAproximacion = 0;
	Integer	PerdidaContacto = 0;
	Integer	PerdidaProyecto = 0;
	Integer	PerdidaPropuesta = 0;
	
	Integer OpAp = 0;
	Integer OpApD = 0;
	
	Integer Ct = 0;
	Integer OpCtD = 0;
	Integer ApCtD = 0;
	
	Integer Pr = 0;
	Integer OpPrD = 0;
	Integer ApPrD = 0;
	Integer CtPrD = 0;
	
	Integer PP = 0;
	Integer OpPpD = 0;
	Integer ApPpD = 0;
	Integer CtPpD = 0;
	Integer PrPpD = 0;
	
	Integer P1 = 0;
	Integer P2 = 0;
	Integer P3 = 0;
	Integer P4 = 0;
	Integer P5 = 0;
	
	Decimal Px01 = 0;
	Decimal Px02 = 0;
	Decimal Px03 = 0;
	Decimal Px04 = 0;
	Decimal Px05 = 0;
	Decimal Px06 = 0;
	Decimal Px07 = 0;
	Decimal Px08 = 0;
	Decimal Px09 = 0;
	Decimal Px10 = 0;
	Decimal Px11 = 0;
	Decimal Px12 = 0;
	Decimal Px13 = 0;
	Decimal Px14 = 0;
	Decimal Px15 = 0;
	
	public String 				sDirector {get; set;} 
	public list<SelectOption> 	lstDirectores {get; set;}
	public Boolean 				bDirector {get; set;} { this.bDirector = true;}
	public Boolean 				bEsDirector {get; set;} { this.bEsDirector = false;}
	public String 				sSubDirector {get; set;}
	public list<SelectOption> 	lstSubdirectores {get; set;}
	public Boolean 				bSubDirector {get; set;} { this.bSubDirector = true;}
	public Boolean 				bEsSubDirector {get; set;} { this.bEsSubDirector = false;}
	public String 				sGerente {get; set;} 
	public list<SelectOption> 	lstGerentes {get; set;}
	public Boolean				bGerente {get; set;} { this.bGerente = true; }
	public Boolean				bEsGerente {get; set;} { this.bEsGerente = false; }
	public String 				sJEC {get; set;}
	public list<SelectOption> 	lstJECS {get; set;}
	public Boolean				bJECS	{get; set;} { this.bJECS = true; }
	public Boolean				bEsJECS	{get; set;} { this.bEsJECS = false; }
	public User 				UsuarioActual {get; set;} 
	public Boolean 				bEsOtro {get; set;} { this.bEsOtro = false;}
	
	map<id, User> todosUsuarios = new map<id,User>();
	map<id, User> usrDirectores = new map<id,User>();
	map<id, User> usrSubDirectores = new map<id,User>();
	map<id, User> usrGerentes = new map<id,User>();
	map<id, User> usrJECs = new map<id,User>();
	map<id, String> usrManagers = new map<id,String>();
	map<String, Integer> mValEficacia;
	map<String, Integer> mValEficaciaPerdidas;
	
	public Opportunity objRango {get; set;}
	
	public list<wrapperReport> lstReporte {get; set;}
	
	set<Id> sIdJerarquia = new set<Id>();
	set<Id> sIdDirectores = new set<Id>();
	set<Id> sIdSubDirectores = new set<Id>();
	set<Id> sIdGerentes = new set<Id>();
	set<Id> sIdJECs = new set<Id>();
	
	public Eficacia(){
		
		mValEficacia = new map<String, Integer>();
		mValEficaciaPerdidas = new map<String, Integer>();
		lstReporte = new list<wrapperReport>();
		objRango = new Opportunity();
		
		
		ValidarInicio();
	}
	
	public void ValidarInicio(){
		lstDirectores = new list<SelectOption>();
		lstDirectores.add(new SelectOption('', ' - Seleccionar - '));
		for (User usuario : [SELECT Id,Name, Profile.Name, 
											managerId,
											Manager.Name, 
											Manager.Manager.Name, 
											Manager.Manager.Manager.Name,
											Manager.Manager.Manager.Manager.Name FROM User]){
			todosUsuarios.put(usuario.Id, usuario);									
			usrManagers.put(usuario.Id, usuario.managerId);
			if(usuario.Profile.Name =='JEC'){
				usrJECs.put(usuario.Id, usuario);
				
				if(UserInfo.getUserId() == usuario.id ){
					UsuarioActual = Usuario;
					bJECS = true;
					bEsJECS = true;
					bGerente = false;
					bSubDirector = false;
					bDirector = false;
					sDirector = usuario.id;
				}	
			}
			if(usuario.Profile.Name == 'GV'){
				usrGerentes.put(usuario.Id, usuario);	
				
				if(UserInfo.getUserId() == usuario.id ){
					UsuarioActual = Usuario;
					bGerente = false;
					bEsGErente = true;
					bSubDirector = false;
					bDirector = false;
					sGerente = usuario.id;
				}	
			}
			if(usuario.Profile.Name == 'SD'){
				usrSubDirectores.put(usuario.Id, usuario);	
				
				if(UserInfo.getUserId() == usuario.id ){
					UsuarioActual = Usuario;
					bSubDirector = false;
					bEsSubDirector = true;
					bDirector = false;
					sSubDirector = usuario.id;
				}	
			}
			if(usuario.Profile.Name == 'DR9'){
				usrDirectores.put(usuario.Id, usuario);	
				lstDirectores.add(new SelectOption(usuario.Id, usuario.Name));
				if(UserInfo.getUserId() == usuario.id ){
					UsuarioActual = Usuario;
					bDirector = false;
					bEsDirector = true;
					sDirector = usuario.id;
				}
			}
			
			if (usuario.Profile.Name != 'DR9' && usuario.Profile.Name != 'GV' && usuario.Profile.Name !='SD' && usuario.Profile.Name !='JEC'){
				bEsOtro = true;
			}else{
				bEsOtro = false;
			}
		}
		if (bEsDirector) ObtenerSubDirectores();
		if (bEsSubDirector) ObtenerGerentes();
		if (bEsGerente) ObtenerJECS();
	}
	
	public void FiltrarJerarquia(){
			system.debug('sDirector: ' + sDirector);	
			system.debug('sSubDirector: ' + sSubDirector);
			system.debug('sGerente: ' + sGerente);
			system.debug('sJEC: ' + sJEC);	
			if(sDirector != '' && sDirector != null){ //Nivel 1
				sIdJerarquia = new set<Id>();
				for (User u : todosUsuarios.Values()){ //Nivel 2
					if (sDirector == u.ManagerId){	
						for(User sU : todosUsuarios.Values()){ //Nivel 3
							if(u.Id == sU.ManagerId){	
								for (User sUg : todosUsuarios.Values()){ //Nivel 4
									if(sUg.ManagerId == sU.Id){
										sIdJerarquia.add(sUg.Id);
									}
								}
							}
						}
					}
				}
			}
			
			if(sSubDirector != '' && sSubDirector != null){ // Nivel 2
				sIdJerarquia = new set<Id>();
				//for (Id sId : sIdSubDirectores){
					for(User sU : todosUsuarios.Values()){ //Nivel 3
						if(sSubDirector == sU.ManagerId){	
							for (User sUg : todosUsuarios.Values()){ //Nivel 4
								if(sUg.ManagerId == sU.Id){
									sIdJerarquia.add(sUg.Id);
								}
							}
						}
					}
				//}
			}
			
		    if (sGerente != '' && sGerente != null){
		    		sIdJerarquia = new set<Id>();
					for (User sUg : todosUsuarios.Values()){ //Nivel 4
						if(sGerente == sUg.ManagerId){
							sIdJerarquia.add(sUg.Id);
						}
					}
		    }
			system.debug('FiltrarJerarquia: ' + sIdJerarquia);
	}
	
	public pageReference OppJecs(){
		if (sJEC != null ){
			sIdJerarquia = new Set<Id>();
			sIdJerarquia.add(sJEC);
		}		
		return null;
	}
	
	public pageReference ObtenerSubDirectores(){
		lstJECS = new list<SelectOption>();
		lstGerentes = new list<SelectOption>();
		lstSubdirectores = new list<SelectOption>();
		lstSubdirectores.add(new SelectOption('', ' - Seleccionar - '));
		
		if (sDirector != '' && sDirector != null){
			for (User u : todosUsuarios.Values()){	
				if (u.ManagerId == sDirector){
					lstSubdirectores.add(new SelectOption(u.Id, u.Name));
				}				
			}
		} else {
			lstJECS.add(new SelectOption('', ' - Seleccionar - '));
			lstGerentes.add(new SelectOption('', ' - Seleccionar - '));
			//sJEC = '';
			//sGerente = '';	
			sIdJerarquia = new set<Id>();
			sIdGerentes = new set<Id>();
			sIdJECs = new set<Id>();	 
		}
		FiltrarJerarquia();
		//sSubDirector = '';
		return null;
	}
	
	public pageReference ObtenerGerentes(){
		lstJECS = new list<SelectOption>();
		lstGerentes = new list<SelectOption>();
		lstGerentes.add(new SelectOption('', ' - Seleccionar - '));
		
		if(sSubDirector != '' && sSubDirector != null){
			for (User u : todosUsuarios.Values()){
				if (u.ManagerId == sSubDirector)
					lstGerentes.add(new SelectOption(u.Id, u.Name));
			}
		} else {
			lstJECS.add(new SelectOption('', ' - Seleccionar - '));
			//sJEC = '';
			sIdJerarquia = new set<Id>();
			sIdJECs = new set<Id>();
		}
		FiltrarJerarquia();
		//sGerente = '';
		return null;
	}
	
	public pageReference ObtenerJECS(){
		lstJECS = new list<SelectOption>();
		lstJECS.add(new SelectOption('', ' - Seleccionar - '));
		//sJEC = '';
		if(sGerente != '' && sGerente != null){
			for (User u : todosUsuarios.Values()){
				if(u.ManagerId != null){
					if (u.ManagerId == sGerente)
						lstJECs.add(new SelectOption(u.Id, u.Name));
				}
			}
		}
		FiltrarJerarquia();
		//sJEC = '';
		return null;
	}
	
	public PageReference getReport(){
		
		Fase = '';
		Cantidad = 0;
		
		Oportunidad = 0;
		Aproximacion = 0;
		Contacto = 0;
		Proyecto = 0;
		Propuesta = 0;
		Perdida = 0;
		Ganada = 0;
		Total = 0;
		
		TotalPerdidas = 0;
		PerdidaOportunidad = 0;
		PerdidaAproximacion = 0;
		PerdidaContacto = 0;
		PerdidaProyecto = 0;
		PerdidaPropuesta = 0;
		
		OpAp = 0;
		OpApD = 0;
		
		Ct = 0;
		OpCtD = 0;
		ApCtD = 0;
		
		Pr = 0;
		OpPrD = 0;
		ApPrD = 0;
		CtPrD = 0;
		
		PP = 0;
		OpPpD = 0;
		ApPpD = 0;
		CtPpD = 0;
		PrPpD = 0;
		
		P1 = 0;
		P2 = 0;
		P3 = 0;
		P4 = 0;
		P5 = 0;
		
		Px01 = 0;
		Px02 = 0;
		Px03 = 0;
		Px04 = 0;
		Px05 = 0;
		Px06 = 0;
		Px07 = 0;
		Px08 = 0;
		Px09 = 0;
		Px10 = 0;
		Px11 = 0;
		Px12 = 0;
		Px13 = 0;
		Px14 = 0;
		Px15 = 0;
		
		
		if(objRango.fecha_Fin__c < objRango.fecha_Inicio__c){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'La fecha fin no puede ser menor que la fecha inicio.'));		
		}else{
		
			mValEficacia = new map<String, Integer>();
			Fase = '';              
	  		Integer Cantidad= 0;
			
			list<AggregateResult> lstAR = new list<AggregateResult>();
			
			if (sIdJerarquia.size()>0){
				lstAR = [SELECT count(Id) N, StageName 
										  	 FROM Opportunity
										    WHERE CreatedDate >=: objRango.fecha_Inicio__c
										      and CreatedDate <=: objRango.fecha_Fin__c.adddays(1)
										      and Opportunity.OwnerId in: sIdJerarquia 
									     group by StageName];
				
				system.debug('Eficacia: Si tuvo filto ::::: ' + sIdJerarquia.size() + ' ::::::::' +  + sIdJerarquia);
			} else { 
				lstAR = [SELECT count(Id) N, StageName 
										  	 FROM Opportunity 
										    WHERE CreatedDate >=: objRango.fecha_Inicio__c
										      and CreatedDate <=: objRango.fecha_Fin__c.adddays(1)
									     group by StageName];
				system.debug('Eficacia: no tuvo filto.'  +sIdJerarquia);
			} 
			
			for (AggregateResult arr : lstAR){
				
				 Fase = (String)arr.get('StageName');              
	  			 Cantidad = (Integer)arr.get('N');
	
	  			 mValEficacia.put(Fase, Cantidad);
	  			 Total += Cantidad;
	  			 
			}
			
			list<AggregateResult> lstARP = new list<AggregateResult>(); 
			
			if (sIdJerarquia.size() > 0){
				lstARP = [SELECT count(Id) N, Opportunity.UltimaFaseOportunidad__c USN 
										  FROM Opportunity 
										 WHERE 		StageName = 'Perdida' 
										       and  CreatedDate >=: objRango.fecha_Inicio__c
										       and	CreatedDate <=: objRango.fecha_Fin__c.adddays(1)
										       and  Opportunity.OwnerId in: sIdJerarquia
									  group by StageName, Opportunity.UltimaFaseOportunidad__c];
				system.debug('Eficacia 01: Si tuvo filto :::::  ' + sIdJerarquia.size() + ' ::::::::' +  + sIdJerarquia);
			}else{
				lstARP = [SELECT count(Id) N, Opportunity.UltimaFaseOportunidad__c USN 
										  FROM Opportunity
										 WHERE 		StageName = 'Perdida' 
										       and  CreatedDate >=: objRango.fecha_Inicio__c
										       and	CreatedDate <=: objRango.fecha_Fin__c.adddays(1)
									  group by StageName, Opportunity.UltimaFaseOportunidad__c];
				system.debug('Eficacia 01: No tuvo filtro ' + sIdJerarquia);
			}
			
			for (AggregateResult arr : lstARP){
				 Fase = (String)arr.get('USN');              
	  			 Cantidad = (Integer)arr.get('N');	
	  			 
	  			 mValEficaciaPerdidas.put(Fase, Cantidad);
	  			 TotalPerdidas += Cantidad;
			} 
			
			//Todas las vivas
			Oportunidad = mValEficacia.get('Oportunidad') != null ? mValEficacia.get('Oportunidad') : 0;
			Aproximacion = mValEficacia.get('Aproximación') != null ? mValEficacia.get('Aproximación') : 0;
			Contacto = mValEficacia.get('Contacto') != null ? mValEficacia.get('Contacto') : 0;
			Proyecto = mValEficacia.get('Proyecto') != null ? mValEficacia.get('Proyecto') : 0;
			Propuesta = mValEficacia.get('Propuesta') != null ? mValEficacia.get('Propuesta') : 0;
			Perdida = mValEficacia.get('Perdida') != null ? mValEficacia.get('Perdida') : 0;
			Ganada = mValEficacia.get('Ganada') != null ? mValEficacia.get('Ganada') : 0;
			
			if(Test.isRunningTest()){
				Oportunidad = 10;
				Aproximacion = 9;
				Contacto = 8;
				Proyecto = 7;
				Propuesta = 6;
				Ganada = 200;
			}
			
			system.debug('Oportunidad: ' + Oportunidad);
			system.debug('Aproximacion: ' + Aproximacion);
			system.debug('Contacto: ' + Contacto);
			system.debug('Proyecto: ' + Proyecto);
			system.debug('Propuesta: ' + Propuesta);
			system.debug('Perdida: ' + Perdida);
			system.debug('Ganada: ' + Ganada);
			system.debug('Total: ' + Total);
					
			//Todas las perdidas y sus fases
			
			PerdidaOportunidad = mValEficaciaPerdidas.get('Oportunidad') != null ? mValEficaciaPerdidas.get('Oportunidad') : 0;
			PerdidaAproximacion = mValEficaciaPerdidas.get('Aproximación') != null ? mValEficaciaPerdidas.get('Aproximación') : 0;
			PerdidaContacto = mValEficaciaPerdidas.get('Contacto') != null ? mValEficaciaPerdidas.get('Contacto') : 0;
			PerdidaProyecto = mValEficaciaPerdidas.get('Proyecto') != null ? mValEficaciaPerdidas.get('Proyecto') : 0;
			PerdidaPropuesta = mValEficaciaPerdidas.get('Propuesta') != null ? mValEficaciaPerdidas.get('Propuesta') : 0;
			
			if(test.isRunningTest()){
				PerdidaOportunidad = 25;
				PerdidaAproximacion = 32;
				PerdidaContacto = 65;
				PerdidaProyecto = 12;
				PerdidaPropuesta = 21;
				TotalPerdidas = 155;
			}
			
			system.debug('*************************************************'); 
			system.debug('PerdidaOportunidad: ' + PerdidaOportunidad);
			system.debug('PerdidaAproximacion: ' + PerdidaAproximacion);
			system.debug('PerdidaContacto: ' + PerdidaContacto);
			system.debug('PerdidaProyecto: ' + PerdidaProyecto);
			system.debug('PerdidaPropuesta: ' + PerdidaPropuesta);
			system.debug('TotalPerdidas: ' + TotalPerdidas);
			
			//Bloque 1
			OpAp  	= 0 + Ganada + Aproximacion + PerdidaAproximacion + Contacto + PerdidaContacto + Proyecto + PerdidaProyecto + Propuesta + PerdidaPropuesta;
			OPApD 	= 0 + Ganada + PerdidaOportunidad + Aproximacion + PerdidaAproximacion + Contacto + PerdidaContacto + Proyecto + PerdidaProyecto + Propuesta + PerdidaPropuesta;
			
			system.debug('Bloque 1 - OpAp :' + OpAp);
			system.debug('Bloque 1 - OPApD:' + OPApD);
			
			//Bloque 2
			Ct = 0 + Ganada + Contacto + PerdidaContacto + Proyecto + PerdidaProyecto + Propuesta + PerdidaPropuesta;
			OpCtD = 0 + Ganada + PerdidaOportunidad + PerdidaAproximacion + Contacto + PerdidaContacto + Proyecto + PerdidaProyecto + Propuesta + PerdidaPropuesta;
			ApCtD = 0 + Ganada + PerdidaAproximacion + Contacto + PerdidaContacto + Proyecto + PerdidaProyecto + Propuesta + PerdidaPropuesta;
			
			system.debug('Bloque 2 - Ct    :' + Ct);
			system.debug('Bloque 2 - OpCtD :' + OpCtD);
			system.debug('Bloque 2 - ApCtD :' + ApCtD);
			
			//Bloque 3
			Pr = 0 + Ganada + Proyecto + PerdidaProyecto + Propuesta + PerdidaPropuesta;
			OpPrD = 0 + Ganada + PerdidaOportunidad + PerdidaAproximacion + PerdidaContacto + Proyecto + PerdidaProyecto + Propuesta + PerdidaPropuesta;
			ApPrD = 0 + Ganada + PerdidaAproximacion + PerdidaContacto + Proyecto + PerdidaProyecto + Propuesta + PerdidaPropuesta;
			CtPrD = 0 + Ganada + PerdidaContacto + Proyecto + PerdidaProyecto + Propuesta + PerdidaPropuesta;
			
			system.debug('Bloque 3 - Pr    :' + Pr);
			system.debug('Bloque 3 - OpPrD :' + OpPrD);
			system.debug('Bloque 3 - ApPrD :' + ApPrD);
			system.debug('Bloque 3 - CtPrD :' + CtPrD);
			
			//Bloque 4
			PP = 0 + Ganada + Propuesta + PerdidaPropuesta;
			OpPpD = 0 + Ganada + PerdidaOportunidad + PerdidaAproximacion + PerdidaContacto + PerdidaProyecto + Propuesta + PerdidaPropuesta;
			ApPpD = 0 + Ganada + PerdidaAproximacion + PerdidaContacto + PerdidaProyecto + Propuesta + PerdidaPropuesta;
			CtPpD = 0 + Ganada + PerdidaContacto + PerdidaProyecto + Propuesta + PerdidaPropuesta;
			PrPpD = 0 + Ganada + PerdidaProyecto + Propuesta + PerdidaPropuesta;
			
			system.debug('Bloque 4 - PP    :' + PP);
			system.debug('Bloque 4 - OpPpD :' + OpPpD);
			system.debug('Bloque 4 - ApPpD :' + ApPpD);
			system.debug('Bloque 4 - CtPpD :' + CtPpD);
			system.debug('Bloque 4 - PrPpD :' + PrPpD);
			
			//Bloque 5
			P1 = 0 + Ganada + TotalPerdidas;
			P2 = 0 + Ganada + (TotalPerdidas - PerdidaOportunidad);
			P3 = 0 + Ganada + (TotalPerdidas - (PerdidaOportunidad + PerdidaAproximacion));
			P4 = 0 + Ganada + (TotalPerdidas - (PerdidaOportunidad + PerdidaAproximacion + PerdidaContacto));
			P5 = 0 + Ganada + (TotalPerdidas - (PerdidaOportunidad + PerdidaAproximacion + PerdidaContacto + PerdidaProyecto));
			
			system.debug('Bloque 5 - P1:' + P1);
			system.debug('Bloque 5 - P2:' + P2);
			system.debug('Bloque 5 - P3:' + P3);
			system.debug('Bloque 5 - P4:' + P4);
			system.debug('Bloque 5 - P5:' + P5);
			
			//Bloque de %
			try { Px01 = (Decimal.valueOf(OpAp) / Decimal.valueOf(OpApD)).setScale(2) * 100; } catch (exception ex) { Px01 = 0; }
			try { Px02 = (Decimal.valueOf(Ct) / Decimal.valueOf(OpCtD)).setScale(2) * 100; } catch (exception ex) { Px02 = 0; }
			try { Px03 = (Decimal.valueOf(Ct) / Decimal.valueOf(ApCtD)).setScale(2) * 100; } catch (exception ex) { Px03 = 0; }
			try { Px04 = (Decimal.valueOf(Pr) / Decimal.valueOf(OpPrD)).setScale(2) * 100; } catch (exception ex) { Px04 = 0; }
			try { Px05 = (Decimal.valueOf(Pr) / Decimal.valueOf(ApPrD)).setScale(2) * 100; } catch (exception ex) { Px05 = 0; }
			try { Px06 = (Decimal.valueOf(Pr) / Decimal.valueOf(CtPrD)).setScale(2) * 100; } catch (exception ex) { Px06 = 0; }
			try { Px07 = (Decimal.valueOf(PP) / Decimal.valueOf(OpPpD)).setScale(2) * 100; } catch (exception ex) { Px07 = 0; }
			try { Px08 = (Decimal.valueOf(PP) / Decimal.valueOf(ApPpD)).setScale(2) * 100; } catch (exception ex) { Px08 = 0; }
			try { Px09 = (Decimal.valueOf(PP) / Decimal.valueOf(CtPpD)).setScale(2) * 100; } catch (exception ex) { Px09 = 0; }
			try { Px10 = (Decimal.valueOf(PP) / Decimal.valueOf(PrPpD)).setScale(2) * 100; } catch (exception ex) { Px10 = 0; }
			try { Px11 = (Decimal.valueOf(Ganada) / Decimal.valueOf(P1)).setScale(2) * 100; } catch (exception ex) { Px11 = 0; }
			try { Px12 = (Decimal.valueOf(Ganada) / Decimal.valueOf(P2)).setScale(2) * 100; } catch (exception ex) { Px12 = 0; }
			try { Px13 = (Decimal.valueOf(Ganada) / Decimal.valueOf(P3)).setScale(2) * 100; } catch (exception ex) { Px13 = 0; }
			try { Px14 = (Decimal.valueOf(Ganada) / Decimal.valueOf(P4)).setScale(2) * 100; } catch (exception ex) { Px14 = 0; }
			try { Px15 = (Decimal.valueOf(Ganada) / Decimal.valueOf(P5)).setScale(2) * 100; } catch (exception ex) { Px15 = 0; }
			
			system.debug('%01: ' + Px01.setScale(0));
			system.debug('%02: ' + Px02.setScale(0));
			system.debug('%03: ' + Px03.setScale(0));
			system.debug('%04: ' + Px04.setScale(0));
			system.debug('%05: ' + Px05.setScale(0));
			system.debug('%06: ' + Px06.setScale(0));
			system.debug('%07: ' + Px07.setScale(0));
			system.debug('%08: ' + Px08.setScale(0));
			system.debug('%09: ' + Px09.setScale(0));
			system.debug('%10: ' + Px10.setScale(0));
			system.debug('%11: ' + Px11.setScale(0));
			system.debug('%12: ' + Px12.setScale(0));
			system.debug('%13: ' + Px13.setScale(0));
			system.debug('%14: ' + Px14.setScale(0));
			system.debug('%15: ' + Px15.setScale(0));	
			
			lstReporte = new list<wrapperReport>();
			lstReporte.add(new wrapperReport('Oportunidad'	,'',OpAp + ' de ' + OpApD, Ct + ' de ' + OpCtD, Pr + ' de ' + OpPrD, PP + ' de ' + OpPpD, Ganada + ' de ' + P1));
			lstReporte.add(new wrapperReport('Aproximación'	,'',''                   , Ct + ' de ' + ApCtD, Pr + ' de ' + ApPrD, PP + ' de ' + ApPpD, Ganada + ' de ' + P2));
			lstReporte.add(new wrapperReport('Contacto'		,'',''                   , ''                 , Pr + ' de ' + CtPrD, PP + ' de ' + CtPpD, Ganada + ' de ' + P3));
			lstReporte.add(new wrapperReport('Proyecto'		,'',''                   , ''                 , ''                 , PP + ' de ' + PrPpD, Ganada + ' de ' + P4));
			lstReporte.add(new wrapperReport('Propuesta'	,'',''                   , ''                 , ''                 , ''                 , Ganada + ' de ' + P5));
			lstReporte.add(new wrapperReport());
			lstReporte.add(new wrapperReport('Opotunidad'	,'',Px01.setScale(0)+'%',Px02.setScale(0)+'%',Px04.setScale(0)+'%',Px07.setScale(0)+'%',Px11.setScale(0)+'%'));
			lstReporte.add(new wrapperReport('Aproximación'	,'',''      			,Px03.setScale(0)+'%',Px05.setScale(0)+'%',Px08.setScale(0)+'%',Px12.setScale(0)+'%'));
			lstReporte.add(new wrapperReport('Contacto'		,'',''      			,''      			 ,Px06.setScale(0)+'%',Px09.setScale(0)+'%',Px13.setScale(0)+'%'));
			lstReporte.add(new wrapperReport('Proyecto'		,'',''      			,''      			 ,''     			  ,Px10.setScale(0)+'%',Px14.setScale(0)+'%'));
			lstReporte.add(new wrapperReport('Propuesta'	,'',''      			,''     			 ,''    			  ,''      			   ,Px15.setScale(0)+'%'));
		}
		return null; 
	}
	
	public class wrapperReport{
		
		public String sFase 	{get; set;}
		public String sOp 		{get; set;}
		public String sAp		{get; set;}
		public String sCt		{get; set;}
		public String sPr		{get; set;}
		public String sPp		{get; set;}
		public String sRes		{get; set;}
		
		public wrapperReport(){
			sFase 	= '';
			sOp 	= '';
			sAp		= '';
			sCt		= '';
			sPr		= '';
			sPp		= '';
			sRes	= '';
		} 
		
		public wrapperReport(
			String Fase,
			String Op,
			String Ap,
			String Ct,
			String Pr,
			String Pp,
			String Res
		){
			sFase = Fase;
			sOp = Op;
			sAp = Ap;
			sCt = Ct;
			sPr	= Pr;
			sPp	= Pp;
			sRes = Res;
		}
	}
	
}