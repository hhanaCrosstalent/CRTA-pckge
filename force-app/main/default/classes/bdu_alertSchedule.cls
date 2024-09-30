//Security isCreateable() isUpdateable() isDeletable() checked
/**
*
*         Deprecated
*
* Static method used to schedule alerts for the BDU
* - Users outside the chatter group
*
* @author Crosstalent
* @group BDU-Backend
* @version 1.1
*/
global class bdu_alertSchedule implements Schedulable 
{    
    /*
    public static String CRON_EXP = '0 17 11 1-31 1-12 ? *';
    */ 
    global static String scheduleIt() {
        /*
        bdu_alertSchedule sm = new bdu_alertSchedule();
        return System.schedule('envoi de mail aux Sys. Admin. pour les utilisateurs hors GroupChatter', CRON_EXP, sm);
        */
        return 'deprecated';
    } 
    
    global void execute(SchedulableContext c){
        /*
        //Checks users outside the chatter group
        List<User> lst_user = [SELECT Id, name FROM User WHERE Id NOT IN (SELECT MemberId FROM CollaborationGroupMember) AND IsActive=true];
        if(lst_user.size()>0) {
            //Retrieves the System admin emails
            //Only french and english currently are supported 
            String admin_en = 'System Administrator';
            String admin_frs = 'Administrateur système';
            List<User> lst_adm = [SELECT Id, Name, Email FROM User 
                WHERE ProfileId IN (SELECT Id FROM Profile WHERE Name =: admin_en OR name = :admin_frs )];
                
            List<Messaging.SingleEmailMessage> lst_mails = new List<Messaging.SingleEmailMessage>();   

            //Creates an email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> toAddresses = new List<String>();
            for( User u1 : lst_adm ){
                toAddresses.add( u1.email );
            }
            
            //Fills the emails
            mail.setToAddresses(toAddresses);
            mail.setSubject('liste des utilisateurs hors groupChatter');
            String contenu = ' Ci-après la liste des utilisateurs qui ne sont inscrits dans aucun groupe Chatter:<br/>';
            contenu = contenu + '<ul>';
            for( User u2 : lst_user ){
                  contenu = contenu + '<li>' + u2.name + '</li>';
            }
            contenu = contenu + '</ul>';
            contenu = contenu + '<br/> Mail automatique du Système BDU.';
            mail.setHtmlBody( contenu );
            lst_mails.add( mail );
            
            //Sends the email
            Messaging.sendEmail( lst_mails ); 
        }
        */
    }
}