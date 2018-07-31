/*******************************************************************************
Desarrollado por: Avanxo México
Autor: René Ayala
Proyecto: Telcel Directorio Comercial
Descripción: Clase de pruebas dedicada a probar llamados de servicios web (callouts).
Permite simular la respuesta en las pruebas de APEX test methods.

Cambios (Versiones)
-------------------------------------
No.    Fecha      Autor                       Descripción
------ ---------- --------------------------  -----------   
0.1    04-02-2018 René Ayala Medina RAM       Creación
0.2    04-02-2018 René Ayala Medina RAM       Construcción
*******************************************************************************/

@isTest
global class TLCL_GenericCallOutMock_mck implements HttpCalloutMock { 

    protected Integer code;
    protected String status;
    protected String body;
    protected Map<String, String> responseHeaders;

    global TLCL_GenericCallOutMock_mck(Integer code, String status, String body, Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status; 
        this.body = body;
        this.responseHeaders = responseHeaders;
    }

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        for (String key : this.responseHeaders.keySet()) {
            res.setHeader(key, this.responseHeaders.get(key));
        }
        res.setBody(this.body);
        res.setStatusCode(this.code);
        res.setStatus(this.status);
        return res;
    }

}