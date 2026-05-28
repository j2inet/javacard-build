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

#Installing PCSC LITE
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


#mkdir /home/j2inet/java_card_sdk/PCSC/tools
#curl https://pcsc-tools.apdu.fr/pcsc-tools-1.7.4.tar.bz2 -o ./pcsc-tools-1.7.4.tar.bz2
#tar -xjf ./pcsc-tools-1.7.4.tar.bz2 -C "${installDir}/PCSC/tools"
#PCSC_TOOLS_PATH="${installDir}/PCSC/tools"
#ls -lisa "${PCSC_TOOLS_PATH}"

JCSDK_CONFIG_NAME="jcsdk_config"
READER_CONFIG='/etc/reader.conf.d/$JCSDK_CONFIG_NAME'
echo "Checking config file."
if [ -f "$READER_CONFIG" ]; then
    echo "Config file already exists."
else
    echo -e "\x1b[36mCreating configuration file\033[0m"  
    echo "# Configuration example of two readers to interact with the" > $JCSDK_CONFIG_NAME
    echo "# Oracle PCSC Reader for Linux " >> $JCSDK_CONFIG_NAME
    echo "FRIENDLYNAME Oracle_Java_Card_PCSC_Reader_0" >> $JCSDK_CONFIG_NAME
    echo "DEVICENAME 127.0.0.1:9025" >> $JCSDK_CONFIG_NAME
    echo "LIBPATH $javaCardSimulatorDir/IFDHandler/libjcsdkifdh.so " >> $JCSDK_CONFIG_NAME
    echo "FRIENDLYNAME Oracle_Java_Card_PCSC_Reader_1" >> $JCSDK_CONFIG_NAME
    echo "DEVICENAME 127.0.0.1:9026" >> $JCSDK_CONFIG_NAME
    echo "LIBPATH $javaCardSimulatorDir/IFDHandler/libjcsdkifdh.so" >> $JCSDK_CONFIG_NAME
    cat $JCSDK_CONFIG_NAME
    echo "mkdir  /etc.reader.conf.d" > ${JCSDK_CONFIG_NAME}.sh
    echo "cp ${JCSDK_CONFIG_NAME} /etc.reader.conf.d/$JCSDK_CONFIG_NAME" >> ${JCSDK_CONFIG_NAME}.sh
    echo "sudo systemctl restart pcscd" >>  ${JCSDK_CONFIG_NAME}.sh
    echo "sudo systemctl restart pcscd.socket" >>  ${JCSDK_CONFIG_NAME}.sh
    chmod +x ${JCSDK_CONFIG_NAME}.sh
    echo -e "\x1b[36mRemember to run ${JCSDK_CONFIG_NAME}.sh\x1b[30m"
fi



#For Open SSL Configuration. See https://docs.oracle.com/en/java/javacard/3.2/jcdksu/configure-openssl-linux.html
export LD_LIBRARY_PATH=$JC_HOME_SIMULATOR/bin
export OPENSSL_MODULES=$JC_HOME_SIMULATOR/runtime/bin


export JAVA_HOME="$javaJdkInstallDir";
export JC_HOME="$javaCardSdkDir";
export JC_SIMULATOR_HOME="$javaCardSimulatorDir";
export JC_HOME_SIMULATOR="$javaCardSimulatorDir";
export JC_HOME_TOOLS=""
export CLASSPATH="$JC_HOME/lib/api_classic-3.2.0.jar:$JC_HOME/lib/tools.jar:$JC_SIMULATOR_HOME/lib/simulator.jar:${JC_SIMULATOR_HOME}/AMService/docs:${JC_SIMULATOR_HOME}/AMService/amservice.jar";
export PATH="$JAVA_HOME/bin:${JC_SIMULATOR_HOME}:${JC_SIMULATOR_HOME}/bin:$PCSC_TOOLS_PATH:$PATH";

export JC_HOME_TOOLS="$javaCardSdkDir";
ls  "$JAVA_HOME/bin";
ls "$JC_HOME"
ls "$JC_HOME_TOOLS"
echo $PCSC_HOME
ls $PCSC_HOME
#cd src
#javac WalletApplet.java


echo -e "\x1b[36mConfigure ${JC_HOME_SIMULATOR}/client.config.properties\x1b[0m"
echo -e "find more information at \x1b[36mhttps://docs.oracle.com/en/java/javacard/3.2/jcdksu/how-run-samples.html\x1b[0m"
echo -e "\x1b[35m"
echo "A000000151000000_scp03enc_<KVN>=<Enter your 32-bit enc key here> "
echo "A000000151000000_scp03mac_<KVN>=<Enter your 32-bit mac key here> "
echo "A000000151000000_scp03dek_<KVN>=<Enter your 32-bit dek key here>"
echo -e "\x1b[0m"
echo "Such as the following."
echo -e "\x1b[35m"
echo A000000151000000_scp03enc_10=1111111111111111111111111111111111111111111111111111111111111111 
echo A000000151000000_scp03mac_10=2222222222222222222222222222222222222222222222222222222222222222 
echo A000000151000000_scp03dek_10=3333333333333333333333333333333333333333333333333333333333333333
echo -e "\x1b[30m"
echo
echo "Not that the run and build scripts provided by oracle may appear to paths that do not exists. I "
echo "had to remove references to a non-existent `samples` folder and `runtimes` folder to get the "
echo "sample code to compile."
