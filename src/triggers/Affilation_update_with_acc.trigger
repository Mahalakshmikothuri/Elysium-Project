trigger Affilation_update_with_acc on Account (after update) {
                    
                    list<id>accid= new list<id>();
                    Map<id,account> accobj= new map<id,account>();
                    list<npe5__Affiliation__c> affilationlst = new list<npe5__Affiliation__c>();
                    recordtype r=[select id from recordtype where name='Organization' and sobjecttype='account'];
                    for(account c:trigger.new)
                    {
                    
                    account  oldacc = Trigger.oldMap.get(c.Id);
                    if(r.id==c.recordtypeid)
                    {
                    
                    if(c.billingCity!=oldacc.billingCity||c.billingStreet!=oldacc.billingStreet||c.billingState!=oldacc.billingState||c.billingPostalCode!=oldacc.billingPostalCode)
                    {
                    
                    accid.add(c.id);
                    accobj.put(c.id,c);

                    }
                    
                    list<npe5__Affiliation__c> affObj=[select id,Always_Copy_Contact_Preferred__c,Always_Copy_From__c,Phone__c,email__c,Mailing_City__c,Mailing_State__c,
                    Mailing_Street__c,Mailing_Zip__c,npe5__Organization__c from npe5__Affiliation__c  where npe5__Organization__c in :accid];
                    
                    for(npe5__Affiliation__c a:affobj)
                    {
                    if(accobj.get(a.npe5__Organization__c).id!=null&&a.Always_Copy_From__c=='Organization')
                    {
                    //a.phone__c=accobj.get(a.npe5__Contact__c).phone;
                    //a.email__c=accobj.get(a.npe5__Contact__c).email;
                    a.Mailing_City__c=accobj.get(a.npe5__Organization__c).billingCity;
                    a.Mailing_State__c=accobj.get(a.npe5__Organization__c).billingState;
                    a.Mailing_Street__c=accobj.get(a.npe5__Organization__c).billingStreet;
                    a.Mailing_Zip__c=accobj.get(a.npe5__Organization__c).billingPostalcode;
                    
                    affilationlst.add(a);
                    
                    
                    
                    
                    }
                    
                    
                    }
                    update affilationlst ;
                    
                    }
                    }
                    
                    }