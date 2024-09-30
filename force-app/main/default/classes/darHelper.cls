//Security isCreateable() isUpdateable() isDeletable() checked
global class darHelper {
    
        /**
         * Sends an email to a job offer manager with a public link to view it
         * @param  ID offerId       Id of the offer to view
         */
        WebService static String sendOffer( ID offerId ) {
                List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
                Recrutement__c options = [SELECT Nom_du_template_poste_et_candidatures__c FROM Recrutement__c LIMIT 1];

                try {
                        Offre_d_emploi__c offre = [SELECT CT_Email_Manager__c, Name FROM Offre_d_emploi__c WHERE Id=:offerId];
                        EmailTemplate modele = [SELECT Subject, HtmlValue 
                                                FROM EmailTemplate 
                                                WHERE developername= :options.Nom_du_template_poste_et_candidatures__c];
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        String[] toAddresses = new String[] {offre.CT_Email_Manager__c};
                        mail.setToAddresses(toAddresses);
                        mail.setSubject(modele.Subject);
                        String contenu = modele.HtmlValue;
                        contenu = contenu.replace('{!offerId}',offre.id); 
                        contenu = contenu.replace('{!offerName}',offre.Name); 
                        mail.setHtmlBody( contenu );
                        
                        emailList.add( mail );      
                        if ( !Test.isRunningTest() && emailList.size()>0 ){
                            Messaging.sendEmail( emailList );
                        }
                        return 'Email envoyé avec succès.';
                }
                catch( Exception e) {
                    return e.getMessage()+' à la ligne '+ e.getLineNumber();
                } 
        }
}