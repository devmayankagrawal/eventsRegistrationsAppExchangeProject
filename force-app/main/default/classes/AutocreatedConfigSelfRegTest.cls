@isTest
private class AutocreatedConfigSelfRegTest {
    
    @isTest
    static void testCreateUser() {
        // Create test data
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Common Community Sites Access' LIMIT 1];
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Contact c = new Contact(
            FirstName = 'Test',
            LastName='Contact',
            Email='testContact@gmail.com',
            AccountId=acc.Id,
            RecordTypeId=Label.AttendeeContactRecordTypeId
        );
        insert c;
        
        // Prepare registration attributes
        Map<SObjectField, String> registrationAttributes = new Map<SObjectField, String>{
            User.FirstName => 'Test',
                User.LastName => 'User',
                User.Username => 'testuser@test.com',
                User.Email => 'testuser@test.com',
                User.Alias => 'tuser',
                User.CommunityNickname => 'testuser',
                User.ContactId=>c.Id
                };
                    
                    // Call the method to create user
                    AutocreatedConfigSelfReg1729162850124 handler = new AutocreatedConfigSelfReg1729162850124();
        Test.startTest();
        Id userId = handler.createUser(acc.Id, p.Id, registrationAttributes, '');
        Test.stopTest();
        
        // Assert the created User
        User createdUser = [SELECT Id, FirstName, LastName, Email FROM User WHERE Id = :userId];
        
        System.assertEquals(createdUser.Id,userId);
        //system.debug('User Id=========='+userId);
        
    }
    
    @isTest
    static void testCreateUser1() {
        // Create test data
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Common Community Sites Access' LIMIT 1];
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Contact c = new Contact(
            FirstName = 'Test',
            LastName='Contact',
            Email='testContact@gmail.com',
            AccountId=acc.Id,
            RecordTypeId=Label.AttendeeContactRecordTypeId
        );
        insert c;
        
        // Prepare registration attributes
        Map<SObjectField, String> registrationAttributes = new Map<SObjectField, String>{
            
            User.ContactId=>c.Id
                };
                    
                    // Call the method to create user
                    AutocreatedConfigSelfReg1729162850124 handler = new AutocreatedConfigSelfReg1729162850124();
        Test.startTest();
        Id userId = handler.createUser(acc.Id, p.Id, registrationAttributes, '');
        Test.stopTest();
        // Assert the created User
        User createdUser = [SELECT Id, FirstName, LastName, Email FROM User WHERE Id = :userId];
        
        System.assertEquals(createdUser.Id,userId);
        //system.debug('User Id1=========='+userId);        
    }
    
    @isTest
    static void testDuplicateContactException() {
        // Create test data
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Common Community Sites Access' LIMIT 1];
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Contact c = new Contact(
            FirstName = 'Test',
            LastName='Contact',
            Email='testContact@gmail.com',
            AccountId=acc.Id,
            RecordTypeId=Label.AttendeeContactRecordTypeId
        );
        insert c;
        
        // Prepare registration attributes
        Map<SObjectField, String> registrationAttributes = new Map<SObjectField, String>{
            User.FirstName => 'Test',
                User.LastName => 'User',
                User.Username => 'testContact@gmail.com',
                User.Email => 'testContact@gmail.com',
                User.Alias => 'tuser',
                User.CommunityNickname => 'testuser',
                User.ContactId=>c.Id
                }; 
                    
                    Contact c1 = new Contact(
                        FirstName = 'Test',
                        LastName='Contact',
                        Email='testContact@gmail.com',
                        AccountId=acc.Id
                    );
        
        
        // Prepare registration attributes
        Map<SObjectField, String> registrationAttributes1 = new Map<SObjectField, String>{
            User.FirstName => 'Test',
                User.LastName => 'User',
                User.Username => 'testContact@gmail.com',
                User.Email => 'testContact@gmail.com',
                User.Alias => 'tuser',
                User.CommunityNickname => 'testuser',
                User.ContactId=>c1.Id
                }; 
                    
                    // Call the createUser method and expect the DuplicateContactException
                    AutocreatedConfigSelfReg1729162850124 handler = new AutocreatedConfigSelfReg1729162850124();
        
        Test.startTest();
        try {  
            Id userId = handler.createUser(acc.Id, p.Id, registrationAttributes1, '');
            
            // Assert the created User
            User createdUser = [SELECT Id, FirstName, LastName, Email FROM User WHERE Id = :userId];
            
            System.assertEquals(createdUser.Id,userId);
        }catch(exception e){
            System.assertEquals('Expected exception message', e.getMessage(), 'Exception message should match.');
        }
        Test.stopTest();
    }    
    
}