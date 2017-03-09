//**** written by Apoorva to cover AUC_Auction_CreateCampaigns_Updated trigger ****//

@isTest
public class Test_AUC_Auction_CreateCampaigns_Updated{
    
    Static testMethod void Test_AUC_Auction_CreateCampaigns(){
        GW_Auctions__Auction__c auc = new GW_Auctions__Auction__c ();
        auc.Name = 'test';
        auc.GW_Auctions__Auction_Date__c = system.today() + 5;
        insert auc;
    }
}