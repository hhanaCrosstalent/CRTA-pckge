/**
 * Created by Saad on 12/01/2022.
 */

public with sharing class FileLoaderService
{
    private final Integer SIZE_LIMIT = Integer.valueOf(Label.FileLoader_SizeLimit);
    private final String OVERSIZE_ERROR = Label.FileLoader_OversizeError;
    WsEngine.Logger logger = new WsEngine.Logger();

    public String sendFile(Id fileId)
    {  
        ContentVersion fileContentVersion = fetchLocalFile(fileId);
        
        String         fileName           = getFileName(fileContentVersion);
        Integer        fileSize           = fileContentVersion.ContentSize;

        if(validateFile(fileSize))
        {    
            return DragDropCVControllerLWC.uploadFile(fileName, fileId);
        }
        return OVERSIZE_ERROR;
    }

    /**
     * Retrieved the record that corresponds to the uploaded file.
     * This method is guaranteed to succeed if called through the standard salesforce file upload component, hence
     *  the absence of exception handling.
     *
     * @param fileId The ID of the file.
     *
     * @return The ContentVersion record corresponding to the uploaded file.
     */
    private ContentVersion fetchLocalFile(Id fileId)
        {   
        	return [
                SELECT
                        Title,
                        ContentSize,
                        FileExtension
                FROM
                        ContentVersion
                WHERE
                ContentDocumentId = :fileId AND
                IsLatest = TRUE
                LIMIT 1
        ];
            
    }

    private String getFileName(ContentVersion localDocument)
    { 
        return String.format('{0}.{1}', new List<String>{localDocument.Title, localDocument.FileExtension});
    }

    private Boolean validateFile(Integer fileSize)
    {
        if(fileSize > SIZE_LIMIT)
        {
            return false;
        }
        return true;
    }
    
    public  Boolean activateLogs(){
      Boolean logactive = [SELECT crta__Active__c FROM crta__logs_activation__c].crta__Active__c;
        if (logactive) {
          return true;
        }
        else {
            return false;
        }
  
    } 
    
    
     private void logMessage(String message)
    {
        logger.write(
                message,
                null,
                null
        );
        logger.flush();
    }
}