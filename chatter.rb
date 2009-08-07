require 'java'  
load 'terracotta.rb'  
  
class Chatter  
  def initialize  
    @name = ARGV[0]  
    @messages = DSO.createRoot "chatter", java.util.ArrayList.new  
    puts "--- Hi #{@name}. Welcome to Chatter. Press Enter to refresh ---"  
  end  
  
  def run  
    while true do  
      print "Enter Text>>"  
      text = STDIN.gets.chomp  
      if text.length > 0 then  
        DSO.guard @messages do  
          @messages.add "[#{Time.now} -- #{@name}] #{text}"  
          puts @messages  
        end  
      else  
        puts @messages  
     end  
    end  
  end  
end  
  
Chatter.new.run