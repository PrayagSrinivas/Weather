
import Foundation


// MARK: - Strings

internal enum GlobalText {
  /// Add
  internal static let add = GlobalText.tr("Localizable", "add")
  /// Cancel
  internal static let cancel = GlobalText.tr("Localizable", "cancel")
  /// Done
  internal static let done = GlobalText.tr("Localizable", "done")
  /// Feels like %@
  internal static func feelsLike(_ p1: Any) -> String {
    return GlobalText.tr("Localizable", "feels_like", String(describing: p1))
  }
  /// No Results
  internal static let noSearchResults = GlobalText.tr("Localizable", "no_search_results")
  /// Search for a location
  internal static let searchLocationPlaceholder = GlobalText.tr("Localizable", "search_location_placeholder")
  /// Weather
  internal static let weatherTitle = GlobalText.tr("Localizable", "weather_title")
}

// MARK: - Implementation Details
extension GlobalText {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
