public class ContactRoless {
            public list<Wrapcon>Wrapconlst{get;set;}
            public ApexPages.StandardController controller;
            public list<ContactRoles__c> lstcnrls{get;set;}
            public list<ContactRoles__c> conrole{get;set;}
            public string oppID{get;set;}
            public string names{get;set;}
            
            public ContactRoless(ApexPages.StandardController con) {
            
            con=controller;
            
            lstcnrls = new list<ContactRoles__c>();
            
            oppID=apexpages.currentpage().getparameters().get('oppid');
             conrole=[select id,Contact__c,Opportunity__c,Primary__c,Role__c,name,Contact__r.lastname from ContactRoles__c where Opportunity__c=:oppId];
            system.debug('oppid'+oppid);
            
            Wrapconlst= new List<Wrapcon>();
            if(conrole.size()==null)
            {
                        conrole=new list<ContactRoles__c>();

            for(integer i=0;i<3;i++)
            {
            Wrapconlst.add(new Wrapcon(true,new ContactRoles__c())); 
            }  
            system.debug('success');
            }
            else{
            
            
            for(integer i=0;i<3;i++)
            {
            Wrapconlst.add(new Wrapcon(true,conrole[i])); 
            
            
            }
            }
            }
            public pagereference dosave()
            {
            for(Wrapcon wrp:Wrapconlst)
            {
            ContactRoles__c  cr= new ContactRoles__c(); 
            if(wrp.conrls.Contact__c!=null)
            names= string.valueof(wrp.conrls.Contact__r.lastname);
            cr.Name=names;
            cr.Contact__c = wrp.conrls.Contact__c;
            cr.Opportunity__c = oppID;
            cr.Role__c = wrp.conrls.Role__c ;
            cr.Primary__c=wrp.conrls.Primary__c;
            conrole.add(cr);
            }
            if(conrole.size()!=0)
            {
            
            upsert conrole;
            }
            
            return null;
            }
            
            
            public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('1','1')); 
        options.add(new SelectOption('2','2')); 
        options.add(new SelectOption('3','3'));
         return options; 
    }
            
            
            public class Wrapcon{
            //public selectRadio Rdio{get;set;}
            public boolean checked{get;set;}
            public ContactRoles__c conrls{get;set;}
            public Wrapcon(boolean checked,ContactRoles__c conrls) //selectRadio Rdio
            {
            this.checked= checked;
            this.conrls = conrls;
            
            }
            
            }
            
            public string primaryconid{get;set;}
            public pagereference selectcon()
            {
            
            system.debug(primaryconid);
            return null;
            }
            
            }