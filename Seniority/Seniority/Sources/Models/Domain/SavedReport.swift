import Foundation

// Appstorage KeyName : SavedReport
struct SavedReport: Codable {
    var responseText: String
    
    var recipient: String
    
    var sendTimeString: String
    
    var savedAt: String
    
    init(responseText: String, recipient: String, sendTimeString: String) {
        self.responseText = responseText
        self.recipient = recipient
        self.sendTimeString = sendTimeString
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        self.savedAt = formatter.string(from: Date())
    }
}
