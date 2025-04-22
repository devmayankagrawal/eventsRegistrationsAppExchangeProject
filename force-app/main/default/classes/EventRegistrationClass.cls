public without sharing class EventRegistrationClass {
    
    public class EventSessionsWrapper {
        @AuraEnabled public List<OrgEventManager__Events__c> events;
        @AuraEnabled public List<Integer> sessionCounts;
        
        public EventSessionsWrapper(List<OrgEventManager__Events__c> events, List<Integer> sessionCounts) {
            this.events = events;
            this.sessionCounts = sessionCounts;
        }
    }
    
    @AuraEnabled
    public static EventSessionsWrapper fetchEventsAndSessions() {
        
        //List<String> listOfLanguages = selectedLanguageValue.split(';');
        //List<String> listOfPrograms = typeOfProgram.split(';');
        Date today = Date.today();
    
        // Ensure the user has access to the Events__c and Sessions__c objects and fields
        if (!Schema.sObjectType.OrgEventManager__Events__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Events.');
        }
    
        // Ensure field-level security checks for Events__c fields
        if (!Schema.sObjectType.OrgEventManager__Events__c.fields.Name.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_Language__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Waiting_List__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_State__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Closing_Date_of_Registration__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Capacity__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Waitlist_Number_Capacity__c.isAccessible()) {
            throw new AuraHandledException('Insufficient field-level security permissions for Events.');
        }
    
        // Ensure the user has access to the child object Sessions__c and its fields
        if (!Schema.sObjectType.OrgEventManager__Session__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.Name.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Session_Date__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__End_Time__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Start_Time__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Venue__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Remarks__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Session_Mode__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Total_Registered_Attendee__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Total_Waitlisted_Attendee__c.isAccessible()) {
            throw new AuraHandledException('Insufficient field-level security permissions for Sessions.');
        }
    
         // Start constructing the query
        String query = 'SELECT Id, Name, OrgEventManager__Event_Language__c, OrgEventManager__Waiting_List__c, OrgEventManager__Event_State__c, OrgEventManager__Closing_Date_of_Registration__c, OrgEventManager__Capacity__c, OrgEventManager__Waitlist_Number_Capacity__c, ' +
                       '(SELECT Id, Name,OrgEventManager__Session_Mode__c, OrgEventManager__Session_Date__c,OrgEventManager__Date_of_session__c, OrgEventManager__End_Time__c, OrgEventManager__Start_Time__c, OrgEventManager__Venue__c, OrgEventManager__Remarks__c, OrgEventManager__Total_Registered_Attendee__c, OrgEventManager__Total_Waitlisted_Attendee__c ' +
                       ' FROM OrgEventManager__Sessions__r ORDER BY OrgEventManager__Session_Date__c ASC) ' +
                       'FROM OrgEventManager__Events__c WHERE OrgEventManager__Closing_Date_of_Registration__c >= :today';
                       
        /*Boolean hasPreviousCondition = false;

        // Handle language filter with proper sanitization
        if (!listOfLanguages.isEmpty()) {
            // Sanitize the list items to prevent injection
            for (Integer i = 0; i < listOfLanguages.size(); i++) {
                listOfLanguages[i] = String.escapeSingleQuotes(listOfLanguages[i]);
            }

            query += ' AND OrgEventManager__Event_Language__c INCLUDES (\'' + String.join(listOfLanguages, '\',\'') + '\')';
            hasPreviousCondition = true;
        }*/

        

        // Add ordering clause
        //query += ' ORDER BY OrgEventManager__Type_of_Programme__c';

        // Perform the query
        List<OrgEventManager__Events__c> events = Database.query(query);

        // List to hold the count of sessions for each event
        List<Integer> sessionCounts = new List<Integer>();
    
        // Iterate through each event to count the number of sessions
        for (OrgEventManager__Events__c event : events) {
            Integer sessionCount = event.OrgEventManager__Sessions__r.size();
            sessionCounts.add(sessionCount);
        }
    
        // Create an instance of the wrapper class and return it
        return new EventSessionsWrapper(events, sessionCounts);
    }

    @AuraEnabled(cacheable=true)
    public static List<OrgEventManager__Events__c> selectedEvents(String SelectedValue1){        
        
    // Ensure the user has access to read the Events__c object
    if (!Schema.sObjectType.OrgEventManager__Events__c.isAccessible()) {
        throw new AuraHandledException('Insufficient permissions to access Events.');
    }

    // Ensure the user has access to read the fields used in the query
    if (!Schema.sObjectType.OrgEventManager__Events__c.fields.Name.isAccessible() ||
        !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_Language__c.isAccessible()) {
        throw new AuraHandledException('Insufficient field-level security permissions.');
    }

    // Ensure the user has access to the child object Sessions__c and its fields
    if (!Schema.sObjectType.OrgEventManager__Session__c.isAccessible() ||
        !Schema.sObjectType.OrgEventManager__Session__c.fields.Name.isAccessible() ||
        !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Remarks__c.isAccessible() ||
        !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__End_Time__c.isAccessible() ||
        !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Start_Time__c.isAccessible() ||
        !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Session_Date__c.isAccessible() ||
        !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Session_Mode__c.isAccessible() ||
        !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Venue__c.isAccessible()) {
        throw new AuraHandledException('Insufficient field-level security permissions for Sessions.');
    }        
        
        List<Id> listStates = SelectedValue1.split(';');     
        
        String query1 = 'SELECT Name, OrgEventManager__Event_Language__c , (SELECT Name,OrgEventManager__Session_Mode__c,OrgEventManager__Remarks__c, OrgEventManager__End_Time__c, OrgEventManager__Start_Time__c, OrgEventManager__Session_Date__c,OrgEventManager__Date_of_session__c,OrgEventManager__Venue__c from OrgEventManager__Sessions__r) FROM OrgEventManager__Events__c WHERE ';
        
        if (listStates.size() > 0) {
            query1 += 'Id IN :listStates';
        }     
        
        
        List<OrgEventManager__Events__c> listarray = Database.query(query1);
        
        return listarray;
    }

    @AuraEnabled
    public static List<Contact> showAttendeeRecords(){
        try {
            // Check if the user has access to Event_Registered_Contact__c and Contact objects
            if (!Schema.sObjectType.OrgEventManager__Event_Registered_Contact__c.isAccessible() ||
            !Schema.sObjectType.Contact.isAccessible()) {
            throw new AuraHandledException('Access to one or more objects is denied.');
        }

        // Check if the user has access to the necessary fields on Event_Registered_Contact__c and Contact objects
        if (!Schema.sObjectType.OrgEventManager__Event_Registered_Contact__c.fields.OrgEventManager__Contact__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Event_Registered_Contact__c.fields.OrgEventManager__Event_Registration__c.isAccessible() ||
            !Schema.sObjectType.Contact.fields.Name.isAccessible() ||
            !Schema.sObjectType.Contact.fields.RecordTypeId.isAccessible() ||
            !Schema.sObjectType.Contact.fields.Email.isAccessible() ||
            !Schema.sObjectType.Contact.fields.Birthdate.isAccessible()) {
            throw new AuraHandledException('Access to one or more fields is denied.');
        }

            String currentUserEmail = UserInfo.getUserEmail();

            // Query Event_Registered_Contact__c records based on the current user's email
            List<OrgEventManager__Event_Registered_Contact__c> eventContacts = [SELECT Id, OrgEventManager__Contact__r.Id, OrgEventManager__Contact__r.Name, OrgEventManager__Contact__r.RecordType.Name, OrgEventManager__Contact__r.Email,OrgEventManager__Contact__r.Birthdate,OrgEventManager__Contact__r.OrgEventManager__Age__c, OrgEventManager__Contact__r.OrgEventManager__Gender__c
                                                     FROM OrgEventManager__Event_Registered_Contact__c
                                                     WHERE OrgEventManager__Contact__r.RecordTypeId =:Label.AttendeeContactRecordTypeId AND OrgEventManager__Event_Registration__r.Email__c = :currentUserEmail ];
    
            // Use a Set to store unique Contact IDs
            Set<Id> uniqueContactIds = new Set<Id>();
            for (OrgEventManager__Event_Registered_Contact__c eventContact : eventContacts) {
                uniqueContactIds.add(eventContact.OrgEventManager__Contact__r.Id);
            }
    
            // Query unique contacts using the unique Contact IDs
            List<Contact> uniqueContacts = [SELECT Id, Name, RecordType.Name, Email,Birthdate,OrgEventManager__Gender__c,OrgEventManager__Age__c
                                            FROM Contact
                                            WHERE Id IN :uniqueContactIds];
    
            // Return the list of unique contacts
            return uniqueContacts;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
   

    public class ContactWrapper {
        @AuraEnabled public List<Contact> contactsToInsert { get; set; }
    
        public ContactWrapper(List<Contact> toInsert) {
            this.contactsToInsert = toInsert;
        }
    }

    @AuraEnabled
    public static ContactWrapper createContacts(List<Contact> contactList,Boolean consentAcknowledged) {
        try {
             // Handle null or empty contact list gracefully
            if (contactList == null || contactList.isEmpty()) {
                System.debug('No contacts provided to insert.');
                return new ContactWrapper(new List<Contact>()); // Return an empty wrapper
            }           

             // Log received data for debugging
             System.debug('Received contact list====>' + contactList);

            // Check user permissions for creating contacts
            if (!Schema.sObjectType.Contact.isCreateable()) {
                throw new AuraHandledException('You do not have permissions to create contacts.');
            }

             
                // Ensure field-level security checks for the fields being used
                if (!Schema.sObjectType.Contact.fields.Name.isAccessible() ||
                !Schema.sObjectType.Contact.fields.FirstName.isAccessible() ||
                !Schema.sObjectType.Contact.fields.LastName.isAccessible() ||
                !Schema.sObjectType.Contact.fields.MobilePhone.isAccessible() ||
                !Schema.sObjectType.Contact.fields.OrgEventManager__Age__c.isAccessible() ||
                !Schema.sObjectType.Contact.fields.OrgEventManager__Gender__c.isAccessible() ||
                !Schema.sObjectType.Contact.fields.Email.isAccessible() ||
                !Schema.sObjectType.Contact.fields.OrgEventManager__Country__c.isAccessible() ||
                !Schema.sObjectType.Contact.fields.OrgEventManager__Postal_Code1__c.isAccessible() ||
                !Schema.sObjectType.Contact.fields.OrgEventManager__Consent_Checkbox__c.isAccessible() ||
                !Schema.sObjectType.Contact.fields.RecordTypeId.isAccessible() ||
                !Schema.sObjectType.Contact.fields.OrgEventManager__Attendee_Event_Registration_Form__c.isAccessible()) {
                throw new AuraHandledException('Insufficient field-level security permissions for Contact fields.');
            }
            // Process and update contact list
            for (Contact c : contactList) {
                c.RecordTypeId = Label.AttendeeContactRecordTypeId;
                c.OrgEventManager__Consent_Checkbox__c = consentAcknowledged;
                c.OrgEventManager__Attendee_Event_Registration_Form__c = true;
            }
            
            // Insert the contacts
            insert contactList;

            // Return the wrapper object with inserted contacts
            return new ContactWrapper(contactList);

        } catch (Exception e) {
            throw new AuraHandledException('Error while creating contacts: ' + e.getMessage());
        }
    }

    //Wrapper class for createContacts method
    /*public class ContactWrapper {
        @AuraEnabled public List<Contact> contactsToInsert { get; set; }
        @AuraEnabled public List<Contact> contactsToUpdate { get; set; }
    
        public ContactWrapper(List<Contact> toInsert, List<Contact> toUpdate) {
            this.contactsToInsert = toInsert;
            this.contactsToUpdate = toUpdate;
        }
    }
    
    //createContacts method is used to update the existing contact with same email address filled from form or 
    //else to insert the new contact from form and used to send duplicate contact email. 
    @AuraEnabled
    public static ContactWrapper createContacts(List<Contact> contactList, Boolean consentAcknowledged) {
        try {
            if (contactList == null || contactList.isEmpty()) {
                throw new AuraHandledException('No contacts to insert.');
            }

            System.debug('Received contact list====>' + contactList);

            // Extract unique email addresses from input
            Set<String> emailSet = new Set<String>();
            for (Contact c : contactList) {
                if (!String.isEmpty(c.Email)) {
                    emailSet.add(c.Email.toLowerCase()); // Standardize email case
                }
            }

            // Query existing contacts with matching emails
            List<Contact> existingContacts = new List<Contact>();
            if (!emailSet.isEmpty()) {
                existingContacts = [
                    SELECT Id, Email, LastName, MobilePhone, OrgEventManager__Age__c, OrgEventManager__Gender__c,
                        OrgEventManager__Country__c, OrgEventManager__Postal_Code1__c, RecordTypeId, RecordType.Name, Name
                    FROM Contact
                    WHERE Email IN :emailSet AND RecordTypeId = :Label.AttendeeContactRecordTypeId
                    ORDER BY LastModifiedDate DESC
                ];
            }

            System.debug('Existing Contacts: ' + existingContacts);

            // Check for duplicate emails
            Map<String, List<Contact>> emailToContactsMap = new Map<String, List<Contact>>();
            for (Contact c : existingContacts) {
                String emailKey = c.Email.toLowerCase();
                if (!emailToContactsMap.containsKey(emailKey)) {
                    emailToContactsMap.put(emailKey, new List<Contact>());
                }
                emailToContactsMap.get(emailKey).add(c);
            }

            // Separate lists for update and insert
            List<Contact> contactsToUpdate = new List<Contact>();
            List<Contact> contactsToInsert = new List<Contact>();
            Set<String> duplicateEmails = new Set<String>();

            for (Contact inputContact : contactList) {
                inputContact.RecordTypeId = Label.AttendeeContactRecordTypeId;
                inputContact.OrgEventManager__Consent_Checkbox__c = consentAcknowledged;

                String emailKey = inputContact.Email.toLowerCase();
                if (emailToContactsMap.containsKey(emailKey)) {
                    // Update the most recent contact
                    List<Contact> duplicates = emailToContactsMap.get(emailKey);
                    Contact latestContact = duplicates[0];

                    latestContact.LastName = inputContact.LastName;
                    latestContact.MobilePhone = inputContact.MobilePhone;
                    latestContact.OrgEventManager__Age__c = inputContact.OrgEventManager__Age__c;
                    latestContact.OrgEventManager__Gender__c = inputContact.OrgEventManager__Gender__c;
                    latestContact.OrgEventManager__Country__c = inputContact.OrgEventManager__Country__c;
                    latestContact.OrgEventManager__Postal_Code1__c = inputContact.OrgEventManager__Postal_Code1__c;

                    contactsToUpdate.add(latestContact);

                    // Collect emails with duplicates
                    if (duplicates.size() > 1) {
                        duplicateEmails.add(emailKey);
                    }
                } else {
                    // Insert new contact
                    inputContact.OrgEventManager__Attendee_Event_Registration_Form__c = true;
                    contactsToInsert.add(inputContact);
                }
            }

            // Perform DML operations
            if (!contactsToUpdate.isEmpty()) update contactsToUpdate;
            if (!contactsToInsert.isEmpty()) insert contactsToInsert;

            // Re-query updated contacts for duplicates
            if (!duplicateEmails.isEmpty()) {
                List<Contact> updatedDuplicates = [
                    SELECT Id, Email, LastName, MobilePhone, OrgEventManager__Age__c, OrgEventManager__Gender__c,
                        OrgEventManager__Country__c, OrgEventManager__Postal_Code1__c, RecordTypeId, RecordType.Name, Name
                    FROM Contact
                    WHERE Email IN :duplicateEmails AND RecordTypeId = :Label.AttendeeContactRecordTypeId
                    ORDER BY LastModifiedDate DESC
                ];

                // Send email with updated duplicate information
                sendDuplicateCgContactEmail(updatedDuplicates);
            }

            System.debug('Inserted Contacts: ' + contactsToInsert.size());
            System.debug('Updated Contacts: ' + contactsToUpdate.size());

            // Return the wrapper object
            return new ContactWrapper(contactsToInsert, contactsToUpdate);

        } catch (Exception e) {
            throw new AuraHandledException('Error while processing contacts: ' + e.getMessage());
        }
    }*/


    

    /*@AuraEnabled
    public static Id createCgRecord(Contact conObj) {
    try {
        
       // If conObj is null, return null immediately
       if (conObj != null && String.isNotBlank(conObj.LastName) && conObj.Email != null) {
        
    
            // Ensure CRUD and FLS permissions on the Contact object before processing
            if (!Schema.sObjectType.Contact.isAccessible() || 
                !Schema.sObjectType.Contact.isUpdateable() || 
                !Schema.sObjectType.Contact.isCreateable()) {
                throw new AuraHandledException('You do not have permission to access, update, or create Contacts.');
            }
            System.debug('Checking Contact CRUD permissions');
            
            // Ensure field-level security checks for the fields being used
            if (!Schema.sObjectType.Contact.fields.AccountId.isAccessible() ||
                !Schema.sObjectType.Contact.fields.Name.isAccessible() ||
                !Schema.sObjectType.Contact.fields.FirstName.isAccessible() ||
                !Schema.sObjectType.Contact.fields.LastName.isAccessible() ||
                !Schema.sObjectType.Contact.fields.Birthdate.isAccessible() ||
                !Schema.sObjectType.Contact.fields.Email.isAccessible() ||
                !Schema.sObjectType.Contact.fields.RecordTypeId.isAccessible() ||
                !Schema.sObjectType.Contact.fields.OrgEventManager__Attendee_Event_Registration_Form__c.isAccessible()) {
                throw new AuraHandledException('Insufficient field-level security permissions for Contact fields.');
            }

            System.debug('Checking FLS for fields');           
            
            // Use bound variables for dynamic SOQL query
            List<Contact> CgContactList = [SELECT Id, AccountId, Name, Birthdate, RecordType.Name 
                                            FROM Contact 
                                            WHERE RecordTypeId = :Label.AttendeeContactRecordTypeId 
                                            AND Email = :conObj.Email 
                                            ORDER BY CreatedDate DESC];

            if (CgContactList.size() >= 1) {
                Contact CgExistingContact = CgContactList[0];

                
                conObj.Id = CgExistingContact.Id; // Set the Id to ensure update on the existing record
                update conObj; // Update conObj directly
                system.debug('Update Attende Contact='+conObj.Id);
                sendDuplicateCgContactEmail(CgContactList);
                //system.debug('send DuplicateCg Contact Email=======');
            } else {
                
                // Create new contact             
                conObj.RecordTypeId = Label.AttendeeContactRecordTypeId; // Set the record type
                conObj.OrgEventManager__Attendee_Event_Registration_Form__c = true;
                insert conObj;
            }

            return conObj.Id;
       } else{
        return null;
       }
       
    } catch (AuraHandledException e) {
        System.debug('Exception message: ' + e.getMessage());
        throw new AuraHandledException(e.getMessage());
    } 
}


    @AuraEnabled
    public static void sendDuplicateCgContactEmail(List<Contact> contactList){
        try {

            System.debug('contactList:::'+contactList);

                if (contactList.size() > 1) {
                    
                   // String duplicateContacts = 'Duplicate contacts exist with the same NRIC number:\n\n' +
                                               // 'Contact ID          Contact Name         Contact Record Type         Contact NRIC No.\n';
                        String emailBody = '<p>Duplicate contacts exist with the same email address:</p>';
                        emailBody += '<table border="1">';
                        emailBody += '<thead><tr><th>Contact ID</th><th>Contact Name</th><th>Contact Record Type</th><th>Email</th><th>Age</th></tr></thead>';
                        emailBody += '<tbody>';                   

                    for (Contact contact : contactList) {
                        //String formattedDate = DateTime.newInstance(contact.Birthdate, Time.newInstance(0, 0, 0, 0)).format('dd/MM/yyyy');
                        //duplicateContacts += contact.Id + '\n';
                         //duplicateContacts += contact.Id + '       ' + contact.Name + '       ' + contact.Record_Typeformula__c + '       ' + contact.NRIC__c + '\n';
                          emailBody += '<tr>';
                            emailBody += '<td><a href="' + label.contactBaseUrl + contact.Id + '/view">' + contact.Id + '</a></td>';
                            emailBody += '<td>' + contact.Name + '</td>';
                            emailBody += '<td>' + contact.RecordType.Name + '</td>';
                            //emailBody += '<td>' + contact.NRIC__c + '</td>';
                            emailBody += '<td>' + contact.Email + '</td>';
                            emailBody += '<td>' + contact.OrgEventManager__Age__c + '</td>';
                            emailBody += '</tr>';
                    }                   

                emailBody += '</tbody></table>';

                System.debug('emailBody::::'+emailBody);
               
                String contactEmailAddress = Label.EventRegistrationEmail;
                System.debug('EventRegistrationEmail Label: ' + contactEmailAddress);
                if (String.isBlank(contactEmailAddress)) {
                    throw new AuraHandledException('EventRegistrationEmail label is blank');
                }

                // Split the email addresses into a list
                List<String> emailAddresses = contactEmailAddress.split(',');
                System.debug('Email addresses: ' + emailAddresses);

                List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>(); 

                if (!emailAddresses.isEmpty()) {                            
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                
                mail.setToAddresses(emailAddresses);// Set all email addresses  
                mail.setSubject('Duplicate Attendee Identified - Event Registration Form');              
                mail.setHTMLBody(emailBody);     
                mail.setOrgWideEmailAddressId(label.orgWideEmailAddressLabel);
                //mail.setSenderDisplayName('Event Registration Form');
                mailList.add(mail);
                } else {
                    throw new AuraHandledException('No valid email addresses found');
                }

                if(!mailList.isEmpty()){
                    Messaging.sendEmail(mailList);
                }   else {
                    System.debug('No emails sent as mailList is empty');
                }
                
            }
        } catch (Exception e) {
            System.debug('Email Exception message: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }*/

   

    @AuraEnabled
    public static OrgEventManager__Online_Registration__c newEventRegitsrtaionRecord(String selectedEventIds, Id cgContactId, List<Id> cgContactIds, List <Id> selectedIDSsession) {
        try {           
            // Check object-level and field-level security for Online_Registration__c
            if (!Schema.sObjectType.OrgEventManager__Online_Registration__c.isCreateable()) {
                throw new AuraHandledException('Insufficient permissions to create Online_Registration__c.');
            }

            // Check object-level and field-level security for Event_Registration__c
            if (!Schema.sObjectType.OrgEventManager__Event_Registration__c.isCreateable() || 
                !Schema.sObjectType.OrgEventManager__Event_Registration__c.fields.OrgEventManager__Contact__c.isCreateable() || 
                !Schema.sObjectType.OrgEventManager__Event_Registration__c.fields.OrgEventManager__Event__c.isCreateable() ||
                !Schema.sObjectType.OrgEventManager__Event_Registration__c.fields.OrgEventManager__Online_Registration__c.isCreateable()) {
                throw new AuraHandledException('Insufficient permissions to create Event_Registration__c or related fields.');
            }

            // Check object-level and field-level security for Event_Registered_Contact__c
            if (!Schema.sObjectType.OrgEventManager__Event_Registered_Contact__c.isCreateable() || 
                !Schema.sObjectType.OrgEventManager__Event_Registered_Contact__c.fields.OrgEventManager__Event_Registration__c.isCreateable() || 
                !Schema.sObjectType.OrgEventManager__Event_Registered_Contact__c.fields.OrgEventManager__Contact__c.isCreateable()) {
                throw new AuraHandledException('Insufficient permissions to create Event_Registered_Contact__c or related fields.');
            }

            // Check object-level and field-level security for Attendee__c
            if (!Schema.sObjectType.OrgEventManager__Attendee__c.isCreateable() || 
                !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Session__c.isCreateable() || 
                !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Name_of_Attendees__c.isCreateable() ) {
                throw new AuraHandledException('Insufficient permissions to create Attendee__c or related fields.');
            }          

             // Check if the user has access to Contact,Events and Session__c objects
             if (!Schema.sObjectType.OrgEventManager__Session__c.isAccessible() ||
             !Schema.sObjectType.Contact.isAccessible() ||
             !Schema.sObjectType.OrgEventManager__Events__c.isAccessible()) {
             throw new AuraHandledException('Access to the object is denied.');
            }
            
            if (selectedEventIds != null && cgContactId != null && !cgContactIds.isEmpty() && !selectedIDSsession.isEmpty()) {
                
                List<Id> allContactIds = new List<Id>(cgContactIds);                

                List<String> eventIdStrings = selectedEventIds.split(',');     
                
                List<OrgEventManager__Event_Registration__c> eventRegistrations = new List<OrgEventManager__Event_Registration__c>();   
                
                List<OrgEventManager__Event_Registered_Contact__c> eventRegContactRecords = new List<OrgEventManager__Event_Registered_Contact__c>(); 

                List<OrgEventManager__Attendee__c> sessionRegCgContacts = new List<OrgEventManager__Attendee__c>();
                
                // Create Online_Registration__c record
                OrgEventManager__Online_Registration__c objOnlineReg = new OrgEventManager__Online_Registration__c();
                insert objOnlineReg;
                
                //insert Event_Registration__c records
                for (String eventId : eventIdStrings) {
                    OrgEventManager__Event_Registration__c eventRegistration = new OrgEventManager__Event_Registration__c();  
                    eventRegistration.OrgEventManager__Contact__c = cgContactId;
                    eventRegistration.OrgEventManager__Event__c = Id.valueOf(eventId.trim());    
                    eventRegistration.OrgEventManager__Online_Registration__c = objOnlineReg.Id;                
                    eventRegistrations.add(eventRegistration);
                }

                // Bulk insert Event_Registration__c records if not empty
                if (!eventRegistrations.isEmpty()) {
                    insert eventRegistrations;
                }              
                
                // Create EventRegistrationContact records
                for (OrgEventManager__Event_Registration__c eventReg : eventRegistrations) {
                    for (Id contactId : allContactIds) {
                        OrgEventManager__Event_Registered_Contact__c eventRegContact = new OrgEventManager__Event_Registered_Contact__c();
                        eventRegContact.OrgEventManager__Event_Registration__c = eventReg.Id;
                        eventRegContact.OrgEventManager__Contact__c = contactId;
                        eventRegContactRecords.add(eventRegContact);
                    }                    
                    
                }

                // Create Session_Registered_Contact records
                for(Id eventSessId : selectedIDSsession){
                    for (Id contactId : cgContactIds) {
                        OrgEventManager__Attendee__c sessionRegContact = new OrgEventManager__Attendee__c();
                        sessionRegContact.OrgEventManager__Session__c = eventSessId;
                        sessionRegContact.OrgEventManager__Name_of_Attendees__c = contactId;
                        sessionRegCgContacts.add(sessionRegContact);
                    }
                 }

                 // Bulk insert Event_Registered_Contact__c records if not empty
                if (!eventRegContactRecords.isEmpty()) {
                    insert eventRegContactRecords;
                }
                
                // Bulk insert Attendee__c records if not empty
                if (!sessionRegCgContacts.isEmpty()) {
                    insert sessionRegCgContacts;
                } 
                
                return objOnlineReg;
            } else {
                return NULL;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<OrgEventManager__Session__c> statusUpdateMethod(String selectedEventIds,List<Id> cgContactIds) {
        try {
            if(selectedEventIds != null){
                
                 // Ensure the user has permission to access and modify the Attendee__c, Session__c and Events__c objects
            if (!Schema.sObjectType.OrgEventManager__Attendee__c.isAccessible() || !Schema.sObjectType.OrgEventManager__Session__c.isAccessible() || !Schema.sObjectType.OrgEventManager__Events__c.isAccessible()) {
                throw new AuraHandledException('You do not have access to required objects.');
            }
            if (!Schema.sObjectType.OrgEventManager__Attendee__c.isUpdateable()) {
                throw new AuraHandledException('You do not have permission to update Attendees.');
            }

            // Ensure FLS checks for the fields in Attendee__c and Session__c
            if (!Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Session__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Name_of_Attendees__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Status__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Attendee__c.fields.Name.isAccessible() ) {
                throw new AuraHandledException('You do not have field-level security permissions.');
            }

             // Check if the user has read access to fields on Regsitrant__c and Session__c
            if (!Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Venue__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Session__c.fields.Name.isAccessible() || 
                !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Session_Mode__c.isAccessible() || 
                !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Session_Date__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Date_of_session__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Start_Time__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__End_Time__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Remarks__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Events__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Events__c.fields.Name.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_Language__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_State__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_Image_Link__c.isAccessible() ) {
                throw new AuraHandledException('Access to one or more fields is denied.');
            }

                // Step 1: Split the comma-separated string into a list of event IDs
                List<String> eventIdStrings = selectedEventIds.split(',');
                
                // Step 2: Query to get Attendee__c records based on event IDs
                List<OrgEventManager__Attendee__c> sessionRegContacts = [
                    SELECT Id, OrgEventManager__Session__c, OrgEventManager__Name_of_Attendees__c, OrgEventManager__Status__c, OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Capacity__c
                    FROM OrgEventManager__Attendee__c
                    WHERE OrgEventManager__Session__r.OrgEventManager__Events__c IN :eventIdStrings
                    ORDER BY CreatedDate ASC
                ];                
               
                
                // Step 3: Group the contacts by session ID
                Map<Id, List<OrgEventManager__Attendee__c>> sessionToContactsMap = new Map<Id, List<OrgEventManager__Attendee__c>>();
                for (OrgEventManager__Attendee__c regContact : sessionRegContacts) {
                    if (!sessionToContactsMap.containsKey(regContact.OrgEventManager__Session__c)) {
                        sessionToContactsMap.put(regContact.OrgEventManager__Session__c, new List<OrgEventManager__Attendee__c>());
                    }
                    sessionToContactsMap.get(regContact.OrgEventManager__Session__c).add(regContact);
                }
                
                // Prepare a list to hold the records to update
                List<OrgEventManager__Attendee__c> sessionRegContactToUpdate = new List<OrgEventManager__Attendee__c>();            
                
                // Step 4: Iterate over each session and process the contacts
                for (Id sessionId : sessionToContactsMap.keySet()) {
                    List<OrgEventManager__Attendee__c> contacts = sessionToContactsMap.get(sessionId);
                    Decimal capacity = contacts[0].OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Capacity__c;//10
                    Integer registeredCount = 0;
                    
                    for (OrgEventManager__Attendee__c contact : contacts) {
                        if (contact.OrgEventManager__Status__c == 'Cancelled' || contact.OrgEventManager__Status__c == 'Attended' || contact.OrgEventManager__Status__c == 'Confirmed') {
                            continue;
                        }
                        if (registeredCount < capacity) {
                            contact.OrgEventManager__Status__c = 'Registered';
                        } else {
                            contact.OrgEventManager__Status__c = 'Waitlist';
                        }
                        registeredCount++;//1
                        sessionRegContactToUpdate.add(contact);
                    }
                }
                
                // Step 5: Update the records in the database
                if (!sessionRegContactToUpdate.isEmpty()) {
                    update sessionRegContactToUpdate;
                }                
                
                Integer cgContactIdsSize = cgContactIds.size();
                List<OrgEventManager__Session__c> sessionRegContactsDashboard = [SELECT Id , Name,OrgEventManager__Session_Mode__c,OrgEventManager__Session_Date__c,OrgEventManager__Date_of_session__c,OrgEventManager__Venue__c,OrgEventManager__Remarks__c,OrgEventManager__Start_Time__c,OrgEventManager__End_Time__c,  OrgEventManager__Events__r.Name,OrgEventManager__Events__r.OrgEventManager__Event_Language__c,OrgEventManager__Events__r.OrgEventManager__Event_State__c ,OrgEventManager__Events__r.OrgEventManager__Event_Image_Link__c, (Select id, name, OrgEventManager__Status__c,OrgEventManager__Name_of_Attendees__r.Name from OrgEventManager__Attendees__r where OrgEventManager__Name_of_Attendees__r.Id IN : cgContactIds order by CreatedDate DESC limit :cgContactIdsSize ) FROM OrgEventManager__Session__c Where OrgEventManager__Events__r.Id IN : eventIdStrings];
                
                sendEmailToParticipant(cgContactIds,selectedEventIds); 
                sendEmailToTeam(cgContactIds,selectedEventIds);
                return sessionRegContactsDashboard;
            }
            else{
                return null;
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void sendEmailToParticipant(List<Id> cgContactIds, String selectedEventIds){
        
        try {
            // Step 1: Split the comma-separated string into a list of event IDs
            List<String> eventIdStrings = selectedEventIds.split(',');
            // Step 2: Retrieve all session registration records for the given cgContactIds
            List<OrgEventManager__Attendee__c> allCaregiverSessions = [
                SELECT Id, OrgEventManager__Session__c, OrgEventManager__Name_of_Attendees__r.Email, OrgEventManager__Status__c, OrgEventManager__Session__r.Name, OrgEventManager__Session__r.OrgEventManager__Venue__c, OrgEventManager__Session__r.OrgEventManager__Session_Date__c, OrgEventManager__Session__r.OrgEventManager__Start_Time__c, OrgEventManager__Session__r.OrgEventManager__End_Time__c, OrgEventManager__Session__r.OrgEventManager__Events__r.Name, OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Language__c, OrgEventManager__Name_of_Attendees__c, OrgEventManager__Name_of_Attendees__r.Name
                FROM OrgEventManager__Attendee__c
                WHERE OrgEventManager__Name_of_Attendees__c IN :cgContactIds AND OrgEventManager__Session__r.OrgEventManager__Events__c IN :eventIdStrings
            ];
            
            // Set the Org-Wide Email Address ID
            // String orgWideEmailAddress = Label.orgWideEmailAddressLabel;
            //String orgWideEmailId = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'pratiksha.thorat@thutechs.com' LIMIT 1].Id;
            
            // Group the sessions by caregiver ID
            Map<Id, List<OrgEventManager__Attendee__c>> cgContactSessionsMap = new Map<Id, List<OrgEventManager__Attendee__c>>();
            for (OrgEventManager__Attendee__c caregiverSession : allCaregiverSessions) {
                if (!cgContactSessionsMap.containsKey(caregiverSession.OrgEventManager__Name_of_Attendees__c)) {
                    cgContactSessionsMap.put(caregiverSession.OrgEventManager__Name_of_Attendees__c, new List<OrgEventManager__Attendee__c>());
                }
                cgContactSessionsMap.get(caregiverSession.OrgEventManager__Name_of_Attendees__c).add(caregiverSession);
            }
            
            // Retrieve custom label value
            String dashboardLink = Label.Event_Registration_Form_URL;
            
            // Step 3: Compose and send the email
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for (Id cgContactId : cgContactSessionsMap.keySet()) {
                List<OrgEventManager__Attendee__c> caregiverSessions = cgContactSessionsMap.get(cgContactId);
                if (caregiverSessions.isEmpty() || caregiverSessions[0].OrgEventManager__Name_of_Attendees__r.Email == null) {
                    continue;
                }
                
                // Compose email content
                String emailBody = '<html><body><p>Dear ' + caregiverSessions[0].OrgEventManager__Name_of_Attendees__r.Name + ',</p>';
                //emailBody += '<p>Thank you for registering for ' + caregiverSessions[0].Sessions__r.Event__r.Name + '.<br>Please log in to your dashboard for more details: <a href="' + dashboardLink + '">Dashboard</a></p>';
                emailBody += '<p>Thank you for registering the following sessions.<br><br>Please log in to your dashboard for more details: <a href="' + dashboardLink + '">Dashboard</a></p>';
                //emailBody += '<p>Please log in to your dashboard for more details: <a href="' + dashboardLink + '">Dashboard</a></p>';
                emailBody += '<table border="1" style="border-collapse: collapse;">';
                emailBody += '<tr><th>Event Name</th><th>Event Language</th><th>Session Name</th><th>Venue</th>';
                emailBody += '<th>Date</th><th>Start Time</th><th>End Time</th>';
                emailBody += '<th>Status</th></tr>';
                
                for (OrgEventManager__Attendee__c caregiverSession : caregiverSessions) {
                    String formattedDate = DateTime.newInstance(caregiverSession.OrgEventManager__Session__r.OrgEventManager__Session_Date__c, Time.newInstance(0, 0, 0, 0)).format('dd/MM/yyyy');
                    emailBody += '<tr>';
                    emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__Events__r.Name + '</td>';
                    emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Language__c + '</td>';
                    emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.Name + '</td>';
                    emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__Venue__c + '</td>';
                    emailBody += '<td style="padding: 8px;">' + formattedDate + '</td>';
                    emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__Start_Time__c + '</td>';
                    emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__End_Time__c + '</td>';
                    //emailBody += '<td>' + caregiverSession.Name_of_Caregiver__r.Name + '</td>';
                    //emailBody += '<td>' + caregiverSession.Name_of_Caregiver__r.NRIC__c + '</td>';
                    //emailBody += '<td>' + caregiverSession.Name_of_Caregiver__r.Email + '</td>';
                    emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Status__c + '</td>';
                    emailBody += '</tr>';
                }
                 	emailBody += '</table>';
                	//emailBody += '<p>[Dashboard table indicating date, time, venue, topic, session remarks, session status]</p>';
                    //emailBody += '<p>Kindly arrive 15 minutes early for registration.</p>';
                    emailBody += '<p>An email and text reminder will be sent out 3 to 5 days before the session.<br>For participants who are new to us, we will contact you to verify your registration details.</p>';
                    //emailBody += '<p>For participants new to us, we will contact you to verify your registration details.</p>';
                    //emailBody += '<p>Should you require further clarification, you may call our Thutech Helpline at 6377 0700.</p>';
                	emailBody += '<p>Thank you.</p>';
                    emailBody += '<p>Best regards,<br>Thutech Infosystem Pvt. Ltd</p>';
                	emailBody += '<p><i>This is an auto-generated email. Please do not reply.</i></p></body></html>';
                
                // Prepare email
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { caregiverSessions[0].OrgEventManager__Name_of_Attendees__r.Email });
                mail.setSubject('Registration – ' + caregiverSessions[0].OrgEventManager__Session__r.OrgEventManager__Events__r.Name);
                mail.setHtmlBody(emailBody);
                mail.setOrgWideEmailAddressId(label.orgWideEmailAddressLabel);
                //mail.setSenderDisplayName('Thutech Event Registration');
                emails.add(mail);
            }
            
            // Send all emails
            if (!emails.isEmpty()) {
                Messaging.sendEmail(emails);
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    @AuraEnabled
    public static List<OrgEventManager__Session__c> publicStatusUpdateMethod(String selectedEventIds,List<Id> cgContactIds) {
        try {
            if(selectedEventIds != null){
                
                 // Ensure the user has permission to access and modify the Attendee__c, Session__c and Events__c objects
            /*if (!Schema.sObjectType.OrgEventManager__Attendee__c.isAccessible() || !Schema.sObjectType.OrgEventManager__Session__c.isAccessible() || !Schema.sObjectType.OrgEventManager__Events__c.isAccessible()) {
                throw new AuraHandledException('You do not have access to required objects.');
            }
            if (!Schema.sObjectType.OrgEventManager__Attendee__c.isUpdateable()) {
                throw new AuraHandledException('You do not have permission to update Attendees.');
            }

            // Ensure FLS checks for the fields in Attendee__c and Session__c
            if (!Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Session__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Name_of_Attendees__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Status__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Attendee__c.fields.Name.isAccessible() ) {
                throw new AuraHandledException('You do not have field-level security permissions.');
            }

             // Check if the user has read access to fields on Regsitrant__c and Session__c
            if (!Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Venue__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Session__c.fields.Name.isAccessible() || 
                !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Session_Date__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Date_of_session__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Start_Time__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__End_Time__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Remarks__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Events__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Events__c.fields.Name.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_Language__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_State__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_Image_Link__c.isAccessible() ) {
                throw new AuraHandledException('Access to one or more fields is denied.');
            }*/

                // Step 1: Split the comma-separated string into a list of event IDs
                List<String> eventIdStrings = selectedEventIds.split(',');
                
                // Step 2: Query to get Attendee__c records based on event IDs
                List<OrgEventManager__Attendee__c> sessionRegContacts = [
                    SELECT Id, OrgEventManager__Session__c, OrgEventManager__Name_of_Attendees__c, OrgEventManager__Status__c, OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Capacity__c
                    FROM OrgEventManager__Attendee__c
                    WHERE OrgEventManager__Session__r.OrgEventManager__Events__c IN :eventIdStrings
                    ORDER BY CreatedDate ASC
                ];                
               
                
                // Step 3: Group the contacts by session ID
                Map<Id, List<OrgEventManager__Attendee__c>> sessionToContactsMap = new Map<Id, List<OrgEventManager__Attendee__c>>();
                for (OrgEventManager__Attendee__c regContact : sessionRegContacts) {
                    if (!sessionToContactsMap.containsKey(regContact.OrgEventManager__Session__c)) {
                        sessionToContactsMap.put(regContact.OrgEventManager__Session__c, new List<OrgEventManager__Attendee__c>());
                    }
                    sessionToContactsMap.get(regContact.OrgEventManager__Session__c).add(regContact);
                }
                
                // Prepare a list to hold the records to update
                List<OrgEventManager__Attendee__c> sessionRegContactToUpdate = new List<OrgEventManager__Attendee__c>();            
                
                // Step 4: Iterate over each session and process the contacts
                for (Id sessionId : sessionToContactsMap.keySet()) {
                    List<OrgEventManager__Attendee__c> contacts = sessionToContactsMap.get(sessionId);
                    Decimal capacity = contacts[0].OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Capacity__c;//10
                    Integer registeredCount = 0;
                    
                    for (OrgEventManager__Attendee__c contact : contacts) {
                        if (contact.OrgEventManager__Status__c == 'Cancelled' || contact.OrgEventManager__Status__c == 'Attended' || contact.OrgEventManager__Status__c == 'Confirmed') {
                            continue;
                        }
                        if (registeredCount < capacity) {
                            contact.OrgEventManager__Status__c = 'Registered';
                        } else {
                            contact.OrgEventManager__Status__c = 'Waitlist';
                        }
                        registeredCount++;//1
                        sessionRegContactToUpdate.add(contact);
                    }
                }
                
                // Step 5: Update the records in the database
                if (!sessionRegContactToUpdate.isEmpty()) {
                    update sessionRegContactToUpdate;
                }                
                
                Integer cgContactIdsSize = cgContactIds.size();
                List<OrgEventManager__Session__c> sessionRegContactsDashboard = [SELECT Id , Name,OrgEventManager__Session_Date__c,OrgEventManager__Date_of_session__c,OrgEventManager__Venue__c,OrgEventManager__Remarks__c,OrgEventManager__Start_Time__c,OrgEventManager__End_Time__c,  OrgEventManager__Events__r.Name,OrgEventManager__Events__r.OrgEventManager__Event_Language__c ,OrgEventManager__Events__r.OrgEventManager__Event_State__c ,OrgEventManager__Events__r.OrgEventManager__Event_Image_Link__c, (Select id, name, OrgEventManager__Status__c,OrgEventManager__Name_of_Attendees__r.Name from OrgEventManager__Attendees__r where OrgEventManager__Name_of_Attendees__r.Id IN : cgContactIds order by CreatedDate DESC limit :cgContactIdsSize ) FROM OrgEventManager__Session__c Where OrgEventManager__Events__r.Id IN : eventIdStrings];
                system.debug('sessionRegContactsDashboard===>'+sessionRegContactsDashboard);
                publicSendEmailToParticipant(cgContactIds,selectedEventIds); 
                sendEmailToTeam(cgContactIds,selectedEventIds);
                return sessionRegContactsDashboard;
            }
            else{
                return null;
            }
            
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
           
        }
    }

    @AuraEnabled
    public static void publicSendEmailToParticipant(List<Id> cgContactIds, String selectedEventIds){
        
        try {
            // Step 1: Split the comma-separated string into a list of event IDs
            List<String> eventIdStrings = selectedEventIds.split(',');
            // Step 2: Retrieve all session registration records for the given cgContactIds
            List<OrgEventManager__Attendee__c> allCaregiverSessions = [
                SELECT Id, OrgEventManager__Session__c, OrgEventManager__Name_of_Attendees__r.Email, OrgEventManager__Status__c, OrgEventManager__Session__r.Name, OrgEventManager__Session__r.OrgEventManager__Venue__c, OrgEventManager__Session__r.OrgEventManager__Session_Date__c, OrgEventManager__Session__r.OrgEventManager__Start_Time__c, OrgEventManager__Session__r.OrgEventManager__End_Time__c, OrgEventManager__Session__r.OrgEventManager__Events__r.Name, OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Language__c, OrgEventManager__Name_of_Attendees__c, OrgEventManager__Name_of_Attendees__r.Name
                FROM OrgEventManager__Attendee__c
                WHERE OrgEventManager__Name_of_Attendees__c IN :cgContactIds AND OrgEventManager__Session__r.OrgEventManager__Events__c IN :eventIdStrings
            ];
            
            // Set the Org-Wide Email Address ID
            // String orgWideEmailAddress = Label.orgWideEmailAddressLabel;
            //String orgWideEmailId = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'pratiksha.thorat@thutechs.com' LIMIT 1].Id;
            
            // Group the sessions by caregiver ID
            Map<Id, List<OrgEventManager__Attendee__c>> cgContactSessionsMap = new Map<Id, List<OrgEventManager__Attendee__c>>();
            for (OrgEventManager__Attendee__c caregiverSession : allCaregiverSessions) {
                if (!cgContactSessionsMap.containsKey(caregiverSession.OrgEventManager__Name_of_Attendees__c)) {
                    cgContactSessionsMap.put(caregiverSession.OrgEventManager__Name_of_Attendees__c, new List<OrgEventManager__Attendee__c>());
                }
                cgContactSessionsMap.get(caregiverSession.OrgEventManager__Name_of_Attendees__c).add(caregiverSession);
            }
            
            // Retrieve custom label value
            //String dashboardLink = Label.Event_Registration_Form_URL;
            
            // Step 3: Compose and send the email
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for (Id cgContactId : cgContactSessionsMap.keySet()) {
                List<OrgEventManager__Attendee__c> caregiverSessions = cgContactSessionsMap.get(cgContactId);
                if (caregiverSessions.isEmpty() || caregiverSessions[0].OrgEventManager__Name_of_Attendees__r.Email == null) {
                    continue;
                }
                
                // Compose email content
                // Compose email content
                String emailBody = '<html><body><p>Dear ' + caregiverSessions[0].OrgEventManager__Name_of_Attendees__r.Name + ',</p>';
                //emailBody += '<p>Thank you for registering for ' + caregiverSessions[0].Sessions__r.Event__r.Name + '.<br>Please log in to your dashboard for more details: <a href="' + dashboardLink + '">Dashboard</a></p>';
                emailBody += '<p>Thank you for registering the following sessions.<br></p>';
                //emailBody += '<p>Please log in to your dashboard for more details: <a href="' + dashboardLink + '">Dashboard</a></p>';
                emailBody += '<table border="1" style="border-collapse: collapse;">';
                emailBody += '<tr><th>Event Name</th><th>Event Language</th><th>Session Name</th><th>Venue</th>';
                emailBody += '<th>Date</th><th>Start Time</th><th>End Time</th>';
                emailBody += '<th>Status</th></tr>';
                
                for (OrgEventManager__Attendee__c caregiverSession : caregiverSessions) {
                    String formattedDate = DateTime.newInstance(caregiverSession.OrgEventManager__Session__r.OrgEventManager__Session_Date__c, Time.newInstance(0, 0, 0, 0)).format('dd/MM/yyyy');
                    emailBody += '<tr>';
                    emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__Events__r.Name + '</td>';
                    emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Language__c + '</td>';
                    emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.Name + '</td>';
                    emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__Venue__c + '</td>';
                    emailBody += '<td style="padding: 8px;">' + formattedDate + '</td>';
                    emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__Start_Time__c + '</td>';
                    emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__End_Time__c + '</td>';
                    //emailBody += '<td>' + caregiverSession.Name_of_Caregiver__r.Name + '</td>';
                    //emailBody += '<td>' + caregiverSession.Name_of_Caregiver__r.NRIC__c + '</td>';
                    //emailBody += '<td>' + caregiverSession.Name_of_Caregiver__r.Email + '</td>';
                    emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Status__c + '</td>';
                    emailBody += '</tr>';
                }
                 	emailBody += '</table>';
                	//emailBody += '<p>[Dashboard table indicating date, time, venue, topic, session remarks, session status]</p>';
                    //emailBody += '<p>Kindly arrive 15 minutes early for registration.</p>';
                    emailBody += '<p>An email and text reminder will be sent out 3 to 5 days before the session.<br>For participants who are new to us, we will contact you to verify your registration details.</p>';
                    //emailBody += '<p>For participants new to us, we will contact you to verify your registration details.</p>';
                    //emailBody += '<p>Should you require further clarification, you may call our Thutech Helpline at 6377 0700.</p>';
                	emailBody += '<p>Thank you.</p>';
                    emailBody += '<p>Best regards,<br>Thutech Infosystem Pvt. Ltd</p>';
                	emailBody += '<p><i>This is an auto-generated email. Please do not reply.</i></p></body></html>';
                
                // Prepare email
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { caregiverSessions[0].OrgEventManager__Name_of_Attendees__r.Email });
                mail.setSubject('Registration – ' + caregiverSessions[0].OrgEventManager__Session__r.OrgEventManager__Events__r.Name);
                mail.setHtmlBody(emailBody);
                mail.setOrgWideEmailAddressId(label.orgWideEmailAddressLabel);
                //mail.setSenderDisplayName('Thutech Event Registration');
                emails.add(mail);
            }
            
            // Send all emails
            if (!emails.isEmpty()) {
                Messaging.sendEmail(emails);
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static void sendEmailToTeam(List<Id> cgContactIds, String selectedEventIds) {
        try {
            // Step 1: Split the comma-separated string into a list of event IDs
            List<String> eventIdStrings = selectedEventIds.split(',');
            
            // Step 2: Retrieve all session registration records for the given cgContactIds
            List<OrgEventManager__Attendee__c> allCaregiverSessions = [
                SELECT Id, OrgEventManager__Session__c, OrgEventManager__Name_of_Attendees__r.Email, OrgEventManager__Status__c, OrgEventManager__Session__r.Name, OrgEventManager__Session__r.OrgEventManager__Venue__c, 
                OrgEventManager__Session__r.OrgEventManager__Session_Date__c, OrgEventManager__Session__r.OrgEventManager__start_Time__c, OrgEventManager__Session__r.OrgEventManager__End_Time__c, 
                OrgEventManager__Session__r.OrgEventManager__Events__r.Name, OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Language__c, 
                OrgEventManager__Name_of_Attendees__c, OrgEventManager__Name_of_Attendees__r.Name
                FROM OrgEventManager__Attendee__c
                WHERE OrgEventManager__Name_of_Attendees__c IN :cgContactIds AND OrgEventManager__Session__r.OrgEventManager__Events__c IN :eventIdStrings
            ];
            
            // Step 3: Use a Set to ensure unique entries
            Set<OrgEventManager__Attendee__c> uniqueCaregiverSessions = new Set<OrgEventManager__Attendee__c>(allCaregiverSessions);
            
            // Step 4: Compose the email content
            String emailBody = '<html><body><p>Dear Team,</p><p>Please find below the details of the events and sessions registered:</p>';
            emailBody += '<table border="1" style="border-collapse: collapse;">';
            emailBody += '<tr><th>Event Name</th><th>Event Language</th><th>Session Name</th><th>Venue</th>';
            emailBody += '<th>Date</th><th>Start Time</th><th>End Time</th><th>Attendance CG Id</th><th>Name</th>';
            emailBody += '<th>Email</th><th>Status</th></tr>';
            
            for (Attendee__c caregiverSession : uniqueCaregiverSessions) {
                String formattedDate = DateTime.newInstance(caregiverSession.OrgEventManager__Session__r.OrgEventManager__Session_Date__c, Time.newInstance(0, 0, 0, 0)).format('dd/MM/yyyy');
                emailBody += '<tr>';
                emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__Events__r.Name + '</td>';
                emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Language__c + '</td>';
                emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.Name + '</td>';
                emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__Venue__c + '</td>';
                emailBody += '<td style="padding: 8px;">' + formattedDate + '</td>';
                emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__Start_Time__c + '</td>';
                emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Session__r.OrgEventManager__End_Time__c + '</td>';
                emailBody += '<td style="padding: 8px;"><a href="' + label.AttendeeCustomLabel + caregiverSession.Id + '/view">' + caregiverSession.Id + '</a></td>';
                emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Name_of_Attendees__r.Name + '</td>';
                //emailBody += '<td>' + caregiverSession.Name_of_Caregiver__r.NRIC__c + '</td>';
                emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Name_of_Attendees__r.Email + '</td>';
                emailBody += '<td style="padding: 8px;">' + caregiverSession.OrgEventManager__Status__c + '</td>';
                emailBody += '</tr>';
            }
            
            emailBody += '</table><p>Best regards,<br>Your Team</p></body></html>';
            
            String contactEmailAddress = Label.EventRegistrationEmail;
            
            // Split the email addresses into a list
            List<String> emailAddresses = contactEmailAddress.split(',');
            
            // Step 5: Prepare and send the email
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>(); 
            
            if (!emailAddresses.isEmpty()) {  
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(emailAddresses); // Replace with the specific email address
                mail.setSubject('Event Registration Details');
                mail.setHtmlBody(emailBody);
                mail.setOrgWideEmailAddressId(label.orgWideEmailAddressLabel);
                //mail.setSenderDisplayName('Thutech Event Registration');
                mailList.add(mail);
            }
            if(!mailList.isEmpty()){
                Messaging.sendEmail(mailList);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    /*@AuraEnabled
    public static string newUpdateCgandPwdContact(List<Id> cgContactIds) {
        try {

            // Check CRUD and FLS for Contact object
            if (!Schema.sObjectType.Contact.isUpdateable() || 
            !Schema.sObjectType.Contact.fields.AccountId.isUpdateable()) {
            throw new AuraHandledException('Insufficient permissions to update Contact or AccountId.');
            }
            
            // Check CRUD and FLS for Account object
            if (!Schema.sObjectType.Account.isCreateable()) {
                throw new AuraHandledException('Insufficient permissions to create Account.');
            }
            
            // Check field-level security for custom fields
            if (!Schema.sObjectType.Contact.fields.OrgEventManager__Postal_Code1__c.isAccessible() ||
                !Schema.sObjectType.Contact.fields.OrgEventManager__Floor__c.isAccessible() ||
                !Schema.sObjectType.Contact.fields.OrgEventManager__Unit_No__c.isAccessible()) {
                throw new AuraHandledException('Insufficient permissions to access Postal_Code__c, Floor__c, or Unit_No__c.');
            }

            if (!cgContactIds.isEmpty()) {
                // Fetch CG contacts
                List<Contact> cgContacts = [
                    SELECT Id, AccountId, OrgEventManager__Postal_Code1__c, 
                           OrgEventManager__Floor__c, OrgEventManager__Unit_No__c
                    FROM Contact 
                    WHERE Id IN :cgContactIds
                ];
                
                if (cgContacts.isEmpty()) {
                    return 'No valid contacts found for the provided IDs.';
                }
    
                List<Contact> cgContactsToUpdate = new List<Contact>();
                Id cgContactAccountId = null;
    
                // Check for existing AccountId among CG contacts
                for (Contact cgContact : cgContacts) {
                    if (cgContact.AccountId != null) {
                        cgContactAccountId = cgContact.AccountId;
                        break;
                    }
                }
    
                // If no AccountId is found, create a new Account
                if (cgContactAccountId == null) {
                    // Use the address details of the first contact
                    Contact sampleCgContact = cgContacts[0];
                    String YYMM = Datetime.now().format('yyMM');
                    Account newAccount = new Account();
                    newAccount.Name = YYMM + '-' + sampleCgContact.OrgEventManager__Postal_Code1__c + '-' + 
                                      sampleCgContact.OrgEventManager__Floor__c + '-' + 
                                      sampleCgContact.OrgEventManager__Unit_No__c;
    
                    insert newAccount;
                    cgContactAccountId = newAccount.Id;
                }
    
                // Map the AccountId to all CG contacts
                for (Contact cgContact : cgContacts) {
                    if (cgContact.AccountId == null) {
                        cgContact.AccountId = cgContactAccountId;
                        cgContactsToUpdate.add(cgContact);
                    }
                }
    
                // Perform the final update for CG contacts
                if (!cgContactsToUpdate.isEmpty()) {
                    update cgContactsToUpdate;
                }
    
                return 'CG contacts updated successfully.';
            } else {
                return 'No CG Contact IDs provided.';
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    @AuraEnabled(cacheable=true)
    public static List<OrgEventManager__Events__c> selectedEventsInDashBoard(String allIDS){        
        
        // Check if the user has read access to the Events__c object
        if (!Schema.sObjectType.OrgEventManager__Events__c.isAccessible() || 
        !Schema.sObjectType.OrgEventManager__Session__c.isAccessible()) {
            // If not accessible, throw an exception or return an empty list
            throw new AuraHandledException('Access to Events__c is denied.');
        }

        // List to store the records
        List<OrgEventManager__Events__c> listarray = new List<OrgEventManager__Events__c>();

        List<Id> listStates = allIDS.split(';');
        
        String query1 = 'SELECT Name, (SELECT Name , OrgEventManager__Session_Date__c,OrgEventManager__Date_of_session__c,OrgEventManager__Venue__c,OrgEventManager__Remarks__c FROM OrgEventManager__Sessions__r) FROM OrgEventManager__Events__c WHERE ';
        
        if (listStates.size() > 0) {
            query1 += 'Id IN :listStates';
        }     
        
        // Check Field-Level Security (FLS) for each field
        if (Schema.sObjectType.OrgEventManager__Events__c.fields.Name.isAccessible() || 
            Schema.sObjectType.OrgEventManager__Session__c.fields.Name.isAccessible() ||
            Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Session_Date__c.isAccessible() ||
            Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Venue__c.isAccessible() ||
            Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Remarks__c.isAccessible() ) {
            
            // Perform the query only if the fields are accessible
            listarray = Database.query(query1);
        }
        
        return listarray;
    }

    @AuraEnabled
    public static List<OrgEventManager__Attendee__c> ShowSessionFirstPageDashboard(){

         // Check if the user has access to Regsitrant__c and Session__c objects
         if (!Schema.sObjectType.OrgEventManager__Event_Registered_Contact__c.isAccessible() ||
         !Schema.sObjectType.OrgEventManager__Event_Registration__c.isAccessible() || 
         !Schema.sObjectType.OrgEventManager__Session__c.isAccessible() ||
         !Schema.sObjectType.Contact.isAccessible() ||
         !Schema.sObjectType.OrgEventManager__Attendee__c.isAccessible() ||
         !Schema.sObjectType.OrgEventManager__Events__c.isAccessible()) {
         throw new AuraHandledException('Access to the object is denied.');
        }
        
        // Check if the user has read access to fields on Regsitrant__c and Session__c
        if (!Schema.sObjectType.OrgEventManager__Event_Registration__c.fields.OrgEventManager__Email__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Venue__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.Name.isAccessible() || 
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Session_Date__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Date_of_session__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Start_Time__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__End_Time__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Remarks__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Events__c.isAccessible() ||
            !Schema.sObjectType.Contact.fields.Name.isAccessible() ||
            !Schema.sObjectType.Contact.fields.RecordTypeId.isAccessible() ||
            !Schema.sObjectType.Contact.fields.LastName.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Name_of_Attendees__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Status__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.Name.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_Language__c.isAccessible()) {
            throw new AuraHandledException('Access to one or more fields is denied.');
        }
        String currentUserEmail = Userinfo.getUserEmail();
        Date today = Date.today();
        
        List<OrgEventManager__Event_Registered_Contact__c> eventcontact = [select Id,OrgEventManager__Contact__r.Id,OrgEventManager__Contact__r.Name from OrgEventManager__Event_Registered_Contact__c where OrgEventManager__Event_Registration__r.OrgEventManager__Email__c =:currentUserEmail and OrgEventManager__Contact__r.RecordType.Name='Participants'];
        
        set<Id> contactIdSet = new set<Id>();
        for(OrgEventManager__Event_Registered_Contact__c e : eventcontact){
            contactIdSet.add(e.OrgEventManager__Contact__r.Id);  
        }
        
        System.debug('contactIdSet===='+contactIdSet);
        
        List<OrgEventManager__Attendee__c> sessRegCon = [select Id,OrgEventManager__Name_of_Attendees__r.Id,OrgEventManager__Session__r.OrgEventManager__Venue__c,OrgEventManager__Name_of_Attendees__r.LastName,OrgEventManager__Session__r.Name,OrgEventManager__Session__r.OrgEventManager__Events__r.Name,OrgEventManager__Session__r.OrgEventManager__Session_Date__c,OrgEventManager__Session__r.OrgEventManager__Date_of_session__c,OrgEventManager__Status__c,OrgEventManager__Session__r.OrgEventManager__Start_Time__c, OrgEventManager__Session__r.OrgEventManager__End_Time__c, OrgEventManager__Session__r.OrgEventManager__Remarks__c,OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Language__c from OrgEventManager__Attendee__c where OrgEventManager__Name_of_Attendees__r.Id IN :contactIdSet];
        
        return sessRegCon;
        
    }

    @AuraEnabled
    public static List<OrgEventManager__Attendee__c> getUpcommingSessions() {
        try {
             // Check if the user has access to Event_Registered_Contact__c and Session__c objects
         if (!Schema.sObjectType.OrgEventManager__Event_Registered_Contact__c.isAccessible() || 
         !Schema.sObjectType.OrgEventManager__Event_Registration__c.isAccessible() ||
         !Schema.sObjectType.OrgEventManager__Session__c.isAccessible() ||
         !Schema.sObjectType.Contact.isAccessible() ||
         !Schema.sObjectType.OrgEventManager__Attendee__c.isAccessible() ||
         !Schema.sObjectType.OrgEventManager__Events__c.isAccessible()) {
         throw new AuraHandledException('Access to the object is denied.');
        }
        
        // Check if the user has read access to fields on Regsitrant__c and Session__c
        if (!Schema.sObjectType.OrgEventManager__Event_Registration__c.fields.OrgEventManager__Email__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Venue__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.Name.isAccessible() || 
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Session_Mode__c.isAccessible() || 
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Session_Date__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Date_of_session__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Start_Time__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__End_Time__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Remarks__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Events__c.isAccessible() ||
            !Schema.sObjectType.Contact.fields.Name.isAccessible() ||
            !Schema.sObjectType.Contact.fields.LastName.isAccessible() ||
            !Schema.sObjectType.Contact.fields.RecordTypeId.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Name_of_Attendees__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Status__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.Name.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_Language__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_Image_Link__c.isAccessible() ) {
            throw new AuraHandledException('Access to one or more fields is denied.');
        }

            String currentUserEmail = Userinfo.getUserEmail();
            Date today = Date.today();

            List <OrgEventManager__Event_Registered_Contact__c> eventcontact = [select Id, OrgEventManager__Contact__r.Id, OrgEventManager__Contact__r.Name from OrgEventManager__Event_Registered_Contact__c where OrgEventManager__Event_Registration__r.OrgEventManager__Email__c =: currentUserEmail and OrgEventManager__Contact__r.RecordType.Name = 'Participants'];
            
            set <Id> contactIdSet = new set <Id> ();
            for (OrgEventManager__Event_Registered_Contact__c e: eventcontact) {
                contactIdSet.add(e.OrgEventManager__Contact__r.Id);
            }

            System.debug('contactIdSet====>' + contactIdSet);

            List <OrgEventManager__Attendee__c> sessRegCon = [SELECT Id, OrgEventManager__Session__r.OrgEventManager__Events__r.Id, OrgEventManager__Name_of_Attendees__r.Id, OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_State__c, OrgEventManager__Session__r.OrgEventManager__Venue__c,OrgEventManager__Session__r.OrgEventManager__Session_Mode__c, 
                                                               OrgEventManager__Name_of_Attendees__r.LastName, OrgEventManager__Session__r.Name, OrgEventManager__Session__r.OrgEventManager__Events__r.Name, OrgEventManager__Session__r.OrgEventManager__Session_Date__c,OrgEventManager__Session__r.OrgEventManager__Date_of_session__c, OrgEventManager__Status__c, 
                                                               OrgEventManager__Session__r.OrgEventManager__Start_Time__c, OrgEventManager__Session__r.OrgEventManager__End_Time__c, OrgEventManager__Session__r.OrgEventManager__Remarks__c, 
                                                               OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Language__c,OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Image_Link__c FROM OrgEventManager__Attendee__c WHERE OrgEventManager__Name_of_Attendees__r.Id IN: contactIdSet AND 
                                                               OrgEventManager__Session__r.OrgEventManager__Session_Date__c >=: today AND OrgEventManager__Status__c IN('Waitlist', 'Registered') order by OrgEventManager__Session__r.OrgEventManager__Session_Date__c ASC];
            
            return sessRegCon ;            
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static List<OrgEventManager__Attendee__c> getPastSessions(){ 
        try {
            
             // Check if the user has access to Event_Registered_Contact__c and Session__c objects
         if (!Schema.sObjectType.OrgEventManager__Event_Registered_Contact__c.isAccessible() || 
         !Schema.sObjectType.OrgEventManager__Event_Registration__c.isAccessible() ||
         !Schema.sObjectType.OrgEventManager__Session__c.isAccessible() ||
         !Schema.sObjectType.Contact.isAccessible() ||
         !Schema.sObjectType.OrgEventManager__Attendee__c.isAccessible() ||
         !Schema.sObjectType.OrgEventManager__Events__c.isAccessible()) {
         throw new AuraHandledException('Access to the object is denied.');
        }
        
        // Check if the user has read access to fields on Regsitrant__c and Session__c
        if (!Schema.sObjectType.OrgEventManager__Event_Registration__c.fields.OrgEventManager__Email__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Venue__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.Name.isAccessible() || 
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Session_Mode__c.isAccessible() || 
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Session_Date__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Date_of_session__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Start_Time__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__End_Time__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Remarks__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Events__c.isAccessible() ||
            !Schema.sObjectType.Contact.fields.Name.isAccessible() ||
            !Schema.sObjectType.Contact.fields.LastName.isAccessible() ||
            !Schema.sObjectType.Contact.fields.RecordTypeId.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Name_of_Attendees__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Status__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.Name.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_Language__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_Image_Link__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Events__c.fields.OrgEventManager__Event_State__c.isAccessible()) {
            throw new AuraHandledException('Access to one or more fields is denied.');
        }

            String currentUserEmail = Userinfo.getUserEmail();
            Date today = Date.today();
            
            List<OrgEventManager__Event_Registered_Contact__c> eventcontact = [select Id,OrgEventManager__Contact__r.Id,OrgEventManager__Contact__r.Name from OrgEventManager__Event_Registered_Contact__c where OrgEventManager__Event_Registration__r.OrgEventManager__Email__c =:currentUserEmail and OrgEventManager__Contact__r.RecordType.Name='Participants'];
            
            set<Id> contactIdSet = new set<Id>();
            for(OrgEventManager__Event_Registered_Contact__c e : eventcontact){
                contactIdSet.add(e.OrgEventManager__Contact__r.Id);  
            }
            
            System.debug('contactIdSet===='+contactIdSet);
            
            List<OrgEventManager__Attendee__c> sessRegCon = [select Id,OrgEventManager__Name_of_Attendees__r.Id,OrgEventManager__Session__r.OrgEventManager__Venue__c,OrgEventManager__Name_of_Attendees__r.LastName, OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_State__c,OrgEventManager__Session__r.Name,OrgEventManager__Session__r.OrgEventManager__Events__r.Name,OrgEventManager__Session__r.OrgEventManager__Session_Mode__c, OrgEventManager__Session__r.OrgEventManager__Session_Date__c,OrgEventManager__Session__r.OrgEventManager__Date_of_session__c,OrgEventManager__Status__c,OrgEventManager__Session__r.OrgEventManager__Start_Time__c, OrgEventManager__Session__r.OrgEventManager__End_Time__c, OrgEventManager__Session__r.OrgEventManager__Remarks__c,OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Language__c
                                                              ,OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Image_Link__c from OrgEventManager__Attendee__c where OrgEventManager__Name_of_Attendees__r.Id IN :contactIdSet and OrgEventManager__Session__r.OrgEventManager__Session_Date__c < :today order by OrgEventManager__Session__r.OrgEventManager__Session_Date__c ASC];
            
            return sessRegCon;
           
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<OrgEventManager__Attendee__c> handleWinDrawlled(String eventId, Id contactId){ 
        try {
            // Check if the user has read access to Attendee__c,Session__c and Events__c object and its fields
            if (!Schema.sObjectType.OrgEventManager__Attendee__c.isAccessible() || !Schema.sObjectType.OrgEventManager__Session__c.isAccessible() || !Schema.sObjectType.OrgEventManager__Events__c.isAccessible()) {
                throw new AuraHandledException('You do not have access to Attendee records.');
            }

            // Ensure FLS checks for the required fields in Attendee__c
            if (!Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Name_of_Attendees__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Session__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Status__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Session__c.fields.Name.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Events__c.isAccessible() ||
                !Schema.sObjectType.OrgEventManager__Events__c.fields.Name.isAccessible() ) {
                throw new AuraHandledException('You do not have field-level security permissions.');
            }
            
            List<OrgEventManager__Attendee__c> registeredContacts = [Select OrgEventManager__Name_of_Attendees__c , OrgEventManager__Session__r.OrgEventManager__Events__r.Id,
                    OrgEventManager__Session__r.Name , OrgEventManager__Status__c 
                    from OrgEventManager__Attendee__c where 
                    OrgEventManager__Session__r.OrgEventManager__Events__r.Name =:eventId and OrgEventManager__Status__c IN ('Registered','Waitlist') and 
                    OrgEventManager__Name_of_Attendees__r.Id =:contactId];

            //Check if the user has update access to the Attendee__c object
            if (!Schema.sObjectType.OrgEventManager__Attendee__c.isUpdateable()) {
                throw new AuraHandledException('You do not have permission to update Attendee records.');
            }
            
            for (OrgEventManager__Attendee__c contact : registeredContacts) {
                contact.OrgEventManager__Status__c = 'Withdraw';
            }
            
            // Perform the update operation
            update registeredContacts;
            
            return registeredContacts;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /*@AuraEnabled(cacheable=true)
    public static List<OrgEventManager__Regsitrant__c> getRelatedSessionRegisteredContact(Id Ids){ 
        try {
            // Check if the user has access to the Regsitrant__c object
        if (!Schema.sObjectType.OrgEventManager__Regsitrant__c.isAccessible() ||
        !Schema.sObjectType.Contact.isAccessible() ||
        !Schema.sObjectType.OrgEventManager__Attendee__c.isAccessible() ||
        !Schema.sObjectType.OrgEventManager__Session__c.isAccessible()) {
            throw new AuraHandledException('Access to Regsitrant__c is denied.');
        }

        // Check if the user has read access to the fields on Regsitrant__c
        if (!Schema.sObjectType.OrgEventManager__Regsitrant__c.fields.Name.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Regsitrant__c.fields.OrgEventManager__Name_of_Registrant__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Regsitrant__c.fields.OrgEventManager__Attendee__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Regsitrant__c.fields.OrgEventManager__Registrant_Gender__c.isAccessible() ||
            !Schema.sObjectType.Contact.fields.Name.isAccessible() ||
            !Schema.sObjectType.Contact.fields.OrgEventManager__Gender__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Attendee__c.fields.Name.isAccessible()
            ) {
            throw new AuraHandledException('Access to one or more fields is denied.');
        }

            return [SELECT id ,Name,OrgEventManager__Name_of_Registrant__r.Id,OrgEventManager__Name_of_Registrant__r.Name ,OrgEventManager__Attendee__r.Id, OrgEventManager__Attendee__r.Name,OrgEventManager__Registrant_Gender__c from OrgEventManager__Regsitrant__c where OrgEventManager__Attendee__r.OrgEventManager__Session__r.Id = :Ids];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    /*@AuraEnabled
    public static Integer getRelatedSessionPWDContact(Id Ids){ 
        try {

            // Check if the user has access to Regsitrant__c and Session__c objects
            if (!Schema.sObjectType.OrgEventManager__Regsitrant__c.isAccessible() || 
            !Schema.sObjectType.OrgEventManager__Session__c.isAccessible()||
            !Schema.sObjectType.Contact.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Attendee__c.isAccessible()) {
            throw new AuraHandledException('Access to the object is denied.');
        }
        
        // Check if the user has read access to fields on Regsitrant__c and Session__c
        if (!Schema.sObjectType.OrgEventManager__Regsitrant__c.fields.OrgEventManager__Name_of_Registrant__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Regsitrant__c.fields.OrgEventManager__Attendee__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Total_Registered_Registrant__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Status__c.isAccessible() ||
            !Schema.sObjectType.Contact.fields.Name.isAccessible()) {
            throw new AuraHandledException('Access to one or more fields is denied.');
        }

            Set<String> nameSet = new Set<String>();
            
            List<OrgEventManager__Regsitrant__c> contacts = [
                SELECT OrgEventManager__Name_of_Registrant__r.Name
                FROM OrgEventManager__Regsitrant__c
                WHERE OrgEventManager__Attendee__r.OrgEventManager__Session__r.Id = :Ids
                AND OrgEventManager__Attendee__r.OrgEventManager__Status__c = 'Registered'
            ];
            
            for (OrgEventManager__Regsitrant__c contact : contacts) {
                if (contact.OrgEventManager__Name_of_Registrant__r != null && contact.OrgEventManager__Name_of_Registrant__r.Name != null) {
                    nameSet.add(contact.OrgEventManager__Name_of_Registrant__r.Name);
                }
            }
            
            
            Integer size = nameSet.size();
            system.debug('"size---"' +size);
            
            
            List<OrgEventManager__Session__c> sessions = [
                SELECT Id, OrgEventManager__Total_Registered_Registrant__c 
                FROM OrgEventManager__Session__c 
                WHERE Id = :Ids
                LIMIT 1
            ];
            
            if (!sessions.isEmpty()) {
                 // Ensure the user has update access to the field
                if (!Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Total_Registered_Registrant__c.isUpdateable()) {
                    throw new AuraHandledException('You do not have permission to update this field.');
                }
                
                // Update the session record
                OrgEventManager__Session__c session = sessions[0];
                session.OrgEventManager__Total_Registered_Registrant__c = size;
                update session;
            }
            
            return size;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Integer getRelatedSessionPWDContactAttended(Id Ids){ 
        try {

             // Check if the user has access to Regsitrant__c and Session__c objects
            if (!Schema.sObjectType.OrgEventManager__Regsitrant__c.isAccessible() || 
            !Schema.sObjectType.OrgEventManager__Session__c.isAccessible() ||
            !Schema.sObjectType.Contact.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Attendee__c.isAccessible()) {
            throw new AuraHandledException('Access to the object is denied.');
        }
        
        // Check if the user has read access to fields on Regsitrant__c and Session__c
        if (!Schema.sObjectType.OrgEventManager__Regsitrant__c.fields.OrgEventManager__Name_of_Registrant__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Regsitrant__c.fields.OrgEventManager__Attendee__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Total_Attended_Registrant__c.isAccessible() ||
            !Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Status__c.isAccessible() ||
            !Schema.sObjectType.Contact.fields.Name.isAccessible()) {
            throw new AuraHandledException('Access to one or more fields is denied.');
        }

            Set<String> nameSet = new Set<String>();
            
            List<OrgEventManager__Regsitrant__c> contacts = [
                SELECT OrgEventManager__Name_of_Registrant__r.Name
                FROM OrgEventManager__Regsitrant__c
                WHERE OrgEventManager__Attendee__r.OrgEventManager__Session__r.Id = :Ids
                AND OrgEventManager__Attendee__r.OrgEventManager__Status__c = 'Attended'
            ];
            
            for (OrgEventManager__Regsitrant__c contact : contacts) {
                if (contact.OrgEventManager__Name_of_Registrant__r != null && contact.OrgEventManager__Name_of_Registrant__r.Name != null) {
                    nameSet.add(contact.OrgEventManager__Name_of_Registrant__r.Name);
                }
            }
            
            
            Integer size = nameSet.size();
            system.debug('"getRelatedSessionPWDContactAttended---"' +size);
            
            
            List<OrgEventManager__Session__c> sessions = [
                SELECT Id, OrgEventManager__Total_Attended_Registrant__c 
                FROM OrgEventManager__Session__c 
                WHERE Id = :Ids
                LIMIT 1
            ];
            
            if (!sessions.isEmpty()) {
                // Ensure the user has update access to the field
                if (!Schema.sObjectType.OrgEventManager__Session__c.fields.OrgEventManager__Total_Attended_Registrant__c.isUpdateable()) {
                    throw new AuraHandledException('You do not have permission to update this field.');
                }
                
                // Update the session record
                OrgEventManager__Session__c session = sessions[0];
                session.OrgEventManager__Total_Attended_Registrant__c = size;
                update session;
            }
            
            return size;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/
}