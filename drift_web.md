Launching lib\main.dart on Chrome in debug mode...
This app is linked to the debug service: ws://127.0.0.1:9626/EcbSPIXj7fw=/ws
Debug service listening on ws://127.0.0.1:9626/EcbSPIXj7fw=/ws
A Dart VM Service on Chrome is available at: http://127.0.0.1:9626/EcbSPIXj7fw=
The Flutter DevTools debugger and profiler on Chrome is available at: http://127.0.0.1:9102?uri=ws://127.0.0.1:9626/EcbSPIXj7fw=/ws
Connecting to VM Service at ws://127.0.0.1:9626/EcbSPIXj7fw=/ws
Connected to the VM Service.
Starting application from main method in: org-dartlang-app:/web_entrypoint.dart.
Starting application from main method in: org-dartlang-app:/web_entrypoint.dart.
Starting application from main method in: org-dartlang-app:/web_entrypoint.dart.
Starting application from main method in: org-dartlang-app:/web_entrypoint.dart.
DartError: Invalid argument(s): When compiling to the web, the `web` parameter needs to be set.
dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 274:3       throw_
package:drift_flutter/src/web.dart 12:5                                           driftDatabase
package:drift_flutter/drift_flutter.dart 33:18                                    driftDatabase
package:what_is/database/database.dart 16:10                                      _openConnection
package:what_is/database/database.dart 9:25                                       new <fn>
package:what_is/services/learn_it_service.dart 29:5                               <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 623:19               <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 648:23               <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 542:3                _asyncStartSync
package:what_is/services/learn_it_service.dart 26:16                              initialize
package:what_is/main.dart 14:33                                                   <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 623:19               <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 648:23               <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 594:19               <fn>
dart-sdk/lib/async/zone.dart 1849:54                                              runUnary
dart-sdk/lib/async/future_impl.dart 222:18                                        handleValue
dart-sdk/lib/async/future_impl.dart 948:44                                        handleValueCallback
dart-sdk/lib/async/future_impl.dart 977:13                                        _propagateToListeners
dart-sdk/lib/async/future_impl.dart 720:5                                         [_completeWithValue]
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 504:7                complete
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 571:12               _asyncReturn
package:what_is/services/storage_service.dart 16:3                                <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 623:19               <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 648:23               <fn>
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 594:19               <fn>
dart-sdk/lib/async/zone.dart 1849:54                                              runUnary
dart-sdk/lib/async/future_impl.dart 222:18                                        handleValue
dart-sdk/lib/async/future_impl.dart 948:44                                        handleValueCallback
dart-sdk/lib/async/future_impl.dart 977:13                                        _propagateToListeners
dart-sdk/lib/async/future_impl.dart 720:5                                         [_completeWithValue]
dart-sdk/lib/async/future_impl.dart 804:7                                         <fn>
dart-sdk/lib/async/schedule_microtask.dart 40:34                                  _microtaskLoop
dart-sdk/lib/async/schedule_microtask.dart 49:5                                   _startMicrotaskLoop
dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/operations.dart 118:77  tear
dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 188:69               <fn>
---
TO use drift web see this post
---
Drift support in Flutter and Dart web apps.
Stable web support

Good news: With drift 2.9.0, web support is stable and officially supported! The WasmDatabase.open API is the preferred way to run drift on the web. While older APIs continue to work, using the stable API will bring performance and safety benefits.

Using modern browser APIs such as WebAssembly and the Origin-Private File System API, you can use drift databases for the web version of your Flutter and Dart applications. Just like the core drift APIs, web support is platform-agnostic: Drift web supports Flutter Web, AngularDart, jaspr, plain package:web/ or any other Dart web framework.

While an official sqlite3 build for the web exists, it is fairly large and doesn't support most browsers. Drift uses a custom sqlite3 build with a Dart interface sharing a lot of code with the existing native platforms, which enables a fast implementation that works on more browsers.

