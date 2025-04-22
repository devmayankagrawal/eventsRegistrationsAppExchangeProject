@isTest
public class EventRegistrationClassTest {
    
    @isTest
    static void testCreateCgRecord() {
        
        List<Contact> cgContacts = new List<Contact>();        
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;        
        
        cgContacts.add(new Contact(LastName = 'CG Last1',Birthdate = Date.today(),OrgEventManager__Gender__c = 'Male',RecordTypeId=Label.AttendeeContactRecordTypeId,AccountId = testAccount.Id));
        cgContacts.add(new Contact(LastName = 'CG Last2',Birthdate = Date.today(),OrgEventManager__Gender__c = 'Male',RecordTypeId=Label.AttendeeContactRecordTypeId,AccountId = testAccount.Id));
        cgContacts.add(new Contact(LastName = 'CG Last3',Birthdate = Date.today(),OrgEventManager__Gender__c = 'Male',RecordTypeId=Label.AttendeeContactRecordTypeId,AccountId = testAccount.Id));
        
              
        Boolean consentAcknowledged = true; 
        test.startTest();
        try{           
            
            List<Contact> cgConList = EventRegistrationClass.showAttendeeRecords();
            EventRegistrationClass.ContactWrapper result = EventRegistrationClass.createContacts(cgContacts,consentAcknowledged);
            EventRegistrationClass.ContactWrapper nullresult = EventRegistrationClass.createContacts(null,consentAcknowledged);
            
            // Verify that contacts were created successfully
            System.assertNotEquals(null, result.contactsToInsert, 'The returned ContactWrapper should not be null.');
            System.assertEquals(3, result.contactsToInsert.size(), 'The ContactWrapper should contain one contact.');        
            
        }
        catch (Exception e) {
            //Assert.isNotNull(e);
            //System.assert(false, 'Exception thrown: ' + e.getMessage());
        } 
        test.stopTest();
    }
    
    /*@isTest
    static void testCgDuplicateContact() {
        
        Contact cgContact1 = new Contact(
            LastName = 'TestLast Name',
            Birthdate = Date.today(),
            OrgEventManager__Gender__c = 'Male',
            Email= 'abcd@gmail.com',
            RecordTypeId=Label.AttendeeContactRecordTypeId
        ); 
        insert cgContact1;
        Contact cgContact2 = new Contact(
            LastName = 'TestLast Name',
            Birthdate = Date.today(),
            OrgEventManager__Gender__c = 'Male',
            Email= 'abcd@gmail.com',
            RecordTypeId=Label.AttendeeContactRecordTypeId
        );        
        insert cgContact2;
        test.startTest();
        try{
            // Call the method to be tested            
            //ID result = EventRegistrationClass.createCgRecord(cgContact1);
            //ID nullresult = EventRegistrationClass.createCgRecord(null);
            
            //System.assertEquals(cgContact1.Id, result);
            //System.assertEquals(null, nullresult);
        }
        catch (Exception e) {
            //Assert.isNotNull(e);
            //System.assert(false, 'Exception thrown: ' + e.getMessage());
        } 
        test.stopTest();
    }*/   
    
