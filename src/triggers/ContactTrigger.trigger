/*
        Name           : ContactTrigger
        Author         : Anil Vaishnav
        Date           : 16th February 2017
        Description    : This trigger use for contact trigger
*/

trigger ContactTrigger on Contact(before insert, after insert, after update,before update){
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ContactTriggerHandler.beforeInsert(Trigger.new);
        }
         if(Trigger.isupdate){
            ContactTriggerHandler.beforeupdate(Trigger.new,trigger.oldmap);
        }
    }else if(Trigger.isAfter){
        if(Trigger.isInsert){
            ContactTriggerHandler.afterInsert(Trigger.new, Trigger.newMap);
        }else if(Trigger.isUpdate){
            ContactTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}