Supported browsers
#
Drift uses the FileSystem Access API to store databases if it's available. Otherwise, it will fall back to a slower implementation based on IndexedDb in a shared worker. This makes drift available on all modern browsers, even ones that don't support the official sqlite3 build for the web. In some browsers, you need to serve your app with additional COOP/COEP headers for full support (but drift works without that too - the official sqlite3 build doesn't).

Supported Browser	With security headers	Without security headers
Firefox (tested version 114)	Full	Full
Chrome (tested version 114)	Full	Good (slightly slower)
Chrome on Android (tested version 114)	Full	Limited (not with multiple tabs)
Safari (tested version 16.2)	Good (slightly slower)	Good (slightly slower)
Safari Technology Preview (tested 172 (17.0))	Full	Good
Firefox currently doesn't support the FileSystem Access API in private browsing windows (IndexedDB is supported from version 115). So drift will fall back to an IndexedDb-based or an in-memory database in private tabs.

In Chrome on Android, shared workers aren't supported. So if the headers required for the preferred API are missing, there unfortunately is no way to prevent data races between tabs, which can lead to persistence issues. Drift informs you about the chosen storage mode, so depending on how critical persistence is to your app, you can instruct users to download a native app or use a different browser in that case.

Compatibility check

This page includes a tiny drift database compiled to JavaScript. You can use it to verify drift works in the browsers you want to target. Clicking on the button will start a feature detection run, so you can see which file system implementation drift would pick on this browser and which web APIs are missing.

Check compatibility
Compatibility check not started yet.
More information about these results is available below.

Getting started
#
Prerequisites
#
On all platforms, drift requires access to sqlite3, the popular database system written as a C library. On native platforms, drift can use the sqlite3 library from your operating system. Flutter apps typically include a more recent version of that library with the sqlite3_flutter_libs package too.

Web browsers don't have builtin access to the sqlite3 library, so it needs to be included with your app. The sqlite3 Dart package (used by drift internally) contains a toolchain to compile sqlite3 to WebAssembly so that it can be used in browsers. You can grab a prebuilt sqlite3.wasm file from its releases page, or compile it yourself. This file needs to be put into the web/ directory of your app.

Drift on the web also requires you to include a portion of drift as a web worker. This worker will be used to host your database in a background thread, improving performance of your website. In some storage implementations, the worker is also responsible for sharing your database between different tabs in real-time. Again, you can compile this worker yourself or grab one from drift releases.

In the end, your web/ directory may look like this:


web/
├── favicon.png
├── index.html
├── manifest.json
├── drift_worker.dart.js
└── sqlite3.wasm
Serving wasm files

For browsers to accept the sqlite3.wasm file, it must be served with Content-Type: application/wasm. flutter run does this by default, but some webservers might not. After deploying your app to the web, check that your server is configured to send the correct Content-Type header for wasm files.

Additional headers
On browsers that support it, drift uses the origin-private part of the FileSystem Access API to store databases efficiently. As parts of that API are asynchronous, and since sqlite3 expectes a synchronous file system, we need to use two workers with shared memory and Atomics.wait/notify. Just like the official sqlite3 port to the web, this requires your website to be served with two special headers:

Cross-Origin-Opener-Policy: Needs to be set to same-origin.
Cross-Origin-Embedder-Policy: Needs to be set to require-corp or credentialless.
For more details, see the security requirements explained by MDN, and the documentation on web.dev. You can use flutter run --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp to add these headers onto flutter run's web server. However, if you use flutter run just like always Drift will fall back to a (slightly slower) implementation (see storages). We recommend researching and enabling these headers in production, too, if possible.

Also, note that the sqlite3.wasm file needs to be served with a Content-Type of application/wasm since browsers will reject the module otherwise.

Downsides of COOP and COEP

While these headers are required for the origin-private FileSystem Access API and bring a security benefit, there are some known problems:

These headers are incompatible with some other packages opening popups, such as the ones used for Google Auth.
Safari 16 has an unfortunate bug preventing dedicated workers to be loaded from cache with these headers. However, shared and service workers are unaffected by this.
Please carefully test your app with these headers to evaluate whether you might be affected by these limitations. If the headers break your app, you should not enable them - drift will fall back to another (potentially slower) implementation in that case.

Setup in Dart
#
From a perspective of the Dart code used, drift on the web is similar to drift on other platforms. You can follow the getting started guide as a general setup guide.

Flutter (sqlite3)
Dart (sqlite3)
If you're using package:drift_flutter to setup your database, you enable web support by passing DriftWebOptions with URIs to the WebAssembly module and the drift worker:


QueryExecutor connectWithDriftFlutter() {
  return driftDatabase(
    name: 'my_app_db',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.dart.js'),
    ),
  );
}
If you need more control on how you're opening web databases (e.g. to prefer certain storage APIs, see the manual setup for Dart in the next tab).

