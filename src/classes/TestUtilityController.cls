/*
        Name           : TestUtilityController
        Author         : Anil Vaishnav
        Date           : 22nd February 2017
        Description    : This class provide test data into test classes
*/

@isTest
public class TestUtilityController{

    // create test account
    public static Account fetchAccount(String name, String recordTypeId){
        return new Account(Name = name, RecordTypeId = recordTypeId);
    }
    
    // create test contact
    public static Contact fetchContact(String firstName, String lastName, String accId, String recordTypeId){
        return new Contact(FirstName = firstName, LastName = lastName, AccountId = accId, RecordTypeId = recordTypeId);
    }
    
    // create test campaign
    public static Campaign fetchCampaign(String name, String recordTypeId){
        return new Campaign(Name = name, RecordTypeId = recordTypeId);
    }
    
    // create test Volunteer_Job
    public static GW_Volunteers__Volunteer_Job__c fetchVolunteerJob(String name, String cmpgId){
        return new GW_Volunteers__Volunteer_Job__c(Name = name, GW_Volunteers__Campaign__c = cmpgId);
    }
    
    // create test Volunteer_Shift
    public static GW_Volunteers__Volunteer_Shift__c fetchVolunteerShift(String jobId, DateTime stDateTime, Decimal duration, Integer noOfVolunteer){
        GW_Volunteers__Volunteer_Shift__c shift = new GW_Volunteers__Volunteer_Shift__c();
        shift.GW_Volunteers__Volunteer_Job__c = jobId;
        shift.GW_Volunteers__Start_Date_Time__c = stDateTime;
        shift.GW_Volunteers__Duration__c = duration;
        shift.GW_Volunteers__Desired_Number_of_Volunteers__c = noOfVolunteer;
        
        return shift;
    }
    
    // create test Volunteer_Hours
    public static GW_Volunteers__Volunteer_Hours__c fetchVolunteerHours(String conId, String jobId, String shiftId, String status, Date stDate, Integer noOfVol, Integer workedHours){
        GW_Volunteers__Volunteer_Hours__c volHours = new GW_Volunteers__Volunteer_Hours__c();
        volHours.GW_Volunteers__Contact__c = conId;
        volHours.GW_Volunteers__Volunteer_Job__c = jobId;
        volHours.GW_Volunteers__Volunteer_Shift__c = shiftId;
        volHours.GW_Volunteers__Status__c = status;
        volHours.GW_Volunteers__Start_Date__c = stDate;
        volHours.GW_Volunteers__Number_of_Volunteers__c = noOfVol;
        volHours.GW_Volunteers__Hours_Worked__c = workedHours;
        
        return volHours;
    }
    
    // create test Recurring_Donation
    public static npe03__Recurring_Donation__c fetchRecurringDonation(String name, Decimal amt, String period, String conId){
        npe03__Recurring_Donation__c rd = new npe03__Recurring_Donation__c();
        rd.Name = name;
        rd.npe03__Amount__c = amt;
        rd.npe03__Installment_Period__c = period;
        rd.npe03__Contact__c = conId;
        
        return rd;
    }
    
    // create test Contact Role
    public static ContactRoles__c fetchContactRole(String conId, String rdId, Boolean isPrimary, String roleStr){
        ContactRoles__c conRole = new ContactRoles__c();
        conRole.Contact__c = conId;
        conRole.Recurring_Donations__c = rdId;
        conRole.Primary__c = isPrimary;
        conRole.Role__c = roleStr;
        
        return conRole;
    }
    
    // create test Opportunity
    public static Opportunity fetchOpportunity(String oppName, String accId, Decimal amt, Date closeDate, String stageName, String rdId, String recTypeId){
        Opportunity opp = new Opportunity();
        opp.Name = oppName;
        opp.AccountId = accId;
        opp.CloseDate = closeDate;
        opp.StageName = stageName;
        opp.npe03__Recurring_Donation__c = rdId;
        opp.RecordTypeId = recTypeId;
        
        return opp;
    }
}