import os

let
  HOME_DIR* = getHomeDir()
  CONFIG_PATH* = HOME_DIR / ".config" / "papa-mosca" / "papa-mosca_apps.json"
  DESKTOP_DIR* = HOME_DIR / ".local/share/applications"
  ICONS_DIR* = HOME_DIR / ".local/share/papa-mosca/icons" # ← NOVO DIRETÓRIO
  ICONS_DIR_FALLBACK* = HOME_DIR / ".local/share/icons/hicolor/48x48/apps"

proc createDirectories*() =
  createDir(HOME_DIR / ".config" / "papa-mosca")
  createDir(DESKTOP_DIR)
  createDir(ICONS_DIR) # ← AGORA CRIA DIRETÓRIO DEDICADO
  createDir(ICONS_DIR_FALLBACK)

proc getWrapperPath*(): string =
  let currentExe = getAppFilename()
  if currentExe.isAbsolute():
    return currentExe
  else:
    return getCurrentDir() / currentExe

proc getConfigPath*(): string =
  return CONFIG_PATH
