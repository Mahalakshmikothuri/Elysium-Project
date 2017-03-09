/*
        Name           : OpportunityTrigger
        Author         : Anil Vaishnav
        Date           : 22nd February 2017
        Description    : This trigger using to opportunity trigger
*/

trigger OpportunityTrigger on Opportunity (before insert, after insert){

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            OpportunityTriggerHandler.afterInsert(Trigger.New, Trigger.NewMap);
        }
    }else if(Trigger.isBefore){
        if(Trigger.isInsert){
            OpportunityTriggerHandler.beforeInsert(Trigger.New);
        }
    }
}