# MK2Router

MK2Router is a view controller routing utility for Swift.

See also: Qiita(Japanese) http://qiita.com/imk2o/items/8a46cfeaede7cbba4dcb

## Requirements

* iOS 8.0+
* Xcode 8.0+
* Swift 3.0

## Install

### CocoaPods

Add the following line to your `Podfile`.

```
pod 'MK2Router', '~> 2.4.0'
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

The `UIStoryboardSegue` extension provides passing parameters between view controllers.

```
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    segue.mk2.context(ifIdentifierEquals: "ShowDetail") { (destination: ItemDetailViewController) in
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

### Variant Context

If you want the `DestinationType.Context` equips variant type, use `enum` type as context.

```
class ItemDetailViewController: UIViewController, DestinationType {
    enum ContextType {
        case itemID(Int)
        case item(Item)
    }
    typealias Context = ContextType

    ...
```

### Feedback with unwind segue

If you want to feedback values to source view controller using unwind segue, do as follows.

* Store the feedback values when unwind (in destination view controller)

```
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    segue.mk2.feedback(ifIdentifierEquals: "Unwind") { (source: SearchOptionViewController) in
        return self.keywordTextField.text ?? ""
    }
}
```

* Get the feedback values (in source view controller)

```
@IBAction func unwindFromSearchOption(_ segue: UIStoryboardSegue) {
    if let keyword = segue.mk2.feedback(from: SearchOptionViewController.self) {
        self.loadItems(keyword: keyword)
    }
}
```

## License

The MIT License.
