// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$webSocketServiceHash() => r'e950debd23660e610e3d47dd580b70c49278b4ce';

/// See also [webSocketService].
@ProviderFor(webSocketService)
final webSocketServiceProvider = Provider<WebSocketService>.internal(
  webSocketService,
  name: r'webSocketServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$webSocketServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WebSocketServiceRef = ProviderRef<WebSocketService>;
String _$webSocketControllerHash() =>
    r'b8d814e38f1e2a46132ebb162023e284374ae808';

/// See also [webSocketController].
@ProviderFor(webSocketController)
final webSocketControllerProvider = FutureProvider<void>.internal(
  webSocketController,
  name: r'webSocketControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$webSocketControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WebSocketControllerRef = FutureProviderRef<void>;
String _$onlineUsersHash() => r'10959cae04fe8c776a309b39c9801cc7a43ca4e2';

/// See also [OnlineUsers].
@ProviderFor(OnlineUsers)
final onlineUsersProvider =
    NotifierProvider<OnlineUsers, List<OnlineUser>>.internal(
      OnlineUsers.new,
      name: r'onlineUsersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$onlineUsersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OnlineUsers = Notifier<List<OnlineUser>>;
String _$newEmailEventsHash() => r'e981b5f52ac30d115bb81f29895452089349ed5c';

/// See also [NewEmailEvents].
@ProviderFor(NewEmailEvents)
final newEmailEventsProvider = NotifierProvider<NewEmailEvents, int?>.internal(
  NewEmailEvents.new,
  name: r'newEmailEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$newEmailEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NewEmailEvents = Notifier<int?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
