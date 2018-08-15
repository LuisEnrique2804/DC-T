global class DCT_ReporteCamposModifDirComercial_sch implements Schedulable{

	global String sQuery {get;set;}
		
    global void execute(SchedulableContext ctx){
		System.debug('EN DCT_AdminCartera_sch.execute...');
							
		//Crea la consulta con los campos 
		this.sQuery = ' Select 		RFC__c, RFC1__c, 		Name,				Grupo__r.Name,			Segmento__c,		Sector__c,	Subsector__c,	DCTKeyNISI__c,	';
		this.sQuery +=' DCTFiscalAddress__c,  DCTCorrespondenceAddress__c,		DCTAnticipatedAdendum__c,	DCTTermDays__c,	DCTBonusCustomization__c,	DCTCustomerFrom__c,	';
		this.sQuery +=' DCTAntiquity__c,		DCTBank__c,	DCTRapReference__c,		Tipocliente__c,		Estatus__c,		DCT_LegalPerson__c, DTC_LegalEntity__c,	';
		this.sQuery +=' DCTSocialReasonModified__c,		DCTDateRegistrationAdjudication__c,			DCTVIP__c,		DCTAVL__c,		DCTLegalRepresentative__c, DCTCatalogoFuerzaVenta2__r.Name, ';
		this.sQuery +=' DCTBenefits__c,					DCTRegistrationDate__c,		DCTLowDateAccuont__c,	DCTVPNActivation__c,		DCTBillingCycle__c,	DCT_CatalogoFuerzaVenta__r.Name, ';
		this.sQuery +=' DCTCreditClass__c,	DCTExemptBail__c,	DCTComments__c,		DCTSharedTreatment__c,	FuerzaVentaPrincipal__c, FuerzaVentaPrincipal__r.Name, FuerzaVentaSecundario__c, FuerzaVentaSecundario__r.Name, ';
		this.sQuery +=' DCTDistribuidorPrincipal__c, DCTDistribuidorSecundario__c,		DCTInplantName1__c, DCTInplantName2__c,		DCTInplantPhone1__c, DCTInplantPhone2__c,	';
		this.sQuery +=' DCTExt1__c, DCTExt2__c,		DCTInplantmobile1__c, DCTInplantmobile2__c,		DCTInplantEmail1__c, DCTInplantEmail2__c, DCT_CatalogoFuerzaVenta__c, DCTCatalogoFuerzaVenta2__c, ';
		this.sQuery +=' DCTInplantDate1__c,	DCTInplantDate2__c,		DCTResearchLegend__c,		DCTResultVerification__c,		DCTReasonRejection__c,	DCTInvestigation__c, ';
		this.sQuery +=' DCTCommentsInvestigation__c,	DCTAuthorizationDateVoBoManagement__c,	DCTTotLineasAutorInvest__c,	OwnerId, DCTServices1__c, DCTServices2__c, ';
		this.sQuery +=' (Select Plan__r.DescripcionGrupoPlan__c, Plan__r.ClaveTarifa__c, Plan__r.ClaveGrupoPlan__c,   Plan__r.DescripcionPlan__c, Plan__r.DCTTerm__c, ';
		this.sQuery +=' DCTSubdirector__r.Name, DCTAuthorizationDate__c, DCTActiveLines__c, DCTAuthorizedLines__c, Status__c, RecordType.Name, Plan__r.ClavePlan__c ';
		this.sQuery +=' From Lineas_Autorizadas__r ORDER BY DCT_ConsecutivoLineasAutorizadas__c), '; //Where RecordType.Name = \'Plan\'
		this.sQuery +=' (Select Name, Posicion__c, DCTTypeContact__c, MobilePhone, DCTNIP__c, Email, DCTReceiveInformation__c ';
		this.sQuery +=' From DirectorioComercial_Contactos__r Where DCT_ContactoDirectorio__c = true) ';
		
		//No es una prueba
		if (!Test.isRunningTest()){
			this.sQuery += ' From Cliente__c ';
			this.sQuery += ' Where ';			
			this.sQuery += ' LastModifiedDate = TODAY ';			
			//this.sQuery += ' And ID = \'a0D1100000A3ikE\''; 		
			//this.sQuery += ' LIMIT 1';							
		}
		//Si es una prueba
		if (Test.isRunningTest()){
			this.sQuery += ' From Cliente__c ';
			this.sQuery += ' Where ';			
			this.sQuery += ' LastModifiedDate = TODAY ';
			//this.sQuery += ' And ID = \'a0D1100000A3ikEEAR\'';		
			this.sQuery += ' LIMIT 1';			
		}
		
		System.debug('EN DCT_AdminCartera_sch.execute sQuery: ' + sQuery);
		
		//Crea el objeto de  DCT_AdminCartera_bch   	
        DCT_ReporteCamposModifDirComercial_bch objDepRegCls = new DCT_ReporteCamposModifDirComercial_bch(sQuery);
        
        //No es una prueba entonces procesa de 1 en 1
       	Id batchInstanceId = Database.executeBatch(objDepRegCls, 25);
			    	 
    }

}