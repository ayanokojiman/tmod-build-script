
#!/bin/bash

echo "Resetting worlds"
cp -r ./World/* ../../Worlds/

echo "Attempting to terminate running tModLoader processes..."

# Try common process names first
pgrep -afi tmodloader | while read -r line; do
    # Extract the PID (first word in the line)
    pid=$(echo "$line" | awk '{print $1}')
    # Extract the command after PID (everything except the first word)
    cmd=$(echo "$line" | cut -d' ' -f2-)

    # Check if command matches the expected dotnet tModLoader path pattern
    if [[ "$cmd" == *".local/share/Steam/steamapps/common/tModLoader/dotnet/dotnet tModLoader.dll"* ]]; then
        echo "Killing process $pid running: $cmd"
        kill -9 "$pid"
    fi
done

# 2. Rebuild the .NET project.
echo "Running .NET build..."
if dotnet build; then
    echo "Build successful."
    echo "Starting tModLoader..."
    if [ "$1" == "f" ]; then
        bash $HOME/.local/share/Steam/steamapps/common/tModLoader/start-tModLoader.sh
    else 
        nohup $HOME/.local/share/Steam/steamapps/common/tModLoader/start-tModLoader.sh > /dev/null 2>&1 &
    fi
else
    echo "ERROR: Build failed. Check the output above for errors."
    exit 1
fi

