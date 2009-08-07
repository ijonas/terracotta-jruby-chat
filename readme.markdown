# JRuby-based Chat Server using TerraCotta #

These source code files form an updated version of the example Jonas Boner wrote about a distributd chat server implemented in JRuby using Terracotta as the 'message bus'.

During subsequent revisions of both Terracotta as well as JRuby, the example had stopped working. These files bring that example
update to date for JRuby 1.3.1 and Terracotta 3.0.1.

You will need installs of both JRuby and Terracotta with JRUBY_HOME and TC_HOME pointing to the base folders of both products respectively, e.g.

  export JRUBY_HOME=$HOME/java/jruby-1.3.1
  export TC_HOME=$HOME/java/terracotta-3.0.1

Once these environment variables have been setup you can start a Terracotta server, followed launching multiple clients by typing:

  ./chat.sh

## Background ##

The key to fixing the example was fixing the java.lang.NoClassDefFoundError: com/tc/object/event/DmiManager, caused by the references to com.tc.object.bytecode.Manager in the terracotta.rb file:

  WRITE_LOCK = com.tc.object.bytecode.Manager::LOCK_TYPE_WRITE  
  READ_LOCK = com.tc.object.bytecode.Manager::LOCK_TYPE_READ  
  CONCURRENT_LOCK = com.tc.object.bytecode.Manager::LOCK_TYPE_CONCURRENT
  
Replacing the above fragment with:
  
  WRITE_LOCK = 2  
  READ_LOCK = 1
  CONCURRENT_LOCK = 4
  
and the whole example springs to life.

Enjoy,
Ijonas.