A full example that works on the web (and all other platforms supported by drift) is available here.

Manual code sharing between native apps and web
#
package:drift_flutter provides a single method to open databases that works both for native and web apps.

If you're not using that package, e.g. because you need more control on how you're opening databases, you can still support all platforms with a single codebase. To share your database code between native applications and web apps, import only the core package:drift/drift.dart library into your database file. And instead of passing a NativeDatabase or WasmDatabase to the super constructor of the generated database class, ensure that the QueryExecutor is customizable, like shown here:


// don't import drift/wasm.dart or drift/native.dart in shared code
import 'package:drift/drift.dart';

@DriftDatabase(/* ... */)
class SharedDatabase extends _$SharedDatabase {
    SharedDatabase(QueryExecutor e): super(e);
}
Next, set up conditional exports to open your database by creating the following files:

native.dart, which will contain the native implementation.
web.dart, for web support.
unsupported.dart, as a stub library to set up conditional exports.
shared.dart, which will contain the conditional exports.
In native Flutter apps, you can create an instance of your database with a snippet like this (also explained further in the setup guide):


// native.dart
import 'package:drift/native.dart';

SharedDatabase constructDb() {
  final db = LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
  return SharedDatabase(db);
}
On the web, you can use:


// web.dart
import 'package:drift/wasm.dart';

SharedDatabase constructDb() {
  return SharedDatabase(connectOnWeb());
}

DatabaseConnection connectOnWeb() {
  return DatabaseConnection.delayed(Future(() async {
    final result = await WasmDatabase.open(
      databaseName: 'my_app_db', // prefer to only use valid identifiers here
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
    );

    if (result.missingFeatures.isNotEmpty) {
      // Depending how central local persistence is to your app, you may want
      // to show a warning to the user if only unrealiable implemetentations
      // are available.
      print('Using ${result.chosenImplementation} due to missing browser '
          'features: ${result.missingFeatures}');
    }

    return result.resolvedExecutor;
  }));
}
Finally, we can use conditional imports to automatically pick the right constructDb function based on where your app runs. To do this, first create a unsupported.dart default implementation:


// unsupported.dart
SharedDatabase constructDb() => throw UnimplementedError();
Now, we can use conditional imports in a shared.dart file to export the correct function:


// shared.dart
export 'unsupported.dart'
  if (dart.library.ffi) 'native.dart'
  if (dart.library.js_interop) 'web.dart';
A ready example of this construct can also be found here.

Using existing databases
#
You can use existing database with Drift on the web by importing the initializeDatabase function on WasmDatabase.open. This function will be called when attempting to open a database that doesn't exist yet, allowing the initial sqlite3 file to be provided instead:


return DatabaseConnection.delayed(
  Future(() async {
    final result = await WasmDatabase.open(
      databaseName: 'my_app_db', // prefer to only use valid identifiers here
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
      initializeDatabase: () async {
        final data = await rootBundle.load('my_database');
        return data.buffer.asUint8List();
      },
    );

    // ...
    return result.resolvedExecutor;
  }),
);
Please be aware that this only works for the default journal mode, WAL is not supported on the web and WAL databases can't be imported with initializeDatabase either.

Examples
#
The drift repository contains a two small web applications using drift on the web:

A cross-platform Flutter app with web support (source code).
If you have a cool open-source web application using drift, we'd love to list it here as well. Feel free to open a PR!

Advanced uses
#
Supported storage implementations
#
When opening a database, drift determines the state of a number of web APIs in the current browser. It then picks a suitable database storage based on what the current browser supports. The following implementation strategies are supported by drift (listed in order of descending preference). You can view the chosen strategy via the WasmDatabaseResult.chosenImplementation returned by WasmDatabase.open.

