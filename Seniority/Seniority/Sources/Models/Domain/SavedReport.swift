import Foundation

// Appstorage KeyName : SavedReport
struct SavedReport: Codable {
    var responseText: String
    var recipient: String
    var savedAt: Date

    init(responseText: String, recipient: String) {
        self.responseText = responseText
        self.recipient = recipient
        self.savedAt = Date()
    }
}
