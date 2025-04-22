@isTest
public class EventsTriggerTest {
    
    @isTest
    static void testHandleAfterUpdate() {
        // Step 1: Set up test data
        // Create an event record with a state other than 'Cancelled'
        OrgEventManager__Events__c eventRecord = new OrgEventManager__Events__c(
            Name = 'Test Event',
            OrgEventManager__Event_State__c = 'Active'
        );
        insert eventRecord;
        
        // Create session records related to the event
        OrgEventManager__Session__c session1 = new OrgEventManager__Session__c(
            Name = 'Session 1',
            OrgEventManager__Session_Date__c = Date.today(),
            OrgEventManager__Start_Time__c = '10:00 AM',
            OrgEventManager__End_Time__c = '11:00 AM',
            OrgEventManager__Events__c = eventRecord.Id
        );
        
        OrgEventManager__Session__c session2 = new OrgEventManager__Session__c(
            Name = 'Session 2',
            OrgEventManager__Session_Date__c = Date.today().addDays(1),
            OrgEventManager__Start_Time__c = '12:00 PM',
            OrgEventManager__End_Time__c = '1:00 PM',
            OrgEventManager__Events__c = eventRecord.Id
        );
        insert new List<OrgEventManager__Session__c> { session1, session2 };
        
            Contact contact1 = new Contact(
            LastName = 'Contact1',
            Birthdate = Date.today(),
            OrgEventManager__Gender__c = 'Male',
            Email= 'Contact1@gmail.com',
            RecordTypeId=Label.AttendeeContactRecordTypeId
        ); 
        insert contact1;
        
        Contact contact2 = new Contact(
            LastName = 'Contact2',
            Birthdate = Date.today(),
            OrgEventManager__Gender__c = 'Male',
            Email= 'Contact2@gmail.com',
            RecordTypeId=Label.AttendeeContactRecordTypeId
        );        
        insert contact2;
        
        // Create attendee records related to the sessions
        OrgEventManager__Attendee__c attendee1 = new OrgEventManager__Attendee__c(
            OrgEventManager__Name_of_Attendees__c = contact1.Id,
            OrgEventManager__Status__c = 'Registered',
            OrgEventManager__Session__c = session1.Id
        );
        
        OrgEventManager__Attendee__c attendee2 = new OrgEventManager__Attendee__c(
            OrgEventManager__Name_of_Attendees__c = contact2.Id,
            OrgEventManager__Status__c = 'Registered',
            OrgEventManager__Session__c = session2.Id
        );
        insert new List<OrgEventManager__Attendee__c> { attendee1, attendee2 };
        
        // Step 2: Perform the update to trigger the handler
        Test.startTest();
        eventRecord.OrgEventManager__Event_State__c = 'Cancelled';
        update eventRecord; // This should trigger the logic in the EventsTriggerHandler.
        Test.stopTest();
        
        // Step 3: Verify results
        // Fetch updated attendee records to verify their status is set to 'Cancelled'
        List<OrgEventManager__Attendee__c> updatedAttendees = [
            SELECT OrgEventManager__Status__c
            FROM OrgEventManager__Attendee__c
            WHERE Id IN :new List<Id> { attendee1.Id, attendee2.Id }
        ];
        
        for (OrgEventManager__Attendee__c attendee : updatedAttendees) {
            System.assertEquals('Cancelled', attendee.OrgEventManager__Status__c, 
                'Attendee status should be updated to "Cancelled"');
        }
    }
}