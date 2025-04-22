public class EventsTriggerHandler {
    
    public static void handleAfterUpdate(List<OrgEventManager__Events__c> newEvents, Map<Id, OrgEventManager__Events__c> oldEventMap) {
        List<OrgEventManager__Events__c> cancelledEvents = new List<OrgEventManager__Events__c>();
        
        for (OrgEventManager__Events__c newEvent : newEvents) {
            OrgEventManager__Events__c oldEvent = oldEventMap.get(newEvent.Id);
            
            // Check if Event State changed to 'Cancelled'
            if (newEvent.OrgEventManager__Event_State__c == 'Cancelled' && oldEvent.OrgEventManager__Event_State__c != 'Cancelled') {
                cancelledEvents.add(newEvent);
            }
        }
        
        if (!cancelledEvents.isEmpty()) {
            EventsTriggerHelper.processCancelledEvents(cancelledEvents);
        }
    }
}