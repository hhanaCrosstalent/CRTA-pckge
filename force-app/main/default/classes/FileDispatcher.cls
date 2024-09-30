public with sharing class FileDispatcher {
    public static HttpResponse dispatch(String fileContent, String fileName, String endpoint, String sourceKey, 
            String syncParsing, String xApiKey, String xUserEmail) {
        
        Blob formData = HttpHexFormBuilder.build().writeParam('source_key', sourceKey)
            .writeParam('sync_parsing', syncParsing).writeFile('file', fileName, fileContent).getFormAsBlob();
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Connection', 'keep-alive');
        request.setHeader('Content-Length', String.valueOf(formData.size()));
        request.setHeader('Content-Type', HttpHexFormBuilder.GetContentType());
        
        request.setHeader('x-api-key', xApiKey);
        request.setHeader('x-user-email', xUserEmail);
        
        request.setBodyAsBlob(formData);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        return response;
    }
}