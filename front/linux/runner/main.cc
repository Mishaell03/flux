#include "my_application.h"

#include <glib/gstdio.h>
#include <limits.h>
#include <unistd.h>

#include <string>

void register_url_scheme() {
  char executable_path[PATH_MAX];
  ssize_t path_length =
      readlink("/proc/self/exe", executable_path, sizeof(executable_path) - 1);

  if (path_length <= 0) {
    return;
  }

  executable_path[path_length] = '\0';

  const gchar* user_data_dir = g_get_user_data_dir();
  g_autofree gchar* applications_dir =
      g_build_filename(user_data_dir, "applications", nullptr);
  g_mkdir_with_parents(applications_dir, 0755);

  g_autofree gchar* desktop_path =
      g_build_filename(applications_dir, "flux.desktop", nullptr);

  std::string desktop_entry =
      "[Desktop Entry]\n"
      "Name=Flux\n"
      "Comment=Flux application\n"
      "Exec=\"";
  desktop_entry += executable_path;
  desktop_entry +=
      "\" %u\n"
      "Icon=flux\n"
      "Terminal=false\n"
      "Type=Application\n"
      "Categories=Utility;\n"
      "MimeType=x-scheme-handler/flux;\n";

  g_file_set_contents(desktop_path, desktop_entry.c_str(), -1, nullptr);
  g_spawn_command_line_sync(
      "xdg-mime default flux.desktop x-scheme-handler/flux", nullptr, nullptr,
      nullptr, nullptr);
}

int main(int argc, char** argv) {
  register_url_scheme();

  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
