import Foundation

enum MockData {
    // MARK: - Fixed IDs (stable across launches, Previews, tests)

    static let podcastId = UUID(uuidString: "A0000001-0001-4000-8000-000000000001")!
    static let episodeId = UUID(uuidString: "B0000002-0002-4000-8000-000000000002")!

    private static let commentIds: [UUID] = [
        UUID(uuidString: "C0000001-0001-4000-8000-000000000001")!,
        UUID(uuidString: "C0000002-0002-4000-8000-000000000002")!,
        UUID(uuidString: "C0000003-0003-4000-8000-000000000003")!,
        UUID(uuidString: "C0000004-0004-4000-8000-000000000004")!,
        UUID(uuidString: "C0000005-0005-4000-8000-000000000005")!,
        UUID(uuidString: "C0000006-0006-4000-8000-000000000006")!,
        UUID(uuidString: "C0000007-0007-4000-8000-000000000007")!,
        UUID(uuidString: "C0000008-0008-4000-8000-000000000008")!,
        UUID(uuidString: "C0000009-0009-4000-8000-000000000009")!,
        UUID(uuidString: "C000000A-000A-4000-8000-00000000000A")!,
        UUID(uuidString: "C000000B-000B-4000-8000-00000000000B")!,
        UUID(uuidString: "C000000C-000C-4000-8000-00000000000C")!,
        UUID(uuidString: "C000000D-000D-4000-8000-00000000000D")!,
        UUID(uuidString: "C000000E-000E-4000-8000-00000000000E")!,
        UUID(uuidString: "C000000F-000F-4000-8000-00000000000F")!,
    ]

    /// Anchor for relative `createdAt` values (deterministic).
    private static let createdAtAnchor: Date = {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(secondsFromGMT: 0)!
        return c.date(from: DateComponents(year: 2025, month: 3, day: 15, hour: 14, minute: 0))!
    }()

    private static func date(offsetMinutes: Int) -> Date {
        Calendar.current.date(byAdding: .minute, value: offsetMinutes, to: createdAtAnchor)!
    }

    // MARK: - Entities

    static let samplePodcast = Podcast(
        id: podcastId,
        title: "Deep Listen",
        author: "Alex Rivera",
        coverImageName: "CoverDeepListen"
    )

    static let sampleEpisode = Episode(
        id: episodeId,
        podcastId: podcastId,
        title: "How Technology Shapes Attention",
        description: "We unpack why notifications feel urgent and what actually helps you stay present. No productivity hacks—just honest talk about focus in a noisy world.",
        durationSeconds: 2300
    )

