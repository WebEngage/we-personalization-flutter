### Version 2.1.0 (November 2, 2026)
* **Swift Package Manager:** added support for `webengage-ios-sdk` **2.x** (WebEngage iOS SDK **7.x**). The supported range is now `1.0.0 ..< 3.0.0`, so both iOS SDK 6.x and 7.x work.
* **CocoaPods:** no change.
* No Dart API changes.
* **Existing SPM apps:** to move to iOS SDK 7.x, update your packages in Xcode (**File ▸ Packages ▸ Update to Latest Package Versions**) or delete `Package.resolved`. If another plugin in your app still limits `webengage-ios-sdk` to 1.x, SPM keeps 1.x until that plugin is updated.

### Version 2.0.0 (May 8, 2026)
* Added Swift Package Manager (SPM) support for iOS.
* Restructured iOS source files to follow SPM conventions.
* Updated minimum iOS deployment target to 13.0.

### Version 1.1.1 (June 19, 2025)
* Resolved an issue with incorrect layout direction in Flutter, ensuring proper support for RTL and LTR languages.

### Version 1.1.0 (January 7, 2025)
* Added support for control groups.
* Optimized the plugin for impressions.

### Version 1.0.4 (January 2, 2025)
* Namespace added.
* Fixed view issue encountered while building with the latest Flutter plugin.

### Version 1.0.3 (September 12, 2023)
* Hotfix : support to Isolate

### Version 1.0.2 (August 23, 2023)
* Hotfix : Null Safety - WEInlineView

### Version 1.0.1 (March 22, 2023)
* Hotfix : Null Safety - onPlaceholderException Callback

### Version 1.0.0 (March 22, 2023)
* Initial Release.
* Supports WebEngage Android SDK v4.3.0+
* Supports WebEngage Personalization Android SDK v1.1.0+
* Supports WebEngage iOS SDK v6.2.0+
* Supports WebEngage Personalization iOS SDK v1.1.0+
* Supports WebEngage Flutter Plugin v1.2.3+
