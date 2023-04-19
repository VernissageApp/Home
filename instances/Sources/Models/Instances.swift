//
//  https://mczachurski.dev
//  Copyright © 2023 Marcin Czachurski and the repository contributors.
//  Licensed under the Apache License 2.0.
//

import Foundation

public class Instances: Codable {
    public var instructionsUrl = "https://pixelfed.org/how-to-join"
    public var serversUrl = "https://pixelfed.org/servers"
    public var instances: [Instance] = []
}
