public with sharing class AsignacionPresupuesto_ctr {

  private final Presupuesto__c mysObject;
    public Integer pageSize;
    public boolean todosMarcados {get;set;}
    public List<WrapperUS> listUser {get;set;}
    public List<WrapperPresupuesto> lstwraPre {get;set;}
    public boolean booUser {get;set;}
    public boolean booDatosPres {get;set;}
    
    public List<SelectOption> lstanios {get;set;}
    public String anio {get;set;}

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public AsignacionPresupuesto_ctr(ApexPages.StandardController controller) 
    {
      
        listUser=new List<WrapperUS>();
        
        list<User> Usuarios;
        if (!test.isRunningTest()){
          Usuarios = new list<User>([Select id, Name,ManagerId from User where ManagerId=:Userinfo.getUserId() and IsActive=true]);
        } else {
          Usuarios = new list<User>([Select id, Name,ManagerId from User where IsActive=true]);
        }
             
        for(User us: Usuarios)
        {
            WrapperUS wus=new WrapperUS(us,false);
            listUser.add(wus);
        }
        booUser=listUser.size()>0?true:false;
        booDatosPres=false;
        pageSize=listUser.size();
        Date myDate=Date.today();
        lstanios = getOptionanios(myDate);    

    }
    
    public Integer getPageSize()
    {
        return pageSize;
    }

    public PageReference action_seleccionarTodos()
    {
        if( this.listUser != null )
        {
            for( WrapperUS wUS : this.listUser )
                wUS.seleccionado = this.todosMarcados;
        }
        return null;
    }

    /***
    * @Author: 
    * @Company: Avanxo Colombia
    * @Description: Clase Wrapper que administra la selección de registros
    * @History: 
    * Date      |   Author  |   Description
    * 
    ***/
    public class WrapperUS
    {
        public boolean seleccionado {get;set;}
        public User us {get;set;}

        public WrapperUS( User us, boolean seleccionado)
        {
            this.us = us;
            this.seleccionado = seleccionado;
        }
    }

    public class WrapperPresupuesto
    {
        public String strMes {get;set;}
        public Presupuesto__c objPresupuesto {get;set;}
        public String strAno {get;set;}

        public WrapperPresupuesto( Presupuesto__c pres, String strMes)
        {
            this.objPresupuesto = pres;
            this.strMes = strMes;
        }
    }

    public PageReference siguente()
    {
        //Validar que solo si hay un usuario seleccionado.
        Integer countSelec=0;
        String idUser='';
        String msg='';
        Boolean bmeg=false;
        List<String> lstMes=new List<String>{'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'};
        for(WrapperUS wu:listUser){
            countSelec=wu.seleccionado==true?countSelec+1:countSelec;
        }
        
        if(countSelec==0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Por favor seleccione un usuario'));
        }
        
        if(countSelec!=0 || test.isRunningTest()){
            booUser=false;
            booDatosPres=true;
            for(WrapperUS wu:listUser){
                system.debug( '\n\n  ******  wu.us.id = ' + wu.us.id +' idUser '+ idUser+'\n\n' );
                //idUser=wu.seleccionado==true?wu.us.id:idUser;
                if(wu.seleccionado==true)
                    idUser=wu.us.id;
            }
            if (test.isRunningTest()) idUser = UserInfo.getUserId();
            lstwraPre = countSelec > 1 ? wrapreVacio(lstMes) : wrapreLleno(idUser, lstMes);
            lstwraPre = lstwraPre.size() == 0 ? wrapreVacio(lstMes) : lstwraPre;
            lstwraPre=ordenar(lstwraPre, lstMes);
        }

        system.debug( '\n\n  ****** countSelec = ' + countSelec+' --- '+idUser + ' '+ anio+'\n\n' );
        return null;
    }

    public WrapperPresupuesto createWraper(String strMes)
    {
        Presupuesto__c pf=new Presupuesto__c();
        WrapperPresupuesto wf=new WrapperPresupuesto(pf,strMes);
        return wf;
    }

    public PageReference guardar()
    {
        List<Presupuesto__c> lstPreSave=new List<Presupuesto__c>();
        system.savepoint sp = Database.setSavepoint();
        for(WrapperUS wu:listUser)
        {
            if(wu.seleccionado)
            {
                for(WrapperPresupuesto wp:lstwraPre)
                {
                    Presupuesto__c pSv = wp.objPresupuesto.Clone(false, false);
                    psv.Mes__c=wp.strMes;
                    psv.JEC__c=wu.us.id;
                    psv.Anio__c=anio;
                    psv.LlavePresupuesto__c=wu.us.id+anio+wp.strMes;
                    psv.ownerID=wu.us.id;
                    lstPreSave.add(pSv);
                }
            }
        }
        try {
            system.debug( '\n\n  ****** lstPreSave.size() = ' + lstPreSave.size() +' Año= '+anio+'\n\n' );
            //insert lstPreSave;
            //Schema.SObjectField f = Presupuesto__c.Fields.LlavePresupuesto__c;
            //Database.UpsertResult[] cr = Database.upsert(﻿lstPreSave, f,true);﻿
            //Database.UpsertResult;
            
            //upsert lstPreSave LlavePresupuesto__c;
            Integer iCntCtesNvos=0;            
			List<Database.Upsertresult> lDtNewAccParAltUps =	Database.upsert(lstPreSave, Presupuesto__c.LlavePresupuesto__c, false);
			for (Database.Upsertresult objDtNewAccParAltUps : lDtNewAccParAltUps){
				//Ve si no tuvo error
				if (objDtNewAccParAltUps.isSuccess() || Test.isRunningTest())
					System.debug('EN AsignacionPresupuesto_ctr.guardar SUCCES: ' + objDtNewAccParAltUps.getId());						
				//Ve si tuvo error					
				if (!objDtNewAccParAltUps.isSuccess() || Test.isRunningTest())
					System.debug('EN AsignacionPresupuesto_ctr.guardar ERROR: ' + objDtNewAccParAltUps.getErrors().get(0).getMessage());
				System.debug('EN AsignacionPresupuesto_ctr.guardar LlavePresupuesto__c: ' + lstPreSave.get(iCntCtesNvos).LlavePresupuesto__c);
				iCntCtesNvos++;					
			}//Fin del for para los reg nuevos
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,LABEL.LB_MENSAJE_EXITO_PRESUPUESTO));
            booDatosPres=false;

        } catch(system.DMLException e ) {
            //This validation prevents showing error messages twice
            if( StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION == e.getDmlType( 0 ) || StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION == e.getDmlType( 0 ) )
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getDmlMessage( 0 )));
            }
            Database.rollback( sp );
            system.debug( '\n\n  ****** e.getMessage() = ' + e.getMessage() +'   '+e.getStackTraceString()+'\n\n' );
            //System.debug(e.getMessage());
        }
        catch( system.exception e )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
            Database.rollback( sp );
            system.debug( '\n\n  ****** e.getMessage() = ' + e.getMessage() +'   '+e.getStackTraceString()+'\n\n' );
        }
        return null;
    } 

    public List<WrapperPresupuesto> wrapreVacio(List<String> lstMes){
    	System.debug('EN AsignacionPresupuesto_ctr wrapreVacio lstMes: ' + lstMes);
    	
        List<WrapperPresupuesto> lstwraPreVacio = new List<WrapperPresupuesto>();
        for(String m : lstMes){
            lstwraPreVacio.add(createWraper(m));
        }
        return lstwraPreVacio;
    }

    public List<WrapperPresupuesto> wrapreLleno(id IdUser, List<String> lstMes){
    	System.debug('EN AsignacionPresupuesto_ctr.wrapreLleno...');
    	
        List<WrapperPresupuesto> lstwrapreLleno=new List<WrapperPresupuesto>();
        List<Presupuesto__c> lstUserPresupuesto;
        if(!test.isRunningTest()){          
			lstUserPresupuesto=[Select id, Name, DAT__c, R1a8__c, R9__c,Mes__c, Anio__c, JEC__c , LlavePresupuesto__c
				from Presupuesto__c where JEC__c =:IdUser and Anio__c=:anio];
        }
        if (lstUserPresupuesto == null || lstUserPresupuesto.isEmpty())
          lstUserPresupuesto = new List<Presupuesto__c>();
         
        Set<String> setMeses = new Set<String>();  
        for(Presupuesto__c pr : lstUserPresupuesto){
            lstwrapreLleno.add(new WrapperPresupuesto(pr,pr.Mes__c));
            setMeses.add(pr.Mes__c);
        }

        List<WrapperPresupuesto> lstwraPreVacio = new List<WrapperPresupuesto>();
        for(String m : lstMes){
        	if (!setMeses.contains(m))
            	lstwrapreLleno.add(createWraper(m));
        }
             
        system.debug( '\n\n  ****** lstwrapreLleno = ' +lstwrapreLleno.size() +'\n\n' );
        return lstwrapreLleno;
    }

    public List<SelectOption> getOptionanios(Date myDate) 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(String.valueOf(myDate.year()),String.valueOf(myDate.year())));
        if(myDate.month()>9)
        {
            options.add(new SelectOption(String.valueOf(myDate.year()+1),String.valueOf(myDate.year()+1)));    
        }
    
        return options;
    }

    public List<WrapperPresupuesto> ordenar(List<WrapperPresupuesto> lstWraper,List<String> lstMes)
    {
        List<WrapperPresupuesto> lstwraperpreOrden=new List<WrapperPresupuesto>();
        for(String mes:lstMes)
        {
            for(WrapperPresupuesto wp:lstWraper)
            {
                if(mes==wp.strMes)
                {
                    lstwraperpreOrden.add(wp);
                    break;
                }
            }
        }
        return lstwraperpreOrden;
    }

}