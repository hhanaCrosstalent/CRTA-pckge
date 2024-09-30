// Test:
// - apex:repeat no namespace, [SELECT] no namespace => works
// - apex:repeat no namespace, Database.query no namespace => works
// - Remoting no namespace, [SELECT] no namespace
// - Remoting no namespace, Database.query no namespace
// - webservice no namespace, [SELECT] no namespace
// - webservice no namespace, Database.query no namespace

public with sharing class TestController {

    public String myMessage {private set; get;}

    public TestController() {
        System.debug('Label List_all x: ' + System.Label.List_all);
        List<AggregateResult> l = [SELECT COUNT(Date__c), Type__c
                                   FROM Temps__c
                                   WHERE Id != null
                                   GROUP BY Type__c];
        for(AggregateResult ar:l) {
            Schema.DescribeFieldResult f = Temps__c.Type__c.getDescribe();
            System.debug('Result: ' + ar.get(f.getName()) + ' count: '+ar.get('expr0'));
        }
    }

    public void save() {}

    public void showMessage() {
        myMessage = 'BIG BINGA';
    }

    // Testing RemoteAction/Web service/normal controller calls

    @RemoteAction
    public static String significant(String s) {
        s = System.Label.SI_Notif_training_request_accept;
        return 'FELIX got '+s;
    }


    //webservice static String significantM(String s) {
    //    return 'FELIX got '+s;
    //}

    //webService static List<Temps__c> getX() {
    //    return [SELECT Id, Name, Date__c FROM Temps__c];
    //}

    //webService static List<Temps__c> getXQuery() {
    //        String soql = 'SELECT Id, Name, Date__c FROM Temps__c';
    //    return Database.query(soql);
    //}

    @RemoteAction
    public static List<Temps__c> getY() {
        return [SELECT Id, Name, Date__c FROM Temps__c LIMIT 1000];
    }

    @RemoteAction
    public static List<Temps__c> getYQuery() {
            String soql = 'SELECT Id, Name, Date__c FROM Temps__c';
            return Database.query(soql);
    }

    public List<Temps__c> getSome() {
        List<Temps__c> l = [SELECT Date__c, Feuille_hebdo__r.Salarie__r.Name FROM Temps__c LIMIT 10000];
        return l;
    }

    public List<Temps__c> getSomeQuery() {
        String soql = 'SELECT Date__c, Feuille_hebdo__r.Salarie__r.Name FROM Temps__c';
        return Database.query(soql);
    }

    // Testing AggregateResult
    //webService static List<AggregateResult> getXAr() {
    //    return [SELECT count(Date__c), Type__c t
    //            FROM Temps__c
    //            GROUP BY Type__c];
    //}

    //webService static List<AggregateResult> getXQueryAr() {
    //    String soql = 'SELECT count(Date__c), Type__c t FROM Temps__c GROUP BY Type__c';
    //    return Database.query(soql);
    //}

    @RemoteAction
    public static List<AggregateResult> getYAr() {
        return [SELECT count(Date__c), Type__c t
                FROM Temps__c
                WHERE Id != null
                GROUP BY Type__c];
    }

    @RemoteAction
    public static List<AggregateResult> getYQueryAr() {
            String soql = 'SELECT COUNT(Date__c), Type__c t FROM Temps__c GROUP BY Type__c';
            return Database.query(soql);
    }

    public List<AggregateResult> getSomeAr() {
        List<AggregateResult> l = [SELECT COUNT(Date__c), Type__c t
                FROM Temps__c
                WHERE Id != null
                GROUP BY Type__c];
        return l;
    }

    public List<AggregateResult> getSomeQueryAr() {
        String soql = 'SELECT COUNT(Date__c), Type__c t FROM Temps__c GROUP BY Type__c';
        List<AggregateResult> l = Database.query(soql);
        System.debug('AggregateResult: '+l);
        return l;
    }

    public void seekOutImagesInRichTextAreas() {
        /*
        Map<String, String[]> m = new Map<String, List<String>> {
            'crta__Action_de_formation__c'=>new String[] {'crta__Besoin_initial__c',
                'crta__Commentaire_besoin_initial__c'},
            'crta__Article__c'=>new String[] {'crta__Texte__c'},
            'crta__BDU_Domaine__c'=>new String[] {'crta__CT_Description__c'},
            'crta__BDU_Valeur__c'=>new String[] {'crta__CT_Commentaire__c','crta__CT_Valeur__c'},
            'Contact'=>new String[] {'crta__CT_Solution_identified_Synthesis__c','crta__RC_Experience__c',
                'crta__RC_Formation__c','crta__Scolarite__c'},
            'crta__Demande__c'=>new String[] {'crta__Description__c','crta__Reponse__c'},
            'crta__Demande_de_formation__c'=>new String[] {'crta__Description__c'},
            'crta__EI_Entretien__c'=>new String[] {'crta__EI_Commentaire_du_manager__c',
                'crta__EI_Commentaire_du_salarie__c', 'crta__EI_Evolution__c','crta__EI_Formations_demandees__c',
                'crta__EI_Mobilite__c'},
            'crta__EI_Ligne_objectif__c'=>new String[] {'crta__EI_Commentaire_manager__c',
                'crta__EI_Commentaire_salarie__c','crta__EI_Conditions_de_reussite__c','crta__EI_Description__c'},
            'crta__EI_Modele_d_entretien__c'=>new String[] {'crta__EI_Description__c','crta__EI_Directives__c'},
            'crta__EI_ligne_competence__c'=>new String[] {'crta__IE_Commentaire_Manager__c',
                'crta__IE_Commentaire_Salarie__c'},
            'crta__FO_Parcours_de_formation__c'=>new String[] {'crta__FO_Description__c'},
            'crta__FO_catalogue_de_formation__c'=>new String[] {'crta__Objectifs_pedagogiques__c','crta__Programme__c'},
            'crta__GS_Fiche_de_poste_Activite__c'=>new String[] {'crta__GS_Description__c'},
            'crta__GS_Fiche_de_poste__c'=>new String[] {'crta__GS_Description__c'},
            'crta__Habilitation__c'=>new String[] {'crta__Description_detaillee__c'},
            'crta__Offre_d_emploi__c'=>new String[] {'crta__CT_Description__c'},
            'crta__RPO_Remplacement__c'=>new String[] {'crta__Commentaire__c'},
            'crta__RPO__c'=>new String[] {'crta__Autres_competences_Commentaire__c','crta__Cadre_pilier__c',
                'crta__Commentaire_du_manager__c', 'crta__Commentaire_du_responsable_RH__c',
                'crta__Description_du_potentiel__c','crta__Expertise__c','crta__Plan_d_action_de_carriere__c',
                'crta__Situation_critique_individuelle__c'},
            'crta__Skill__c'=>new String[] {'crta__Description_detaillee__c'}
        };
        */
        List<FieldDefinition> fields = [SELECT EntityDefinition.QualifiedApiName,
                                               QualifiedApiName
                                        FROM FieldDefinition
                                        WHERE Datatype LIKE 'Rich Text Area%'
                                        AND EntityDefinition.QualifiedApiName != 'IdeaComment'];
        String s = 'These fields reference images: ';
        for(FieldDefinition field:fields) {
                String t = field.EntityDefinition.QualifiedApiName;
                String f = field.QualifiedApiName;
                String soql = 'SELECT ' + f + ' FROM ' + t;
            for(sObject o:Database.query(soql)) {
                if(o.get(f)!=null && ((String)o.get(f)).contains('servlet/rtaImage')) {
                    s += '\n' + t + '.' + f;
                    break;
                }
            }
        }
        System.debug(s);
        Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
        m.setToAddresses(new String[] {'felix.vanhove@crosstalent.fr'});
        List<Organization> orgs = [SELECT Name, IsSandbox FROM Organization LIMIT 1];
        m.setSubject('RTA '+ orgs[0].Name + (orgs[0].IsSandbox?' Sandbox':' Production org'));
        m.setPlainTextBody(s);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {m});
    }
}