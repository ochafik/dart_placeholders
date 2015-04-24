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

# TODO

* Create a pub transformer that removes the `import 'package:placeholders/placeholders.dart';` and the `$_` aliases, and expands `_.foo.bar...` into `(_) => _.foo.bar...`
* Email dartlang.org/misc to discuss, then file a Dart Enhancement Process request to make the analyzer aware of this
* Investigate placeholders for functions with 2, 3, more arguments (as in Scala with `_1`, `_2`... or Swift with `$1`, `$2`...)
