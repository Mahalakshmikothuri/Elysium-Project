trigger Update_Opportunity_Record_Type on npe03__Recurring_Donation__c (after update) {
    
//**** written by Apoorva Mathur to update the Opportunity Record Type based on value of 'Opportunity Record Type Field' in Recurring Donation ****//
    
    Set<Id> RdIdSet = new Set<Id>();
    
    for(npe03__Recurring_Donation__c rd : Trigger.New){
        
        if(rd.Opportunity_Record_Type__c != Trigger.OldMap.get(rd.id).Opportunity_Record_Type__c){
            RdIdSet.add(rd.Id);
        }
    }
    
    List<RecordType> RecTypeList = [Select Id, Name, DeveloperName from RecordType where sObjectType =: 'Opportunity'];
    
    List<npe03__Recurring_Donation__c> RdList = [Select Id, Name, Opportunity_Record_Type__c, (Select Id, RecordTypeId, RecordType.Name
                                                 from npe03__Donations__r) from
                                                npe03__Recurring_Donation__c where Id in: RdIdSet ];
    Id recId ;
    for(npe03__Recurring_Donation__c rd : RdList){
        system.debug('Opportunity_Record_Type__c in Recurring Donations---->' + rd.Opportunity_Record_Type__c);
        for(RecordType r : RecTypeList){
           if(r.Name == rd.Opportunity_Record_Type__c){
               for(Opportunity o : rd.npe03__Donations__r){
                   o.RecordTypeId = r.Id;
               } 
           }
        }
    }
}