    /// Fifteen comments across 195 / 754 / 1100 / 1600 seconds (3 + 5 + 4 + 3).
    static let sampleComments: [ReactionComment] = [
        // 03:15 — 195 s (×3)
        ReactionComment(
            id: commentIds[0],
            episodeId: episodeId,
            timestampSeconds: 195,
            userName: "maya_k",
            content: "Okay this bit about inbox zero hit different—I literally paused here.",
            mood: .funny,
            likesCount: 2,
            createdAt: date(offsetMinutes: -320)
        ),
        ReactionComment(
            id: commentIds[1],
            episodeId: episodeId,
            timestampSeconds: 195,
            userName: "Jon P.",
            content: "Not me rewinding to catch that stat again. Wild.",
            mood: .thoughtful,
            likesCount: 12,
            createdAt: date(offsetMinutes: -180)
        ),
        ReactionComment(
            id: commentIds[2],
            episodeId: episodeId,
            timestampSeconds: 195,
            userName: "sofia listens",
            content: "Sending this clip to my group chat. The delivery is perfect.",
            mood: .surprising,
            likesCount: 45,
            createdAt: date(offsetMinutes: -45)
        ),

        // 12:34 — 754 s (×5)
        ReactionComment(
            id: commentIds[3],
            episodeId: episodeId,
            timestampSeconds: 754,
            userName: "benchwarmer99",
            content: "Hot take but I think they’re underselling how tired everyone is.",
            mood: .meaningful,
            likesCount: 3,
            createdAt: date(offsetMinutes: -900)
        ),
        ReactionComment(
            id: commentIds[4],
            episodeId: episodeId,
            timestampSeconds: 754,
            userName: "eli.nyc",
            content: "Paused to breathe. That line about ‘borrowed attention’ stuck with me.",
            mood: .thoughtful,
            likesCount: 67,
            createdAt: date(offsetMinutes: -840)
        ),
        ReactionComment(
            id: commentIds[5],
            episodeId: episodeId,
            timestampSeconds: 754,
            userName: "Rae☀️",
            content: "LOL the example with the group chat is too real.",
            mood: .funny,
            likesCount: 8,
            createdAt: date(offsetMinutes: -600)
        ),
        ReactionComment(
            id: commentIds[6],
            episodeId: episodeId,
            timestampSeconds: 754,
            userName: "devon",
            content: "Wait—did anyone else catch the nuance about defaults vs. intentions?",
            mood: .surprising,
            likesCount: 31,
            createdAt: date(offsetMinutes: -120)
        ),
        ReactionComment(
            id: commentIds[7],
            episodeId: episodeId,
            timestampSeconds: 754,
            userName: "nour",
            content: "This is the part I’ll quote later. Bookmarking.",
            mood: .meaningful,
            likesCount: 5,
            createdAt: date(offsetMinutes: -30)
        ),

        // 18:20 — 1100 s (×4)
        ReactionComment(
            id: commentIds[8],
            episodeId: episodeId,
            timestampSeconds: 1100,
            userName: "Chris O.",
            content: "Needed this reminder today. Thanks for not sugarcoating it.",
            mood: .meaningful,
            likesCount: 102,
            createdAt: date(offsetMinutes: -1500)
        ),
        ReactionComment(
            id: commentIds[9],
            episodeId: episodeId,
            timestampSeconds: 1100,
            userName: "tali_w",
            content: "The host’s laugh after that story—I’m grinning at my desk.",
            mood: .funny,
            likesCount: 14,
            createdAt: date(offsetMinutes: -720)
        ),
        ReactionComment(
            id: commentIds[10],
            episodeId: episodeId,
            timestampSeconds: 1100,
            userName: "marco_v",
            content: "Interesting tension between agency and environment here.",
            mood: .thoughtful,
            likesCount: 19,
            createdAt: date(offsetMinutes: -400)
        ),
        ReactionComment(
            id: commentIds[11],
            episodeId: episodeId,
            timestampSeconds: 1100,
            userName: "Anonymous Earbuds",
            content: "Hold up—I did not expect the pivot at the end of this segment.",
            mood: .surprising,
            likesCount: 6,
            createdAt: date(offsetMinutes: -90)
        ),

        // 26:40 — 1600 s (×3)
        ReactionComment(
            id: commentIds[12],
            episodeId: episodeId,
            timestampSeconds: 1600,
            userName: "ivy",
            content: "Saving this for my commute tomorrow. The outro lands.",
            mood: .thoughtful,
            likesCount: 4,
            createdAt: date(offsetMinutes: -2000)
        ),
        ReactionComment(
            id: commentIds[13],
            episodeId: episodeId,
            timestampSeconds: 1600,
            userName: "sam-s",
            content: "If you’re still listening: same. That closing thought was fire.",
            mood: .funny,
            likesCount: 28,
            createdAt: date(offsetMinutes: -300)
        ),
        ReactionComment(
            id: commentIds[14],
            episodeId: episodeId,
            timestampSeconds: 1600,
            userName: "river_j",
            content: "This episode changed how I’ll set boundaries with my phone. For real.",
            mood: .meaningful,
            likesCount: 88,
            createdAt: date(offsetMinutes: -60)
        ),
    ]

    // MARK: - Derived API (single source of truth)

    /// All distinct timestamp seconds for this episode’s comments, ascending.
    static var highlightTimestampsSeconds: [Int] {
        Set(sampleComments.map(\.timestampSeconds)).sorted()
    }

    /// Comments grouped by anchor second (handy for tests / debugging).
    static func commentsGroupedByTimestamp() -> [Int: [ReactionComment]] {
        Dictionary(grouping: sampleComments, by: \.timestampSeconds)
    }

    #if DEBUG
    static func dumpCommentsForDebugging() {
        for c in sampleComments {
            print("[\(c.timestampSeconds)s] \(c.userName) | likes:\(c.likesCount) | \(c.createdAt) | \(c.content.prefix(40))…")
        }
        print("highlightTimestampsSeconds:", highlightTimestampsSeconds)
    }
    #endif
}
