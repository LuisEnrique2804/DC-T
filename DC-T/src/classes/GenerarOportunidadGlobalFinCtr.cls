public with sharing class GenerarOportunidadGlobalFinCtr {
	public String msjResultado{get;set;}
	
	public GenerarOportunidadGlobalFinCtr(){
		this.msjResultado = ApexPages.currentPage().getParameters().get('msjResultado');
	}
	
	public PageReference salir(){
		return new PageReference('/home/home.jsp');
	}
}