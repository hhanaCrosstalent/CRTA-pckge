@IsTest(SeeAllData=true)
global class bduBatch_test {
    
    @IsTest
    global static void bduBatch_test() {
        
        List<RecordType> RT = [SELECT Id, name FROM RecordType WHERE name='Salarié'];
        Contact s1 = new Contact(Firstname = 'Test', Lastname='Toto', Sexe__c='M',
                Contrat_pret__c='CDI', Birthdate = Date.newInstance(1972,10,01),
                RecordTypeId=RT[0].Id, Categorie_professionnelle__c = 'Cadre',
                CT_Date_of_entry_to_the_society__c = date.newinstance(2012,10,01),
                CT_Exit_date__c=date.newinstance(2052,10,01), Stagiaire__c=false);
        insert s1;
        system.assertEquals(s1.Firstname, 'Test');
        system.assertEquals(s1.Lastname, 'Toto');
        Contact s2 = new Contact(Firstname = 'Testa', Lastname='Toto', Sexe__c='F', Contrat_pret__c = 'CDI',
                Birthdate = Date.newInstance(1992,10,01), RecordTypeId = RT[0].Id,
                Categorie_professionnelle__c = 'Dirigeant',
                CT_Date_of_entry_to_the_society__c = date.newinstance(2012,10,01),
                CT_Exit_date__c = date.newinstance(2052,10,01),
                Stagiaire__c = false);
        insert s2;
        BDU_Data_Accidents_du_travail__c at1 = new BDU_Data_Accidents_du_travail__c(Salarie__c = s1.Id);
         Id recordTypeAccountHierarchical = Schema.SObjectType.Account
            .getRecordTypeInfosByDeveloperName()
            .get('Hierarchical').getRecordTypeId();
        Account accountHierarchical = BrainHRDataFactory.newAccount();
        accountHierarchical.RecordtypeId = recordTypeAccountHierarchical;
        insert accountHierarchical;
        GS_Affectation_poste__c af1 = new GS_Affectation_poste__c(
            GS_Salarie__c = s1.Id, 
            GS_Date_de_debut__c = Date.newInstance(2012,10,01),
            GS_Date_de_fin__c = Date.newInstance(2016,10,01),
            Stagiaire__c = false,
            Temps_de_travail__c = 'Temps plein',
            Type_de_contrat__c = 'CDI',
        	crta__Hierarchical_Account__c = accountHierarchical.Id);
        insert af1;

        Param_calc_auto__c options;
        try {
            options = [SELECT publishNewValues__c FROM Param_calc_auto__c];
        } catch(Exception e) {
            options = new Param_calc_auto__c(PublishNewValues__c = false);
            insert options;
        }


        BDU_Chapitre__c chapitre;
        try {
            chapitre = [SELECT Id FROM BDU_Chapitre__c WHERE Name='Données sociales' LIMIT 1];
        } catch(Exception e) {
            chapitre = new BDU_Chapitre__c(
                    Name='Données sociales',
                    CT_Order__c = 1
                    );
            insert chapitre; 
        }

        BDU_Domaine__c domaine;
        try {
            domaine = [SELECT Id FROM BDU_Domaine__c WHERE Name='Emploi' LIMIT 1];
        } catch(Exception e) {
            domaine = new BDU_Domaine__c(
                    Name='Emploi',
                    CT_BDU_Chapitre__c = chapitre.Id,
                    CT_Affiche__c = true,
                    CT_Slug__c = 'emploi'
                    );
            insert domaine; 
        }

        BDU_Indicateur__c indic;
        try {
            /*0!0*/
            indic = [SELECT Id, CT_Code__c, CT_isSOQL__c FROM BDU_Indicateur__c WHERE CT_Code__c = 'IND01128' LIMIT 1];
        } catch(Exception e) {
            indic = new BDU_Indicateur__c(
                    Name = 'Effectif total au 31/12 (tous salariés)',
                    CT_Libelle__c = 'Effectif total au 31/12 (tous salariés)',
                    CT_Article__c = 'Art.R.2323-17',
                    CT_BDU_Domaine__c = domaine.Id,
                    CT_Code__c = 'IND01128',
                    CT_Code_Applicable__c = 'Code du travail',
                    CT_Description__c = 'Par catégorie et par sexe. 1 salarié compte 1, quel que soit son temps de '
                            + 'travail. CDI, CDD, Apprentissage et alternance ; hors stagiaires)',
                    CT_Emplacement__c = 'Bilan Social',
                    CT_Affiche__c = true,
                    CT_Afficher_le_tableau__c = true,
                    CT_Afficher_le_graphique__c = true,
                    CT_Annuel__c = true,
                    CT_Semestriel__c = true,
                    CT_Trimestriel__c = true,
                    CT_Bimestriel__c = true,
                    CT_Mensuel__c = true,
                    CT_isSOQL__c = false
                    );
            insert indic;
        }

        List<BduBatchParam> param = new List<BduBatchParam>();
        Date debut = Date.newInstance(1990,01,01);
        Date fin = Date.newInstance(2090,12,31);
        param.add(new bduBatchParam(indic, 'Societe A', null, null, null, null, debut, fin, 2014, 1, 1, 1, 1 ));

        bduBatch batch = new bduBatch( param );
        Database.executeBatch( batch, 1 );  
        BDU_Indicateur__c indic2;
        try {
            /*0_0!0_0*/
            indic2 = [SELECT Id, CT_Code__c, CT_isSOQL__c 
                    FROM BDU_Indicateur__c 
                    WHERE CT_Code__c = 'IND01121' 
                    LIMIT 1];
        } catch(Exception e) {
            indic2 = new BDU_Indicateur__c(
                    Name = 'Effectif total au 31/12 (tous salariés)',
                    CT_Libelle__c = 'Effectif total au 31/12 (tous salariés)',
                    CT_Article__c = 'Art.R.2323-17',
                    CT_BDU_Domaine__c = domaine.Id,
                    CT_Code__c = 'IND01121',
                    CT_Code_Applicable__c = 'Code du travail',
                    CT_Description__c = 'Par catégorie et par sexe. 1 salarié compte 1, quel que soit son temps de '
                        + 'travail. CDI, CDD, Apprentissage et alternance ; hors stagiaires)',
                    CT_Emplacement__c = 'Bilan Social',
                    CT_Affiche__c = true,
                    CT_Afficher_le_tableau__c = true, 
                    CT_Afficher_le_graphique__c = true,
                    CT_Annuel__c = true,
                    CT_Semestriel__c = true,
                    CT_Trimestriel__c = true,
                    CT_Bimestriel__c = true,
                    CT_Mensuel__c = true,
                    CT_isSOQL__c = false
                    );
            insert indic2; 
        }

        List<bduBatchParam> param2 = new List<bduBatchParam>();
        Date debut2 = Date.newInstance(1990,01,01);
        Date fin2 = Date.newInstance(2090,12,31);
        param2.add(new bduBatchParam(indic2, 'Societe A', null, null, null, null, debut2, fin2, 2014, 1, 1, 1, 1));

        bduBatch batch2 = new bduBatch( param2);
        Database.executeBatch( batch2, 1);

        BDU_Indicateur__c indic3;
        try {
            /*0!0_0*/
            indic3 = [SELECT Id, Name, CT_Libelle__c, CT_Article__c, CT_BDU_Domaine__c, CT_Code__c, 
                        CT_Code_Applicable__c, CT_Description__c, CT_Emplacement__c, CT_Affiche__c, 
                        CT_Afficher_le_tableau__c, CT_Afficher_le_graphique__c, CT_Annuel__c, CT_Semestriel__c,
                        CT_Trimestriel__c, CT_Bimestriel__c, CT_Mensuel__c, CT_isSOQL__c
                      FROM BDU_Indicateur__c 
                      WHERE CT_Code__c = 'IND01119' 
                      LIMIT 1];
        } catch(Exception e) {
            indic3 = new BDU_Indicateur__c(
                    Name = 'Effectif total au 31/12 (tous salariés)',
                    CT_Libelle__c = 'Effectif total au 31/12 (tous salariés)',
                    CT_Article__c = 'Art.R.2323-17',
                    CT_BDU_Domaine__c = domaine.Id,
                    CT_Code__c = 'IND01119',
                    CT_Code_Applicable__c = 'Code du travail',
                    CT_Description__c = 'Par catégorie et par sexe. 1 salarié compte 1, quel que soit son temps de '
                                    + 'travail. CDI, CDD, Apprentissage et alternance ; hors stagiaires)',
                    CT_Emplacement__c = 'Bilan Social',
                    CT_Affiche__c = true,
                    CT_Afficher_le_tableau__c = true, 
                    CT_Afficher_le_graphique__c = true,
                    CT_Annuel__c = true,
                    CT_Semestriel__c = true,
                    CT_Trimestriel__c = true,
                    CT_Bimestriel__c = true,
                    CT_Mensuel__c = true,
                    CT_isSOQL__c = false
                    );
            insert indic3; 
        }

        List<bduBatchParam> param3 = new List<bduBatchParam>();
        Date debut3 = Date.newInstance(1990,01,01);
        Date fin3 = Date.newInstance(2090,12,31);
        param3.add(new bduBatchParam(indic3, 'Societe A', null, null, null, null, debut3, fin3, 2014, 1, 1, 1, 1));

        bduBatch batch3 = new bduBatch( param3 );
        Database.executeBatch( batch3, 1 );  

        BDU_Indicateur__c indic4;
        try {
            /*0_0!0*/
            indic4 = [SELECT Id, CT_Code__c, CT_isSOQL__c 
                        FROM BDU_Indicateur__c 
                        WHERE CT_Code__c = 'IND01113' 
                        LIMIT 1];
        } catch(Exception e) {
            indic4 = new BDU_Indicateur__c(
                    Name = 'Effectif total au 31/12 (tous salariés)',
                    CT_Libelle__c = 'Effectif total au 31/12 (tous salariés)',
                    CT_Article__c = 'Art.R.2323-17',
                    CT_BDU_Domaine__c = domaine.Id,
                    CT_Code__c = 'IND01113',
                    CT_Code_Applicable__c = 'Code du travail',
                    CT_Description__c = 'Par catégorie et par sexe. 1 salarié compte 1, quel que soit son temps de '
                        + 'travail. CDI, CDD, Apprentissage et alternance ; hors stagiaires)',
                    CT_Emplacement__c = 'Bilan Social',
                    CT_Affiche__c = true,
                    CT_Afficher_le_tableau__c = true,
                    CT_Afficher_le_graphique__c = true,
                    CT_Annuel__c = true,
                    CT_Semestriel__c = true,
                    CT_Trimestriel__c = true,
                    CT_Bimestriel__c = true,
                    CT_Mensuel__c = true,
                    CT_isSOQL__c = false
                    );
            insert indic4; 
        }
        List<bduBatchParam> param4 = new List<bduBatchParam>();
        Date debut4 = Date.newInstance(1990,01,01);
        Date fin4 = Date.newInstance(2090,12,31);
        param4.add(new bduBatchParam(indic4, 'Societe A', null, null, null, null, debut4, fin4, 2014, 1, 1, 1, 1));

        bduBatch batch4 = new bduBatch( param4 );
        Database.executeBatch( batch4, 1 );  


        BDU_Indicateur__c indic5;
        try {
            indic5 = [SELECT Id, CT_Code__c, CT_isSOQL__c 
                      FROM BDU_Indicateur__c 
                      WHERE CT_Code__c = 'IND01117' 
                      LIMIT 1];
        } catch(Exception e) {
            indic5 = new BDU_Indicateur__c(
                    Name = 'Effectif total au 31/12 (tous salariés)',
                    CT_Libelle__c = 'Effectif total au 31/12 (tous salariés)',
                    CT_Article__c = 'Art.R.2323-17',
                    CT_BDU_Domaine__c = domaine.Id,
                    CT_Code__c = 'IND01117',
                    CT_Code_Applicable__c = 'Code du travail',
                    CT_Description__c = 'Par catégorie et par sexe. 1 salarié compte 1, quel que soit son temps de '
                        + 'travail. CDI, CDD, Apprentissage et alternance ; hors stagiaires)',
                    CT_Emplacement__c = 'Bilan Social',
                    CT_Affiche__c = true,
                    CT_Afficher_le_tableau__c = true, 
                    CT_Afficher_le_graphique__c = true,
                    CT_Annuel__c = true,
                    CT_Semestriel__c = true,
                    CT_Trimestriel__c = true,
                    CT_Bimestriel__c = true,
                    CT_Mensuel__c = true,
                    CT_isSOQL__c = false
                    );
            insert indic5; 
        }

        List<BduBatchParam> param5 = new List<BduBatchParam>();
        Date debut5 = Date.newInstance(1990,01,01);
        Date fin5 = Date.newInstance(2090,12,31);
        param5.add(new bduBatchParam(indic5, 'Societe A', null, null, null, null, debut5, fin5, 2014, 1, 1, 1, 1));

        bduBatch batch5 = new bduBatch(param5);
        Database.executeBatch(batch5, 1);
    }
}