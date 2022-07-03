
sudo apt-get update
sudo apt -y install jq feh fop
cd /home/pi/
mkdir bin
cd bin
wget https://github.com/dropbox/dbxcli/releases/download/v3.0.0/dbxcli-linux-arm
mv dbxcli-linux-arm dbxcli
chmod 755 dbxcli
