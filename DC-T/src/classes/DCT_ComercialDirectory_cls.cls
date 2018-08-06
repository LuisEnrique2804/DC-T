/***************************************************************************************************************************
   Desarrollado por: Avanxo México                                                                                        
   Autor: Luis Enrique Garcia Sanabria                                                                         
   Email: legarcia@avanxo.com                                                                                  
   Fecha de creación: 02-05-2018                                                                                           
 ***************************************************************************************************************************
   Metadata: DCT_ComercialDirectory_tgr                                                                                                              
 ***************************************************************************************************************************
   Descripción: Clase que crea el historico de los cambios que se tiene en un registro de Directorio Comercial, validando 
   							si el campo tuvo algun cambio y lo registra, valida si el cambio se realizo en un campo solicitado, en caso
   							de que no, no se crea dicho registro y de lo contrario se crea con todos los campos que cambiaron.             
                                                                                                                           
 ***************************************************************************************************************************
                                                  Control de versiones                                                     
 ***************************************************************************************************************************
   No.      Fecha                 Autor                    Email                          Descripción                     
 ***************************************************************************************************************************
   1.0   02-05-2018   Luis Enrique Garcia Sanabria   legarcia@avanxo.com   Creacion de la clase DCT_ComercialDirectory_cls 
 ***************************************************************************************************************************/
public class DCT_ComercialDirectory_cls {

    public static String VaRtCteCautivo = Schema.SObjectType.Cliente__c.getRecordTypeInfosByName().get('Cliente Cautivo').getRecordTypeId();
    public static String VaRtCteProspInvestiga = Schema.SObjectType.Cliente__c.getRecordTypeInfosByName().get('Prospecto Investigación').getRecordTypeId();
	public static String sUsrActualPerfil {get;set;}

