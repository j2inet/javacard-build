sudo apt install build-essential autoconf automake libtool flex pkg-config libudev-dev libusb-1.0-0-dev -y
sudo apt-get install meson  -y
sudo apt install polkitd cmake libpolkit-gobject-1-dev libsystemd0 libsystemd-dev systemd systemd-dev doxygen -y
#Installing PCSC Tools
sudo apt install pcsc-tools -y
sudo apt install pcscd
sudo systemctl enable pcscd
sudo systemctl start pcscd


# Enable 32-bit application support
# for more information, see https://docs.oracle.com/en/java/javacard/3.2/jcdksu/linux---configure-linux-operating-system-run-32-bit-applications.html

sudo dpkg --add-architecture i386
sudo apt update
sudo apt install libc6-i386