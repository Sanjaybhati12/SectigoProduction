public with sharing class CaseResponseSchedule implements Schedulable
{
    public void execute(SchedulableContext ctx) 
    {
        caseAutoResponseBatch  car = new caseAutoResponseBatch();
        Database.executeBatch(car,Integer.valueOf(System.Label.Case_Auto_Response_Chunk_Size));
    }
}