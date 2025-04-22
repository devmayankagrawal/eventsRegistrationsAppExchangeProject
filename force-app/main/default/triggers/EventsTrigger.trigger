trigger EventsTrigger on OrgEventManager__Events__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        EventsTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}