temp_marker="_tmp"
target_prefix="/opt/raspberrypi/root"

echo "Fixing symbolic links..."

for file in /opt/raspberrypi/root/usr/lib/arm-linux-gnueabihf/*
do
    #attempt to read as link
    existing_link=$(readlink $file)

    #test if it's hard-coded to rpi root directory
    if echo "$existing_link" | grep -q "^/lib/arm-linux-gnueabihf"
    then
        echo "Found:         $file -> $existing_link"
        echo "Recreating as: $file -> $target_prefix$existing_link"

        #create a new link with the VM target prefix and switch out for the old one
        sudo ln -s "$target_prefix$existing_link" "$file$temp_marker"
        sudo rm -f $file
        sudo mv "$file$temp_marker" $file
    fi
done

echo "Done."