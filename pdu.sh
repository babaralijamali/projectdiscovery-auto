#!/bin/bash

echo "⚠️  This will remove Go and all installed bug bounty tools from all known locations."
read -p "Do you want to continue? [y/N]: " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "❌ Uninstallation cancelled."
    exit 1
fi

# List of known bug bounty tools (add more if needed)
TOOLS=(
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

# Paths to search for binaries
BIN_DIRS=(
  /usr/local/bin
  /usr/bin
  /bin
  /sbin
  /usr/sbin
  ~/.local/bin
  ~/go/bin
)

echo "🔍 Searching and removing tools..."
for tool in "${TOOLS[@]}"; do
  FOUND=0
  for dir in "${BIN_DIRS[@]}"; do
    if [[ -f "$dir/$tool" ]]; then
      echo "🗑 Removing $tool from $dir"
      sudo rm -f "$dir/$tool"
      FOUND=1
    fi
  done
  if [[ $FOUND -eq 0 ]]; then
    echo "ℹ️  $tool not found in standard paths"
  fi
done

# Remove Go from /usr/local/go
if [[ -d "/usr/local/go" ]]; then
  echo "🗑 Removing Go installation from /usr/local/go"
  sudo rm -rf /usr/local/go
else
  echo "ℹ️  Go not found in /usr/local/go"
fi

# Remove Go path from ~/.profile or ~/.bashrc
if grep -q "export PATH=\$PATH:/usr/local/go/bin" ~/.profile; then
  sed -i '/export PATH=\$PATH:\/usr\/local\/go\/bin/d' ~/.profile
  echo "🧹 Removed Go path from ~/.profile"
fi
if grep -q "export PATH=\$PATH:/usr/local/go/bin" ~/.bashrc; then
  sed -i '/export PATH=\$PATH:\/usr\/local\/go\/bin/d' ~/.bashrc
  echo "🧹 Removed Go path from ~/.bashrc"
fi

# Optional: Remove user Go workspace and build cache
read -p "Do you want to delete your Go workspace and cache (~/go and ~/.cache/go-build)? [y/N]: " clean_cache
if [[ "$clean_cache" == "y" || "$clean_cache" == "Y" ]]; then
  rm -rf ~/go ~/.cache/go-build
  echo "🧽 Removed ~/go and ~/.cache/go-build"
fi

echo "✅ Uninstallation complete."
