trigger Camp_memberupdate  on Contact (after update) {
                    list<id> conid= new list<id>();
                    map<id,id>cmap= new map<id,id>();
                    for(contact c:trigger.new)
                    {
                    contact oldcon=trigger.oldMap.get(c.id);
                    if(c.npo02__Soft_Credit_Total__c!=oldcon.npo02__Soft_Credit_Total__c)
                    {
                    conid.add(c.id);
                    cmap.put(c.id,c.id);
                    
                    }
                    
                    }
                    list<id>oppid= new list<id>();
                    map<id,id>conmap= new map<id,id>();
                    list<OpportunityContactRole> opprole=[Select OpportunityId,contactid From OpportunityContactRole where ContactId in:conid];
                    for(OpportunityContactRole o:opprole)
                    {
                    oppid.add(o.OpportunityId);
                    conmap.put(o.contactid,o.contactid);
                    }
                    list<opportunity> opp=[select id,Campaignid from opportunity where id in:oppid];
                    list<id> campid= new list<id>();
                    for(opportunity o:opp)
                    {
                    campid.add(o.Campaignid);
                    
                    }
                    List<Campaign> campaignList = [Select ID, (SELECT Id, Status,contactid,name FROM CampaignMembers) FROM campaign WHERE id = :campid ];
                    
                    list<CampaignMember> clst=new list<CampaignMember>();
                                        list<CampaignMember> inscm=new list<CampaignMember>();

                    boolean reqmem=false;
                    boolean listempty=false;
                    for(Campaign cm:campaignList)
                    {
                    if(cm.CampaignMembers.size()!=null)
                    {
                    for(CampaignMember cms:cm.CampaignMembers)
                    {
                    
                    if(conmap.get(cms.contactid)==cms.contactid)
                    {
                    reqmem=true;
                    listempty=false;
                    cms.Status='Responded';
                    clst.add(cms);
                    
                    }
                    else
                    {
                      reqmem=false;
                      listempty=false;
                    }
                    }
                    }
                    else{
                    listempty=true;
                    reqmem=false;
                    }
                    // CampaignMember cnew= new CampaignMember();
                    // cnew.contactid=conmap.get(cmap);
                    
                    
                    }
                    system.debug('listempty'+listempty);
                    system.debug('reqmem'+reqmem);
                    if(reqmem==false||listempty==true)
                    {
                   
                     list<contact> c=[select id,name from contact where id in:conid];
                    
                    for(Campaign cm:campaignList)
                    {
                    for(contact con:c)
                    {
                    CampaignMember cnew= new CampaignMember();
                    //cnew.name=con.name;
                    cnew.contactid=con.id;
                    cnew.Campaignid=cm.id;
                    cnew.status='Responded';
                    inscm.add(cnew); 
                    system.debug('inscm'+inscm);
                    }
                    
                    }
                    }
                    try{
                    insert inscm;
                    }
                    catch(exception e){}
                    update clst;
                    }