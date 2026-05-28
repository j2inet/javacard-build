mkdir  /etc.reader.conf.d
cp jcsdk_config /etc.reader.conf.d/jcsdk_config
sudo systemctl restart pcscd
sudo systemctl restart pcscd.socket
