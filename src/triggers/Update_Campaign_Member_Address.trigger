trigger Update_Campaign_Member_Address on CampaignMember (before insert, before update) {

    //**** written by Apoorva Mathur to update the Phone, email and address fields in Campaign Member record based on the selection of Account ****//
    
    //If Account field is null or if the household account is selected, then the phone, email and address field values of the Contact are copied 
    //in the Campaign member record.
    //If the Account is an organization account, then the phone, email and address values are copied from the Contact's related affiliation record.
    
        Set<Id> ConIds = new Set<Id>();
        Set<Id> AccIds = new Set<Id>();
        
        for(CampaignMember cm : Trigger.New){
            if(cm.ContactId != null){
                ConIds.add(cm.ContactId);
            }   
            if(cm.Account__c != null){
                AccIds.add(cm.Account__c);
            } 
        }
        List<Account> AccountList = [Select Id from Account];
        List<Account> AccList = [Select Id, Name from Account where Id in : AccIds];
        List<Contact> ConList = [Select Id, AccountId, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode,
                                npe01__HomeEmail__c, npe01__WorkEmail__c, npe01__AlternateEmail__c, HomePhone, npe01__WorkPhone__c,
                                MobilePhone, OtherPhone, npe01__Preferred_Email__c, npe01__PreferredPhone__c, Title, (Select Id, 
                                npe5__Organization__c, npe5__Contact__c, Title__c, Mailing_Street__c, Mailing_City__c, Mailing_State__c, 
                                Mailing_Zip__c, Phone__c, Email__c from npe5__Affiliations__r) from Contact where Id in : ConIds];
        
     if(Trigger.IsInsert){   
        for(CampaignMember cm : Trigger.New){
            if(cm.Account__c == null || (cm.Account__c != null && cm.Account_Name__c.Contains('Household'))){
                for(Contact con : ConList){
                    for(Account acc : AccountList){
                        if(cm.ContactId == con.Id && con.AccountId == acc.Id){
                            cm.Account__c = acc.Id;
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
                        }
                    }
                }
            }
            
               if(cm.Account__c != null){
                if(cm.Account_Name__c != null && cm.Account_Name__c.Contains('Organization')){
                system.debug('--------Account Name contains Organization-------');
                    for(Account acc : AccList){
                        for(Contact con : ConList){
                            if(cm.ContactId == con.Id && cm.Account__c == acc.Id){
                                for(npe5__Affiliation__c aff : con.npe5__Affiliations__r){
                                    if(aff.npe5__Organization__c == acc.Id){
                                        cm.Member_Title__c = aff.Title__c;
                                        cm.Member_Mailing_Street__c = aff.Mailing_Street__c;
                                        cm.Member_Mailing_City__c = aff.Mailing_City__c;
                                        cm.Member_Mailing_State__c = aff.Mailing_State__c;
                                        cm.Member_Mailing_Zip__c = aff.Mailing_Zip__c;
                                        cm.Member_Phone__c  = aff.Phone__c;
                                        cm.Member_Email__c = aff.Email__c;
                                    }
                                }
                            }
                        }
                    }
                }
               }
            
            }
        }
        
        if(Trigger.IsUpdate){
        for(CampaignMember cm : Trigger.New){
        if(cm.Account__c != Trigger.OldMap.get(cm.Id).Account__c){
            if(cm.Account__c == null || (cm.Account__c != null && cm.Account_Name__c.Contains('Household'))){
                for(Contact con : ConList){
                    for(Account acc : AccountList){
                        if(cm.ContactId == con.Id && con.AccountId == acc.Id){
                            cm.Account__c = acc.Id;
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
                            
                        }
                    }
                }
            }
            
            if(cm.Account__c != null){
                if(cm.Account_Name__c != null && cm.Account_Name__c.Contains('Organization')){
                system.debug('--------Account Name contains Organization-------');
                    for(Account acc : AccList){
                        for(Contact con : ConList){
                            if(cm.ContactId == con.Id && cm.Account__c == acc.Id){
                                for(npe5__Affiliation__c aff : con.npe5__Affiliations__r){
                                    if(aff.npe5__Organization__c == acc.Id){
                                        system.debug('-----the code is working so far---');
                                        cm.Member_Title__c = aff.Title__c;
                                        cm.Member_Mailing_Street__c = aff.Mailing_Street__c;
                                        cm.Member_Mailing_City__c = aff.Mailing_City__c;
                                        cm.Member_Mailing_State__c = aff.Mailing_State__c;
                                        cm.Member_Mailing_Zip__c = aff.Mailing_Zip__c;
                                        cm.Member_Phone__c  = aff.Phone__c;
                                        cm.Member_Email__c = aff.Email__c;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        }}
        
    
}