public with sharing class CTPeopleTracingTriggerHandler implements MyTriggerInterface {
  public CTPeopleTracingTriggerHandler() {
  }
  public void beforeInsert(List<SObject> newRecordList) {
    List<People_Tracing__c> newPtrRecord = (List<People_Tracing__c>) newRecordList;
    List<People_Tracing__c> peopleTraces = CTPeopleTracingController.getDuplicates(
      newPtrRecord
    );
    if (peopleTraces != null) {
      for (People_Tracing__c ptr : peopleTraces) {
        ptr.addError(
          'Duplicate record found. Person_1: ' +
            ptr.Person_1__c +
            ' and Person_2: ' +
            ptr.Person_2__c +
            ' already exist'
        );
      }
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
  }
  public void afterUpdate(
    Map<Id, SObject> oldRecordMap,
    Map<Id, SObject> newRecordMap
  ) {
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