	public static  void HistoricalTracking(Map<id,Cliente__c> directoryComercialNew, Map<id,Cliente__c> directoryComercialOld){
		List<HistoryMovement__c> lstHistory = new List<HistoryMovement__c>();
		boolean blnAnyChange = false;
		for(id idDC: directoryComercialOld.keySet()) {

			HistoryMovement__c history = new HistoryMovement__c();

			history.Directorio_Comercial__c = idDC;
			String sName = directoryComercialNew.get(idDC).Name+'-'+String.valueOf(directoryComercialNew.get(idDC).LastModifiedDate);
			sName = sName.length() > 80 ? sName.substring(80) :  sName;
			history.Name = sName;

			if(directoryComercialNew.get(idDC).DCTBank__c != directoryComercialOld.get(idDC).DCTBank__c) {
				history.bankPreviousValue__c = directoryComercialOld.get(idDC).DCTBank__c;
				history.bankNewValue__c = directoryComercialNew.get(idDC).DCTBank__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTBenefits__c != directoryComercialOld.get(idDC).DCTBenefits__c) {
				history.BenefitsPreviousValue__c = directoryComercialOld.get(idDC).DCTBenefits__c;
				history.BenefitsNewValue__c = directoryComercialNew.get(idDC).DCTBenefits__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTBonusCustomization__c != directoryComercialOld.get(idDC).DCTBonusCustomization__c) {
				history.BonusCustomizationPreviousValue__c = directoryComercialOld.get(idDC).DCTBonusCustomization__c;
				history.BonusCustomizationNewValue__c = directoryComercialNew.get(idDC).DCTBonusCustomization__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTCollectionBonus__c != directoryComercialOld.get(idDC).DCTCollectionBonus__c) {
				history.CollectionBonusPreviousValue__c = String.valueOf(directoryComercialOld.get(idDC).DCTCollectionBonus__c);
				history.CollectionBonusNewValue__c = String.valueOf(directoryComercialNew.get(idDC).DCTCollectionBonus__c); 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTCareChannel__c != directoryComercialOld.get(idDC).DCTCareChannel__c) {
				history.CareChannelPreviousValue__c = directoryComercialOld.get(idDC).DCTCareChannel__c;
				history.CareChannelNewValue__c = directoryComercialNew.get(idDC).DCTCareChannel__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTBillingCycle__c != directoryComercialOld.get(idDC).DCTBillingCycle__c) {
				history.BillingCyclePreviousValue__c = directoryComercialOld.get(idDC).DCTBillingCycle__c;
				history.BillingCycleNewValue__c = directoryComercialNew.get(idDC).DCTBillingCycle__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTCreditClass__c != directoryComercialOld.get(idDC).DCTCreditClass__c) {
				history.CreditClassPreviousValue__c = directoryComercialOld.get(idDC).DCTCreditClass__c;
				history.CreditClassNewValue__c = directoryComercialNew.get(idDC).DCTCreditClass__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTKeyNISI__c != directoryComercialOld.get(idDC).DCTKeyNISI__c) {
				history.KeyNISIPreviousValue__c = directoryComercialOld.get(idDC).DCTKeyNISI__c;
				history.KeyNISINewValue__c = directoryComercialNew.get(idDC).DCTKeyNISI__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTUniquekeyCustomer__c != directoryComercialOld.get(idDC).DCTUniquekeyCustomer__c) {
				history.UniquekeyCustomerPreviousValue__c = directoryComercialOld.get(idDC).DCTUniquekeyCustomer__c;
				history.UniquekeyCustomerNewValue__c = directoryComercialNew.get(idDC).DCTUniquekeyCustomer__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTCustomerFrom__c != directoryComercialOld.get(idDC).DCTCustomerFrom__c) {
				history.CustomerFromPreviousValue__c = directoryComercialOld.get(idDC).DCTCustomerFrom__c;
				history.CustomerFromNewValue__c = directoryComercialNew.get(idDC).DCTCustomerFrom__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTComments__c != directoryComercialOld.get(idDC).DCTComments__c) {
				history.CommentsPreviousValue__c = directoryComercialOld.get(idDC).DCTComments__c;
				history.CommentsNewValue__c = directoryComercialNew.get(idDC).DCTComments__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).Competidores__c != directoryComercialOld.get(idDC).Competidores__c) {
				history.CompetidoresPreviousValue__c = directoryComercialOld.get(idDC).Competidores__c;
				history.CompetidoresNewValue__c = directoryComercialNew.get(idDC).Competidores__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).Cuentaprincipal__c != directoryComercialOld.get(idDC).Cuentaprincipal__c) {
				history.ParentIdPreviousValue__c = directoryComercialOld.get(idDC).Cuentaprincipal__c;
				history.ParentIdNewValue__c = directoryComercialNew.get(idDC).Cuentaprincipal__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTAddressCorrespondence__c != directoryComercialOld.get(idDC).DCTAddressCorrespondence__c) {
				history.CorrespondenceAddressPreviousValue__c = directoryComercialOld.get(idDC).DCTAddressCorrespondence__c;
				history.CorrespondenceAddressNewValue__c = directoryComercialNew.get(idDC).DCTAddressCorrespondence__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTTaxResidence_del__c != directoryComercialOld.get(idDC).DCTTaxResidence_del__c) {
				history.FiscalAddressPreviousValue__c = directoryComercialOld.get(idDC).DCTTaxResidence_del__c;
				history.FiscalAddressNewValue__c = directoryComercialNew.get(idDC).DCTTaxResidence_del__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).Estatus__c != directoryComercialOld.get(idDC).Estatus__c) {
				history.EstatusPreviousValue__c = directoryComercialOld.get(idDC).Estatus__c;
				history.EstatusNewValue__c = directoryComercialNew.get(idDC).Estatus__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTCreditBureau__c != directoryComercialOld.get(idDC).DCTCreditBureau__c) {
				history.CreditBureauPreviousValue__c = directoryComercialOld.get(idDC).DCTCreditBureau__c;
				history.CreditBureauNewValue__c = directoryComercialNew.get(idDC).DCTCreditBureau__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTExemptBail__c != directoryComercialOld.get(idDC).DCTExemptBail__c) {
				history.ExemptBailPreviousValue__c = directoryComercialOld.get(idDC).DCTExemptBail__c;
				history.ExemptBailNewValue__c = directoryComercialNew.get(idDC).DCTExemptBail__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTLowDateAccuont__c != directoryComercialOld.get(idDC).DCTLowDateAccuont__c) {
				history.LowDatePreviousValue__c = directoryComercialOld.get(idDC).DCTLowDateAccuont__c;
				history.LowDateNewValue__c = directoryComercialNew.get(idDC).DCTLowDateAccuont__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTDateRegistrationAdjudication__c != directoryComercialOld.get(idDC).DCTDateRegistrationAdjudication__c) {
				history.DateRegistrationAdjudicationNewValue__c = directoryComercialOld.get(idDC).DCTDateRegistrationAdjudication__c;
				history.DateRegistrationAdjudicationPreviousValu__c = directoryComercialNew.get(idDC).DCTDateRegistrationAdjudication__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTRegistrationDate__c != directoryComercialOld.get(idDC).DCTRegistrationDate__c) {
				history.RegistrationDatePreviousValue__c = directoryComercialOld.get(idDC).DCTRegistrationDate__c;
				history.RegistrationDateNewValue__c = directoryComercialNew.get(idDC).DCTRegistrationDate__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTMethodOfPayment__c != directoryComercialOld.get(idDC).DCTMethodOfPayment__c) {
				history.MethodOfPaymentPreviousValue__c = directoryComercialOld.get(idDC).DCTMethodOfPayment__c;
				history.MethodOfPaymentNewValue__c = directoryComercialNew.get(idDC).DCTMethodOfPayment__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTManager__c != directoryComercialOld.get(idDC).DCTManager__c) {
				history.GerentePreviousValue__c = directoryComercialOld.get(idDC).DCTManager__c;
				history.GerenteNewValue__c = directoryComercialNew.get(idDC).DCTManager__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTCategoryData__c != directoryComercialOld.get(idDC).DCTCategoryData__c) {
				history.CategoryDataPreviousValue__c = directoryComercialOld.get(idDC).DCTCategoryData__c;
				history.CategoryDataNewValue__c = directoryComercialNew.get(idDC).DCTCategoryData__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).Grupo__c != directoryComercialOld.get(idDC).Grupo__c) {
				history.GruopPreviousValue__c = directoryComercialOld.get(idDC).Grupo__c;
				history.GruopNewValue__c = directoryComercialNew.get(idDC).Grupo__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTReasonRejection__c != directoryComercialOld.get(idDC).DCTReasonRejection__c) {
				history.ReasonRejectionPreviousValue__c = directoryComercialOld.get(idDC).DCTReasonRejection__c;
				history.ReasonRejectionNewValue__c = directoryComercialNew.get(idDC).DCTReasonRejection__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCT_NombreComercial__c != directoryComercialOld.get(idDC).DCT_NombreComercial__c) {
				history.NombreComercialPreviousValue__c = directoryComercialOld.get(idDC).DCT_NombreComercial__c;
				history.NombreComercialNewValue__c = directoryComercialNew.get(idDC).DCT_NombreComercial__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCT_LegalPerson__c != directoryComercialOld.get(idDC).DCT_LegalPerson__c) {
				history.LegalEntityPreviousValue__c = directoryComercialOld.get(idDC).DCT_LegalPerson__c;
				history.LegalEntityNewValue__c = directoryComercialNew.get(idDC).DCT_LegalPerson__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTPlan__c != directoryComercialOld.get(idDC).DCTPlan__c) {
				history.PlanPreviousValue__c = directoryComercialOld.get(idDC).DCTPlan__c;
				history.PlanNewValue__c = directoryComercialNew.get(idDC).DCTPlan__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTTermDays__c != directoryComercialOld.get(idDC).DCTTermDays__c) {
				history.TermDaysPreviousValue__c = directoryComercialOld.get(idDC).DCTTermDays__c;
				history.TermDaysNewValue__c = directoryComercialNew.get(idDC).DCTTermDays__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTOtherRegions__c != directoryComercialOld.get(idDC).DCTOtherRegions__c) {
				history.OtherRegionsPreviousValue__c = directoryComercialOld.get(idDC).DCTOtherRegions__c;
				history.OtherRegionsNewValue__c = directoryComercialNew.get(idDC).DCTOtherRegions__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTOtherCountries__c != directoryComercialOld.get(idDC).DCTOtherCountries__c) {
				history.OtherCountriesPreviousValue__c = directoryComercialOld.get(idDC).DCTOtherCountries__c;
				history.OtherCountriesNewValue__c = directoryComercialNew.get(idDC).DCTOtherCountries__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).OwnerId != directoryComercialOld.get(idDC).OwnerId) {
				history.OwnerIdPreviousValue__c = directoryComercialOld.get(idDC).OwnerId;
				//Ve si el valor del reg corresponde con un usuario
				String sIdOwnerIdReg = directoryComercialNew.get(idDC).OwnerId;
				if (sIdOwnerIdReg.startsWith('005'))
					history.OwnerIdNewValue__c = sIdOwnerIdReg;
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTFullCompanyName__c != directoryComercialOld.get(idDC).DCTFullCompanyName__c) {
				history.FullCompanyNamePreviousValue__c = directoryComercialOld.get(idDC).DCTFullCompanyName__c;
				history.FullCompanyNameNewValue__c = directoryComercialNew.get(idDC).DCTFullCompanyName__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTSocialReasonModified__c != directoryComercialOld.get(idDC).DCTSocialReasonModified__c) {
				history.SocialReasonModifiedPreviousValue__c = directoryComercialOld.get(idDC).DCTSocialReasonModified__c;
				history.SocialReasonModifiedNewValue__c = directoryComercialNew.get(idDC).DCTSocialReasonModified__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTRapReference__c != directoryComercialOld.get(idDC).DCTRapReference__c) {
				history.RapReferencePreviousValue__c = directoryComercialOld.get(idDC).DCTRapReference__c;
				history.RapReferenceNewValue__c = directoryComercialNew.get(idDC).DCTRapReference__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTLegalRepresentative__c != directoryComercialOld.get(idDC).DCTLegalRepresentative__c) {
				history.LegalRepresentativePreviousValue__c = directoryComercialOld.get(idDC).DCTLegalRepresentative__c;
				history.LegalRepresentativeNewValue__c = directoryComercialNew.get(idDC).DCTLegalRepresentative__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).RFC1__c != directoryComercialOld.get(idDC).RFC1__c) {
				history.RFCPreviousValue__c = directoryComercialOld.get(idDC).RFC1__c;
				history.RFCNewValue__c = directoryComercialNew.get(idDC).RFC1__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).Segmento__c != directoryComercialOld.get(idDC).Segmento__c) {
				history.SegmentoPreviousValue__c = directoryComercialOld.get(idDC).Segmento__c;
				history.SegmentoNewValue__c = directoryComercialNew.get(idDC).Segmento__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTRates__c != directoryComercialOld.get(idDC).DCTRates__c) {
				history.RatesPreviousValue__c = directoryComercialOld.get(idDC).DCTRates__c;
				history.RatesNewValue__c = directoryComercialNew.get(idDC).DCTRates__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).Tipocliente__c != directoryComercialOld.get(idDC).Tipocliente__c) {
				history.TipoClientePreviousValue__c = directoryComercialOld.get(idDC).Tipocliente__c;
				history.TipoClienteNewValue__c = directoryComercialNew.get(idDC).Tipocliente__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTAccountType__c != directoryComercialOld.get(idDC).DCTAccountType__c) {
				history.AccountTypePreviousValue__c = directoryComercialOld.get(idDC).DCTAccountType__c;
				history.AccountTypeNewValue__c = directoryComercialNew.get(idDC).DCTAccountType__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTCompanyType__c != directoryComercialOld.get(idDC).DCTCompanyType__c) {
				history.CompanyTypePreviousValue__c = directoryComercialOld.get(idDC).DCTCompanyType__c;
				history.CompanyTypeNewValue__c = directoryComercialNew.get(idDC).DCTCompanyType__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTUseTaxAddress__c != directoryComercialOld.get(idDC).DCTUseTaxAddress__c) {
				history.UseTaxAddressPreviousValue__c = directoryComercialOld.get(idDC).DCTUseTaxAddress__c;
				history.UseTaxAddressNewValue__c = directoryComercialNew.get(idDC).DCTUseTaxAddress__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTVPNActivation__c != directoryComercialOld.get(idDC).DCTVPNActivation__c) {
				history.VPNActivationPreviousValue__c = directoryComercialOld.get(idDC).DCTVPNActivation__c;
				history.VPNActivationNewValue__c = directoryComercialNew.get(idDC).DCTVPNActivation__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTVIP__c != directoryComercialOld.get(idDC).DCTVIP__c) {
				history.VIPPreviousValue__c = directoryComercialOld.get(idDC).DCTVIP__c;
				history.VIPNewValue__c = directoryComercialNew.get(idDC).DCTVIP__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTAVL__c != directoryComercialOld.get(idDC).DCTAVL__c) {
				history.AVLPreviousValue__c = directoryComercialOld.get(idDC).DCTAVL__c;
				history.AVLNewValue__c = directoryComercialNew.get(idDC).DCTAVL__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTInplantName1__c != directoryComercialOld.get(idDC).DCTInplantName1__c) {
				history.InplantName1PreviousValue__c = directoryComercialOld.get(idDC).DCTInplantName1__c;
				history.InplantName1NewValue__c = directoryComercialNew.get(idDC).DCTInplantName1__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTInplantName2__c != directoryComercialOld.get(idDC).DCTInplantName2__c) {
				history.InplantName2PreviousValue__c = directoryComercialOld.get(idDC).DCTInplantName2__c;
				history.InplantName2NewValue__c = directoryComercialNew.get(idDC).DCTInplantName2__c; 	
				blnAnyChange = true;			
			}		
			if(directoryComercialNew.get(idDC).DCTInplantPhone1__c != directoryComercialOld.get(idDC).DCTInplantPhone1__c) {
				history.InplantPhone1PreviousValue__c = directoryComercialOld.get(idDC).DCTInplantPhone1__c;
				history.InplantPhone1NewValue__c = directoryComercialNew.get(idDC).DCTInplantPhone1__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTInplantPhone2__c != directoryComercialOld.get(idDC).DCTInplantPhone2__c) {
				history.InplantPhone2PreviousValue__c = directoryComercialOld.get(idDC).DCTInplantPhone2__c;
				history.InplantPhone2NewValue__c = directoryComercialNew.get(idDC).DCTInplantPhone2__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTExt1__c != directoryComercialOld.get(idDC).DCTExt1__c) {
				history.Ext1PreviousValue__c = directoryComercialOld.get(idDC).DCTExt1__c;
				history.Ext1NewValue__c = directoryComercialNew.get(idDC).DCTExt1__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTExt2__c != directoryComercialOld.get(idDC).DCTExt2__c) {
				history.Ext2PreviousValue__c = directoryComercialOld.get(idDC).DCTExt2__c;
				history.Ext2NewValue__c = directoryComercialNew.get(idDC).DCTExt2__c; 	
				blnAnyChange = true;			
			}		
			if(directoryComercialNew.get(idDC).DCTInplantmobile1__c != directoryComercialOld.get(idDC).DCTInplantmobile1__c) {
				history.Inplantmobile1PreviosValue__c = directoryComercialOld.get(idDC).DCTInplantmobile1__c;
				history.Inplantmobile1NewValue__c = directoryComercialNew.get(idDC).DCTInplantmobile1__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTInplantmobile2__c != directoryComercialOld.get(idDC).DCTInplantmobile2__c) {
				history.nplantmobile2PreviousValue__c = directoryComercialOld.get(idDC).DCTInplantmobile2__c;
				history.Inplantmobile2NewValue__c = directoryComercialNew.get(idDC).DCTInplantmobile2__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTInplantEmail1__c != directoryComercialOld.get(idDC).DCTInplantEmail1__c) {
				history.InplantEmail1PreviousValue__c = directoryComercialOld.get(idDC).DCTInplantEmail1__c;
				history.InplantEmail1NewValue__c = directoryComercialNew.get(idDC).DCTInplantEmail1__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTInplantEmail2__c != directoryComercialOld.get(idDC).DCTInplantEmail2__c) {
				history.InplantEmail2PreviousValue__c = directoryComercialOld.get(idDC).DCTInplantEmail2__c;
				history.InplantEmail2NewValue__c = directoryComercialNew.get(idDC).DCTInplantEmail2__c; 	
				blnAnyChange = true;			
			}		
			if(directoryComercialNew.get(idDC).DCTInplantDate1__c != directoryComercialOld.get(idDC).DCTInplantDate1__c) {
				history.InplantDate1PreviousValue__c = directoryComercialOld.get(idDC).DCTInplantDate1__c;
				history.InplantDate1NewValue__c = directoryComercialNew.get(idDC).DCTInplantDate1__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTInplantDate2__c != directoryComercialOld.get(idDC).DCTInplantDate2__c) {
				history.InplantDate2PreviousValue__c = directoryComercialOld.get(idDC).DCTInplantDate2__c;
				history.InplantDate2NewValue__c = directoryComercialNew.get(idDC).DCTInplantDate2__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTDistributor1__c != directoryComercialOld.get(idDC).DCTDistributor1__c) {
				history.Distributor1PreviousValue__c = directoryComercialOld.get(idDC).DCTDistributor1__c;
				history.Distributor1NewValue__c = directoryComercialNew.get(idDC).DCTDistributor1__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTDistributor2__c != directoryComercialOld.get(idDC).DCTDistributor2__c) {
				history.Distributor2PreviousValue__c = directoryComercialOld.get(idDC).DCTDistributor2__c;
				history.Distributor2NewValue__c = directoryComercialNew.get(idDC).DCTDistributor2__c; 	
				blnAnyChange = true;			
			}	

			//if(directoryComercialNew.get(idDC).DCTBank__c != directoryComercialOld.get(idDC).DCTBank__c) {
			//	history.AccountNumberPreviousValue__c = directoryComercialOld.get(idDC).DCTBank__c;
			//	history.AccountNumberNewValue__c = directoryComercialNew.get(idDC).DCTBank__c; 	
			//	blnAnyChange = true;			
			//}	

			//Campos de Investigación//
			if(directoryComercialNew.get(idDC).DCTResultVerification__c != directoryComercialOld.get(idDC).DCTResultVerification__c) {
				history.ResultVerificationPreviousValue__c = directoryComercialOld.get(idDC).DCTResultVerification__c;
				history.ResultVerificationNewValue__c = directoryComercialNew.get(idDC).DCTResultVerification__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTResearchLegend__c != directoryComercialOld.get(idDC).DCTResearchLegend__c) {
				history.ResearchLegendPreviousValue__c = directoryComercialOld.get(idDC).DCTResearchLegend__c;
				history.ResearchLegendNewValue__c = directoryComercialNew.get(idDC).DCTResearchLegend__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTInvestigation__c != directoryComercialOld.get(idDC).DCTInvestigation__c) {
				history.InvestigationPreviousValue__c = directoryComercialOld.get(idDC).DCTInvestigation__c;
				history.InvestigationNewValue__c = directoryComercialNew.get(idDC).DCTInvestigation__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTCommentsInvestigation__c != directoryComercialOld.get(idDC).DCTCommentsInvestigation__c) {
				history.CommentsInvestigationPreviousValue__c = directoryComercialOld.get(idDC).DCTCommentsInvestigation__c;
				history.CommentsInvestigationNewValue__c = directoryComercialNew.get(idDC).DCTCommentsInvestigation__c; 	
				blnAnyChange = true;			
			}	
			if(directoryComercialNew.get(idDC).DCTApprovalProcess__c != directoryComercialOld.get(idDC).DCTApprovalProcess__c) {
				history.ApprovalProcessPreviousValue__c = directoryComercialOld.get(idDC).DCTApprovalProcess__c;
				history.ApprovalProcessNewValue__c = directoryComercialNew.get(idDC).DCTApprovalProcess__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTAskAuthorization__c != directoryComercialOld.get(idDC).DCTAskAuthorization__c) {
				history.AskAuthorizationPreviousValue__c = directoryComercialOld.get(idDC).DCTAskAuthorization__c;
				history.AskAuthorizationNewValue__c = directoryComercialNew.get(idDC).DCTAskAuthorization__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTTypeAuthorization__c != directoryComercialOld.get(idDC).DCTTypeAuthorization__c) {
				history.TypeAuthorizationPreviousValue__c = directoryComercialOld.get(idDC).DCTTypeAuthorization__c;
				history.TypeAuthorizationNewValue__c = directoryComercialNew.get(idDC).DCTTypeAuthorization__c; 	
				blnAnyChange = true;			
			}
			if(directoryComercialNew.get(idDC).DCTTotLineasAutorInvest__c != directoryComercialOld.get(idDC).DCTTotLineasAutorInvest__c) {
				history.TotalAuthorizedLinesPreviousValue__c = directoryComercialOld.get(idDC).DCTTotLineasAutorInvest__c;
				history.TotalAuthorizedLinesNewValue__c = directoryComercialNew.get(idDC).DCTTotLineasAutorInvest__c; 	
				blnAnyChange = true;			
			}

			lstHistory.add(history);
		}
		if(blnAnyChange) {
			List<Database.SaveResult> sr = Database.insert(lstHistory,true); 
			for(Database.SaveResult iterator: sr) {
				if(iterator.isSuccess()) {
					System.debug(loggingLevel.Error, '*** EXITO');
				}
			}
		}
	}

	public static void SendSecondValidation(Map<id,Cliente__c> directoryComercialNew, Map<id,Cliente__c> directoryComercialOld){
		List<Account> lstAccs = new List<Account>();
	    List<DCTRegion__c> lstRegion = new List<DCTRegion__c>();
	    Set<DCTRegion__c> setRegion = new Set<DCTRegion__c>();
	    Set<String> setRFC = new Set<String>();
	    Set<String> setName = new Set<String>();
	    Set<string> setIdOwners = new Set<string>();
	    List<User> lstUserManager = new List<User>();
	    Map<Id, Id> mapUserManager = new Map<Id, Id>();
	    System.debug(loggingLevel.Error, '*** directoryComercialNew.values(): ' + directoryComercialNew.values());
	    for(Cliente__c iterator: directoryComercialNew.values()) {
	    	if(iterator.RFC__c != null ) {
	    		setRFC.add(iterator.RFC__c);
	    	} else {
	    		setRFC.add(iterator.RFC1__c);
	    	}
	      	setName.add(iterator.Name);
	      	setIdOwners.add(iterator.OwnerId);
	    }
	    System.debug(loggingLevel.Error, '*** setRFC: ' + setRFC);
		for(id idDC: directoryComercialOld.keySet()) {  
			System.debug(loggingLevel.Error, '*** directoryComercialOld.get(idDC).DCTDuplicateRecordRejected__c: ' + directoryComercialOld.get(idDC).DCTDuplicateRecordRejected__c);
			System.debug(loggingLevel.Error, '*** directoryComercialNew.get(idDC).DCTDuplicateRecordRejected__c: ' + directoryComercialNew.get(idDC).DCTDuplicateRecordRejected__c);
			System.debug(loggingLevel.Error, '*** directoryComercialNew.get(idDC).RecordTypeId : ' + directoryComercialNew.get(idDC).RecordTypeId );
			System.debug(loggingLevel.Error, '*** VaRtCteCautivo: ' + VaRtCteCautivo);
			if(directoryComercialNew.get(idDC).DCTDuplicateRecordRejected__c && directoryComercialNew.get(idDC).RecordTypeId != VaRtCteCautivo){
				//if(directoryComercialNew.get(idDC).DCTDuplicateRecordRejected__c != directoryComercialOld.get(idDC).DCTDuplicateRecordRejected__c) {
					//try{lstAccs = [SELECT Id, Name, RFC__c FROM Account WHERE Name Not IN: setName AND RFC__c IN: setRFC ORDER BY CreatedDate ASC];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
					try{lstRegion = [SELECT Id, Name, RFC__c, DCTBillingCycle__c, EstatusCobranza__c FROM DCTRegion__c WHERE RFC__c IN: setRFC ORDER BY CreatedDate ASC];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
					try{lstUserManager = [SELECT Id, ManagerId, Manager.ManagerId FROM User WHERE Id IN:setIdOwners];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
					System.debug(loggingLevel.Error, '*** lstAccs: ' + lstAccs);
					System.debug(loggingLevel.Error, '*** lstRegion: ' + lstRegion);
					if(lstRegion.size()>0) {
						for(DCTRegion__c iteratorReg: lstRegion) {
							if(iteratorReg.DCTBillingCycle__c == '97' || iteratorReg.DCTBillingCycle__c == '98' ||iteratorReg.DCTBillingCycle__c == '99' ) {
								setRegion.add(iteratorReg);
							}else if( iteratorReg.EstatusCobranza__c == 'PA' || iteratorReg.EstatusCobranza__c == 'AF' || 
								iteratorReg.EstatusCobranza__c == 'DF' || iteratorReg.EstatusCobranza__c == 'EM' || 
								iteratorReg.EstatusCobranza__c == 'SP' || iteratorReg.EstatusCobranza__c == 'HL' || 
								iteratorReg.EstatusCobranza__c == 'SS' || iteratorReg.EstatusCobranza__c == 'SU' || 
								iteratorReg.EstatusCobranza__c == 'FP' || iteratorReg.EstatusCobranza__c == 'AB' || 
								iteratorReg.EstatusCobranza__c == 'SA' || iteratorReg.EstatusCobranza__c == 'EA' || 
								iteratorReg.EstatusCobranza__c == 'PD') {
								setRegion.add(iteratorReg);
							}
						}
					}
            		//Si tiene algo la lista de lstUserManager recorrela y metela en 
            		for (User usuario : lstUserManager){
            			mapUserManager.put(usuario.Id, usuario.ManagerId);
            		}
            		System.debug(loggingLevel.Error, '*** mapUserManager: ' + mapUserManager);
					System.debug(loggingLevel.Error, '*** setRegion.size(): ' + setRegion.size());
					System.debug(loggingLevel.Error, '*** setRegion: ' + setRegion);
					if(setRegion.size()>0) {
						Approval.ProcessSubmitRequest procSubmReq = new Approval.ProcessSubmitRequest();
					    procSubmReq.setComments('Favor de revisar el registro del prospecto, ya que actualmente se cuenta con un adeudo.');
					    procSubmReq.setObjectId(idDC);
					    procSubmReq.setProcessDefinitionNameOrId('DCTDuplicateRecord2');
					    procSubmReq.setSkipEntryCriteria(true);
					    procSubmReq.setNextApproverIds(mapUserManager.values()); 
					    System.debug(loggingLevel.Error, '*** procSubmReq: ' + procSubmReq);
					    System.debug(loggingLevel.Error, '*** procSubmReq.getNextApproverIds(): ' + procSubmReq.getNextApproverIds());      
					    Approval.ProcessResult resultAprove = Approval.process(procSubmReq,true);
					    System.debug(loggingLevel.Error, '*** resultAprove.getInstanceId(): ' + resultAprove.getInstanceId());
					    System.debug(loggingLevel.Error, '*** resultAprove.getInstanceStatus(): ' + resultAprove.getInstanceStatus());
					    System.debug(loggingLevel.Error, '*** resultAprove.getEntityId(): ' + resultAprove.getEntityId());
					    if(resultAprove.isSuccess()) {

					        System.debug(loggingLevel.Error, '*** Approvación Enviada exitosamente: ');
					    }else {
					        System.debug(loggingLevel.Error, '*** strErrorMsg: ');
					    }
					}
				//}	
			}	
			System.debug(loggingLevel.Error, '*** directoryComercialOld.get(idDC).DCTDuplicateRegistrationAcceptance__c: ' + directoryComercialOld.get(idDC).DCTDuplicateRegistrationAcceptance__c);
			System.debug(loggingLevel.Error, '*** directoryComercialNew.get(idDC).DCTDuplicateRegistrationAcceptance__c: ' + directoryComercialNew.get(idDC).DCTDuplicateRegistrationAcceptance__c);
			if(!directoryComercialOld.get(idDC).DCTDuplicateRegistrationAcceptance__c) {
				if(directoryComercialNew.get(idDC).DCTDuplicateRegistrationAcceptance__c != directoryComercialOld.get(idDC).DCTDuplicateRegistrationAcceptance__c) {
					Map<String,Map<String,RecordType>> mapRTsByDevName = TLCL_Utils_cls.getRecordTypes('DeveloperName');
					Account pctRecord = new Account();
					pctRecord.Name = directoryComercialOld.get(idDC).Name; 
					pctRecord.OwnerId = directoryComercialOld.get(idDC).OwnerId; 
					pctRecord.RFC__c = directoryComercialOld.get(idDC).RFC1__c; 
					pctRecord.DTC_LegalEntity__c = directoryComercialOld.get(idDC).DCTLegalPersonBack__c;
					pctRecord.Sector__c = directoryComercialOld.get(idDC).DCTSectorBack__c;
					pctRecord.Segmento__c = directoryComercialOld.get(idDC).DCTSegmentback__c;
					pctRecord.Subsector__c = directoryComercialOld.get(idDC).DCTSubsectorback__c;
					pctRecord.DCT_TypeOfProcedure__c = directoryComercialOld.get(idDC).DCTActivationTypeback__c;
					if(pctRecord.Segmento__c == 'Corporativo'){
						pctRecord.RecordTypeId = mapRTsByDevName.get('Account').get('PlanClienteTelcelCorporativo').Id;
					}
					if(pctRecord.Segmento__c == 'Empresarial'){
						pctRecord.RecordTypeId = mapRTsByDevName.get('Account').get('PlanClienteTelcelEmpresarial').Id; 
					}
					if(pctRecord.Segmento__c == 'PyME'){
						pctRecord.RecordTypeId = mapRTsByDevName.get('Account').get('PlanClienteTelcelPyME').Id;
					}
					pctRecord.DCT_RegistrationDate__c = Date.today();
					pctRecord.TipoCliente__c = 'Prospecto';
					pctRecord.Estatus__c = 'Activo';
					Database.SaveResult sr = Database.insert(pctRecord,false);
						if(sr.isSuccess()){
							System.debug(loggingLevel.Error, '*** El prospecto ha sido creado de manera exitosa.: ');
						}else{
							for(Database.Error iterator:sr.getErrors()){
								System.debug(loggingLevel.Error, '*** iterator.getMessage(): ' + iterator.getMessage());
							}        
						}
				}	
			}
		}
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');	
	}

	public static void ChangeDate(Map<id,Cliente__c> directoryComercialNew, Map<id,Cliente__c> directoryComercialOld){
		Set<String> setIdPCT = new Set<String>();
		List<Account> lstAccs = new List<Account>();
		System.debug(loggingLevel.Error, '*** directoryComercialOld: ' + directoryComercialOld);
		for(String iterator: directoryComercialOld.keySet()) {
			System.debug(loggingLevel.Error, '*** Fecha de Ampliacion de vigencia: ' + directoryComercialNew.get(iterator).FechaAmpliacionVigencia__c);
			if(directoryComercialNew.get(iterator).FechaAmpliacionVigencia__c != null) {
				System.debug(loggingLevel.Error, '*** Cambio a True:' + directoryComercialOld.get(iterator).FechaAmpliacionVigencia__c +' != '+ directoryComercialNew.get(iterator).FechaAmpliacionVigencia__c);
				if(directoryComercialOld.get(iterator).FechaAmpliacionVigencia__c != directoryComercialNew.get(iterator).FechaAmpliacionVigencia__c) {
					System.debug(loggingLevel.Error, '*** Ampliar vigencia de seguimiento: ' + directoryComercialOld.get(iterator).DCTExtensionValidity__c);
					if(directoryComercialOld.get(iterator).DCTExtensionValidity__c) {
						setIdPCT.add(directoryComercialNew.get(iterator).Cliente__c);
					}
				}
			}
		}
		System.debug(loggingLevel.Error, '*** setIdPCT: ' + setIdPCT);
		if(setIdPCT.size()>0) {
			for(Account iteratorAcc: [SELECT DCT_RegistrationDate__c FROM Account WHERE Id IN : setIdPCT]) {
				System.debug(loggingLevel.Error, '*** iteratorAcc.DCT_RegistrationDate__c: ' + iteratorAcc.DCT_RegistrationDate__c);
				iteratorAcc.DCT_RegistrationDate__c = iteratorAcc.DCT_RegistrationDate__c.addDays(60);
				System.debug(loggingLevel.Error, '*** iteratorAcc.DCT_RegistrationDate__c+60: ' + iteratorAcc.DCT_RegistrationDate__c);
				lstAccs.add(iteratorAcc);
			}
		}
		List<Database.SaveResult> sr = Database.Update(lstAccs,true);
		for(Database.SaveResult iterator: sr) {
			if(iterator.isSuccess()) {
				System.debug(loggingLevel.Error, '*** Se actualizo la fecha del registro: ');
			}
		}
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');	
	}

	public static void actualizaVigencia(Map<id,Cliente__c> directoryComercialNew, Map<id,Cliente__c> directoryComercialOld){
	    System.debug('EN DCT_ComercialDirectory_cls.actualizaVigencia...');
	    			
		Boolean bGanadas = false;
		Map<String, Boolean> mapOppGanadas = new Map<String, Boolean>();
		Map<String, String> mapIdUsrMgr = new Map<String, String>();
    	String VaRtProspecto = Schema.SObjectType.Cliente__c.getRecordTypeInfosByName().get('Prospecto').getRecordTypeId();
    	String VaRtCteProspInvestiga = Schema.SObjectType.Cliente__c.getRecordTypeInfosByName().get('Prospecto Investigación').getRecordTypeId();    
		
		Set<String> setIdPerfilAdmin = new Set<String>();
       	for (User usuario : [Select Id, ProfileId, Profile.Name
			FROM User where Profile.Name LIKE 'Administrador%']){
			setIdPerfilAdmin.add(usuario.ProfileId);	
       	}

		
		//Busca las Opp asociadas a este directorio
		for (Cliente__c objMapaCliente : [Select id, Cliente__c,
			(Select OwnerId, MapaCliente__c, RecordTypeId From DirectorioComercial_Embudo__r
				Where StageName != 'Oportunidad') //RecordType.Name Like '%Ganada%'
			From Cliente__c Where id IN :directoryComercialNew.keySet()]){
			//Ve si el mapa en cuestion tiene opp Ganadas 
			if (!objMapaCliente.DirectorioComercial_Embudo__r.isEmpty())
				mapOppGanadas.put(objMapaCliente.id, true);
		}//Fin del for para la consulta de Cliente__c 
		
		//Recorre los reg de los Directorios y despliega los msg de error
		for (String sIdDir : directoryComercialNew.keySet()){
			//Ve si el directorio existe en mapOppGanadas			
			if (directoryComercialNew.get(sIdDir).DCTExtensionValidity__c && !directoryComercialOld.get(sIdDir).DCTExtensionValidity__c)
				if (!mapOppGanadas.containsKey(sIdDir))
					directoryComercialNew.get(sIdDir).DCTExtensionValidity__c.AddError('No se puede solicitar "Ampliar Vigencia de Seguimiento" ya que tu prospecto no cuenta con evidencia de seguimiento.');
		}
		
		Set<String> sOwnerDirCom = new Set<String>();
		//Recorre la lista de reg que se estan actualizando
		for (Cliente__c DirCom : directoryComercialNew.Values()){
			sOwnerDirCom.add(DirCom.OwnerId);						
		}//Fin del for para directoryComercialNew.Values()
		
		Map<String, String> mapIdDirComIdMan = new Map<String, String>();
		String sNmFuncBusc = 'SD';
		String sIdMan = '';
		System.debug(loggingLevel.Error, '*** sOwnerDirCom: ' + sOwnerDirCom);		
		//Consulta 
       	for (User usuario : [Select Id, UserRole.Name, UserRoleId,
       		Manager.UserRole.Name, ManagerId,//1er nivel hacia arriva
       		Manager.Manager.UserRole.Name, Manager.ManagerId,//2do nivel hacia arriva       		
       		Manager.Manager.Manager.UserRole.Name, Manager.Manager.ManagerId//3er nivel hacia arriva
       		FROM User WHERE id IN :sOwnerDirCom]){
       		System.debug(loggingLevel.Error, '*** usuario: ' + usuario);
	    	System.debug('EN DCT_ComercialDirectory_cls.actualizaVigencia usuarios de Funcion del usuario: ' + usuario.UserRole.Name); 
			System.debug('EN DCT_ComercialDirectory_cls.actualizaVigencia usuarios de Funcion del gestor 1er nivel: ' + usuario.Manager.UserRole.Name);
			System.debug('EN DCT_ComercialDirectory_cls.actualizaVigencia usuarios de Funcion del gestor 2do nivel: ' + usuario.Manager.Manager.UserRole.Name);
			System.debug('EN DCT_ComercialDirectory_cls.actualizaVigencia usuarios de Funcion del gestor 3er nivel: ' + usuario.Manager.Manager.Manager.UserRole.Name);
			//Ve si alguna de las funciones de los gestores es de tipo GV o SD
			if (usuario.UserRole.Name != null)
				if (usuario.UserRole.Name.startsWith(sNmFuncBusc))
        			sIdMan = usuario.Id;
			else if (usuario.Manager.UserRole.Name != null)
				if (usuario.Manager.UserRole.Name.startsWith(sNmFuncBusc))
        			sIdMan = usuario.ManagerId;
			else if (usuario.Manager.Manager.UserRole.Name != null)
				if (usuario.Manager.Manager.UserRole.Name.startsWith(sNmFuncBusc))
        			sIdMan = usuario.Manager.ManagerId;
			else if (usuario.Manager.Manager.Manager.UserRole.Name != null)
				if (usuario.Manager.Manager.Manager.UserRole.Name.startsWith(sNmFuncBusc))
        			sIdMan = usuario.Manager.Manager.ManagerId;
        	//Mete al mapa los datos del usuario y su manager
        	if (sIdMan != null)
				mapIdUsrMgr.put(usuario.id, sIdMan);        			
       	}
    	System.debug('EN DCT_ComercialDirectory_cls.actualizaVigencia mapIdUsrMgr: ' + mapIdUsrMgr); 
		
		//Actualiza el canpo de DCT_IdManagerOwnReg__c para el dueño del reg de DirCom
		for (String sIdDirCom : directoryComercialNew.KeySet()){
	    	System.debug('EN DCT_ComercialDirectory_cls.actualizaVigencia sIdDirCom: ' + sIdDirCom);			
			//Busca al Manager del Owner
			if (mapIdUsrMgr.containsKey(directoryComercialNew.get(sIdDirCom).OwnerId)){
		    	System.debug('EN DCT_ComercialDirectory_cls.actualizaVigencia OwnerId: ' + mapIdUsrMgr.get(directoryComercialNew.get(sIdDirCom).OwnerId));			
				directoryComercialNew.get(sIdDirCom).DCT_IdManagerOwnReg__c = mapIdUsrMgr.get(directoryComercialNew.get(sIdDirCom).OwnerId);
				if (!setIdPerfilAdmin.contains(UserInfo.getProfileId()))
					directoryComercialNew.get(sIdDirCom).DCTVicePrincipal__c = mapIdUsrMgr.get(directoryComercialNew.get(sIdDirCom).OwnerId);				 
				if (setIdPerfilAdmin.contains(UserInfo.getProfileId()))
					directoryComercialNew.get(sIdDirCom).DCTVicePrincipal__c = '00515000006uPtN';
		    	System.debug('EN DCT_ComercialDirectory_cls.actualizaVigencia DCTVicePrincipal__c: ' + directoryComercialNew.get(sIdDirCom).DCTVicePrincipal__c + ' DCT_IdManagerOwnReg__c: ' + directoryComercialNew.get(sIdDirCom).DCT_IdManagerOwnReg__c + ' RecordTypeId: ' + directoryComercialNew.get(sIdDirCom).RecordTypeId);				
			}
			if (!mapIdUsrMgr.containsKey(directoryComercialNew.get(sIdDirCom).OwnerId)){
				directoryComercialNew.get(sIdDirCom).DCT_IdManagerOwnReg__c = '00515000006uPtN';
				directoryComercialNew.get(sIdDirCom).DCTVicePrincipal__c = '00515000006uPtN';
			}			
			if (directoryComercialNew.get(sIdDirCom).RecordTypeId == VaRtProspecto
				&& directoryComercialNew.get(sIdDirCom).DCTAuthorizationDateVoBoManagement__c != null
           		&& directoryComercialNew.get(sIdDirCom).DCTAskAuthorization__c == true
				){
		    	System.debug('EN DCT_ComercialDirectory_cls.actualizaVigencia DCTVicePrincipal__c2 VAL 2: ' + directoryComercialNew.get(sIdDirCom).RecordTypeId);					
				directoryComercialNew.get(sIdDirCom).RecordTypeId = VaRtCteProspInvestiga;
			}
			if (directoryComercialNew.get(sIdDirCom).RecordTypeId == VaRtProspecto
				&& directoryComercialNew.get(sIdDirCom).DCTResearchLegend__c == 'Procede Activación'
				){
		    	System.debug('EN DCT_ComercialDirectory_cls.actualizaVigencia DCTVicePrincipal__c2 VAL 2: ' + directoryComercialNew.get(sIdDirCom).RecordTypeId);					
				directoryComercialNew.get(sIdDirCom).RecordTypeId = VaRtCteProspInvestiga;
			}				
			//Si se trata de portabilidad actualiza el campo de DCTInvestigation__c = 'VI'
			if (directoryComercialNew.get(sIdDirCom).DCT_TypeOfProcedure__c == 'Portabilidad'
				&& directoryComercialOld.get(sIdDirCom).DCTInvestigation__c == NULL)
				directoryComercialNew.get(sIdDirCom).DCTInvestigation__c = 'VI';
				
	    	System.debug('EN DCT_ComercialDirectory_cls.actualizaVigencia DCTVicePrincipal__c3: ' + directoryComercialNew.get(sIdDirCom).RecordTypeId + ' ' + directoryComercialNew.get(sIdDirCom).DCTResearchLegend__c);								
		}//Fin del for para directoryComercialNew.Values()		
				
	}
	
	public static void actualizaPropietario(Map<id,Cliente__c> directoryComercialNew, Map<id,Cliente__c> directoryComercialOld){
		
		for (User usrDatos : [Select u.id, u.Profile.Name, u.ProfileId 
			From User u where id =: UserInfo.getUserId()]){
			System.debug('ENTRO A DCT_ComercialDirectory_cls.actualizaPropietario usrDatos: ' + usrDatos);
			if (usrDatos.Profile.Name != null)				
				sUsrActualPerfil = usrDatos.Profile.Name;
			System.debug('ENTRO A DCT_ComercialDirectory_cls.actualizaPropietario sUsrActualPerfil: ' + sUsrActualPerfil);
		}
 
		//Ve si se trata de un perfil de Admin, Coordinador() y Gerente de Ventas (GV)
		if  (!sUsrActualPerfil.startsWith('Administrador') && !sUsrActualPerfil.startsWith('Coordinacion')
			&& !sUsrActualPerfil.startsWith('GV') ){
				
		}//Fin si  sUsrActualPerfil es admin, corrd, GV
		
		DCT_TriggerExecutionControl_cls.setAlreadyBeenExecuted('DCT_ComercialDirectory_tgr');	
	}
	
	public static void updateReferRAPFolioSAP(Map<id,Cliente__c> directoryComercialNew, Map<id,Cliente__c> directoryComercialOld){
		System.debug('ENTRO A DCT_ComercialDirectory_cls.updateReferRAPFolioSAP...');
		
		String sIdDirComFolioSap = '';
		String sIdDirComRefRap = '';		
        Map<String, String> mapRecTypeDirCom = new Map<String, String>();
        
        for (RecordType rtEmb : [Select r.id, r.SobjectType, r.Name From RecordType r
				where r.SobjectType = 'Cliente__c' 
				And (Name Like '%Cliente Cauti%') 
				Order by Name]){
        	mapRecTypeDirCom.put(rtEmb.id, rtEmb.Name);
        }
		System.debug('ENTRO A DCT_ComercialDirectory_cls.updateReferRAPFolioSAP mapRecTypeDirCom: ' + mapRecTypeDirCom);
				
		//Consulta las opp de la lista newList                
		for (ID sIdDirCom : directoryComercialNew.KeySet()) {
			System.debug('ENTRO A DCT_ComercialDirectory_cls.updateReferRAPFolioSAP sIdDirCom: ' + sIdDirCom);			
			
            Cliente__c oldDirCom = directoryComercialOld.get( directoryComercialNew.get(sIdDirCom).Id );
            
            //Ve si la opp ya esta cerrada para mandar llamar el WA de Referencia RAP
            if(mapRecTypeDirCom.containsKey( directoryComercialNew.get(sIdDirCom).recordTypeId )){
            	if (directoryComercialNew.get(sIdDirCom).DCTFolio__c == NULL || directoryComercialNew.get(sIdDirCom).DCTFolio__c == '0')
					sIdDirComFolioSap += sIdDirCom + ',';
            	if (directoryComercialNew.get(sIdDirCom).DCTRapReference__c == NULL)
					sIdDirComRefRap += sIdDirCom + ',';
					
            }//Fin si mapRecTypeEmbudo.containsKey(opp.recordTypeId)
		}//Fin del for para directoryComercialNew.KeySet()

		System.debug('ENTRO A DCT_ComercialDirectory_cls.updateReferRAPFolioSAP sIdDirComFolioSap: ' + sIdDirComFolioSap + ' sIdDirComRefRap: ' + sIdDirComRefRap);                
        //Muy bien ya tienes los id de los reg que se van a actualizar mandalos al servicio web para el Folio
        if (sIdDirComFolioSap != null && sIdDirComFolioSap != '')        	
			DCT_Utils_cls.ActualizaFolioSAPDirCom(sIdDirComFolioSap);

        //Muy bien ya tienes los id de los reg que se van a actualizar mandalos al servicio web para la RefRap
        if (sIdDirComRefRap != null && sIdDirComRefRap != '')
        	//Para actualizar la ReferenciaRAP
			DCT_Utils_cls.ActualizaReferenciaRAPDirCom(sIdDirComRefRap);
		
	}

	//Manda llamar la actualización del estatus y la leyenda de investigación cuando se de da el Vo Bo
	public static void InsertInvestgaciones(Map<id,Cliente__c> directoryComercialNew){
		System.debug('ENTRO A DCT_ComercialDirectory_cls.InsertInvestgaciones...');
		
        Map<String, String> mapRecTypeDirCom = new Map<String, String>();
        
        //Consulta los tipos de registros
        for (RecordType rtEmb : [Select r.id, r.SobjectType, r.Name From RecordType r
				where r.SobjectType = 'Cliente__c' Order by Name]){
        	mapRecTypeDirCom.put(rtEmb.id, rtEmb.Name);
        }
		System.debug('ENTRO A DCT_ComercialDirectory_cls.InsertInvestgaciones mapRecTypeDirCom: ' + mapRecTypeDirCom);
				
		//Consulta las opp de la lista newList                
		for (String sIdDirCom : directoryComercialNew.KeySet()) {
			System.debug('ENTRO A DCT_ComercialDirectory_cls.InsertInvestgaciones sIdDirCom: ' + sIdDirCom);			
            //Ve si la opp ya esta cerrada para mandar llamar el WA de Referencia RAP
            if(mapRecTypeDirCom.containsKey( directoryComercialNew.get(sIdDirCom).recordTypeId) ){
				Cliente__c ClientePaso = directoryComercialNew.get(sIdDirCom);
				System.debug('ENTRO A DCT_ComercialDirectory_cls.InsertInvestgaciones ANTES DCTResultVerification__c: ' + ClientePaso.DCTResultVerification__c + ' DCTResearchLegend__c: ' + ClientePaso.DCTResearchLegend__c + ' DCTInvestigation__c: ' + ClientePaso.DCTInvestigation__c + ' DCTApprovalProcess__c: ' + ClientePaso.DCTApprovalProcess__c + ' DCTAskAuthorization__c: ' + ClientePaso.DCTAskAuthorization__c + ' DCTTypeAuthorization__c: ' + ClientePaso.DCTTypeAuthorization__c + ' DCTTypeAuthorization__c: ' + ClientePaso.DCTTypeAuthorization__c);
				//Si es positiva
				if (ClientePaso.DCTResultVerificationEsp__c == 'POSITIVA')
					DCT_Utils_cls.ActualizaInvestigacionesEsc1PosSI(ClientePaso.id, true);
            }//Fin si mapRecTypeEmbudo.containsKey(opp.recordTypeId)
		}//Fin del for para directoryComercialNew.KeySet()
					
	}
	
	//Manda llamar la actualización del estatus y la leyenda de investigación cuando se de da el Vo Bo
	public static void UpdateInvestgaciones(Map<id,Cliente__c> directoryComercialNew, Map<id,Cliente__c> directoryComercialOld){
		System.debug('ENTRO A DCT_ComercialDirectory_cls.updateInvestgaciones...');
		
		String sIdDirComInvesEsc1 = '';		
		String sIdDirComInvesEsc12 = '';
		String sIdDirComInvesEsc2 = '';				
		String sIdDirComInvesEsc3 = '';		
		String sIdDirComInvesEsc40 = '';		
		String sIdDirComInvesEsc4 = '';		
		String sIdDirComInvesEsc5 = '';		
		Boolean bActCampos = false;
        Map<String, String> mapRecTypeDirCom = new Map<String, String>();
        
        //Consulta los tipos de registros
        for (RecordType rtEmb : [Select r.id, r.SobjectType, r.Name From RecordType r
				where r.SobjectType = 'Cliente__c' Order by Name
				//AND (Name Like '%Cautivo%' OR Name Like '%Prospecto%') 
				]){
        	mapRecTypeDirCom.put(rtEmb.id, rtEmb.Name);
        }
		System.debug('ENTRO A DCT_ComercialDirectory_cls.updateInvestgaciones mapRecTypeDirCom: ' + mapRecTypeDirCom);
				
		//Consulta las opp de la lista newList                
		for (String sIdDirCom : directoryComercialNew.KeySet()) {
			System.debug('ENTRO A DCT_ComercialDirectory_cls.updateInvestgaciones sIdDirCom: ' + sIdDirCom);			
            Cliente__c oldDirCom = directoryComercialOld.get( directoryComercialNew.get(sIdDirCom).Id );    
			System.debug('ENTRO A DCT_ComercialDirectory_cls.updateInvestgaciones oldDirCom: ' + oldDirCom);
            //Ve si la opp ya esta cerrada para mandar llamar el WA de Referencia RAP
            if(mapRecTypeDirCom.containsKey( directoryComercialNew.get(sIdDirCom).recordTypeId) ){
				Cliente__c ClientePaso = directoryComercialNew.get(sIdDirCom);
				System.debug('ENTRO A DCT_ComercialDirectory_cls.updateInvestgaciones ANTES DCTResultVerification__c: ' + ClientePaso.DCTResultVerification__c + ' DCTResearchLegend__c: ' + ClientePaso.DCTResearchLegend__c + ' DCTInvestigation__c: ' + ClientePaso.DCTInvestigation__c + ' DCTApprovalProcess__c: ' + ClientePaso.DCTApprovalProcess__c + ' DCTAskAuthorization__c: ' + ClientePaso.DCTAskAuthorization__c + ' DCTTypeAuthorization__c: ' + ClientePaso.DCTTypeAuthorization__c + ' DCTTypeAuthorization__c: ' + ClientePaso.DCTTypeAuthorization__c);
				//Si es positiva
				if (oldDirCom.DCTResultVerificationEsp__c == NULL
					&& ClientePaso.DCTResultVerificationEsp__c == 'POSITIVA')
					DCT_Utils_cls.ActualizaInvestigacionesEsc1PosSI(ClientePaso.id, true);
				//Si es negativa
				if (oldDirCom.DCTResultVerificationEsp__c == NULL
					&& ClientePaso.DCTResultVerificationEsp__c == 'NEGATIVA')
					DCT_Utils_cls.ActualizaInvestigacionesEsc12Pos(ClientePaso.id, true);
				//Si la investigación es DCTInvestigation__c
				if (ClientePaso.DCTInvestigation__c != NULL
					&& ClientePaso.DCTInvestigation__c != oldDirCom.DCTInvestigation__c
					&& ClientePaso.DCTInvestigation__c == 'VI')
					DCT_Utils_cls.ActualizaInvestigacionesEsc5VI(ClientePaso.id, true);					
								
            	//Escenario 1 INVESTIGACIÒN POSITIVA
            	/*if (ClientePaso.DCTResultVerification__c == 'POSITIVA' 
            		&& ClientePaso.DCTResearchLegend__c != null
            		&& ClientePaso.DCTInvestigation__c == 'IT'
            		&& ClientePaso.DCTAskAuthorization__c == false            		
            		&& ClientePaso.DCTTotLineasAutorInvest__c != null
            		){
					System.debug('EN DCT_ComercialDirectory_cls.updateInvestgaciones VAL 1...');            			
					//Verifica si tiene proceso de aprobación pendientes
					if (!TieneProcesosApdoba(sIdDirCom))            			
						sIdDirComInvesEsc1 += sIdDirCom + ',';
            	}//Fin si*/
            	//Escenario 2.0 INVESTIGACIÒN NEGATIVA solicita aprobaciòn del subdirector            	
            	/*if (ClientePaso.DCTResultVerification__c == 'NEGATIVA' 
            		&& ClientePaso.DCTResearchLegend__c != null
            		&& ClientePaso.DCTInvestigation__c == 'IT' 
            		&& ClientePaso.DCTAskAuthorization__c == false
            		&& ClientePaso.DCTTotLineasAutorInvest__c == '0'
            		){
					System.debug('EN DCT_ComercialDirectory_cls.updateInvestgaciones VAL 2...');            			
					//Verifica si tiene proceso de aprobación pendientes
					if (!TieneProcesosApdoba(sIdDirCom))            			
						sIdDirComInvesEsc12 += sIdDirCom + ',';
            	}//Fin si*/            	
            	//Escenario 2.1 INVESTIGACIÒN NEGATIVA solicita aprobaciòn del subdirector            	
            	if (ClientePaso.DCTResultVerification__c == 'NEGATIVA' 
            		&& ClientePaso.DCTResearchLegend__c == 'Rechazar Activación'
            		&& ClientePaso.DCTInvestigation__c == 'IN'
            		&& ClientePaso.DCTAskAuthorization__c == true
            		&& (ClientePaso.DCTTypeAuthorization__c == 'Rechazado por Subdirector'
            			|| ClientePaso.DCTTypeAuthorization__c == 'Vo.Bo. Subdirector')
            		){
					System.debug('EN DCT_ComercialDirectory_cls.updateInvestgaciones VAL 3...');            			
					//Verifica si tiene proceso de aprobación pendientes
					if (!TieneProcesosApdoba(sIdDirCom))            			
						sIdDirComInvesEsc2 += sIdDirCom + ',';
            	}//Fin si
            	//Escenario 2.2 INVESTIGACIÒN NEGATIVA solicita aprobaciòn del subdirector            	
            	/*else if (ClientePaso.DCTResultVerification__c == 'NEGATIVA' 
            		&& ClientePaso.DCTResearchLegend__c != null
            		&& ClientePaso.DCTInvestigation__c == 'IT' 
            		&& ClientePaso.DCTAskAuthorization__c == true
            		&& ClientePaso.DCTTotLineasAutorInvest__c == '0'
            		){
					System.debug('EN DCT_ComercialDirectory_cls.updateInvestgaciones VAL 2.2...');            			
					//Verifica si tiene proceso de aprobación pendientes
					if (!TieneProcesosApdoba(sIdDirCom))            			
						sIdDirComInvesEsc12 += sIdDirCom + ',';
            	}//Fin si*/            	            	             		
            	//Escenario 3 NO TIENE INVESTIGACIÒN solicita aprobaciòn del subdirector            	
            	else if ( (ClientePaso.DCTResultVerification__c == null ||
						ClientePaso.DCTResultVerification__c == 'Sin Investigacion')
            		&& (ClientePaso.DCTResearchLegend__c == 'Rechazar Activación' ||
            			ClientePaso.DCTResultVerification__c == null)
            		&& ClientePaso.DCTInvestigation__c == 'SI'
            		&& ClientePaso.DCTApprovalProcess__c == false
            		&& ClientePaso.DCTAskAuthorization__c == true            		
            		&& ClientePaso.DCTTypeAuthorization__c == 'Vo.Bo. Subdirector'
            		){
					System.debug('EN DCT_ComercialDirectory_cls.updateInvestgaciones VAL 4...');            			
					//Verifica si tiene proceso de aprobación pendientes
					if (!TieneProcesosApdoba(sIdDirCom))            			
						sIdDirComInvesEsc3 += sIdDirCom + ',';
            	}//Fin si             		            	
            	//Escenario 4 TIENE INVESTIGACIÒN solicita aprobaciòn del subdirector            	
            	else if (ClientePaso.DCTResultVerification__c == null 
            		&& ClientePaso.DCTResearchLegend__c == 'Rechazar Activación'
            		&& ClientePaso.DCTInvestigation__c == 'IT'
            		&& ClientePaso.DCTApprovalProcess__c == false
            		&& ClientePaso.DCTAskAuthorization__c == true            		
            		&& ClientePaso.DCTTypeAuthorization__c == 'Rechazado por Subdirector'
            		){
					System.debug('EN DCT_ComercialDirectory_cls.updateInvestgaciones VAL 5...');            			
					//Verifica si tiene proceso de aprobación pendientes
					if (!TieneProcesosApdoba(sIdDirCom))            			
						sIdDirComInvesEsc40 += sIdDirCom + ',';
            	}//Fin si				
            	//Escenario 4 TIENE INVESTIGACIÒN solicita aprobaciòn del subdirector            	
            	else if ( (ClientePaso.DCTResultVerification__c == null ||
            			ClientePaso.DCTResultVerification__c == 'EN PROCESO')
            		&& ClientePaso.DCTResearchLegend__c == 'Rechazar Activación'
            		&& ClientePaso.DCTInvestigation__c == 'IT'
            		&& ClientePaso.DCTApprovalProcess__c == false
            		&& ClientePaso.DCTAskAuthorization__c == true            		
            		&& ClientePaso.DCTTypeAuthorization__c == 'Vo.Bo. Subdirector'
            		){
					System.debug('EN DCT_ComercialDirectory_cls.updateInvestgaciones VAL 6...');            			
					//Verifica si tiene proceso de aprobación pendientes
					if (!TieneProcesosApdoba(sIdDirCom))            			
						sIdDirComInvesEsc4 += sIdDirCom + ',';
            	}//Fin si
            	/*//Escenario 4 TIENE INVESTIGACIÒN solicita aprobaciòn del subdirector            	
            	else if ( (ClientePaso.DCTResultVerification__c == null 
       				|| ClientePaso.DCTResultVerification__c != null)
            		&& ClientePaso.DCTResearchLegend__c == null
            		&& ClientePaso.DCTInvestigation__c == 'VI'
            		&& ClientePaso.DCTApprovalProcess__c == false
            		&& ClientePaso.DCTAskAuthorization__c == false            		
            		&& ClientePaso.DCTTypeAuthorization__c == null
            		&& ClientePaso.DCTTotLineasAutorInvest__c == null            		
            		){
					System.debug('EN DCT_ComercialDirectory_cls.updateInvestgaciones VAL 7...');            			
					//Verifica si tiene proceso de aprobación pendientes
					if (!TieneProcesosApdoba(sIdDirCom))            			
						sIdDirComInvesEsc5 += sIdDirCom + ',';
            	}//Fin si*/            	
				System.debug('ENTRO A DCT_ComercialDirectory_cls.updateInvestgaciones DCTResultVerification__c: ' + ClientePaso.DCTResultVerification__c + ' DCTResearchLegend__c: ' + ClientePaso.DCTResearchLegend__c + ' DCTInvestigation__c: ' + ClientePaso.DCTInvestigation__c + ' DCTApprovalProcess__c: ' + ClientePaso.DCTApprovalProcess__c + ' DCTAskAuthorization__c: ' + ClientePaso.DCTAskAuthorization__c + ' DCTTypeAuthorization__c: ' + ClientePaso.DCTTypeAuthorization__c + ' DCTTypeAuthorization__c: ' + ClientePaso.DCTTypeAuthorization__c);            	
            }//Fin si mapRecTypeEmbudo.containsKey(opp.recordTypeId)
		}//Fin del for para directoryComercialNew.KeySet()
		
		System.debug('ENTRO A DCT_ComercialDirectory_cls.updateInvestgaciones sIdDirComInvesEsc1: ' + sIdDirComInvesEsc1 + ' sIdDirComInvesEsc2: ' + sIdDirComInvesEsc2 + ' sIdDirComInvesEsc3: ' + sIdDirComInvesEsc3 + ' sIdDirComInvesEsc4: ' + sIdDirComInvesEsc4 + ' sIdDirComInvesEsc12: ' + sIdDirComInvesEsc12 + ' sIdDirComInvesEsc40: ' + sIdDirComInvesEsc40 + ' sIdDirComInvesEsc5: ' + sIdDirComInvesEsc5 + ' bActCampos: ' + bActCampos);
        //Muy bien ya tienes los id de los reg que se van a actualizar mandalos al servicio web para el Folio
        //Escenario 1
        //if (sIdDirComInvesEsc1 != null && sIdDirComInvesEsc1 != '')//POSITIVA
		//	DCT_Utils_cls.ActualizaInvestigacionesEsc1Pos(sIdDirComInvesEsc1, bActCampos);
        //Escenario 2.1
        //if (sIdDirComInvesEsc12 != null && sIdDirComInvesEsc12 != '')//NEGATIVA
		//	DCT_Utils_cls.ActualizaInvestigacionesEsc12Pos(sIdDirComInvesEsc12, bActCampos);			
		//Escenario 2.2	
        if (sIdDirComInvesEsc2 != null && sIdDirComInvesEsc2 != '')//NEGATIVA
			DCT_Utils_cls.ActualizaInvestigacionesEsc2NegCAprob(sIdDirComInvesEsc2);
		//Escenario 3	
        if (sIdDirComInvesEsc3 != null && sIdDirComInvesEsc3 != '')//SI
			DCT_Utils_cls.ActualizaInvestigacionesEsc3SinInvestiga(sIdDirComInvesEsc3);
		//Escenario 40
        if (sIdDirComInvesEsc40 != null && sIdDirComInvesEsc40 != '')//TI
			DCT_Utils_cls.ActualizaInvestigacionesEsc4IT(sIdDirComInvesEsc40);			
		//Escenario 4
        if (sIdDirComInvesEsc4 != null && sIdDirComInvesEsc4 != '')//TI
			DCT_Utils_cls.ActualizaInvestigacionesEsc4IT(sIdDirComInvesEsc4);
		//Escenario 5			
        //if (sIdDirComInvesEsc5 != null && sIdDirComInvesEsc5 != '')//VI
		//	DCT_Utils_cls.ActualizaInvestigacionesEsc5VI(sIdDirComInvesEsc5);
			
	}
	
	public static Boolean TieneProcesosApdoba(String sIdReg){
		System.debug('EN TieneProcesosApdoba...');
		Boolean bTieneProcesoAproba = false;

		for (ProcessInstance objProcessInstance : [Select p.TargetObjectId, p.Status, p.ProcessDefinitionId, p.Id 
			From ProcessInstance p Where p.TargetObjectId =: sIdReg And Status = 'Pending']){
			bTieneProcesoAproba = true;
		}
				
		System.debug('EN TieneProcesosApdoba bTieneProcesoAproba: ' + bTieneProcesoAproba);
		return bTieneProcesoAproba;
	}
	
	
}