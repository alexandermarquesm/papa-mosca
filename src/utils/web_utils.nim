import httpclient, net, os, strutils
import ../models/app_config
import ./file_utils

# Funções para manipulação de URLs e web
proc extractDomain*(url: string): string =
  ## Extrai o domínio de uma URL
  try:
    var domain = url.replace("https://", "").replace("http://", "")
    domain = domain.split('/')[0]
    domain = domain.split(':')[0] # Remove porta
    return domain
  except:
    return "web"

proc downloadFavicon*(url: string): string =
  ## Baixa o favicon usando APIs que retornam ícones limpos
  let domain = extractDomain(url)
  let iconName = "papa-mosca-" & domain & ".png"
  let iconPath = ICONS_DIR / iconName

  echo "🎨 Buscando ícone limpo para: " & domain

  let client = newHttpClient()
  client.timeout = 10000

  # APIs que geralmente retornam ícones sem fundo branco
  let apis = [
    # 1. Favicon Kit - Ícones em alta resolução, muitos sem fundo
    ("Favicon-Kit-256", "https://api.faviconkit.com/" & domain & "/256"),
    ("Favicon-Kit-128", "https://api.faviconkit.com/" & domain & "/128"),
    ("Favicon-Kit-64", "https://api.faviconkit.com/" & domain & "/64"),

    # 2. DuckDuckGo - Ícones mais naturais
    ("DuckDuckGo", "https://icons.duckduckgo.com/ip3/" & domain & ".ico"),

    # 3. Google apenas como último recurso
    ("Google-192", "https://www.google.com/s2/favicons?domain=" & domain &
        "&sz=192"),
  ]

  for (apiName, apiUrl) in apis:
    try:
      echo "🔄 Tentando " & apiName & "..."
      let iconData = client.getContent(apiUrl)

      if iconData.len > 1000: # Ícones de qualidade são maiores
        writeFile(iconPath, iconData)
        echo "✅ " & apiName & " - Ícone de qualidade (" & $iconData.len & " bytes)"
        return iconPath
      elif iconData.len > 100:
        echo "⚠️  " & apiName & " - Ícone pequeno, continuando busca..."
        # Não salva ainda, continua procurando melhor
      else:
        echo "❌ " & apiName & " - Ícone inválido"

    except Exception as e:
      echo "❌ " & apiName & " - Erro: " & e.msg

  # Fallback final
  echo "⚠️  Nenhum ícone bom encontrado, usando padrão do sistema"
  return DEFAULT_ICON

proc getSiteDescription*(url: string): string =
  ## Retorna uma descrição simples baseada na URL
  let domain = extractDomain(url)
  return "Web App: " & domain
