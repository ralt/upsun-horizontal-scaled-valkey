#!/bin/bash

# Create cache directory if it doesn't exist
mkdir -p $PLATFORM_CACHE_DIR/valkey

# Check if Valkey 9.0.0 is already cached
if [ ! -f "$PLATFORM_CACHE_DIR/valkey/valkey-${VALKEY_VERSION}.tar.gz" ]; then
  echo "Downloading Valkey ${VALKEY_VERSION}..."
  curl -L https://github.com/valkey-io/valkey/archive/refs/tags/"$VALKEY_VERSION".tar.gz \
    -o $PLATFORM_CACHE_DIR/valkey/valkey-"$VALKEY_VERSION".tar.gz
else
  echo "Using cached Valkey ${VALKEY_VERSION}"
fi

# Extract and build Valkey
echo "Extracting and building Valkey..."
tar -xzf $PLATFORM_CACHE_DIR/valkey/valkey-"$VALKEY_VERSION".tar.gz -C $PLATFORM_APP_DIR
mv $PLATFORM_APP_DIR/valkey-"$VALKEY_VERSION" $PLATFORM_APP_DIR/valkey

cd $PLATFORM_APP_DIR/valkey
make -j$(nproc)

echo "Valkey build completed!"
