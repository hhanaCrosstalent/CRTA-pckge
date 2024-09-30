public with sharing class WelcomeToController {
   

    public class NewContactWrappper {

        @AuraEnabled
        public Date entryDate  {get;set;}
        @AuraEnabled
        public List<ContactWrappper> contacts {get;set;}
    }

    public class ContactWrappper implements Comparable
        {
           @AuraEnabled
            public string name{get;set;}
             @AuraEnabled
            public string title{get;set;}
            @AuraEnabled
            public string initial{get;set;}
            @AuraEnabled
            public Date anniversary{get;set;}
             @AuraEnabled
            public Date birdhdate{get;set;}
            @AuraEnabled
            public String urlPhoto{get;set;}
            @AuraEnabled
            public String localisation{get;set;}
            @AuraEnabled
            public String anciennete{get;set;}
             @AuraEnabled
            public Boolean isNotLast{get;set;}

            public ContactWrappper(string name, string initial, String urlPhoto, String title) {
                this.name = name;
                this.initial = initial;               
                this.urlPhoto=urlPhoto;
                this.title = title;                
            }

            public ContactWrappper(string name, string initial, String urlPhoto, String title, Date anniversary, String pays, String ville) {
                this(name,initial,urlPhoto, title);
                this.anniversary=anniversary;
                this.localisation=  (pays!=null&& ville!=null) ? (ville+', '+pays) : (pays!=null) ? pays : (ville!=null) ?  ville : '';
            }


            public Integer compareTo(Object toCompare) {
            ContactWrappper c = (ContactWrappper)toCompare;
            Date dateToComp = c.birdhdate != null ? Date.newInstance(2024,c.birdhdate.month(), c.birdhdate.day()) : Date.newInstance(2024,c.anniversary.month(), c.anniversary.day());
            Date currentDate = this.birdhdate != null ? Date.newInstance(2024,this.birdhdate.month(), this.birdhdate.day()) : Date.newInstance(2024,this.anniversary.month(), this.anniversary.day());
            Integer tmpResult = currentDate.daysBetween(dateToComp);
            return -tmpResult;
        }
        }


        @AuraEnabled
        public static List<NewContactWrappper> getNewContacts11(Integer lim, Integer intervalDays, String accApiName){

            System.debug('o');
            Map<Date, List<ContactWrappper>> returnedResult = new Map<Date, List<ContactWrappper>>();
            List<NewContactWrappper> returnedResultList = new List<NewContactWrappper>();
            try {
            Date todayDate = System.today();
            Date minDate = todayDate.toStartOfWeek().addDays(intervalDays);//-300
                        System.debug('o');
            /*Map<Id, Contact> newContacts = new Map<Id, Contact>([select Id, Title, Name, FirstName, LastName , 
            crta__Department_of_Birth__c , MailingCountry , 
            crta__CT_Date_of_entry_to_the_society__c  from Contact where crta__CT_Date_of_entry_to_the_society__c >= :minDate and crta__CT_Date_of_entry_to_the_society__c <= :todayDate order by crta__CT_Date_of_entry_to_the_society__c DESC, Name ASC limit :lim]);
             */

            
            String query = 'select Id, Name, FirstName, LastName , title, '
                       +' crta__Department_of_Birth__c , MailingCountry , '
           +'  crta__CT_Date_of_entry_to_the_society__c  from Contact where crta__CT_Date_of_entry_to_the_society__c >= :minDate and crta__CT_Date_of_entry_to_the_society__c <= :todayDate ';
           if (!String.isBlank(accApiName)) {
            String accIdByApiName = getAccountFromConnectedContact(accApiName);
               query += (' AND ' + accApiName + ' != null ');
               if(!String.isBlank(accIdByApiName)) {
                query += (' AND ' + accApiName + ' = :accIdByApiName');
               }
             }
           query += ' order by crta__CT_Date_of_entry_to_the_society__c DESC, Name ASC limit :lim ';
            Map<Id, Contact> newContacts = new Map<Id, Contact>();
            for(Contact c : Database.query(query)) {
                            System.debug(c);
               newContacts.put(c.Id,c);
            }

            System.debug('o');


            List<ContentVersion> pictureList = [SELECT Id, Title, LastModifiedDate, FirstPublishLocationId, Description   
                                                FROM ContentVersion 
                                                WHERE FirstPublishLocationId IN :newContacts.keySet() 
                                                AND Description = 'Profile_Picture'
                                                ORDER BY LastModifiedDate DESC];
            Map<Id, String> photoByContactId = new  Map<Id, String>();
            for(ContentVersion cv : pictureList) {
                   photoByContactId.put(cv.FirstPublishLocationId,'/sfc/servlet.shepherd/version/download/' + cv.Id);
            }
        
            
            List<User> users = [select Id, MediumPhotoUrl, crta__Contact__c from User where crta__Contact__c in :newContacts.keySet() and IsActive = true and (NOT MediumPhotoUrl  LIKE '%/profilephoto/005/M' )];
            for(User u : users) {
                if (!photoByContactId.containsKey(u.crta__Contact__c)){
                  photoByContactId.put(u.crta__Contact__c,u.MediumPhotoUrl);
                }
             }

          for(Contact c : newContacts.values()){
            if(returnedResult.containsKey(c.crta__CT_Date_of_entry_to_the_society__c)) {
                returnedResult.get(c.crta__CT_Date_of_entry_to_the_society__c).add(new ContactWrappper(c.name, c.FirstName.left(1).toUpperCase() + ' ' +c.LastName.left(1).toUpperCase(), photoByContactId.get(c.Id), c.title, c.crta__CT_Date_of_entry_to_the_society__c,c.MailingCountry, c.crta__Department_of_Birth__c)); 
            } else {
                returnedResult.put(c.crta__CT_Date_of_entry_to_the_society__c, new List<ContactWrappper>{new ContactWrappper(c.name, c.FirstName.left(1).toUpperCase() + ' ' +c.LastName.left(1).toUpperCase(), photoByContactId.get(c.Id), c.title, c.crta__CT_Date_of_entry_to_the_society__c,c.MailingCountry, c.crta__Department_of_Birth__c)}); 

            }
          }

          for(Date key: returnedResult.keySet()) {
            NewContactWrappper cw = new NewContactWrappper();
            cw.entryDate = key;
            cw.contacts = new List<ContactWrappper>();
            for(ContactWrappper c : returnedResult.get(key)) {
                 cw.contacts.add(c);
            }

            returnedResultList.add(cw);

          }

                          return returnedResultList;

                
            } catch (Exception e) {
                System.debug('an error occcurs while getting last incoming contacts '+ e.getMessage());
                
                           return returnedResultList;

             }
        }


        /*@AuraEnabled(cacheable=true)
        public static List<ContactWrappper>  getTodayIncommingContacts(Integer lim) {
            System.debug('lim '+ lim);

                    List<ContactWrappper> returnedContacts = new List<ContactWrappper>();

            Date todayDate = System.today();
            Map<Id, Contact> todayIncomingContacts = new Map<Id, Contact>([select Id, Name, FirstName, LastName  from Contact where crta__CT_Date_of_entry_to_the_society__c = :todayDate order by Name ASC LIMIT :lim ]);



            

            List<ContentVersion> pictureList = [SELECT Id, Title, LastModifiedDate, FirstPublishLocationId, Description   
                                                FROM ContentVersion 
                                                WHERE FirstPublishLocationId IN :todayIncomingContacts.keySet() 
                                                AND Description = 'Profile_Picture'
                                                ORDER BY LastModifiedDate DESC];
            Map<Id, String> photoByContactId = new  Map<Id, String>();
            for(ContentVersion cv : pictureList) {
                   photoByContactId.put(cv.FirstPublishLocationId,'/sfc/servlet.shepherd/version/download/' + cv.Id);
            }

            List<User> users = [select Id, MediumPhotoUrl, crta__Contact__c from User where crta__Contact__c in :todayIncomingContacts.keySet() and IsActive = true and (NOT MediumPhotoUrl  LIKE '%/profilephoto/005/M' )];
            for(User u : users) {
                if (!photoByContactId.containsKey(u.crta__Contact__c)) {
                  photoByContactId.put(u.crta__Contact__c,u.MediumPhotoUrl);
                }
             }

            for(Contact c : todayIncomingContacts.values()){
             returnedContacts.add(new ContactWrappper(c.name, c.FirstName.left(1).toUpperCase() + ' ' +c.LastName.left(1).toUpperCase(), photoByContactId.get(c.Id), c.title));
             }

              return returnedContacts;

           }*/

     /*@AuraEnabled
    public static List<ContactWrappper>  getNewContacts1(Integer lim) {
            System.debug('lim '+ lim);

                    List<ContactWrappper> returnedContacts = new List<ContactWrappper>();

            Date todayDate = System.today();
            Map<Id, Contact> todayIncomingContacts = new Map<Id, Contact>([select Id, Name, FirstName, LastName, title  from Contact where crta__CT_Date_of_entry_to_the_society__c <= :todayDate order by Name ASC LIMIT :lim ]);
            
            Map<Id, String> photoByContactId = new  Map<Id, String>();

             List<ContentVersion> pictureList = [SELECT Id, Title, LastModifiedDate, FirstPublishLocationId, Description   
                                                FROM ContentVersion 
                                                WHERE FirstPublishLocationId IN :todayIncomingContacts.keySet() 
                                                AND Description = 'Profile_Picture'
                                                ORDER BY LastModifiedDate DESC];
            for(ContentVersion cv : pictureList) {
                   photoByContactId.put(cv.FirstPublishLocationId,'/sfc/servlet.shepherd/version/download/' + cv.Id);
            }

        List<User> users = [select Id, MediumPhotoUrl, crta__Contact__c from User where crta__Contact__c in :todayIncomingContacts.keySet() and IsActive = true and (NOT MediumPhotoUrl  LIKE '%/profilephoto/005/M' )];
        for(User u : users) {
            if (!photoByContactId.containsKey(u.crta__Contact__c)) {
                         photoByContactId.put(u.crta__Contact__c,u.MediumPhotoUrl);
            }
        }

        for(Contact c : todayIncomingContacts.values()){
            returnedContacts.add(new ContactWrappper(c.name, c.FirstName.left(1).toUpperCase() + ' ' +c.LastName.left(1).toUpperCase(), photoByContactId.get(c.Id), c.title));
        }

        return returnedContacts;

        }*/


        @AuraEnabled
         public static String getAccountNameFromConnectedContact(String accApiName) {
          if (!String.isBlank(accApiName)) {
           Id accId = getAccountFromConnectedContact(accApiName);
           Account a = [select Name from Account where Id = :accId];
           return a!=null ? a.Name : '';
          }
          return '';           
        }

    
    
        private static Id getAccountFromConnectedContact(String accApiName) {
           String contactId = [SELECT crta__Contact__c FROM User WHERE Id = : UserInfo.getUserId() LIMIT 1].crta__Contact__c;
           if(!String.isBlank(contactId)) {
             //String accountApiName = accApiName.contains('__c') ? accApiName.split('__c') [0] + '__r' : accApiName;
             List<Contact> contactList = Database.query('select ' + accApiName+ ' from Contact where Id = :contactId');

             return contactList!=null && !contactList.isEmpty() ?  (Id) contactList.get(0).get(accApiName) : null;
           }
           return null;
        }


           @AuraEnabled(cacheable=true)
        public static List<NewContactWrappper> getIncommingContacts(Integer lim, Integer intervalDays, String functionApiName , String accApiName){
            functionApiName = String.isBlank(functionApiName) ? ' title ': functionApiName;
            System.debug('o 2 '+intervalDays );
            Map<Date, List<ContactWrappper>> returnedResult = new Map<Date, List<ContactWrappper>>();
            List<NewContactWrappper> returnedResultList = new List<NewContactWrappper>();
            //try {
          

            Date todayDate = System.today();
            Date minDate = todayDate.toStartOfWeek().addDays(intervalDays);//-300
                        System.debug('o');

            String query = 'select Id, ';
            query +=  functionApiName+' , ' ;
            query += ' Name, FirstName, LastName , '
                       +' crta__Department_of_Birth__c , MailingCountry , '
           +'  crta__CT_Date_of_entry_to_the_society__c  from Contact where crta__CT_Date_of_entry_to_the_society__c >= :minDate and crta__CT_Date_of_entry_to_the_society__c <= :todayDate ';
           if (!String.isBlank(accApiName)) {
            String accIdByApiName = getAccountFromConnectedContact(accApiName);
               query += (' AND ' + accApiName + ' != null ');
               if(!String.isBlank(accIdByApiName)) {
                query += (' AND ' + accApiName + ' = :accIdByApiName');
               }
             }
           query += ' order by crta__CT_Date_of_entry_to_the_society__c DESC, Name ASC ';
            Map<Id, Contact> newContacts = new Map<Id, Contact>();
            System.debug(query);
            for(Contact c : Database.query(query)) {
               newContacts.put(c.Id,c);
            }
             
            System.debug('o'+newContacts.size());



                List<ContentVersion> pictureList = [SELECT Id, Title, LastModifiedDate, FirstPublishLocationId, Description   
                                                FROM ContentVersion 
                                                WHERE FirstPublishLocationId IN :newContacts.keySet() 
                                                AND Description = 'Profile_Picture'
                                                ORDER BY LastModifiedDate DESC];
            Map<Id, String> photoByContactId = new  Map<Id, String>();
            for(ContentVersion cv : pictureList) {
                   photoByContactId.put(cv.FirstPublishLocationId,'/sfc/servlet.shepherd/version/download/' + cv.Id);
            }
            
            List<User> users = [select Id, MediumPhotoUrl, crta__Contact__c from User where crta__Contact__c in :newContacts.keySet() and IsActive = true and (NOT MediumPhotoUrl  LIKE '%/profilephoto/005/M' )];
        for(User u : users) {
            if (!photoByContactId.containsKey(u.crta__Contact__c)) {
            photoByContactId.put(u.crta__Contact__c,u.MediumPhotoUrl);
            }
        }

          for(Contact c : newContacts.values()){
            if(returnedResult.containsKey(c.crta__CT_Date_of_entry_to_the_society__c)) {
                returnedResult.get(c.crta__CT_Date_of_entry_to_the_society__c).add(new ContactWrappper(c.name, c.FirstName.left(1).toUpperCase() + ' ' +c.LastName.left(1).toUpperCase(), photoByContactId.get(c.Id), c.title, c.crta__CT_Date_of_entry_to_the_society__c,c.MailingCountry, c.crta__Department_of_Birth__c)); 
            } else {
                returnedResult.put(c.crta__CT_Date_of_entry_to_the_society__c, new List<ContactWrappper>{new ContactWrappper(c.name, c.FirstName.left(1).toUpperCase() + ' ' +c.LastName.left(1).toUpperCase(), photoByContactId.get(c.Id), c.title, c.crta__CT_Date_of_entry_to_the_society__c,c.MailingCountry, c.crta__Department_of_Birth__c)}); 

            }
          }
          Integer i = 0;
          for(Date key: returnedResult.keySet()) {
            if (i == 0) {
            NewContactWrappper cw = new NewContactWrappper();
            cw.entryDate = key;
            cw.contacts = new List<ContactWrappper>();
            for(ContactWrappper c : returnedResult.get(key)) {
                if (cw.contacts.size()<lim) { cw.contacts.add(c);}
            }

            returnedResultList.add(cw); i= i+1;
             }
          }

          System.debug(returnedResultList);

                          return returnedResultList;

                
            /*} catch (Exception e) {
                System.debug('an error occcurs while getting last incoming contacts '+ e.getMessage());
                
                           return returnedResultList;

        }*/
    }
    }