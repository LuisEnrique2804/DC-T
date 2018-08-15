@isTest
public class SingleRequestMock implements HttpCalloutMock {

    // Atributos de Instancia
    public Integer code        { get; set; }
    public String status       { get; set; }
    public String body         { get; set; }
    public Boolean isEncrypted { get; set; }
    public Map<String, String> mapResponseHeaders { get; set; }

    /**
     * Constructor con parámetros por defecto
     * @param  body        Cuerpo de la respuesta
     * @param  isEncrypted Indica si el cuerpo de la respuesta debería ser encriptado
     */
    public SingleRequestMock(String body) {
        this.body   = body;
        this.isEncrypted = false;
        this.code   = 200;
        this.status = 'OK';
    }

    /**
     * Constructor con parámetros por defecto
     * @param  body        Cuerpo de la respuesta
     * @param  isEncrypted Indica si el cuerpo de la respuesta debería ser encriptado
     */
    public SingleRequestMock(String body, Boolean isEncrypted) {
        this(body);
        this.isEncrypted = isEncrypted;
        this.code   = 200;
        this.status = 'OK';
    }

    /**
     * Constructor con distintas opciones para el mock de respuesta
     * @param  body        Cuerpo de la respuesta
     * @param  isEncrypted Indica si el cuerpo de la respuesta debería ser encriptado
     * @param  code        Código de respuesta HTTP
     * @param  status      Estatus de respuesta HTTP
     */
    public SingleRequestMock(String body, Boolean isEncrypted, Integer code, String status) {
        this(body, isEncrypted);
        this.code   = code;
        this.status = status;
    }

    /**
     * Constructor con distintas opciones para el mock de respuesta
     * @param  body            Cuerpo de la respuesta
     * @param  isEncrypted     Indica si el cuerpo de la respuesta debería ser encriptado
     * @param  code            Código de respuesta HTTP
     * @param  status          Estatus de respuesta HTTP
     * @param  mapExtraHeaders Cabeceras adicionales para la respuesta HTTP
     */
    public SingleRequestMock(String body, Boolean isEncrypted, Integer code, String status, Map<String, String> mapExtraHeaders) {
        this(body, isEncrypted, code, status);
        this.mapResponseHeaders = mapExtraHeaders;
    }

    /**
     * Respuesta falsa para la petición HTTP.
     */
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();

        // Cabeceras HTTP adicionales para la respuesta
        if (mapResponseHeaders != null) {
            for (String key : this.mapResponseHeaders.keySet()) {
                response.setHeader(key, this.mapResponseHeaders.get(key));
            }
        }

        response.setBody(this.body);
        response.setStatusCode(this.code);
        response.setStatus(this.status);

        return response;
    }

}