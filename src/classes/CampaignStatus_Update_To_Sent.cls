global with sharing class CampaignStatus_Update_To_Sent{
    
    //**** Written by Apoorva Mathur to update Campaign Member status from Planned to Sent on the click of 'Update To Sent' button ****//
    
    webService static String Update_To_Sent(ID CmpId){   
        List<CampaignMember> UpdateCmpMemberList = new List<CampaignMember>();
   
        Campaign CampaignRecord = [Select Id from Campaign where Id =: CmpId];
        
        List<CampaignMember> CmpMemberList = [Select Id, CampaignId, Status from CampaignMember where CampaignId =: CmpId];
        
        for(CampaignMember cm : CmpMemberList){
            if(cm.Status == 'Planned'){
                cm.Status = 'Sent';
                UpdateCmpMemberList.add(cm);
            }
        }
        update UpdateCmpMemberList;
        return null;
        
    }
}