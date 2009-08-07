#/bin/sh
java -Xbootclasspath/p:$TC_HOME/lib/dso-boot/dso-boot-hotspot_osx_150_19.jar -Dtc.install-root=$TC_HOME -Dtc.config=./tc-config.xml -jar $JRUBY_HOME/lib/jruby.jar chatter.rb