//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import flutter_secure_storage_macos
import hotkey_manager
import path_provider_foundation
import screen_retriever
import shared_preferences_foundation
import system_tray
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FlutterSecureStoragePlugin.register(with: registry.registrar(forPlugin: "FlutterSecureStoragePlugin"))
  HotkeyManagerPlugin.register(with: registry.registrar(forPlugin: "HotkeyManagerPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  ScreenRetrieverPlugin.register(with: registry.registrar(forPlugin: "ScreenRetrieverPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SystemTrayPlugin.register(with: registry.registrar(forPlugin: "SystemTrayPlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}
