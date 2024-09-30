public with sharing class FileDispatcherLWC {
   			
    
    public static HttpResponse dispatch(Id fileId, String fileName, String endpoint, String sourceKey,
            String syncParsing, String xApiKey, String xUserEmail) {

        Blob formData = HttpHexFormBuilderLWC.build().writeParam('source_key', sourceKey)
                .writeParam('sync_parsing', syncParsing).writeFile('file', fileName, fileId).getFormAsBlob();

        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setTimeout(120000);        
        request.setHeader('Connection', 'keep-alive');
        request.setHeader('Content-Length', String.valueOf(formData.size()));
        request.setHeader('Content-Type', HttpHexFormBuilderLWC.GetContentType());

        request.setHeader('x-api-key', xApiKey);
        request.setHeader('x-user-email', xUserEmail);

        request.setBodyAsBlob(formData);

        Http http = new Http();
        HttpResponse response = http.send(request);
        system.debug('response '+response);   
             
        return response;
    }
    
    
     

}