nu_base_path="$HOME/.nu_base_path"
if [[ -f "$nu_base_path" ]]; then
    NU_BASE_PATH=$(cat "$nu_base_path" | tr -d '[:space:]')
else
    NU_BASE_PATH="${HOME}/nu/nu_base"
fi

echo "NU_BASE_PATH: $NU_BASE_PATH"

nu "$NU_BASE_PATH/modules/install-desktop.nu"
