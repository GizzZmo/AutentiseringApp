import CloudKit

class CloudKitSubscriptionManager {
    private let container = CKContainer.default()
    private let privateDatabase = CKContainer.default().privateCloudDatabase

    func createSubscription() {
        let subscription = CKQuerySubscription(
            recordType: "UserData",
            predicate: NSPredicate(value: true),
            options: [.firesOnRecordCreation, .firesOnRecordUpdate]
        )

        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo

        privateDatabase.save(subscription) { _, _ in }
    }
}
