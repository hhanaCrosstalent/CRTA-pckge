@IsTest(SeeAllData=true)
private class indicateurHelper_test {
    
    @IsTest 
    private static void showReport() {
        indicateurHelper.showReport('test');
        indicateurHelper.showReport('IND01103c');
        System.assert(indicateurHelper.showReport('test') != null);
        System.assert(indicateurHelper.showReport('IND01103c') != null);
    }
}