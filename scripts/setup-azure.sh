#!/bin/bash
# Setup script for Azure OpenAI configuration

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Azure OpenAI Setup for Open-Codex ===${NC}"
echo "This script will help you configure Open-Codex to use Azure OpenAI."
echo

# Get Azure API Key
read -p "Enter your Azure OpenAI API Key: " azure_key
if [ -z "$azure_key" ]; then
  echo -e "${RED}Error: Azure OpenAI API Key is required.${NC}"
  exit 1
fi

# Get Azure Endpoint
read -p "Enter your Azure OpenAI Endpoint (e.g., https://your-resource-name.openai.azure.com): " azure_endpoint
if [ -z "$azure_endpoint" ]; then
  echo -e "${RED}Error: Azure OpenAI Endpoint is required.${NC}"
  exit 1
fi

# Get Azure Deployment (model) name with default
read -p "Enter your Azure Deployment name [Default: o4-mini]: " azure_deployment
azure_deployment=${azure_deployment:-o4-mini}

# Get shell config file
shell_config=""
if [ -f "$HOME/.zshrc" ]; then
  shell_config="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
  shell_config="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
  shell_config="$HOME/.bash_profile"
else
  echo -e "${YELLOW}Warning: Could not find shell config file. Will create .env file instead.${NC}"
fi

# Add to shell config if found
if [ -n "$shell_config" ]; then
  echo -e "\n# Azure OpenAI Configuration for Open-Codex" >> "$shell_config"
  echo "export AZURE_OPENAI_KEY=\"$azure_key\"" >> "$shell_config"
  echo "export AZURE_OPENAI_ENDPOINT=\"$azure_endpoint\"" >> "$shell_config"
  echo "export AZURE_OPENAI_DEPLOYMENT=\"$azure_deployment\"" >> "$shell_config"
  echo -e "${GREEN}Azure OpenAI configuration added to $shell_config${NC}"
  echo "To apply these changes, run: source $shell_config"
fi

# Create .env file in project root
cat > "$HOME/.codex/.env" << EOF
# Azure OpenAI Configuration
AZURE_OPENAI_KEY="$azure_key"
AZURE_OPENAI_ENDPOINT="$azure_endpoint"
AZURE_OPENAI_DEPLOYMENT="$azure_deployment"
EOF

echo -e "${GREEN}Configuration saved to $HOME/.codex/.env${NC}"
echo -e "${YELLOW}Note: You may need to restart the application for changes to take effect.${NC}"

# Create a simple test script
cat > "$HOME/.codex/test-azure.js" << EOF
// Simple test script to verify Azure OpenAI configuration
const KEY = process.env.AZURE_OPENAI_KEY;
const ENDPOINT = process.env.AZURE_OPENAI_ENDPOINT;
const DEPLOYMENT = process.env.AZURE_OPENAI_DEPLOYMENT;

console.log('Azure OpenAI Configuration:');
console.log('- API Key:', KEY ? '✓ Set' : '✗ Not set');
console.log('- Endpoint:', ENDPOINT ? '✓ Set' : '✗ Not set');
console.log('- Deployment:', DEPLOYMENT || 'o4-mini (default)');
EOF

echo -e "${BLUE}Configuration complete!${NC}"
echo "To test if your environment variables are set correctly, run:"
echo -e "  ${GREEN}node $HOME/.codex/test-azure.js${NC}"
echo
echo -e "To use Open-Codex with Azure OpenAI, run:"
echo -e "  ${GREEN}open-codex${NC}"
echo "It should automatically detect your Azure configuration."