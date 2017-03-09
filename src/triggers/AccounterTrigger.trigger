/*
        Name           : AccountTrigger
        Author         : Anil Vaishnav
        Date           : 16th February 2017
        Description    : This trigger use for account trigger
*/

trigger AccounterTrigger on Account (after update){

    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            AccountTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}