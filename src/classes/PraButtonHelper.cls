public class PraButtonHelper {
    public Opportunity opp;
     public PraButtonHelper( ApexPages.StandardController stdController ) {
        opp = ( Opportunity )stdController.getRecord();        
    }
     public void updateContacts(){
        PraButtonHelper.updateSoftCreditTotals( opp.Id );    
    }
 @future public static void updateSoftCreditTotals( Id oppId ) {
  /*Opportunity opp1 = [ SELECT Id,name,Amount FROM Opportunity WHERE Id = :oppId ];
      opp1.name=(Double.valueOf(opp1.Amount).format().remove(','))+'-get8-'+opp1.name;
       update opp1;*/

       OpportunityContactRole oppContactRole = [SELECT Id, OpportunityId, ContactId FROM OpportunityContactRole WHERE OpportunityId = :oppId]; 
       List<Opportunity> opp = [Select Opportunity.Id, Opportunity.Amount 
                                 From Opportunity Where Opportunity.Id 
                                 IN (Select OpportunityContactRole.OpportunityId from OpportunityContactRole where OpportunityContactRole.ContactId = :oppContactRole.ContactId)]; 
       Double j=0;
        for(Opportunity op:opp){
            if(op.Amount!=null)
            {
              j+=op.Amount;
            }
        }
     If(oppContactRole != null)  {
        Contact ct = [SELECT Id, npo02__Soft_Credit_Total__c FROM Contact WHERE Id = :oppContactRole.ContactId]; 
        ct.npo02__Soft_Credit_Total__c = j;
        update ct;
     }
 }
}

/*public with sharing class OppHelper {
    public Opportunity opp;
    public OppHelper( ApexPages.StandardController stdController ) {
        opp = ( Opportunity )stdController.getRecord();        
    }
    public void rollupOppContacts(){
        OppHelper.rollupOppContactsFuture( opp.Id );    
    }
    @future public static void rollupOppContactsFuture( Id oppId ) {
        Contact[] contactList = [ SELECT Id, Some_field__c FROM Contact
                             WHERE Id IN ( SELECT ContactId FROM OpportunityContactRole
                                         WHERE OpportunityId = :oppId ) ];
        Opportunity opp = [ SELECT Id, Some_rollup_score__c FROM Opportunity WHERE Id = :oppId ];
        opp.Some_rollup_score__c = 0;
        
        for( Contact contact : contactList ) {
            opp.Some_rollup_score__c = contact.Some_field__c;
        }
        update opp;
    }
}*/