//written by sandeep for Updating Prior Account Totals when opportunity's Account is changed
trigger updateTotals on Account (after update) {
    
    list<Opportunity> lstOpptytoBeUpdated = new List<Opportunity>();
    list<Id> accountIds = new list<Id>();
    list<Account> lstAcc = new list<Account>();
    list<Account> lstAcctobeUpdated = new list<Account>();  
    if(trigger.isUpdate && trigger.isAfter){
        for(Account ac: trigger.new)
        {
            accountIds.add(ac.id);
        }
        lstAcc = [select id,name,(select id,name from Opportunities) from Account where id in:accountIds];
        //lstOpptytoBeUpdated = [select id,name from opportunity where AccountId in:accountIds];  
    
        for(Account acnt:lstAcc)
        {
            if(acnt.Opportunities!=null){
                for(Opportunity op: acnt.Opportunities){
                    op.Name=op.Name;
                    lstOpptytoBeUpdated.add(op);
                }
            }
            else{
                    acnt.Total_Pledged_Gifts__c = 0;
                    acnt.Total_Number_of_Pledged_Gifts__c = 0;
                    acnt.Total_Pledged_Gifts_Last_N_Days__c = 0;
                    acnt.Number_of_Pledged_Gifts_Last_N_Days__c = 0;
                    acnt.npo02__TotalOppAmount__c=0;
                    
                    acnt.Total_Asked_Gifts__c = 0;
                    acnt.Total_Number_of_Asked_Gifts__c = 0;
                    acnt.Total_Asked_Gifts_Last_N_Days__c = 0;
                    acnt.Number_of_Asked_Gifts_Last_N_Days__c = 0;
                    lstAcctobeUpdated.add(acnt);
            }
        }
    }
    
    if(!lstOpptytoBeUpdated.isEmpty())
        update lstOpptytoBeUpdated;
    
    if(!lstAcctobeUpdated.isEmpty())
        update lstAcctobeUpdated;   
}