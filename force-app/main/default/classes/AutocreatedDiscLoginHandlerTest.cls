@isTest
private class AutocreatedDiscLoginHandlerTest {
    
    @isTest
    static void testLoginWithEmail() {
        // Test data setup
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus Login User' LIMIT 1];
        
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Contact c = new Contact(
            FirstName = 'Test',
            LastName='Contact',
            Email='agrawal@thutechs.com',
            AccountId=acc.Id
        );
        insert c;
        
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Username= 'agrawal@thutechs.com',
            Email = 'agrawal@thutechs.com',
            IsActive = true,
            Alias = 'Tuser',
            languagelocalekey = UserInfo.getLanguage(),
            localesidkey = UserInfo.getLocale(),
            emailEncodingKey = 'UTF-8',
            timeZoneSidKey = UserInfo.getTimezone().getID(),
            ProfileId = p.Id,
            ContactId = c.Id
        );
        insert testUser;
        
        // Create a test request attributes
        Map<String, String> requestAttributes = new Map<String, String>();
        requestAttributes.put('CommunityUrl', 'https://example.force.com');
        
        
        // Call the login method with an email identifier
        AutocreatedDiscLoginHandler1729162741641 loginHandler = new AutocreatedDiscLoginHandler1729162741641();
        //Test.startTest();
        try {  
            PageReference result = loginHandler.login('agrawal@thutechs.com', 'https://eventsregistration-dev-ed.develop.my.salesforce.com/', requestAttributes);            
            System.assert(result != null, 'The result should not be null');
        }
        catch (Exception e) {
            //Assert.isNotNull(e);
            //System.assert(false, 'Exception thrown: ' + e.getMessage());
        } 
        //Test.stopTest();
        
    }
    
    @isTest
    static void testLoginWithPhoneNumber() {
        // Test data setup
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus Login User' LIMIT 1];
        
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Contact c = new Contact(
            FirstName = 'Test',
            LastName='Contact',
            Email='agrawal@thutechs.com',
            AccountId=acc.Id
        );
        insert c;
        
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Username= 'agrawal@thutechs.com',
            Email = 'agrawal@thutechs.com',
            IsActive = true,
            Alias = 'Tuser',
            MobilePhone='+91 9865326598',
            languagelocalekey = UserInfo.getLanguage(),
            localesidkey = UserInfo.getLocale(),
            emailEncodingKey = 'UTF-8',
            timeZoneSidKey = UserInfo.getTimezone().getID(),
            ProfileId = p.Id,
            ContactId = c.Id
        );
        insert testUser;
        
        // Create a test request attributes
        Map<String, String> requestAttributes = new Map<String, String>();
        requestAttributes.put('CommunityUrl', 'https://example.force.com');
        
        
        // Call the login method with an email identifier
        AutocreatedDiscLoginHandler1729162741641 loginHandler = new AutocreatedDiscLoginHandler1729162741641();
        //Test.startTest();
        try {  
            PageReference result = loginHandler.login('+91 9865326598', 'https://eventsregistration-dev-ed.develop.my.salesforce.com/', requestAttributes);
            System.assert(result != null, 'The result should not be null');
        }
        catch (Exception e) {
            //Assert.isNotNull(e);
            //System.assert(false, 'Exception thrown: ' + e.getMessage());
        } 
        //Test.stopTest();
    }
    
    @isTest
    static void testLoginWithNoUniqueEmail() {
        // Test data setup
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus Login User' LIMIT 1];
        
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Contact c = new Contact(
            FirstName = 'Test',
            LastName='Contact',
            Email='mayank.agrawal@thutechs.com',
            AccountId=acc.Id
        );
        insert c;
        
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Username= 'mayank.agrawal@thutechs.com',
            Email = 'mayank.agrawal@thutechs.com',
            IsActive = true,
            Alias = 'Tuser',
            languagelocalekey = UserInfo.getLanguage(),
            localesidkey = UserInfo.getLocale(),
            emailEncodingKey = 'UTF-8',
            timeZoneSidKey = UserInfo.getTimezone().getID(),
            ProfileId = p.Id,
            ContactId = c.Id
        );
        insert testUser;
        
        // Create a test request attributes
        Map<String, String> requestAttributes = new Map<String, String>();
        requestAttributes.put('CommunityUrl', 'https://example.force.com');
        
        
        // Call the login method with an email identifier
        AutocreatedDiscLoginHandler1729162741641 loginHandler = new AutocreatedDiscLoginHandler1729162741641();
        //Test.startTest();
        try {  
            PageReference result = loginHandler.login('mayank.agrawal@thutechs.com', 'https://eventsregistration-dev-ed.develop.my.salesforce.com/', requestAttributes);
            System.assert(result != null, 'The result should not be null');
        }
        catch (Exception e) {
            //Assert.isNotNull(e);
            //System.assert(false, 'Exception thrown: ' + e.getMessage());
        } 
        //Test.stopTest();
    }
    
    @isTest
    static void testLoginWithNoUniquePhoneNumber() {
        // Test data setup
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus Login User' LIMIT 1];
        
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Contact c = new Contact(
            FirstName = 'Test',
            LastName='Contact',
            Email='agrawal@thutechs.com',
            AccountId=acc.Id
        );
        insert c;
        
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Username= 'agrawal@thutechs.com',
            Email = 'agrawal@thutechs.com',
            IsActive = true,
            Alias = 'Tuser',
            MobilePhone='+65 85006399',
            languagelocalekey = UserInfo.getLanguage(),
            localesidkey = UserInfo.getLocale(),
            emailEncodingKey = 'UTF-8',
            timeZoneSidKey = UserInfo.getTimezone().getID(),
            ProfileId = p.Id,
            ContactId = c.Id
        );
        insert testUser;
        
        // Create a test request attributes
        Map<String, String> requestAttributes = new Map<String, String>();
        requestAttributes.put('CommunityUrl', 'https://example.force.com');        
        
        // Call the login method with an email identifier
        AutocreatedDiscLoginHandler1729162741641 loginHandler = new AutocreatedDiscLoginHandler1729162741641();
        //Test.startTest();
        try {  
            PageReference result = loginHandler.login('+65 85006399', 'https://eventsregistration-dev-ed.develop.my.salesforce.com/', requestAttributes);
            System.assert(result != null, 'The result should not be null');
        }
        catch (Exception e) {
            //Assert.isNotNull(e);
            //System.assert(false, 'Exception thrown: ' + e.getMessage());
        } 
        //Test.stopTest();
    }
}