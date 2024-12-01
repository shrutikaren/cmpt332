#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to handle cleanup on exit
cleanup() {
    echo "Cleaning up..."

    # Remove device nodes if they were created
    if [ -n "$WRITE_DEVICE" ] && [ -e "$WRITE_DEVICE" ]; then
        sudo rm "$WRITE_DEVICE" || echo "Warning: Failed to remove $WRITE_DEVICE"
    fi

    if [ -n "$READ_DEVICE" ] && [ -e "$READ_DEVICE" ]; then
        sudo rm "$READ_DEVICE" || echo "Warning: Failed to remove $READ_DEVICE"
    fi

    # Unload the kernel module if it's loaded
    if lsmod | grep -q "pipe-driver"; then
        sudo rmmod pipe-driver || echo "Warning: Failed to remove pipe-driver module."
    fi

    echo "Cleanup completed."
}

# Trap EXIT signal to ensure cleanup is performed
trap cleanup EXIT

echo "===== Start Testing ====="

# Step 1: Compile the Kernel Module and User-Space Program
echo "Compiling the kernel module and test program..."
make || { echo "Compilation failed."; exit 1; }

# Step 2: Load the Kernel Module
echo "Loading the pipe-driver kernel module..."
sudo insmod pipe-driver.ko || { echo "Failed to insert pipe-driver module."; exit 1; }

# Allow some time for the module to initialize
sleep 1

# Step 3: Retrieve the Major Number Dynamically
echo "Retrieving the major number assigned to 'fifo'..."
MAJOR_NUMBER=$(grep 'fifo' /proc/devices | awk '{print $1}')

# Validate that the major number was found
if [ -z "$MAJOR_NUMBER" ]; then
    echo "Failed to retrieve the major number for 'fifo' from /proc/devices."
    exit 1
fi

echo "Major number for 'fifo' is: $MAJOR_NUMBER"

# Step 4: Generate Random Device Node Numbers Between 100 and 250
echo "Generating random device node numbers between 100 and 250..."
while true; do
    RANDOM_BASE=$(shuf -i 100-249 -n 1) # 249 to ensure RANDOM_BASE+1 <=250
    # Ensure the chosen base does not conflict with existing device nodes
    if [ ! -e "/dev/fifo${RANDOM_BASE}" ] && [ ! -e "/dev/fifo$((RANDOM_BASE + 1))" ]; then
        break
    fi
done

echo "Selected base number: $RANDOM_BASE"

# Define device node paths
WRITE_DEVICE="/dev/fifo${RANDOM_BASE}"
READ_DEVICE="/dev/fifo$((RANDOM_BASE + 1))"

# Step 5: Create Device Nodes with the Assigned Major Number and Minor Numbers
echo "Creating device nodes..."
sudo mknod "$WRITE_DEVICE" c "$MAJOR_NUMBER" 0 || { echo "Failed to create $WRITE_DEVICE."; exit 1; }
sudo mknod "$READ_DEVICE" c "$MAJOR_NUMBER" 1 || { echo "Failed to create $READ_DEVICE."; exit 1; }

# Step 6: Set Appropriate Permissions
echo "Setting permissions for device nodes..."
sudo chmod 666 "$WRITE_DEVICE" "$READ_DEVICE" || { echo "Failed to set permissions."; exit 1; }

echo "Device nodes created:"
ls -l "$WRITE_DEVICE" "$READ_DEVICE"

# Step 7: Run the User-Space Test Program with Device Node Paths as Arguments
echo "Running the user-space test program 'driver-PC'..."
./driver-PC "$WRITE_DEVICE" "$READ_DEVICE" || { echo "Test program encountered an error."; exit 1; }

echo "Test program completed successfully."

echo "===== Success ====="
