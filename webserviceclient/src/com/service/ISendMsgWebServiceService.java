
package com.service;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.logging.Logger;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import javax.xml.ws.WebEndpoint;
import javax.xml.ws.WebServiceClient;
import javax.xml.ws.WebServiceFeature;


/**
 * This class was generated by the JAX-WS RI.
 * JAX-WS RI 2.1.6 in JDK 6
 * Generated source version: 2.1
 * 
 */
@WebServiceClient(name = "ISendMsgWebServiceService", targetNamespace = "http://webservice.service.sms.com/", wsdlLocation = "http://192.168.218.227:8089/smsservice/services/sendMsg?wsdl")
public class ISendMsgWebServiceService
    extends Service
{

    private final static URL ISENDMSGWEBSERVICESERVICE_WSDL_LOCATION;
    private final static Logger logger = Logger.getLogger(com.service.ISendMsgWebServiceService.class.getName());

    static {
        URL url = null;
        try {
            URL baseUrl;
            baseUrl = com.service.ISendMsgWebServiceService.class.getResource(".");
            url = new URL(baseUrl, "http://192.168.218.227:8089/smsservice/services/sendMsg?wsdl");
        } catch (MalformedURLException e) {
            logger.warning("Failed to create URL for the wsdl Location: 'http://192.168.218.227:8089/smsservice/services/sendMsg?wsdl', retrying as a local file");
            logger.warning(e.getMessage());
        }
        ISENDMSGWEBSERVICESERVICE_WSDL_LOCATION = url;
    }

    public ISendMsgWebServiceService(URL wsdlLocation, QName serviceName) {
        super(wsdlLocation, serviceName);
    }

    public ISendMsgWebServiceService() {
        super(ISENDMSGWEBSERVICESERVICE_WSDL_LOCATION, new QName("http://webservice.service.sms.com/", "ISendMsgWebServiceService"));
    }

    /**
     * 
     * @return
     *     returns ISendMsgWebService
     */
    @WebEndpoint(name = "ISendMsgWebServicePort")
    public ISendMsgWebService getISendMsgWebServicePort() {
        return super.getPort(new QName("http://webservice.service.sms.com/", "ISendMsgWebServicePort"), ISendMsgWebService.class);
    }

    /**
     * 
     * @param features
     *     A list of {@link javax.xml.ws.WebServiceFeature} to configure on the proxy.  Supported features not in the <code>features</code> parameter will have their default values.
     * @return
     *     returns ISendMsgWebService
     */
    @WebEndpoint(name = "ISendMsgWebServicePort")
    public ISendMsgWebService getISendMsgWebServicePort(WebServiceFeature... features) {
        return super.getPort(new QName("http://webservice.service.sms.com/", "ISendMsgWebServicePort"), ISendMsgWebService.class, features);
    }

}
