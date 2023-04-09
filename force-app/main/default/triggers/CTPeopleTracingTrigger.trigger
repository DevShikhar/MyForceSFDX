trigger CTPeopleTracingTrigger on People_Tracing__c(
  before insert,
  after insert,
  before update,
  after update,
  before delete,
  after delete,
  after undelete
) {
  TriggerDispatcher.run(
    new CTPeopleTracingTriggerHandler(),
    Trigger.OperationType
  );
}