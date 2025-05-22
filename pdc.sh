#!/bin/bash

echo "🔍 Checking Go installation and bug bounty tools..."

# List of tools to check
TOOLS=(
  go
  subfinder
  httpx
  nuclei
  naabu
  dnsx
  katana
  assetfinder
  waybackurls
  httprobe
)

# Paths to check
BIN_DIRS=(
  /usr/local/bin
  /usr/bin
  ~/.local/bin
  ~/go/bin
)

echo "========================"
echo "📦 Installed Tool Report"
echo "========================"

for tool in "${TOOLS[@]}"; do
  FOUND=0
  for dir in "${BIN_DIRS[@]}"; do
    if [[ -x "$dir/$tool" ]]; then
      echo "✅ $tool found in $dir"
      FOUND=1
      break
    fi
  done

  # Check from PATH if not found in predefined dirs
  if [[ $FOUND -eq 0 ]] && command -v "$tool" &>/dev/null; then
    location=$(command -v "$tool")
    echo "✅ $tool found in PATH at $location"
  elif [[ $FOUND -eq 0 ]]; then
    echo "❌ $tool is NOT installed"
  fi
done

echo "========================"
echo "📁 Environment Variables"
echo "========================"

# Check if Go env vars are set
echo "GOROOT: ${GOROOT:-Not Set}"
echo "GOPATH: ${GOPATH:-Not Set}"
echo "PATH includes Go bin: $(echo $PATH | grep -q '/go/bin' && echo Yes || echo No)"

echo "✅ Check complete."
