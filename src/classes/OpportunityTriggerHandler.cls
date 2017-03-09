/*
        Name           : OpportunityTriggerHandler
        Author         : Anil Vaishnav
        Date           : 22nd February 2017
        Description    : Trigger handler class of opportunity trigger
*/

public class OpportunityTriggerHandler{
    
    // before insert
    public static void beforeInsert(List<Opportunity> newList){
        
        // Update the Opportunity Record Type based on value of 'Opportunity Record Type Field' in Recurring Donation
        updateRecordType(newList);
    }
    
    // after insert
    public static void afterInsert(List<Opportunity> newList, Map<Id, Opportunity> newMap){
    
        // create contact role
        createContactRole(newMap.keySet());
    }
    
    // create contact Roles
    //@future
    public static void createContactRole(Set<Id> oppIds){
        List<Opportunity> newList = [select Id,npe03__Recurring_Donation__c from Opportunity where npe03__Recurring_Donation__c != null And Id in :oppIds];
        
        if(newList.size() > 0){
            Set<Id> setRDIds = new Set<Id>();
            Set<Id> setOppIds = new Set<Id>();
            for(Opportunity opp : newList){
                setRDIds.add(opp.npe03__Recurring_Donation__c);
                setOppIds.add(opp.Id);
            }
            
            if(setRDIds.size() > 0){
                
                // delete existing Opportunity contact role
                /*
                List<OpportunityContactRole> listToDelete = [Select Id from OpportunityContactRole where OpportunityId in :setOppIds];
                if(listToDelete.size() > 0){
                    delete listToDelete;
                }
                */
                
                Map<Id, npe03__Recurring_Donation__c> mapRD = new Map<Id, npe03__Recurring_Donation__c>([Select Id,Name,(Select Id,Primary__c,Contact__c,Role__c from ContactRoles__r) from npe03__Recurring_Donation__c where Id in :setRDIds]);
                if(mapRD.size() > 0){
                    
                    List<OpportunityContactRole> listToInsert = new List<OpportunityContactRole>();
                    for(Opportunity opp : newList){
                        if(mapRD.containsKey(opp.npe03__Recurring_Donation__c)){
                            
                            npe03__Recurring_Donation__c rd = mapRD.get(opp.npe03__Recurring_Donation__c);
                            if(rd.ContactRoles__r != null && rd.ContactRoles__r.size() > 0){
                                
                                for(ContactRoles__c conRole :rd.ContactRoles__r){
                                
                                    OpportunityContactRole oppConRole = new OpportunityContactRole();
                                    oppConRole.ContactId = conRole.Contact__c;
                                    oppConRole.IsPrimary = conRole.Primary__c;
                                    oppConRole.OpportunityId = opp.Id;
                                    oppConRole.Role = conRole.Role__c;
                                    
                                    listToInsert.add(oppConRole);
                                }
                            }
                        }
                    }
                    
                    if(listToInsert.size() > 0){
                        insert listToInsert;
                    }
                }
            }
        }
    }
    
    // Update the Opportunity Record Type based on value of 'Opportunity Record Type Field' in Recurring Donation
    private static void updateRecordType(List<Opportunity> newList){
        List<RecordType> RecTypeList = [Select Id, Name, DeveloperName from RecordType where sObjectType = 'Opportunity'];
    
        for(Opportunity opp : newList){
            If(opp.npe03__Recurring_Donation__c != null){
                system.debug('Opp record type name in recurring donation record--->' + opp.RecordType_Name_In_Recurring_Donation__c);
                    
                for(RecordType rt : RectypeList){
                    if(rt.Name == opp.RecordType_Name_In_Recurring_Donation__c){
                        system.debug('They are equal///////' + rt.Name);
                        
                        opp.RecordTypeId = rt.Id; 
                    }
                }
            }
        }
    }
}