import Foundation

enum TimeFormatter {
    /// Formats whole seconds as `m:ss` / `mm:ss` (demo: no fractional seconds).
    static func mmss(from totalSeconds: Int) -> String {
        let s = max(0, totalSeconds)
        let m = s / 60
        let r = s % 60
        return String(format: "%d:%02d", m, r)
    }
}
