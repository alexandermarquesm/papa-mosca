.PHONY: build install uninstall clean dist help dev debug release purge check_path add_to_path check_chromium

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

# Verificar Chromium
check_chromium:
	@echo "🔍 Verificando Chromium..."
	@if command -v chromium >/dev/null 2>&1; then \
		echo "✅ Chromium encontrado"; \
	else \
		echo "❌ Chromium não encontrado"; \
		echo "📦 Para instalar:"; \
		echo "   sudo pacman -S chromium"; \
		echo ""; \
		read -p "❓ Tentar instalar agora? [Y/n] " ans; \
		case "$$ans" in \
			[Nn]*) \
				echo "⚠️  O Papa-Mosca não funcionará sem Chromium"; \
				echo "💡 Instale manualmente depois: sudo pacman -S chromium"; \
				;; \
			*) \
				echo "📦 Instalando Chromium..."; \
				if sudo pacman -S --needed --noconfirm chromium; then \
					echo "✅ Chromium instalado com sucesso!"; \
				else \
					echo "❌ Falha na instalação. Execute manualmente:"; \
					echo "   sudo pacman -S chromium"; \
					exit 1; \
				fi; \
				;; \
		esac; \
	fi

# Instalação
install: build check_chromium
	@echo "📦 Instalando $(APP_NAME)..."
	
	# Criar diretórios necessários
	mkdir -p $(INSTALL_DIR) $(CONFIG_DIR)/profiles
	
	# Instalar binário
	cp $(BUILD_DIR)/$(APP_NAME) $(INSTALL_DIR)/
	chmod +x $(INSTALL_DIR)/$(APP_NAME)
	
	@echo "✅ $(APP_NAME) instalado em $(INSTALL_DIR)"
	@echo "🔍 Detectado shell: $(shell basename $(SHELL))"
	@$(MAKE) check_path

# Verificar PATH
check_path:
	@echo "🔧 Verificando PATH..."
	@if echo ":$$PATH:" | grep -q ":$$HOME/.local/bin:"; then \
		echo "✅ ~/.local/bin já está no PATH"; \
	else \
		echo "⚠️  ~/.local/bin não está no PATH"; \
		$(MAKE) add_to_path; \
	fi

# Adicionar ao PATH
add_to_path:
	@echo "📝 Adicionando ~/.local/bin ao PATH..."
	@if [ -f "$$HOME/.bashrc" ]; then \
		if ! grep -q "\.local/bin" "$$HOME/.bashrc"; then \
			echo 'export PATH="$$HOME/.local/bin:$$PATH"' >> $$HOME/.bashrc; \
			echo "✅ Adicionado ao .bashrc"; \
		else \
			echo "ℹ️  Já configurado no .bashrc"; \
		fi; \
	fi
	@if [ -f "$$HOME/.zshrc" ]; then \
		if ! grep -q "\.local/bin" "$$HOME/.zshrc"; then \
			echo 'export PATH="$$HOME/.local/bin:$$PATH"' >> $$HOME/.zshrc; \
			echo "✅ Adicionado ao .zshrc"; \
		else \
			echo "ℹ️  Já configurado no .zshrc"; \
		fi; \
	fi
	@if [ -f "$$HOME/.config/fish/config.fish" ]; then \
		if ! grep -q "\.local/bin" "$$HOME/.config/fish/config.fish"; then \
			if command -v fish_add_path >/dev/null 2>&1; then \
				echo 'fish_add_path ~/.local/bin' >> $$HOME/.config/fish/config.fish; \
			else \
				echo 'set -gx PATH $$HOME/.local/bin $$PATH' >> $$HOME/.config/fish/config.fish; \
			fi; \
			echo "✅ Adicionado ao config.fish"; \
		else \
			echo "ℹ️  Já configurado no config.fish"; \
		fi; \
	fi
	@echo ""
	@echo "🔄 Reinicie o terminal ou execute:"
	@echo "   source ~/.bashrc 2>/dev/null || source ~/.zshrc 2>/dev/null || source ~/.config/fish/config.fish 2>/dev/null"

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
	
	@echo ""
	@echo "💡 O diretório ~/.local/bin permanece no seu PATH"
	@echo "   (útil para outros programas que você possa instalar)"
	@echo ""
	@echo "🔧 Se quiser removê-lo, edite manualmente:"
	@echo "   - ~/.bashrc, ~/.zshrc ou ~/.config/fish/config.fish"
	@echo "   - Procure por linhas com '~/.local/bin'"
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
	@echo "  make install   - Instalar localmente (com verificação de dependências)"
	@echo "  make uninstall - Remover instalação (pergunta sobre configurações)"
	@echo "  make purge     - Remover TUDO (binário + configurações + apps)"
	@echo "  make clean     - Limpar arquivos de build"
	@echo "  make dev       - Compilar para desenvolvimento"
	@echo "  make debug     - Compilar com informações de debug"
	@echo "  make dist      - Criar pacote de distribuição"
	@echo "  make release   - Criar release para GitHub"
	@echo "  make help      - Mostrar esta ajuda"