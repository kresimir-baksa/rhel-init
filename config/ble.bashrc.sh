# Add this lines at the top of .bashrc:
[[ $- == *i* ]] && source path-to-blesh --noattach && source path-to-blesh-colors

# Add this line at the end of .bashrc:
[[ ${BLE_VERSION-} ]] && ble-attach