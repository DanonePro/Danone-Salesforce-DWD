trigger OrderEventTrigger on Order_Event__e (after insert) {
     List<String> OrderNums = New List<String>();
     for(Order_Event__e orEvent: trigger.New){
         if(orEvent.Type__c == 'Shipped') OrderNums.add(orEvent.Order_Number__c);
     }
     List<Order> OrderShipped= [Select Id, Status, OrderNumber from Order where OrderNumber in :OrderNums];
     for(Order o : OrderShipped) o.Status='Shipped';
     if (OrderShipped.size() > 0) Update OrderShipped;
 }