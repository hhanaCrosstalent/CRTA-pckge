//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Class holding parameters values between batches
 *
 * @author Crosstalent
 * @group BDU-Backend
 * @version 1.1
 */
global class bduBatchParam {
    global BDU_Indicateur__c indi;
    global String BU1;
    global String BU2;
    global String BU3;
    global String BU4;
    global String BU5;
    global Date startDate;
    global Date endDate;
    global Integer year;
    global Integer semester;
    global Integer quarter;
    global Integer bimestre;
    global Integer month;

    global bduBatchParam(BDU_Indicateur__c pIndi, String pBU1, String pBU2, String pBU3, String pBU4,  String pBU5, Date pStartDate, Date pEndDate, Integer pYear, Integer pSemester, Integer pQuarter, Integer pBimestre, Integer pMonth) { 
        indi = pIndi; 
        BU1 = pBU1; 
        BU2 = pBU2; 
        BU3 = pBU3; 
        BU4 = pBU4; 
        BU5 = pBU5;
        startDate = pStartDate; 
        endDate = pEndDate; 
        year = pYear; 
        semester = pSemester; 
        quarter = pQuarter; 
        bimestre = pBimestre; 
        month = pMonth;
    }
}