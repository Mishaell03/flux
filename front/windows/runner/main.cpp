#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include <string>

#include "flutter_window.h"
#include "utils.h"
#include "app_links/app_links_plugin_c_api.h"

void RegisterUrlScheme() {
  wchar_t executable_path[MAX_PATH];
  DWORD path_length =
      ::GetModuleFileNameW(nullptr, executable_path, MAX_PATH);

  if (path_length == 0 || path_length == MAX_PATH) {
    return;
  }

  HKEY scheme_key;
  if (::RegCreateKeyExW(HKEY_CURRENT_USER, L"Software\\Classes\\flux", 0,
                        nullptr, 0, KEY_WRITE, nullptr, &scheme_key,
                        nullptr) != ERROR_SUCCESS) {
    return;
  }

  const wchar_t scheme_name[] = L"URL:Flux Protocol";
  const wchar_t empty_value[] = L"";
  ::RegSetValueExW(scheme_key, nullptr, 0, REG_SZ,
                   reinterpret_cast<const BYTE*>(scheme_name),
                   sizeof(scheme_name));
  ::RegSetValueExW(scheme_key, L"URL Protocol", 0, REG_SZ,
                   reinterpret_cast<const BYTE*>(empty_value),
                   sizeof(empty_value));
  ::RegCloseKey(scheme_key);

  HKEY command_key;
  if (::RegCreateKeyExW(
          HKEY_CURRENT_USER,
          L"Software\\Classes\\flux\\shell\\open\\command", 0, nullptr, 0,
          KEY_WRITE, nullptr, &command_key, nullptr) != ERROR_SUCCESS) {
    return;
  }

  std::wstring command = L"\"";
  command += executable_path;
  command += L"\" \"%1\"";

  ::RegSetValueExW(
      command_key, nullptr, 0, REG_SZ,
      reinterpret_cast<const BYTE*>(command.c_str()),
      static_cast<DWORD>((command.size() + 1) * sizeof(wchar_t)));
  ::RegCloseKey(command_key);
}

bool SendAppLinkToInstance(const std::wstring& title) {
  HWND hwnd = ::FindWindow(L"FLUTTER_RUNNER_WIN32_WINDOW", title.c_str());

  if (!hwnd) {
    return false;
  }

  SendAppLink(hwnd);

  WINDOWPLACEMENT place = {sizeof(WINDOWPLACEMENT)};
  GetWindowPlacement(hwnd, &place);

  switch (place.showCmd) {
    case SW_SHOWMAXIMIZED:
      ShowWindow(hwnd, SW_SHOWMAXIMIZED);
      break;
    case SW_SHOWMINIMIZED:
      ShowWindow(hwnd, SW_RESTORE);
      break;
    default:
      ShowWindow(hwnd, SW_NORMAL);
      break;
  }

  SetWindowPos(hwnd, HWND_TOP, 0, 0, 0, 0,
               SWP_SHOWWINDOW | SWP_NOSIZE | SWP_NOMOVE);
  SetForegroundWindow(hwnd);

  return true;
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  if (SendAppLinkToInstance(L"Flux")) {
    return EXIT_SUCCESS;
  }

  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
  RegisterUrlScheme();

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"Flux", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
