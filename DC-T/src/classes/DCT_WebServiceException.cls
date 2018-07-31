public class DCT_WebServiceException extends Exception {
	public EndpointSetting__mdt endpointSetting { get; set; }
    public String message     { get; set; }
    public String strRequest  { get; set; }
    public String strResponse { get; set; }
    
    public DCT_WebServiceException(EndpointSetting__mdt endpointSetting, String message, String strRequest, String strResponse){
        this.endpointSetting = endpointSetting;
        this.message = message;
        this.strRequest = strRequest;
        this.strResponse = strResponse;
    }
}