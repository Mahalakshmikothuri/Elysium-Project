trigger Update_Camp_Member_Address on Contact (after update) {

    //**** written by Apoorva Mathur to update the Phone, email and address fields in Campaign Member record if Contact address is changed ****//    
    
    Set<Id> ContactIdSet = new Set<Id>();
    Set<Id> AccountIdSet = new Set<Id>();
    List<Contact> ContactListMain = new List<Contact>();
    List<CampaignMember> CmpMemberList = new List<CampaignMember>();
    List<CampaignMember> CmpMemberListNew = new List<CampaignMember>();
    
    if(Trigger.IsUpdate){
        for(Contact con : Trigger.New){
            if(con.MailingStreet != Trigger.OldMap.get(con.id).MailingStreet || con.MailingCity != Trigger.OldMap.get(con.id).MailingCity
                || con.MailingState != Trigger.OldMap.get(con.id).MailingState || con.MailingCountry != Trigger.OldMap.get(con.id).MailingCountry
                || con.MailingPostalCode != Trigger.OldMap.get(con.id).MailingPostalCode || con.npe01__Preferred_Email__c != Trigger.OldMap.get(con.id).npe01__Preferred_Email__c
                || con.npe01__PreferredPhone__c != Trigger.OldMap.get(con.id).npe01__PreferredPhone__c || con.npe01__HomeEmail__c != Trigger.OldMap.get(con.id).npe01__HomeEmail__c 
                || con.npe01__WorkEmail__c != Trigger.OldMap.get(con.id).npe01__WorkEmail__c || con.npe01__AlternateEmail__c != Trigger.OldMap.get(con.id).npe01__AlternateEmail__c 
                || con.HomePhone != Trigger.OldMap.get(con.id).HomePhone || con.npe01__WorkPhone__c != Trigger.OldMap.get(con.id).npe01__WorkPhone__c 
                || con.MobilePhone != Trigger.OldMap.get(con.id).MobilePhone || con.OtherPhone != Trigger.OldMap.get(con.id).OtherPhone){
                
                ContactIdSet.add(con.id); 
                
            }   
        }
        
        if(ContactIdSet.size() > 0 && ContactIdSet != null){
            ContactListMain = [Select Id, AccountId, Title, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode,
                                        npe01__HomeEmail__c, npe01__WorkEmail__c, npe01__AlternateEmail__c, HomePhone, npe01__WorkPhone__c,
                                        MobilePhone, OtherPhone, npe01__Preferred_Email__c, npe01__PreferredPhone__c, (Select Id, ContactId,
                                        Account__c, Account_Name__c, Member_Phone__c, Member_Email__c, Member_Mailing_Street__c, Member_Mailing_City__c,
                                        Member_Title__c , Member_Mailing_State__c, Member_Mailing_Zip__c from CampaignMembers where 
                                        Account_Name__c Like '%Household%') from Contact where Id in: ContactIdSet];
            
        }
        for(Contact con: ContactListMain){
            for(CampaignMember cm : con.CampaignMembers){
                system.debug('Account name---->' + cm.Account_Name__c);
                if(cm.Account__c != null && cm.Account_Name__c.Contains('Household')){
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
                            system.debug('campaign member id---->' + cm.id);
                            CmpMemberList.add(cm);
                }
            }
        }
    }
    
    update CmpMemberList;
}