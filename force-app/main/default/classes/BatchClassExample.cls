global class BatchClassExample implements Database.Batchable<sObject> {
global List<Contact> start(Database.BatchableContext BC) {

List<Contact> conList= new List<Contact>();
for(Integer i=0;i<100;i++)
{
Contact ac= new Contact();
ac.LastName='con'+i;
ac.email='email'+i+'@gmail.com';    
conList.add(ac);
}
    

String query = 'SELECT Id, Name FROM Contact';
return conList;
}

global void execute(Database.BatchableContext BC, List<Contact> conList) {


try {
if(conList.size()>0)
{
//Insert conList;
}

} catch(Exception e) {
System.debug(e);
}

}

global void finish(Database.BatchableContext BC) {
// execute any post-processing operations like sending email
}
}