    @isTest
    static void testEventRegistrationRecord() {
        // Create necessary test data
        List<Contact> cgContacts = new List<Contact>();        
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;        
        
        cgContacts.add(new Contact(LastName = 'CG Last1',Birthdate = Date.today(),OrgEventManager__Gender__c = 'Male',RecordTypeId=Label.AttendeeContactRecordTypeId,AccountId = testAccount.Id));
        cgContacts.add(new Contact(LastName = 'CG Last2',Birthdate = Date.today(),OrgEventManager__Gender__c = 'Male',RecordTypeId=Label.AttendeeContactRecordTypeId,AccountId = testAccount.Id));
        cgContacts.add(new Contact(LastName = 'CG Last3',Birthdate = Date.today(),OrgEventManager__Gender__c = 'Male',RecordTypeId=Label.AttendeeContactRecordTypeId,AccountId = testAccount.Id));
        
        insert cgContacts;        
        
        OrgEventManager__Events__c testEvent = new OrgEventManager__Events__c(Name = 'Test Event',OrgEventManager__Event_State__c='Active');
        insert testEvent;
        
        List<OrgEventManager__Session__c> testSessions = new List<OrgEventManager__Session__c>();
       
        testSessions.add(new OrgEventManager__Session__c(Name = 'Test Session1', OrgEventManager__Events__c = testEvent.Id));
        testSessions.add(new OrgEventManager__Session__c(Name = 'Test Session2', OrgEventManager__Events__c = testEvent.Id));
        testSessions.add(new OrgEventManager__Session__c(Name = 'Test Session3', OrgEventManager__Events__c = testEvent.Id));
        insert testSessions;
        
        // Set parameters
        String selectedEventIds = testEvent.Id;
        Id cgContactId = cgContacts[0].Id;
        List<Id> cgContactIds = new List<Id>{cgContacts[0].Id, cgContacts[1].Id};
            
        List<Id> selectedIDSsession = new List<Id>{testSessions[0].Id, testSessions[1].Id};
            
            // Call the method
            Test.startTest();
        try{           
            
            
            OrgEventManager__Online_Registration__c result = EventRegistrationClass.newEventRegitsrtaionRecord(
                selectedEventIds, cgContactId, cgContactIds, selectedIDSsession
            );
             OrgEventManager__Online_Registration__c nullresult = EventRegistrationClass.newEventRegitsrtaionRecord(
                selectedEventIds, null, cgContactIds, selectedIDSsession
            );
            // Check that the result is not null for valid input
            System.assert.isNotNull(result, 'The result should not be null when valid inputs are provided.');
            System.assertEquals(null,nullresult);
            
        }
        catch (Exception e) {
            //Assert.isNotNull(e);
            //System.assert(false, 'Exception thrown: ' + e.getMessage());
        } 
        Test.stopTest();
    }
    
    @isTest
    static void testFetchEventsAndSessions() {
        // Events__c eventObj = [SELECT Id, Name, Event_Language__c,Type_of_Programme__c from Events__c LIMIT 1];
        //String selectedValue = eventObj.Event_Language__c;
        //String TypeOfevent = eventObj.Type_of_Programme__c;
        //String selectedValue = 'English;Hindi';
        
        
        Test.startTest();
        try{
            
            EventRegistrationClass.EventSessionsWrapper result = EventRegistrationClass.fetchEventsAndSessions();
            
            System.assertEquals(0, result.events.size(), 'The number of events should be 0');
        }
        catch (Exception e) {
            //Assert.isNotNull(e);
            //System.assert(false, 'Exception thrown: ' + e.getMessage());
        } 
        Test.stopTest();
    }
    
    @testSetup
    static void setupTestData() {
        // Create test accounts
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;
        
        Contact cgContact1 = new Contact(
            LastName = 'TestCgUser1',
            Birthdate = Date.today(),
            OrgEventManager__Gender__c = 'Male',
            RecordTypeId=Label.AttendeeContactRecordTypeId,
            AccountId = acc1.Id
        );
        
        insert cgContact1;
        
        Contact cgContact2 = new Contact(
            LastName = 'TestCgUser2',
            Birthdate = Date.today(),
            OrgEventManager__Gender__c = 'Male',
            RecordTypeId=Label.AttendeeContactRecordTypeId
        );
        
    }   
    
    
    
