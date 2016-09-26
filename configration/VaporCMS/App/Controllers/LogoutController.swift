import Vapor
import HTTP
import MySQL

class LogoutController: ResourceRepresentable{

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
        let response = Response(redirect: "/login")

        // TODO: アップデートしたら直す
        try? request.session().data["userid"] = nil
        return response
    }

    func store(request: Request) throws -> ResponseRepresentable {
        let response = Response(redirect: "/login")

        // TODO: アップデートしたら直す
        try? request.session().data["userid"] = nil
        return response
    }
}