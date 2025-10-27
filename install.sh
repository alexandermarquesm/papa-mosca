#!/bin/bash
# Papa-Mosca - Instalação Automática  # ← MUDAR AQUI

set -e

echo "🖥️  Instalando Papa-Mosca..."  # ← MUDAR AQUI
echo "================================"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções de log
log_info() { echo -e "${BLUE}ℹ️ $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️ $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Verificar se é Arch Linux
check_arch_linux() {
    if command -v pacman &> /dev/null; then
        log_info "Detectado Arch Linux"
        return 0
    else
        return 1
    fi
}

# Verificar dependências
log_info "Verificando dependências..."

# Verificar Nim
if ! command -v nim &> /dev/null; then
    log_error "Nim não encontrado."
    
    if check_arch_linux; then
        log_info "Instalando Nim via pacman..."
        sudo pacman -S --noconfirm nim
    else
        log_error "Instale Nim manualmente:"
        echo "   Arch: sudo pacman -S nim"
        echo "   Ubuntu: sudo apt install nim"
        echo "   Ou visite: https://nim-lang.org/install.html"
        exit 1
    fi
else
    log_success "Nim encontrado: $(nim --version | head -n1)"
fi

# Verificar Nimble
if ! command -v nimble &> /dev/null; then
    log_error "Nimble não encontrado."
    
    if check_arch_linux; then
        log_info "Instalando Nimble via pacman..."
        sudo pacman -S --noconfirm nimble
    else
        log_error "Instale Nimble manualmente."
        exit 1
    fi
else
    log_success "Nimble encontrado"
fi

# Verificar Chromium (dependência importante)
if ! command -v chromium &> /dev/null && ! command -v google-chrome &> /dev/null; then
    log_warning "Chromium/Chrome não encontrado."
    
    if check_arch_linux; then
        log_info "Instalando Chromium..."
        sudo pacman -S --noconfirm chromium
    else
        log_warning "Instale Chromium ou Chrome para melhor experiência:"
        echo "   Arch: sudo pacman -S chromium"
        echo "   Ubuntu: sudo apt install chromium-browser"
    fi
else
    log_success "Navegador encontrado"
fi

# Compilar
log_info "Compilando Papa-Mosca..."  # ← MUDAR AQUI
if make build; then
    log_success "Compilação concluída"
else
    log_error "Falha na compilação"
    exit 1
fi

# Instalar
log_info "Instalando..."
if make install; then
    log_success "Instalação concluída"
else
    log_error "Falha na instalação"
    exit 1
fi

# Verificar instalação
if command -v papa-mosca &> /dev/null; then  # ← MUDAR AQUI
    log_success "Papa-Mosca instalado com sucesso!"  # ← MUDAR AQUI
else
    log_error "Papa-Mosca não encontrado no PATH"  # ← MUDAR AQUI
    log_info "Certifique-se que ~/.local/bin está no seu PATH"
    exit 1
fi

echo ""
echo "🎉 Papa-Mosca instalado com sucesso!"  # ← MUDAR AQUI
echo "================================="
echo ""
echo "💡 Comece a usar:"
echo "   papa-mosca --help                  # Ver ajuda"  # ← MUDAR AQUI
echo "   papa-mosca --create WhatsApp https://web.whatsapp.com"  # ← MUDAR AQUI
echo "   papa-mosca --list                  # Listar apps"  # ← MUDAR AQUI
echo ""
echo "🚀 Seus apps aparecerão no menu e no terminal!"
echo ""
echo "📖 Para atualizar, execute este script novamente"