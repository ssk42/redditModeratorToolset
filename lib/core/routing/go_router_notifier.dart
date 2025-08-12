import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_provider.dart';

class GoRouterNotifier extends ChangeNotifier {
  GoRouterNotifier(this._ref) {
    _ref.listen<AsyncValue<String?>>(authStateProvider, (_, __) {
      notifyListeners();
    }, fireImmediately: true);
  }

  final Ref _ref;

  bool get isAuthenticated =>
      _ref.read(authStateProvider).asData?.value != null;
}

final goRouterNotifierProvider = ChangeNotifierProvider<GoRouterNotifier>((
  ref,
) {
  return GoRouterNotifier(ref);
});
