@isTest
public class MultiRequestMock implements HttpCalloutMock {
    /**
     * Mapa de objetos Mock identificados por endpoint
     */
    protected Map<String, HttpCalloutMock> mapResponses;

    /**
     * Constructor sin parámetros
     */
    public MultiRequestMock() {
        this.mapResponses = new Map<String, HttpCalloutMock>();
    }

    /**
     * Constructor con parámetros
     * @param  mapResponses Mapa de objetos mock de respuesta
     */
    public MultiRequestMock(Map<String, HttpCalloutMock> mapResponses) {
        this.mapResponses = mapResponses;
    }

    /**
     * Respuesta falsa para el llamado a servicio
     * @param  request Objeto Request
     * @return         Objeto Response
     */
	public HttpResponse respond(HttpRequest request) {
        HttpCalloutMock responseMock = this.mapResponses.get(request.getEndpoint());

        if (responseMock != null) {
            return responseMock.respond(request);
        } else {
            throw new ResponseMockException('Mock no válido');
        }
    }

    /**
     * Agregar un nuevo mock al mapa
     * @param endpoint     Endpoint identificador del objeto Mock
     * @param responseMock Objeto mock de respuesta
     */
    public void addRequestMock(String endpoint, HttpCalloutMock responseMock) {
        this.mapResponses.put(endpoint, responseMock);
    }

    /**
     * Excepción personalizada para generación de Mock de respuesta
     */
    public class ResponseMockException extends Exception {}

}