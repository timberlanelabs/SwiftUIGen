# SwiftUIGen

A utility to generate `PreviewDevice` presets from the available devices

### Installation
 
 - Manual
 
Go to the GitHub page for the [latest release](https://github.com/timberlanelabs/SwiftUIGen/releases/latest) <br>
Download the `swiftuigen.zip` file associated with that release<br>
Extract the content of the zip archive in your project directory
 
 - Homebrew
 
```terminal
$ brew update
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
