trigger parentCampaignHours on Campaign (after insert, after update, after delete) {
        Set<id> campIds  = new Set<id>();
		map<id,campaign> parentCampaignMap = new map<id,campaign>();
       list<campaign> parentCamps  = new list<campaign>();
    //when Child Camp insert or Updating 
    	If(Trigger.isDelete){
			for(campaign camp : Trigger.old){
            campIds.add(camp.parentId);
			}            
		} 
    If(Trigger.isUpdate || Trigger.isInsert){
      for(campaign camp : Trigger.new){
          If(camp.parentId != Null){
               campIds.add(camp.parentId);
          }           
        } 
    }
            parentCamps = [select id,name,Number_of_Volunteers_in_Hierarchy__c from campaign where id in :campIds];	
		//when deleting Child camps   
		       
        List<campaign> ChildCamp = [select id,Parentid, GW_Volunteers__Number_of_Volunteers__c,GW_Volunteers__Volunteers_Still_Needed__c,
                                            GW_Volunteers__Volunteer_Completed_Hours__c,GW_Volunteers__Volunteer_Jobs__c,GW_Volunteers__Volunteer_Shifts__c
                                            FROM Campaign 
                                            WHERE ParentId IN :campIds ];
        INteger  totalcompletedhours = 0;
        Map<Id, decimal> totalcamp = new Map<Id,decimal>();
		for(campaign cmp : parentCamps){
			for(campaign Camp : ChildCamp){
				if(camp.parentId == cmp.Id)
				{
					camp.Number_of_Volunteers_in_Hierarchy__c = totalcompletedhours + Camp.GW_Volunteers__Number_of_Volunteers__c;
					parentCampaignMap.put(cmp.id,cmp);					
				}
			}
		}            
    
	 if(parentCampaignMap != null)
		update parentCampaignMap.values();    
}