opfsShared: Uses the origin-private filesystem access API in a shared web worker. As this API is only available in dedicated web workers, this requires shared workers to be able to spawn dedicated workers. While allowed by the web standards, this is only implemented by Firefox.
opfsLocks: Uses the origin-private filesystem access API, but without shared workers. This requires the COOP and COEP headers.
sharedIndexedDb: Uses IndexedDB to store chunks of data, the database is hosted in a shared web worker.
unsafeIndexedDb: This also uses the IndexedDB database, but without a shared worker or another means of synchronization between tabs. In this mode, it is not safe for multiple tabs of your app to access the same database. While this was the default mode used by earlier implementations of drift for the web, we now try to avoid it and it will not be used on modern browsers.
inMemory: When no persistence API is available, drift will fall back to an in-memory database.
The missing browser APIs contributing to a specific implementation being chosen are available in WasmDatabaseResult.missingFeatures. There's nothing your app or drift could do about them. If persistence is important to your app and drift has chosen the unsafeIndexedDb or the inMemory implementation due to a lack of proper persistence support, you may want to show a warning to the user explaining that they have to upgrade their browser.

Customizing how databases are opened
#
To customize which implementation drift uses, you can use the WasmDatabase.probe API. Without directly opening a database, it returns information about which databases exist in the current context and which features are available in the browser.

WasmDatabase.probe returns a WasmProbeResult, which can then be used to:

open() the database.
deleteDatabase() to delete a specific database at a specified location.
exportDatabase(), to export it as a Uint8List.
Custom functions and database setup
#
Constructors on NativeDatabase have a setup callback used to initialize the raw database instance, for instance by registering custom functions that are needed on the database. Unfortunately, this cannot be supported by WasmDatabase.open directly. Since the raw database instance may only exist on a web worker, we can't use Dart callback functions.

However, it is possible to compile a custom worker that will setup drift databases it creates. For that, you can create a Dart file (usually put into web/) with content like:


void setupDatabase(CommonDatabase database) {
  database.createFunction(
    functionName: 'my_function',
    function: (args) => args.length,
  );
}

void main() {
  WasmDatabase.workerMainForOpen(setupAllDatabases: setupDatabase);
}
To open the database from the application, you can then use this:


final result = await WasmDatabase.open(
  databaseName: 'my_app_db', // prefer to only use valid identifiers here
  sqlite3Uri: Uri.parse('sqlite3.wasm'),
  driftWorkerUri: Uri.parse('my_drift_worker.dart.js'),
  localSetup: setupDatabase,
);
The setupDatabase value is duplicated with localSetup in case drift determines that it needs to use an in-memory database or an IndexedDB-powered database that doesn't run in a worker. In that case, localSetup would get called instead. For databases running in a worker, the worker calls setupAllDatabases which creates the necessary functions.

The next section explains how to compile the Dart file calling workerMainForOpen into a JavaScript worker that can be referenced with driftWorkerUri. There is no need to compile a custom sqlite3.wasm for this.

Compilation
#
Drift and the sqlite3 Dart package provide pre-compiled versions of the worker and the WebAssembly module for your convenience. If you want to instead compile these yourself, this section describes how to do that.

The web worker is written in Dart - the entrypoint is stable and part of drift's public API. To compile a worker suitable for WasmDatabase.open, create a new Dart file that calls WasmDatabase.workerMainForOpen:


import 'package:drift/wasm.dart';

// When compiled with dart2js, this file defines a dedicated or shared web
// worker used by drift.
void main() => WasmDatabase.workerMainForOpen();
The JavaScript file included in drift releases is compiled with dart compile js -O4 web/drift_worker.dart. You can use that command or a tool such as build_web_compilers to compile this worker. Be aware that dart2js needs to be used as a compiler. dartdevc generates modules which are unsuitable for workers without additional setup.

Compiling the sqlite3.wasm file requires a C toolchain capable of compiling to WebAssembly. On Arch Linux, I'm using clang with the wasi-compiler-rt and wasi-libc pacakges. Depending on your distribution, you may have to compile the wasi-sdk or another toolchain yourself. Finally, we're also using binaryen as an optimizer.

The repository for the sqlite3 package contains CMake buildscripts to compile sqlite3. Thus, you can compile the file like this:


git clone https://github.com/simolus3/sqlite3.dart.git
cd sqlite3.dart/sqlite3

