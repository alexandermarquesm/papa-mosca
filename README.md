Vou melhorar seu README.md para ficar mais profissional e claro:

# Papa-Mosca 🕷️

**Transforme qualquer site em um app desktop nativo com um comando!**

Papa-Mosca é uma ferramenta leve e poderosa que converte aplicações web em aplicações desktop nativas, criando ícones automáticos e integração perfeita com seu sistema.

## ✨ Por que Papa-Mosca?

Assim como a **aranha papa-moscas** captura suas presas com precisão, nossa ferramenta "captura" sites e os transforma em apps desktop de forma instantânea e eficiente!

### 🎯 Características Principais

- ⚡ **Conversão instantânea** - Transforme sites em apps com um comando
- 🖼️ **Ícones inteligentes** - Baixados automaticamente com alta qualidade
- 🏠 **Integração nativa** - Apps aparecem no menu de aplicações
- 🎨 **Otimizado para Wayland** - Funciona perfeitamente com Hyprland e compositors modernos
- 🚀 **CLI poderosa** - Gerenciamento rápido via terminal
- 🔧 **Zero configuração** - Funciona imediatamente após instalação
- 📱 **Performance otimizada** - Usa Chromium em modo app ultra-eficiente

## 🚀 Instalação Rápida

### 🐧 Arch Linux (Recomendado)

```bash
# Clone o repositório
git clone https://github.com/alexandermarquesm/papa-mosca.git
cd papa-mosca

# Instalação automática (recomendado)
./install.sh
```

### ⚙️ Instalação Manual

```bash
# Clone o projeto
git clone https://github.com/alexandermarquesm/papa-mosca.git
cd papa-mosca

# Compilar
make build

# Instalar
make install
```

### 📋 Pré-requisitos

- **Nim** (>= 2.0.0) - [Instalação](https://nim-lang.org/install.html)
- **Chromium** ou Google Chrome
- **Linux** com suporte a XDG Desktop Entries

## 📖 Como Usar

### 🆕 Criar um novo app:

```bash
# Apps de mensagens
papa-mosca --create WhatsApp https://web.whatsapp.com
papa-mosca --create Telegram https://web.telegram.org

# Apps de produtividade
papa-mosca --create Notion https://notion.so
papa-mosca --create "Meu Gmail" https://gmail.com

# Apps de entretenimento
papa-mosca --create Spotify https://open.spotify.com
papa-mosca --create YouTube https://youtube.com
```

### 🔧 Gerenciar seus apps:

```bash
# Listar todos os apps criados
papa-mosca --list

# Executar um app
papa-mosca WhatsApp
papa-mosca --run Notion

# Remover um app
papa-mosca --remove WhatsApp
```

### ⚡ Opções avançadas:

```bash
# Tamanho personalizado da janela
papa-mosca --create Notion https://notion.so -w 800 -h 600

# Ícone personalizado
papa-mosca --create YouTube https://youtube.com -i /caminho/para/icone.png

# Ou use um ícone do sistema
papa-mosca --create Spotify https://spotify.com -i spotify
```

## 🎯 Exemplos Práticos

| Comando                                                         | Resultado                   |
| --------------------------------------------------------------- | --------------------------- |
| `papa-mosca --create WhatsApp https://web.whatsapp.com`         | App do WhatsApp no menu     |
| `papa-mosca --create Gmail https://gmail.com`                   | Gmail como app nativo       |
| `papa-mosca --create Spotify https://spotify.com -w 800 -h 600` | Spotify em janela compacta  |
| `papa-mosca --list`                                             | Lista todos os apps criados |
| `papa-mosca WhatsApp`                                           | Abre o app do WhatsApp      |

## 🛠️ Comandos Disponíveis

```bash
# Comandos básicos
papa-mosca <nome_do_app>           # Abrir app existente
papa-mosca --run <nome_do_app>     # Abrir app (explícito)
papa-mosca --create <nome> <url>   # Criar novo app
papa-mosca --list                  # Listar todos os apps
papa-mosca --remove <nome_do_app>  # Remover app

# Informações
papa-mosca --version               # Mostrar versão
papa-mosca --help                  # Mostrar ajuda completa
```

## ⚙️ Opções para `--create`

| Opção                 | Descrição                                        | Padrão     |
| --------------------- | ------------------------------------------------ | ---------- |
| `-w, --width LARGURA` | Largura da janela                                | 1200       |
| `-h, --height ALTURA` | Altura da janela                                 | 800        |
| `-i, --icon ICONE`    | Ícone personalizado (caminho ou nome do sistema) | Automático |

## 🏗️ Estrutura do Projeto

```
papa-mosca/
├── src/
│   ├── main.nim                    # Ponto de entrada da aplicação
│   ├── core/                       # Núcleo da aplicação
│   │   ├── config.nim              # Gerenciamento de configurações
│   │   ├── app_runner.nim          # Executor de aplicações
│   │   └── desktop_integration.nim # Integração com desktop
│   ├── utils/                      # Utilitários
│   │   ├── file_utils.nim          # Operações de arquivo
│   │   └── web_utils.nim           # Operações web e download de ícones
│   ├── models/                     # Modelos de dados
│   │   └── app_config.nim          # Definições de configuração
│   └── cli/                        # Interface de linha de comando
│       ├── command_handler.nim     # Manipulador de comandos
│       └── help_displayer.nim      # Sistema de ajuda
├── Makefile                        # Build e instalação
├── install.sh                      # Instalador automático
└── README.md                       # Documentação
```

## 🔧 Desenvolvimento

### 🛠️ Compilar:

```bash
make build          # Build de release
make dev            # Build de desenvolvimento
make debug          # Build com informações de debug
```

### 🧹 Manutenção:

```bash
make clean          # Limpar arquivos de build
make uninstall      # Remover binário (pergunta sobre configurações)
make purge          # Remover TUDO (binário + configurações + apps)
```

### 📦 Distribuição:

```bash
make dist           # Criar pacote de distribuição
```

## 🤝 Contribuindo

Contribuições são bem-vindas! Para contribuir:

1. **Fork** o projeto
2. Crie uma **branch** para sua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. Abra um **Pull Request**

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🐛 Reportar Problemas

Encontrou um bug? Tem uma sugestão de melhoria?

[Abra uma issue](https://github.com/alexandermarquesm/papa-mosca/issues) no GitHub!

## 🌟 Agradecimentos

- Desenvolvido em [Nim](https://nim-lang.org/) - linguagem eficiente e expressiva
- Ícones por [Google Favicon Service](https://www.google.com/s2/favicons)
- Integração com [XDG Desktop Specifications](https://specifications.freedesktop.org/)
- Inspirado pela comunidade Arch Linux

## ❓ FAQ

### ❓ Onde os apps são instalados?

- **Binário**: `~/.local/bin/papa-mosca`
- **Configurações**: `~/.config/papa-mosca/`
- **Desktop files**: `~/.local/share/applications/`
- **Ícones**: `~/.local/share/papa-mosca/icons/`

### ❓ Posso usar em outras distribuições Linux?

Sim! Funciona em qualquer distribuição que suporte:

- Nim compiler
- Chromium/Chrome
- XDG Desktop Entries

### ❓ Como desinstalar completamente?

```bash
make purge
```

---

**Papa-Mosca** - Transformando a web em apps desktop com a precisão de uma aranha! 🕷️✨

> **💡 Dica**: Após a instalação, seus apps aparecerão automaticamente no menu de aplicações do seu sistema!
