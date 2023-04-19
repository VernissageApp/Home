//
//  https://mczachurski.dev
//  Copyright © 2023 Marcin Czachurski and the repository contributors.
//  Licensed under the Apache License 2.0.
//

import Foundation

public struct Metadata: Codable {
    public let instructionsUrl: String
    public let serversUrl: String
    public let instances: [String]
    
    init(instructionsUrl: String, serversUrl: String, instances: [String]) {
        self.instructionsUrl = instructionsUrl
        self.serversUrl = serversUrl
        self.instances = instances
    }
}
