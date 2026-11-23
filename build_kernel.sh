#!/bin/bash
set -e

# Caminho absoluto da pasta toolchain
TC_DIR="$(pwd)/toolchain"

# Coloca o binário do clang e o python 3.9 embutido no início do PATH
export PATH="${TC_DIR}/bin:${TC_DIR}/python3/bin:${PATH}"

# Argumentos padrão do make pro S23 FE (Exynos 2200 / s5e9925)
MAKE_ARGS=(
    O=out
    ARCH=arm64
    TARGET_SOC=s5e9925
    PLATFORM_VERSION=12
    ANDROID_MAJOR_VERSION=s
    LLVM=1
    LLVM_IAS=1
    CLANG_TRIPLE=aarch64-linux-gnu-
    CROSS_COMPILE=aarch64-linux-gnu-
    KCFLAGS="-Wno-error"
    HOSTCFLAGS="-I/usr/include/openssl-1.1 -Wno-error"
    HOSTLDFLAGS="-L/usr/lib/openssl-1.1 -Wl,-rpath,/usr/lib/openssl-1.1"
)

# Gera o .config
# make "${MAKE_ARGS[@]}" s5e9925-r11sksx_defconfig
# Gera o .config (descomente só se precisar resetar a configuração)
# make "${MAKE_ARGS[@]}" s5e9925-r11sksx_defconfig

# Garante que o driver de TUI da Samsung fique desativado
./scripts/config --file out/.config -d SAMSUNG_TUI

# Compila usando todas as threads disponíveis (no seu i5-13420H são 12 threads)
make "${MAKE_ARGS[@]}" -j"$(nproc)"
