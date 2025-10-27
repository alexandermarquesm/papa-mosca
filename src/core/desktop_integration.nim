import os, strformat, strutils
import ../models/app_config
import ../utils/file_utils
import ../utils/web_utils

proc getAppCategories*(url: string): string =
  let urlLower = url.toLowerAscii()

  if "mail" in urlLower or "gmail" in urlLower or "outlook" in urlLower:
    return "Network;Email;"
  elif "whatsapp" in urlLower or "telegram" in urlLower or "discord" in urlLower:
    return "Network;InstantMessaging;"
  elif "spotify" in urlLower or "youtube" in urlLower or "music" in urlLower:
    return "Audio;AudioVideo;"
  elif "figma" in urlLower or "canva" in urlLower:
    return "Graphics;"
  elif "notion" in urlLower or "trello" in urlLower:
    return "Office;"
  elif "github" in urlLower or "gitlab" in urlLower:
    return "Development;"
  else:
    return "Network;WebBrowser;"

proc createDesktopFile*(appName: string, appConfig: AppConfig,
    title: string = "") =
  ## Cria arquivo .desktop usando o título fornecido ou o appName
  let actualTitle = if title.len > 0: title else: appName

  createDir(DESKTOP_DIR)

  let desktopFileName = "papa-mosca-" & appName.toLowerAscii().replace(" ",
      "-") & ".desktop"
  let desktopFilePath = DESKTOP_DIR / desktopFileName

  let categories = getAppCategories(appConfig.url)
  let wrapperPath = getWrapperPath()

  # Baixar ícone
  let iconPath = downloadFavicon(appConfig.url)

  # Obter descrição (opcional)
  let description = getSiteDescription(appConfig.url)

  # Construir keywords baseadas no domínio
  let domain = extractDomain(appConfig.url)
  var allKeywords = "web;app;" & appName.toLowerAscii() & ";" & domain

  echo "🎯 Criando desktop file..."
  echo "📝 Nome do app: " & actualTitle
  echo "🔖 Nome interno: " & appName
  echo "🌐 URL: " & appConfig.url
  echo "📄 Descrição: " & (if description.len > 60: description[0..57] &
      "..." else: description)
  echo "🖼️  Ícone: " & iconPath

  let desktopFile = &"""
[Desktop Entry]
Version=1.0
Type=Application
Name={actualTitle}
GenericName=Web Application
Comment={description}
Exec={wrapperPath} "{appName}"
Icon={iconPath}
Terminal=false
StartupNotify=true
Categories={categories}
Keywords={allKeywords}
StartupWMClass={domain}
"""

  writeFile(desktopFilePath, desktopFile)
  echo "✅ Desktop file criado: " & desktopFilePath

  # Atualizar banco de dados de desktop
  let updateCmd = "update-desktop-database " & DESKTOP_DIR
  discard execShellCmd(updateCmd)

  # Atualizar cache de ícones se necessário
  if iconPath != DEFAULT_ICON and fileExists(iconPath):
    echo "🔄 Atualizando cache de ícones..."
    discard execShellCmd("gtk-update-icon-cache -f -t " & HOME_DIR / ".local/share/icons/hicolor")

proc removeDesktopFile*(appName: string) =
  let desktopFileName = "papa-mosca-" & appName.toLowerAscii().replace(" ",
      "-") & ".desktop"
  let desktopFilePath = DESKTOP_DIR / desktopFileName

  if fileExists(desktopFilePath):
    removeFile(desktopFilePath)
    echo "✅ Desktop file removido: " & desktopFilePath

    let updateCmd = "update-desktop-database " & DESKTOP_DIR
    discard execShellCmd(updateCmd)

# Exportar funções públicas
export createDesktopFile
export removeDesktopFile
export getAppCategories