cmake -S assets/wasm -B .dart_tool/sqlite3_build --toolchain toolchain.cmake
cmake --build .dart_tool/sqlite3_build/ -t output -j
This will output two files to example/web: sqlite3.wasm and sqlite3.debug.wasm. The former is suitable for use in applications. The debug variant prints file system invocations to the console for debugging purposes. I mainly use it when working on the low-level Dart bindings, it is probably not too useful for application developers.

Migrating from existing web databases
#
WasmDatabase.open is drift's stable web API, which has been built with the lessons learned from previous web APIs available in drift (that have always been marked as @experimental). You can use WasmDatabase.open to replace the following drift APIs:

The sql.js-based implementation in package:drift/web.dart.
Custom WasmDatabase constructions that manually load sqlite3.
Custom worker setups created with package:drift/web/worker.dart.
Let's start with the good news: After migrating to WasmDatabase.open, drift will manage workers for you. It automatically uses the best worker setup supported by the current browsers, enabling the use of shared and dedicated web workers where appropriate. So the migration from package:drift/web/worker.dart is to just stop using that API, since you get all of its features out of the box with WasmDatabase.open.

Migrating from custom WasmDatabases
#
In older drift versions, you may have used a custom setup that loaded the WASM binary manually, created a CommonSqlite3 instance with it and passed that to WasmDatabase.


// If you've previously opened your database like this
Future<WasmDatabase> customDatabase() async {
  final sqlite3 = await WasmSqlite3.loadFromUrl(Uri.parse('/sqlite3.wasm'));
  final fs = await IndexedDbFileSystem.open(dbName: 'my_app');
  sqlite3.registerVirtualFileSystem(fs, makeDefault: true);

  return WasmDatabase(sqlite3: sqlite3, path: '/app.db');
}
// Then you can migrate like this
final result = await WasmDatabase.open(
  databaseName: 'my_app',
  sqlite3Uri: Uri.parse('sqlite3.wasm'),
  driftWorkerUri: Uri.parse('drift_worker.dart.js'),
  initializeDatabase: () async {
    // Manually open the file system previously used
    final fs = await IndexedDbFileSystem.open(dbName: 'my_app');
    const oldPath = '/app.db'; // The path passed to WasmDatabase before

    Uint8List? oldDatabase;

    // Check if the old database exists
    if (fs.xAccess(oldPath, 0) != 0) {
      // It does, then copy the old file
      final (file: file, outFlags: _) = fs.xOpen(
        Sqlite3Filename(oldPath),
        0,
      );
      final blob = Uint8List(file.xFileSize());
      file.xRead(blob, 0);
      file.xClose();
      fs.xDelete(oldPath, 0);

      oldDatabase = blob;
    }

    await fs.close();
    return oldDatabase;
  },
);
Migrating from package:drift/web.dart
#
To migrate from a WebDatabase to the new setup, you can use the initializeDatabase callback. It is invoked when opening the database if no file exists yet. By loading the old database there, it is migrated to the new format without data loss:


final result = await WasmDatabase.open(
  databaseName: 'my_app',
  sqlite3Uri: Uri.parse('sqlite3.wasm'),
  driftWorkerUri: Uri.parse('drift_worker.dart.js'),
  initializeDatabase: () async {
    final storage = await DriftWebStorage.indexedDbIfSupported('old_db');
    await storage.open();

    final blob = await storage.restore();
    await storage.close();

    return blob;
  },
);
In that snippet, old_db is the name previously passed to the WebDatabase.

Legacy web support
#
Drift first gained its initial web support in 2019 by wrapping the sql.js JavaScript library. This implementation, which is still supported today, relies on keeping an in-memory database that is periodically saved to local storage. In the last years, development in web browsers and the Dart ecosystem enabled more performant approaches that are unfortunately impossible to implement with the original drift web API. This is the reason the original API is still considered experimental - while it will continue to be supported, it is now obvious that the new approach by WasmDatabase.open is sound and more efficient than these implementations. The original APIs are still documented on this page for your reference.

Debugging
#
You can see all queries sent from drift to the underlying database engine by enabling the logStatements parameter on the WebDatabase - they will appear in the console. When you have assertions enabled (e.g. in debug mode), drift will expose the underlying database object via window.db. If you need to quickly run a query to check the state of the database, you can use db.exec(sql). If you need to delete your databases, there stored using local storage. You can clear all your data with localStorage.clear().

