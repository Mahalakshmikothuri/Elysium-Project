//**** written by Apoorva Mathur to cover the following triggers ****//
        //1. 'Updating_Camp_Member_Address' on Affiliation 
        //2. 'Update_Campaign_Member_Address' on CampaignMember 
        //3. 'Update_Camp_Member_Address' on Contact
    

@isTest
Public class Test_Update_Camp_Member_Address_Triggers{
    
    Static TestMethod Void Test_Update_Camp_Member_Address_Triggers(){
        
        test.starttest();
        Account a1 = new Account();
        a1.Name = 'Test Household';
        insert a1;
        
        Account a2 = new Account();
        a2.Name = 'Test Organization';
        insert a2;
        
        Contact c1 = new Contact();
        c1.FirstName = 'Test';
        c1.LastName = 'Contact1';
        c1.AccountId = a1.id;
        c1.MailingStreet = 'Street1';
        c1.MailingCity = 'City1';
        c1.MailingState = 'State1';
        c1.MailingCountry = 'Country1';
        c1.MailingPostalCode = '222222';
        c1.Primary_Phone__c='987737377373';
        c1.Primary_Phone_Type__c='mobile';
        c1.npe01__Preferred_Email__c = 'Personal';
        c1.npe01__PreferredPhone__c = 'Home';
        c1.npe01__HomeEmail__c = 'ap@test.com';
        c1.npe01__WorkEmail__c = 'ap@test.com';
        c1.npe01__AlternateEmail__c = 'ap@test.com';
        c1.HomePhone = '9999999999';
        c1.npe01__WorkPhone__c = '9999999999';
        c1.MobilePhone = '9999999999';
        c1.HomePhone = '9999999999';
        insert c1;
        
        Contact c2 = new Contact();
        c2.FirstName = 'Test';
        c2.LastName = 'Contact2';
        c2.AccountId = a2.id;
        c2.MailingStreet = 'Street1';
        c2.MailingCity = 'City1';
        c2.MailingState = 'State1';
        c2.MailingCountry = 'Country1';
        c1.Primary_Phone__c='987737377373';
        c1.Primary_Phone_Type__c='Home';
        c2.MailingPostalCode = '222222';
        c2.npe01__Preferred_Email__c = 'Work';
        c2.npe01__PreferredPhone__c = 'Work';
        c2.npe01__HomeEmail__c = 'ap@test.com';
        c2.npe01__WorkEmail__c = 'ap@test.com';
        c2.npe01__AlternateEmail__c = 'ap@test.com';
        c2.HomePhone = '9999999999';
        c2.npe01__WorkPhone__c = '9999999999';
        c2.MobilePhone = '9999999999';
        c2.OtherPhone = '9999999999';
        insert c2;
        
        Contact c3 = new Contact();
        c3.FirstName = 'Test';
        c3.LastName = 'Contact1';
        c3.AccountId = a1.id;
        c3.MailingStreet = 'Street1';
        c3.MailingCity = 'City1';
        c3.MailingState = 'State1';
        c1.Primary_Phone__c='987737377373';
        c1.Primary_Phone_Type__c='Work';
        c3.MailingCountry = 'Country1';
        c3.MailingPostalCode = '222222';
        c3.npe01__Preferred_Email__c = 'Alternate';
        c3.npe01__PreferredPhone__c = 'Mobile';
        c3.npe01__HomeEmail__c = 'ap@test.com';
        c3.npe01__WorkEmail__c = 'ap@test.com';
        c3.npe01__AlternateEmail__c = 'ap@test.com';
        c3.HomePhone = '9999999999';
        c3.npe01__WorkPhone__c = '9999999999';
        c3.MobilePhone = '9999999999';
        c3.HomePhone = '9999999999';
        insert c3;
        
        Contact c4 = new Contact();
        c4.FirstName = 'Test';
        c4.LastName = 'Contact1';
        c4.AccountId = a1.id;
        c4.MailingStreet = 'Street1';
        c4.MailingCity = 'City1';
        c4.MailingState = 'State1';
        c4.MailingCountry = 'Country1';
        c1.Primary_Phone__c='987737377373';
        c1.Primary_Phone_Type__c='Other';
        c4.MailingPostalCode = '222222';
        c4.npe01__Preferred_Email__c = 'Alternate';
        c4.npe01__PreferredPhone__c = 'Other';
        c4.npe01__HomeEmail__c = 'ap@test.com';
        c4.npe01__WorkEmail__c = 'ap@test.com';
        c4.npe01__AlternateEmail__c = 'ap@test.com';
        c4.HomePhone = '9999999999';
        c4.npe01__WorkPhone__c = '9999999999';
        c4.MobilePhone = '9999999999';
        c4.HomePhone = '9999999999';
        insert c4;
        
        npe5__Affiliation__c aff1 = new npe5__Affiliation__c();
        aff1.npe5__Organization__c = a1.id;
        aff1.npe5__Contact__c = c1.id;
        aff1.Phone__c = '111111111';
        aff1.Email__c = 'ap2@test.com';
        aff1.Mailing_Street__c = 'Street1';
        aff1.Mailing_City__c = 'City1';
        aff1.Mailing_State__c = 'State1';
        aff1.Mailing_Zip__c = '333333';
        insert aff1;
        
        npe5__Affiliation__c aff2 = new npe5__Affiliation__c();
        aff2.npe5__Organization__c = a2.id;
        aff2.npe5__Contact__c = c1.id;
        aff2.Phone__c = '111111111';
        aff2.Email__c = 'ap2@test.com';
        aff2.Mailing_Street__c = 'Street1';
        aff2.Mailing_City__c = 'City1';
        aff2.Mailing_State__c = 'State1';
        aff2.Mailing_Zip__c = '333333';
        insert aff2;
        
        npe5__Affiliation__c aff3 = new npe5__Affiliation__c();
        aff3.npe5__Organization__c = a1.id;
        aff3.npe5__Contact__c = c2.id;
        aff3.Phone__c = '111111111';
        aff3.Email__c = 'ap2@test.com';
        aff3.Mailing_Street__c = 'Street1';
        aff3.Mailing_City__c = 'City1';
        aff3.Mailing_State__c = 'State1';
        aff3.Mailing_Zip__c = '333333';
        insert aff3;
        
        npe5__Affiliation__c aff4 = new npe5__Affiliation__c();
        aff4.npe5__Organization__c = a2.id;
        aff4.npe5__Contact__c = c2.id;
        aff4.Phone__c = '111111111';
        aff4.Email__c = 'ap2@test.com';
        aff4.Mailing_Street__c = 'Street1';
        aff4.Mailing_City__c = 'City1';
        aff4.Mailing_State__c = 'State1';
        aff4.Mailing_Zip__c = '333333';
        insert aff4;
        
        Campaign cmp1 = new Campaign();
        cmp1.Name = 'New Campaign1';
        insert cmp1;
        
        Campaign cmp2 = new Campaign();
        cmp2.Name = 'New Campaign2';
        insert cmp2;
        
        CampaignMember cm1  = new CampaignMember();
        cm1.CampaignId = cmp1.id;
        cm1.ContactId = c1.id;
        cm1.Account__c = a1.id;
        insert cm1;
        
        CampaignMember cm2  = new CampaignMember();
        cm2.CampaignId = cmp2.id;
        cm2.ContactId = c1.id;
        cm2.Account__c = a2.id;
        insert cm2;
        
        cm1.Account__c = a2.id;
        update cm1; 
        
        cm2.Account__c = a1.id;
        update cm2;
        
        c1.MailingStreet = 'Street2';
        c1.MailingCity = 'City2';
        c1.MailingState = 'State2';
        c1.MailingCountry = 'Country2';
        c1.MailingPostalCode = '555555';
        c1.npe01__Preferred_Email__c = 'Work';
        c1.npe01__PreferredPhone__c = 'Work';
        c1.npe01__HomeEmail__c = 'ap1@test.com';
        c1.npe01__WorkEmail__c = 'ap2@test.com';
        c1.npe01__AlternateEmail__c = 'ap3@test.com';
        c1.HomePhone = '9999999910';
        c1.npe01__WorkPhone__c = '9999910999';
        c1.Primary_Phone__c='98777373';
        c1.Primary_Phone_Type__c='Work';
        c1.MobilePhone = '9999910999';
        c1.HomePhone = '9999991099';
        update c1;
        
        c1.MailingStreet = 'Street2';
        c1.MailingCity = 'City2';
        c1.MailingState = 'State2';
        c1.MailingCountry = 'Country2';
        c1.MailingPostalCode = '555555';
        c1.npe01__Preferred_Email__c = 'Alternate';
        c1.npe01__PreferredPhone__c = 'Mobile';
        c1.npe01__HomeEmail__c = 'ap1@test.com';
        c1.npe01__WorkEmail__c = 'ap2@test.com';
        c1.npe01__AlternateEmail__c = 'ap3@test.com';
        c1.HomePhone = '9999999910';
        c1.Primary_Phone__c='98457377373';
        c1.Primary_Phone_Type__c='Other';
        c1.npe01__WorkPhone__c = '9999910999';
        c1.MobilePhone = '9999910999';
        c1.HomePhone = '9999991099';
        update c1;
        
        c1.MailingStreet = 'Street2';
        c1.MailingCity = 'City2';
        c1.MailingState = 'State2';
        c1.MailingCountry = 'Country2';
        c1.MailingPostalCode = '555555';
        c1.npe01__Preferred_Email__c = 'Alternate';
        c1.npe01__PreferredPhone__c = 'Other';
        c1.npe01__HomeEmail__c = 'ap1@test.com';
        c1.npe01__WorkEmail__c = 'ap2@test.com';
        c1.npe01__AlternateEmail__c = 'ap3@test.com';
        c1.HomePhone = '9999999910';
        c1.Primary_Phone__c='987737377563';
        //c1.Primary_Phone_Type__c='mobile';
        c1.npe01__WorkPhone__c = '9999910999';
        c1.MobilePhone = '9999910999';
        c1.HomePhone = '9999991099';
        update c1;
        
        aff1.Phone__c = '111111111';
        aff1.Email__c = 'ap4@test.com';
        aff1.Mailing_Street__c = 'Street3';
        aff1.Mailing_City__c = 'City3';
        aff1.Mailing_State__c = 'State3';
        aff1.Mailing_Zip__c = '333345';
        update aff1;
        test.stoptest();
    }
}