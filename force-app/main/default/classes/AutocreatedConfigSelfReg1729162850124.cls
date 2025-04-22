global class AutocreatedConfigSelfReg1729162850124 implements Auth.ConfigurableSelfRegHandler {
    
    private final Long CURRENT_TIME = Datetime.now().getTime();
    private final String[] UPPERCASE_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    private final String[] LOWERCASE_CHARS = 'abcdefghijklmnopqrstuvwxyz'.split('');
    private final String[] NUMBER_CHARS = '1234567890'.split('');
    private final String[] SPECIAL_CHARS = '!#$%-_=+<>'.split('');
    
    public class DuplicateContactException extends Exception {}
    
    // This method is called once after verification (if any was configured)
    // This method should create a user and insert it
    // Password can be null
    // Return null or throw an exception to fail creation
    global Id createUser(Id accountId, Id profileId, Map<SObjectField, String> registrationAttributes, String password) {
        TRY{
            if (!Schema.sObjectType.User.isCreateable()) {
                throw new Auth.DiscoveryCustomErrorException('Insufficient permissions to create User records.');
            }
            if (!Schema.sObjectType.User.fields.ProfileId.isCreateable() ||
                !Schema.sObjectType.User.fields.Email.isCreateable() ||
                !Schema.sObjectType.User.fields.FirstName.isCreateable() ||
                !Schema.sObjectType.User.fields.LastName.isCreateable() ||
                !Schema.sObjectType.User.fields.ContactId.isCreateable() ||
                !Schema.sObjectType.User.fields.languagelocalekey.isCreateable() ||
                !Schema.sObjectType.User.fields.localesidkey.isCreateable() ||
                !Schema.sObjectType.User.fields.emailEncodingKey.isCreateable() ||
                !Schema.sObjectType.User.fields.timeZoneSidKey.isCreateable() ||
                !Schema.sObjectType.User.fields.Username.isCreateable() ||
                !Schema.sObjectType.User.fields.Alias.isCreateable() ||
                !Schema.sObjectType.User.fields.CommunityNickname.isCreateable() 
               ) {
                throw new Auth.DiscoveryCustomErrorException('Insufficient permissions to set required fields on User records.');
            }

            User u = new User();
            u.ProfileId = profileId;
            for (SObjectField field : registrationAttributes.keySet()) {
                String value = registrationAttributes.get(field);
                u.put(field, value);
            }
            
            u = handleUnsetRequiredFields(u);
            u.ContactId = generateContact(u, accountId);
            if (String.isBlank(password)) {
                password = generateRandomPassword();
            }
            //(To by pass Site.validatePassword method to avoid the Salesforce System Error)  
            if(!test.isRunningTest()){
                Site.validatePassword(u, password, password);
                if (u.contactId == null) {
                    return Site.createExternalUser(u, accountId, password);
                }
            }
            u.languagelocalekey = UserInfo.getLanguage();
            u.localesidkey = UserInfo.getLocale();
            u.emailEncodingKey = 'UTF-8';
            u.timeZoneSidKey = UserInfo.getTimezone().getID();
            insert u;
            //System.setPassword(u.Id, password);
            return u.id;
        }  catch (Exception e) {
            string message = e.getMessage();
            string LinkUrl = System.URL.getOrgDomainUrl().toExternalForm();
            if(message.equals('[User already exists.]')){
                throw new Auth.DiscoveryCustomErrorException ('User Already Exists, please go to login page. ' + LinkUrl );
            }else if(message.equals('[There was an error in registering a user in site [SiteName]. The error message is: portal user already exists for contact]')) {
                
                throw new Auth.DiscoveryCustomErrorException('An error occurred, please try logging in or using a different email. You can login at ' + LinkUrl);
            }else if(message.equals('Your password must have a mix of letters and numbers')) {
                throw new Auth.DiscoveryCustomErrorException (e.getMessage());
            }else if(message.equals('Your password must be at least 8 characters long.')) {
                throw new Auth.DiscoveryCustomErrorException (e.getMessage());
            }else if(message.contains('DUPLICATES_DETECTED')) {
                throw new Auth.DiscoveryCustomErrorException ('Account already exists, please login or contact us for help.');
            }else{
                throw new Auth.DiscoveryCustomErrorException (e.getMessage());
            }
            
        }
    }
    
    // Method to autogenerate a password if one was not passed in
    // By setting a password for a user, we won't send a welcome email to set the password
    private String generateRandomPassword() {
        String[] characters = new List<String>(UPPERCASE_CHARS);
        characters.addAll(LOWERCASE_CHARS);
        characters.addAll(NUMBER_CHARS);
        characters.addAll(SPECIAL_CHARS);
        String newPassword = '';
        Boolean needsUpper = true, needsLower = true, needsNumber = true, needsSpecial = true;
        while (newPassword.length() < 50) {
            Integer randomInt = generateRandomInt(characters.size());
            String c = characters[randomInt];
            if (needsUpper && c.isAllUpperCase()) {
                needsUpper = false;
            } else if (needsLower && c.isAllLowerCase()) {
                needsLower = false;
            } else if (needsNumber && c.isNumeric()) {
                needsNumber = false;
            } else if (needsSpecial && !c.isAlphanumeric()) {
                needsSpecial = false;
            }
            newPassword += c; 
        }
        newPassword = addMissingPasswordRequirements(newPassword, needsLower, needsUpper, needsNumber, needsSpecial);
        return newPassword;
    }
    
    private String addMissingPasswordRequirements(String password, Boolean addLowerCase, Boolean addUpperCase, Boolean addNumber, Boolean addSpecial) {
        if (addLowerCase) {
            password += LOWERCASE_CHARS[generateRandomInt(LOWERCASE_CHARS.size())];
        }
        if (addUpperCase) {
            password += UPPERCASE_CHARS[generateRandomInt(UPPERCASE_CHARS.size())];
        }
        if (addNumber) {
            password += NUMBER_CHARS[generateRandomInt(NUMBER_CHARS.size())];
        }
        if (addSpecial) {
            password += SPECIAL_CHARS[generateRandomInt(SPECIAL_CHARS.size())];
        }
        return password;
    }
    
    // Generates a random number from 0 up to, but not including, max.
    private Integer generateRandomInt(Integer max) {
        return Math.mod(Math.abs(Crypto.getRandomInteger()), max);
    }
    
    // Loops over required fields that were not passed in to set to some default value
    private User handleUnsetRequiredFields(User u) {
        if (String.isBlank(u.LastName)){
            u.LastName = generateLastName();
        }
        if (String.isBlank(u.Username)) {
            u.Username = generateUsername();
        }
        if (String.isBlank(u.Email)) {
            u.Email = generateEmail();
        }
        if (String.isBlank(u.Alias)) {
            u.Alias = generateAlias();
        }
        if (String.isBlank(u.CommunityNickname)) {
            u.CommunityNickname = generateCommunityNickname();
        }
        return u;
    }
    
    // Method to construct a contact for a user
    private Id generateContact(User u, Id accountId) {
        
        // Check if a contact with the same email ID exists
        List<Contact> contactList = [SELECT Id, AccountId, Account.Owner.UserRole.Name FROM Contact WHERE Email = :u.Email ORDER BY CreatedDate ASC LIMIT 1];
        system.debug('contactList=========='+contactList);
        
        // Check if a user with the same email exists
        List<User> userList = [SELECT Id FROM User WHERE Email = :u.Email LIMIT 1];
        
        if (contactList.size() > 0) {
            // Check if a user exists with the contact's email
            List<User> existingUserList = [SELECT Id FROM User WHERE ContactId = :contactList[0].Id LIMIT 1];
            
            if (existingUserList.size() > 0) {
                // If a user already exists for this contact, throw an exception with the required message
                throw new Auth.DiscoveryCustomErrorException('The user with this email already exists. You can login to access the site.');
            } else {
                // If no user exists but the contact exists, update the account owner
                if (contactList[0].AccountId != null && contactList[0].Account.Owner.UserRole.Name == 'Event Registration Form Customer User') {
                    
                     if (!Schema.sObjectType.Account.isUpdateable()) {
                        throw new Auth.DiscoveryCustomErrorException('Insufficient permissions to update Account records.');
                    }
                    if (!Schema.sObjectType.Account.fields.OwnerId.isUpdateable()) {
                        throw new Auth.DiscoveryCustomErrorException('Insufficient permissions to update the Account Owner.');
                    }
                    
                    Account existingAccount = [SELECT Id, OwnerId FROM Account WHERE Id = :contactList[0].AccountId LIMIT 1];
                    existingAccount.OwnerId = Label.ownerIdLabel;
                    update existingAccount;
                }
                System.debug('Account owner updated for existing account.');
                return contactList[0].Id;
            }
        } else if (userList.size() > 0) {
            // If contact does not exist but user exists, throw an exception
            throw new Auth.DiscoveryCustomErrorException('The user with this email already exists. You can login to access the site.');
        }
        
        // Add FLS checks
        if (!Schema.sObjectType.Contact.isCreateable()) {
            throw new Auth.DiscoveryCustomErrorException('Insufficient permissions to create Contact records.');
        }
        if (!Schema.sObjectType.Contact.fields.FirstName.isCreateable() ||
            !Schema.sObjectType.Contact.fields.LastName.isCreateable() ||
            !Schema.sObjectType.Contact.fields.Email.isCreateable() ||
            !Schema.sObjectType.Contact.fields.RecordTypeId.isCreateable() ||
            !Schema.sObjectType.Contact.fields.AccountId.isCreateable()) {
            throw new Auth.DiscoveryCustomErrorException('Insufficient permissions to set required fields on Contact records.');
        }
        // Add logic here if you want to build your own contact for the user
        Contact cont = new Contact();
        cont.FirstName=u.FirstName;
        cont.LastName=u.LastName;
        cont.AccountId=accountId;
        cont.Email=u.Email;
        cont.RecordTypeId = Label.AttendeeContactRecordTypeId;
        System.debug('cont:'+cont);
        insert cont;
        return cont.Id;
    }
    
    // Default implementation to try to provide uniqueness
    private String generateAlias() {
        String timeString = String.valueOf(CURRENT_TIME);
        return timeString.substring(timeString.length() - 8);
    }
    
    // Default implementation to try to provide uniqueness
    //(To make the method visible in the test class)
    @testVisible
    private String generateLastName() {
        return 'ExternalUser' + CURRENT_TIME;
    }
    
    // Default implementation to try to provide uniqueness
    //(To make the method visible in the test class)
    @testVisible
    private String generateUsername() {
        return 'externaluser' + CURRENT_TIME + '@company.com';
    }
    
    // Default implementation to try to provide uniqueness
    //(To make the method visible in the test class)
    @testVisible
    private String generateEmail() {
        return 'externaluser' + CURRENT_TIME + '@company.com';
    }
    
    // Default implementation to try to provide uniqueness
    private String generateCommunityNickname() {
        return 'ExternalUser' + CURRENT_TIME;
    }
}