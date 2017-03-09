/*
        Name           : VolunteerHoursTrigger
        Author         : Anil Vaishnav
        Date           : 16th February 2017
        Description    : Trigger on VolunteerHours
*/

trigger VolunteerHoursTrigger on GW_Volunteers__Volunteer_Hours__c(after insert, after update, after delete, after undelete){
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            VolunteerHoursTriggerHandler.afterInsert(Trigger.New);
        }
        
        if(Trigger.isUpdate){
            VolunteerHoursTriggerHandler.afterUpdate(Trigger.New, Trigger.OldMap);
        }
        
        if(Trigger.isDelete){
            VolunteerHoursTriggerHandler.afterDelete(Trigger.Old);
        }
        
        if(Trigger.isUndelete){
            VolunteerHoursTriggerHandler.afterUndelete(Trigger.New);
        }
    }
}