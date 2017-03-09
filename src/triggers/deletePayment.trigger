trigger deletePayment on npe01__OppPayment__c (after insert) {

    if(trigger.isInsert && trigger.isAfter)
        deletePayment_TriggerHandler.deletePayments(trigger.new);
}