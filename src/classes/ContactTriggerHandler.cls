/*
        Name           : ContactTriggerHandler
        Author         : Anil Vaishnav
        Date           : 16th February 2017
        Description    : Handler class of Contact trigger
*/

public class ContactTriggerHandler{
    
    // before insert
    public static void beforeInsert(List<Contact> newList){
    
        // copy address from account
        copyAddressFromAccount(newList);
        copyphonenumber(newlist);
        
    }
    // before update
     public static void beforeupdate(List<Contact> newList,map<id,contact> oldmap){
    
        // copy address from account
        copyAddressFromAccount(newList);
        copyphonenumberbeforeupdate(newlist,oldmap);
        
    }
    
    
    // after insert
    public static void afterInsert(List<Contact> newList, Map<Id, Contact> newMap){
        
        // update account phon number
        updateAccountPhoneNo(newList, null, false);
    }
    
    // after udpate
    public static void afterUpdate(List<Contact> newList, Map<Id, Contact> oldMap){
    
        // change account address when contact's address is changed.
        changeAccountAddress(newList, oldMap);
        
        // change campaign member's address
        changeCampaignMemberAddress(newList, oldMap);
        
        // update account phon number
        updateAccountPhoneNo(newList, oldMap, true);
        
        // update affiliation records
        updateAffiliationRecords(newList, oldMap);
    }
    // ************* written by harsha in order to update contact po details*****************//
    private static void copyphonenumber(List<Contact> newList)
    {
    
    for(contact c:newlist)
    {
    
    if(c.Primary_Phone_Type__c!=null&&c.Primary_Phone_Type__c!='')
    {
    c.npe01__PreferredPhone__c=c.Primary_Phone_Type__c;
    if(c.Primary_Phone_Type__c=='Home')
    {
    c.HomePhone=c.Primary_Phone__c;
    }
    else if(c.Primary_Phone_Type__c=='Work')
    {
    c.npe01__WorkPhone__c=c.Primary_Phone__c;
    }
    else if(c.Primary_Phone_Type__c=='Mobile')
    {
    c.MobilePhone=c.Primary_Phone__c;
    }
    else if(c.Primary_Phone_Type__c=='Other')
    {
    c.OtherPhone=c.Primary_Phone__c;
    }
    
    }
    
    
    }
    
    }
    
    
    private static void copyphonenumberbeforeupdate(List<Contact> newList,map<id,contact> oldmap)
    {
    
    for(contact c:newlist)
    {
            Contact oldCon = oldMap.get(c.Id);
       
    if((c.Primary_Phone_Type__c!=null&&c.Primary_Phone_Type__c!=''&&c.Primary_Phone_Type__c!=oldcon.Primary_Phone_Type__c)||c.Primary_Phone__c!=oldcon.Primary_Phone__c)
    {
    c.npe01__PreferredPhone__c=c.Primary_Phone_Type__c;
    
    if(c.Primary_Phone_Type__c=='Home')
    {
    c.HomePhone=c.Primary_Phone__c;
        c.npe01__WorkPhone__c='';
            c.MobilePhone='';
               c.OtherPhone='';


    }
    else if(c.Primary_Phone_Type__c=='Work')
    {
    c.npe01__WorkPhone__c=c.Primary_Phone__c;
     c.MobilePhone='';
               c.OtherPhone='';
               c.HomePhone='';
    }
    else if(c.Primary_Phone_Type__c=='Mobile')
    {
    c.MobilePhone=c.Primary_Phone__c;
    c.OtherPhone='';
               c.HomePhone='';
               c.npe01__WorkPhone__c='';
    }
    else if(c.Primary_Phone_Type__c=='Other')
    {
    c.OtherPhone=c.Primary_Phone__c;
     c.HomePhone='';
               c.npe01__WorkPhone__c='';
               c.MobilePhone='';
    }
    
    }
    
    
    }
    
    }
    
    
    
    // this method copy address from account
    private static void copyAddressFromAccount(List<Contact> newList){
        Set<Id> recTypeIds = new Set<Id>();
        for(RecordType recType : [Select Id from RecordType where sObjectType = 'Contact' And Name != 'Agent']){
            recTypeIds.add(recType.Id);
        }
        if(!recTypeIds.isEmpty()){
            Set<Id> accIds = new Set<Id>();
            for(Contact con : newList){
                if(recTypeIds.contains(con.RecordTypeId) && con.AccountId != null){
                    accIds.add(con.AccountId);
                }
            }
            if(!accIds.isEmpty()){
                List<RecordType> listAccRecType = [Select Id from RecordType where sObjectType = 'Account' And Name = 'Household Account'];
                
                if(!listAccRecType.isEmpty()){
                    Map<Id, Account> mapAcc = new Map<Id, Account>([Select Id,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account where Id in :accIds And RecordTypeId = :listAccRecType[0].Id]);
                    if(mapAcc != null && !mapAcc.isEmpty()){
                        for(Contact con : newList){
                            if(recTypeIds.contains(con.RecordTypeId) && con.AccountId != null && mapAcc.containsKey(con.AccountId)){
                                Account acc = mapAcc.get(con.AccountId);
                                
                                con.MailingStreet = acc.BillingStreet;
                                con.MailingCity = acc.BillingCity;
                                con.MailingState = acc.BillingState;
                                con.MailingPostalCode = acc.BillingPostalCode;
                                con.MailingCountry = acc.BillingCountry;
                            }
                        }
                    }
                }
            }
        }
    }
    
