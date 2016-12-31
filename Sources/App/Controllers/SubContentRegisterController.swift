import Vapor
import HTTP

class SubContentRegisterController: ResourceRepresentable {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }

    func makeResource() -> Resource<String>{
        return Resource(
            index: index,
            store: store
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {

        guard SessionManager.hasSession(request: request) else{
            let response = Response(redirect: "/login")
            return response
        }

        return try self.drop.view.make("subcontent-register", ViewUtil.contextIncludeHeader(request: request, context: [:], isSecure: true))
    }

    func store(request: Request) throws -> ResponseRepresentable {

        guard SecureUtil.verifyAuthenticityToken(drop: self.drop, request: request) else{
            return "Invalid request"
        }

        guard SessionManager.hasSession(request: request) else{
            return Response(redirect: "/")
        }

        var errorMessage = ""
        var successMessage = ""

        do{
            let subContentInput = try SubContentInput(request: request)
            let result = SubContentAccessor.register(input: subContentInput)

            (errorMessage, successMessage) = result ? ("", "登録しました") : ("登録失敗しました", "")
        }catch let validationError as ValidationErrorProtocol{

            (errorMessage, successMessage) = (validationError.message, "")            
        }

        let viewData: [String: Node] = [
            "title": Node(request.data["name"]?.string ?? ""),
            "content": Node(request.data["content"]?.string ?? ""),
            "error_message": Node(errorMessage), 
            "success_message": Node(successMessage)
        ]

        let context = ViewUtil.contextIncludeHeader(request: request, context: viewData, isSecure: true)

        return try self.drop.view.make("subcontent-register", context)
    }
}