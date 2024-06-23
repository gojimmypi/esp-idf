#!/bin/bash

# Define an array with all submodule paths
submodules_master=(
  "components/bt/controller/lib_esp32"
  "components/bt/controller/lib_esp32c3_family"
  "components/bt/host/nimble/nimble"
  "components/esp_wifi/lib"
  "components/lwip/lwip"
  "components/openthread/lib"
)

submodules_main=(
  "components/esp_coex/lib"
)

# Loop through each submodule and reset it
for submodule in "${submodules_master[@]}"; do
  if [ -d "$submodule" ]; then
    echo "$submodule"
    cd "$submodule"
    git fetch origin
    git reset --hard origin/master  # Replace 'master' with the appropriate branch if needed
    cd -  # Go back to the main repository directory
  else
    echo "Submodule path '$submodule' does not exist. Skipping..."
  fi  
done

for submodule in "${submodules_main[@]}"; do
  if [ -d "$submodule" ]; then
    echo "$submodule"
    cd "$submodule"
    git fetch origin
    git reset --hard origin/main  # Replace 'master' with the appropriate branch if needed
    cd -  # Go back to the main repository directory
  else
    echo "Submodule path '$submodule' does not exist. Skipping..."
  fi
done
