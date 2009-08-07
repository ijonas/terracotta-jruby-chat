# Usage:  
#  
# # create an instance of 'foo' as a DSO root this  
# # means that it will be shared across the cluster  
# foo = DSO.createRoot "foo", Foo.new  
#  
# # update 'foo' in a guarded block, get result back  
# result = DSO.guard foo, DSO::WRITE_LOCK do  
#   foo.add bar  
#   foo.getSum  
# end  

# require '/Users/ijonas/java/terracotta/lib/tc.jar'  
TC = com.tc.object.bytecode.ManagerUtil  
  
module DSO  
  
  # The different lock types  
  WRITE_LOCK = 2  
  READ_LOCK = 1
  CONCURRENT_LOCK = 4
  
  # Creates a Terracotta shared root, 'name' is the name of the root  
  # (can be anything that uniquily defines the root), 'object' is an  
  # instance of the object to be shared. If the root the given name  
  # already exists it simply returns it.  
  def DSO.createRoot(name, object)  
    guardWithNamedLock name, WRITE_LOCK do  
      TC.lookupOrCreateRoot name, object  
    end  
  end  
  
  # Creates a transaction and guards the object (passed in as the  
  # 'object' argument) during the execution of the block passed into  
  # the method. Similar to Java's synchronized(object) {...} blocks.  
  # Garantuees that the critical section is maintained correctly across  
  # the cluster. The type of the lock can be one of: DSO:WRITE_LOCK,  
  # DSO::READ_LOCK or DSO::CONCURRENT_LOCK (default is DSO:WRITE_LOCK).  
  def DSO.guard(object, type = WRITE_LOCK)  
    TC.monitorEnter object, type  
    begin  
      yield  
    ensure  
      TC.monitorExit object  
    end  
  end  
  
  # Creates a transaction and guards the critical section using a virtual  
  # so called 'named lock. It is held during the execution of the block  
  # passed into the method. Garantuees that the critical section is  
  # maintained correctly across the cluster. The type of the lock can  
  # be one of: DSO:WRITE_LOCK, DSO::READ_LOCK or DSO::CONCURRENT_LOCK  
  # (default is DSO:WRITE_LOCK)8.  
  def DSO.guardWithNamedLock(name, type = WRITE_LOCK)  
    TC.beginLock name, type  
    begin  
      yield  
    ensure  
      TC.commitLock name  
    end  
  end  
  
  # Dispatches a Distributed Method Call (DMI). Ensures that the  
  # particular method will be invoked on all nodes in the cluster.  
  def DSO.dmi(object, methodName, arguments)  
    TC.distributedMethodCall object, methodName, arguments  
  end  
end