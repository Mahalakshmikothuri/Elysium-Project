trigger Affilation_update on Contact (after update) {
//************************ Written by harsha to update affiliated record address*************************//
list<id>conid= new list<id>();
Map<id,contact> conobj= new map<id,contact>();
list<npe5__Affiliation__c> affilationlst = new list<npe5__Affiliation__c>();
for(contact c:trigger.new)
{

    contact  oldcon = Trigger.oldMap.get(c.Id);

if(c.Email!=oldcon.Email||c.Phone!=oldcon.Phone||c.MailingCity!=oldcon.MailingCity||c.MailingStreet!=oldcon.MailingStreet||c.MailingState!=oldcon.MailingState||c.MailingPostalCode!=oldcon.MailingPostalCode)
{

conid.add(c.id);
conobj.put(c.id,c);

}

list<npe5__Affiliation__c> affObj=[select id,Always_Copy_Contact_Preferred__c,Always_Copy_From__c,Phone__c,email__c,Mailing_City__c,Mailing_State__c,
Mailing_Street__c,Mailing_Zip__c,npe5__Contact__c from npe5__Affiliation__c  where npe5__Contact__c in :conid];

for(npe5__Affiliation__c a:affobj)
{
if(conobj.get(a.npe5__Contact__c).id!=null&&a.Always_Copy_From__c=='Contact')
{
a.phone__c=conobj.get(a.npe5__Contact__c).phone;
a.email__c=conobj.get(a.npe5__Contact__c).email;
a.Mailing_City__c=conobj.get(a.npe5__Contact__c).MailingCity;
a.Mailing_State__c=conobj.get(a.npe5__Contact__c).MailingState;
a.Mailing_Street__c=conobj.get(a.npe5__Contact__c).MailingStreet;
a.Mailing_Zip__c=conobj.get(a.npe5__Contact__c).MailingPostalcode;

affilationlst.add(a);




}


}
update affilationlst ;

}

}