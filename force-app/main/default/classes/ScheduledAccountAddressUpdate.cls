public with sharing class ScheduledAccountAddressUpdate implements Schedulable {
  public ScheduledAccountAddressUpdate() {
  }

  public void execute(SchedulableContext ctx) {
    Database.executeBatch(new BatchApexDemo(), 10);
  }
}