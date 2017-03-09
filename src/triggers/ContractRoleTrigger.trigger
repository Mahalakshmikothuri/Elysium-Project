/*    
        Name           : ContractRoleTrigger
        Author         : Anil Vaishnav
        Date           : 22nd February 2017
        Description    : This trigger manage active contact role and create opportunity contact roles
*/ 

trigger ContractRoleTrigger on ContactRoles__c(after insert, after update, before delete, after undelete){

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ContractRoleTriggerHandler.afterInsert(Trigger.New);
        }else if(Trigger.isUpdate){
            ContractRoleTriggerHandler.afterUpdate(Trigger.New, Trigger.OldMap);
        }if(Trigger.isUndelete){
            ContractRoleTriggerHandler.afterUndelete(Trigger.New);
        }
    }else if(Trigger.isBefore){
        if(Trigger.isDelete){
            ContractRoleTriggerHandler.beforeDelete(Trigger.old);
        }
    }
}