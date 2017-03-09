/*
Trigger Name: updateAccountndContactsPledgedTotals
Purpose/Overview: To Update Pledged Totals on Account and Opportunity when amount and stage changes happened on pledged opportunities
Author: SANDEEP KUMAR K
Created Date: 2/2/2017
Test Class Name:       
Change History: 
Date Modified: Developer Name: Section/Page Block Modified/Added: Purpose/Overview of Change
*/
trigger updateAccountndContactsPledgedTotals on Opportunity (before insert,before update,after insert,after update,after delete){
    contact cont = new contact();
    Account acnt = new Account();
    string contId;
    String acntID;
    String priorCntID;
    String PriorAcntID;
    contact priorContact = new contact();
    Account priorAccount=new Account();
    list<Opportunity> lstOppty = new list<Opportunity>();
    list<Opportunity> AccountsLstOppty = new list<Opportunity>();
    map<id,opportunity> updateoptys = new map<id,opportunity>(); 
    decimal opptyAmount=0;
    decimal acontOpptyAmount=0;
    decimal postedContOpptyAmount=0;
    decimal postedAcntOpptyAmount=0;
    decimal askedContOpptyAmount=0;
    integer askedContOpptyCount=0;
    decimal askedContOpptyAmountlastNDays=0;
    integer askedContOpptyCountlastNDays=0;
    integer pledgedOpptyContCount=0;
    integer pledgedOpptyAcntCount=0;
    decimal contLastNDaysAmount=0;
    integer contLastNDaysCount=0;
    decimal acntLastNDaysAmount=0;
    integer acntLastNDaysCount=0;
    decimal askedAcntOpptyAmount=0;
    integer askedAcntOpptyCount=0;
    decimal askedAcntOpptyAmountlastNDays=0;
    integer askedAcntOpptyCountlastNDays=0;
    integer askedAcntOptCountlastNDays=0;
    integer noAskedCntOpptyCount=0;
    integer noAskedAcntOpptyCount=0;
    integer noPledgedCntOpptyCount=0;
    integer noPledgedAcntOpptyCount=0;
    integer noPostedCntOpptyCount=0;
    integer noPostedAcntOpptyCount=0;
    list<campaignMember> lstCmpMembs = new list<campaignMember>();
    list<campaignMember> lstCmpMembstobeUpdated = new list<campaignMember>();
    list<campaignMember> lstCmpMembstobeDeleted = new list<campaignMember>();

    if(trigger.isInsert && trigger.isBefore)
    {
        updateOppty_TriggerHandler.updateOppty(trigger.new);
    }
    if(!trigger.isDelete){
        for(Opportunity objOpp :trigger.new){
            acntID = objOpp.AccountId;
            contId = objOpp.npsp__Primary_Contact__c;
            
            //To Update Prior Account ID and Prior Primary Contact ID
            if(trigger.isBefore && trigger.isUpdate){
                if(trigger.oldmap.get(objOpp.id).AccountID!=null && trigger.oldmap.get(objOpp.id).AccountID!=trigger.newmap.get(objOpp.id).AccountID)
                {
                    objOpp.Account_ID_Prior_Value__c = trigger.oldmap.get(objOpp.id).AccountID;
                    //priorAcntID =trigger.oldmap.get(objOpp.id).AccountID;
                }
                if((trigger.oldmap.get(objOpp.id).npsp__Primary_Contact__c!=null && trigger.newmap.get(objOpp.id).npsp__Primary_Contact__c==null) || trigger.oldmap.get(objOpp.id).npsp__Primary_Contact__c!=null && trigger.oldmap.get(objOpp.id).npsp__Primary_Contact__c!=trigger.newmap.get(objOpp.id).npsp__Primary_Contact__c)
                {
                    objOpp.Primary_Contact_ID_Prior_Value__c = trigger.oldmap.get(objOpp.id).npsp__Primary_Contact__c;
                    //priorCntID = trigger.oldmap.get(objOpp.id).npsp__Primary_Contact__c;
                    
                }
            }
        }
    }
    list<Id> contactIds =new list<Id>();
    ID contacId;
    ID primaryCampaignId;
    contact contct = new contact();
    list<campaignMember> lstCms = new list<campaignMember>();
    list<campaignMember> updateCms = new list<campaignMember>();
    if(trigger.isDelete)
    {
        for(Opportunity op : trigger.old)
        {
            acntID = op.AccountId;
            contId = op.npsp__Primary_Contact__c;
            primaryCampaignId = op.campaignId;
            
            if(op.campaignId!=null && op.AccountId!=null && op.npsp__Primary_Contact__c!=null)
                contacId = op.npsp__Primary_Contact__c;
        }
            if(contacId!=null)
                contct = [select id,AccountID,Account.RecordType.Name from contact where id=:contacId]; 
        if(contct!=null)
            if(contct.Accountid==acntID && contct.Account.RecordType.Name=='Household Account'){
                list<contact> lstconts =[select id,name from contact where accountid=:acntID];
                if(!lstconts.isEmpty()){
                    for(contact c:lstconts)
                        contactIds.add(c.id);
                }
                lstCms=[select id,name,campaignId,Number_Sent__c,Number_Planned__c from campaignMember where campaignId=:primaryCampaignId and contactId in :contactIds];
                if(!lstCms.isEmpty()){
                    for(campaignMember cMemb : lstCms){
                        if(cMemb.Number_Sent__c==1){
                            cMemb.Status ='Sent';
                            lstCmpMembstobeUpdated.add(cMemb);
                        }
                        else if(cMemb.Number_Planned__c==1){
                            cMemb.Status='Planned';
                            lstCmpMembstobeUpdated.add(cMemb);
                        }
                        else{
                            lstCmpMembstobeDeleted.add(cMemb);
                        }
                            
                    }
                }
            }
                
    }
    if(string.isNotBlank(contId))
        cont = [select id,name,Total_Pledged_Gifts__c,Total_Number_of_Pledged_Gifts__c,Total_Pledged_Gifts_Last_N_Days__c,Number_of_Pledged_Gifts_Last_N_Days__c from contact where id=:contId];
    if(string.isNotBlank(acntID))
        acnt = [select id,name,Total_Pledged_Gifts__c,Total_Number_of_Pledged_Gifts__c,Total_Pledged_Gifts_Last_N_Days__c,Number_of_Pledged_Gifts_Last_N_Days__c from account where id=:acntID]; 
    lstOppty = [select id ,CloseDate,name,amount,stageName,AccountId,npsp__Primary_Contact__c from opportunity where npsp__Primary_Contact__c = :contId];
    AccountsLstOppty  =[select id ,CloseDate,name,amount,stageName,AccountId,npsp__Primary_Contact__c from opportunity where AccountID = :acntID];
    
    integer contOpptySize = lstOppty.size();
    integer acntOpptySize = AccountsLstOppty.size();
    
    for(Opportunity Opty: lstOppty)
    {
        if(opty.stageName!='Asked' || opty.stageName!='LOI Submitted' || opty.stageName!='Application Submitted')
            noAskedCntOpptyCount++;
        if(opty.stageName!='Pledged')
            noPledgedCntOpptyCount++;
        if(opty.stageName!='Pledged')
            noPostedCntOpptyCount++;
    }
    for(Opportunity opt :AccountsLstOppty)
    {
        if(opt.stageName!='Asked' || opt.stageName!='LOI Submitted' || opt.stageName!='Application Submitted')
            noAskedAcntOpptyCount++;
        if(opt.stageName!='Pledged')
            noPledgedAcntOpptyCount++;
        if(opt.stageName!='Posted')
            noPostedAcntOpptyCount++;
    }
    if(noAskedCntOpptyCount == contOpptySize){
        cont.Total_Asked_Gifts__c = 0;
        cont.Total_Number_of_Asked_Gifts__c = 0;
        cont.Total_Asked_Gifts_Last_N_Days__c = 0;
        cont.Number_of_Asked_Gifts_Last_N_Days__c = 0;
    }
    if(noAskedAcntOpptyCount == acntOpptySize)
    {
        acnt.Total_Asked_Gifts__c = 0;
        acnt.Total_Number_of_Asked_Gifts__c = 0;
        acnt.Total_Asked_Gifts_Last_N_Days__c = 0;
        acnt.Number_of_Asked_Gifts_Last_N_Days__c = 0;
    }
    
    if(noPledgedCntOpptyCount == contOpptySize)
    {
        cont.Total_Pledged_Gifts__c = 0;
        cont.Total_Number_of_Pledged_Gifts__c = 0;
        cont.Total_Pledged_Gifts_Last_N_Days__c = 0;
        cont.Number_of_Pledged_Gifts_Last_N_Days__c = 0;
    }
    if(noPledgedAcntOpptyCount == acntOpptySize)
    {
        acnt.Total_Pledged_Gifts__c = 0;
        acnt.Total_Number_of_Pledged_Gifts__c = 0;
        acnt.Total_Pledged_Gifts_Last_N_Days__c = 0;
        acnt.Number_of_Pledged_Gifts_Last_N_Days__c = 0;
        acnt.npo02__TotalOppAmount__c=0;
    }
    /*if(noPostedCntOpptyCount == contOpptySize)
    {
        cont.npo02__TotalOppAmount__c=0;
    }
    if(noPostedAcntOpptyCount == acntOpptySize)
    {
        acnt.npo02__TotalOppAmount__c=0;
    }*/
    
    
    
    if(lstOppty.isEmpty()){
        cont.Total_Pledged_Gifts__c = 0;
        cont.Total_Number_of_Pledged_Gifts__c = 0;
        cont.Total_Pledged_Gifts_Last_N_Days__c = 0;
        cont.Number_of_Pledged_Gifts_Last_N_Days__c = 0;
        //cont.npo02__TotalOppAmount__c=0;
        
        cont.Total_Asked_Gifts__c = 0;
        cont.Total_Number_of_Asked_Gifts__c = 0;
        cont.Total_Asked_Gifts_Last_N_Days__c = 0;
        cont.Number_of_Asked_Gifts_Last_N_Days__c = 0;
    }
    if(AccountsLstOppty.isEmpty()){
        acnt.Total_Pledged_Gifts__c = 0;
        acnt.Total_Number_of_Pledged_Gifts__c = 0;
        acnt.Total_Pledged_Gifts_Last_N_Days__c = 0;
        acnt.Number_of_Pledged_Gifts_Last_N_Days__c = 0;
        //acnt.npo02__TotalOppAmount__c=0;
        
        acnt.Total_Asked_Gifts__c = 0;
        acnt.Total_Number_of_Asked_Gifts__c = 0;
        acnt.Total_Asked_Gifts_Last_N_Days__c = 0;
        acnt.Number_of_Asked_Gifts_Last_N_Days__c = 0;
    }
    if(!lstOppty.isEmpty() && lstOppty.size()==1)
    {
        if(lstOppty[0].stageName!='Pledged'){
            cont.Total_Pledged_Gifts__c = 0;
            cont.Total_Number_of_Pledged_Gifts__c = 0;
            cont.Total_Pledged_Gifts_Last_N_Days__c = 0;
            cont.Number_of_Pledged_Gifts_Last_N_Days__c = 0;
            
        }
        //if(lstOppty[0].stageName!='Posted')
           //cont.npo02__TotalOppAmount__c = 0;
        
        if(lstOppty[0].stageName!='Asked' || lstOppty[0].stageName!='LOI Submitted' || lstOppty[0].stageName!='Application Submitted'){
            cont.Total_Asked_Gifts__c = 0;
            cont.Total_Number_of_Asked_Gifts__c = 0;
            cont.Total_Asked_Gifts_Last_N_Days__c = 0;
            cont.Number_of_Asked_Gifts_Last_N_Days__c = 0;  
        }
    }
    if(!AccountsLstOppty.isEmpty() && AccountsLstOppty.size()==1)
    {
        if(AccountsLstOppty[0].stageName!='Pledged'){
            acnt.Total_Pledged_Gifts__c = 0;
            acnt.Total_Number_of_Pledged_Gifts__c = 0;
            acnt.Total_Pledged_Gifts_Last_N_Days__c = 0;
            acnt.Number_of_Pledged_Gifts_Last_N_Days__c = 0;
            
        }
        /*if(AccountsLstOppty[0].stageName!='Posted'){
            acnt.npo02__TotalOppAmount__c = 0;
        }*/
        
        if(AccountsLstOppty[0].stageName!='Asked' || AccountsLstOppty[0].stageName!='LOI Submitted' || AccountsLstOppty[0].stageName!='Application Submitted'){
            acnt.Total_Asked_Gifts__c = 0;
            acnt.Total_Number_of_Asked_Gifts__c = 0;
            acnt.Total_Asked_Gifts_Last_N_Days__c = 0;
            acnt.Number_of_Asked_Gifts_Last_N_Days__c = 0;
        }
    }
    //Add opportunity amount to pledged totals scenario for Contact
    for(Opportunity opty : lstOppty){
       if((opty.stageName=='Pledged' && opty.amount!=null) && (string.isNotBlank(cont.id) && string.isNotBlank(opty.npsp__Primary_Contact__c) && opty.npsp__Primary_Contact__c == cont.id))
       {
            pledgedOpptyContCount = pledgedOpptyContCount+1;
            system.debug('Opportunity count##########'+pledgedOpptyContCount);
            if(opty.Amount!=null)
            opptyAmount = opptyAmount+opty.Amount;
            cont.Total_Pledged_Gifts__c = opptyAmount;
            cont.Total_Number_of_Pledged_Gifts__c = pledgedOpptyContCount;
            //if(date.today().daysBetween(opty.CloseDate)<=365 && date.today().daysBetween(opty.CloseDate)>=0){
            if(opty.CloseDate<date.today() && opty.CloseDate>date.today()-365){
                if(opty.Amount!=null)
                contLastNDaysAmount=contLastNDaysAmount+opty.amount;
                contLastNDaysCount = contLastNDaysCount+1;
                cont.Total_Pledged_Gifts_Last_N_Days__c = contLastNDaysAmount;
                cont.Number_of_Pledged_Gifts_Last_N_Days__c = contLastNDaysCount;
            }
            /*else{
                if(cont.Total_Pledged_Gifts_Last_N_Days__c!=0 && cont.Total_Pledged_Gifts_Last_N_Days__c>0)
                    if(opty.Amount!=null)
                    cont.Total_Pledged_Gifts_Last_N_Days__c = contLastNDaysAmount-opty.amount;
                if(cont.Number_of_Pledged_Gifts_Last_N_Days__c!=0 && cont.Number_of_Pledged_Gifts_Last_N_Days__c>0)
                    cont.Number_of_Pledged_Gifts_Last_N_Days__c = contLastNDaysCount-1;
            }*/
       }
       //To update Total Gifts amount on contact from Posted Opportunities Amount 
       /*if((opty.stageName=='Posted' && opty.amount!=null) && (string.isNotBlank(cont.id) && string.isNotBlank(opty.npsp__Primary_Contact__c) && opty.npsp__Primary_Contact__c == cont.id))
       {
            postedContOpptyAmount = postedContOpptyAmount+opty.amount;
            cont.npo02__TotalOppAmount__c = postedContOpptyAmount;
       }*/
       if((opty.stageName=='Asked' || opty.stageName=='LOI Submitted' || opty.stageName=='Application Submitted') && opty.amount!=null && string.isNotBlank(cont.id) && string.isNotBlank(opty.npsp__Primary_Contact__c) && opty.npsp__Primary_Contact__c == cont.id)
       {
            if(opty.Amount!=null)
            askedContOpptyAmount = askedContOpptyAmount+opty.Amount;
            askedContOpptyCount = askedContOpptyCount+1;
            cont.Total_Asked_Gifts__c = askedContOpptyAmount;
            cont.Total_Number_of_Asked_Gifts__c = askedContOpptyCount;
            //if(date.today().daysBetween(opty.CloseDate)<=365 && date.today().daysBetween(opty.CloseDate)>=0){
            if(opty.CloseDate<date.today() && opty.CloseDate>date.today()-365){ 
                if(opty.Amount!=null)
                askedContOpptyAmountlastNDays = askedContOpptyAmountlastNDays+opty.Amount;
                askedContOpptyCountlastNDays = askedContOpptyCountlastNDays+1;
                cont.Total_Asked_Gifts_Last_N_Days__c = askedContOpptyAmountlastNDays;
                cont.Number_of_Asked_Gifts_Last_N_Days__c = askedContOpptyCountlastNDays;
            }
            /*else{
                if(cont.Total_Asked_Gifts_Last_N_Days__c!=0 && cont.Total_Asked_Gifts_Last_N_Days__c>0)
                if(opty.Amount!=null)    
                    cont.Total_Asked_Gifts_Last_N_Days__c = askedContOpptyAmountlastNDays-Opty.Amount;
                if(cont.Number_of_Asked_Gifts_Last_N_Days__c!=0 && cont.Number_of_Asked_Gifts_Last_N_Days__c>0)
                    cont.Number_of_Asked_Gifts_Last_N_Days__c = askedContOpptyCountlastNDays-1;
            }*/
       }
    }
    //Add opportunity amount to pledged totals scenario for Account
    for(Opportunity acntOpp :AccountsLstOppty){
        if((acntOpp.stageName=='Pledged' && acntOpp.amount!=null) && (string.isNotBlank(acnt.id) && acntOpp.AccountId == acnt.id))
        {
            pledgedOpptyAcntCount = pledgedOpptyAcntCount+1;
            if(acntOpp.Amount!=null)
            acontOpptyAmount = acontOpptyAmount+acntOpp.Amount;
            acnt.Total_Pledged_Gifts__c = acontOpptyAmount;
            acnt.Total_Number_of_Pledged_Gifts__c = pledgedOpptyAcntCount;
            //acnt.Total_Pledged_Gifts_Last_N_Days__c = acontOpptyAmount;
            //acnt.Number_of_Pledged_Gifts_Last_N_Days__c = pledgedOpptyAcntCount;
           //if(date.today().daysBetween(acntOpp.CloseDate)<=365 && date.today().daysBetween(acntOpp.CloseDate)>=0){
            if(acntOpp.CloseDate<date.today() && acntOpp.CloseDate>date.today()-365){   
                if(acntOpp.Amount!=null)
                acntLastNDaysAmount=acntLastNDaysAmount+acntOpp.amount;
                acntLastNDaysCount = acntLastNDaysCount+1;
                acnt.Total_Pledged_Gifts_Last_N_Days__c = acntLastNDaysAmount;
                acnt.Number_of_Pledged_Gifts_Last_N_Days__c = acntLastNDaysCount;
            }
            /*else{
                if(acnt.Total_Pledged_Gifts_Last_N_Days__c!=0 && acnt.Total_Pledged_Gifts_Last_N_Days__c>0)
                    if(acntOpp.amount!=null)
                        acnt.Total_Pledged_Gifts_Last_N_Days__c=acntLastNDaysAmount-acntOpp.amount;
                if(acnt.Number_of_Pledged_Gifts_Last_N_Days__c!=0 && acnt.Number_of_Pledged_Gifts_Last_N_Days__c>0)
                    acnt.Number_of_Pledged_Gifts_Last_N_Days__c = acntLastNDaysCount-1;
            }*/
        }
        /*if((acntOpp.stageName=='Posted' && acntOpp.amount!=null) && (string.isNotBlank(acnt.id) && acntOpp.AccountId == acnt.id))
        {
           postedAcntOpptyAmount = postedAcntOpptyAmount+acntOpp.Amount;
           acnt.npo02__TotalOppAmount__c = postedAcntOpptyAmount;
        }*/
        if((acntOpp.stageName=='Asked' || acntOpp.stageName=='LOI Submitted' || acntOpp.stageName=='Application Submitted'))
        {
            if(acntOpp.Amount!=null)
            askedAcntOpptyAmount = askedAcntOpptyAmount+acntOpp.Amount;
            askedAcntOpptyCount = askedAcntOpptyCount+1;
            acnt.Total_Asked_Gifts__c = askedAcntOpptyAmount;
            acnt.Total_Number_of_Asked_Gifts__c = askedAcntOpptyCount;
            System.debug('Difference of close date and today:'+date.today().daysBetween(acntOpp.CloseDate));
            //if(date.today().daysBetween(acntOpp.CloseDate)<=365 && date.today().daysBetween(acntOpp.CloseDate)>=0){
            if(acntOpp.CloseDate<date.today() && acntOpp.CloseDate>date.today()-365){   
                if(acntOpp.Amount!=null)
                askedAcntOpptyAmountlastNDays = askedAcntOpptyAmountlastNDays+acntOpp.Amount;
                //askedAcntOpptyCountlastNDays = askedAcntOpptyCountlastNDays+1;
                askedAcntOptCountlastNDays = askedAcntOptCountlastNDays+1;
                acnt.Total_Asked_Gifts_Last_N_Days__c = askedAcntOpptyAmountlastNDays;
                //acnt.Number_of_Asked_Gifts_Last_N_Days__c = askedAcntOpptyCountlastNDays;
                acnt.Number_of_Asked_Gifts_Last_N_Days__c = askedAcntOptCountlastNDays;
            }
            /*else{
                if(acnt.Total_Asked_Gifts_Last_N_Days__c!=0 && acnt.Total_Asked_Gifts_Last_N_Days__c>0)
                    if(acntOpp.Amount!=null)
                        acnt.Total_Asked_Gifts_Last_N_Days__c = askedAcntOpptyAmountlastNDays-acntOpp.Amount;
                    if(acnt.Number_of_Asked_Gifts_Last_N_Days__c!=0 && acnt.Number_of_Asked_Gifts_Last_N_Days__c>0)
                        acnt.Number_of_Asked_Gifts_Last_N_Days__c  = askedAcntOptCountlastNDays-1;
            }*/
        }
    }
    if(acnt.id!=null)
        update acnt;
    if(cont.id!=null)
        update cont;
    if(trigger.isAfter && trigger.isUpdate)
    {
        list<ID>  campaignIds = new list<Id>();
        for(Opportunity op: trigger.new){   
            if(trigger.oldmap.get(op.id).AccountID!=null && trigger.oldmap.get(op.id).AccountID!=trigger.newmap.get(op.id).AccountID)
            {
                priorAcntID =trigger.oldmap.get(op.id).AccountID;
            }
            if((trigger.oldmap.get(op.id).npsp__Primary_Contact__c!=null && trigger.newmap.get(op.id).npsp__Primary_Contact__c==null) || trigger.oldmap.get(op.id).npsp__Primary_Contact__c!=null && trigger.oldmap.get(op.id).npsp__Primary_Contact__c!=trigger.newmap.get(op.id).npsp__Primary_Contact__c)
            {
                priorCntID = trigger.oldmap.get(op.id).npsp__Primary_Contact__c;    
            }
            campaignIds.add(op.campaignId);
        }
        
        if(string.isNotBlank(priorCntId))
        {
            list<id> cntIds = new list<Id>();
            priorContact = [select id,LastName,AccountId,Account.recordtype.Name,(select id,Name,npsp__Primary_Contact__c from Opportunities) from contact where id=:priorCntId];
            priorContact.id = priorCntId;
            
            LIST<opportunity> opps =[select id,name from opportunity where npsp__Primary_Contact__c=:priorCntId];
            System.debug('^$^$^$^$ Record Type: '+priorContact.Account.recordtype.Name);
            if(priorContact.Account.recordtype.Name=='Household Account'){
                list<Contact> lstCnts =[select id,name from contact where AccountID=:priorContact.AccountId];
                if(!lstCnts.isEmpty()){
                    for(contact cn :lstCnts)
                        cntIds.add(cn.id);
                }
                lstCmpMembs  = [select id,name,contactId,Number_Planned__c,Number_Sent__c from campaignMember where contactId in :cntIds and campaignId in :campaignIds];
            }
            //priorContact.LastName = priorContact.LastName;
            if(!opps.isEmpty()){
                for(opportunity o:opps){
                        o.id=o.id;
                        o.name = o.name;
                        updateoptys.put(o.id,o);
                    }
            }
            else{
                priorContact.Total_Pledged_Gifts__c = 0;
                priorContact.Total_Number_of_Pledged_Gifts__c = 0;
                priorContact.Total_Pledged_Gifts_Last_N_Days__c = 0;
                priorContact.Number_of_Pledged_Gifts_Last_N_Days__c = 0;
                //priorContact.npo02__TotalOppAmount__c=0;
                
                priorContact.Total_Asked_Gifts__c = 0;
                priorContact.Total_Number_of_Asked_Gifts__c = 0;
                priorContact.Total_Asked_Gifts_Last_N_Days__c = 0;
                priorContact.Number_of_Asked_Gifts_Last_N_Days__c = 0;
            }
            
            if(!lstCmpMembs.isEmpty())
            {
                for(campaignMember cm : lstCmpMembs){
                    if(cm.Number_Sent__c==1){
                        cm.Status ='Sent';
                        lstCmpMembstobeUpdated.add(cm);
                    }
                    else if(cm.Number_Planned__c==1){
                        cm.Status='Planned';
                        lstCmpMembstobeUpdated.add(cm);
                    }
                    else{
                        lstCmpMembstobeDeleted.add(cm);
                    }
                            
                }
            }
        }
        if(string.isNotBlank(priorAcntId)){
            priorAccount = [select id,name,(select id,Name from Opportunities) from Account where id=:priorAcntId];
            priorAccount.id = priorAcntId;
            if(!priorAccount.Opportunities.isEmpty()){
                //priorAccount.Name = priorAccount.Name;
                System.debug('$$$$$$$$$'+priorAccount.Opportunities!=null);
                for(opportunity opt:priorAccount.Opportunities){
                    opt.id=opt.id;
                    opt.name = opt.name;
                    updateoptys.put(opt.id,opt);
                }
            }
            else
            {
                priorAccount.Total_Pledged_Gifts__c = 0;
                priorAccount.Total_Number_of_Pledged_Gifts__c = 0;
                priorAccount.Total_Pledged_Gifts_Last_N_Days__c = 0;
                priorAccount.Number_of_Pledged_Gifts_Last_N_Days__c = 0;
                //priorAccount.npo02__TotalOppAmount__c=0;
                
                priorAccount.Total_Asked_Gifts__c = 0;
                priorAccount.Total_Number_of_Asked_Gifts__c = 0;
                priorAccount.Total_Asked_Gifts_Last_N_Days__c = 0;
                priorAccount.Number_of_Asked_Gifts_Last_N_Days__c = 0;
                
                System.debug('***********'+priorAccount);
            }
            System.debug('***********'+priorAccount);
        }
    }
    if(!updateoptys.isEmpty())
        update updateoptys.values();
    IF(priorContact.id!=null)
        update priorContact;
    If(priorAccount.id!=null)
        Update priorAccount;
    
    if(!lstCmpMembstobeUpdated.isEmpty())
        update LstCmpMembstobeUpdated;
    if(!lstCmpMembstobeDeleted.isEmpty())
        delete lstCmpMembstobeDeleted;
}