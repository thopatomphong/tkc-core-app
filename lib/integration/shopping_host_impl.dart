import 'package:core_app/core/env/env.dart';
import 'package:core_app/core/providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_mini_app/shopping_mini_app.dart';

class ShoppingHostImpl implements ShoppingHost {
  const ShoppingHostImpl(this.ref, this.context);

  final Ref ref;
  final BuildContext context;

  @override
  Dio get httpClient => ref.read(dioProvider);

  @override
  String get apiBaseUrl => Env.apiBaseUrl;

  @override
  void onExit() => context.go('/');
}
