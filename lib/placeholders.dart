library placeholders;

import 'package:smoke/smoke.dart' as smoke;

//@MirrorsUsed(symbols: const ["calls"], override: "*")
//import 'dart:mirrors';

typedef dynamic _Function1(dynamic target);

/// TODO(ochafik): Add transformer typechecks + rewrites.
class Placeholder extends Function {
  final _Function1 _chainedCall;
  final bool _skipsNulls;
  Placeholder(this._skipsNulls, this._chainedCall);
  
  dynamic call(arg) {
    return _chainedCall(arg);
  }

  noSuchMethod(Invocation i) {
    final n = i.memberName;
    _Function1 invoker;
    if (i.isGetter) {
      invoker = (target) => smoke.read(target, n);
    } else if (i.isSetter) {
      final value = i.positionalArguments.single;
      invoker = (target) => smoke.write(target, n, value);
    } else {
      assert(i.isMethod);
      final positionalArguments = i.positionalArguments;
      final namedArguments = i.namedArguments;
      invoker = (target) => smoke.invoke(target, n, positionalArguments, namedArgs: namedArguments);
    }
    return _map(invoker);
  }
  
  /// Dirty overrides that return placeholders.
  toString() => _map((v) => v.toString());
  get hashCode => _map((v) => v.hashCode);
  operator==(other) => _map((v) => v == other);

  Placeholder _map(_Function1 transform) =>
      new Placeholder(_skipsNulls, (v) {
        final value = _chainedCall(v);
        return _skipsNulls && value == null ? null : transform(value);
      });
}

_identity(v) => v;
var $_ = new Placeholder(false, _identity);
var $__ = new Placeholder(true, _identity);
