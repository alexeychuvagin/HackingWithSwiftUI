# Accessibility
### [Project 15](https://www.hackingwithswift.com/books/ios-swiftui/accessibility-introduction)

## Introduction

Making your app accessible means taking steps to ensure that everyone can use it fully regardless of their individual needs. For example, if they are blind then your app should work well with the system’s VoiceOver system to ensure your UI can be read smoothly.

SwiftUI gives us a huge amount of functionality for free, because its layout system of VStack and HStack naturally forms a flow of views. However, it isn’t perfect, and any time you can add some extra information to help out the iOS accessibility system it’s likely to help.

## Remarks

**.accessibility(label:)** - The label is read immediately, and should be a short piece of text that gets right to the point. If this view deletes an item from the user’s data, it might say “Delete”.

**.accessibility(hint:)** - The hint is read after a short delay, and should provide more details on what the view is there for. It might say “Deletes an email from your inbox”, for example.

**.accessibility(addTraits: .isButton)** - This lets us provide some extra behind the scenes information to VoiceOver that describes how the view works, and in our case we can tell it that our image is also a button by adding this modifier.

**.accessibility(removeTraits: .isImage)** - This removes some traits from a view.

**.accessibility(hidden: true/false)** - This makes any view completely invisible to the accessibility system.

**.accessibilityElement(children: .combine)** -This combines children into a single accessibility element (with pause).

**.accessibilityElement(children: .ignore)** - This makes child views are invisible to VoiceOver.

```swift
VStack {
    Text("Your score is")
    Text("1000")
        .font(.title)
}
.accessibilityElement(children: .ignore)
.accessibility(label: Text("Your score is 1000"))
```

**.accessibility(value:)** - This relaces value description of a view. A good example of this is the Slider control, which VoiceOver reads out as a series of percentages. If you’re using percentages then this makes sense, but if you aren’t then you can override the value VoiceOver reads out by using this modifier to provide some alternative text.

```swift
Stepper("Rate our service: \(rating)/5", value: $rating, in: 1...5)
    .accessibility(value: Text("\(rating) out of 5"))
```

## Summary

This project does not contain any meaningful code, it is just a sandbox for testing accessibility.