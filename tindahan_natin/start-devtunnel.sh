#!/bin/bash
ENV_FILE=".env"
PORT_A=5336
PORT_B=8000

# 1. Setup persistent tunnel and both ports if missing
devtunnel show tindahannatinfluttertunnel > /dev/null 2>&1
if [ $? -ne 0 ]; then
  devtunnel create tindahannatinfluttertunnel --allow-anonymous
  devtunnel port create tindahannatinfluttertunnel -p $PORT_A
  devtunnel port create tindahannatinfluttertunnel -p $PORT_B
fi

# 2. Kill any old background instances using this log file
pkill -f "devtunnel host tindahannatinfluttertunnel"

# 3. Host in background
devtunnel host tindahannatinfluttertunnel > tunnel.log 2>&1 &

# 4. Wait for both endpoint assignments to populate in the log
while [ $(grep -c "https://" tunnel.log) -lt 2 ]; do
  sleep 0.5
done

# 5. Extract unique URLs sorted by port number
URL_A=$(grep -o "https://[a-zA-Z0-9-]*-$PORT_A\.devtunnels\.ms" tunnel.log | head -n 1)
URL_B=$(grep -o "https://[a-zA-Z0-9-]*-$PORT_B\.devtunnels\.ms" tunnel.log | head -n 1)

echo $URL_A
echo $URL_B

# 6. Update the .env file cleanly
#if [ -f "$ENV_FILE" ]; then
#  sed -i '' '/^SERVER_HTTP=/d; /^PUBLIC_WEB_APP_BASE_URL=/d' "$ENV_FILE" 2>/dev/null || sed -i '/^SERVER_HTTP=/d; /^PUBLIC_WEB_APP_BASE_URL=/d' "$ENV_FILE"
#  echo "SERVER_HTTP=$URL_A" >> "$ENV_FILE"
#  echo "PUBLIC_WEB_APP_BASE_URL=$URL_B" >> "$ENV_FILE"
#else
#  echo "SERVER_HTTP=$URL_A" > "$ENV_FILE"
#  echo "PUBLIC_WEB_APP_BASE_URL=$URL_B" >> "$ENV_FILE"
#fi
#
#echo "Tunnel configured:"
#echo "Port $PORT_A -> $URL_A"
#echo "Port $PORT_B -> $URL_B"