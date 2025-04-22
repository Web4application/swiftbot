import Vapor
import Queues

struct MyScheduledTask: ScheduledJob {
func run(context: QueueContext) -> EventLoopFuture<Void> {
// Your task logic here
context.application.logger.info("Running scheduled task")
return context.eventLoop.makeSucceededFuture(())
}
}
