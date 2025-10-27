import json, os
import ../models/app_config
import ../utils/file_utils

proc loadConfig*(appName: string): AppConfig =
  let configFile = getConfigPath()
  if fileExists(configFile):
    try:
      let data = readFile(configFile)
      let jsonData = parseJson(data)
      if jsonData.hasKey(appName):
        let appConfig = jsonData[appName]
        return AppConfig(
          name: appName,
          url: appConfig["url"].getStr(""),
          width: appConfig["width"].getInt(1200),
          height: appConfig["height"].getInt(800),
          icon: appConfig["icon"].getStr(DEFAULT_ICON),
          debug: appConfig["debug"].getBool(false)
        )
    except Exception as e:
      echo "❌ Erro ao carregar: " & $e.msg

  return AppConfig(
    name: appName,
    url: "",
    width: 1200,
    height: 800,
    icon: DEFAULT_ICON,
    debug: false
  )

proc saveConfig*(appName: string, appConfig: AppConfig) =
  var configData: JsonNode

  let configFile = getConfigPath()
  if fileExists(configFile):
    try:
      configData = parseJson(readFile(configFile))
    except:
      configData = newJObject()
  else:
    configData = newJObject()

  configData[appName] = %*{
    "url": appConfig.url,
    "width": appConfig.width,
    "height": appConfig.height,
    "icon": appConfig.icon,
    "debug": appConfig.debug
  }

  writeFile(configFile, pretty(configData))
  echo "💾 Config salva em: " & configFile
