A faux 3d asset rendering utility for flutter based on Stack, Container and Transformation Widgets.

It's not mature enough to be used as a general purpose framework, but can serve as a basis for anyone who wants to achieve similar things.

To examine a typical use please look into https://github.com/Zira-Games/paper-3d-sample repo.

Make sure to run add the following snippet in your main function before use.

```dart
void main() {
  final previousCheck = Provider.debugCheckInvalidValueType;
  Provider.debugCheckInvalidValueType = <T>(T value) {
    if (value is BehaviorSubject) return;
    previousCheck!<T>(value);
  };
  
  // ...
  
}

```