Web support is now stable, but please continue to report all issues you find.

Using IndexedDb
#
The default WebDatabase uses local storage to store the raw sqlite database file. On browsers that support it, you can also use IndexedDb to store that blob. In general, browsers allow a larger size for IndexedDb. The implementation is also more performant, since we don't have to encode binary blobs as strings.

To use this implementation on browsers that support it, replace WebDatabase(name) with:


WebDatabase.withStorage(await DriftWebStorage.indexedDbIfSupported(name))
Drift will automatically migrate data from local storage to IndexedDb when it is available.

Using web workers
You can offload the database to a background thread by using Web Workers. Drift also supports shared workers, which allows you to seamlessly synchronize query-streams and updates across multiple tabs!

Since web workers can't use local storage, you need to use DriftWebStorage.indexedDb instead of the regular implementation.

The following example is meant to be used with a regular Dart web app, compiled using build_web_compilers. A Flutter port of this example is part of the drift repository.

To write a web worker that will serve requests for drift, create a file called worker.dart in the web/ folder of your app. It could have the following content:


// Note: This snippet describes a legacy API! Please consider migrating to
// `package:drift/wasm.dart`, which has builtin support for web workers!
import 'dart:html'; // ignore: deprecated_member_use

import 'package:drift/drift.dart';
import 'package:drift/web.dart'; // ignore: deprecated_member_use
import 'package:drift/web/worker.dart'; // ignore: deprecated_member_use

void main() {
  // Load sql.js library in the worker
  WorkerGlobalScope.instance.importScripts('sql-wasm.js');

  // Call drift function that will set up this worker
  driftWorkerMain(() {
    return WebDatabase.withStorage(
      DriftWebStorage.indexedDb(
        'worker',
        migrateFromLocalStorage: false,
        inWebWorker: true,
      ),
    );
  });
}
For more information on this api, see the remote API.

Connecting to that worker is very simple with drift's web and remote apis. In your regular app code (outside of the worker), you can connect like this:


DatabaseConnection connectToWorker() {
  return DatabaseConnection.delayed(
    connectToDriftWorker(
      'worker.dart.js',
      // Note that SharedWorkers may not be available on all browsers and platforms.
      mode: DriftWorkerMode.shared,
    ),
  );
}

You can then open a drift database with that connection. For more information on the DatabaseConnection class, see the documentation on isolates.

A small, but working example is available under examples/web_worker_example in the drift repository.

Flutter
Flutter users will have to use a different approach to compile service workers. Flutter web doesn't compile .dart files in web folder and won't use .js files generated by build_web_compilers either. Instead, we'll use Dart's build system to manually compile the worker to a JavaScript file before using Flutter-specific tooling.

Example is available under examples/flutter_web_worker_example in the drift repository.

First, add build_web_compilers to the project:


dev_dependencies:
  build_web_compilers: ^3.2.1
Inside a build.yaml file, the compilers can be configured to always use dart2js (a good choice for web workers). Add these lines to build.yaml:


targets:
  $default:
    builders:
      build_web_compilers:entrypoint:
        generate_for:
          - web/**.dart
        options:
          compiler: dart2js
        dev_options:
          dart2js_args:
            - --no-minify
        release_options:
          dart2js_args:
            - -O4
Now, run the compiler and copy the compiled worker JS files to web/:


#Debug mode
dart run build_runner build --delete-conflicting-outputs -o web:build/web/
cp -f build/web/worker.dart.js web/worker.dart.js

#Release mode
dart run build_runner build --release --delete-conflicting-outputs -o web:build/web/
cp -f build/web/worker.dart.js web/worker.dart.min.js
Finally, use this to connect to a worker:


import 'dart:js_interop';

import 'package:drift/drift.dart';
import 'package:drift/remote.dart';
import 'package:drift/web.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart';

DatabaseConnection connectToWorker(String databaseName) {
  final worker = SharedWorker(
      (kReleaseMode ? 'worker.dart.min.js' : 'worker.dart.js').toJS,
      databaseName.toJS);

  return DatabaseConnection.delayed(
      connectToRemoteAndInitialize(worker.port.channel()));
}