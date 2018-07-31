global class DCT_ResponseSISACactiva_cls {
	global Boolean       esExitoso; 
	global List<Info1y7> resultadoMetodo17;
	global List<Info2y8> resultadoMetodo28;
	global List<Info6y9> resultadoMetodo69;
	global List<Info3>   resultadoMetodo3;
	global List<Info4>   resultadoMetodo4;
	global List<Info5>   resultadoMetodo5;
	global List<Info10>  resultadoMetodo10;
	global List<Info11>  resultadoMetodo11;
	global List<Error>   listaErrores;

	global class Error{
		global String codigo;
		global String descripcion;
	}
	global class Info2y8 {
		global String LeyendaInvestigacion;
		global String FuerzaVentaAtiendenCliente;
		global String FuerzaVentaEjecutivo;
		global String FuerzaVentaServicioVoz;
		global String FuerzaVentaServicioDatos;
		global String CicloFacturacion;
		global String ClaseCredito;
		global String TipoCuenta;
		global String TarifasAutorizada;
		global String GrupoPlan;
		global String FuerzaVentaPromocionVentaEmpleado;
		global String FuerzaVentaRenovacionAdendum;
		global String FuerzaVentaCambioSim;
		global String Rfc;
		global String AdendumAnticipado;
		global String PlazoDiasAdendum;
		global Boolean BonificaPenalizacion;
		global String UsuarioXO;
		global String PuedeActivarVPN;
		global String FuerzadeVentaActivarVPN;
	}
	global class Info1y7 {
		global String LeyendaInvestigacion;
		global String RazonSocial; 
		global String FuerzaVentaAtiendenCliente;
		global String FuerzaVentaEjecutivo;
		global String FuerzaVentaServicioVoz;
		global String FuerzaVentaServicioDatos;
		global String CicloFacturacion;
		global String ClaseCredito;
		global String TipoCuenta;
		global String TarifasAutorizada;
		global String GrupoPlan;
		global String FuerzaVentaPromocionVentaEmpleado;
		global String FuerzaVentaRenovacionAdendum;
		global String FuerzaVentaCambioSim;
		global String AdendumAnticipado;
		global String PlazoDiasAdendum;
		global Boolean BonificaPenalizacion;
		global String UsuarioXO;
		global String PuedeActivarVPN;
		global String FuerzadeVentaActivarVPN;
	}
	global class Info6y9 {
		global String LeyendaInvestigacion;
		global String FuerzaVentaAtiendenCliente;
		global String FuerzaVentaEjecutivo;
		global String FuerzaVentaServicioVoz;
		global String FuerzaVentaServicioDatos;
		global String CicloFacturacion;
		global String ClaseCredito;
		global String TipoCuenta;
		global String TarifasAutorizada;
		global String GrupoPlan;
		global String FuerzaVentaPromocionVentaEmpleado;
		global String FuerzaVentaRenovacionAdendum;
		global String FuerzaVentaCambioSim;
		global String AdendumAnticipado;
		global String PlazoDiasAdendum;
		global Boolean BonificaPenalizacion;
		global String UsuarioXOEjecutivo;
		global String PuedeActivarVPN;
		global String FuerzadeVentaActivarVPN;
	}
	global class Info3 {
		global String RazonSocial; 
		global String DireccionFiscal;
		global String DireccionCorrespondencia;
		global String Id;
	}
	global class Info4 {
		global String RazonSocial; 
		global String UsuarioXO; 
	}
	global class Info5 {
		global String RazonSocial; 
		global String Rfc; 
	}
	global class Info10 {
		global String FuerzaVentaEjecutivo;
		global String UsuarioXO; 
	}

	global class Info11 {
		global String UsuarioXO; 
	}
}