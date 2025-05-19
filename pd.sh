#!/bin/bash

set -e

GO_VERSION="1.22.3"
GO_DOWNLOAD_URL="https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
GO_INSTALL_DIR="/usr/local"
PROFILE_PATH="/etc/profile.d/golang.sh"
GOBIN="/usr/local/bin"

echo "🔍 Checking Go installation..."
if ! command -v go &> /dev/null; then
    echo "⬇️ Installing Go ${GO_VERSION} from official website..."
    wget -q $GO_DOWNLOAD_URL -O /tmp/go.tar.gz
    sudo rm -rf $GO_INSTALL_DIR/go
    sudo tar -C $GO_INSTALL_DIR -xzf /tmp/go.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee $PROFILE_PATH > /dev/null
    export PATH=$PATH:/usr/local/go/bin
else
    INSTALLED_VERSION=$(go version | awk '{print $3}')
    if [[ "$INSTALLED_VERSION" != "go${GO_VERSION}" ]]; then
        echo "🔄 Updating Go to ${GO_VERSION}..."
        wget -q $GO_DOWNLOAD_URL -O /tmp/go.tar.gz
        sudo rm -rf $GO_INSTALL_DIR/go
        sudo tar -C $GO_INSTALL_DIR -xzf /tmp/go.tar.gz
        export PATH=$PATH:/usr/local/go/bin
    else
        echo "✅ Go is already at the latest version (${GO_VERSION})."
    fi
fi

echo "📦 Installing or updating bug bounty tools..."

TOOLS=(
    "github.com/projectdiscovery/subfinder/v2/cmd/subfinder"
    "github.com/projectdiscovery/httpx/cmd/httpx"
    "github.com/projectdiscovery/nuclei/v3/cmd/nuclei"
    "github.com/projectdiscovery/naabu/v2/cmd/naabu"
    "github.com/projectdiscovery/dnsx/cmd/dnsx"
    "github.com/projectdiscovery/katana/cmd/katana"
    "github.com/tomnomnom/assetfinder"
    "github.com/tomnomnom/waybackurls"
    "github.com/tomnomnom/httprobe"
)

for TOOL in "${TOOLS[@]}"; do
    echo "🔧 Installing/Updating $(basename "$TOOL")..."
    GOBIN=$GOBIN go install "$TOOL@latest"
done

echo "✅ All tools installed or updated system-wide at $GOBIN"
