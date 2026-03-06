#!/bin/bash
set -e

# Environment Setup
export ARCH=arm64
export PROJECT_NAME=a73xq
mkdir -p out

# Configuration
JOBS=$(nproc --all)
TOOLCHAIN_DIR=$(pwd)/toolchain
OUT_DIR=$(pwd)/out

# Default Toolchain Paths (Can be overridden by ENV)
GCC64_DIR=${GCC64_DIR:-$TOOLCHAIN_DIR/gcc64}
CLANG_DIR=${CLANG_DIR:-$TOOLCHAIN_DIR/clang}
DTC_PATH=${DTC_PATH:-$(pwd)/tools/dtc}

# Build Variables
BUILD_CROSS_COMPILE=$GCC64_DIR/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=$CLANG_DIR/bin/clang
CLANG_TRIPLE=${CLANG_TRIPLE:-aarch64-linux-gnu-}
KERNEL_MAKE_ENV="DTC_EXT=$DTC_PATH CONFIG_BUILD_ARM64_DT_OVERLAY=y"

echo "----------------------------------------------"
echo "Building Kernel for $PROJECT_NAME"
echo "Jobs: $JOBS"
echo "Clang: $KERNEL_LLVM_BIN"
echo "GCC: $BUILD_CROSS_COMPILE"
echo "----------------------------------------------"

# Create toolchain dir if it doesn't exist
mkdir -p $TOOLCHAIN_DIR

# 1. Configure
make -j$JOBS -C $(pwd) O=$OUT_DIR $KERNEL_MAKE_ENV \
    ARCH=arm64 \
    CROSS_COMPILE=$BUILD_CROSS_COMPILE \
    REAL_CC=$KERNEL_LLVM_BIN \
    CLANG_TRIPLE=$CLANG_TRIPLE \
    CONFIG_SECTION_MISMATCH_WARN_ONLY=y \
    vendor/a73xq_eur_open_defconfig

# 2. Build
make -j$JOBS -C $(pwd) O=$OUT_DIR $KERNEL_MAKE_ENV \
    ARCH=arm64 \
    CROSS_COMPILE=$BUILD_CROSS_COMPILE \
    REAL_CC=$KERNEL_LLVM_BIN \
    CLANG_TRIPLE=$CLANG_TRIPLE \
    CONFIG_SECTION_MISMATCH_WARN_ONLY=y

# 3. Copy Artifacts
echo "Checking for build artifacts..."
# Search for Image or Image.gz/lz4/etc
find $OUT_DIR/arch/arm64/boot/ -maxdepth 1 -name "Image*" -exec cp {} . \;

# Search for DTBOs
find $OUT_DIR/arch/arm64/boot/dts/vendor/qcom/ -name "*.dtbo" -exec cp {} . \;

if [ -f "Image" ] || [ -f "Image.gz" ]; then
    echo "Build Completed Successfully!"
else
    echo "Error: Kernel Image not found in output directory."
    exit 1
fi
