trigger Insert_Camp_Member_Statuses on Campaign (before insert, after insert) {
    
    //**** written by Apoorva Mathur to add the campaign member status 'Planned' where Campaign Record type is either 'GW Auction Campaign' or 'Marketing Campaign' ****//
    
    // this list will hold all the new CampaignMembers we will add.
    List<CampaignMemberStatus> CmpStatusList = new List<CampaignMemberStatus>();
    
    // this will hold the id's of all volunteer campaigns.
    set<ID> setCmpId = new set<ID>();
    
    // this list will hold all the new CampaignMembers we will add.
    list<CampaignMemberStatus> listCMSToAdd = new list<CampaignMemberStatus>();
    List<RecordType> RtList = [Select Id, DeveloperName from RecordType where sObjectType =: 'Campaign'];
    
    If(Trigger.IsBefore){
        for(Campaign cmp : Trigger.New){
            cmp.IsActive = true;
        }
    }
    
    If(Trigger.IsAfter){
        for(Campaign cmp : Trigger.New){
            if(cmp.Record_Type_Name__c == 'GW Auction Campaign' || cmp.Record_Type_Name__c == 'Marketing Campaign'){
                CampaignMemberStatus cms = new CampaignMemberStatus(
                Label = 'Planned',
                CampaignId = cmp.Id,
                HasResponded = false,
                SortOrder = 0,
                IsDefault = true
                );
                CmpStatusList.add(cms);
            }
            if(cmp.Record_Type_Name__c == 'Program Site Campaign'){
                // remember the campaign
                setCmpId.add(cmp.Id);
              
                CampaignMemberStatus cms1 = new CampaignMemberStatus(
                    Label = 'Prospect',
                    CampaignId = cmp.Id,
                    HasResponded = false,
                    SortOrder = 100,
                    IsDefault = true
                );
                listCMSToAdd.add(cms1);
            
                CampaignMemberStatus cms2 = new CampaignMemberStatus(
                    Label = 'Confirmed',
                    CampaignId = cmp.Id,
                    HasResponded = true,
                    SortOrder = 200
                );
                listCMSToAdd.add(cms2);
            
                CampaignMemberStatus cms3 = new CampaignMemberStatus(
                    Label = 'Completed',
                    CampaignId = cmp.Id,
                    HasResponded = true,
                    SortOrder = 300
                );
                listCMSToAdd.add(cms3);
                
                CampaignMemberStatus cms4 = new CampaignMemberStatus(
                    Label = 'No-Show',
                    CampaignId = cmp.Id,
                    HasResponded = false,
                    SortOrder = 400
                );
                listCMSTOAdd.add(cms4);
        
                CampaignMemberStatus cms5 = new CampaignMemberStatus(
                    Label = 'Canceled',
                    CampaignId = cmp.Id,
                    HasResponded = false,
                    SortOrder = 500
                );
                listCMSTOAdd.add(cms5);
            }
        }
    }
    
    insert CmpStatusList;
    
    // now get the default CampaignMembers from all Volunteer Campaigns, that we will remove.    
    list<CampaignMemberStatus> listCMSToDel = [Select Id From CampaignMemberStatus WHERE CampaignId in :setCmpId]; 
    
    insert listCMSToAdd;
    delete listCMSToDel;
}