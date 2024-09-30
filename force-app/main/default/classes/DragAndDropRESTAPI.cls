@RestResource(urlMapping='/DragAndDrop/v1/*')
global with sharing class DragAndDropRESTAPI
{
    @HttpPost
    global static Id attachDoc() {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;

        String fName = req.params.get('FileName'); 
        if(fName != null) {
            System.debug('Got FileName');
            String parId = req.params.get('parId');  
            Blob postContent = req.requestBody; 
            String idJob = '';
            idJob = System.enqueueJob(new DragDropFactory(postContent, fName)); 
            System.debug('idJob :  ' +idJob);
            return idJob;
        }

        String jobId = req.params.get('jobId');
        System.debug('Got jobId: ' + jobId);
        return null;
   }
    
    public PageReference myActionInController()
    {
        
         System.debug('Je suis dans myActionInController');
        return null ;
    }
}