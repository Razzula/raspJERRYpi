# SSH
ssh-keygen -t ed25519 -f ~/.ssh/raspJERRYpi-git -C "raspJERRYpi"

cat >> ~/.ssh/config <<'EOF'
Host github.com
    IdentityFile ~/.ssh/raspJERRYpi-git
    IdentitiesOnly yes
EOF

chmod 600 ~/.ssh/config

echo
echo "Add the following public key to GitHub:"
echo "https://github.com/settings/ssh/new"
cat ~/.ssh/raspJERRYpi-git.pub
echo
