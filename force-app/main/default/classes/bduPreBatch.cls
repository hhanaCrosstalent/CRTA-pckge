//Security isCreateable() isUpdateable() isDeletable() checked
/**
* Batch class preparing the data for the batch
* To manually launch it:
*  String stringDate = '01/01/2014';
*  bduPreBatch clsCRON = new bduPreBatch( stringDate );
*  System.Schedule('Traitement des données', '0 0 20 1 1-12 ? *', clsCRON);
* 
* @author Crosstalent
* @group BDU-Backend
* @version 2.0
*/
global class bduPreBatch implements Database.Batchable<SObject>, Schedulable {
    private String stringDate;
    private Date refDate;
    
    global bduPreBatch( String prefDate ) {
        if(prefDate==null || prefDate=='') {
            stringDate = Datetime.now().date().format();
        } else {
            stringDate = prefDate;
        }
        refDate = Date.parse( stringDate );
    }
    
    /**
* Retrieves contacts and their fields
* @param Database.BatchableContext BC
*/
    global Database.QueryLocator start( Database.BatchableContext BC ) {
        if(Test.isRunningTest()) {
            return Database.getQueryLocator('SELECT Id, CT_BU1__c, CT_BU2__c, CT_BU3__c, CT_BU4__c, CT_BU5__c, Contrat_pret__c, Categorie_professionnelle__c, Nombre_de_formations_dans_l_annee__c, Nombre_conges_formations_non_remuneres__c, Nombre_de_repos_compensateurs__c, Nombre_de_chomages_partiels__c, Nombre_de_chomages_intemperies__c '
                                            + 'FROM Contact LIMIT 50');
        } else {
            return Database.getQueryLocator('SELECT Id, CT_BU1__c, CT_BU2__c, CT_BU3__c, CT_BU4__c, CT_BU5__c, Contrat_pret__c, Categorie_professionnelle__c, Nombre_de_formations_dans_l_annee__c, Nombre_conges_formations_non_remuneres__c, Nombre_de_repos_compensateurs__c, Nombre_de_chomages_partiels__c, Nombre_de_chomages_intemperies__c '
                                            + 'FROM Contact');
        }
    }
    
    /**
* Updates the contacts with the latest infos from their children tables
* @param Database.BatchableContext BC
* @param List<SObject>             scope         List of contacts to update
*/
    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        Integer refYear = refDate.year();
        String contractTypes = Param_calc_auto__c.getInstance().Types_de_contrat_effectif_permanent__c;
        List<String> contractArray = contractTypes.split(',');
        String reposTypes = Param_calc_auto__c.getInstance().Nom_Repos_compensateur__c;
        List<String> reposArray = contractTypes.split(',');
        Map<Id, Contact> contactMap = new Map<Id, Contact>(); 
        for( SObject s : scope ) {
            contactMap.put( s.Id, (Contact)s );
        }
        
        //Updating Business Units
        List<GS_Affectation_poste__c> orgList = [SELECT GS_Salarie__c, Categorie_professionnelle__c, Temps_de_travail_en_pourcentage__c, Temps_de_travail__c, Type_de_contrat__c, CT_BU1__c, CT_BU2__c, CT_BU3__c, CT_BU4__c, CT_BU5__c 
                                                 FROM GS_Affectation_poste__c 
                                                 WHERE GS_Salarie__c In :contactMap.keySet() 
                                                 AND GS_Date_de_debut__c <= :refDate 
                                                 AND (GS_Date_de_fin__c=null OR GS_Date_de_fin__c >= :refDate)];
        for( GS_Affectation_poste__c org : orgList ){
            Contact tmp = contactMap.get( org.GS_Salarie__c );
            tmp.CT_BU1__c = org.CT_BU1__c;
            tmp.CT_BU2__c = org.CT_BU2__c;
            tmp.CT_BU3__c = org.CT_BU3__c;
            tmp.CT_BU4__c = org.CT_BU4__c;
            tmp.CT_BU5__c = org.CT_BU5__c;
            tmp.Contrat_pret__c = org.Type_de_contrat__c;
            tmp.CT_Working_time__c = org.Temps_de_travail__c;
            tmp.Temps_de_travail_en_pourcentage__c = org.Temps_de_travail_en_pourcentage__c;
            tmp.Categorie_professionnelle__c = org.Categorie_professionnelle__c;
        } 
        
        //Updating trainings count
        List<AggregateResult> trainingList = [SELECT COUNT(Id), CT_Candidate__c cand 
                                              FROM Formation__c 
                                              WHERE CT_Candidate__c IN: contactMap.keySet() 
                                              AND CALENDAR_YEAR(CT_Start_date__c) = :refYear 
                                              GROUP BY CT_Candidate__c];
        for(AggregateResult training: trainingList) {
            ID contactId = (ID)training.get('cand');
            Contact tmp = contactMap.get(contactId);
            tmp.Nombre_de_formations_dans_l_annee__c = Double.valueOf(training.get('expr0'));
        }
        
        //Updating unpaid trainings count
        trainingList = [SELECT COUNT(Id), CT_Candidate__c cand 
                        FROM Formation__c 
                        WHERE CT_Candidate__c IN: contactMap.keySet() 
                        AND CALENDAR_YEAR(CT_Start_date__c) = :refYear 
                        AND Conge_formation_non_remunere__c = true 
                        GROUP BY CT_Candidate__c];
        for(AggregateResult training: trainingList) {
            ID contactId = (ID)training.get('cand');
            Contact tmp = contactMap.get(contactId);
            tmp.Nombre_conges_formations_non_remuneres__c  = Double.valueOf(training.get('expr0'));
        }
        
        //Updating repos compensateur count
        List<AggregateResult> leaveList = [SELECT COUNT(Id), CT_Salarie__c sal FROM BDU_Data_Absence__c WHERE CT_Salarie__c IN: contactMap.keySet() AND CT_Date_debut__c <= :refDate AND (CT_Date_fin__c=null OR CT_Date_fin__c <= :refDate) AND Type_d_absence__c IN :reposArray GROUP BY CT_Salarie__c];
        for(AggregateResult leave: leaveList) {
            ID contactId = (ID)leave.get('sal');
            Contact tmp = contactMap.get(contactId);
            tmp.Nombre_de_repos_compensateurs__c  = Double.valueOf(leave.get('expr0'));
        }
        
        //Updating chomage partiel count
        List<AggregateResult> chomList = [SELECT COUNT(Id), Salarie__c sal FROM Periode_non_travaillee__c WHERE Salarie__c IN: contactMap.keySet() AND Date_de_debut__c <= :refDate AND Date_de_fin__c <= :refDate AND Chomage_partiel__c = true GROUP BY Salarie__c];
        for(AggregateResult chom: chomList) {
            ID contactId = (ID)chom.get('sal');
            Contact tmp = contactMap.get(contactId);
            tmp.Nombre_de_chomages_partiels__c  = Double.valueOf(chom.get('expr0'));
        }
        
        //Updating chomage intemperie count
        chomList = [SELECT COUNT(Id), Salarie__c sal FROM Periode_non_travaillee__c WHERE Salarie__c IN :contactMap.keySet() AND Date_de_debut__c <= :refDate AND Date_de_fin__c <= :refDate AND Chomage_intemperies__c = true GROUP BY Salarie__c];
        for(AggregateResult chom: chomList) {
            Id contactId = (Id) chom.get('sal');
            Contact tmp = contactMap.get(contactId);
            tmp.Nombre_de_chomages_intemperies__c  = Double.valueOf(chom.get('expr0'));
        }
        
        //Finding key date for 'Effectif permanent'
        orgList = [SELECT GS_Salarie__c, GS_Date_de_debut__c , Temps_de_travail_en_pourcentage__c, Temps_de_travail__c, GS_Date_de_fin__c, Type_de_contrat__c, Categorie_professionnelle__c FROM GS_Affectation_poste__c WHERE GS_Salarie__c In :contactMap.keySet() AND Type_de_contrat__c!=null ORDER BY GS_Salarie__c, GS_Date_de_debut__c ASC];
        for( GS_Affectation_poste__c org : orgList ){
            Contact tmp = contactMap.get( org.GS_Salarie__c );    
            if (contractTypes.contains(org.Type_de_contrat__c)){
                if ( tmp!=null && tmp.Date_de_passage_cdi__c==null ) {       
                    tmp.Date_de_passage_cdi__c = org.GS_Date_de_debut__c;
                } 
                if ( tmp!=null && org.Temps_de_travail_en_pourcentage__c==100){ 
                    if(tmp.Date_de_passage_temps_plein__c==null || tmp.Date_de_passage_temps_plein__c > org.GS_Date_de_debut__c) {
                        tmp.Date_de_passage_temps_plein__c = org.GS_Date_de_debut__c;
                    }
                } else {
                    tmp.Date_de_passage_temps_plein__c = null;
                }
            }
        }
        /*
//Updating category
List<BDU_Data_Classification__c> catList = [SELECT Salarie__c, CT_Categorie__c FROM BDU_Data_Classification__c WHERE Salarie__c In :contactMap.keySet() AND CT_Date_de_debut__c <= :refDate AND (CT_Date_de_fin__c=null OR CT_Date_de_fin__c >= :refDate)];
for( BDU_Data_Classification__c category : catList ) {
Contact tmp = contactMap.get(category.Salarie__c );
tmp.Categorie_professionnelle__c =category.CT_categorie__c;
}

//Updating contract
List<BDU_Data_type_de_contrat__c> contractList = [SELECT Salarie__c, CT_Type_de_contrat__c, CT_Date_de_fin__c FROM BDU_Data_type_de_contrat__c WHERE Salarie__c In :contactMap.keySet() AND CT_Date_de_debut__c <= :refDate AND (CT_Date_de_fin__c=null OR CT_Date_de_fin__c >= :refDate)];
for( BDU_Data_type_de_contrat__c t : contractList ) {
Contact tmp = contactMap.get( t.Salarie__c );
tmp.Contrat_pret__c = t.CT_Type_de_contrat__c;
}
*/
        
        if (
            Schema.sObjectType.Contact.isUpdateable()
            && Schema.sObjectType.Contact.fields.CT_BU1__c.isUpdateable()
            && Schema.sObjectType.Contact.fields.CT_BU2__c.isUpdateable()
            && Schema.sObjectType.Contact.fields.CT_BU3__c.isUpdateable()
            && Schema.sObjectType.Contact.fields.CT_BU4__c.isUpdateable()
            && Schema.sObjectType.Contact.fields.CT_BU5__c.isUpdateable()
            && Schema.sObjectType.Contact.fields.Contrat_pret__c.isUpdateable()
            && Schema.sObjectType.Contact.fields.CT_Working_time__c.isUpdateable()
            && Schema.sObjectType.Contact.fields.Temps_de_travail_en_pourcentage__c.isUpdateable()
            && Schema.sObjectType.Contact.fields.Categorie_professionnelle__c.isUpdateable()
        ) {
            update scope;
        } else {
            System.debug(System.Label.Permission + ' bduPreBatch line 168');
        }
    }
    
    /**
* Launches the batch splitter after the contacts were updated
* @param Database.BatchableContext BC
*/
    global void finish( Database.BatchableContext bc) {
        if (!Test.isRunningTest()) {
            bduBatchSplitter splitter = new bduBatchSplitter( refDate );
            Database.executeBatch(splitter, 1);
        }
    }
    
    global void execute( SchedulableContext c) {
        Database.executeBatch( this, 2000 );
    }
}