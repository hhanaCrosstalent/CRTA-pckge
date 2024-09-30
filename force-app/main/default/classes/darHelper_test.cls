@IsTest
private class darHelper_test {
    @IsTest
    private static void darHelper_test() {
        Offre_d_emploi__c offer = new Offre_d_emploi__c();
        insert offer;
        Recrutement__c options = new Recrutement__c(Nom_du_template_poste_et_candidatures__c='template');
        insert options;
        User thisUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        System.assert(thisUser != null);
        System.runAs(thisUser) {
            EmailTemplate template = new EmailTemplate(
                Name = 'template',
                DeveloperName = 'template',
                Subject = 'Test',
                TemplateType = 'text',
                Body = '{!offerId} {!offerName}',
                HtmlValue = '{!offerId} {!offerName}',
                FolderId = UserInfo.getUserId()
            );
            insert template;
            darHelper.sendOffer(offer.Id);
        }
    }
}