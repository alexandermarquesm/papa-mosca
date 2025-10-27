# Package

version       = "1.0.0"
author        = "Alexander Marques"
description   = "Transforma Web Apps em Apps Desktop"
license       = "MIT"
srcDir        = "src"

# Dependencies
requires "nim >= 2.0.0"

# Tasks para desenvolvimento
task make_build, "Compila usando Makefile (recomendado)":
  exec "make build"

task make_install, "Instala usando Makefile":
  exec "make install"

task make_dev, "Modo desenvolvimento":
  exec "make dev"

task make_clean, "Limpa os builds":
  exec "make clean"

task make_dist, "Cria pacote de distribuição":
  exec "make dist"

task make_release, "Prepara release para GitHub":
  exec "make release"

task make_purge, "Limpa TUDO (incluindo dist)":
  exec "make purge"