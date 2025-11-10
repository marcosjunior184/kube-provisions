#!/bin/sh
set -e
echo "Starting file transfer process..."

# Install necessary tools
apk add --no-cache rsync openssh-client

# Setup SSH connection to external server
mkdir -p /root/.ssh
echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
ssh-keyscan -H $MEDIA_SERVER_HOST > /root/.ssh/known_hosts

# STEP 1: "PULL" - Check for completed downloads in isolated volume
echo "Checking for completed downloads..."

# Find completed files (no .part files present)
find /downloads-src -type f \( -name "*.mkv" -o -name "*.mp4" -o -name "*.avi" \) | while read file; do
  # Check if download is complete (no corresponding .part file)
  if [ ! -f "${file}.part" ]; then
    echo "Found completed file: $file"
    
    # STEP 2: "PUSH" - Transfer to external server
    # Determine if it's TV or Movie based on path
    if echo "$file" | grep -q "/tv/"; then
      dest_path="/media/tv/$(basename "$file")"
    else
      dest_path="/media/movies/$(basename "$file")"
    fi
    
    # Transfer file
    scp -o StrictHostKeyChecking=no \
        "$file" \
        $MEDIA_SERVER_USER@$MEDIA_SERVER_HOST:"$dest_path"
    
    # Remove source file after successful transfer
    if [ $? -eq 0 ]; then
      rm "$file"
      echo "Successfully transferred: $file"
    else
      echo "Failed to transfer: $file"
    fi
  fi
done

# Clean up empty directories
find /downloads-src -type d -empty -delete

echo "File transfer process completed"