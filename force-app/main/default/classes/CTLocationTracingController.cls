public with sharing class CTLocationTracingController {
  public CTLocationTracingController() {
  }

  public static List<Location_Tracing__c> getVisitors(String locationId) {
    List<Location_Tracing__c> allVisitors = [
      SELECT Id, Person__c, Location__c, Visit_Date__c, Name
      FROM Location_Tracing__c
      WHERE Location__c = :locationId
      ORDER BY Visit_Date__c DESC
    ];

    if (allVisitors.size() > 0) {
      return allVisitors;
    } else {
      return null;
    }
  }

  public static List<Location_Tracing__c> getLocationsByPersonId(
    Set<Id> personIds
  ) {
    List<Location_Tracing__c> allVisitors = [
      SELECT Id, Person__c, Location__c, Visit_Date__c, Name
      FROM Location_Tracing__c
      WHERE Person__c IN :personIds AND Visit_Date__c = LAST_N_DAYS:10
      ORDER BY Visit_Date__c DESC
    ];

    if (allVisitors.size() > 0) {
      return allVisitors;
    } else {
      return null;
    }
  }

  public static List<Location_Tracing__c> getLocationsByLocationId(
    Set<Id> locationIds
  ) {
    List<Location_Tracing__c> allVisitors = [
      SELECT Id, Person__c, Location__c, Visit_Date__c, Name
      FROM Location_Tracing__c
      WHERE
        Location__c IN :locationIds
        AND Person__r.Health_Status__c = 'Green'
        AND Visit_Date__c = LAST_N_DAYS:10
      ORDER BY Visit_Date__c DESC
    ];

    if (allVisitors.size() > 0) {
      return allVisitors;
    } else {
      return null;
    }
  }

  public static list<Location_Tracing__c> getDuplicates(
    List<Location_Tracing__c> newLocationTraces
  ) {
    Set<Id> locationIds = new Set<Id>();
    Set<Id> personIds = new Set<Id>();

    for (Location_Tracing__c ltr : newLocationTraces) {
      locationIds.add(ltr.Location__c);
      personIds.add(ltr.Person__c);
    }

    Map<Id, List<Location_Tracing__c>> existingLTRMap = new Map<Id, List<Location_Tracing__c>>();
    List<Location_Tracing__c> existingLTRList = [
      SELECT Id, Person__c, Location__c, Visit_Date__c, Name
      FROM Location_Tracing__c
      WHERE Location__c IN :locationIds AND Person__c IN :personIds
    ];
    for (Location_Tracing__c ltr : existingLTRList) {
      if (!existingLTRMap.containsKey(ltr.Location__c)) {
        existingLTRMap.put(
          ltr.Location__c,
          new List<Location_Tracing__c>{ ltr }
        );
      } else {
        existingLTRMap.get(ltr.Location__c).add(ltr);
      }
    }
    List<Location_Tracing__c> duplicateLTR = new List<Location_Tracing__c>();
    for (Location_Tracing__c ltr : newLocationTraces) {
      if (existingLTRMap.containsKey(ltr.Location__c)) {
        for (Location_Tracing__c lt : existingLTRMap.get(ltr.Location__c)) {
          if (
            lt.Person__c == ltr.Person__c &&
            lt.Visit_Date__c == ltr.Visit_Date__c
          ) {
            duplicateLTR.add(ltr);
          }
        }
      }
    }
    if (duplicateLTR.size() > 0) {
      return duplicateLTR;
    } else {
      return null;
    }
  }
}