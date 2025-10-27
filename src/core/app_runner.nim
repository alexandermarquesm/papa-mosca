import os, strformat, strutils
import ../models/app_config
import ../utils/file_utils

proc runApp*(appConfig: AppConfig) =
  echo "🚀 Executando app: " & appConfig.name
  echo "🌐 URL: " & appConfig.url

  let profileDir = HOME_DIR / ".config" / "papa-mosca" / "profiles" /
      appConfig.name.toLowerAscii()
  createDir(profileDir)

  # Chromium ULTRA OTIMIZADO em modo app + SILENCIOSO
  let cmd = &"chromium --app={appConfig.url} " &
    &"--user-data-dir='{profileDir}' " &
    &"--window-size={appConfig.width},{appConfig.height} " &
    # 🚀 OTIMMIZAÇÕES DE PERFORMANCE
    "--no-first-run " &
    "--disable-extensions " &
    "--disable-plugins " &
    "--disable-background-timer-throttling " &
    "--disable-backgrounding-occluded-windows " &
    "--disable-renderer-backgrounding " &
    "--disable-features=TranslateUI,AudioServiceOutOfProcess,MediaRouter " &
    "--no-default-browser-check " &
    "--disable-component-update " &
    "--disable-sync " &
    "--disable-default-apps " &
    "--noerrdialogs " &
    "--disable-infobars " &
    "--disable-breakpad " &
    "--disable-logging " &
    "--disable-dev-shm-usage " &
    "--aggressive-cache-discard " &
    "--memory-pressure-off " &
    "--max_old_space_size=256 " &
    "--disable-back-forward-cache " &
    "--disable-ipc-flooding-protection " &
    "--disable-hang-monitor " &
    "--disable-prompt-on-repost " &
    "--disable-search-engine-choice-screen " &
    "--password-store=basic " &
    "--use-mock-keychain " &
    "--autoplay-policy=no-user-gesture-required " &
    "--process-per-site " &
    "--in-process-gpu " &
    "--disable-software-rasterizer " &
    "--disable-features=VizDisplayCompositor " &
    # 🔇 SILENCE LOGS
    "--log-level=0 " &
    "--disable-logging " &
    "--silent-launch " &
    "--disable-crash-reporter "

  echo "🦉 Iniciando Chromium ULTRA OTIMIZADO"
  echo "💾 Perfil: " & profileDir
  echo "⚡ Modo alta performance ativado"

  let exitCode = execShellCmd(cmd)

  if exitCode == 0:
    echo "✅ " & appConfig.name & " finalizado"
  else:
    echo "❌ Chromium falhou - tentando modo simples..."
    let fallbackCmd = &"chromium --app={appConfig.url} " &
      &"--window-size={appConfig.width},{appConfig.height} " &
      "--no-first-run --disable-logging --log-level=0"
    discard execShellCmd(fallbackCmd)
