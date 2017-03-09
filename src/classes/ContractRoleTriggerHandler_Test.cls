/*
        Name           : ContractRoleTriggerHandler_Test
        Author         : Anil Vaishnav
        Date           : 22nd February 2017
        Description    : Test class of ContractRoleTriggerHandler class, ContractRoleTrigger, OpportunityTrigger and OpportunityTriggerHandler
*/

@isTest
public class ContractRoleTriggerHandler_Test{

    // test method
    @isTest
    private static void test(){
        List<RecordType> listAccRecType = [Select Id from RecordType where sObjectType = 'Account' LIMIT 1];
        if(listAccRecType.size() > 0){
            
            // create test Account
            Account acc = TestUtilityController.fetchAccount('Test Account', listAccRecType[0].Id);
            insert acc;
            
            List<RecordType> listConRecType = [Select Id from RecordType where sObjectType = 'Contact' LIMIT 1];
            if(listConRecType.size() > 0){
            
                // create test Contact
                Contact con = TestUtilityController.fetchContact('Test', 'Contact', acc.Id, listConRecType[0].Id);
                insert con;
        
                // create test Recurring Donation
                npe03__Recurring_Donation__c rd = TestUtilityController.fetchRecurringDonation('Test RD', 12.25, 'Monthly', con.Id);
                insert rd;
                
                // create test contact role
                ContactRoles__c conRole = TestUtilityController.fetchContactRole(con.Id, rd.Id, true, 'Donor');
                insert conRole;
                
                List<RecordType> listOppRecType = [Select Id from RecordType where sObjectType = 'Opportunity' and Name = 'Recurring Donation'];
                if(listOppRecType.size() > 0){
                    
                    // create test opportunity
                    Opportunity opp = TestUtilityController.fetchOpportunity('Test Opp', acc.Id, 12.2, Date.today(), 'Qualification', rd.Id, listOppRecType[0].Id);  
                    insert opp;
                    
                    // create test contact role
                    ContactRoles__c conRole2 = TestUtilityController.fetchContactRole(con.Id, rd.Id, true, 'Donor');
                    insert conRole2;
                    
                    delete conRole2;
                    
                    undelete conRole2;
                }
            }
        }
    }
}