//
//  https://mczachurski.dev
//  Copyright © 2023 Marcin Czachurski and the repository contributors.
//  Licensed under the Apache License 2.0.
//

import Foundation

/// Represents a user of Pixelfed and their associated profile.
public class Account: Codable {

    /// The account id.
    public let id: String

    /// The username of the account, not including domain.
    public let username: String

    /// The Webfinger account URI. Equal to username for local users, or username@domain for remote users.
    public let acct: String

    /// The profile’s display name.
    public let displayName: String?

    /// The location of the user’s profile page.
    public let url: URL?

    /// An image icon that is shown next to statuses and in the profile.
    public let avatar: URL?

    /// A static version of the avatar. Equal to avatar if its value is a static image; different if avatar is an animated GIF.
    public let avatarStatic: URL?

    /// An image banner that is shown above the profile and in profile cards.
    public let header: URL?

    /// A static version of the header. Equal to header if its value is a static image; different if header is an animated GIF.
    public let headerStatic: URL?

    /// Whether the account manually approves follow requests.
    public let locked: Bool

    /// When the account was created. String (ISO 8601 Datetime).
    public let createdAt: String

    /// The reported followers of this profile.
    public let followersCount: Int

    /// The reported follows of this profile.
    public let followingCount: Int

    /// How many statuses are attached to this account.
    public let statusesCount: Int

    /// Indicates that the account may perform automated actions, may not be monitored, or identifies as a robot.
    public let bot: Bool = false

    /// Indicates that the account represents a Group actor.
    public let group: Bool = false

    /// Whether the account has opted into discovery features such as the profile directory.
    public let discoverable: Bool?

    /// Whether the local user has opted out of being indexed by search engines.
    public let noindex: Bool?

    /// Indicates that the profile is currently inactive and that its user has moved to a new account.
    public let moved: Bool?

    /// An extra attribute returned only when an account is suspended.
    public let suspended: Bool?

    /// An extra attribute returned only when an account is silenced. If true, indicates that the account should be hidden behind a warning screen.
    public let limited: Bool?

    /// User website.
    public let website: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case acct
        case locked
        case createdAt = "created_at"
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case statusesCount = "statuses_count"
        case displayName = "display_name"
        case avatarStatic = "avatar_static"
        case headerStatic = "header_static"
        case url
        case avatar
        case header
        case bot
        case group
        case discoverable
        case noindex
        case moved
        case suspended
        case limited
        case website
    }
}
