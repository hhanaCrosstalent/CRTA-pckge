public class PercentageController {
      @AuraEnabled(cacheable=true)
     public  static List<Double> findOrderPercentage(String   objectApiName, String   fieldApiName , String recordId) {
        if (!String.isBlank(objectApiName) && !String.isBlank(fieldApiName) && !String.isBlank(recordId)) {
       /*String   objectApiName = 'crta__EI_Entretien__c' ;
        String   fieldApiName = 'crta__EI_Statut__c';*/
        crta__EI_Entretien__c record = [SELECT crta__EI_Statut__c FROM crta__EI_Entretien__c WHERE Id = :recordId];
         List<Double> percentageOfSelectedValues = new List<Double>();
         system.debug('Je suissss la dans Calcul pourcentage ');
        // Récupérer la valeur sélectionnée à partir de l'enregistrement
        String selectedValue = (String)record.get(fieldApiName);
        
        // Récupérer les valeurs possibles du champ de liste de sélection depuis les métadonnées de l'objet
        List<String> allValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap().get(fieldApiName).getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry picklistEntry : picklistValues) {
            allValues.add(picklistEntry.getValue());
        }
        
        // Si une valeur est sélectionnée dans l'enregistrement
        if (selectedValue != null) {
            system.debug('selectedValue'+ selectedValue) ;
            // Si la valeur sélectionnée existe dans la liste des valeurs possibles
                        system.debug('selectedValue'+ allValues) ;
            if (allValues.contains(selectedValue)) {
                // Calculer le pourcentage de la valeur sélectionnée par rapport au total
                Integer order = allValues.indexOf(selectedValue);
                system.debug('order'+ order) ;
                Integer totalValuesCount = allValues.size();
                system.debug('totalValuesCount'+totalValuesCount) ;
                Double percentage = (order +1) / (Double)totalValuesCount * 100;
                percentageOfSelectedValues.add(percentage);
            }
        }
        system.debug('Percent Test'+percentageOfSelectedValues);
        return percentageOfSelectedValues;
    
        }
        return null;
    }
/*
List<Double> percentageOfSelectedValues = findOrderPercentage('crta__EI_Entretien__c', 'crta__EI_Statut__c', record);
//System.debug(percentageOfSelectedValues);*/

}