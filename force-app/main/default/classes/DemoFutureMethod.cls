public with sharing class DemoFutureMethod {
  public DemoFutureMethod() {
  }
  @future
  public static void insertUserWithRole(
    String uname,
    String al,
    String em,
    String lname,
    String profilename,
    String rolename
  ) {
    Profile p = [SELECT Id FROM Profile WHERE Name = :profilename];
    UserRole r = [SELECT Id FROM UserRole WHERE Name = :rolename];
    // Create new user with a non-null user role ID
    User u = new User(
      alias = al,
      email = em,
      emailencodingkey = 'UTF-8',
      lastname = lname,
      languagelocalekey = 'en_US',
      localesidkey = 'en_US',
      profileid = p.Id,
      userroleid = r.Id,
      timezonesidkey = 'America/Los_Angeles',
      username = uname
    );
    insert u;
  }
}