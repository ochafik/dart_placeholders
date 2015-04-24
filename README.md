Hack: Scala-style placeholder closures with optional null-skipping in Dart!

```dart
import 'package:placeholders/placeholders.dart';
final _ = $_, __ = $__;

// Simple placeholder expressions:
expect([1, 2, 3, 4].where(_ % 2 == 0), [2, 4]);
expect([1, 10, 100].map(_.toString().length), [1, 2, 3]);

class Inner { int foo; }
class Outer { Inner inner; }

final outers = [
  null,
  new Outer(),
  new Outer()..inner = (new Inner()),
  new Outer()..inner = (new Inner()..foo = 123)
];
// Null-skipping placeholder:
expect(outers.map(__.inner.foo), [
  null,
  null,
  null,
  123
]);
```
