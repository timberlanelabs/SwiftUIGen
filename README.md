# SwiftUIGen

A utility to generate `PreviewDevice` presets from the available devices

### Installation
 
 - Plugins!

`SwiftUIGen` has been updated to support build tool and command plugins for Xcode and SPM. Simply add this package as a dependency and generate code however suits your workflow.

Add the `SwiftUIGen` tool to your `Package.swift` or Xcode Package Dependencies

```swift
.package(url: "https://github.com/timberlanelabs/SwiftUIGen", branch: "main")
```

And that's it!. It doesn't need to be added to any targets for the plugins to become available.
 
 - Manual
 
Go to the GitHub page for the [latest release](https://github.com/timberlanelabs/SwiftUIGen/releases/latest) <br>
Download the `swiftuigen.zip` file associated with that release<br>
Extract the content of the zip archive in your project directory
 
 - Homebrew
 
```terminal
$ brew tap timberlanelabs/tap
$ brew install swiftuigen
```

### Usage
To generate a file containing the preview devices simply run:

```terminal
swiftuigen previews --output file.swift
```

Add the file to your project and you can then use them in your SwiftUI previews:

```swift
struct MyApp_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
            .previewDevice(.iPhone(.iPhone11))
    }
}
```

This _could_ be run as part of a build phase if that is desirable, however this could result in some git 'nosiness' if different team members have 
different devices so it may be more advantageous to only run this periodically as needed.
