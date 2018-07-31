public class DCT_ServiceTokenResponse_wpr {
	//public RefreshTokenRs signToken;

	//public class RefreshTokenRs {
	//	public String signedToken;
	//	public String expiration;
	//}

	public class DtRespuestaTelcel{
 		public String access_token {get;set;}
 		public String token_type {get;set;} 		
 		public Integer expires_in {get;set;}
 		public String error {get;set;} 		
		public String error_description {get;set;} 		 		
 	}

	/*
        Método que convierte una cadena JSON a una instancia de la clase "AAZ_ServiceTokenResponse_wpr"
    */

	public static DCT_ServiceTokenResponse_wpr parse(String json) {
		DCT_ServiceTokenResponse_wpr wrappInstance = new DCT_ServiceTokenResponse_wpr();
		try{wrappInstance = (DCT_ServiceTokenResponse_wpr) System.JSON.deserialize(json, DCT_ServiceTokenResponse_wpr.class);}catch(SerializationException sE){}catch(Exception gE){}
		return wrappInstance;
	}
}