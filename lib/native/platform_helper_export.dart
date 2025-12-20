// Conditional export based on platform
export 'platform_helper_stub.dart'
    if (dart.library.io) 'platform_helper_native.dart'
    if (dart.library.html) 'platform_helper_web.dart';
