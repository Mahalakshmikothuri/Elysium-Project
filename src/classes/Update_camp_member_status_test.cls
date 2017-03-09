@istest
                        public class Update_camp_member_status_test{
                        
                        public static testmethod void mytest()
                        {
                        recordtype r=[select id,name from recordtype where name='Organization' and sobjecttype='account'];
                        
                        account acc= new account();
                        acc.Name='test';
                        insert acc;
                        
                        contact con = new contact();
                        con.lastname='test';
                        con.accountid=acc.id;
                        
                        insert con;
                        
                        
                        contact con1 = new contact();
                        con1.lastname='newtest';
                        con1.accountid=acc.id;
                        
                        insert con1;
                        
                        recordtype cr=[select id,name from recordtype where  sobjecttype='campaign' and name='Marketing Campaign'];
                        
                        campaign camp = new campaign();
                        camp.name='new';
                        camp.isactive=true;
                        camp.recordtypeid=cr.id;
                        insert camp;
                        
                        
                        CampaignMember cm=new CampaignMember();
                        cm.Campaignid=camp.id;
                        cm.Number_Planned__c=1;
                        cm.contactid=con.id;
                        insert cm;
                        
                        
                        campaign camp1 = new campaign();
                        camp1.name='new';
                        camp1.isactive=true;
                        camp1.recordtypeid=cr.id;
                        insert camp1;
                        
                        recordtype cmr=[select id,name from recordtype where sobjecttype='CampaignMember' and name='Default Campaign Member'];
                        
                        CampaignMember cm1=new CampaignMember();
                        cm1.Campaignid=camp.id;
                        cm1.Number_Planned__c=1;
                        cm1.contactid=con1.id;
                        insert cm1;
                        
                        
                        
                        recordtype orp=[select id,name from recordtype where sobjecttype='opportunity' and name='Donation'];
                        
                        opportunity opp= new opportunity();
                        opp.name='test';
                        opp.recordtypeid=orp.id;
                        opp.accountid=acc.id;
                        opp.Campaignid=camp.id;
                        opp.StageName='Pledged';
                        opp.CloseDate=system.today()+1;
                        insert opp;
                        //cm.recordtypeid=cmr.id;
                        
                        opportunity oppup=[select id,Campaignid from opportunity where id=:opp.id];
                        oppup.Campaignid=camp1.id;
                        update oppup;
                         test.starttest();
                        opportunity delopp=[select id from opportunity where id=:oppup.id];
                        delete delopp;
                        test.stoptest();
                        
                        }
                        
                        public static testmethod void mytest1()
                        {
                        recordtype r=[select id,name from recordtype where name='Household Account' and sobjecttype='account'];
                        
                        account acc= new account();
                        acc.Name='test';
                        insert acc;
                        
                        contact con = new contact();
                        con.lastname='test';
                        con.accountid=acc.id;
                        
                        insert con;
                        
                        
                        contact con1 = new contact();
                        con1.lastname='newtest';
                        con1.accountid=acc.id;
                        
                        insert con1;
                        
                        npe5__Affiliation__c aff= new npe5__Affiliation__c();
                        aff.npe5__Contact__c=con.id;
                        aff.npe5__Organization__c=acc.id;
                        insert aff;
                        
                        npe5__Affiliation__c aff1= new npe5__Affiliation__c();
                        aff1.npe5__Contact__c=con1.id;
                        aff1.npe5__Organization__c=acc.id;
                        insert aff1;
                        recordtype cr=[select id,name from recordtype where  sobjecttype='campaign' and name='Marketing Campaign'];
                        
                        campaign camp = new campaign();
                        camp.name='new';
                        camp.isactive=true;
                        camp.recordtypeid=cr.id;
                        insert camp;
                        
                        
                        CampaignMember cm=new CampaignMember();
                        cm.Campaignid=camp.id;
                        cm.Number_Planned__c=1;
                        cm.contactid=con.id;
                        insert cm;
                        
                        
                        campaign camp1 = new campaign();
                        camp1.name='newnew';
                        camp1.isactive=true;
                        camp1.recordtypeid=cr.id;
                        insert camp1;
                        
                        
                        CampaignMember cm1=new CampaignMember();
                        cm1.Campaignid=camp1.id;
                        cm1.Number_Planned__c=1;
                        cm1.contactid=con1.id;
                        insert cm1;
                        
                        
                        
                        recordtype orp=[select id,name from recordtype where sobjecttype='opportunity' and name='Donation'];
                        
                        opportunity opp= new opportunity();
                        opp.name='test';
                        opp.recordtypeid=orp.id;
                        opp.accountid=acc.id;
                        opp.Campaignid=camp.id;
                        opp.StageName='Pledged';
                        opp.CloseDate=system.today()+1;
                        insert opp;
                        //cm.recordtypeid=cmr.id;
                        
                        opportunity oppup=[select id,Campaignid from opportunity where id=:opp.id];
                        oppup.Campaignid=camp1.id;
                        update oppup;
                        test.starttest();
                        opportunity delopp=[select id from opportunity where id=:oppup.id];
                        delete delopp;
                        test.stoptest();
                        
                        }
                        
                        }