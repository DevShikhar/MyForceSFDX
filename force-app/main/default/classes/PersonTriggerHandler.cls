public with sharing class PersonTriggerHandler implements MyTriggerInterface {
  public PersonTriggerHandler() {
  }

  public void beforeInsert(List<SObject> newRecordList) {
    List<Person__c> newPersonRecords = (List<Person__c>) newRecordList;
    for (Person__c pr : newPersonRecords) {
      pr.Token__c = CTPersonController.getToken(pr.Mobile__c);
      pr.Health_Status__c = 'Green';
    }
  }
  public void afterInsert(
    List<SObject> newRecordList,
    Map<Id, SObject> newRecordMap
  ) {
  }
  public void beforeUpdate(
    Map<Id, SObject> oldRecordMap,
    Map<Id, SObject> newRecordMap
  ) {
    Map<Id, Person__c> newPersonMap = (Map<Id, Person__c>) newRecordMap;
    Map<Id, Person__c> oldPersonMap = (Map<Id, Person__c>) oldRecordMap;

    for (Person__c pr : newPersonMap.values()) {
      if (
        !pr.Health_Status__c.equals(oldPersonMap.get(pr.Id).Health_Status__c)
      ) {
        pr.Status_Update_Date__c = Date.today();
      }
    }
  }
  public void afterUpdate(
    Map<Id, SObject> oldRecordMap,
    Map<Id, SObject> newRecordMap
  ) {
    Map<Id, Person__c> newPersonMap = (Map<Id, Person__c>) newRecordMap;
    Map<Id, Person__c> oldPersonMap = (Map<Id, Person__c>) oldRecordMap;

    Set<Id> statusChange = new Set<Id>();
    Set<Id> redStatusChange = new Set<Id>();
    for (Person__c pr : newPersonMap.values()) {
      if (pr.Health_Status__c != oldPersonMap.get(pr.id).Health_Status__c) {
        statusChange.add(pr.Id);
      }

      if (
        pr.Health_Status__c == 'Red' &&
        pr.Health_Status__c != oldPersonMap.get(pr.id).Health_Status__c
      ) {
        redStatusChange.add(pr.Id);
      }
    }

    List<Person__c> updateToOrange = new List<Person__c>();
    List<Person__c> updateToYellow = new List<Person__c>();

    Set<Id> cohabitantIDs = CTPersonController.getCohabitants(redStatusChange);
    for (Id personId : cohabitantIDs) {
      updateToOrange.add(
        new Person__c(id = personId, Health_Status__c = 'Orange')
      );
    }

    Set<Id> PrimaryIDs = CTPersonController.getPrimary(redStatusChange);
    for (Id personId : PrimaryIDs) {
      updateToOrange.add(
        new Person__c(id = personId, Health_Status__c = 'Orange')
      );
    }
    if (updateToOrange.size() > 0) {
      update updateToOrange;
    }
    Set<Id> neighbourIDs = CTPersonController.getNeighbours(redStatusChange);
    for (Id personId : neighbourIDs) {
      updateToYellow.add(
        new Person__c(id = personId, Health_Status__c = 'Yellow')
      );
    }

    Set<Id> SecondaryIds = CTPersonController.getSecondary(PrimaryIDs);
    for (Id personId : SecondaryIds) {
      updateToYellow.add(
        new Person__c(id = personId, Health_Status__c = 'Yellow')
      );
    }
    if (updateToYellow.size() > 0) {
      update updateToYellow;
    }

    List<Location_Tracing__c> locationsVisited = CTLocationTracingController.getLocationsByPersonId(
      statusChange
    );
    if (locationsVisited != null && locationsVisited.size() > 0) {
      CTLocationController.UpdateRedScore(locationsVisited);
    }
  }
  public void beforeDelete(
    List<SObject> oldRecordList,
    Map<Id, SObject> oldMapRecord
  ) {
  }
  public void afterDelete(Map<Id, SObject> oldRecordMap) {
  }
  public void afterUndelete(
    List<SObject> newRecordList,
    Map<id, SObject> newRecordMap
  ) {
  }
}