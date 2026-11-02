#!/bin/bash
# Build the static ggml libraries that vibe-server links against, following
# upstream's `build-libs` task in server/libs/libs.chore for Linux.
# Usage: build-ggml.sh <server-dir> <jobs>
set -euo pipefail

server=$1
jobs=$2
version=$(cat "$server/libs/ggml-version")
out="$server/libs/lib"

rm -rf ggml-src ggml-build ggml-build-x64 "$out"
git clone --depth 1 --branch "$version" https://github.com/ggml-org/ggml.git ggml-src
for patch in "$server"/libs/patches/*.patch; do
  git -C ggml-src apply --verbose "$patch"
done

flags=(-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF
  -DGGML_BUILD_EXAMPLES=OFF -DGGML_BUILD_TESTS=OFF
  -DGGML_VULKAN=ON -DGGML_VULKAN_DYNAMIC_LOADER=ON)
x86=false
if [ "$(uname -m)" = x86_64 ]; then
  x86=true
  flags+=(-DGGML_NATIVE=OFF)
fi
cmake -S ggml-src -B ggml-build "${flags[@]}"
cmake --build ggml-build --parallel "$jobs"

mkdir -p "$out"
find_lib() {
  find "$1" -name "$2" -print -quit | grep . || { echo "$2 not found under $1" >&2; exit 1; }
}
stage() {
  cp "$(find_lib ggml-build "$1")" "$out/$1"
}
# Suffix every symbol of one CPU backend build so two of them link into one
# binary; vibe-server picks the AVX2 or the baseline one at startup.
stage_cpu_variant() {
  local lib="$out/libggml-cpu-$2.a"
  cp "$(find_lib "$1" libggml-cpu.a)" "$lib"
  nm --defined-only --format=just-symbols "$lib" | grep -v -e ':$' -e '^$' | sort -u |
    awk -v suffix="_$2" '{ print $1, $1 suffix }' > "$lib.map"
  objcopy --redefine-syms="$lib.map" "$lib"
  rm "$lib.map"
}

stage libggml.a
stage libggml-base.a
stage libggml-vulkan.a
if $x86; then
  cmake -S ggml-src -B ggml-build-x64 "${flags[@]}" \
    -DGGML_VULKAN=OFF -DGGML_AVX2=OFF -DGGML_FMA=OFF -DGGML_BMI2=OFF
  cmake --build ggml-build-x64 --parallel "$jobs" --target ggml-cpu
  stage_cpu_variant ggml-build hsw
  stage_cpu_variant ggml-build-x64 x64
else
  stage libggml-cpu.a
fi
