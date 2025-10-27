.PHONY: build install uninstall clean dist help dev debug release purge

# Configurações
APP_NAME = papa-mosca
INSTALL_DIR = $(HOME)/.local/bin
CONFIG_DIR = $(HOME)/.config/papa-mosca
DESKTOP_DIR = $(HOME)/.local/share/applications
ICONS_DIR = $(HOME)/.local/share/papa-mosca/icons
BUILD_DIR = build

# Build
build:
	@echo "🔨 Compilando $(APP_NAME)..."
	mkdir -p $(BUILD_DIR)
	nim c -d:ssl -d:release --opt:size -o:$(BUILD_DIR)/$(APP_NAME) src/main.nim
	@echo "✅ Build completo: $(BUILD_DIR)/$(APP_NAME)"

# Instalação
install: build
	@echo "📦 Instalando $(APP_NAME)..."
	
	# Criar diretórios necessários
	mkdir -p $(INSTALL_DIR) $(CONFIG_DIR) $(DESKTOP_DIR) $(ICONS_DIR)
	
	# Instalar binário
	cp $(BUILD_DIR)/$(APP_NAME) $(INSTALL_DIR)/
	chmod +x $(INSTALL_DIR)/$(APP_NAME)
	
	# Criar diretório de perfis
	mkdir -p $(CONFIG_DIR)/profiles
	
	@echo "✅ $(APP_NAME) instalado em $(INSTALL_DIR)"
	@echo "💡 Execute: $(APP_NAME) --help"

# Desinstalar
uninstall:
	@echo "🗑️  Desinstalando $(APP_NAME)..."
	
	# Remover binário
	rm -f $(INSTALL_DIR)/$(APP_NAME)
	
	# Remover arquivos de usuário (pergunta primeiro)
	@echo "❓ Deseja remover configurações e apps do usuário? [y/N] " && read ans && [ $${ans:-N} = y ] && \
	(rm -rf $(CONFIG_DIR) && \
	rm -f $(DESKTOP_DIR)/papa-mosca-*.desktop && \
	rm -rf $(HOME)/.local/share/papa-mosca && \
	echo "✅ Configurações removidas") || echo "ℹ️  Configurações mantidas"
	
	# Atualizar bancos de dados
	-update-desktop-database $(DESKTOP_DIR)
	-gtk-update-icon-cache $(HOME)/.local/share/icons/hicolor
	
	@echo "✅ $(APP_NAME) desinstalado"

# Limpar
clean:
	@echo "🧹 Limpando..."
	rm -rf $(BUILD_DIR)
	rm -rf dist
	@echo "✅ Limpeza completa"

# Limpeza completa (incluindo releases)
superclean: clean
	@echo "🧹 Limpando releases..."
	rm -f papa-mosca-*.tar.gz
	@echo "✅ Limpeza super completa"

# Desinstalação completa (remove TUDO)
purge:
	@echo "🔥 Remoção completa..."
	rm -f $(INSTALL_DIR)/$(APP_NAME)
	rm -rf $(CONFIG_DIR)
	rm -f $(DESKTOP_DIR)/papa-mosca-*.desktop
	rm -rf $(HOME)/.local/share/papa-mosca
	-update-desktop-database $(DESKTOP_DIR)
	-gtk-update-icon-cache $(HOME)/.local/share/icons/hicolor
	@echo "✅ Remoção completa concluída"

# Desenvolvimento
dev:
	@echo "🚀 Modo desenvolvimento..."
	nim c -d:ssl --linedir:on --debuginfo -o:$(BUILD_DIR)/$(APP_NAME) src/main.nim
	@echo "✅ Build de desenvolvimento completo"

# Debug
debug:
	@echo "🐛 Compilando para debug..."
	nim c -d:ssl -d:debug --debuginfo -o:$(BUILD_DIR)/$(APP_NAME)_debug src/main.nim
	@echo "✅ Build debug completo: $(BUILD_DIR)/$(APP_NAME)_debug"

# Distribuição
dist: build
	@echo "📦 Criando pacote de distribuição..."
	mkdir -p dist
	cp $(BUILD_DIR)/$(APP_NAME) dist/
	cp README.md dist/
	cp LICENSE dist/ 2>/dev/null || true
	@echo "✅ Pacote criado em dist/"

# Release para GitHub
release: dist
	@echo "🚀 Preparando release..."
	tar -czf papa-mosca-$(shell date +%Y%m%d).tar.gz -C dist .
	@echo "✅ Release criada: papa-mosca-$(shell date +%Y%m%d).tar.gz"

# Ajuda
help:
	@echo "Papa-Mosca - Makefile"
	@echo ""
	@echo "Comandos disponíveis:"
	@echo "  make build     - Compilar o projeto (Release)"
	@echo "  make install   - Instalar localmente"
	@echo "  make uninstall - Remover instalação (pergunta sobre configurações)"
	@echo "  make purge     - Remover TUDO (binário + configurações + apps)"
	@echo "  make clean     - Limpar arquivos de build"
	@echo "  make dev       - Compilar para desenvolvimento"
	@echo "  make debug     - Compilar com informações de debug"
	@echo "  make dist      - Criar pacote de distribuição"
	@echo "  make release   - Criar release para GitHub"
	@echo "  make help      - Mostrar esta ajuda"