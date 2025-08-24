import Foundation

// Appstorage KeyName : SavedReport
struct SavedReport: Codable {
    var responseText: AttributedString
    var recipient: String
    var savedAt: Date

    init(responseText: String, recipient: String) {
        do {
            self.responseText = try AttributedString(markdown: responseText)
        } catch {
            self.responseText = AttributedString(responseText)
        }
        self.recipient = recipient
        self.savedAt = Date()
    }
}
