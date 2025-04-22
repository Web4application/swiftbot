import Queues
import Vapor

struct MyScheduledTask: ScheduledJob {
    func run(context: QueueContext) -> EventLoopFuture<Void> {
        context.logger.info("Running MyScheduledTask at midnight.")
        // Add your task logic here
        return context.eventLoop.makeSucceededFuture(())
    }
}
