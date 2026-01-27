#!/bin/bash
################################################################################
# Generate .env file from ANYLINE_MOBILE_SDK_LICENSE_KEY environment variable
################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"

if [[ -z "$ANYLINE_MOBILE_SDK_LICENSE_KEY" ]]; then
    echo "Error: ANYLINE_MOBILE_SDK_LICENSE_KEY environment variable is not set" >&2
    echo "" >&2
    echo "Please set it in your shell profile (.zshrc or .bashrc):" >&2
    echo "  export ANYLINE_MOBILE_SDK_LICENSE_KEY='your-license-key-here'" >&2
    echo "" >&2
    echo "Then reload your shell or run: source ~/.zshrc" >&2
    exit 1
fi

echo "ANYLINE_MOBILE_SDK_LICENSE_KEY=\"$ANYLINE_MOBILE_SDK_LICENSE_KEY\"" > "$ENV_FILE"
echo "Generated $ENV_FILE with license key"
