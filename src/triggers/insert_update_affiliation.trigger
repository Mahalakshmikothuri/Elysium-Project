trigger insert_update_affiliation on npe5__Affiliation__c (before insert,before update) {

list<id> accid= new list<id>();
list<id> conid= new list<id>();

list<npe5__Affiliation__c> updatelst= new list<npe5__Affiliation__c>();
if(trigger.isbefore&&trigger.isinsert)
{
for(npe5__Affiliation__c aff:trigger.new)
{
   // npe5__Affiliation__c oldaff = Trigger.oldMap.get(aff.Id);

//if(aff.Always_Copy_From__c!=oldaff.Always_Copy_From__c&&aff.Always_Copy_From__c!=null)
if(aff.Always_Copy_From__c!=null)

{

if(aff.Always_Copy_From__c=='Contact')
{

conid.add(aff.npe5__Contact__c);
}
if(aff.Always_Copy_From__c=='Organization')
{

accid.add(aff.npe5__Organization__c);
}
}

}

if(accid.size()!=null)
{


list<account> acc=[select id, billingCity,billingStreet,billingState,billingPostalCode from account where id in :accid];
for(account ac:acc)
{
for(npe5__Affiliation__c a:trigger.new)
{
if(ac.id==a.npe5__Organization__c)
{
a.Mailing_City__c=ac.billingCity;
a.Mailing_State__c=ac.billingState;
a.Mailing_Street__c=ac.billingStreet;
a.Mailing_Zip__c=ac.billingPostalCode;
//updatelst.add(a);
}
}




}
}
if(conid.size()!=null)
{
list<contact> con=[select id,mailingcity,email,phone,MailingStreet,MailingState,MailingPostalCode from contact where id in:conid]; 

for(contact c:con)
{
for(npe5__Affiliation__c a:trigger.new)
{

if(c.id==a.npe5__Contact__c)
{
a.phone__c=c.phone;
a.email__c=c.email;
a.Mailing_City__c=c.MailingCity;
a.Mailing_State__c=c.MailingState;
a.Mailing_Street__c=c.MailingStreet;
a.Mailing_Zip__c=c.MailingPostalcode;
//updatelst.add(a);


}

}


}

}
//update updatelst;
}

if(trigger.isbefore&&trigger.isupdate)
{
for(npe5__Affiliation__c aff:trigger.new)
{
    npe5__Affiliation__c oldaff = Trigger.oldMap.get(aff.Id);

if(aff.Always_Copy_From__c!=oldaff.Always_Copy_From__c&&aff.Always_Copy_From__c!=null)

{

if(aff.Always_Copy_From__c=='Contact')
{

conid.add(aff.npe5__Contact__c);
}
if(aff.Always_Copy_From__c=='Organization')
{

accid.add(aff.npe5__Organization__c);
}
}

}

if(accid.size()!=null)
{


list<account> acc=[select id, billingCity,billingStreet,billingState,billingPostalCode from account where id in :accid];
for(account ac:acc)
{
for(npe5__Affiliation__c a:trigger.new)
{
if(ac.id==a.npe5__Organization__c)
{
a.Mailing_City__c=ac.billingCity;
a.Mailing_State__c=ac.billingState;
a.Mailing_Street__c=ac.billingStreet;
a.Mailing_Zip__c=ac.billingPostalCode;
//updatelst.add(a);
}
}




}
}
if(conid.size()!=null)
{
list<contact> con=[select id,mailingcity,email,phone,MailingStreet,MailingState,MailingPostalCode from contact where id in:conid]; 
system.debug(con);
for(contact c:con)
{
for(npe5__Affiliation__c a:trigger.new)
{

if(c.id==a.npe5__Contact__c)
{
a.phone__c=c.phone;
a.email__c=c.email;
a.Mailing_City__c=c.MailingCity;
a.Mailing_State__c=c.MailingState;
a.Mailing_Street__c=c.MailingStreet;
a.Mailing_Zip__c=c.MailingPostalcode;
//updatelst.add(a);


}

}


}

}
//update updatelst;
}


}