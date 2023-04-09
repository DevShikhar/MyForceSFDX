public with sharing class CTPersonController {
  public CTPersonController() {
  }

  public static String getToken(String mobile) {
    Blob targetBlob = Blob.valueOf(mobile);
    Blob hash = Crypto.generateDigest('MD5', targetBlob);

    return EncodingUtil.base64Encode(hash);
  }

  public static List<Person__c> getRecentHealthChanges() {
    List<Person__c> allPerson = [
      SELECT
        Id,
        Name,
        Health_Status__c,
        Mobile__c,
        Status_Update_Date__c,
        Token__c
      FROM Person__c
      ORDER BY Status_Update_Date__c DESC
    ];
    if (allPerson.size() > 0) {
      return allPerson;
    } else {
      return null;
    }
  }

  public static List<Person__c> searchPeople(String searchTerm) {
    List<Person__c> allPerson = [
      SELECT
        Id,
        Name,
        Health_Status__c,
        Mobile__c,
        Status_Update_Date__c,
        Token__c
      FROM Person__c
      WHERE
        name LIKE :searchTerm
        OR Mobile__c LIKE :searchTerm
        OR Token__c LIKE :searchTerm
      ORDER BY Status_Update_Date__c DESC
    ];
    if (allPerson.size() > 0) {
      return allPerson;
    } else {
      return null;
    }
  }

  public static Person__c getPersonById(String personId) {
    List<Person__c> allPerson = [
      SELECT
        Id,
        Name,
        Health_Status__c,
        Mobile__c,
        Status_Update_Date__c,
        Token__c
      FROM Person__c
      WHERE ID = :personId
    ];
    if (allPerson.size() > 0) {
      return allPerson[0];
    } else {
      return null;
    }
  }

  public static Map<String, Integer> getHealthStatusCount() {
    Map<String, Integer> healthStatusCount = new Map<String, Integer>();
    for (AggregateResult agr : [
      SELECT Health_Status__c, count(id) countOfPerson
      FROM Person__c
      GROUP BY Health_Status__c
    ]) {
      healthStatusCount.put(
        String.valueOf(agr.get('Health_Status__c')),
        Integer.valueOf(agr.get('countOfPerson'))
      );
    }
    if (healthStatusCount.keySet().size() > 0) {
      return healthStatusCount;
    } else {
      return null;
    }
  }

  public static Set<Id> getCohabitants(Set<Id> personIds) {
    List<String> HStatus = new List<String>{ 'Green', 'Yellow' };
    Set<ID> cohabitantIDs = new Set<Id>();

    for (People_Tracing__c ptr : [
      SELECT Id, Person_1__c, Person_2__c, Contact_Type__c
      FROM People_Tracing__c
      WHERE
        Contact_Type__c = 'Cohabitant'
        AND (Person_1__c IN :personIds
        OR Person_2__c IN :personIds)
        AND (Person_1__r.Health_Status__c IN :HStatus
        OR Person_2__r.Health_Status__c IN :HStatus)
    ]) {
      if (!personIds.contains(ptr.Person_1__c)) {
        cohabitantIDs.add(ptr.Person_1__c);
      } else {
        cohabitantIDs.add(ptr.Person_2__c);
      }
    }
    return cohabitantIDs;
  }

  public static Set<Id> getNeighbours(Set<Id> personIds) {
    Set<ID> neighbourIds = new Set<Id>();

    for (People_Tracing__c ptr : [
      SELECT Id, Person_1__c, Person_2__c, Contact_Type__c
      FROM People_Tracing__c
      WHERE
        Contact_Type__c = 'Neighbour'
        AND (Person_1__c IN :personIds
        OR Person_2__c IN :personIds)
        AND (Person_1__r.Health_Status__c = 'Green'
        OR Person_2__r.Health_Status__c = 'Green')
    ]) {
      if (!personIds.contains(ptr.Person_1__c)) {
        neighbourIds.add(ptr.Person_1__c);
      } else {
        neighbourIds.add(ptr.Person_2__c);
      }
    }
    return neighbourIds;
  }

  public static Set<Id> getPrimary(Set<Id> personIds) {
    List<String> HStatus = new List<String>{ 'Green', 'Yellow' };
    Set<ID> primaryIDs = new Set<Id>();

    for (People_Tracing__c ptr : [
      SELECT Id, Person_1__c, Person_2__c, Contact_Type__c
      FROM People_Tracing__c
      WHERE
        Contact_Type__c = 'Other'
        AND Contact_Date__c = LAST_N_DAYS:10
        AND (Person_1__c IN :personIds
        OR Person_2__c IN :personIds)
        AND (Person_1__r.Health_Status__c IN :HStatus
        OR Person_2__r.Health_Status__c IN :HStatus)
    ]) {
      if (!personIds.contains(ptr.Person_1__c)) {
        primaryIDs.add(ptr.Person_1__c);
      } else {
        primaryIDs.add(ptr.Person_2__c);
      }
    }
    return primaryIDs;
  }

  public static Set<Id> getSecondary(Set<Id> primaryPersonIDs) {
    List<String> HStatus = new List<String>{ 'Green', 'Yellow' };
    Set<ID> secondaryIDs = new Set<Id>();

    for (People_Tracing__c ptr : [
      SELECT Id, Person_1__c, Person_2__c, Contact_Type__c
      FROM People_Tracing__c
      WHERE
        Contact_Type__c = 'Other'
        AND Contact_Date__c = LAST_N_DAYS:10
        AND (Person_1__c IN :primaryPersonIDs
        OR Person_2__c IN :primaryPersonIDs)
        AND (Person_1__r.Health_Status__c IN :HStatus
        OR Person_2__r.Health_Status__c IN :HStatus)
    ]) {
      if (!primaryPersonIDs.contains(ptr.Person_1__c)) {
        secondaryIDs.add(ptr.Person_1__c);
      } else {
        secondaryIDs.add(ptr.Person_2__c);
      }
    }
    return secondaryIDs;
  }
}