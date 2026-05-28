#!/bin/bash
echo "Setting up JavaCard development environment...";
echo "This script will install the JavaCard SDK and Simulator on your system.";
echo "Find more documentation at https://docs.oracle.com/en/java/javacard/3.2/";




#Path to the Java JDK download from https://www.oracle.com/java/technologies/downloads/#java25
javaJdkZip="/home/j2inet/Downloads/jdk-25_linux-x64_bin.tar.gz";
#Path to the directory where you want to install the Java JDK
javaJdkInstallDir="/home/j2inet/shares/sdks/java_jdk";
# Unzip the Java JDK
echo "Installing Java JDK from $javaJdkZip to $javaJdkInstallDir";
mkdir -p $javaJdkInstallDir;
tar -xzf "$javaJdkZip" -C "$javaJdkInstallDir" --strip-components=1;





# Path to JavaCard SDK download from https://www.oracle.com/java/technologies/javacard-downloads.html
javaCardSdkZip="/home/j2inet/Downloads/java_card_devkit_tools-bin-v26.0-b_705-04-MAY-2026.zip";
# Path to the directory where you want to install the JavaCard SDK
installDir="/home/j2inet/java_card_sdk";

# Path to the JavaCard Simulator downlaod from https://www.oracle.com/java/technologies/javacard-downloads.html
javaCardSimulatorZip="/home/j2inet/Downloads/java_card_devkit_simulator-linux-bin-v26.0-b_788-05-MAY-2026.tar.gz";

# Path to the JavaCard SDK installation directory
javaCardSdkDir="$installDir/java_card_devkit_tools-bin-v26.0-b_705-04-MAY-2026";
# Path to the JavaCard Simulator installation directory
javaCardSimulatorDir="$installDir/java_card_simulator-bin-v26.0-b_788-05-MAY-2026";

#Unzip the JavaCard SDK
echo "Installing JavaCard SDK from $javaCardSdkZip to $installDir";
mkdir -p $installDir;
unzip -o "$javaCardSdkZip" -d "$javaCardSdkDir";

#Unzip the JavaCard Simulator
echo "Installing JavaCard Simulator from $javaCardSimulatorZip to $installDir";
mkdir -p $javaCardSimulatorDir;
tar -xzf "$javaCardSimulatorZip" -C "$javaCardSimulatorDir" --strip-components=1;


sudo apt install build-essential autoconf automake libtool flex pkg-config libudev-dev libusb-1.0-0-dev -y
sudo apt-get install meson  -y
sudo apt install polkitd cmake libpolkit-gobject-1-dev libsystemd0 libsystemd-dev systemd systemd-dev doxygen -y
# curl https://pcsclite.apdu.fr/files/pcsc-lite-2.4.1.tar.xz -o ~/Downloads/pcsc-lite-2.4.1.tar.xz
# pcsc=~/Downloads/pcsc-lite-2.4.1.tar.xz
# mkdir $PCSC_HOME
# tar -xf "$pcsc" -C "$PCSC_HOME" --strip-components=1

export PCSC_HOME=$installDir/PCSC
pushd $PCSC_HOME
git clone git@github.com:LudovicRousseau/PCSC.git source
cd source
meson setup builddir
cd builddir
meson compile
sudo meson install
echo "\x1b[37mBuilding!\x1b[0m"
pwd
#meson compile
# sudo /usr/local/sbin/pcscd --foreground
/usr/local/sbin/pcscd --version

popd





export JAVA_HOME="$javaJdkInstallDir";
export JC_HOME="$javaCardSdkDir";
export JC_SIMULATOR_HOME="$javaCardSimulatorDir";
export JC_HOME_SIMULATOR="$javaCardSimulatorDir";
export JC_HOME_TOOLS=""
export CLASSPATH="$JC_HOME/lib/api_classic-3.2.0.jar:$JC_HOME/lib/tools.jar:$JC_SIMULATOR_HOME/lib/simulator.jar";
export PATH="$JAVA_HOME/bin:${JC_SIMULATOR_HOME}:${JC_SIMULATOR_HOME}/bin:$PATH";

export JC_HOME_TOOLS="$javaCardSdkDir";
ls  "$JAVA_HOME/bin";
ls "$JC_HOME"
ls "$JC_HOME_TOOLS"
echo $PCSC_HOME
ls $PCSC_HOME
#cd src
#javac WalletApplet.java


