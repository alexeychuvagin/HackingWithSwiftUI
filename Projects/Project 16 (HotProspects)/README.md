# Hot Prospects
## [Introduction](https://www.hackingwithswift.com/books/ios-swiftui/hot-prospects-introduction) 

In this project we’re going to build Hot Prospects, which is an app to track who you meet at conferences. You’ve probably seen apps like it before: it will show a QR code that stores your attendee information, then others can scan that code to add you to their list of possible leads for later follow up.

That might sound easy enough, but along the way we’re going to cover stacks of really important new techniques: creating tab bars and context menus, sharing custom data using the environment, sending custom change notifications, and more. The resulting app is awesome, but what you learn along the way will be particularly useful!

## [Reading custom values from the environment with @EnvironmentObject](https://www.hackingwithswift.com/books/ios-swiftui/reading-custom-values-from-the-environment-with-environmentobject)

**@State** is used to work with state that is local to a single view.

**@ObservedObject** lets us pass one object from view to view so we can share it.

**@EnvironmentObject** lets us place an object into the environment so that any child view can automatically have access to it.

Environment objects use the same ObservableObject protocol, and SwiftUI will automatically make sure all views that share the same environment object get updated when it changes.

*If @EnvironmentObject can’t find an object in the environment your code will just crash, so please be careful.*

**How @EnvironmentObject works**

Well, you’ve seen how dictionaries let us use one type for the key and another for the value. The environment effectively lets us use data types themselves for the key, and instances of the type as the value. This is a bit mind bending at first, but imagine it like this: the keys are things like Int, String, and Bool, with the values being things like 5, “Hello”, and true, which means we can say “give me the Int” and we’d get back 5.

## [TabView](https://www.hackingwithswift.com/books/ios-swiftui/creating-tabs-with-tabview-and-tabitem)

```swift
TabView {
    Text("Tab 1")
        .tabItem {
            Image(systemName: "star")
            Text("One")
        }

    Text("Tab 2")
        .tabItem {
            Image(systemName: "star.fill")
            Text("Two")
        }
}
```
*Now, you can if you want try to add more views into the tabItem() modifier, or perhaps rearrange them so the text view comes before the image view, but it doesn’t matter: SwiftUI will always show no more than one image and no more than one text view, in that order.*

**How to control the current view programmatically using state**

1. Create an @State property to track the tab that is currently showing.
2. Modify that property to a new value whenever we want to jump to a different tab.
3. Pass that as a binding into the TabView, so it will be tracked automatically.
4. Tell SwiftUI which tab should be shown for each value of that property.

```swift
@State private var selectedView = 0
    
var body: some View {
    TabView(selection: $selectedView) {
        Text("Tab 1")
            .onTapGesture {
                self.selectedView = 0
            }
            .tabItem {
                Image(systemName: "star")
                Text("One")
            }
            .tag(0)
            
        Text("Tab 2")
            .onTapGesture {
                self.selectedView = 1
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Two")
            }
            .tag(1)
    }
}
```

## [Result Type](https://www.hackingwithswift.com/books/ios-swiftui/understanding-swifts-result-type)

```swift
enum NetworkError: Error {
    case badURL, requestFailed, unknown
}
    
func fetchData(from urlString: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
    // check the URL is OK, otherwise return with a failure
    guard let url = URL(string: urlString) else {
        completion(.failure(.badURL))
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        // the task has completed – push our work back to the main thread
        DispatchQueue.main.async {
            if let data = data {
                // success: convert the data to a string and send it back
                let stringData = String(decoding: data, as: UTF8.self)
                completion(.success(stringData))
            } else if error != nil {
                // any sort of network failure
                completion(.failure(.requestFailed))
            } else {
                // this ought not to be possible, yet here we are
                completion(.failure(.unknown))
            }
        }
    }.resume()
}

Text("Hello, World!")
    .onAppear {
        self.fetchData(from: "https://www.apple.com") { result in
            switch result {
            case .success(let str):
                print(str)
            case .failure(let error):
                switch error {
                case .badURL:
                    print("Bad URL")
                case .requestFailed:
                    print("Network problems")
                case .unknown:
                    print("Unknown error")
                }
            }
        }
    }
```

## [Manually publishing ObservableObject changes](https://www.hackingwithswift.com/books/ios-swiftui/manually-publishing-observableobject-changes)

```swift
final class DelayedUpdated: ObservableObject {
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var updater = DelayedUpdated()
    
    var body: some View {
        Text("Value is: \(updater.value)")
    }
}
```

## [Context menu](https://www.hackingwithswift.com/books/ios-swiftui/creating-context-menus)

SwiftUI lets us attach context menus to objects to provide this extra functionality, all done using the contextMenu() modifier. You can pass this a selection of buttons and they’ll be shown in order, so we could build a simple context menu to control a view’s background color like this:

```swift
@State private var backgroundColor = Color.red
    
var body: some View {
    VStack {
        Text("Hello World!")
            .padding()
            .background(backgroundColor)
            
        Text("Change Color")
            .padding()
            .contextMenu {
                Button(action: { self.backgroundColor = Color.red }) {
                    Text("Red")
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.red)
                }
                Button(action: { self.backgroundColor = Color.green }) {
                    Text("Green")
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                Button(action: { self.backgroundColor = Color.blue }) {
                    Text("Blue")
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
    }
}
```

### Tips
1. If you’re going to use them, use them in lots of places – it can be frustrating to press and hold on something only to find nothing happens.
2. Keep your list of options as short as you can – aim for three or less.
3. Don’t repeat options the user can already see elsewhere in your UI.

## [Scheduling local notifications](https://www.hackingwithswift.com/books/ios-swiftui/scheduling-local-notifications)

```swift
import UserNotifications

Button("Request Permission") {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("All set!")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }
}

Button("Schedule Notification") {
    // The content is what should be shown, and can be a title, subtitle, sound, image, and so on.
    let content = UNMutableNotificationContent()
    content.title = "Feed the cat"
    content.subtitle = "It looks hungry"
    content.sound = UNNotificationSound.default

    // The trigger determines when the notification should be shown, and can be a number of seconds from now, a date and time in the future, or a location.
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

    // The request combines the content and trigger, but also adds a unique identifier so you can edit or remove specific alerts later on. If you don’t want to edit or remove stuff, use UUID().uuidString to get a random identifier.
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    // add our notification request
    UNUserNotificationCenter.current().add(request)
}
```

## Summary

This was our largest project yet, but the end result is another really useful app that could easily form the starting point for a real conference. Along the way we also learned about custom environment objects, TabView, Result, objectWillChange, image interpolation, context menus, local notifications, Swift package dependencies, filter() and map(), and so much more – it’s been packed!

## Preview

<img src="./Preview/preview.gif" width="300">