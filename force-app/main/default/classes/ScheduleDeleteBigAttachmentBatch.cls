global class ScheduleDeleteBigAttachmentBatch implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        // Implement any logic to be scheduled
       
        // We now call the batch class to be scheduled
        Com_DeleteBigAttachmentBatch b = new Com_DeleteBigAttachmentBatch();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,200);
    }
   
}