    // this method change account's address when contact's addres is changed.
    private static void changeAccountAddress(List<Contact> newList, Map<Id, Contact> oldMap){
        Set<Id> recTypeIds = new Set<Id>();
        for(RecordType recType : [Select Id from RecordType where sObjectType = 'Contact' And Name != 'Agent']){
            recTypeIds.add(recType.Id);
        }
        if(!recTypeIds.isEmpty()){
            Set<Id> accIds = new Set<Id>();
            for(Contact con : newList){
                if(recTypeIds.contains(con.RecordTypeId) && con.AccountId != null){
                    accIds.add(con.AccountId);
                }
            }
            
            if(!accIds.isEmpty()){
                list<RecordType> listAccRecType = [Select Id from RecordType where sObjectType = 'Account' And Name = 'Household Account'];
                if(!listAccRecType.isEmpty()){
                    Map<Id, Account> mapAcc = new Map<Id, Account>([Select Id,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account where Id in :accIds And RecordTypeId = :listAccRecType[0].Id]);
                    
                    if(mapAcc != null && !mapAcc.isEmpty()){
                        Map<Id, Account> mapToUpdate = new Map<Id, Account>();    
                        for(Contact con : newList){
                            if(recTypeIds.contains(con.RecordTypeId) && con.AccountId != null && mapAcc.containsKey(con.AccountId) && (con.MailingStreet != oldMap.get(con.Id).MailingStreet || 
                                con.MailingCity != oldMap.get(con.Id).MailingCity || con.MailingState != oldMap.get(con.Id).MailingState || con.MailingPostalCode != oldMap.get(con.Id).MailingPostalCode ||
                                con.MailingCountry != oldMap.get(con.Id).MailingCountry)){
                                
                                Account acc = mapAcc.get(con.AccountId);
                                
                                acc.BillingStreet = con.MailingStreet;
                                acc.BillingCity = con.MailingCity;
                                acc.BillingState = con.MailingState;
                                acc.BillingPostalCode = con.MailingPostalCode;
                                acc.BillingCountry = con.MailingCountry;
                                
                                mapToUpdate.put(acc.Id, acc);
                            }
                        }
                        if(!mapToUpdate.isEmpty()){
                            update mapToUpdate.values();
                        }
                    }
                }
            }
        }
    }
    
    // this method change campaing member address 
    private static void changeCampaignMemberAddress(List<Contact> newList, Map<Id, Contact> oldMap){
        
        Set<Id> contactIdsSet = new Set<Id>();
        
        for(Contact con : newList){
            if(con.MailingStreet != oldMap.get(con.id).MailingStreet || con.MailingCity != oldMap.get(con.id).MailingCity
                || con.MailingState != oldMap.get(con.id).MailingState || con.MailingCountry != oldMap.get(con.id).MailingCountry
                || con.MailingPostalCode != oldMap.get(con.id).MailingPostalCode || con.npe01__Preferred_Email__c != oldMap.get(con.id).npe01__Preferred_Email__c
                || con.npe01__PreferredPhone__c != oldMap.get(con.id).npe01__PreferredPhone__c || con.npe01__HomeEmail__c != oldMap.get(con.id).npe01__HomeEmail__c 
                || con.npe01__WorkEmail__c != oldMap.get(con.id).npe01__WorkEmail__c || con.npe01__AlternateEmail__c != oldMap.get(con.id).npe01__AlternateEmail__c 
                || con.HomePhone != oldMap.get(con.id).HomePhone || con.npe01__WorkPhone__c != oldMap.get(con.id).npe01__WorkPhone__c 
                || con.MobilePhone != oldMap.get(con.id).MobilePhone || con.OtherPhone != oldMap.get(con.id).OtherPhone){
                
                contactIdsSet.add(con.id); 
                
            }   
        }
        
        if(contactIdsSet.size() > 0){
            List<Contact> contactListMain = [Select Id, AccountId, Title, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode,
                                        npe01__HomeEmail__c, npe01__WorkEmail__c, npe01__AlternateEmail__c, HomePhone, npe01__WorkPhone__c,
                                        MobilePhone, OtherPhone, npe01__Preferred_Email__c, npe01__PreferredPhone__c, 
                                        (Select Id, ContactId,
                                        Account__c, Account_Name__c, Member_Phone__c, Member_Email__c, Member_Mailing_Street__c, Member_Mailing_City__c,
                                        Member_Title__c , Member_Mailing_State__c, Member_Mailing_Zip__c 
                                        from CampaignMembers where Account_Name__c Like '%Household%') 
                                        from Contact where Id in :contactIdsSet];
            
            List<CampaignMember> cmpMemberList = new List<CampaignMember>();  
                                      
            for(Contact con: ContactListMain){
                for(CampaignMember cm : con.CampaignMembers){
                    if(cm.Account__c != null && cm.Account_Name__c != null && cm.Account_Name__c.contains('Household')){
                        cm.Member_Title__c = con.Title;
                        cm.Member_Mailing_Street__c = con.MailingStreet;
                        cm.Member_Mailing_City__c = con.MailingCity;
                        cm.Member_Mailing_State__c = con.MailingState;
                        cm.Member_Mailing_Zip__c = con.MailingPostalCode;
                        if(con.npe01__Preferred_Email__c == 'Personal'){
                            cm.Member_Email__c = con.npe01__HomeEmail__c;
                        }
                        if(con.npe01__Preferred_Email__c  == 'Work'){
                            cm.Member_Email__c = con.npe01__WorkEmail__c;
                        }
                        if(con.npe01__Preferred_Email__c == 'Alternate'){
                            cm.Member_Email__c = con.npe01__AlternateEmail__c;
                        }
                        if(con.npe01__PreferredPhone__c == 'Home'){
                            cm.Member_Phone__c = con.HomePhone;
                        }
                        if(con.npe01__PreferredPhone__c == 'Work'){
                            cm.Member_Phone__c = con.npe01__WorkPhone__c;
                        }
                        if(con.npe01__PreferredPhone__c == 'Mobile'){
                            cm.Member_Phone__c = con.MobilePhone;
                        }
                        if(con.npe01__PreferredPhone__c == 'Other'){
                            cm.Member_Phone__c = con.OtherPhone;
                        }
                        cmpMemberList.add(cm);
                    }
                }
            }
            
            if(cmpMemberList.size() > 0){
                update cmpMemberList;
            }
        }
    }
    
