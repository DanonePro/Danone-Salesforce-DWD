public class Weber_LtngOrderEditCtrl {
    public Weber_LtngOrderEditCtrl(){
        
    }
    
    @AuraEnabled
    public static list<DataStructs> AddNewCol(string lst_oldDS1){
        system.debug('lst_oldDS1::::::' + lst_oldDS1);
        list<DataStructs> lst_oldDS = (list<DataStructs>)Json.deserialize(lst_oldDS1, list<DataStructs>.class);
        try{
            for(DataStructs dsobj : lst_oldDS){
                list<delivery> lst_delivery = dsobj.lst_delivery;

                delivery dliv = new delivery();
                dliv.Qty = 0;
                dliv.discount = 0;
                dliv.Price = dliv.Qty * ((100 - dliv.discount) / 100) * dsobj.UnitPrice;
                dliv.isDel = false;
                lst_delivery.add(dliv);
            }
            system.debug('lst_oldDS2::::::' + lst_oldDS);
        }catch(Exception ex){
            system.debug('Exception::::::' + ex.getMessage());
        }
        
        return lst_oldDS;
    }
    
    @AuraEnabled
    public static list<DataStructs> getlst1(){
        list<DataStructs> lst1 = new  list<DataStructs>();
        DataStructs ds = new DataStructs();
        ds.newXmas = 'productname1';
        ds.itemN = 123;
        ds.DescStr = 'Grill A';
        ds.TgtQty = 50;
        ds.TgtPrice = 50000;
        ds.halfTgtQty = 25;
        ds.halfTgtPrice = 25000;
        ds.UnitPrice = ds.TgtPrice/ds.TgtQty;
        lst1.add(ds);
        
        DataStructs ds2 = new DataStructs();
        ds2.newXmas = 'productname2';
        ds2.itemN = 465;
        ds2.DescStr = 'Grill B';
        ds2.TgtQty = 20;
        ds2.TgtPrice = 30000;
        ds2.halfTgtQty = 10;
        ds2.halfTgtPrice = 15000;
        ds2.UnitPrice = ds2.TgtPrice/ds2.TgtQty;
        lst1.add(ds2);
        
        DataStructs ds3 = new DataStructs();
        ds3.newXmas = 'productname3';
        ds3.itemN = 789;
        ds3.DescStr = 'Grill C';
        ds3.TgtQty = 40;
        ds3.TgtPrice = 40000;
        ds3.halfTgtQty = 20;
        ds3.halfTgtPrice = 20000;
        ds3.UnitPrice = ds3.TgtPrice/ds3.TgtQty;
        lst1.add(ds3);
        
        DataStructs ds4 = new DataStructs();
        ds4.newXmas = 'productname4';
        ds4.itemN = 1011;
        ds4.DescStr = 'Grill D';
        ds4.TgtQty = 10;
        ds4.TgtPrice = 20000;
        ds4.halfTgtQty = 5;
        ds4.halfTgtPrice = 10000;
        ds4.UnitPrice = ds4.TgtPrice/ds4.TgtQty;
        lst1.add(ds4);
        
        return lst1;
    }
    
    public class DataStructs{
        @AuraEnabled 
        public String newXmas{get;set;}
        @AuraEnabled 
        public Integer itemN{get;set;}
        @AuraEnabled 
        public String DescStr{get;set;}
        @AuraEnabled 
        public Integer TgtQty{get;set;}
        @AuraEnabled 
        public Decimal TgtPrice{get;set;}
        @AuraEnabled 
        public Integer halfTgtQty{get;set;}
        @AuraEnabled 
        public Decimal halfTgtPrice{get;set;}
        
        
        @AuraEnabled 
        public Decimal UnitPrice{get;set;}
        @AuraEnabled 
        public list<delivery> lst_delivery {get;set;}
        
        public DataStructs(){
            if(lst_delivery == null){
                lst_delivery = new list<delivery>();
            }
                
        }
    }
    
    public class delivery{
        @AuraEnabled 
        public date dliDate {get;set;}
        @AuraEnabled 
        public Integer Qty{get;set;}
        @AuraEnabled 
        public Decimal discount{get;set;}
        @AuraEnabled 
        public Decimal Price{get;set;}
        @AuraEnabled 
        public boolean isDel{get;set;}
    }
}