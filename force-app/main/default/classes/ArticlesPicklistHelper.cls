//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * @Author : Ophélie ABOA
 * @Date: 26/11/2018 
 * @Description : Création d'une picklist servant à l'affichage des types d'articles disponibles
 * 
*/
public class ArticlesPicklistHelper extends VisualEditor.DynamicPickList{
    public override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(Label.None, '');
        return defaultValue;
    }

    public override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows myValues = new VisualEditor.DynamicPickListRows();
        VisualEditor.DataRow valueFirst = new VisualEditor.DataRow(Label.Archives, 'Archives');
        myValues.addRow(valueFirst);

        for(RecordType r : [SELECT Id, toLabel(Name), DeveloperName FROM RecordType WHERE SobjectType = 'crta__Article__c']) {
            VisualEditor.DataRow value = new VisualEditor.DataRow(r.Name, r.DeveloperName);
            myValues.addRow(value);
        }
        return myValues;
    }
}