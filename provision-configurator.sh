# https://docs.oracle.com/en/java/javacard/3.2/jcdksu/configuring-java-card-development-kit-simulator.html

#java -jar Configurator.jar -binary <simulator-binary> -SCP-keyset <kvn> <k_enc> <k_mac> <k_dek> -global-pin <pin> <tries_count>
$JAVA_HOME=/home/j2inet/shares/sdks/java_jdk/
${JAVA_HOME}/bin/java -jar $JC_SIMULATOR_HOME/Configurator.jar -binary $JC_SIMULATOR_HOME/bin/jcsl -SCP-keyset 10 1111111111111111111111111111111111111111111111111111111111111111 2222222222222222222222222222222222222222222222222222222222222222 3333333333333333333333333333333333333333333333333333333333333333 -global-pin 01020304050f 03


# 