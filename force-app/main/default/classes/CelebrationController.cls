public with sharing class CelebrationController {


    public class ContactWrappper implements Comparable{
           @AuraEnabled
            public string name{get;set;}
            @AuraEnabled
            public string initial{get;set;}
            @AuraEnabled
            public Date anniversary{get;set;}
             @AuraEnabled
            public Date birdhdate{get;set;}
            @AuraEnabled
            public String urlPhoto{get;set;}
            @AuraEnabled
            public String anciennete{get;set;}
             @AuraEnabled
            public Boolean isNotLast{get;set;}

            public ContactWrappper(string name, string initial, Date anniversary, Date birdhdate,String urlPhoto, Decimal anciennete) {
                this.name = name;
                this.initial = initial;
                this.anniversary = anniversary;
                this.birdhdate=birdhdate;
                this.urlPhoto=urlPhoto;
                this.isNotLast = true;
                if (anciennete!=null){
                this.anciennete=' - ' + Integer.valueOf(anciennete)  + ' e ' + Label.anniversary;
                }
                
            }


            public Integer compareTo(Object toCompare) {
            ContactWrappper c = (ContactWrappper)toCompare;
            Date dateToComp = c.birdhdate != null ? Date.newInstance(2024,c.birdhdate.month(), c.birdhdate.day()) : Date.newInstance(2024,c.anniversary.month(), c.anniversary.day());
            Date currentDate = this.birdhdate != null ? Date.newInstance(2024,this.birdhdate.month(), this.birdhdate.day()) : Date.newInstance(2024,this.anniversary.month(), this.anniversary.day());
            //dateToComp = System.today();
            Integer tmpResult = currentDate.daysBetween(dateToComp);
            return tmpResult;
        }
        }



    public static Contact getCurrContact() {
        List<Contact> logged = [
            SELECT Id, Name, ReportsToId
            FROM Contact
            WHERE Id =: getCurrContactId()
            LIMIT 1
        ];
        return (logged != null && !logged.isEmpty()) ? logged[0] : null;
    }

    public static String getCurrContactId() {
        return [
            SELECT crta__Contact__c
            FROM User 
            WHERE Id =: UserInfo.getUserId()
            LIMIT 1
        ].crta__Contact__c;
    }


    @AuraEnabled(cacheable=true)
    public static List<ContactWrappper> getContactsByBirthday(Integer lim, Integer intervalDays, List<String> userView) {
        List<ContactWrappper> returnedContacts = new List<ContactWrappper>();

        Date requestedDate = System.today().addDays(intervalDays);
        Date today = System.today();

     /*  
        Map<Id, Contact> birthdates =  new Map<Id, Contact>([SELECT Id, Name, Birthdate, FirstName, LastName FROM Contact WHERE Birthdate != null and CALENDAR_MONTH(Birthdate)=:requestedDate.month() and DAY_IN_MONTH(Birthdate)=:requestedDate.day() ORDER BY Birthdate ]);
        Map<Id,Contact> anniversaries =  new Map<Id, Contact>([
            SELECT Id, Name, crta__CT_Date_of_entry_to_the_society__c, FirstName, LastName, crta__Anciennete_Calculee__c FROM Contact WHERE crta__CT_Date_of_entry_to_the_society__c != null and CALENDAR_MONTH(crta__CT_Date_of_entry_to_the_society__c)=:requestedDate.month() and DAY_IN_MONTH(crta__CT_Date_of_entry_to_the_society__c)=:requestedDate.day() ORDER BY crta__CT_Date_of_entry_to_the_society__c ]);
 */
       String whereClauseView = '';
       if (userView.contains('employee')) {
            Contact currEmployee = getCurrContact();
            String reportsToId = (String.isBlank(currEmployee.ReportsToId)) ? '' : currEmployee.ReportsToId;
            whereClauseView += ' AND (ReportsToId = \'' + reportsToId + '\'' + ' OR Id = \'' + reportsToId + '\'' + ' OR Id = \'' + currEmployee.Id + '\')';
        }
        /*if(dynamicFilters.size() > 0){
            for(FilterWrapper filter : dynamicFilters) {
                
                if(filter.objectApiName == 'Contact' ){
                    if(filter.idValue != null && String.isBlank(filter.idValue) == false){
                        if(filter.type == 'text'){
                            whereClauseView+=' AND '+filter.fieldApiName+' Like \''+filter.idValue+'%\''; 
                        }else if(filter.type == 'pickList'){
                            whereClauseView+=' AND '+filter.fieldApiName+' = \''+filter.idValue+'\''; 
                        }
                        else{
                            if(filter.fieldApiName.contains('.')) {
                                filter.fieldApiName = filter.fieldApiName.substringBefore('.')+'.Id';
                            }
                            whereClauseView += ' AND ' + filter.fieldApiName + ' = \'' + filter.idValue + '\'';  
                        } 
                        
                    }
                }
            }
        }*/
      
        Map<Id, Contact> birthdates =  new Map<Id, Contact>();
        String contactQuery =   '';
        if (intervalDays == null || intervalDays == 0) {
            contactQuery =   'SELECT Id, Name, Birthdate, FirstName, LastName FROM Contact WHERE Birthdate != null and Birthdate = TODAY and crta__Is_visible_birthday__c = true '+whereClauseView+' ORDER BY Birthdate ASC';
       
        } else {
          contactQuery =   'SELECT Id, Name, Birthdate, FirstName, LastName FROM Contact WHERE Birthdate != null and Birthdate >= TODAY and Birthdate <= NEXT_N_DAYS:'+intervalDays+' and crta__Is_visible_birthday__c = true '+whereClauseView+' ORDER BY Birthdate ASC';
        }
        List<Contact> contactBirthdays = Database.query(contactQuery);


        for (Contact c : contactBirthdays){
            birthdates.put(c.Id, c);
        }

        String annivQuery = requestedDate.year() == today.year() ? 
        'SELECT Id, Name, crta__CT_Date_of_entry_to_the_society__c, FirstName, LastName, crta__Anciennete_Calculee__c FROM Contact WHERE crta__CT_Date_of_entry_to_the_society__c != null and crta__Anciennete_Calculee__c >= 1  and '
        +
'((CALENDAR_MONTH(crta__CT_Date_of_entry_to_the_society__c) = '+today.month()+' and DAY_IN_MONTH(crta__CT_Date_of_entry_to_the_society__c) >= '+today.day()+') or CALENDAR_MONTH(crta__CT_Date_of_entry_to_the_society__c) > '+today.month()+') '
+ 'and '
+ ' ((CALENDAR_MONTH(crta__CT_Date_of_entry_to_the_society__c) = '+requestedDate.month()+' and DAY_IN_MONTH(crta__CT_Date_of_entry_to_the_society__c) <= '+requestedDate.day()+') or CALENDAR_MONTH(crta__CT_Date_of_entry_to_the_society__c) < '+requestedDate.month()+')'
+' and crta__Is_visible_anniversary__c = true '+whereClauseView+' order by crta__CT_Date_of_entry_to_the_society__c ASC' : 
         
'SELECT Id, Name, crta__CT_Date_of_entry_to_the_society__c, FirstName, LastName, crta__Anciennete_Calculee__c FROM Contact WHERE crta__CT_Date_of_entry_to_the_society__c != null and crta__Anciennete_Calculee__c >= 1 and '+ 
         '( (  ' +

+ '(( CALENDAR_MONTH(crta__CT_Date_of_entry_to_the_society__c) = ' + today.month() +' and  DAY_IN_MONTH(crta__CT_Date_of_entry_to_the_society__c) >= '+today.day() + ') or CALENDAR_MONTH(crta__CT_Date_of_entry_to_the_society__c) > '+today.month()+') '

+ ' and ((CALENDAR_MONTH(crta__CT_Date_of_entry_to_the_society__c) = 12 and DAY_IN_MONTH(crta__CT_Date_of_entry_to_the_society__c) <= 31) or CALENDAR_MONTH(crta__CT_Date_of_entry_to_the_society__c) < 12) '

+ ' ) OR ( ((CALENDAR_MONTH(crta__CT_Date_of_entry_to_the_society__c) = 1 and DAY_IN_MONTH(crta__CT_Date_of_entry_to_the_society__c) >= 1 ) or CALENDAR_MONTH(crta__CT_Date_of_entry_to_the_society__c) > 1) '

+' and ((CALENDAR_MONTH(crta__CT_Date_of_entry_to_the_society__c) = '+requestedDate.month()+' and DAY_IN_MONTH(crta__CT_Date_of_entry_to_the_society__c) <= '+requestedDate.day()+') or CALENDAR_MONTH(crta__CT_Date_of_entry_to_the_society__c) < '+requestedDate.month()+')) ) ' 
                 
 +   ' and crta__Is_visible_anniversary__c = true ' +whereClauseView+' order by crta__CT_Date_of_entry_to_the_society__c ASC';
        System.debug('annivQuery ');
        System.debug(annivQuery);
        List<Contact> contactANNIV =  Database.query(annivQuery);
        Map<Id, Contact> anniversaries =  new Map<Id, Contact>();
        for (Contact c : contactANNIV){
            anniversaries.put(c.Id, c);
        }
        
        Set<Id> contactIds = new Set<Id>();
        contactIds.addAll(anniversaries.keySet());
        contactIds.addAll(birthdates.keySet());


        List<ContentVersion> pictureList = [SELECT Id, Title, LastModifiedDate, FirstPublishLocationId, Description   
                                                FROM ContentVersion 
                                                WHERE FirstPublishLocationId IN :contactIds 
                                                AND Description = 'Profile_Picture'
                                                ORDER BY LastModifiedDate DESC];
            Map<Id, String> photoByContactId = new  Map<Id, String>();
            for(ContentVersion cv : pictureList) {
                   photoByContactId.put(cv.FirstPublishLocationId,'/sfc/servlet.shepherd/version/download/' + cv.Id);
            }
        
            
        

        List<User> users = [select Id, MediumPhotoUrl, crta__Contact__c from User where crta__Contact__c in :contactIds and IsActive = true and (NOT MediumPhotoUrl  LIKE '%/profilephoto/005/M' )];
        //Map<Id, String> photoByContactId = new  Map<Id, String>();
        for(User u : users) {
             if (!photoByContactId.containsKey(u.crta__Contact__c)){
                  photoByContactId.put(u.crta__Contact__c,u.MediumPhotoUrl);
                }
            //photoByContactId.put(u.crta__Contact__c,u.MediumPhotoUrl);
        }

        /*if ( lim != 0) { //birthdates != null && anniversaries != null && !birthdates.isEmpty() && !anniversaries.isEmpty()
            Integer birthdaysSize = birthdates.size();
            Integer anniversariesSize = anniversaries.size();
         //Integer maxSize = Math.max(birthdaysSize, anniversariesSize);
         Integer j = 0;
         for(Integer i=0; i<lim/2; i++) { j++;
            if (i<birthdaysSize) {
                Contact c = birthdates.values().get(i);
                returnedContacts.add(new ContactWrappper(c.Name,c.FirstName.left(1).toUpperCase()+ ' ' +c.LastName.left(1).toUpperCase(), null, c.Birthdate, photoByContactId.get(c.Id), null));
            }
            if (i<anniversariesSize) {
                Contact c = anniversaries.values().get(i);
                returnedContacts.add(new ContactWrappper(c.Name,c.FirstName.left(1).toUpperCase()+ ' ' +c.LastName.left(1).toUpperCase(), c.crta__CT_Date_of_entry_to_the_society__c, null, photoByContactId.get(c.Id), c.crta__Anciennete_Calculee__c));
            }
         }

          for(Integer i=j; i<lim && i<birthdates.size() &&  returnedContacts.size() < lim;  i++) {
            System.debug(i);
            Contact c =  birthdates.values().get(i);
                returnedContacts.add(new ContactWrappper(c.Name,c.FirstName.left(1).toUpperCase() + ' ' +c.LastName.left(1).toUpperCase(),null, c.Birthdate, photoByContactId.get(c.Id), null));
            }
             for(Integer i=j; i<lim && i< anniversaries.size() && returnedContacts.size() < lim; i++) {
                            System.debug(i);
                Contact c =  anniversaries.values().get(i);
                returnedContacts.add(new ContactWrappper(c.Name,c.FirstName.left(1).toUpperCase() + ' ' +c.LastName.left(1).toUpperCase(),c.crta__CT_Date_of_entry_to_the_society__c, null, photoByContactId.get(c.Id), c.crta__Anciennete_Calculee__c));
            }


        } else {*/
         for(Contact c : anniversaries.values()) {
                returnedContacts.add(new ContactWrappper(c.Name,c.FirstName.left(1).toUpperCase() + ' ' +c.LastName.left(1).toUpperCase(), c.crta__CT_Date_of_entry_to_the_society__c, null, photoByContactId.get(c.Id), c.crta__Anciennete_Calculee__c));
            }
         for(Contact c : birthdates.values()) {
                returnedContacts.add(new ContactWrappper(c.Name,c.FirstName.left(1).toUpperCase() + ' ' +c.LastName.left(1).toUpperCase(), null, c.Birthdate, photoByContactId.get(c.Id), null));
            }
       // }

        if (!returnedContacts.isEmpty()) {
            returnedContacts.sort();
       
            returnedContacts=sortedByToday(today,returnedContacts);

            

                

                if(lim != null && lim!=0) {
            List<ContactWrappper> limittedList = new List<ContactWrappper>();

for (Integer i = 0; i< lim && i<returnedContacts.size(); i++) {
    limittedList.add(returnedContacts[i]);
}
returnedContacts = limittedList;
        }

                    returnedContacts.get(returnedContacts.size()-1).isNotLast = false;

        }

    

        return returnedContacts;
    }

    private static List<ContactWrappper> sortedByToday(Date today, List<ContactWrappper> returnedContacts) {
        List<ContactWrappper> finalList = new List<ContactWrappper>();
        List<ContactWrappper> post = new List<ContactWrappper>();
        List<ContactWrappper> last = new List<ContactWrappper>();
        for(Integer i = (returnedContacts.size()-1); i>=0;i--){
                    System.debug(i);
                    ContactWrappper c = returnedContacts.get(i);
                    Date thedate = c.birdhdate != null ? Date.newInstance(2024,c.birdhdate.month(), c.birdhdate.day()) : Date.newInstance(2024,c.anniversary.month(), c.anniversary.day());
                  if (thedate >= Date.newInstance(2024, today.month(), today.day())) {
                         post.add(c);
                  } /*else {
                      post.add(c);
                  } */      
                }

                 for(Integer i = 0; i<returnedContacts.size();i++){
                                System.debug(i);
                    ContactWrappper c = returnedContacts.get(i);
                    Date thedate = c.birdhdate != null ? Date.newInstance(2024,c.birdhdate.month(), c.birdhdate.day()) : Date.newInstance(2024,c.anniversary.month(), c.anniversary.day());
                  if (thedate < Date.newInstance(2024, today.month(), today.day())) {
                         last.add(c);
                  } /*else {
                      post.add(c);
                  } */      
                }

                finalList.addAll(post);
                finalList.addAll(last);
                return finalList;
    }



    

}