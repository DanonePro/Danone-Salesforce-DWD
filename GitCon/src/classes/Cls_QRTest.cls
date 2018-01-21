public class Cls_QRTest {
    public string lbl_1 {get;set;}
    
    public Cls_QRTest(){
        
    }
    
    public PageReference btn_click1(){
        string accid = ApexPages.currentPage().getParameters().get('id');
        Account acc = [Select a.Name, a.Id 
                       From Account a
                       where id =:accid
                       limit 1];
        string returntxt = '';
        if(acc != null){
            map<id, Order> map_order = new map<id, Order>([Select o.TotalAmount, o.OrderNumber, o.Name, o.Id, o.AccountId, Delivery_Date__c 
                                                           From Order o
                                                           where AccountId =:accid]);
            map<id, OrderItem> map_orderLineItem = new map<id, OrderItem>([Select o.UnitPrice, o.TotalPrice, o.SystemModstamp, o.ServiceDate, o.Quantity, o.PricebookEntryId, 
                                                                           o.OriginalOrderItemId, o.OrderItemNumber, o.OrderId, o.ListPrice, o.LastModifiedDate, o.LastModifiedById, 
                                                                           o.IsDeleted, o.Id, o.EndDate, o.Description, o.CreatedDate, o.CreatedById, o.AvailableQuantity 
                                                                           From OrderItem o
                                                                           where o.OrderId in:map_order.keySet()]);
            map<id, list<OrderItem>> map_orderid_LineItems = new map<id, list<OrderItem>>();
            for(OrderItem oi : map_orderLineItem.values()){
                id oid = oi.OrderId;
                list<OrderItem> lst_OI = new list<OrderItem>();
                if(map_orderid_LineItems.get(oid) != null){
                    lst_OI = map_orderid_LineItems.get(oid);
                }else{
                    map_orderid_LineItems.put(oid, lst_OI);
                }
                lst_OI.add(oi);
            }
            
            //000
            returntxt += '000;8711216090007;8717371820008;' + removeNull(acc.name) + ';' + removeNull(acc.Id) + ';\r\n';
            integer i = 0;
            for(id oid : map_order.keySet()){ //order
                Order orderobj = map_order.get(oid);
                //100
                returntxt += '100;'+ (++i) +';ORDERS;D;' + removeNull(orderobj.OrderNumber) + ';' + removeNull(orderobj.Name) + ';'+ removeNull(orderobj.TotalAmount) + ';\r\n';
                //111
                returntxt += '111;;;0;;;;;;;;;;;;\r\n';
                //115
                returntxt += '115;'+ removeNull(orderobj.Delivery_Date__c) +';;;;;;;;;;;;;;\r\n';
                //119
                returntxt += '119;SU;8717371820008;;;;;;;;;;;;;\r\n';
                returntxt += '119;BY;8711216090113;;;;;;;;;;;;;\r\n';
                returntxt += '119;DP;8711216090113;;;;;;;;;;;;;\r\n';
                returntxt += '119;IV;8711216090007;;;;;;;;;;;;;\r\n';
                if(map_orderid_LineItems.get(oid) != null){
                    list<OrderItem> lst_OI = map_orderid_LineItems.get(oid);
                    for(OrderItem oi : lst_OI){ //orderLineItem
                        returntxt += '500;' + removeNull(oi.OrderItemNumber) + ';' + removeNull(oi.Id) + ';'+ removeNull(oi.Quantity) + ';'+ removeNull(oi.UnitPrice) + ';\r\n';
                    }
                }
                
            }
            returntxt = returntxt.removeEnd('\r\n');
        }
        lbl_1 = returntxt;
        Attachment att = new Attachment();
        att.Body =  Blob.valueOf(returntxt);
        att.ContentType = 'text/plain';
        att.ParentId = accid;
        att.Name = 'test_'+  Datetime.now().format('yyyyMMddHHmmssSSS') +'.txt';
        insert att;

       
        return null;
    }
    
    private string removeNull(object obj){
        if(obj == null)
            return '';
        if(obj instanceof Date){
            Date dt = (Date)obj;
            Datetime dtime = Datetime.newInstance(dt.year(), dt.month(), dt.day());
            return dtime.format('yyyyMMdd');
        }else if (obj instanceof Datetime){
            Datetime dtime = (Datetime)obj;
            return dtime.format('yyyyMMddHHmm');
        }
        return string.valueof(obj);
    }
    
    public static string getType(Object o) {
        if(o == null) return '';              // we can't say much about null with our current techniques
        if(o instanceof SObject)            return ((SObject)o).getSObjectType().getDescribe().getName()+''; 
        if(o instanceof Boolean)            return 'Boolean';
        if(o instanceof Id)                 return 'Id';
        if(o instanceof String)             return 'String';
        if(o instanceof Blob)               return 'Blob';
        if(o instanceof Date)               return 'Date';
        if(o instanceof Datetime)           return 'Datetime';
        if(o instanceof Time)               return 'Time';
        if(o instanceof String)             return 'String';
        if(o instanceof Integer)            return 'Integer';
        if(o instanceof Long)               return 'Long';
        if(o instanceof Decimal)            return 'Decimal';  // we can't distinguish between decimal and double
        if(o instanceof Double)             return 'Double';   // we can't distinguish between decimal and double
        if(o instanceof List<object>)       return 'List';
        return 'Object';                    // actually we can't detect maps and sets and maps
    }
}