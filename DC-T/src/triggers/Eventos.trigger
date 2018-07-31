trigger Eventos on Event (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    new EventTriggerHandler().run();
}