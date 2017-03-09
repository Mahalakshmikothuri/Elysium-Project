public class Opportunityext {
                        
                        public list<OpportunityContactRole> opprole {get;set;}
                        public list<string> conid{get;set;}
                        public Opportunityext(ApexPages.StandardController controller) {
                        
                        
                        
                        }
                        public boolean checkonce=false;
                        public pagereference updateststus()
                        {
                        list<CampaignMember> camplist= new list<CampaignMember>();
                        
                        list<CampaignMember> camplistins= new list<CampaignMember>();
                        set<CampaignMember> campset= new set<CampaignMember>();
                        conid= new list<string>();
                        map<id,id>conmap= new map<id,id>();
                        map<id,id>campcheck = new map<id,id>();
                        
                        string opid=ApexPages.currentPage().getParameters().get('id');
                        // list<opportunity> opp=[select id,Campaignid from opportunity where id in:opid];
                        
                        opprole =[select contact.id  from OpportunityContactRole where opportunity.id=:opid];
                        
                        for(OpportunityContactRole o:opprole)
                        {
                        
                        conid.add(o.contact.id);
                        //conmap.put(o.contact.id,o.contact.id);
                        }
                        opportunity opp=[select Campaignid from opportunity where id=:opid];
                        
                        Campaign campaignList = [Select ID, (SELECT Id, Status,contactid,name FROM CampaignMembers) FROM campaign WHERE id =:opp.Campaignid];
                        
                        for(integer i=0;i<opprole.size();i++)
                        {
                        
                        for(CampaignMember c:campaignList.CampaignMembers)
                        
                        {
                        
                        if(opprole[i].contact.id==c.contactid)
                        {
                        
                        
                        c.Status='Responded';
                        camplist.add(c);
                        system.debug(camplist);
                        conmap.put(opprole[i].contact.id,opprole[i].contact.id);
                        
                        }
                       /* 
                        else{
                        system.debug('-------------------->>'+conmap);
                        
                        
                        if(conmap.get(opprole[i].contact.id)==null)
                        {
                        conmap.put(opprole[i].contact.id,opprole[i].contact.id);
                        
                        CampaignMember cnew= new CampaignMember();
                        
                        
                        cnew.contactid=opprole[i].contact.id;
                        cnew.Campaignid=opp.Campaignid;
                        cnew.status='Responded';
                        system.debug('camplistins'+camplistins);
                        campset.add(cnew);
                        system.debug('campset'+campset);
                        camplistins.addall(campset);
                        }
                        
                        }
                        
                        */
                        }
                        
                        
                        }
                        update camplist;
                        for(integer j=0;j<opprole.size();j++)
                        {
                        
                        if(conmap.get(opprole[j].contact.id)==null)
                        {
                        
                        system.debug('opprole[j].contact.id'+opprole[j].contact.id);
                         CampaignMember cnew= new CampaignMember();
                        
                        
                        cnew.contactid=opprole[j].contact.id;
                        cnew.Campaignid=opp.Campaignid;
                        cnew.status='Responded';
                        system.debug('camplistins'+camplistins);
                        camplistins.add(cnew);
                        
                        
                        }
                        
                        }
                        insert camplistins;
                        system.debug('camplistins---------------->>'+conmap);
                       // insert camplistins;
                        
                        return null;
                        
                        }
                        }