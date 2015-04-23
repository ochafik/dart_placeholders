library placeholders;

@MirrorsUsed(symbols: const ["calls"], override: "*")
import 'dart:mirrors';

/// TODO(ochafik): Add barback typechecks.
class Placeholder extends Function {
  final Function _target;
  final bool _isElvis;
  Placeholder(this._isElvis, this._target);
  
  // TODO(ochafik): File bug about List.map and al. failing to recognize functional objects as functions.
  dynamic call(dynamic);

  noSuchMethod(Invocation i) {
    var n = i.memberName;
    if (MirrorSystem.getName(n) == "call") {
      return _target(i.positionalArguments.single);
    } else {
      Function invoker;
      if (i.isGetter) {
        invoker = (target) => reflect(target).getField(n).reflectee;
      } else if (i.isSetter) {
        var value = i.positionalArguments.single;
        invoker = (target) => reflect(target).setField(n, value);
      } else {
        assert(i.isMethod);
        var positionalArguments = i.positionalArguments;
        var namedArguments = i.namedArguments;
        invoker = (target) => reflect(target).invoke(n, positionalArguments, namedArguments).reflectee;
      }
      return _map(invoker);
    }
  }

  /// Dirty overrides that return placeholders.
  toString() => _map((v) => v.toString());
  get hashCode => _map((v) => v.hashCode);
  operator==(other) => _map((v) => v == other);

  Placeholder _map(Function transform) =>
      new Placeholder(_isElvis, (v) {
        var value = _target(v);
        return _isElvis && value == null ? null : transform(value);
      });
}

var $_ = new Placeholder(false, (v) => v);
var $__ = new Placeholder(true, (v) => v);

