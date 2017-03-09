//**** written by Apoorva Mathur to cover the triggers 'Update_Opportunity_Record_Type' on Recurring Donation & 'Update_Opp_Record_Type' on Opportunity ****//

@isTest

Public class Test_Update_Opportunity_Record_Type{
    
    Static testMethod void Test_Update_Opportunity_Record_Type(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        npe03__Recurring_Donation__c r = new npe03__Recurring_Donation__c();
        r.Name = 'Apoorva Test';
        r.npe03__Organization__c = a.id;
        r.npe03__Amount__c = 10;
        r.npe03__Date_Established__c = system.today() + 2;
        r.npe03__Installment_Period__c = 'Monthly';
        r.Opportunity_Record_Type__c = 'Recurring Matching Gift';
        insert r;
        
        r.Opportunity_Record_Type__c = 'Recurring Donation';
        update r;
    }
}