/**
 * Created by Saad on 12/01/2022.
 */

@SuppressWarnings('ApexUnusedDeclaration')
public with sharing class FileLoaderController
{
    public class FileLoaderException extends Exception{}
    private static String message         = '';
    private static final  String TECHNICAL_ERROR = Label.FileLoader_TechnicalError;

    @AuraEnabled(Cacheable=false)
    public static String sendToParser(Id fileId)
    {
        try
        {
            FileLoaderService service = new FileLoaderService();
            message = service.sendFile(fileId);
        }
        catch(FileLoaderException e)
        {
            message = TECHNICAL_ERROR + e.getMessage();
            system.debug('message '+message);
        }
        finally
        {
            Database.delete(fileId, false);
        }

        return message;
    }
}