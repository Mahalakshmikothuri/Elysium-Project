/*
        Name           : AccountTriggerHandler
        Author         : Anil Vaishnav
        Date           : 16th February 2017
        Description    : Handler class of Account trigger
*/

public class AccountTriggerHandler{

    public static void afterUpdate(List<Account> newList, Map<Id, Account> oldMap){
        changeAddress(newList, oldMap);
    }
    
    private static void changeAddress(List<Account> newList, Map<Id, Account> oldMap){
        List<RecordType> listAccRecType = [Select Id from RecordType where sObjectType = 'Account' And Name = 'Household Account'];
        if(!listAccRecType.isEmpty()){
            Set<Id> setAccIds = new Set<Id>();
            for(Account acc : newList){
                if(acc.RecordTypeId == listAccRecType[0].Id && (acc.BillingStreet != oldMap.get(acc.Id).BillingStreet || 
                    acc.BillingCity != oldMap.get(acc.Id).BillingCity || acc.BillingState != oldMap.get(acc.Id).BillingState || 
                    acc.BillingPostalCode != oldMap.get(acc.Id).BillingPostalCode || acc.BillingCountry != oldMap.get(acc.Id).BillingCountry)){
                    
                    setAccIds.add(acc.Id);
                }
            }
            if(!setAccIds.isEmpty()){
                changeContactsAddress(setAccIds);
            }
        }
    }
    
    public static void changeContactsAddress(Set<Id> setAccIds){
        Set<Id> recTypeIds = new Set<Id>();
        for(RecordType recType : [Select Id from RecordType where sObjectType = 'Contact' And Name != 'Agent']){
            recTypeIds.add(recType.Id);
        }
        if(!recTypeIds.isEmpty()){
            List<Contact> listToUpdate = new List<Contact>();
            for(Account acc : [Select Id,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,
                                (Select Id,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,RecordTypeId from Contacts where RecordTypeId in :recTypeIds)
                                from Account where Id in :setAccIds]){
                for(Contact con : acc.Contacts){
                    
                    con.MailingStreet = acc.BillingStreet;
                    con.MailingCity = acc.BillingCity;
                    con.MailingState = acc.BillingState;
                    con.MailingPostalCode = acc.BillingPostalCode;
                    con.MailingCountry = acc.BillingCountry;
                    
                    listToUpdate.add(con);
                    
                }
            }
            if(!listToUpdate.isEmpty()){
                update listToUpdate;
            }
        }
    }
}