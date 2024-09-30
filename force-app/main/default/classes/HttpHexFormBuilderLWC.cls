/**
 * Created by Saad on 20/01/2022.
 */

// https://github.com/nicolas1bruno/multipart-data-apex-request
public class HttpHexFormBuilderLWC {
    private final static string BOUNDARY = '----sfdc-multi-form';
    private String form ;

    public HttpHexFormBuilderLWC() {
        form = '';
    }

    public static HttpHexFormBuilderLWC build(){
        return new HttpHexFormBuilderLWC();
    }

    public static String getBoundary() {
        return BOUNDARY;
    }

    public static string GetContentType() {
        return 'multipart/form-data; boundary="' + BOUNDARY + '"';
    }

    private HttpHexFormBuilderLWC writeFooter(){
        this.form += EncodingUtil.convertToHex( Blob.valueOf( '--' + BOUNDARY + '--' ) );
        return this;
    }

    public HttpHexFormBuilderLWC writeParam( String key, String value ) {
        String body = '--' + BOUNDARY;
        body += '\r\nContent-Disposition: form-data; name="' + key + '";\r\n\r\n' + value + '\r\n';

        this.form += EncodingUtil.convertToHex( Blob.valueOf( body ) );
        return this;
    }

    /*public HttpHexFormBuilderLWC writeFile( String key, String fileName, String fileContent ){
        String mimeType = resolveMimeType(fileName);

        String content = '--' + BOUNDARY;
        content += '\r\nContent-Disposition: form-data; name="' + key + '"; filename="' + fileName + '";\r\nContent-Type: ' + mimeType + ';\r\n\r\n';
        content = EncodingUtil.convertToHex( Blob.valueOf( content ) );

        content += EncodingUtil.convertToHex( EncodingUtil.base64Decode( fileContent ) );
        content += EncodingUtil.convertToHex( Blob.valueOf( '\r\n' ) );
        this.form += content;
        return this;
    }*/

    public HttpHexFormBuilderLWC writeFile( String key, String fileName, Id fileId ){
        this.form += String.format(
                '{0}{1}{2}{3}',
                new List<String>{
                        EncodingUtil.convertToHex( Blob.valueOf( String.format(
                                '--{0}\r\nContent-Disposition: form-data; name="{1}"; filename="{2}";\r\nContent-Type: {3};\r\n\r\n',
                                new List<String>{
                                        BOUNDARY,
                                        key,
                                        fileName,
                                        resolveMimeType(fileName)
                                }
                        )
                        )),
                        EncodingUtil.convertToHex( fetchLocalFileContent(fileId) ),
                        EncodingUtil.convertToHex( Blob.valueOf( '\r\n' ) ),
                        EncodingUtil.convertToHex( Blob.valueOf( '--' + BOUNDARY + '--' ) )
                }
        );
        return this;
    }

    public String getFormAsString() {
        this.writeFooter();
        return this.form;
    }

    public Blob getFormAsBlob() {
        return EncodingUtil.convertFromHex( this.form );
    }

    @TestVisible private static String resolveMimeType(String fileName) {
        String fileType = fileName.substringAfterLast('.');
        String mimeType = 'image/png';
        if (fileType.equalsIgnoreCase('png')) {
            mimeType = 'image/png';
        } else if (fileType.equalsIgnoreCase('jpeg') || fileType.equalsIgnoreCase('jpg')) {
            mimeType = 'image/jpg';
        } else if (fileType.equalsIgnoreCase('pgm')) {
            mimeType = 'image/x-portable-graymap';
        } else if (fileType.equalsIgnoreCase('ppm')) {
            mimeType = 'image/x-portable-pixmap';
        } else if (fileType.equalsIgnoreCase('pdf')) {
            mimeType = 'application/pdf';
        }
        return mimeType;
    }

    private Blob fetchLocalFileContent(Id fileId)
    {
        return [
                SELECT
                        VersionData
                FROM
                        ContentVersion
                WHERE
                ContentDocumentId = :fileId AND
                IsLatest = TRUE
                LIMIT 1
        ].VersionData;
    }
}