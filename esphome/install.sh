#!/data/data/com.termux/files/usr/bin/bash
termux-change-repo
pkg update && pkg upgrade -y
pkg install -y python rust git glibc-repo file
pkg update && pkg upgrade -y
pkg install -y libisl-glibc libiconv-glibc libjpeg-turbo
pkg clean
cd ~/
python -m venv ~/.esphome
source ~/.esphome/bin/activate
pip install --upgrade --no-cache wheel setuptools pip
pip install --upgrade --no-cache esphome
cp -r ~/storage/downloads/esphome/configs/ ~/.esphome/
cd ~/.esphome/configs/
esphome -v compile esp8266.yaml
esphome -v compile bk7231n.yaml
rm -f esp8266.yaml bk7231n.yaml .gitignore
rm -rf ~/.esphome/configs/.esphome/
cp ~/storage/downloads/esphome/setup_env.sh ~/
chmod +x ~/setup_env.sh
cd ~/
source setup_env.sh
