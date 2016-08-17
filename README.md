# MK2Router

MK2Router is a view controller routing utility for Swift.

See also: Qiita(Japanese) http://qiita.com/imk2o/items/8a46cfeaede7cbba4dcb

## Requirements

* iOS 8.0+
* Xcode 7.3+
* Swift 2.2

## Install

### Carthage

Add the following line to your `Cartfile`.

```
github 'imk2o/MK2Router' ~> 1.0.0
```

Run `carthage update` to build the framework and drag the built `MK2Router.framework` into your Xcode project.

### CocoaPods

Add the following line to your `Podfile`.

```
pod 'MK2Router', '~> 1.0.0'
```

Run `pod install` and open your Xcode workspace.

## Usage

### The DestinationType protocol

The `DestinationType` protocol indicates that the routable destination view controller.
Declare `typealias Context` that the required parameter type for routing.

```
class ItemDetailViewController: UIViewController, DestinationType {
  typealias Context = Int

  ...
}
```

The `UIViewController#context` property refers to passed parameters.

```
override func viewDidLoad() {
    super.viewDidLoad()

    let itemID: Int = self.context
}
```

### Routing with segue

The `SegueAssistant` class provides passing parameters between view controllers.

```
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let assistant = SegueAssistant(segue: segue, sender: sender)

    assistant.prepareIfIdentifierEquals("ShowDetail") { (destination: ItemDetailViewController) -> Int in
        guard
            let indexPath = self.tableView.indexPathForSelectedRow,
            let selectedItem = self.items?[indexPath.row]
        else {
            fatalError()
        }

        return selectedItem.ID
    }
}
```

### Manual routing

The `Router` class provides some instance methods.
The following example is present a `ItemDetailViewController` that instantiates with `Main` storyboard's `ItemDetailNav` layout.

```
Router.shared.perform(
    sourceViewController,
    storyboardName: "Main",
    storyboardID: "ItemDetailNav"
) { (destination: ItemDetailViewController) -> Int in
    return itemID    // pass the seleted item ID
}
```

## License

The MIT License.
