/*public  class Praveena_TestButton {
    public static List<OpportunityContactRole> test()
   {
       List<OpportunityContactRole> ocr=[select Role, ContactId, IsPrimary,OpportunityId from OpportunityContactRole
                                         where OpportunityId='00663000005t4L5AAI']; 
       for(OpportunityContactRole o:ocr)
       {
           AggregateResult[] groupedResults= [SELECT  Sum(npo02__Soft_Credit_Total__c)t
              FROM Contact 
              where id in ( select ContactId from 
              OpportunityContactRole where Role =:o.Role  and OpportunityId=:o.OpportunityId)];
           
            for (AggregateResult ar : groupedResults)  {
                System.debug('Contact Role: '+ o.Role +',Total amount: ' + ar.get('t'));
             }
       }
       return ocr;
   }
}*/

global class Praveena_TestButton{
    webservice static String UpdateTotalButton(ID oppId){
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
            
        Contact ct = [SELECT Id, npo02__Soft_Credit_Total__c FROM Contact WHERE Id = :oppContactRole.ContactId]; 
        ct.npo02__Soft_Credit_Total__c = j;
        update ct;
        
        return 'Updated Soft Credit';
    }
}