    // this method update accoun't phone number
    private static void updateAccountPhoneNo(List<Contact> newList, Map<Id, Contact> oldMap, Boolean isUpdate){
        Set<Id> accIds = new Set<Id>();
        for(Contact con : newList){
            if(con.AccountId != null && con.npsp__Primary_Contact__c && (!isUpdate || (isUpdate && con.Phone != oldMap.get(con.Id).Phone))){
                accIds.add(con.AccountId);
            }
        }
        
        if(accIds.size() > 0){
            Map<Id, Account> mapAcc = new Map<Id, Account>([Select Id, Phone from Account where Id in :accIds]);
            for(Contact con : newList){
                if(con.AccountId != null && con.npsp__Primary_Contact__c && (!isUpdate || (isUpdate && con.Phone != oldMap.get(con.Id).Phone)) && mapAcc.containsKey(con.AccountId)){
                    Account acc = mapAcc.get(con.AccountId);
                    acc.Phone = con.Phone;
                    mapAcc.put(con.AccountId, acc);
                }
            }
            if(mapAcc.size() > 0){
                update mapAcc.values();
            }
        }
    }
    
    // this method update affiliation address
    private static void updateAffiliationRecords(List<Contact> newList, Map<Id, Contact> oldMap){
        
        Set<Id> conIds = new Set<Id>();
        for(Contact con : newList){
            Contact oldCon = oldMap.get(con.Id);
            
            if(con.Email != oldCon.Email || con.Phone != oldCon.Phone || con.MailingCity != oldCon.MailingCity || con.MailingStreet != oldCon.MailingStreet ||
                con.MailingState != oldCon.MailingState || con.MailingPostalCode != oldCon.MailingPostalCode || con.MailingCountry != oldCon.MailingCountry){
                
                conIds.add(con.Id);
            }
        }
        
        if(conIds.size() > 0){
            List<npe5__Affiliation__c> listToUpdate = new List<npe5__Affiliation__c>();
            
            for(Contact con : [Select Id,Email,Phone,MailingCity,MailingStreet,MailingState,MailingPostalCode,MailingCountry,
                                (Select Id,Phone__c,Email__c,Mailing_City__c,Mailing_State__c,
                                Mailing_Street__c,Mailing_Zip__c from npe5__Affiliations__r where Always_Copy_From__c = 'Contact') 
                                from Contact where Id in :conIds]){
                                
                if(con.npe5__Affiliations__r != null && con.npe5__Affiliations__r.size() > 0){
                    for(npe5__Affiliation__c aff : con.npe5__Affiliations__r){
                        aff.Email__c = con.Email;
                        aff.Phone__c = con.Phone;
                        aff.Mailing_City__c = con.MailingCity;
                        aff.Mailing_Street__c = con.MailingStreet;
                        aff.Mailing_State__c = con.MailingState;
                        aff.Mailing_Zip__c = con.MailingPostalCode;
                        
                        listToUpdate.add(aff);
                    }
                }
            }
            
            if(listToUpdate.size() > 0){
                update listToUpdate;
            }
        }
    }
}