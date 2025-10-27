import strformat

proc showHelp*() =
  echo &"""
Papa-Mosca v1.0.0 - Transforma Web Apps em Apps Desktop

USO:
  papa-mosca [COMANDO] [ARGUMENTOS]

COMANDOS PRINCIPAIS:
  <nome_do_app>                    Abrir app existente
  --run, -r <nome_do_app>          Abrir app (explícito)
  --create, --add <nome> <url>     Criar novo app
  --list, -l                       Listar todos os apps
  --remove, -rm <nome_do_app>      Remover app
  --version, -v                    Mostrar versão
  --help, -h                       Mostrar esta ajuda

OPÇÕES PARA CRIAR APPS:
  -w, --width LARGURA              Largura da janela (padrão: 1200)
  -h, --height ALTURA              Altura da janela (padrão: 800)
  -i, --icon ICONE                 Ícone personalizado

EXEMPLOS:
  papa-mosca --list                              # Listar apps
  papa-mosca WhatsApp                            # Abrir WhatsApp
  papa-mosca --run Gmail                         # Abrir Gmail
  papa-mosca --create Discord https://discord.com
  papa-mosca --add Spotify https://spotify.com -w 800 -h 600
  papa-mosca --create Notion https://notion.so
  papa-mosca --remove AppAntigo                  # Remover app

INSTALAÇÃO:
  make install                    # Instalar localmente
  make uninstall                  # Remover instalação

🎯 Os apps ficam disponíveis no menu e no terminal!
"""

proc showVersion*() =
  echo "Papa-Mosca v1.0.0"
