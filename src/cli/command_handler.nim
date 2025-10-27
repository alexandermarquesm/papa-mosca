import os, strutils, json
import ../models/app_config
import ../core/config
import ../core/app_runner
import ../core/desktop_integration
import ../utils/file_utils
import ./help_displayer


proc listApps*() =
  let configFile = getConfigPath()
  if fileExists(configFile):
    let data = readFile(configFile)
    let jsonData = parseJson(data)
    echo "📱 Apps disponíveis:"
    for appName, appConfig in jsonData:
      let url = appConfig["url"].getStr()
      echo "  🎯 " & appName & " - " & url
    echo ""
    echo "💡 Use: papa-mosca \"NOME_DO_APP\" para executar"
  else:
    echo "📭 Nenhum app configurado"

proc removeApp*(appName: string) =
  let configFile = getConfigPath()
  if fileExists(configFile):
    var configData = parseJson(readFile(configFile))
    if configData.hasKey(appName):
      configData.delete(appName)
      writeFile(configFile, pretty(configData))

      removeDesktopFile(appName)
      echo "✅ App '" & appName & "' removido"
    else:
      echo "❌ App '" & appName & "' não encontrado"
  else:
    echo "❌ Nenhum app configurado"

proc createApp*(appName: string, url: string, width: int = 1200, height: int = 800,
               icon: string = DEFAULT_ICON) =
  echo "🎯 Criando app: " & appName
  echo "🌐 URL: " & url

  createDirectories()

  let config = AppConfig(
    name: appName,
    url: url,
    width: width,
    height: height,
    icon: icon,
    debug: false,
  )

  # Salvar configuração
  saveConfig(appName, config)

  # Criar arquivo .desktop usando o nome do app diretamente
  createDesktopFile(appName, config, appName) # Passa o appName como título

  echo "🎉 App '" & appName & "' criado com sucesso!"
  echo "📁 Desktop file: ~/.local/share/applications/papa-mosca-" &
      appName.toLowerAscii().replace(" ", "-") & ".desktop"
  echo "🖼️  Ícone salvo em: " & ICONS_DIR
  echo ""
  echo "💡 Agora você pode usar:"
  echo "   papa-mosca \"" & appName & "\""
  echo "   ou pelo menu de aplicações"

proc handleCommand*(args: seq[string]) =
  if args.len == 0:
    showHelp()
    return

  case args[0]:
  of "--help", "-h":
    showHelp()
  of "--version", "-v":
    showVersion()
  of "--list", "-l":
    listApps()
  of "--remove", "-rm":
    if args.len >= 2:
      removeApp(args[1])
    else:
      echo "❌ Especifique o nome do app para remover"
      echo "💡 Use --list para ver apps disponíveis"
  of "--run", "-r":
    if args.len >= 2:
      let appName = args[1]
      let savedConfig = loadConfig(appName)
      if savedConfig.url != "":
        echo "🚀 Executando app: " & appName
        runApp(savedConfig)
      else:
        echo "❌ App '" & appName & "' não encontrado"
        echo "💡 Apps disponíveis:"
        listApps()
    else:
      echo "❌ Especifique o nome do app para executar"
      echo "💡 Use --list para ver apps disponíveis"
  of "--create", "--add":
    if args.len >= 3:
      let appName = args[1]
      let url = args[2]
      var width = 1200
      var height = 800
      var icon = DEFAULT_ICON

      # Processar opções adicionais (removemos o -t/--title)
      var i = 3
      while i < args.len:
        case args[i]:
        of "-w", "--width":
          inc(i)
          if i < args.len:
            width = parseInt(args[i])
        of "-h", "--height":
          inc(i)
          if i < args.len:
            height = parseInt(args[i])
        of "-i", "--icon":
          inc(i)
          if i < args.len:
            icon = args[i]
        else:
          echo "⚠️  Opção desconhecida: " & args[i]
        inc(i)

      createApp(appName, url, width, height, icon)

    else:
      echo "❌ Uso: papa-mosca --create <nome> <url>"
      echo "💡 Exemplo: papa-mosca --create WhatsApp https://web.whatsapp.com"
  else:
    let appName = args[0]
    let savedConfig = loadConfig(appName)
    if savedConfig.url != "":
      echo "🚀 Executando app: " & appName
      runApp(savedConfig)
      return

    echo "❌ App '" & appName & "' não encontrado."
    echo "💡 Para criar um novo app:"
    echo "   papa-mosca --create \"" & appName & "\" https://exemplo.com"
    echo ""
    echo "📱 Apps disponíveis:"
    listApps()
