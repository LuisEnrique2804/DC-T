trigger PlanCliente on Account (
    before insert, before update, before delete, 
    after insert, after update, after delete, after undelete) {
		if(!DCT_TriggerExecutionControl_cls.hasAlreadyBeenExecuted('PlanCliente')){
        	new AccountTriggerHandler().run();
		}
    }