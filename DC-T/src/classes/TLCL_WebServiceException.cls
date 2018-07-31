/*******************************************************************************
Desarrollado por: Avanxo México
Autor: René Ayala
Proyecto: Telcel Directorio Comercial
Descripción: Clase que permite lanzar excepciones personalizadas.

Cambios (Versiones)
-------------------------------------
No.    Fecha      Autor                       Descripción
------ ---------- --------------------------  -----------   
0.1    04-02-2018 René Ayala Medina RAM       Creación
1.0    04-02-2018 René Ayala Medina RAM       Construcción y documentación         
*******************************************************************************/

public class TLCL_WebServiceException extends Exception{

    public EndpointSetting__mdt endpointSetting { get; set; }
    public String message     { get; set; }
    public String strRequest  { get; set; }
    public String strResponse { get; set; }
    
    public TLCL_WebServiceException(EndpointSetting__mdt endpointSetting, String message, String strRequest, String strResponse){
        this.endpointSetting = endpointSetting;
        this.message = message;
        this.strRequest = strRequest;
        this.strResponse = strResponse;
    }
}