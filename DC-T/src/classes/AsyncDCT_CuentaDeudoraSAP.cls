//Generated by wsdl2apex

public class AsyncDCT_CuentaDeudoraSAP {
    public class RegistraCtaDeudoraResponseFuture extends System.WebServiceCalloutFuture {
        public String getValue() {
            DCT_CuentaDeudoraSAP.RegistraCtaDeudoraResponse response = (DCT_CuentaDeudoraSAP.RegistraCtaDeudoraResponse)System.WebServiceCallout.endInvoke(this);
            return response.return_x;
        }
    }
    public class AsyncSapCtaDeudoraWSPort {
        public String endpoint_x = 'http://10.188.90.120:7080/WSCuentaDeudoraWeb/SapCtaDeudoraWSService';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://webservices.ctadeudora.ddas.gis.sss.dfa.telcel.com/', 'DCT_CuentaDeudoraSAP'};
        public AsyncDCT_CuentaDeudoraSAP.RegistraCtaDeudoraResponseFuture beginRegistraCtaDeudora(System.Continuation continuation,String usuario,String password,String xmlConsultaStock) {
            DCT_CuentaDeudoraSAP.RegistraCtaDeudora request_x = new DCT_CuentaDeudoraSAP.RegistraCtaDeudora();
            request_x.usuario = usuario;
            request_x.password = password;
            request_x.xmlConsultaStock = xmlConsultaStock;
            return (AsyncDCT_CuentaDeudoraSAP.RegistraCtaDeudoraResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncDCT_CuentaDeudoraSAP.RegistraCtaDeudoraResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              'RegistraCtaDeudora',
              'http://webservices.ctadeudora.ddas.gis.sss.dfa.telcel.com/',
              'RegistraCtaDeudora',
              'http://webservices.ctadeudora.ddas.gis.sss.dfa.telcel.com/',
              'RegistraCtaDeudoraResponse',
              'DCT_CuentaDeudoraSAP.RegistraCtaDeudoraResponse'}
            );
        }
    }
}