/*
Trigger Name: updateMembersSent
Purpose/Overview: To Update Number Sent field in Campaign based on campaign Members
Author: SANDEEP KUMAR K
Created Date: 04/02/2017
Test Class Name:       
Change History: 
Date Modified: Developer Name: Section/Page Block Modified/Added: Purpose/Overview of Change
*/
trigger updateMembersSent on CampaignMember (before insert,before update,after insert,after update, after delete) {

    set<campaign> campMembersSet = new set<campaign>();
    list<campaign> lstCamptobeUpdated = new list<campaign>();
    list<campaign> lstCampaigns = new list<campaign>();
    list<campaignmember> lstCampaignMembs = new list<campaignmember>();
    set<id> campaignIds = new set<id>();
    set<id> campaignMemberIds = new set<id>();
    map<id,campaign> campMap = new Map<id,campaign>();
    integer numSent=0;
    
    
    
    /* To update Campaign Members 'Number Sent' field to 1 when created*/
    
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate))
    {
        for(campaignmember cmp : trigger.new)
        {
            if(cmp.status=='Sent')
            {
                cmp.Number_Sent__c = 1;
                //cmp.Number_Planned__c=null;
                }
                
                    /************* written by harsha in order to update number planned to 1 when campingn member added***********/
                    
                    if(cmp.status=='Planned')
                    {
                    cmp.Number_Planned__c=1;
                     //cmp.Number_Sent__c=null;
                    
                    }

        }
    }
    
    
    if(trigger.isAfter)
    {
        if(trigger.isInsert || trigger.isUpdate){
            for(campaignmember cm : trigger.new)
            {
                //if(cm.Status=='Sent'){
                    campaignIds.add(cm.Campaignid);
                    //campaignMemberIds.add(cm.id);         
                //}
                system.debug('&&& Campaign IDS After :'+campaignIds);
            }
        }
        if(trigger.isDelete)
        {
            for(campaignmember cm: trigger.old)
                campaignIds.add(cm.Campaignid);
        }
        system.debug('&&& Campaign IDS :'+campaignIds);
       lstCampaigns=[select id,name,NumberSent,Manually_Tracking_Sent_Members__c from campaign where id in :campaignIds];
       lstCampaignMembs = [select id,name,Status,Number_Sent__c,CampaignId from campaignMember where CampaignId in :campaignIds];
       system.debug('no of campaigns'+lstCampaigns.size());
       system.debug('no of campaign members'+lstCampaignMembs.size());
       if(lstCampaignMembs.isEmpty()){
           for(campaign cmp :lstCampaigns){
            cmp.NumberSent= 0;
            campMap.put(cmp.id,cmp);
           }
        }   
       for(campaignmember cmpMemb: lstCampaignMembs)
       {
           for(campaign cmp :lstCampaigns){
              
               if(cmpMemb.CampaignId==cmp.id && cmpMemb.Number_Sent__c==1 && !cmp.Manually_Tracking_Sent_Members__c)
               {
                    numSent = numSent+1;
                    system.debug('&&& Campaign Number Sent Before:'+cmp.NumberSent);
                   /*if(cmp.NumberSent!=0 && cmp.NumberSent!=null)
                       cmp.NumberSent=cmp.NumberSent-1;
                    else if(cmp.NumberSent==0 || cmp.NumberSent==null)
                       cmp.NumberSent=1;*/
                   system.debug('&&& Campaign Members Number Sent Before:'+cmpMemb.Number_Sent__c);
                    //if(cmp.NumberSent==0 || cmp.NumberSent==null)
                        //cmp.NumberSent= numSent+cmpMemb.Number_Sent__c;
                    //else
                        cmp.NumberSent= numSent;
                    
                system.debug('&&& Campaign Number Sent After:'+cmp.NumberSent);    
               }
               //lstCamptobeUpdated.add(cmp);
               campMap.put(cmp.id,cmp);
           }
       }
        
    }
    //if(!lstCamptobeUpdated.isEmpty()){
        //campMembersSet.addAll(lstCamptobeUpdated);
        //lstCamptobeUpdated.addAll(campMembersSet);
    //}
    if(!campMap.values().isEmpty()) 
        update campMap.values();
}