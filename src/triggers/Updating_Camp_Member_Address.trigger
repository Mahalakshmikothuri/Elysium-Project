trigger Updating_Camp_Member_Address on npe5__Affiliation__c (after update) {
    
    //**** written by Apoorva Mathur to update the Phone, email and address fields in Campaign Member record if Affiliation address is changed ****//    
    
    Set<Id> AffIdSet = new Set<Id>();
    Set<Id> ConIdSet = new Set<Id>();
    List<npe5__Affiliation__c> AffList = new List<npe5__Affiliation__c>();
    List<Contact> ContactList = new List<Contact>();
    List<CampaignMember> CmpMemberList = new List<CampaignMember>();
    
    for(npe5__Affiliation__c aff : Trigger.New){
        if(aff.Mailing_Street__c != Trigger.OldMap.get(aff.id).Mailing_Street__c || aff.Mailing_City__c != Trigger.OldMap.get(aff.id).Mailing_City__c
            || aff.Mailing_State__c != Trigger.OldMap.get(aff.id).Mailing_State__c || aff.Mailing_Zip__c != Trigger.OldMap.get(aff.id).Mailing_Zip__c
            || aff.Phone__c != Trigger.OldMap.get(aff.id).Phone__c || aff.Email__c != Trigger.OldMap.get(aff.id).Email__c){
                
                  AffIdSet.add(aff.id); 
                  ConIdSet.add(aff.npe5__Contact__c);
        }
    }
    
    If(AffIdSet.size() > 0 && AffIdSet != null){
        AffList = [Select Id, npe5__Organization__c, npe5__Contact__c, Mailing_Street__c, Mailing_City__c, Mailing_State__c, 
                    Mailing_Zip__c, Phone__c, Email__c from npe5__Affiliation__c where Id in: AffIdSet];
        ContactList = [Select Id,  (Select Id, ContactId, Account__c, Account_Name__c, Member_Phone__c, Member_Email__c, Member_Mailing_Street__c, 
                        Member_Mailing_City__c, Member_Mailing_State__c, Member_Mailing_Zip__c from CampaignMembers)  from Contact 
                        where Id in: ConIdSet];
    }
    
    for(npe5__Affiliation__c aff : AffList){
        for(Contact con : ContactList){
            if(aff.npe5__Contact__c == con.id){
                for(CampaignMember cm : con.CampaignMembers){
                    if(cm.Account__c != null && cm.Account_Name__c.Contains('Organization')){
                        cm.Member_Mailing_Street__c = aff.Mailing_Street__c;
                        cm.Member_Mailing_City__c = aff.Mailing_City__c;
                        cm.Member_Mailing_State__c = aff.Mailing_State__c;
                        cm.Member_Mailing_Zip__c = aff.Mailing_Zip__c;
                        cm.Member_Phone__c  = aff.Phone__c;
                        cm.Member_Email__c = aff.Email__c;
                        CmpMemberList.add(cm);
                    }
                }
            }
        }
    }
    
    update CmpMemberList;
}