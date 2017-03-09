/*
        Name           : VolunteerHoursTrigger_Test
        Author         : Anil Vaishnav
        Date           : 22nd February 2017
        Description    : Test class of VolunteerHoursTriggerHandler class and VolunteerHoursTrigger
*/

@isTest
public class VolunteerHoursTriggerHandler_Test{

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
            
                List<RecordType> listCmpRecType = [Select Id from RecordType where sObjectType = 'Campaign' LIMIT 1];
                if(listCmpRecType.size() > 0){
                
                    // create test campaign
                    Campaign cmpg = TestUtilityController.fetchCampaign('Test Campaign', listCmpRecType[0].Id);
                    insert cmpg;
                    
                    // create test Volunteer_Job
                    GW_Volunteers__Volunteer_Job__c volunteerJob = TestUtilityController.fetchVolunteerJob('Test Volunteer Job', cmpg.Id);
                    insert volunteerJob;
                    
                    // create test Volunteer_Shift
                    GW_Volunteers__Volunteer_Shift__c volunteerShift = TestUtilityController.fetchVolunteerShift(volunteerJob.Id, DateTime.now(), 3, 2);
                    insert volunteerShift;
                    
                    // create test Volunteer_Hours
                    GW_Volunteers__Volunteer_Hours__c hours = TestUtilityController.fetchVolunteerHours(con.Id, volunteerJob.Id, volunteerShift.Id, 'Completed', Date.today(), 2, 3);
                    insert hours;
                    
                    hours.GW_Volunteers__Hours_Worked__c = 4;
                    update hours;
                    
                    delete hours;
                    
                    undelete hours;
                }
            }
        }
    }
}