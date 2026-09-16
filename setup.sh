#!/usr/bin/env bash
#
# Agentic Development Framework — setup
#
# Pure bash + sed. No prerequisites beyond a POSIX shell.
# Prompts for project-specific values, replaces {{PLACEHOLDERS}} across the agent and
# command files, and copies the skill templates into your active skills directory.
#
# Re-runnable: it reads previous answers from .agentic/local.config if present.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$ROOT_DIR/.agentic/local.config"

# Files that contain {{PLACEHOLDERS}} to substitute.
TARGET_GLOBS=(
  "$ROOT_DIR/.opencode/agents/"*.md
  "$ROOT_DIR/.opencode/commands/"*.md
)

# ---- helpers ---------------------------------------------------------------

# prompt VAR "Question" "default"
prompt() {
  local __var="$1" __q="$2" __def="${3:-}" __ans
  local __prev="${!__var:-}"
  [ -n "$__prev" ] && __def="$__prev"
  if [ -n "$__def" ]; then
    read -r -p "$__q [$__def]: " __ans || true
    __ans="${__ans:-$__def}"
  else
    read -r -p "$__q: " __ans || true
  fi
  printf -v "$__var" '%s' "$__ans"
}

# cross-platform in-place sed (GNU vs BSD/macOS)
sed_inplace() {
  local expr="$1" file="$2"
  if sed --version >/dev/null 2>&1; then
    sed -i -e "$expr" "$file"          # GNU
  else
    sed -i '' -e "$expr" "$file"       # BSD/macOS
  fi
}

# escape a value for safe use on the sed replacement side
sed_escape() { printf '%s' "$1" | sed -e 's/[\/&|]/\\&/g'; }

# ---- load previous answers -------------------------------------------------

if [ -f "$CONFIG_FILE" ]; then
  echo "Found previous config at $CONFIG_FILE — values will be offered as defaults."
  # shellcheck disable=SC1090
  . "$CONFIG_FILE"
fi

echo
echo "=== Agentic Development Framework setup ==="
echo "Answer a few questions. Press Enter to accept the [default]."
echo

# ---- gather values ---------------------------------------------------------

prompt PROJECT_NAME        "Human-readable project name"              "My Project"
prompt PROJECT_SLUG        "Project slug (lowercase, for skill discovery, e.g. acme)" "myproject"
prompt WORKSPACE_ROOT      "Absolute path where your repos live"      "$HOME/$PROJECT_SLUG"
prompt TICKET_PREFIX       "Ticket key prefix (e.g. ACME)"            "TASK"
prompt DEFAULT_BASE_BRANCH "Default base branch for new work"         "develop"
prompt TICKET_SOURCE       "Ticket source (manual|github|jira)"       "manual"
prompt ARTIFACT_DIR        "Traceability artifact directory"          ".agentic/stories"
prompt SKILLS_DIR          "Where to install project skills"          "$WORKSPACE_ROOT/.opencode/skills"

# ---- confirm ---------------------------------------------------------------

echo
echo "About to apply:"
printf '  %-20s %s\n' PROJECT_NAME "$PROJECT_NAME"
printf '  %-20s %s\n' PROJECT_SLUG "$PROJECT_SLUG"
printf '  %-20s %s\n' WORKSPACE_ROOT "$WORKSPACE_ROOT"
printf '  %-20s %s\n' TICKET_PREFIX "$TICKET_PREFIX"
printf '  %-20s %s\n' DEFAULT_BASE_BRANCH "$DEFAULT_BASE_BRANCH"
printf '  %-20s %s\n' TICKET_SOURCE "$TICKET_SOURCE"
printf '  %-20s %s\n' ARTIFACT_DIR "$ARTIFACT_DIR"
printf '  %-20s %s\n' SKILLS_DIR "$SKILLS_DIR"
echo
read -r -p "Proceed? (y/N): " CONFIRM || true
case "${CONFIRM:-}" in
  y|Y|yes|YES) ;;
  *) echo "Aborted."; exit 1 ;;
esac

# ---- persist answers -------------------------------------------------------

mkdir -p "$(dirname "$CONFIG_FILE")"
cat > "$CONFIG_FILE" <<EOF
PROJECT_NAME="$PROJECT_NAME"
PROJECT_SLUG="$PROJECT_SLUG"
WORKSPACE_ROOT="$WORKSPACE_ROOT"
TICKET_PREFIX="$TICKET_PREFIX"
DEFAULT_BASE_BRANCH="$DEFAULT_BASE_BRANCH"
TICKET_SOURCE="$TICKET_SOURCE"
ARTIFACT_DIR="$ARTIFACT_DIR"
SKILLS_DIR="$SKILLS_DIR"
EOF

# ---- substitute placeholders ----------------------------------------------
# bash 3.2 (macOS default) has no associative arrays, so we substitute
# each known placeholder explicitly.

substitute_file() {
  local file="$1"
  [ -f "$file" ] || return 0
  sed_inplace "s|{{PROJECT_NAME}}|$(sed_escape "$PROJECT_NAME")|g" "$file"
  sed_inplace "s|{{PROJECT_SLUG}}|$(sed_escape "$PROJECT_SLUG")|g" "$file"
  sed_inplace "s|{{WORKSPACE_ROOT}}|$(sed_escape "$WORKSPACE_ROOT")|g" "$file"
  sed_inplace "s|{{TICKET_PREFIX}}|$(sed_escape "$TICKET_PREFIX")|g" "$file"
  sed_inplace "s|{{DEFAULT_BASE_BRANCH}}|$(sed_escape "$DEFAULT_BASE_BRANCH")|g" "$file"
  sed_inplace "s|{{TICKET_SOURCE}}|$(sed_escape "$TICKET_SOURCE")|g" "$file"
  sed_inplace "s|{{ARTIFACT_DIR}}|$(sed_escape "$ARTIFACT_DIR")|g" "$file"
}

echo
echo "Substituting placeholders in agent + command files..."
for file in "${TARGET_GLOBS[@]}"; do
  [ -f "$file" ] || continue
  substitute_file "$file"
  echo "  updated $(basename "$file")"
done

# ---- install skill templates ----------------------------------------------

echo
echo "Installing skill templates into $SKILLS_DIR ..."
mkdir -p "$SKILLS_DIR"
for slot in project-domain project-architecture project-test-strategy project-workflow; do
  src="$ROOT_DIR/skills/_templates/$slot/SKILL.md"
  dest_dir="$SKILLS_DIR/$slot"
  if [ -e "$dest_dir/SKILL.md" ]; then
    echo "  skip $slot (already exists)"
    continue
  fi
  mkdir -p "$dest_dir"
  cp "$src" "$dest_dir/SKILL.md"
  # substitute placeholders inside the installed template too
  substitute_file "$dest_dir/SKILL.md"
  echo "  installed $slot"
done

# ---- done ------------------------------------------------------------------

cat <<EOF

Setup complete.

Next steps:
  1. Point OpenCode at these agents/commands (see README "Install").
  2. Fill in your project knowledge. Two options:
       a. Run  /bootstrap-project   — the agents scan your codebase and ticket
          system and write the four skills for you (asking questions as needed).
       b. Or edit the templates in $SKILLS_DIR by hand.
  3. Kick off work with  /develop <ticket-or-story>.

  If TICKET_SOURCE=jira, configure a Jira MCP (see README). manual/github need none.
EOF
