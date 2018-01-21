trigger OrderTrigger on Order (after update) {
    List<Order_Event__e> OrdEvents = New List<Order_Event__e>();
    for (Order o: Trigger.new) {
        if(o.Status == 'Placed' && Trigger.oldMap.get(o.Id).Status <> 'Placed'){
           OrdEvents.add(new Order_Event__e(Order_Number__c = o.OrderNumber, Type__c=o.Status));
        }
    }
    if(OrdEvents.size()>0) EventBus.publish(OrdEvents);    	  
}