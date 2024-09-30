//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Class splitting the bduBatch into manageable size inside Salesforce governors limits
 * Database.stateful is used as a counter between batches
 * This class is only called by the bduPreBatch class
 *
 * To manually launch this batch :
 *  Date date_ref = Date.newInstance(2014,01,01);
 *  bduBatchSplitter batch = new bduBatchSplitter( date_ref );
 *  Database.executeBatch( batch, 1 );  
 */
global with sharing class bduBatchSplitter implements Database.Batchable<bduBatchParam>, Database.Stateful {
  
    global final Date refDate;
    global Integer scopeCounter; //Database.Stateful: au max 500 reports par heure
    global Integer hourCounter; //Database.Stateful
    global List<BduBatchParam> batchParams; //Database.Stateful 
    global Decimal LIMIT_REPORTS = 450; //Database.Stateful

    /**
     * A specific combinations of Business Units
     */
    public class Node  {
        public String BU1;
        public String BU2;
        public String BU3;
        public String BU4;
        public String BU5;

        public Node(String pBU1, String pBU2, String pBU3, String pBU4, String pBU5) {
            BU1 = pBU1;
            BU2 = pBU2;
            BU3 = pBU3;
            BU4 = pBU4;
            BU5 = pBU5;
        }
    }

    /**
     * A specific period of time
     */
    public class Period {
        public Date startDate;
        public Date endDate;
        public Integer year;
        public Integer semester;
        public Integer quarter;
        public Integer bimestre;
        public Integer month;
        
        public Period( Date pStartDate, Date pEndDate, Integer pYear, Integer pSemester, Integer pQuarter, 
                        Integer pBimestre, Integer pMonth ) {
            startDate = pStartDate;
            endDate = pEndDate;
            year = pYear;
            semester = pSemester;
            quarter = pquarter;
            bimestre = pBimestre;
            month = pmonth;
        }
    }

    global bduBatchSplitter( Date pDate_ref ) {
        LIMIT_REPORTS = [SELECT Reports_limit_calc__c FROM Param_calc_auto__c].Reports_limit_calc__c;
        refDate = pDate_ref; 
    }

    global Iterable<BduBatchParam> start(Database.BatchableContext bc) {
        scopeCounter = 0;
        hourCounter = 0;

        Set<Node> nodes = nodeSearch();
        List<Period> periodList = periodSearch();
        List<BDU_Indicateur__c> indicateurs;
        List<BduBatchParam> pendingParams = new List<BduBatchParam>();

        if(Test.isRunningTest()) {
            indicateurs = [SELECT Id, CT_isSOQL__c, CT_wantedColumn__c, ct_columnLabels__c, CT_Afficher_le_tableau__c, 
                                CT_Afficher_le_graphique__c, CT_Code__c, CT_Annuel__c, CT_Semestriel__c, 
                                CT_Trimestriel__c, CT_Bimestriel__c, CT_Mensuel__c
                           FROM BDU_Indicateur__c 
                           WHERE CT_Code__c IN ('IND01348','IND01304','IND01306','IND01327','IND01126','IND01335')];
        } else {
            indicateurs = [SELECT Id, CT_isSOQL__c, CT_wantedColumn__c, CT_columnLabels__c, CT_Afficher_le_tableau__c, 
                                CT_Afficher_le_graphique__c, CT_Annuel__c, CT_Semestriel__c, CT_Code__c, 
                                CT_Trimestriel__c, CT_Bimestriel__c, CT_Mensuel__c
                           FROM BDU_Indicateur__c
                           LIMIT 100000];
        }
        
        //Loops on all BDU_Indicateur__c, Nodes and period to contruct the needed parameters to be passed onto the batch
        for(BDU_Indicateur__c indicateur : indicateurs) {
            if(indicateur.CT_Code__c != null) {
                for(Period p : periodList ) {
                    if((indicateur.CT_Annuel__c==true && p.semester==null && p.quarter==null 
                                && p.bimestre==null && p.month==null) 
                            || (indicateur.CT_Semestriel__c==true && p.semester!=null) 
                            || (indicateur.CT_Trimestriel__c==true && p.quarter!=null) 
                            || (indicateur.CT_Bimestriel__c==true && p.bimestre!=null) 
                            || (indicateur.CT_Mensuel__c==true && p.month!=null)) {
                        pendingParams.add(new BduBatchParam(indicateur, null, null, null, null, null, p.startDate, 
                                                        p.endDate, p.year, p.semester, p.quarter, p.bimestre, p.month) );
                        
                        if(Test.isRunningTest()) {
                            return pendingParams;
                        }
                        for(Node n : nodes) {
                            pendingParams.add(new BduBatchParam(indicateur, n.BU1, n.BU2, n.BU3, n.BU4, n.BU5, 
                                p.startDate, p.endDate, p.year, p.semester, p.quarter, p.bimestre, p.month));

                            if(Test.isRunningTest() && pendingParams.size()>50) {
                                return pendingParams; 
                            }
                        }
                    }
                }
            }
        }

        batchParams = new List<bduBatchParam>();
        return pendingParams; 
    }

    

    /**
     * Launches the batches with the previously calculated parameters and within Salesforce governors limits 
     * (i.e. 500 reports/hour max)
     * @param  Database.BatchableContext info
     * @param  List<bduBatchParam>       scope         List of the parameters to process in the batch
     */
    global void execute( Database.BatchableContext info, List<bduBatchParam> scope ) {
        for(bduBatchParam currentParam : scope) {
            scopeCounter++;
            if(scopeCounter <= LIMIT_REPORTS) {
                if(!currentParam.indi.CT_isSOQL__c) {
                    //Remove existing values
                    if(!BDU_Valeur__c.sObjectType.getDescribe().isDeletable()) {
                        System.debug('User does not have sufficient rights.');
                        return;
                    }
                    List<BDU_Valeur__c> delList = [SELECT Id 
                        FROM BDU_Valeur__c 
                        WHERE CT_BDU_Indicateur__c =: currentParam.indi.id 
                        AND CT_BU1__c =: currentParam.BU1 
                        AND CT_BU2__c =: currentParam.BU2 
                        AND CT_BU3__c =: currentParam.BU3 
                        AND CT_BU4__c =: currentParam.BU4 
                        AND CT_BU5__c =: currentParam.BU5 
                        AND CT_Annee__c =: String.valueOf(currentParam.year) 
                        AND CT_semestre__c =: String.valueOf(currentParam.semester) 
                        AND CT_Trimestre__c =: String.valueOf(currentParam.quarter) 
                        AND CT_Bimestre__c =: String.valueOf(currentParam.bimestre) 
                        AND CT_Mois__c =: String.valueOf(currentParam.month)];
                    delete delList;

                    //Starts batch for the current parameters
                    BduValuesCalc.processReport(currentParam.indi.CT_Code__c, currentParam.indi.Id, currentParam.BU1, 
                        currentParam.BU2, currentParam.BU3, currentParam.BU4, currentParam.BU5, 
                        currentParam.startDate, currentParam.endDate, currentParam.year, currentParam.semester, 
                        currentParam.quarter, currentParam.bimestre, currentParam.month); 
                }
            } else {
                batchParams.add( currentParam );
                if(batchParams.size() >= LIMIT_REPORTS) {
                    DateTime nextBatch = DateTime.now().addHours(hourCounter);
                    if(hourCounter == 0) { //Initial batch
                        nextBatch = DateTime.now().addMinutes(10);
                    }
                    BduBatch clsCRON = new BduBatch( batchParams );
                    System.Schedule('Calcul automatique des BDU_valeur__c' + nextBatch.format(), 
                        '0 ' + nextBatch.minute() + ' ' + nextBatch.hour() + ' ' + nextBatch.day() + ' ' + 
                        nextBatch.month()+' ? '+nextBatch.year(), clsCRON);

                    batchParams = new List<bduBatchParam>(); //Resetting batchParams for the next batch
                    hourCounter++; //Next batch in the next hour
                }
            }
        }
    }

    /**
     * Launches a new batch the following hour if there are batch parameters still in the queue
     * @param  Database.BatchableContext bc
     */
    global void finish(Database.BatchableContext bc) {
        if(batchParams!=null && batchParams.size()>0) {
            DateTime nextBatch = DateTime.now().addHours(hourCounter);
            BduBatch clsCRON = new BduBatch(batchParams);
            System.Schedule('Calcul automatique des BDU_valeur__c ' + nextBatch.format(), 
                                '0 ' + nextBatch.minute() + ' ' + nextBatch.hour() + ' ' + nextBatch.day() + ' ' + 
                                nextBatch.month() + ' ? ' + nextBatch.year(), clsCRON);
        }
    }

    /**
     * Search all the possible nodes for the setting specified Business Units
     * @return Set<Node> Set of the unique nodes found
     */
    private Set<Node> nodeSearch() {
        Set<Node> nodes = new Set<Node>();

        //We only look at the specified Business Units
        String buOptions = Param_calc_auto__c.getOrgDefaults().organisation_BU__c;
        String col = ''; 
        List<String> selectedBUs = buOptions.split(';'); 
        Map<String,String> buMap  = new Map<String,String>{
            '1'=>GS_Affectation_poste__c.CT_BU1__c.getDescribe().getName(),
            '2'=>GS_Affectation_poste__c.CT_BU2__c.getDescribe().getName(),
            '3'=>GS_Affectation_poste__c.CT_BU3__c.getDescribe().getName(),
            '4'=>GS_Affectation_poste__c.CT_BU4__c.getDescribe().getName(),
            '5'=>GS_Affectation_poste__c.CT_BU5__c.getDescribe().getName()
        }; 

        //Creating select condition for future soql request
        for(String selectedBU : selectedBUs) {
            if(col=='') {
                col = buMap.get( selectedBU ) ;
            }
            else {
                col = col + ',' + buMap.get( selectedBU );
            }
        }
        
        String soql1 = 'SELECT ' + String.escapeSingleQuotes(col) + 
            ' FROM GS_Affectation_poste__c GROUP BY ' + String.escapeSingleQuotes(col);
        for(AggregateResult res : Database.query(soql1)) {
            String sBU1;
            String sBU2;
            String sBU3;
            String sBU4;
            String sBU5;
            for(String selectedBU : selectedBUs) {
                if(selectedBU.trim() == '1') {
                    sBU1 = String.valueOf( res.get( buMap.get(selectedBU) ) );
                } else if(selectedBU.trim() == '2') {
                    sBU2 = String.valueOf( res.get( buMap.get(selectedBU) ) );
                } else if(selectedBU.trim() == '3') {
                    sBU3 = String.valueOf( res.get( buMap.get(selectedBU) ) );
                } else if(selectedBU.trim() == '4') {
                    sBU4 = String.valueOf( res.get( buMap.get(selectedBU) ) );
                } else if(selectedBU.trim() == '5') {
                    sBU5 = String.valueOf( res.get( buMap.get(selectedBU) ) );
                }
                nodes.add(new Node(sBU1, sBU2, sBU3, sBU4, sBU5));
            }
        }
        return nodes;
    }

    /**
     * Searches all the possible periods
    * @return List<Period> All found periods
     */
    public List<Period> periodSearch() {
        List<Period> periodList = new List<Period>(); 

        if(refDate.month()==1) {
            //---pour 01/01/2014 => annuel: 01/01/2013 - 31/12/2013
            periodList.add(new Period( Date.newInstance(refDate.year()-1,1,1), refDate.addDays( -1 ), 
            refDate.year()-1, null, null, null, null));
            //---pour 01/01/2014 => 2eme semestre 2013: 01/07/2013 - 31/12/2013
            periodList.add(new Period( Date.newInstance(refDate.year()-1,07,1), refDate.addDays( -1 ), 
            refDate.year()-1, 2, null, null, null));
            //---pour 01/01/2014 => 4eme trimestre 2013: 01/10/2013 - 31/12/2013
            periodList.add(new Period( Date.newInstance(refDate.year()-1,10,1), refDate.addDays( -1 ), 
            refDate.year()-1, null, 4, null, null));
            //---pour 01/01/2014 => 6eme bimestre 2013: 01/11/2013 - 31/12/2013
            periodList.add(new Period( Date.newInstance(refDate.year()-1,11,01), refDate.addDays( -1 ), 
            refDate.year()-1, null, null, 6, null));
            //---pour 01/01/2014 => mensuel ann?e pr?c?dente
            periodList.add(new Period( Date.newInstance(refDate.year()-1,12,01), refDate.addDays( -1 ), 
            refDate.year()-1, null, null, null, 12));
        } else if(refDate.month()==3) {
            //---pour 01/03/2014 => 1er bimestre 2014: 01/01/2014 - 28/02/2014 (ann?e biscextile ? voir)
            periodList.add(new Period( Date.newInstance(refDate.year(),01,01), refDate.addDays( -1 ), 
            refDate.year(), null, null, 1, null));
            //--- mensuel
            periodList.add(new Period( Date.newInstance(refDate.year(),refDate.month()-1,01), refDate.addDays( -1 ), 
            refDate.year(), null, null, null, refDate.month()-1));
        } else if(refDate.month()==4) {
            //---pour 01/04/2014 => 1er trimestre 2014: 01/01/2014 - 31/03/2014
            periodList.add(new Period(
            Date.newInstance(refDate.year(),01,01), refDate.addDays( -1 ), 
            refDate.year(), null, 1, null, null));
            //--- mensuel
            periodList.add(new Period( Date.newInstance(refDate.year(),refDate.month()-1,01), refDate.addDays( -1 ), 
            refDate.year(), null, null, null, refDate.month()-1));
        } else if(refDate.month()==5) {
            //---pour 01/05/2014 => 2eme bimestre 2014: 01/03/2014 - 30/04/2014
            periodList.add(new Period( Date.newInstance(refDate.year(),03,01), refDate.addDays( -1 ), 
            refDate.year(), null, null, 2, null));
            //--- mensuel
            periodList.add(new Period( Date.newInstance(refDate.year(),refDate.month()-1,01), refDate.addDays( -1 ), 
            refDate.year(), null, null, null, refDate.month()-1));
        } else if(refDate.month()==7) {
            //---pour 01/07/2014 => 1er semestre 2014: 01/01/2014 - 30/06/2014
            periodList.add(new Period( Date.newInstance(refDate.year(),1,1), refDate.addDays( -1 ), 
            refDate.year(), 1, null, null, null));
            //---pour 01/07/2014 => 2eme trimestre 2014: 01/04/2014 - 30/06/2014
            periodList.add(new Period( Date.newInstance(refDate.year(),04,01), refDate.addDays( -1 ), 
            refDate.year(), null, 2, null, null));
            //---pour 01/07/2014 => 3eme bimestre 2014: 01/05/2014 - 30/06/2014
            periodList.add(new Period( Date.newInstance(refDate.year(),05,01), refDate.addDays( -1 ), 
            refDate.year(), null, null, 3, null));
            //--- mensuel
            periodList.add(new Period( Date.newInstance(refDate.year(),refDate.month()-1,01), refDate.addDays( -1 ), 
            refDate.year(), null, null, null, refDate.month()-1));
        } else if(refDate.month()==9) {
            //---pour 01/09/2014 => 4eme bimestre 2014: 01/07/2014 - 31/08/2014
            periodList.add(new Period( Date.newInstance(refDate.year(),07,01), refDate.addDays( -1 ), 
            refDate.year(), null, null, 4, null));
            //--- mensuel
            periodList.add(new Period( Date.newInstance(refDate.year(),refDate.month()-1,01), refDate.addDays( -1 ), 
            refDate.year(), null, null, null, refDate.month()-1));
        } else if(refDate.month()==10) {
            //---pour 01/10/2014 => 3eme trimestre 2014: 01/07/2014 - 30/09/2014
            periodList.add(new Period( Date.newInstance(refDate.year(),07,01), refDate.addDays( -1 ), 
            refDate.year(), null, 3, null, null));
            //--- mensuel
            periodList.add(new Period( Date.newInstance(refDate.year(),refDate.month()-1,01), refDate.addDays( -1 ),
            refDate.year(), null, null, null, refDate.month()-1));
        } else if(refDate.month()==11) {
            //---pour 01/11/2014 => 5eme bimestre 2014: 01/09/2014 - 31/10/2014
            periodList.add(new Period( Date.newInstance(refDate.year(),09,01), refDate.addDays( -1 ), 
            refDate.year(), null, null, 5, null));
            //--- mensuel
            periodList.add(new Period( Date.newInstance(refDate.year(),refDate.month()-1,01), refDate.addDays( -1 ),
            refDate.year(), null, null, null, refDate.month()-1));
        } else {
            //--- mensuel
            periodList.add(new Period( Date.newInstance(refDate.year(),refDate.month()-1,01), refDate.addDays( -1 ), 
            refDate.year(), null, null, null, refDate.month()-1));
        }

        return periodList;
    }
}