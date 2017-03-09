/*
        Name           : VolunteerHoursTriggerHandler
        Author         : Anil Vaishnav
        Date           : 22nd February 2017
        Description    : Handler class of VolunteerHours Trigger 
*/

public class VolunteerHoursTriggerHandler{

    // after insert
    public static void afterInsert(List<GW_Volunteers__Volunteer_Hours__c> newList){
        calculateTotalWorkedHours(newList, null, false);
    }
    
    // after update
    public static void afterUpdate(List<GW_Volunteers__Volunteer_Hours__c> newList, Map<Id, GW_Volunteers__Volunteer_Hours__c> oldMap){
        calculateTotalWorkedHours(newList, oldMap, true);
    }
    
    // after delete
    public static void afterDelete(List<GW_Volunteers__Volunteer_Hours__c> oldList){
        calculateTotalWorkedHours(oldList, null, false);
    }
    
    // after undelete
    public static void afterUnDelete(List<GW_Volunteers__Volunteer_Hours__c> newList){
        calculateTotalWorkedHours(newList, null, false);
    }
    
    // this method calculate Total_Hours_Worked and update volunteer shift
    public static void calculateTotalWorkedHours(List<GW_Volunteers__Volunteer_Hours__c> newList, Map<Id, GW_Volunteers__Volunteer_Hours__c> oldMap, Boolean isUpdate){
        
        Set<Id> volunteerShiftIds = new Set<Id>();
        for(GW_Volunteers__Volunteer_Hours__c volunteerHours : newList){
            if(!isUpdate || (isUpdate && (volunteerHours.GW_Volunteers__Status__c != oldMap.get(volunteerHours.id).GW_Volunteers__Status__c ||
                 volunteerHours.GW_Volunteers__Hours_Worked__c != oldMap.get(volunteerHours.id).GW_Volunteers__Hours_Worked__c ||
                 volunteerHours.GW_Volunteers__Number_of_Volunteers__c != oldMap.get(volunteerHours.id).GW_Volunteers__Number_of_Volunteers__c ||
                 volunteerHours.GW_Volunteers__Volunteer_Shift__c != oldMap.get(volunteerHours.id).GW_Volunteers__Volunteer_Shift__c))){
                
                if(volunteerHours.GW_Volunteers__Volunteer_Shift__c != null){
                    volunteerShiftIds.add(volunteerHours.GW_Volunteers__Volunteer_Shift__c);
                }
                if(isUpdate && volunteerHours.GW_Volunteers__Volunteer_Shift__c != oldMap.get(volunteerHours.id).GW_Volunteers__Volunteer_Shift__c && oldMap.get(volunteerHours.id).GW_Volunteers__Volunteer_Shift__c != null){
                    volunteerShiftIds.add(oldMap.get(volunteerHours.id).GW_Volunteers__Volunteer_Shift__c);
                }
            }
        }
        if(volunteerShiftIds.size() > 0){
            
            List<GW_Volunteers__Volunteer_Shift__c> listShift = [Select Id,Total_Hours_Worked__c,(Select Id,GW_Volunteers__Total_Hours_Worked__c from GW_Volunteers__Volunteer_Hours__r where GW_Volunteers__Status__c = 'Completed' And GW_Volunteers__Total_Hours_Worked__c != null) from GW_Volunteers__Volunteer_Shift__c where Id in :volunteerShiftIds];
            for(GW_Volunteers__Volunteer_Shift__c shift :  listShift){
                Decimal totalHours = 0.0;
                for(GW_Volunteers__Volunteer_Hours__c volHours : shift.GW_Volunteers__Volunteer_Hours__r){
                    totalHours += volHours.GW_Volunteers__Total_Hours_Worked__c;
                }
                shift.Total_Hours_Worked__c = totalHours;
            }
            update listShift;
        }
    }
}