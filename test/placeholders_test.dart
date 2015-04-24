import 'package:unittest/unittest.dart';
import 'package:Placeholders/placeholders.dart';

class Foo { int i; }
class Bar { Foo foo; }
class Baz { Bar bar; }

final _ = $;
final __ = $$;

main() {
  group('Placeholder', () {
    group('_', () {
      test('chains calls', () {
        final list = [new Baz()..bar = (new Bar()..foo = (new Foo()..i = 10))];
        expect(list.map(_.bar.foo.i), [10]);
        expect(list.map(_.bar.foo.i.toString()), ["10"]);
        expect(list.map(_.bar.foo.i == 10), [true]);
        expect(list.map(_.bar.foo.i.hashCode), [10.hashCode]);

        expect([1, 2, 3, 4].where(_ % 2 == 0), [2, 4]);
        expect([1, 2, 3, 4].where(_ <= 2), [1, 2]);
        expect([1, 2, 3, 4].where(_.toString() == "2"), [2]);
        expect([1, 10, 100].map(_.toString().length), [1, 2, 3]);
        
        expect([1, 2, 3, 4].map(_ + 1), [2, 3, 4, 5]);
      });
      test('chokes on nulls', () {
        expect(() => [null].map(_.bar).toList(), throws);
      });
    });
    group('__', () {
      test('skips nulls', () {
        final list = [
          null,
          new Baz(),
          new Baz()..bar = (new Bar()),
          new Baz()..bar = (new Bar()..foo = (new Foo())),
          new Baz()..bar = (new Bar()..foo = (new Foo()..i = 10)),
        ];
        expect(list.map(__.bar.foo.i), [
          null,
          null,
          null,
          null,
          10
        ]);
      });
    });
  });
}