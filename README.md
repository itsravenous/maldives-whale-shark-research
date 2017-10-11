# Maldives Whale Shark Research iOS App
## Prerequisites
- Xcode 9 and Swift 4
- [CocoaPods](https://cocoapods.org) 
## Getting started
### Install Pod dependencies
Nothing unusual here, just `pod install` and remember to open `MaldivesWhaleSharkResearch.xcworkspace` instead of the `.xcodeproj`.

### Install Swift Package Manager dependencies
Swift Package Manager isn't yet fully integrated for Xcode iOS projects. We use an approach based on https://github.com/j-channings/swift-package-manager-ios.

- Generate the dependencies Xcode project: `ruby generate-dependencies-project.rb` 
- Drag the generated `Dependencies.xcodeproj` into your project (at the top level).
- If you add new dependencies to `Package.swift` (or update the existing ones), regenerate this project (and drag it back in).


