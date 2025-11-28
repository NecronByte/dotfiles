eval "$(oh-my-posh init bash --config ~/.poshthemes/nord.omp.json)"

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

_ai_update_npm_global() {
  local pkg="$1"
  local label="$2"

  local before after

  before=$(_ai_npm_version "$pkg")

  if [[ -z "$before" ]]; then
    echo "📦 $label: inte installerad (enligt npm), installerar senaste..."
    npm install -g "$pkg"
    after=$(_ai_npm_version "$pkg")

    if [[ -n "$after" ]]; then
      echo "✅ $label: installerad i version $after"
    else
      echo "⚠️  $label: installation kördes, men kunde inte läsa ut version."
    fi
    return
  fi

  echo "🔍 $label: nuvarande version $before"
  npm update -g "$pkg" >/dev/null 2>&1
  after=$(_ai_npm_version "$pkg")

  if [[ -z "$after" ]]; then
    echo "❌ $label: verkar försvunnit efter uppdatering?! (kolla npm ls -g $pkg)"
  elif [[ "$after" == "$before" ]]; then
    echo "ℹ️  $label: redan senaste ($before)"
  else
    echo "✅ $label: uppdaterad $before → $after"
  fi
}

ai-tools-update() {
  echo "=== 🔧 Uppdaterar AI-verktyg (npm global) ==="
  _ai_update_npm_global "@openai/codex" "Codex CLI"
  _ai_update_npm_global "@anthropic-ai/claude-code" "Claude Code"
  _ai_update_npm_global "@github/copilot" "GitHub Copilot CLI"
  echo "=== ✅ Klar ==="
}

alias aiupdate="ai-tools-update"