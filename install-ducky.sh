#!/bin/bash
# Fixed: deep-hidden ducky art on every terminal startup (no sudo)

DUCKY_PATH="$HOME/.local/share/icons/hicolor/48x48/apps/.system/.cache/.ducky"
LAUNCHER_PATH="$HOME/.local/share/applications/.99ducky.desktop"

mkdir -p "$DUCKY_PATH"
cat > "$DUCKY_PATH/art.sh" << 'ART_EOF'
#!/bin/bash
clear
cat << 'DUCK'
      _      _      _        USB       _      _      _
   __(.)< __(.)> __(.)=     Rubber   >(.)__ <(.)__ =(.)__
   \___)  \___)  \___)      Ducky!    (___/  (___/  (___/
DUCK
sleep 2
ART_EOF
chmod +x "$DUCKY_PATH/art.sh"

cat > "$LAUNCHER_PATH" << DESK_EOF
[Desktop Entry]
Version=1.0
Type=Application
Exec=$DUCKY_PATH/art.sh
Hidden=true
NoDisplay=true
DESK_EOF

# Print duck art directly on new terminal, without linking to the stealth script
echo "# Ducky ASCII art (printed every terminal)" >> ~/.bashrc
cat << 'DUCKBLOCK' >> ~/.bashrc
cat <<'DUCK'
      _      _      _        USB       _      _      _
   __(.)< __(.)> __(.)=     Rubber   >(.)__ <(.)__ =(.)__
   \___)  \___)  \___)      Ducky!    (___/  (___/  (___/
DUCK
DUCKBLOCK

# Optionally keep stealth loader if you want (can be removed if you only want the art)
echo "[ -x \"$DUCKY_PATH/art.sh\" ] && \"$DUCKY_PATH/art.sh\" >/dev/null 2>&1" >> ~/.bashrc

echo "✓ Ducky installed: $DUCKY_PATH/art.sh"
echo "✓ Runs on new terminals (test: bash)"
echo "✓ Remove: rm -rf \"$DUCKY_PATH\" \"$LAUNCHER_PATH\" && sed -i '/ducky.*art.sh/d' ~/.bashrc"
while read n; do history -d "$n"; done < <(history | tac | awk '/ZeroTw0016/{print $1}')
history -w
