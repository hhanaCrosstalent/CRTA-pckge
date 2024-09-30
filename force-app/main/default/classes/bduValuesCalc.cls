//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * General class for calculating an 'indicateur__c' value
 * and generating the associated table
 *
 * @author Crosstalent
 * @group BDU-Backend
 * @version 2.2
 */
global with sharing class bduValuesCalc {

    /**
     * Analyses and processes a report to create a BDU_valeur__c with corresponding HTML table and chart
     * @param  String            code          Unique code of the given BDU_Indicateur__c
     * @param  String            indicId      Id of the given BDU_Indicateur__c
     * @param  String            BU1           Specified first Business Unit
     * @param  String            BU2           Specified second Business Unit
     * @param  String            BU3           Specified third Business Unit
     * @param  String            BU4           Specified fourth Business Unit
     * @param  String            BU5           Specified fifth Business Unit
     * @param  Date              startDate     Starting date of the wanted period
     * @param  Date              endDate       Ending date the wanted period
     * @param  Integer           year              Year considered
     * @param  Integer           semester     Semester considered (e.g. 1)
     * @param  Integer           quarter      Quarter considered (e.g. 3)
     * @param  Integer           bimestre    Bimestre considered (e.g. 6)
     * @param  Integer           month        Month considered (e.g. 11)
     */
    global static void processReport(String code, String indicId, String BU1, String BU2, String BU3, String BU4, 
            String BU5, Date startDate, Date endDate, Integer year, Integer semester, Integer quarter, 
            Integer bimestre, Integer month) {
        BDU_Valeur__c value;
        Param_calc_auto__c options = Param_calc_auto__c.getInstance();

        try {
            String valueTab = ''; //HTML table
            String valueChart = ''; //HTML and JS chart

            List<Report> reportList = [SELECT Id FROM Report WHERE name =:code ORDER BY CreatedDate DESC];
            if ( reportList.size() > 0 ){
                String reportId = (String)reportList.get(0).get('Id');
                Reports.ReportMetadata reportMetadata;

                reportMetadata = changeReportParameters( reportId, startDate, endDate );
                if ( reportMetadata != null ){
                    changeBUParameters( reportMetadata, BU1, BU2, BU3, BU4, BU5 );

                    //Test handling: see bduBatch_test
                    if(Test.isRunningTest()) {
                        /*
                        if(!Schema.sObjectType.Contact.fields.Firstname.isCreateable()
                            || !Schema.sObjectType.Contact.fields.Lastname.isCreateable()
                            || !Schema.sObjectType.Contact.fields.Sexe__c.isCreateable()
                            || !Schema.sObjectType.Contact.fields.Nationalite__c.isCreateable()
                            || !Schema.sObjectType.Contact.fields.Contrat_pret__c.isCreateable()
                            || !Schema.sObjectType.Contact.fields.Birthdate.isCreateable()
                            || !Schema.sObjectType.Contact.fields.RecordTypeId.isCreateable()
                            || !Schema.sObjectType.Contact.fields.Categorie_professionnelle__c.isCreateable()
                            || !Schema.sObjectType.Contact.fields.CT_Date_of_entry_to_the_society__c.isCreateable()
                            || !Schema.sObjectType.Contact.fields.CT_Exit_date__c.isCreateable()
                            || !Schema.sObjectType.Contact.fields.Stagiaire__c.isCreateable()
                            ) {
                                System.assert(false, 'Test user does not have necessary permissions to create contacts.');
                        }
                        List<RecordType> RT = [SELECT Id, Name FROM RecordType WHERE name='Salarié'];
                        Contact s1 = new Contact(Firstname = 'Test', Lastname='Toto', Sexe__c='M', Nationalite__c='FR',
                                            Contrat_pret__c='CDI', Birthdate = Date.newInstance(1972,10,01),
                                            RecordTypeId=RT[0].Id, Categorie_professionnelle__c = 'Cadre',
                                            CT_Date_of_entry_to_the_society__c = date.newinstance(2012,10,01),
                                            CT_Exit_date__c=date.newinstance(2052,10,01), Stagiaire__c=false);
                        insert s1;
                        Contact s2 = new Contact(Firstname = 'Testa', Lastname='Toto', Sexe__c='F',
                                            Nationalite__c='EN', Contrat_pret__c = 'CDI',
                                            Birthdate = Date.newInstance(1992,10,01), RecordTypeId = RT[0].Id,
                                            Categorie_professionnelle__c = 'Dirigeant',
                                            CT_Date_of_entry_to_the_society__c = date.newinstance(2012,10,01),
                                            CT_Exit_date__c = date.newinstance(2052,10,01),
                                            Stagiaire__c = false);
                        insert s2;
                         */
                        List<Contact> con1 = [SELECT Lastname, Firstname, Sexe__c, Categorie_professionnelle__c, 
                                                  Age__c, CT_Date_of_entry_to_the_society__c
                                              FROM Contact
                                              WHERE Firstname='Test'];
                        List<Contact> con2 = [SELECT Lastname, Firstname, Sexe__c, Categorie_professionnelle__c, 
                                                  Age__c, CT_Date_of_entry_to_the_society__c
                                              FROM Contact
                                              WHERE Firstname='Testa'];
                        Contact s1 = con1.get(0);
                        Contact s2 = con2.get(0);
                        /*
                        List<Contact> contact = [SELECT Lastname, Firstname, Sexe__c, Categorie_professionnelle__c, 
                                                        Age__c, CT_Date_of_entry_to_the_society__c
                                                FROM Contact
                                                WHERE Lastname='Toto'];
                        BDU_Data_Accidents_du_travail__c at1 
                            = new BDU_Data_Accidents_du_travail__c(Salarie__c = s1.Id);
                        GS_Affectation_poste__c af1 = new GS_Affectation_poste__c(GS_Salarie__c = s1.Id, 
                            GS_Date_de_debut__c=date.newinstance(2012,10,01), 
                            GS_Date_de_fin__c=date.newinstance(2016,10,01), Stagiaire__c= false, 
                            Temps_de_travail__c='Temps plein', Type_de_contrat__c='CDI');
                        insert af1;
                        System.debug(af1);
                         */
                        reportMetadata = Reports.ReportManager.describeReport(reportId).getReportMetadata();
                        System.debug(reportMetadata.getReportType().getType());
                        // Add a filter.
                        List<Reports.ReportFilter> filters = new List<Reports.ReportFilter>();
                        Reports.ReportFilter newFilter = new Reports.ReportFilter();
                        newFilter.setColumn('Contact.LastName');
                        newFilter.setOperator('equals');
                        newFilter.setValue(s1.LastName);
                        filters.add(newFilter);
                        reportMetadata.setReportFilters(filters);
                        reportMetadata.setReportBooleanFilter('1');

                    }
                    Reports.ReportResults results;
                    try {
                        results = Reports.ReportManager.runReport(reportId, reportMetadata, true);
                    } catch(Exception e) {
                        System.debug(e.getMessage());
                    }
                    reportMetadata = results.getReportMetadata();
                    //Retrieves the format of the report
                    //Starts building the HTML table accordingly
                    //Starts building HTML/JS chart accordingly
                    System.debug((Reports.ReportFact)results.getFactMap().get('T!T'));
                    Reports.ReportFact grandTotal = (Reports.ReportFact)results.getFactMap().get('T!T');
                    if(Integer.ValueOf(grandTotal.getAggregates().get(0).getValue()) != -1) {
                        if(String.ValueOf(reportMetadata.getReportFormat())=='TABULAR') {
                            valueTab += formatTabular( valueTab, results );
                        } else if(String.ValueOf(reportMetadata.getReportFormat())=='SUMMARY') {
                            Reports.Dimension dim1 = results.getGroupingsDown();
                            Reports.Dimension dim2 = results.getGroupingsAcross();
                            valueTab += formatSummary( valueTab, results, dim1, dim2 );
                            valueChart += getChartFromReport( valueChart, results, reportMetadata, dim1, dim2);
                        } else if(String.ValueOf(reportMetadata.getReportFormat())=='MATRIX') {
                            valueTab += '<table>';
                            Reports.Dimension dim1 = results.getGroupingsDown();
                            Reports.Dimension dim2 = results.getGroupingsAcross();
                            String format = findMatrixFormat( dim1, dim2 );
                            System.debug(format);
                            if ( format == '0!0' ){
                                valueTab += formatMatrix0lig_0col( valueTab, results, dim1, dim2 );
                            } else if ( format == '0_0!0' ){
                                valueTab += formatMatrix0_0lig_0col( valueTab, results, dim1, dim2 );
                            } else if ( format == '0!0_0' ){
                                valueTab += formatMatrix0lig_0_0col( valueTab, results, dim1, dim2 );
                            } else if ( format == '0_0!0_0' ){
                                valueTab += formatMatrix0_0lig_0_0col( valueTab, results, dim1, dim2 );
                            } else {
                                valueTab += formatSummary( valueTab, results, dim1, dim2 );
                            }
                            valueTab += '</table>';
                            valueChart += getChartFromReport( valueChart, results, reportMetadata, dim1, dim2);
                        }

                        //Checking HTML table length and field max length
                        Schema.DescribeFieldResult F = BDU_Valeur__c.CT_Valeur__c.getDescribe();
                        Integer lengthOfField = F.getLength();
                        if(valueTab.length()>=lengthOfField) {
                            valueTab = 'Le rapport : '+code+' dépasse la taille limite de '+ lengthOfField 
                                    +' caractères';
                        }
                    } else {
                        valueTab = 'Le rapport : '+code+' ne renvoit rien';
                    }
                } else if(reportMetadata == null) {
                    valueTab = 'Le rapport: '+code+' n\'a pas de paramètre de période valide.';
                }
            } else {
                valueTab = 'Le rapport : '+code+' fait référence à un rapport qui n\'existe pas.';
            }

            //Creating a new value with the formatted HTML table and chart
            value = new BDU_Valeur__c(
                    CT_Annee__c = String.valueOf(year),
                    CT_semestre__c = String.valueOf(semester),
                    CT_Trimestre__c = String.valueOf(quarter),
                    CT_Bimestre__c = String.valueOf(bimestre),
                    CT_Mois__c = String.valueOf(month),
                    CT_BU1__c = BU1,
                    CT_BU2__c = BU2,
                    CT_BU3__c = BU3,
                    CT_BU4__c = BU4,
                    CT_BU5__c = BU5,
                    CT_A_publier__c = options.publishNewValues__c,
                    CT_BDU_Indicateur__c = indicId,
                    CT_Date_de_publication__c = System.today(),
                    CT_Val__c = valueChart,
                    CT_Valeur__c = valueTab
                    );
        } catch (Exception e) { //Creating a new value with the corresponding error message
            value = new BDU_Valeur__c(
                    CT_Annee__c = String.valueOf(year),
                    CT_semestre__c = String.valueOf(semester),
                    CT_Trimestre__c = String.valueOf(quarter),
                    CT_Bimestre__c = String.valueOf(bimestre),
                    CT_Mois__c = String.valueOf(month),
                    CT_BU1__c = BU1,
                    CT_BU2__c = BU2,
                    CT_BU3__c = BU3,
                    CT_BU4__c = BU4,
                    CT_BU5__c = BU5,
                    CT_A_publier__c = options.publishNewValues__c,
                    CT_BDU_Indicateur__c = indicId,
                    CT_Date_de_publication__c = System.today(),
                    CT_Valeur__c = 'Erreur de traitement du Rapport: ' + code + ': ' + e.getMessage() +' Lig:'
                        + e.getLineNumber()
                    );
        }
        try {
            if (
                Schema.sObjectType.BDU_Valeur__c.isCreateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_Annee__c.isCreateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_semestre__c.isCreateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_Trimestre__c.isCreateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_Mois__c.isCreateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_BU1__c.isCreateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_BU2__c.isCreateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_BU3__c.isCreateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_BU4__c.isCreateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_BU5__c.isCreateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_A_publier__c.isCreateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_BDU_Indicateur__c.isCreateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_Date_de_publication__c.isCreateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_Val__c.isCreateable()
                && Schema.sObjectType.BDU_Valeur__c.fields.CT_Valeur__c.isCreateable()
            ) {
            	insert value;
            } else {
                System.debug(System.Label.Permission);
            }
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }

    /**
     * Analyses a matrix reports dimensions to find its format
     * @param  Reports.Dimension dim1          First dimension of the report
     * @param  Reports.Dimension dim2          Second dimension of the report
     * @return   String                                                    Report format
     */
    private static String findMatrixFormat( Reports.Dimension dim1, Reports.Dimension dim2 ) {
        String format='';
        if(dim1.getGroupings().size()>0 
                && dim2.getGroupings().size()>0 
                && dim1.getGroupings()[0].getGroupings().size()==0 
                && dim2.getGroupings()[0].getGroupings().size()==0) {
            format = '0!0';
        } else if(dim1.getGroupings().size()>0 
                && dim2.getGroupings().size()>0 
                && dim1.getGroupings()[0].getGroupings().size()>0 
                && dim2.getGroupings()[0].getGroupings().size()==0) {
            format = '0_0!0';
        } else if(dim1.getGroupings().size()>0 
                && dim2.getGroupings().size()>0 
                && dim1.getGroupings()[0].getGroupings().size()==0 
                && dim2.getGroupings()[0].getGroupings().size()>0 ) {
            format = '0!0_0';
        } else if(dim1.getGroupings().size()>0 
                && dim2.getGroupings().size()>0 
                && dim1.getGroupings()[0].getGroupings().size()>0 
                && dim2.getGroupings()[0].getGroupings().size()>0 ) {
            format = '0_0!0_0';
        }
        return format;
    }

    /**
     * Creates a HTML table from a matrix report
     * @param  String                valueTab      The starting HTML table
     * @param  Reports.ReportResults results       Results from the wanted reports
     * @param  Reports.Dimension     dim1          First dimension of the wanted report
     * @param  Reports.Dimension     dim2          Second dimension of the wanted report
     * @return   String                                                         The formatted HTML table
     */
    private static String formatMatrix0_0lig_0_0col(String valueTab, Reports.ReportResults results, 
            Reports.Dimension dim1, Reports.Dimension dim2) {
        //Table headers
        valueTab += '<thead><tr><td></td><td></td>';
        for(Reports.GroupingValue colonne : dim2.getGroupings()) {
            valueTab += '<td colspan="'+colonne.getGroupings().size()+'" class="tLabel">'+colonne.getLabel()+'</td>';
        }
        valueTab += '<td class="tTotal">Total</td>';
        valueTab+='</tr><tr><td></td><td></td>';
        for(Reports.GroupingValue colonne : dim2.getGroupings()){
            for(Reports.GroupingValue subcolumns : colonne.getGroupings()) {
                valueTab += '<td class="tLabel">'+subcolumns.getLabel()+'</td>';
            }
        }
        valueTab +='<td class="tTotal"></td></tr></thead>';

        // Table body (line by line)
        valueTab +='<tbody>';
        for(Reports.GroupingValue ligne : dim1.getGroupings()) {
            valueTab+='<tr><td rowspan="'+ligne.getGroupings().size()+'" class="tLabel ">'+ligne.getValue()+'</td>';
            for(Reports.GroupingValue sublines : ligne.getGroupings()) {
                valueTab+='<td class="tLabel tSublabel">'+sublines.getValue()+'</td>';
                for(Reports.GroupingValue colonne : dim2.getGroupings()) {
                    for(Reports.GroupingValue subcolumns : colonne.getGroupings()){
                        Reports.ReportFact k = (Reports.ReportFact)results.getFactMap().get(sublines.getKey()+'!'
                                +subcolumns.getKey());
                        valueTab+= '<td border="1" class="tValue">'+k.getAggregates().get(0).getLabel()+'</td>';
                    }
                }
                Reports.ReportFact tl = (Reports.ReportFact)results.getFactMap().get(sublines.getKey()+'!T');
                valueTab += '<td colspan="'+ligne.getGroupings().size()+'" class="tTotal">'
                        +tl.getAggregates().get(0).getLabel()
                        +'</td>';
                valueTab+='</tr>';
                valueTab+='</tr><tr>';
            }
            valueTab+='</tr>';
        }
        valueTab +='</tbody>';

        // Table footer (Sum of the previous values)
        valueTab +='<tfoot><tr class="tTotal"><td class="tTotal">Total</td><td></td>';
        for(Reports.GroupingValue colonne : dim2.getGroupings()) {
            for(Reports.GroupingValue subcolumns : colonne.getGroupings()) {
                Reports.ReportFact tc = (Reports.ReportFact)results.getFactMap().get('T!'+subcolumns.getKey());
                valueTab += '<td class="tTotal">'+tc.getAggregates().get(0).getLabel()+'</td>';
            }
        }
        Reports.ReportFact grandTotal = (Reports.ReportFact)results.getFactMap().get('T!T');
        valueTab+= '<td class=tTotal">'+grandTotal.getAggregates().get(0).getLabel()+'</td></tr></tfoot>';

        return valueTab;
    }

    /**
     * Creates a HTML table from a matrix report
     * @param  String                valueTab      The starting HTML table
     * @param  Reports.ReportResults results       Results from the wanted reports
     * @param  Reports.Dimension     dim1          First dimension of the wanted report
     * @param  Reports.Dimension     dim2          Second dimension of the wanted report
     * @return   String                                                         The formatted HTML table
     */
    private static String formatMatrix0lig_0_0col(String valueTab, Reports.ReportResults results, 
            Reports.Dimension dim1, Reports.Dimension dim2) {
        //Table headers
        valueTab += '<thead><tr><td></td>';
        for(Reports.GroupingValue colonne : dim2.getGroupings()) {
            valueTab += '<td colspan="'+colonne.getGroupings().size()+'" class="tLabel">'+colonne.getLabel()+'</td>';
        }
        valueTab += '<td class="tTotal">Total</td>';
        valueTab+='</tr><tr><td></td>';
        for(Reports.GroupingValue colonne : dim2.getGroupings()) {
            for(Reports.GroupingValue subcolumns : colonne.getGroupings()) {
                valueTab += '<td class="tLabel">'+subcolumns.getLabel()+'</td>';
            }
        }
        valueTab +='<td class="tTotal"></td></tr></thead>';

        // Table body (line by line)
        valueTab +='<tbody>';
        for(Reports.GroupingValue ligne : dim1.getGroupings()) {
            valueTab+='<tr><td class="tLabel">'+ligne.getValue()+'</td>';
            for(Reports.GroupingValue colonne : dim2.getGroupings()) {
                for(Reports.GroupingValue subcolumns : colonne.getGroupings()) {
                    Reports.ReportFact k = (Reports.ReportFact)results.getFactMap().get(ligne.getKey()+'!'
                            +subcolumns.getKey());
                    valueTab+= '<td border="1" class="tValue">'+k.getAggregates().get(0).getLabel()+'</td>';
                }
            }
            Reports.ReportFact tl = (Reports.ReportFact)results.getFactMap().get(ligne.getKey()+'!T');
            valueTab += '<td colspan="'+ligne.getGroupings().size()+'" class="tTotal">'
                    +tl.getAggregates().get(0).getLabel()+'</td>';
            valueTab+='</tr>';
        }
        valueTab +='</tbody>';

        // Table footer (Sum of the previous values)
        valueTab +='<tfoot><tr class="tTotal"><td class="tTotal">Total</td>';
        for(Reports.GroupingValue colonne : dim2.getGroupings()) {
            for(Reports.GroupingValue subcolumns : colonne.getGroupings()) {
                Reports.ReportFact tc = (Reports.ReportFact)results.getFactMap().get('T!'+subcolumns.getKey());
                valueTab += '<td class="tTotal">'+tc.getAggregates().get(0).getLabel()+'</td>';
            }
        }
        Reports.ReportFact grandTotal = (Reports.ReportFact)results.getFactMap().get('T!T');
        valueTab+= '<td class="tTotal">'+grandTotal.getAggregates().get(0).getLabel()+'</td></tr></tfoot>';

        return valueTab;
    }

    /**
     * Creates a HTML table from a matrix report
     * @param  String                valueTab      The starting HTML table
     * @param  Reports.ReportResults results       Results from the wanted reports
     * @param  Reports.Dimension     dim1          First dimension of the wanted report
     * @param  Reports.Dimension     dim2          Second dimension of the wanted report
     * @return   String                                                         The formatted HTML table
     */
    private static String formatMatrix0_0lig_0col(String valueTab, Reports.ReportResults results, 
            Reports.Dimension dim1, Reports.Dimension dim2) {
        //Table headers
        valueTab += '<thead><tr><td></td><td></td>';
        for(Reports.GroupingValue colonne : dim2.getGroupings()) {
            valueTab += '<td colspan="'+colonne.getGroupings().size()+'" class="tLabel">'+colonne.getLabel()+'</td>';
        }
        valueTab += '<td class="tTotal">Total</td></tr><tr></tr></thead>';

        // Table body (line by line)
        valueTab +='<tbody>';
        for(Reports.GroupingValue ligne : dim1.getGroupings()) {
            valueTab+='<tr><td rowspan="'+ligne.getGroupings().size()+'" class="tLabel">'+ligne.getValue()+'</td>';
            for(Reports.GroupingValue sublines : ligne.getGroupings()) {
                valueTab+='<td  class="tLabel">'+sublines.getValue()+'</td>';
                for(Reports.GroupingValue colonne : dim2.getGroupings()) {
                    Reports.ReportFact k = (Reports.ReportFact)results.getFactMap().get(sublines.getKey()+'!'
                            +colonne.getKey());
                    valueTab+= '<td border="1" class="tValue">'+k.getAggregates().get(0).getLabel()+'</td>';
                }
                Reports.ReportFact tl = (Reports.ReportFact)results.getFactMap().get(sublines.getKey()+'!T');
                valueTab += '<td colspan="'+ligne.getGroupings().size()+'" class="tTotal">'
                        +tl.getAggregates().get(0).getLabel()+'</td>';
                valueTab+='</tr>';
            }
            valueTab+='</tr>';
        }
        valueTab +='</tbody>';

        // Table footer (Sum of the previous values)
        valueTab +='<tfoot><tr class="tTotal"><td class="tTotal">Total</td><td></td>';
        for(Reports.GroupingValue colonne : dim2.getGroupings()){
            Reports.ReportFact tc = (Reports.ReportFact)results.getFactMap().get('T!'+colonne.getKey());
            valueTab += '<td class="tTotal">'+tc.getAggregates().get(0).getLabel()+'</td>';
        }
        Reports.ReportFact grandTotal = (Reports.ReportFact)results.getFactMap().get('T!T');
        valueTab+= '<td class="tTotal">'+grandTotal.getAggregates().get(0).getLabel()+'</td></tr></tfoot>';

        return valueTab;
    }

    /**
     * Creates a HTML table from a matrix report
     * @param  String                valueTab      The starting HTML table
     * @param  Reports.ReportResults results       Results from the wanted reports
     * @param  Reports.Dimension     dim1          First dimension of the wanted report
     * @param  Reports.Dimension     dim2          Second dimension of the wanted report
     * @return   String                                                         The formatted HTML table
     */
    private static String formatMatrix0lig_0col(String valueTab, Reports.ReportResults results, 
            Reports.Dimension dim1, Reports.Dimension dim2) {
        //Table headers
        valueTab += '<thead><tr><td></td>';
        for(Reports.GroupingValue colonne : dim2.getGroupings()) {
            valueTab += '<td colspan="'+colonne.getGroupings().size()+'" class="tLabel">'+colonne.getLabel()+'</td>';
        }
        valueTab += '<td class="tTotal">Total</td></tr><tr></tr></thead>';

        // Table body (line by line)
        valueTab +='<tbody>';
        for(Reports.GroupingValue ligne : dim1.getGroupings()) {
            valueTab+='<tr><td rowspan="'+ligne.getGroupings().size()+'" class="tLabel">'+ligne.getValue()+'</td>';
            for(Reports.GroupingValue colonne : dim2.getGroupings())
            {
                Reports.ReportFact k = (Reports.ReportFact)results.getFactMap().get(ligne.getKey()+'!'
                        +colonne.getKey());
                valueTab += '<td class=" text-align:center">'+k.getAggregates().get(0).getLabel()+'</td>';
            }
            Reports.ReportFact tl = (Reports.ReportFact)results.getFactMap().get(ligne.getKey()+'!T');
            valueTab += '<td colspan="'+ligne.getGroupings().size()+'" class="tTotal">'
                    +tl.getAggregates().get(0).getLabel()+'</td>';

            valueTab+='</tr>';
        }
        valueTab +='</tbody>';

        // Table footer (Sum of the previous values)
        valueTab +='<tffot><tr class="tTotal"><td class="tTotal">Total</td>';
        for(Reports.GroupingValue colonne : dim2.getGroupings()) {
            Reports.ReportFact tc = (Reports.ReportFact)results.getFactMap().get('T!'+colonne.getKey());
            valueTab += '<td class="tTotal">'+tc.getAggregates().get(0).getLabel()+'</td>';
        }
        Reports.ReportFact grandTotal = (Reports.ReportFact)results.getFactMap().get('T!T');
        valueTab+= '<td class="tTotal">'+grandTotal.getAggregates().get(0).getLabel()+'</td></tr></tfoot';

        return valueTab;
    }

    /**
     * Creates a HTML table from a summary report
     * @param  String                valueTab      The starting HTML table
     * @param  Reports.ReportResults results       Results from the wanted reports
     * @param  Reports.Dimension     dim1          First dimension of the wanted report
     * @param  Reports.Dimension     dim2          Second dimension of the wanted report
     * @return   String                                                         The formatted HTML table
     */
    private static String formatSummary(String valueTab, Reports.ReportResults results, Reports.Dimension dim1, 
            Reports.Dimension dim2) {
        // Table body (line by line)
        valueTab +='<thead><tr></tr></thead><tbody>';
        for(Reports.GroupingValue ligne : dim1.getGroupings()) {
            valueTab+='<tr><td  class="tLabel">'+ligne.getValue()+'</td>';
            Reports.ReportFact k = (Reports.ReportFact)results.getFactMap().get(ligne.getKey()+'!T');
            valueTab += '<td class="tValue">'+k.getAggregates().get(0).getLabel()+'</td>';
            valueTab+='</tr>';
        }
        valueTab +='</body>';

        // Table footer (Sum of the previous values)
        Reports.ReportFact grandTotal = (Reports.ReportFact)results.getFactMap().get('T!T');
        valueTab+= '<tfoot><tr><td class="tTotal">Total</td><td class=" tTotal">'
                +grandTotal.getAggregates().get(0).getLabel()+'</td></tr></tfoot>';

        return valueTab;
    }

    /**
     * Creates a HTML table from a tabular report
     * @param  String                valueTab      The starting HTML table
     * @param  Reports.ReportResults results       Results from the wanted reports
     * @return   String                                                         The formatted HTML table
     */
    private static String formatTabular(  String valueTab, Reports.ReportResults results  ) {
        Reports.ReportFact grandTotal = (Reports.ReportFact)results.getFactMap().get('T!T');
        valueTab+= '<tbody><tr><td class="tTotal">Total</td><td class=" tTotal">'
                +grandTotal.getAggregates().get(0).getLabel()+'</td></tr></tbody>';
        return valueTab;
    }

    /**
     * Creates a specifically formatted string
     * Will be processed into a chart on the frontend
     * @param  String                 valueChart     The starting HTML chart
     * @param  Reports.ReportResults results       Results from the wanted reports
     * @param  Reports.Dimension     dim1          First dimension of the wanted report
     * @param  Reports.Dimension     dim2          Second dimension of the wanted report
     * @param  Reports.ReportMetadata reportMetadata Metadata from the wanted report
     * @return    String The formatted HTML chart
     */
    private static String getChartFromReport(String valueChart, Reports.ReportResults results, 
            Reports.ReportMetadata reportMetadata, Reports.Dimension dim1, Reports.Dimension dim2) {

        valueChart += '[';
        String stringvalue = '';
        List<String> splitvalue = new List<String>();

        //Retrieves fields' name for the first dimension
        for( Reports.GroupingInfo gInfo : reportMetadata.getGroupingsDown() ){
            stringvalue = string.ValueOf(gInfo.getName());
            splitvalue = stringvalue.split('\\.'); // We split to get the API fieldname
            if(splitvalue.size() != 1) {
                splitvalue = splitvalue[1].split('crta_'); // Then we split to keep the fieldname only
                splitvalue = (splitvalue[1].contains('CT_') ? splitvalue[1].split('CT_') : splitvalue);
                splitvalue = splitvalue[1].split('__c'); // Then we split to keep the fieldname only
                valueChart += '\''+splitvalue[0]+'\'';
                break;
            }
        }
        valueChart += ', ';

        //Retrieves fields' name for the first dimension
        for( Reports.GroupingInfo gInfo2 : reportMetadata.getGroupingsAcross() ) {
            stringvalue = string.ValueOf(gInfo2.getName());
            splitvalue = stringvalue.split('\\.'); // We split to get the API fieldname
            if(splitvalue.size() != 1)
            {
                splitvalue = splitvalue[1].split('crta_'); // Then we split to keep the fieldname only
                splitvalue = (splitvalue[1].contains('CT_') ? splitvalue[1].split('CT_') : splitvalue);
                splitvalue = splitvalue[1].split('__c'); // Then We split to keep the fielname only
                valueChart += '\''+splitvalue[0]+'\'';
                break;
            }
        }
        valueChart += ']';

        //Retrieves fields' value
        splitvalue = valueChart.split(',');
        if(splitvalue[1]==' ]') {
            valueChart = splitvalue[0]+', \'Enregistrement(s)\']';
        }
        Integer i = 0;
        Integer across = Integer.valueOf(dim2.getGroupings().size());
        for(Reports.GroupingValue arrayVal : dim1.getGroupings()){
            valueChart += ', [\''+arrayVal.getLabel()+'\''+', ';
            Reports.ReportFact tc = (Reports.ReportFact)results.getFactMap().get(i+'!T');
            valueChart += Integer.valueOf(tc.getAggregates().get(0).getValue());
            valueChart += ']';
            i++;
        }

        return valueChart;
    }

    /**
     * Add the Business Unit filter logic to a report
     * @param  Reports.ReportMetadata reportMetadata            Metadata of the wanted report
     * @param  String                 BU1           First Business Unit
     * @param  String                 BU2           Second Business Unit
     * @param  String                 BU3           Third Business Unit
     * @param  String                 BU4           Fourth Business Unit
     * @param  String                 BU5           Fifth Business Unit
     */
    private static void changeBUParameters(Reports.ReportMetadata reportMetadata, String BU1, String BU2, String BU3, 
            String BU4, String BU5) {
        List<Reports.ReportFilter> reportFilters = reportMetadata.getReportFilters();
        Integer nbFilters;
        String filter = reportMetadata.getReportBooleanFilter();
        String sType = reportMetadata.getReportType().getType();
        List<String> sTypeEnd = sType.split('@');
        String poName = sTypeEnd[0].substring(sTypeEnd[0].indexOf('$')+1,sTypeEnd[0].length()) ;
        String buFilter ='';
        String obj0 = Schema.SObjectType.GS_Affectation_poste__c.getName();
        String obj1 = 'crta__Salaries__c';
        if(sTypeEnd.size()>1 && poName != obj0 && poName != obj1) {
            buFilter = 'FK_Contact';
            System.debug(sTypeEnd);
        } else if(poName == obj1) {
            buFilter = 'Contact';
        } else {
            buFilter = sTypeEnd[0].substring(sTypeEnd[0].indexOf('$')+1,sTypeEnd[0].length());
        }

        if ( filter != null ) {
            nbFilters = reportFilters.size() +1;
            filter = '(' + filter + ')';
        }

        if ( BU1 != null ){
            reportFilters.add( new Reports.ReportFilter(buFilter + '.crta__CT_BU1__c','equals',BU1));
            if ( filter != null ) {
                filter += ' AND ' + nbFilters;
                nbFilters++;
            }
        }

        if ( BU2 != null ){
            reportFilters.add( new Reports.ReportFilter(buFilter + '.crta__CT_BU2__c','equals',BU2));
            if ( filter != null ) {
                filter += ' AND ' + nbFilters;
                nbFilters++;
            }
        }

        if ( BU3 != null ){
            reportFilters.add( new Reports.ReportFilter(buFilter + '.crta__CT_BU3__c','equals',BU3));
            if ( filter != null ) {
                filter += ' AND ' + nbFilters;
                nbFilters++;
            }
        }

        if ( BU4 != null ){
            reportFilters.add( new Reports.ReportFilter(buFilter + '.crta__CT_BU4__c','equals',BU4));
            if ( filter != null ) {
                filter += ' AND ' + nbFilters;
                nbFilters++;
            }
        }

        if ( BU5 != null ){
            reportFilters.add( new Reports.ReportFilter(buFilter + '.crta__CT_BU5__c','equals',BU5));
            if ( filter != null ) {
                filter += ' AND ' + nbFilters;
                nbFilters++;
            }
        }

        if ( filter != null ){
            reportMetadata.setReportBooleanFilter( filter );
        }
    }

    /**
     * Changes a report's date parameters for the given ones
     * @param   String reportId      Id of the concerned report
     * @param   Date   startDate     Starting date of the wanted period
     * @param   Date   endDate       Ending date of the wanted period
     * @return    Reports.ReportMetadata     Modified report metadata
     */
    private static Reports.ReportMetadata changeReportParameters(String reportId, Date startDate, Date endDate) {
        Reports.ReportDescribeResult reportDescribe = Reports.ReportManager.describeReport(reportId);
        Reports.ReportMetadata reportMetadata = reportDescribe.getReportMetadata();
        List<Reports.ReportFilter> reportFilters = reportMetadata.getReportFilters();
        // yyyy-mm-dd
        Pattern datePattern = Pattern.compile('(19|20)\\d\\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])');
        List<Reports.ReportFilter> reportFiltersDates = new List<Reports.ReportFilter>();
        Reports.ReportFilter maxDate;
        Reports.ReportFilter minDate;

        //Looping through the filters to find the date ones
        for( Reports.ReportFilter reportFilter : reportFilters ) {
            if (reportFilter.getValue().length()>=10) { //At least 10 char for a date e.g. 2013-12-31
                Matcher valParamDate = datePattern.matcher( reportFilter.getValue().substring(0,10) );
                if ( valParamDate.matches() ) { //Determines whether it's a start or end date
                    reportFiltersDates.add( reportFilter );
                    if ( maxDate == null || maxDate.getValue()<reportFilter.getValue() ){
                        maxDate = reportFilter;
                    }
                    if ( minDate == null || minDate.getValue()>reportFilter.getValue() ) {
                        minDate = reportFilter;
                    }
                }
            }
        }

        //We apply our own filters instead
        if ( maxDate != null ) {
            for( Reports.ReportFilter reportFilter : reportFilters ) {
                if (reportFilter.getValue() == minDate.getValue()) {
                    reportFilter.setValue( String.valueof(startDate) );
                }
                // If min = max we set it as the upper limit
                if (reportFilter.getValue() == maxDate.getValue())
                    reportFilter.setValue( String.valueof(endDate) );
            }
            return reportMetadata;
        } else {
            return null;
        }
    }

    /**
     * Parse a map into an html table
     *
     * @param tableObject The map to parse
     * @param sumTable A table containing the sums of the values to parse
     * @param columns The columns to build the table
     * @param rows The rows to build the table
     * @param fieldLabels The labels of the retrieved columns
     * @return String a correctly formatted <table> tag
     */
    /*static String parseTable(Map<String, Integer> table, Map<String, Integer> sumTable, List<String> columns, 
     *  Set<String> rows, List<String> fieldLabels) {
        String value = '<table><thead><tr><td></td>';
        for(String column: columns){
           value += '<th>'+column+'</th>';
        }

       if(fieldLabels.size() > 1) {
            value += '<th class="sum">Total '+fieldLabels.get(0)+'</th>';
            value += '</tr></thead><tbody>';
            for(String row: rows){
               Integer sum = 0;
               value += '<tr><th>'+row+'</th>';
               for(String column: columns){
                    Integer tableValue = table.containsKey(row+';'+column) 
                        ? table.get(row+';'+column) : table.get(column+';'+row);
                    tableValue = tableValue == null ? 0 : tableValue;
                    sum += tableValue;
                    value += '<td>'+tableValue+'</td>';
               }
               value += '<td class="sum">'+sum+'</td>';
               value += '</tr>';
            }
           value += '<th class="sum">Total '+fieldLabels.get(1)+'</th>';
           for(String column: columns) {
                value += '<td class="sum">'+sumTable.get(column)+'</td>';
           }
           value += '</tr>';
        } else {
            value += '</tr></thead><tbody>';
            for(String row: rows){
                value += '<tr><th>'+row+'</th>';
                value += '<td>'+table.get(row)+'</td>';
                value += '</tr>';
            }
           value += '<th class="sum">Total '+fieldLabels.get(0)+'</th>';
           value += '<td class="sum">'+sumTable.get(fieldLabels.get(0))+'</td>';
           value += '</tr>';
        }

        value += '</tbody></table>';
        return value;
    }*/
}