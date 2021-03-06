import FluentProvider
import Validation

final class Article: Model, Timestampable, JSONRepresentable {
    
    let storage = Storage()
    var title: String
    var content: String
    var isPublished: Bool
    
    init(request: Request) throws {
        
        title = request.data["title"]?.string ?? ""
        content = request.data["content"]?.string ?? ""
        isPublished = true
        
        try validate()
    }
    
    func validate() throws {
        
        try title.validated(by: Count.containedIn(low: 1, high: 100))
        try content.validated(by: Count.containedIn(low: 1, high: 10000))
    }
    
    required init(row: Row) throws {
        title = try row.get("title")
        content = try row.get("content")
        isPublished = try row.get("is_published")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("title", title)
        try row.set("content", content)
        try row.set("is_published", isPublished)
        return row
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("title", title)
        try json.set("content", content)
        try json.set("is_published", isPublished)
        try json.set("createdAt", formattedCreatedAt)
        try json.set("updatedAt", formattedUpdatedAt)
        return json
    }
}

// MARK: - Preparation
extension Article: Preparation {
    
    static func prepare(_ database: Fluent.Database) throws {}
    
    static func revert(_ database: Fluent.Database) throws {}
}

extension Article: Paginatable {}

extension Article: Updateable {
    
    func update(for req: Request) throws {
        
        title = req.data["title"]?.string ?? ""
        content = req.data["content"]?.string ?? ""
        isPublished = true
        
        try validate()
    }
    
    static var updateableKeys: [UpdateableKey<Article>] {
        return []
    }
}
