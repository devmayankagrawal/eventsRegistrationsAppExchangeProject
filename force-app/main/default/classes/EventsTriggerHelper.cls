public class EventsTriggerHelper {
    
    public static void processCancelledEvents(List<OrgEventManager__Events__c> cancelledEvents) {
        
        // Fetch sessions related to the cancelled events
        Set<Id> eventIds = new Set<Id>();
        for (OrgEventManager__Events__c event : cancelledEvents) {
            eventIds.add(event.Id);
        }
        
        List<OrgEventManager__Session__c> sessions = [
            SELECT Id, Name, OrgEventManager__Session_Date__c, OrgEventManager__Start_Time__c, OrgEventManager__End_Time__c, OrgEventManager__Remarks__c, OrgEventManager__Venue__c,OrgEventManager__Events__c,
            (SELECT Id, OrgEventManager__Name_of_Attendees__c,OrgEventManager__Name_of_Attendees__r.Id,OrgEventManager__Name_of_Attendees__r.Name, OrgEventManager__Attendee_Email__c, OrgEventManager__Status__c
             FROM OrgEventManager__Attendees__r)
            FROM OrgEventManager__Session__c
            WHERE OrgEventManager__Events__c IN :eventIds
        ];
        
        Map<Id, List<OrgEventManager__Attendee__c>> attendeeMap = new Map<Id, List<OrgEventManager__Attendee__c>>();
        Map<Id, List<OrgEventManager__Session__c>> sessionMap = new Map<Id, List<OrgEventManager__Session__c>>();
        
        // Organize sessions and attendees
        for (OrgEventManager__Session__c session : sessions) {
            if (!sessionMap.containsKey(session.OrgEventManager__Events__c)) {
                sessionMap.put(session.OrgEventManager__Events__c, new List<OrgEventManager__Session__c>());
            }
            sessionMap.get(session.OrgEventManager__Events__c).add(session);
            
            for (OrgEventManager__Attendee__c attendee : session.OrgEventManager__Attendees__r) {
                if (!attendeeMap.containsKey(attendee.OrgEventManager__Name_of_Attendees__r.Id)) {
                    attendeeMap.put(attendee.OrgEventManager__Name_of_Attendees__r.Id, new List<OrgEventManager__Attendee__c>());
                }
                attendeeMap.get(attendee.OrgEventManager__Name_of_Attendees__r.Id).add(attendee);
            }
        }
        
        if (!Schema.sObjectType.OrgEventManager__Attendee__c.isUpdateable()) {
            throw new Auth.DiscoveryCustomErrorException('Insufficient permissions to update Participant records.');
        }
        if (!Schema.sObjectType.OrgEventManager__Attendee__c.fields.OrgEventManager__Status__c.isUpdateable()) {
            throw new Auth.DiscoveryCustomErrorException('Insufficient permissions to update the Participant Status.');
        }
        
        // Send email and update attendee status
        List<OrgEventManager__Attendee__c> attendeesToUpdate = new List<OrgEventManager__Attendee__c>();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        // Generate HTML email content        
        for (Id contactId : attendeeMap.keySet()) {
            List<OrgEventManager__Attendee__c> attendees = attendeeMap.get(contactId);
            String attendeeName = attendees[0].OrgEventManager__Name_of_Attendees__r.Name;
            String eventName = cancelledEvents[0].Name;
            String eventURL = Label.Event_Registration_Form_URL;
            
            // Build session details as an HTML table
            String sessionDetailsTable = '<table border="1" style="border-collapse: collapse; width: 100%;">' +
                '<tr>' +
                '<th>Session Name</th>' +
                '<th>Session Date</th>' +
                '<th>Start Time</th>' +
                '<th>End Time</th>' +
                '<th>Remarks</th>' +
                '<th>Venue</th>' +
                '</tr>';
            for (OrgEventManager__Session__c session : sessionMap.get(cancelledEvents[0].Id)) {
                String formattedDate = DateTime.newInstance(session.OrgEventManager__Session_Date__c, Time.newInstance(0, 0, 0, 0)).format('dd/MM/yyyy');
                sessionDetailsTable += '<tr>' +
                    '<td style="padding: 5px;">' + session.Name + '</td>' +
                    '<td style="padding: 5px;">' + formattedDate + '</td>' +
                    '<td style="padding: 5px;">' + session.OrgEventManager__Start_Time__c + '</td>' +
                    '<td style="padding: 5px;">' + session.OrgEventManager__End_Time__c + '</td>' +
                    '<td style="padding: 5px;">' + session.OrgEventManager__Remarks__c + '</td>' +
                    '<td style="padding: 5px;">' + session.OrgEventManager__Venue__c + '</td>' +
                    '</tr>';
            }
            sessionDetailsTable += '</table>';
            
            // Compose HTML email body
            String htmlBody = 'Dear ' + attendeeName + ',<br/><br/>' +
                'We regret to inform you that <b>' + eventName + '</b> has been cancelled due to unforeseen circumstances.<br/><br/>' +
                'Our sincere apologies for any inconvenience caused.<br/><br/>' +
                'Please log in to your dashboard for more details: <a href="' + eventURL + '">' + eventURL + '</a><br/><br/>' +
                sessionDetailsTable +
                '<br/><br/>Thank you.<br/><br/>' +
                'Best regards,<br/>' +
                'Thutech<br/><br/>' +
                '<i>This is an auto-generated email. Please do not reply.</i>';
            
            // Create a new email message
            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            emailMessage.setToAddresses(new String[] { attendees[0].OrgEventManager__Attendee_Email__c });
            emailMessage.setSubject('Event Cancelled: ' + eventName);
            emailMessage.setHtmlBody(htmlBody);
            emailMessage.setOrgWideEmailAddressId(label.orgWideEmailAddressLabel);
            
            // Add to the list
            emails.add(emailMessage);
            
            // Update attendee status
            for (OrgEventManager__Attendee__c attendee : attendees) {
                attendee.OrgEventManager__Status__c = 'Cancelled';
                attendeesToUpdate.add(attendee);
            }
        }
        
        // Send emails and update attendees
        if (!emails.isEmpty()) Messaging.sendEmail(emails);
        if (!attendeesToUpdate.isEmpty()) update attendeesToUpdate;
    }
}