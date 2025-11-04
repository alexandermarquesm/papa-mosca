#!/bin/bash
# Papa-Mosca - Instalador Rápido para Usuários Finais

set -e

echo "🎯 Papa-Mosca - Instalador Rápido"
echo "================================"

# Verificação mínima - apenas se o Makefile existe
if [[ ! -f "Makefile" ]]; then
    echo "❌ Execute do diretório do projeto Papa-Mosca"
    echo "💡 Certifique-se que o Makefile está presente"
    exit 1
fi

echo "🚀 Iniciando instalação..."
echo ""

# Delegar TUDO para o Makefile (ele já tem todas as verificações)
if make install; then
    echo ""
    echo "🎉 Instalação concluída!"
    echo "💡 Use: papa-mosca --help"
else
    echo ""
    echo "❌ Instalação falhou"
    echo "🐛 Verifique as mensagens acima para detalhes"
    exit 1
fi