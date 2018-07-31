public class DCT_UserResponseWrapper_wpr {
	public AddUserRs signToken;
    public Errors genericResponse;
    public Boolean isSuccessful;

    public class AddUserRs {
        public String username;
        public String signedToken;
        public String expiration;
    }

    public class Errors{
        public Error Response;  
    }

    public class Error{
        public String code;
        public String message;       
    }

    /*
        Método que convierte una cadena JSON a una instancia de la clase "DCT_UserResponseWrapper_wpr"
    */

    public static DCT_UserResponseWrapper_wpr parse(String json) {
        DCT_UserResponseWrapper_wpr wrappInstance = new DCT_UserResponseWrapper_wpr();
        try{wrappInstance = (DCT_UserResponseWrapper_wpr) System.JSON.deserialize(json, DCT_UserResponseWrapper_wpr.class);}catch(SerializationException sE){}catch(Exception gE){}
        System.debug(loggingLevel.Error, '*** wrappInstance: ' + wrappInstance);
        return wrappInstance;
    }
}