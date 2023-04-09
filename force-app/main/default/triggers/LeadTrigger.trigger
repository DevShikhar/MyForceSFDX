trigger LeadTrigger on Lead (before insert, before Update) {
    for(Lead leadRecord : Trigger.New){
        if(trigger.isBefore && trigger.isUpdate){
            if((leadRecord.Status == 'Closed - Converted' || leadRecord.Status == 'Closed - Not Converted') && (Trigger.oldMap.get(leadRecord.Id).status == 'Open - Not Contacted')){
                leadRecord.addError('Cannot closed without contacting customer');
            }
    	}
    }
}