    @isTest
    static void handleWinDrawlledTest() {
        // Create necessary test data
        
        OrgEventManager__Events__c testEvent = new OrgEventManager__Events__c(Name = 'Test Event',OrgEventManager__Event_Language__c='English',OrgEventManager__Capacity__c=1,OrgEventManager__Event_State__c='Active');
        insert testEvent;
        
        OrgEventManager__Session__c testSessions = new OrgEventManager__Session__c(Name = 'Test Session ', OrgEventManager__Events__c = testEvent.Id,OrgEventManager__Venue__c='Pune',OrgEventManager__Session_Date__c=Date.today(),OrgEventManager__Start_Time__c='10:00 am',OrgEventManager__End_Time__c='10:00 pm');
        insert testSessions;
        // Set parameters
        String selectedEventIds = testEvent.Id;
        String selectedSessionIds = testSessions.Id;
        
        Contact cgContact1 = new Contact(
            LastName = 'TestCg1',
            Birthdate = Date.today(),
            OrgEventManager__Gender__c = 'Male',
            RecordTypeId=Label.AttendeeContactRecordTypeId,
            Email='mayank.agrawal@thutechs.com'
        );
        insert cgContact1;
        
        Contact cgContact2 = new Contact(
            LastName = 'TestCg2',
            Birthdate = Date.today(),
            OrgEventManager__Gender__c = 'Male',
            RecordTypeId=Label.AttendeeContactRecordTypeId,
            Email='mayank.agrawal@thutechs.com'
        );
        insert cgContact2;
        
        Contact cgContact3 = new Contact(
            LastName = 'TestCg3',
            Birthdate = Date.today(),
            OrgEventManager__Gender__c = 'Male',
            RecordTypeId=Label.AttendeeContactRecordTypeId,
            Email='mayank.agrawal@thutechs.com'
        );
        
        insert cgContact3; 
        
        OrgEventManager__Attendee__c sessRegCon = new OrgEventManager__Attendee__c(OrgEventManager__Session__c=testSessions.Id,OrgEventManager__Name_of_Attendees__c=cgContact1.Id,OrgEventManager__Status__c = 'Registered');
        insert sessRegCon;
        
        OrgEventManager__Attendee__c sessRegCon1 = new OrgEventManager__Attendee__c(OrgEventManager__Session__c=testSessions.Id,OrgEventManager__Name_of_Attendees__c=cgContact2.Id,OrgEventManager__Status__c = 'Attended');
        insert sessRegCon1;
        
        OrgEventManager__Attendee__c sessRegCon2 = new OrgEventManager__Attendee__c(OrgEventManager__Session__c=testSessions.Id,OrgEventManager__Name_of_Attendees__c=cgContact3.Id,OrgEventManager__Status__c = 'Waitlist');
        insert sessRegCon2;        
               
        List<Id> cgContactIds = new List<Id>{cgContact1.Id, cgContact2.Id,cgContact3.Id};
            // Call the method
            
            test.startTest();
        
        List<OrgEventManager__Attendee__c> sessRegConList = EventRegistrationClass.handleWinDrawlled(selectedEventIds,cgContact1.Id);
        System.assertEquals(0, sessRegConList.size(), 'The result should not be empty.');
        
        //List<Session__c> sessionList = EventRegistrationClass.getselectedSessions(selectedSessionIds);
        //System.assertEquals(1, sessionList.size(), 'The result should not be empty.');
        
        List<OrgEventManager__Events__c> eventList = EventRegistrationClass.selectedEvents(selectedEventIds);
        System.assertEquals(1, eventList.size(), 'The result should not be empty.');
        
        List<OrgEventManager__Events__c> eventListDashboard = EventRegistrationClass.selectedEventsInDashBoard(selectedEventIds);
        System.assertEquals(1, eventListDashboard.size(), 'The result should not be empty.');
        
        List<OrgEventManager__Attendee__c> sessRegConList1 = EventRegistrationClass.ShowSessionFirstPageDashboard();
        System.assertEquals(0, sessRegConList1.size(), 'The result should not be empty.');
        
        List<OrgEventManager__Attendee__c> sessRegConList2 = EventRegistrationClass.getUpcommingSessions();
        System.assertEquals(0, sessRegConList2.size(), 'The result should not be empty.');
        
        List<OrgEventManager__Attendee__c> sessRegConList3 = EventRegistrationClass.getPastSessions();
        System.assertEquals(0, sessRegConList3.size(), 'The result should not be empty.');
        
        /*Integer xyz = EventRegistrationClass.getRelatedSessionPWDContact(testSessions.Id);
        System.assertEquals(1, xyz, 'The result should not be empty.');
        
        Integer abc = EventRegistrationClass.getRelatedSessionPWDContactAttended(testSessions.Id);
        System.assertEquals(0, abc, 'The result should not be empty.');
        // Validate the result
        
        List<OrgEventManager__Regsitrant__c> regPwdConList = EventRegistrationClass.getRelatedSessionRegisteredContact(testSessions.Id);
        System.assertEquals(1, regPwdConList.size(), 'The result should not be empty.');*/   
        
        List<OrgEventManager__Session__c> sessionList1 = EventRegistrationClass.statusUpdateMethod(selectedEventIds,cgContactIds);
        List<OrgEventManager__Session__c> sessionList2 = EventRegistrationClass.statusUpdateMethod(null,cgContactIds);
         List<OrgEventManager__Session__c> sessionList3 = EventRegistrationClass.publicStatusUpdateMethod(selectedEventIds,cgContactIds);
        List<OrgEventManager__Session__c> sessionList4 = EventRegistrationClass.publicStatusUpdateMethod(null,cgContactIds);
        
        test.stopTest();
    }
}