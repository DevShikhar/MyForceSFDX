public with sharing class CTPeopleTracingController {
  public CTPeopleTracingController() {
  }

  public static List<People_Tracing__c> getVisitors(String recordId) {
    List<People_Tracing__c> ptr = [
      SELECT
        Contact_Date__c,
        Contact_Type__c,
        Person_1__c,
        Person_2__c,
        Id,
        Name
      FROM People_Tracing__c
      WHERE Person_1__c = :recordId OR Person_2__c = :recordId
      ORDER BY Contact_Date__c DESC
    ];

    if (ptr.size() > 0) {
      return ptr;
    } else {
      return null;
    }
  }

  public static List<People_Tracing__c> getDuplicates(
    List<People_Tracing__c> peopleTraces
  ) {
    Set<Id> persons = new Set<Id>();

    for (People_Tracing__c ptr : peopleTraces) {
      persons.add(ptr.Person_1__c);
      persons.add(ptr.Person_2__c);
    }

    List<People_Tracing__c> existingPTR = [
      SELECT
        Contact_Date__c,
        Contact_Type__c,
        Person_1__c,
        Person_2__c,
        Id,
        Name
      FROM People_Tracing__c
      WHERE Person_1__c IN :persons AND Person_2__c IN :persons
    ];

    Map<Id, Set<People_Tracing__c>> existingPTRMap = new Map<Id, Set<People_Tracing__c>>();

    for (People_Tracing__c ptr : existingPTR) {
      if (!existingPTRMap.containsKey(ptr.Person_1__c)) {
        existingPTRMap.put(ptr.Person_1__c, new Set<People_Tracing__c>{ ptr });
      } else {
        existingPTRMap.get(ptr.Person_1__c).add(ptr);
      }
    }

    List<People_Tracing__c> duplicatePTR = new List<People_Tracing__c>();

    for (People_Tracing__c ptr : peopleTraces) {
      if (existingPTRMap.containsKey(ptr.Person_1__c)) {
        for (People_Tracing__c pt : existingPTRMap.get(ptr.Person_1__c)) {
          if (
            ptr.Person_2__c == pt.Person_2__c &&
            ptr.Contact_Date__c == pt.Contact_Date__c
          ) {
            duplicatePTR.add(ptr);
          }
        }
      }
      if (existingPTRMap.containsKey(ptr.Person_2__c)) {
        for (People_Tracing__c pt : existingPTRMap.get(ptr.Person_2__c)) {
          if (
            ptr.Person_1__c == pt.Person_2__c &&
            ptr.Contact_Date__c == pt.Contact_Date__c
          ) {
            duplicatePTR.add(ptr);
          }
        }
      }
    }
    if (duplicatePTR.size() > 0) {
      return duplicatePTR;
    } else {
      return null;
    }
  }
}