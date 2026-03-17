#!/bin/bash
# One-liner installer: copy-paste & run as normal user (no sudo needed)
# Creates deep-hidden ducky art that shows on every new terminal startup

# Deep path mimicking icon cache (invisible to casual ls)
DUCKY_PATH="$HOME/.local/share/icons/hicolor/48x48/apps/.system/.cache/.ducky"
LAUNCHER_PATH="$HOME/.local/share/applications/.99ducky.desktop"

# Create deep nested dirs & hidden art script
mkdir -p "$DUCKY_PATH"
cat > "$DUCKY_PATH/art.sh" << 'EOF'
#!/bin/bash
clear
cat << 'ART'
      _      _      _        USB       _      _      _
   __(.)< __(.)> __(.)=     Rubber   >(.)__ <(.)__ =(.)__
  \\___)  \\___)  \\___)    Ducky!    (___/  (___/  (___/
ART
sleep 2
EOF
chmod +x "$DUCKY_PATH/art.sh"

# Hidden launcher via .desktop (runs silently on shell startup)
cat > "$LAUNCHER_PATH" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Exec=$DUCKY_PATH/art.sh
Hidden=true
NoDisplay=true
EOF
chmod +x "$LAUNCHER_PATH"

# Append stealth trigger to .bashrc (runs art on every new terminal)
echo "# Ducky stealth loader" >> ~/.bashrc
echo "[ -x $LAUNCHER_PATH ] && $DUCKY_PATH/art.sh >/dev/null 2>&1" >> ~/.bashrc

echo "✓ Ducky hidden deep: $DUCKY_PATH/art.sh"
echo "✓ Auto-runs every new terminal (check with: bash)"
echo "✓ Remove: rm -rf $DUCKY_PATH $LAUNCHER_PATH && sed -i '$d' ~/.bashrc"
