trigger Update_camp_member_status on Opportunity (before insert,after insert,after update,before delete,before update) {
/*
Trigger Name: Update_camp_member_status
Purpose/Overview: written in order to update status on campign members and to delete camping members
Author: Sri Harsha g
Created Date:2017
Test Class Name:       
Change History: 
Date Modified: Developer Name: Section/Page Block Modified/Added: Purpose/Overview of Change
*/
                        //*************** written by harsha  to update status on campign member********************//
                        set<id> accid= new set<id> ();
                        set<id> campid=new set<id>();
                        map<id,id>conmap= new map<id,id>();
                        set<id> Householdacc = new set<id>();
                        boolean orgacc=false;
                        
                        if(trigger.isbefore&&trigger.isinsert)
                        {
                        for(opportunity o:trigger.new)
                        {
                        if(o.Campaignid!=null)
                        {
                        campid.add(o.Campaignid);
                        accid.add(o.accountid);  
                                      
                        }
                        }
                        set<id>accfid= new set<id>();
                        
                        recordtype r=[select id,name from recordtype where name='Organization' and sobjecttype='account'];
                        
                        list<account> acc=[select id,recordtypeid from account where id in:accid];
                        for(account a:acc)
                        {
                        
                        if(a.recordtypeid==r.id)
                        {
                        accfid.add(a.id);
                        orgacc=true;
                        }
                        else{
                        Householdacc.add(a.id);
                        orgacc=false;
                        }
                        }
                        list<CampaignMember> deletemember= new list<CampaignMember>();
                        if(orgacc==true)
                        {
                        list<npe5__Affiliation__c> affiliation=[select id,npe5__Contact__c,npe5__Organization__c from npe5__Affiliation__c where npe5__Organization__c in:accfid ];
                        
                        
                        
                        list<CampaignMember> camplist= new list<CampaignMember>();
                        list<Campaign> campaignList = [Select ID, (SELECT Id, Status,contactid,name,Number_Planned__c,Number_Sent__c FROM CampaignMembers) FROM campaign WHERE id in:campid];
                        
                        for(integer i=0;i<affiliation.size();i++)
                        {
                        
                        for(Campaign camp:campaignList )
                        {
                        for(CampaignMember c:camp.CampaignMembers)
                        
                        {
                        
                        if(affiliation[i].npe5__Contact__c==c.contactid)
                        {
                        
                          if(c.Number_Planned__c!=null||c.Number_Sent__c!=null)
                         {
                        c.Status='Responded';
                        camplist.add(c);
                        system.debug(camplist);
                        conmap.put(affiliation[i].npe5__Contact__c,affiliation[i].npe5__Contact__c);
                        
                        }
                        else{
                       // deletemember.add(c);
                        }
                        }
                        
                        }
                        
                        }
                        }
                        try{
                        update camplist;
                       // delete deletemember;
                        }
                        catch(exception e){system.debug('ee'+e);}
                       
                        }
                        
                        if(orgacc==false)
                        {
                        list<contact> con=[select id,name from contact where accountid in: Householdacc];
                        
                        
                         list<CampaignMember> camplist= new list<CampaignMember>();
                        list<Campaign> campaignList = [Select ID, (SELECT Id, Status,contactid,name,Number_Planned__c,Number_Sent__c FROM CampaignMembers) FROM campaign WHERE id in:campid];
                        
                        for(integer i=0;i<con.size();i++)
                        {
                        
                        for(Campaign camp:campaignList )
                        {
                        for(CampaignMember c:camp.CampaignMembers)
                        
                        {
                        
                        if(con[i].id==c.contactid)
                        {
                        
                        if(c.Number_Planned__c!=null||c.Number_Sent__c!=null)
                         {
                        c.Status='Responded';
                        camplist.add(c);
                        system.debug(camplist);
                        conmap.put(con[i].id,con[i].id);
                        
                        }
                         else{
                      //  deletemember.add(c);
                        }
                        }
                        
                        }
                        
                        }
                        }
                        try{
                        update camplist;
                       // delete deletemember;
                        }
                        catch(exception e){system.debug('ee'+e);}
                       
                        }
                        
                        
                        }
                        
                        
                        
                        
                        //******************updating previous campin details to back and updating new camp member status*************************//
                        list<id>  oldcaomid= new list<id>();
                        list<id> oldacc= new list<id>();
                        list<id>oppid=new list<id>();
                        list<CampaignMember> oldcMembers= new list<CampaignMember>();
                        map<id,id> oldmapids = new map<id,id>();
                        list<CampaignMember> delMembers= new list<CampaignMember>();
                        list<opportunity> updateopp= new list<opportunity>();
                        map<id,id>oldcamid= new map<id,id>();
                        if(trigger.isbefore&&trigger.isupdate)
                        {
                        for(opportunity o:trigger.new)
                        {
                        Opportunity oldOpp = Trigger.oldMap.get(o.Id);
                        
                        if(o.Campaignid!=oldopp.Campaignid)
                        {
                        if(o.Campaignid!=null)
                        {
                        campid.add(o.Campaignid);
                        system.debug('campid'+campid);
                        accid.add(o.accountid);
                        system.debug('accid'+accid);
                        }
                        oppid.add(o.id);
                        oldcamid.put(o.id,oldopp.Campaignid);
                        oldcaomid.add(oldopp.Campaignid);
                        oldacc.add(oldopp.accountid);
                        system.debug('oldaccid'+oldacc);
                        }
                        }
                        
                        list<id> oldaccfid = new list<id>();
                        
                        recordtype r=[select id,name from recordtype where name='Organization' and sobjecttype='account'];
                        
                        list<account> oldaccr=[select id,recordtypeid from account where id in : oldacc];
                        for(account a:oldaccr)
                        {
                        
                        if(a.recordtypeid==r.id)
                        {
                        oldaccfid.add(a.id);
                        system.debug(oldaccfid);
                                                orgacc=true;

                        }
                        else{
                        
                        oldaccfid.add(a.id);
                        }
                        }
                        if(orgacc==true)
                        {
                        list<npe5__Affiliation__c> oldaffiliation=[select id,npe5__Contact__c,npe5__Organization__c from npe5__Affiliation__c where npe5__Organization__c in:oldaccfid];
                        
                        system.debug('oldaffiliation'+oldaffiliation);
                        list<Campaign> oldList = [Select ID, (SELECT Id, Status,contactid,name,Number_Planned__c,Number_Sent__c FROM CampaignMembers) FROM campaign WHERE id in:oldcaomid];
                        system.debug('oldList'+oldList);
                        
                        for(integer i=0;i<oldaffiliation.size();i++)
                        {
                        for(Campaign camp:oldList)
                        {
                        for(CampaignMember c:camp.CampaignMembers)
                        
                        {
                        system.debug('before affelitons');
                        system.debug('oldaffiliation[i].npe5__Contact__c'+c.Number_Planned__c);
                        system.debug('oldaffiliation[i].npe5__Contact__c'+c.Number_Sent__c);
                        if(oldaffiliation[i].npe5__Contact__c==c.contactid)
                        {
                        system.debug('checked affelitons');
                        
                        if(c.Number_Planned__c==1&&c.Number_Sent__c==null)
                        {
                        if(oldmapids.get(c.id)==null)
                        {
                        c.Status='Planned';
                        oldcMembers.add(c);
                        system.debug(oldcMembers);
                        system.debug('oldcMembers'+oldcMembers);
                        oldmapids.put(c.id,c.id);
                        }
                        }
                        
                        if((c.Number_Sent__c==1&&c.Number_Planned__c==null)||(c.Number_Sent__c==1&&c.Number_Planned__c==1))
                        {
                        if(oldmapids.get(c.id)==null)
                        {
                        c.Status='Sent';
                        oldcMembers.add(c);
                        
                        system.debug(oldcMembers);
                        system.debug('oldcMembers'+oldcMembers); 
                          oldmapids.put(c.id,c.id);                         
                        }
                        }
                        
                        
                        if(c.Number_Sent__c==null&&c.Number_Planned__c==null)
                        {
                        delMembers.add(c);
                        
                        system.debug('delMembers'+delMembers);                            
                        }
                        }
                        
                        }
                        
                        }
                        }
                        
                        delete delMembers;
                       
                        update oldcMembers;
                        
                        list<opportunity> opp=[select id,Campaign_ID_Prior_Value__c from opportunity where id in:oppid];
                        
                        for(opportunity ocid:opp)
                        {
                        //if(oldcamid.get(ocid.id)==ocid.id)
                        {
                        
                        ocid.Campaign_ID_Prior_Value__c=oldcamid.get(ocid.id);
                        updateopp.add(ocid);
                        }
                        }
                        //update updateopp;       
                        
                         
                         }
                         
                         //------------*****checking houseold contact*****-------------------------//
                         if(orgacc==false)
                         {
                         list<contact> oldcon=[select id,name from contact where accountid in:oldaccfid];
                        
                        system.debug('oldaffiliation'+oldcon);
                        list<Campaign> oldList = [Select ID, (SELECT Id, Status,contactid,name,Number_Planned__c,Number_Sent__c FROM CampaignMembers) FROM campaign WHERE id in:oldcaomid];
                        system.debug('oldList'+oldList);
                        
                         for(integer i=0;i<oldcon.size();i++)
                        {
                        for(Campaign camp:oldList)
                        {
                        for(CampaignMember c:camp.CampaignMembers)
                        
                        {
                        system.debug('before affelitons');
                        system.debug('oldaffiliation[i].npe5__Contact__c'+c.Number_Planned__c);
                        system.debug('oldaffiliation[i].npe5__Contact__c'+c.Number_Sent__c);
                        if(oldcon[i].id==c.contactid)
                        {
                        system.debug('checked affelitons');
                        
                        if(c.Number_Planned__c==1&&c.Number_Sent__c==null)
                        {
                        c.Status='Planned';
                        oldcMembers.add(c);
                        system.debug(oldcMembers);
                        system.debug('oldcMembers'+oldcMembers);
                        
                        }
                        
                        if((c.Number_Sent__c==1&&c.Number_Planned__c==null)||(c.Number_Sent__c==1&&c.Number_Planned__c==1))
                        {
                        c.Status='Sent';
                        oldcMembers.add(c);
                        
                        system.debug(oldcMembers);
                        system.debug('oldcMembers'+oldcMembers);                            
                        }
                        
                        
                        
                        if(c.Number_Sent__c==null&&c.Number_Planned__c==null)
                        {
                        delMembers.add(c);
                        
                        system.debug('delMembers'+delMembers);                            
                        }
                        }
                        
                        }
                        
                        }
                        }
                        
                        delete delMembers;
                        update oldcMembers;
                        system.debug('oldcMembers'+oldcMembers);
                        list<opportunity> opp=[select id,Campaign_ID_Prior_Value__c from opportunity where id in:oppid];
                        
                        for(opportunity ocid:opp)
                        {
                        //if(oldcamid.get(ocid.id)==ocid.id)
                        {
                        
                        ocid.Campaign_ID_Prior_Value__c=oldcamid.get(ocid.id);
                        updateopp.add(ocid);
                        }
                        }
                       // update updateopp;   
                         
                         
                         
                   
                        
                         }
                           
                           // ********* Deleting and updating status to responded values************************//
                        map<id,id> camidlstchk= new map<id,id>();
                        list<CampaignMember> deletmembers = new list<CampaignMember>();
                        boolean newaccorg=false;
                        if(campid.size()!=null)
                        {
                        list<id>accfid= new list<id>();
                        
                        //recordtype r=[select id,name from recordtype where name='Organization' and sobjecttype='account'];
                        
                        list<account> acc=[select id,recordtypeid from account where id in:accid];
                        for(account a:acc)
                        {                
                        if(a.recordtypeid==r.id)
                        {
                        accfid.add(a.id);
                        newaccorg=true;
                        }
                        else{
                        accfid.add(a.id);
                        }
                        }
                        if(newaccorg==true)
                        {
                        list<npe5__Affiliation__c> affiliation=[select id,npe5__Contact__c,npe5__Organization__c from npe5__Affiliation__c where npe5__Organization__c in:accfid ];           
                        list<CampaignMember> camplist= new list<CampaignMember>();
                        list<Campaign> campaignList = [Select ID, (SELECT Id, Status,contactid,name,Number_Planned__c,Number_Sent__c FROM CampaignMembers) FROM campaign WHERE id in:campid];
                        
                        for(integer i=0;i<affiliation.size();i++)
                        {                
                        for(Campaign camp:campaignList )
                        {
                        for(CampaignMember c:camp.CampaignMembers)                        
                        {                        
                        if(affiliation[i].npe5__Contact__c==c.contactid)
                        {
                        if(c.Number_Planned__c==1||c.Number_Sent__c==1)
                        {
                        //if(camidlstchk.get(c.id)==null)
                        {
                        c.Status='Responded';
                        camplist.add(c);
                        system.debug(camplist);
                        conmap.put(affiliation[i].npe5__Contact__c,affiliation[i].npe5__Contact__c);  
                        camidlstchk.put(c.id,c.id); 
                        }
                        }
                        else{
                        deletmembers.add(c);     
                        system.debug('----------->>'+deletmembers.size());                           
                        }
                        }                        
                        }                    
                        }
                        }
                        update camplist;
                        delete deletmembers;   
                        system.debug(deletmembers);         
                        }
                        
                        
                        
                        if(newaccorg==false)
                        {
                        system.debug('newaccorg'+newaccorg);
                        list<contact> con=[select id,name from contact where accountid in:accfid ];           
                        list<CampaignMember> camplist= new list<CampaignMember>();
                        list<Campaign> campaignList = [Select ID, (SELECT Id, Status,contactid,name,Number_Planned__c,Number_Sent__c FROM CampaignMembers) FROM campaign WHERE id in:campid];
                        
                        for(integer i=0;i<con.size();i++)
                        {                
                        for(Campaign camp:campaignList )
                        {
                        for(CampaignMember c:camp.CampaignMembers)                        
                        {                        
                        if(con[i].id==c.contactid)
                        {
                        if(c.Number_Planned__c==1||c.Number_Sent__c==1)
                        {
                        c.Status='Responded';
                        camplist.add(c);
                        system.debug(camplist);
                        conmap.put(con[i].id,con[i].id);   
                        }
                        else{
                        deletmembers.add(c);     
                        system.debug('----------->>'+deletmembers.size());                           
                        }
                        }                        
                        }                    
                        }
                        }
                        update camplist;
                        delete deletmembers; 
                        system.debug('camplist'+camplist);  
                        system.debug(deletmembers);         
                        
                        
                        
                        } 
                        
                        }
                           
                        } 
                        
                        //**************** Trigger delete Event*******************************************//
                        
                        if(trigger.isbefore&&trigger.isdelete)
                        {
                        list<CampaignMember> deletmembers = new list<CampaignMember>();
                        
                        list<id> campmem = new list<id>();
                        list<id>accidold = new list<id>();
                        map<id,id> camdelmap= new map<id,id>();
                        list<CampaignMember> cmapmlst= new list<CampaignMember>();
                        
                        for(opportunity o:trigger.old)
                        {            
                        if(o.Campaignid!=null)
                        {                
                        campmem.add(o.Campaignid);
                        accidold.add(o.accountid);
                        }         
                        }        
                        recordtype r=[select id,name from recordtype where name='Organization' and sobjecttype='account'];
                        
                        list<account> acc=[select id,recordtypeid from account where id in:accidold];
                        list<id>accfid= new list<id>();
                        
                        for(account a:acc)
                        {                
                        if(a.recordtypeid==r.id)
                        {
                        accfid.add(a.id);
                        orgacc=true;
                        }
                        else{
                        
                         accfid.add(a.id);

                        }
                        }
                        if(orgacc==true)
                        {
                        list<npe5__Affiliation__c> affiliation=[select id,npe5__Contact__c,npe5__Organization__c from npe5__Affiliation__c where npe5__Organization__c in:accfid ];           
                        list<CampaignMember> camplist= new list<CampaignMember>();
                        // list<Campaign> campaignList = [Select ID, (SELECT Id, Status,contactid,name,Number_Planned__c,Number_Sent__c FROM CampaignMembers) FROM campaign WHERE id in:campid];
                        
                        list<Campaign> campaignList = [Select ID, (SELECT Id, Status,contactid,name,Number_Planned__c,Number_Sent__c FROM CampaignMembers) FROM campaign WHERE id in:campmem];        
                        
                        for(integer i=0;i<affiliation.size();i++)
                        {                
                        for(Campaign camp:campaignList )
                        {
                        for(CampaignMember c:camp.CampaignMembers)                        
                        {                        
                        if(affiliation[i].npe5__Contact__c==c.contactid)
                        {
                        
                        
                        if(c.Number_Planned__c==1&&c.Number_Sent__c==null)
                        {
                        //if(camdelmap.get(c.id)==null)
                        {
                        c.Status='Planned';
                        cmapmlst.add(c);
                        system.debug(oldcMembers);
                        system.debug('oldcMembers'+oldcMembers); 
                        camdelmap.put(c.id,c.id);                   
                        }       
                        }         
                        if((c.Number_Sent__c==1&&c.Number_Planned__c==null)||(c.Number_Sent__c==1&&c.Number_Planned__c==1))
                        {
                       // if(camdelmap.get(c.id)==null)
                        {
                          //cmapmlst.clear();

                        c.Status='Sent';
                        cmapmlst.add(c);
                        
                        system.debug(oldcMembers);
                        system.debug('oldcMembers'+oldcMembers); 
                        camdelmap.put(c.id,c.id);
                        }                   
                        }
                        
                        /*
                        
                        if(c.Number_Planned__c==1)
                        {
                        //if(camdelmap.get(c.id)==null)
                        {
                        c.Status='Planned';
                        cmapmlst.add(c);
                        system.debug(oldcMembers);
                        system.debug('oldcMembers'+oldcMembers); 
                        camdelmap.put(c.id,c.id);
                        }                   
                        }                
                        if(c.Number_Sent__c==1)
                        {
                        //if(camdelmap.get(c.id)==null)
                         {
                                                 //cmapmlst.clear();

                        c.Status='Sent';
                        cmapmlst.add(c);
                        
                        system.debug(oldcMembers);
                        system.debug('oldcMembers'+oldcMembers);
                                                camdelmap.put(c.id,c.id);

                        }                    
                        }  
                        if(c.Number_Planned__c==1&&c.Number_Sent__c==1)
                        {
                                             //if(camdelmap.get(c.id)==null)
                                             {
                                                camdelmap.put(c.id,c.id);

                        cmapmlst.clear();
                        c.Status='Sent';
                        cmapmlst.add(c);
                        }
                        
                        }
                        */
                        
                        
                        if(c.Number_Sent__c==null&&c.Number_Planned__c==null)
                        {
                        deletmembers.add(c);                    
                        }
                        }
                        }
                        }
                        
                        }
                        update cmapmlst;
                        delete deletmembers ;
                        } 
                        if(orgacc==false)
                        {
                        list<contact> con=[select id,name from contact where accountid in:accfid ];           
                        list<CampaignMember> camplist= new list<CampaignMember>();
                        // list<Campaign> campaignList = [Select ID, (SELECT Id, Status,contactid,name,Number_Planned__c,Number_Sent__c FROM CampaignMembers) FROM campaign WHERE id in:campid];
                        
                        list<Campaign> campaignList = [Select ID, (SELECT Id, Status,contactid,name,Number_Planned__c,Number_Sent__c FROM CampaignMembers) FROM campaign WHERE id in:campmem];        
                        
                        for(integer i=0;i<con.size();i++)
                        {                
                        for(Campaign camp:campaignList )
                        {
                        for(CampaignMember c:camp.CampaignMembers)                        
                        {                        
                        if(con[i].id==c.contactid)
                        {
                        
                        if(c.Number_Planned__c==1&&c.Number_Sent__c==null)
                        {
                        //if(camdelmap.get(c.id)==null)
                        {
                        c.Status='Planned';
                        cmapmlst.add(c);
                        system.debug(oldcMembers);
                        system.debug('oldcMembers'+oldcMembers); 
                        camdelmap.put(c.id,c.id);                   
                        }       
                        }         
                        if((c.Number_Sent__c==1&&c.Number_Planned__c==null)||(c.Number_Sent__c==1&&c.Number_Planned__c==1))
                        {
                       // if(camdelmap.get(c.id)==null)
                        {
                          //cmapmlst.clear();

                        c.Status='Sent';
                        cmapmlst.add(c);
                        
                        system.debug(oldcMembers);
                        system.debug('oldcMembers'+oldcMembers); 
                        camdelmap.put(c.id,c.id);
                        }                   
                        }  
                        /*
                        if(c.Number_Planned__c==1&&c.Number_Sent__c==1)
                        {
                       // if(camdelmap.get(c.id)==null)
                        {
                        cmapmlst.clear();
                        c.Status='Sent';
                        cmapmlst.add(c);
                        camdelmap.put(c.id,c.id);
                        }
                        
                        
                        }
                        */
                        if(c.Number_Sent__c==null&&c.Number_Planned__c==null)
                        {
                        deletmembers.add(c);                    
                        }
                        }
                        }
                        }
                        
                        }
                        update cmapmlst;
                        delete deletmembers ;
                        
                        }
                        }   
                        
                        
                        }