public with sharing class CTLocationTriggerHandler implements MyTriggerInterface {
  public CTLocationTriggerHandler() {
  }

  public void beforeInsert(List<SObject> newRecordList) {
    List<Location__c> newLocationList = (List<Location__c>) newRecordList;
    for (Location__c loc : newLocationList) {
      loc.Status__c = 'Green';
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
    Map<id, Location__c> newLocationMap = (Map<Id, Location__c>) newRecordMap;
    Map<id, Location__c> oldLocationMap = (Map<Id, Location__c>) oldRecordMap;

    for (Location__c loc : newLocationMap.values()) {
      if (loc.status__c != oldLocationMap.get(loc.id).status__c) {
        loc.status_update_date__c = Date.Today();
      }
    }
  }
  public void afterUpdate(
    Map<Id, SObject> oldRecordMap,
    Map<Id, SObject> newRecordMap
  ) {
    Map<id, Location__c> newLocationMap = (Map<Id, Location__c>) newRecordMap;
    Map<id, Location__c> oldLocationMap = (Map<Id, Location__c>) oldRecordMap;
    Set<Id> RedlocationIds = new Set<Id>();
    for (Location__c loc : newLocationMap.values()) {
      if (
        loc.status__c != oldLocationMap.get(loc.id).status__c &&
        loc.status__c == 'Red'
      ) {
        RedlocationIds.add(loc.id);
      }
    }
    List<Location_Tracing__c> Ltrace = CTLocationTracingController.getLocationsByLocationId(
      RedlocationIds
    );
    List<Id> personIds = new List<Id>();
    List<Person__c> personToUpdate = new List<Person__c>();

    if (Ltrace != null && Ltrace.size() > 0) {
      for (Location_Tracing__c ltr : Ltrace) {
        personIds.add(ltr.Person__c);
      }
      for (Id pid : personIds) {
        personToUpdate.add(
          new Person__c(id = pid, Health_Status__c = 'Yellow')
        );
      }
    }
    Database.SaveResult[] sr = Database.update(personToUpdate, false);
    for (Database.SaveResult res : sr) {
      if (!res.isSuccess()) {
        for (Database.Error err : res.getErrors()) {
          System.debug(err.getMessage());
        }
      }
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