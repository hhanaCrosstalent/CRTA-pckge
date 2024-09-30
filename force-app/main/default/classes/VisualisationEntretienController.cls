//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Controller for the interview page
 */
public with sharing class VisualisationEntretienController {

    public String contactId {get; set; }
    public EI_entretien__c interview {get; set; }
    public List<Attachment> attachments {get; set; }
    public List<GS_Affectation_poste__c> positions {get; set; }
    public List<EI_ligne_objectif__c> objectives {get; set; }
    public List<EI_ligne_objectif__c> pastObjectives {get; set; }
    public List<EI_ligne_competence__c> skills {get; set; }
    public List<Formation__c> pastTrainings {get; set; }
    public List<Formation__c> plannedTrainings {get; set; }
    public Integer ReadOnly {get; set;}
    public String attachIdToDel{get; set;}
    public String objIdToDel{get; set;}
    public String skillIdToDel{get; set;}
    public Boolean isPreview { get; set; }
    public Attachment attachment {
        get {
            if(attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }


    /**
     * Retrieves an interview and its misc. children objects
     */
    public VisualisationEntretienController() {
        contactId = sirhTemplateController.contactId;
        String preview = ApexPages.currentPage().getParameters().get('apercu');
        isPreview = (preview == '1') ? true : false;

        //Interview query
        interview = InterviewRepository.getById(ApexPages.currentPage().getParameters().get('id'));

        //Interview's children objects
        attachments = [SELECT Id, Description, Name, LastModifiedDate 
                       FROM Attachment 
                       WHERE ParentId = :interview.id];
        positions = [SELECT Id, GS_date_de_debut__c,GS_date_de_fin__c, GS_fiche_de_poste__c, GS_fiche_de_poste__r.Id, 
                            GS_fiche_de_poste__r.Name 
                     FROM GS_affectation_poste__c 
                     WHERE GS_salarie__c = :interview.EI_Salarie_qui_passe_l_entretien__c];
        objectives = [SELECT EI_description__c, EI_Objectif_evalue_par_le_manager__c,
                            EI_Objectif_evalue_par_le_salarie__c, EI_commentaire_manager__c,
                            EI_commentaire_salarie__c, EI_Ponderation_d_objectifs__c, EI_Conditions_de_reussite__c
                      FROM EI_ligne_objectif__c
                      WHERE EI_Entretien__c = :interview.Id];
        skills = [SELECT EI_Libelle_de_competence__c, EI_Description_de_la_competence__c, 
                    IE_competence_evaluee_par_le_manager__c,IE_competence_evaluee_par_le_salarie__c, 
                    IE_commentaire_manager__c, IE_commentaire_salarie__c 
                  FROM EI_ligne_competence__c 
                  WHERE IE_Entretien__c = :interview.Id];
        pastTrainings = [SELECT CT_Start_date__c, FO_Nom_de_la_formation__c, FO_statut__c, 
                            FO_Catalogue_de_formation__r.name, 
                            FO_Catalogue_de_formation__r.FO_organisme_de_formation__c, 
                            FO_Catalogue_de_formation__r.FO_organisme_de_formation__r.Name 
                         FROM Formation__c 
                         WHERE CT_Candidate__c = :interview.EI_Salarie_qui_passe_l_entretien__c 
                         AND FO_statut__c LIKE '9%'];
        plannedTrainings = [SELECT CT_Start_date__c, FO_Nom_de_la_formation__c, FO_statut__c, 
                                FO_Catalogue_de_formation__r.name, 
                                FO_Catalogue_de_formation__r.FO_organisme_de_formation__c, 
                                FO_Catalogue_de_formation__r.FO_organisme_de_formation__r.Name
                            FROM Formation__c
                            WHERE CT_Candidate__c = :interview.EI_Salarie_qui_passe_l_entretien__c 
                            AND (NOT FO_statut__c LIKE '9%') ];

        try {
            Id pastInterview =[SELECT Id 
                               FROM EI_entretien__c 
                               WHERE EI_Salarie_qui_passe_l_entretien__c=:interview.EI_Salarie_qui_passe_l_entretien__c 
                               AND EI_Date_de_l_entretien__c < :interview.EI_Date_de_l_entretien__c 
                               AND RecordType.DeveloperName='Entretien_Read_Only' ORDER BY EI_Date_de_l_entretien__c  DESC 
                               LIMIT 1].Id;
            pastObjectives = [SELECT EI_description__c, EI_Objectif_evalue_par_le_manager__c,EI_Objectif_evalue_par_le_salarie__c, EI_commentaire_manager__c, EI_commentaire_salarie__c,EI_Ponderation_d_objectifs__c,EI_Conditions_de_reussite__c 
                              FROM EI_ligne_objectif__c 
                              WHERE EI_Entretien__c =:pastInterview];
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        if(interview.Recordtype.developername=='Entretien_Read_Only') {
            ReadOnly=1;
        } else {
            ReadOnly=0;
        }
    }

    /**
     * Remote action triggered when an object div is dropped
     * Updates the order of said blocks in a custom setting
     * @return String Status of the update
     */
    @RemoteAction
    public static String updateOrder(String order) {
        if (
            Schema.sObjectType.EI__c.isUpdateable()
            && Schema.sObjectType.EI__c.fields.reviewBlocksOrder__c.isUpdateable()
        ) {
            EI__c options = [SELECT ReviewBlocksOrder__c FROM EI__c];
            options.reviewBlocksOrder__c = order;
            try {
                update options;
                return 'success';
            } catch(Exception e) {
                return e.getMessage();
            }
        } else {
            return System.Label.Permission;
        }
    }

    /**
     * Remote action to update a skill object
     * Triggered on click in the modal window
     * @return String Status of the update
     */
    @RemoteAction
    public static String updateSkill(String updateString) {
        if (
            Schema.sObjectType.EI_ligne_competence__c.isUpdateable()
        ) {
            Map<String, Object> updateValues = (Map<String, Object>)JSON.deserializeUntyped(updateString);
            EI_ligne_competence__c skill = [SELECT IE_competence_evaluee_par_le_manager__c,IE_competence_evaluee_par_le_salarie__c, IE_commentaire_manager__c, IE_commentaire_salarie__c 
                                            FROM EI_ligne_competence__c 
                                            WHERE Id = :String.valueOf(updateValues.get('id'))];
            if(
                updateValues.get('isManager') == '1'
            	&& Schema.sObjectType.EI_ligne_competence__c.fields.IE_Commentaire_Manager__c.isUpdateable()
            	&& Schema.sObjectType.EI_ligne_competence__c.fields.IE_Competence_evaluee_par_le_manager__c.isUpdateable()
            ) {
                skill.IE_Commentaire_Manager__c = String.valueOf(updateValues.get('comment'));
                skill.IE_Competence_evaluee_par_le_manager__c = String.valueOf(updateValues.get('eval'));
            } else if (
                Schema.sObjectType.EI_ligne_competence__c.fields.IE_Commentaire_salarie__c.isUpdateable()
            	&& Schema.sObjectType.EI_ligne_competence__c.fields.IE_Competence_evaluee_par_le_salarie__c.isUpdateable()
            ) {
                skill.IE_Commentaire_salarie__c = String.valueOf(updateValues.get('comment'));
                skill.IE_Competence_evaluee_par_le_salarie__c = String.valueOf(updateValues.get('eval'));
            }

            try {
                update skill;
                return 'success';
            } catch(Exception e) {
                if(e.getTypeName() == 'System.DmlException') {
                    return System.Label.SI_Error_skill_update.replace('{0}', e.getDmlMessage(0));
                } 
                return System.Label.SI_Error_skill_update.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.Permission;
        }
    }

    /**
     * Remote action to update an objective object
     * Triggered on click in the modal window
     * @return String Status of the update
     */
    @RemoteAction
    public static String updatePastObjective(String updateString) {
        if (
            Schema.sObjectType.EI_ligne_objectif__c.isUpdateable()
        ) {
            Map<String, Object> updateValues = (Map<String, Object>)JSON.deserializeUntyped(updateString);
            EI_Ligne_objectif__c objective = [SELECT EI_Commentaire_manager__c, EI_Objectif_evalue_par_le_manager__c, EI_Objectif_evalue_par_le_salarie__c, EI_Commentaire_salarie__c 
                                              FROM EI_ligne_objectif__c 
                                              WHERE Id = :String.valueOf(updateValues.get('id'))];

            if(
                updateValues.get('isManager') == '1'
            	&& Schema.sObjectType.EI_ligne_objectif__c.fields.EI_Commentaire_manager__c.isUpdateable()
            	&& Schema.sObjectType.EI_ligne_objectif__c.fields.EI_Objectif_evalue_par_le_manager__c.isUpdateable()
            ) {
                objective.EI_Commentaire_manager__c = String.valueOf(updateValues.get('comment'));
                objective.EI_Objectif_evalue_par_le_manager__c = String.valueOf(updateValues.get('eval'));
            } else if (
                Schema.sObjectType.EI_ligne_objectif__c.fields.EI_Commentaire_salarie__c.isUpdateable()
            	&& Schema.sObjectType.EI_ligne_objectif__c.fields.EI_Objectif_evalue_par_le_salarie__c.isUpdateable()
            ) {
                objective.EI_Commentaire_salarie__c = String.valueOf(updateValues.get('comment'));
                objective.EI_Objectif_evalue_par_le_salarie__c = String.valueOf(updateValues.get('eval'));
            }
            try {
                update objective;
                return 'success';
            } catch(Exception e) {
                if(e.getTypeName() == 'System.DmlException') {
                    return System.Label.SI_Error_objective_update.replace('{0}', e.getDmlMessage(0));
                } 
                return System.Label.SI_Error_objective_update.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.Permission;
        }
    }

    /**
     * Remote action to update an objective object
     * Triggered on click in the modal window
     * @return String Status of the update
     */
    @RemoteAction
    public static String updateFutureObjective(String updateString) {
        if (
            Schema.sObjectType.EI_ligne_objectif__c.isUpdateable()
            && Schema.sObjectType.EI_ligne_objectif__c.fields.EI_Ponderation_d_objectifs__c.isUpdateable()
            && Schema.sObjectType.EI_ligne_objectif__c.fields.EI_Description__c.isUpdateable()
            && Schema.sObjectType.EI_ligne_objectif__c.fields.EI_Conditions_de_reussite__c.isUpdateable()
        ) {
            Map<String, Object> updateValues = (Map<String, Object>)JSON.deserializeUntyped(updateString);
            EI_Ligne_objectif__c objective = [SELECT EI_description__c, EI_Ponderation_d_objectifs__c,EI_Conditions_de_reussite__c 
                                              FROM EI_ligne_objectif__c 
                                              WHERE Id = :String.valueOf(updateValues.get('id'))];
            objective.EI_Ponderation_d_objectifs__c = Integer.valueOf(updateValues.get('weighting'));
            objective.EI_Description__c = String.valueOf(updateValues.get('description'));
            objective.EI_Conditions_de_reussite__c = String.valueOf(updateValues.get('success'));
            try {
                update objective;
                return 'success';
            } catch(Exception e) {
                if(e.getTypeName() == 'System.DmlException') {
                    return System.Label.SI_Error_objective_update.replace('{0}', e.getDmlMessage(0));
                } 
                return System.Label.SI_Error_objective_update.replace('{0}', e.getMessage());
            }
        } else {
            return System.Label.Permission;
        }
    }

    /**
     * Deletes the specified attachments
     *
     * @return Current page
     */
    public PageReference delAttachment(){
        PageReference redirect = ApexPages.currentPage();
        redirect.setRedirect(true);
        if(!Schema.sObjectType.Attachment.isDeletable()
                || !EI_entretien__c.sObjectType.getDescribe().isDeletable()) {
            System.debug('User does not have sufficient rights.');
            return redirect;
        }
        try {
            Attachment AttachmenttoDel = [SELECT Id FROM Attachment WHERE Id = :attachIdToDel];
            delete AttachmenttoDel;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        return redirect;
    }

    /**
     * Deletes the specified objective
     *
     * @return Current page
     */
    public PageReference delObjective() {
        if(!EI_ligne_objectif__c.sObjectType.getDescribe().isDeletable()) {
            System.debug('User does not have sufficient rights.');
            return null;
        }
        try {
            EI_ligne_objectif__c ObjToDel = [SELECT Id FROM EI_ligne_objectif__c WHERE Id = :objIdToDel];
            delete ObjToDel;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }

        PageReference redirect = ApexPages.currentPage();
        redirect.setRedirect(true);
        return redirect;
    }

    /**
     * Deletes the specified skill
     *
     * @return Current page
     */
    public PageReference delSkill() {
        if(!EI_ligne_competence__c.sObjectType.getDescribe().isDeletable()) {
            System.debug('User does not have sufficient rights.');
            return null;
        }
        try {
            EI_ligne_competence__c skillToDel = [SELECT Id FROM EI_ligne_competence__c WHERE Id = :skillIdToDel];
            delete skillToDel;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }

        PageReference redirect = ApexPages.currentPage();
        redirect.setRedirect(true);
        return redirect;
    }


    /**
     * Saves the current interview and its children objects
     *
     * @return Current page
     */
    public void save() {
        if (
            Schema.sObjectType.EI_entretien__c.isUpdateable()
            && Schema.sObjectType.EI_ligne_objectif__c.isUpdateable()
            && Schema.sObjectType.EI_ligne_competence__c.isUpdateable()
            && Schema.sObjectType.Formation__c.isUpdateable()
        ) {
            update interview;
            update objectives;
            update skills;
            update plannedTrainings;
        } else {
            System.debug(System.Label.Permission);
        }
    }


    /**
     * Adds an objective to the current interview
     *
     * @return Current page
     */
    public PageReference addObjective() {
        save();
        if(!Schema.sObjectType.EI_ligne_objectif__c.fields.EI_Entretien__c.isCreateable()) {
            System.debug('User does not have sufficient rights.');
            return null;
        }
        EI_ligne_objectif__c newObj = new  EI_ligne_objectif__c(); 
        newObj.EI_Entretien__c = interview.id;
        insert newObj;

        PageReference page = Apexpages.currentPage() ; 
        page.setredirect(true);
        return page;
    }

    /**
     * Uploads an attachment to the current interview
     *
     * @return Current page
     */
    public PageReference upload() {
        if(!Schema.sObjectType.Attachment.fields.OwnerId.isCreateable()
                || !Schema.sObjectType.Attachment.fields.ParentId.isCreateable()
                || !Schema.sObjectType.Attachment.fields.IsPrivate.isCreateable()
                ) {
            System.debug('User does not have sufficient rights.');
            return null;
        }

        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = interview.id; // the record the file is attached to
        attachment.IsPrivate = true;

        try {
            insert attachment;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            return null;
        } finally {
            attachment = new Attachment(); 
        }

        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));

        PageReference redirect = ApexPages.currentPage();
        redirect.setRedirect(true);
        return redirect;
    }
}