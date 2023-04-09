trigger PersonTrigger on Person__c(
  before insert,
  after insert,
  before update,
  after update,
  before delete,
  after delete,
  after undelete
) {
  TriggerDispatcher.run(new PersonTriggerHandler(), Trigger.operationType);
}