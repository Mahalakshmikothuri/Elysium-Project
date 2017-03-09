trigger AUC_Auction_CreateCampaigns_Updated on GW_Auctions__Auction__c (after insert) {
   
//**** written by Apoorva to delete the campaign member status 'Donated' from Auction Tickets and Auction Item Donors Campaigns ****//
    
    Set<Id> cmpIds = new Set<Id>();
    List<CampaignMemberStatus> DeleteCmsList = new List<CampaignMemberStatus>();
    for(GW_Auctions__Auction__c auc : trigger.new){
        List<Campaign> CampaignsList = [Select Id, GW_Auctions__Auction__c from Campaign where GW_Auctions__Auction__c =: auc.id];
        
        for(Campaign cmp : CampaignsList){
           cmpIds.add(cmp.id);
        }
    }
    
    List<CampaignMemberStatus> cmsList = [Select Id, Label, CampaignId from CampaignMemberStatus where CampaignId in :cmpIds];
    for(CampaignMemberStatus cms : cmsList){
        if(cms.Label == 'Donated'){
            DeleteCmsList.add(cms);
        }
    }
    
    Delete DeleteCmsList;
}