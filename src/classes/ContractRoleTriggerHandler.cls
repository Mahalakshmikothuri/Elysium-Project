/*    
        Name           : ContractRoleTriggerHandler
        Author         : Anil Vaishnav
        Date           : 22nd February 2017
        Description    : This class manage contact role trigger
*/ 

public class ContractRoleTriggerHandler{
    
    // before delete
    public static void beforeDelete(List<ContactRoles__c> oldList){
        deleteContactRoles(oldList);
    }
    
    // after insert
    public static void afterInsert(List<ContactRoles__c> newList){
    
        // for active contact role
        manageActiveContactRole(newList, null, false);
        
        // for creating opportunity contact role
        createOpportunityContactRole(newList, null, false);
    }
    
    // after update
    public static void afterUpdate(List<ContactRoles__c> newList, Map<Id, ContactRoles__c> oldMap){
        
        // for active contact role
        manageActiveContactRole(newList, oldMap, true);
    }
    
    // after insert
    public static void afterUndelete(List<ContactRoles__c> newList){
    
        // for active contact role
        manageActiveContactRole(newList, null, false);
        
        // for creating opportunity contact role
        createOpportunityContactRole(newList, null, false);
    }
    
    // manage active contact role
    public static void manageActiveContactRole(List<ContactRoles__c> newList, Map<Id, ContactRoles__c> oldMap, Boolean isUpdate){
        
        Map<Id, Id> mapRDToCR = new Map<Id, Id>();
        for(ContactRoles__c conRole : newList){
        
            if(conRole.Primary__c && conRole.Recurring_Donations__c != null && (!isUpdate || (isUpdate && (conRole.Primary__c != oldMap.get(conRole.Id).Primary__c || conRole.Recurring_Donations__c != oldMap.get(conRole.Id).Recurring_Donations__c)))){
                mapRDToCR.put(conRole.Recurring_Donations__c, conRole.Id);
            }
        }
        
        if(mapRDToCR.size() > 0){
        
            Set<Id> conRoleIds = new Set<Id>();
            conRoleIds.addAll(mapRDToCR.values());
            
            List<ContactRoles__c> listToUpdate = [Select Id,Primary__c from ContactRoles__c where Recurring_Donations__c in :mapRDToCR.keySet() And Id not in :conRoleIds And Primary__c = true];
            
            if(listToUpdate.size() > 0){
                for(ContactRoles__c conRole : listToUpdate){
                    conRole.Primary__c = false;
                }
                update listToUpdate;
            }
        }
    }
    
    // create opportunity contact role
    public static void createOpportunityContactRole(List<ContactRoles__c> newList, Map<Id, ContactRoles__c> oldMap, Boolean isUpdate){
        
        // create or update opportunity contact role
        Map<Id, List<ContactRoles__c>> mapRDToCR = new Map<Id, List<ContactRoles__c>>();
        for(ContactRoles__c conRole : newList){
            if(conRole.Recurring_Donations__c != null){
            
                // for create new opportunity contact role
                if(!isUpdate){
                    List<ContactRoles__c> listConRole = mapRDToCR.containsKey(conRole.Recurring_Donations__c) ? mapRDToCR.get(conRole.Recurring_Donations__c) : new List<ContactRoles__c>();
                    listConRole.add(conRole);
                    mapRDToCR.put(conRole.Recurring_Donations__c, listConRole);
                }
            }
        }
        
        if(mapRDToCR.size() > 0){
            List<OpportunityContactRole> listToInsert = new List<OpportunityContactRole>();
            
            for(Opportunity opp : [Select Id,Name, npe03__Recurring_Donation__c from Opportunity where npe03__Recurring_Donation__c in :mapRDToCR.keySet()]){
                
                if(mapRDToCR.containsKey(opp.npe03__Recurring_Donation__c)){
                    for(ContactRoles__c conRole : mapRDToCR.get(opp.npe03__Recurring_Donation__c)){
                        
                        OpportunityContactRole oppConRole = new OpportunityContactRole();
                        oppConRole.ContactId = conRole.Contact__c;
                        oppConRole.IsPrimary = conRole.Primary__c;
                        oppConRole.OpportunityId = opp.Id;
                        oppConRole.Role = conRole.Role__c;
                        
                        listToInsert.add(oppConRole);
                    }
                }
            }
            
            if(listToInsert.size() > 0){
                insert listToInsert;
            }
        }    
    }
    
    // this method delete contact role from opportunity
    public static void deleteContactRoles(List<ContactRoles__c> oldList){
        Map<Id, Set<Id>> mapRDToCR = new Map<Id, Set<Id>>();
        for(ContactRoles__c conRole : oldList){
            if(conRole.Recurring_Donations__c != null && conRole.Contact__c != null){
                
                Set<Id> conIds = mapRDToCR.containsKey(conRole.Recurring_Donations__c) ? mapRDToCR.get(conRole.Recurring_Donations__c) : new Set<Id>();
                conIds.add(conRole.Contact__c);
                mapRDToCR.put(conRole.Recurring_Donations__c, conIds);
            }
        }
        
        if(mapRDToCR.size() > 0){
            List<OpportunityContactRole> listToDelete = new List<OpportunityContactRole>();
            
            for(Opportunity opp : [Select Id,npe03__Recurring_Donation__c,(Select Id,ContactId from OpportunityContactRoles) from Opportunity where npe03__Recurring_Donation__c in :mapRDToCR.keySet()]){
                if(mapRDToCR.containsKey(opp.npe03__Recurring_Donation__c) && opp.OpportunityContactRoles != null && opp.OpportunityContactRoles.size() > 0){
                    Set<Id> contIds = mapRDToCR.get(opp.npe03__Recurring_Donation__c);
                    for(OpportunityContactRole conRole : opp.OpportunityContactRoles){
                        if(contIds.contains(conRole.ContactId)){
                            listToDelete.add(conRole);
                        }
                    }
                }
            }
            
            if(listToDelete.size() > 0){
                delete listToDelete;
            }
        }
    }
}