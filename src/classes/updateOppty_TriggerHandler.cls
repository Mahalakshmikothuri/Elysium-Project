/*
Trigger Name: updateOppty_TriggerHandler
Purpose/Overview: To Update Opportunity's Do Not Automatically Create Payments field when the the below mentioned criteria matches
Author: SANDEEP KUMAR K
Created Date: 14/02/2017
Test Class Name:       
Change History: 
Date Modified: Developer Name: Section/Page Block Modified/Added: Purpose/Overview of Change
*/
public class updateOppty_TriggerHandler{

    public static void updateOppty(list<Opportunity> lstOpptys){

        list<Opportunity> OpptsToUpdate = new list<Opportunity>();
        System.debug('Opportunity^&^&^&^'+lstOpptys);
        Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Opportunity.getRecordTypeInfosById();
        for(Opportunity opp : lstOpptys)
        {
            System.debug('^&^&^ )pp0rtunity Record Type:'+rtMap.get(opp.RecordTypeId).getName());
            System.debug('^&^&^ )pp0rtunity Stage:'+opp.StageName);
            if((rtMap.get(opp.RecordTypeId).getName()=='Donation' && opp.StageName!='Posted') 
            || (rtMap.get(opp.RecordTypeId).getName()=='GW Auction Purchased Item' && opp.StageName!='Posted') 
            || (rtMap.get(opp.RecordTypeId).getName()=='GW Auction Ticket' && opp.StageName!='Posted')
            || (rtMap.get(opp.RecordTypeId).getName()=='Grant' && opp.StageName!='Posted')
            || (rtMap.get(opp.RecordTypeId).getName()=='Major Gift' && opp.StageName!='Posted')
            || (rtMap.get(opp.RecordTypeId).getName()=='Matching Gift' && opp.StageName!='Posted')
            || (rtMap.get(opp.RecordTypeId).getName()=='Membership' && opp.StageName!='Posted')
            )
            {
            opp.npe01__Do_Not_Automatically_Create_Payment__c=true;
            System.debug('&^&^&^&^&^'+opp.npe01__Do_Not_Automatically_Create_Payment__c);
            }
            //OpptsToUpdate.add(opp);
        }
    }
}