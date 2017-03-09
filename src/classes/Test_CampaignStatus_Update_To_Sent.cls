@isTest

Public class Test_CampaignStatus_Update_To_Sent{
    
    static testmethod void CampaignStatus_Update_To_Sent(){
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.AccountId = a.id;
        insert con;
        
        Campaign c = new Campaign();
        c.Name = 'Test Campaign';
        insert c;
        
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = c.id;
        cm.ContactId = con.id;
        cm.Account__c = a.id;
        insert cm;
        
        CampaignStatus_Update_To_Sent.Update_To_Sent(c.id);
    }
}