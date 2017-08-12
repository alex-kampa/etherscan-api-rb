
## read data utilities

def get_msh(v)
  File.open("data.msh/#{v}.msh", 'rb') { |f| return Marshal.load(f) }
end

## formatting

def comma_numbers(number, delimiter = ',')
  number.to_i.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
end

## output utilities

require 'pp'

def output_pp(x, f)
  write_to_file('', f)
  stdout_original = STDOUT.clone
  STDOUT.reopen(f, 'a')
  pp x
  STDOUT.reopen(stdout_original)
end

def write_to_file(x, target_file, mode='w')
  File.open(target_file, mode) { |f| f.write x }
end

## logging

class SimpleLog

  attr_reader :sLog, :sWarn

  def initialize(h={:verbose => nil})
    @verbose = h[:verbose]
    @sLog = ''
    @sWarn = ''
  end

  def silent
    @verbose = nil
  end
  
  def loud
    @verbose = 1
  end
  
  def p(x='')
    s = x.to_s + "\n" 
    @sLog << s
    puts s if @verbose
  end

  def h1(x)
    s, deco = '', '==== '
    s << "\n" + deco + "\n"
    s << deco + x.to_s + "\n"
    s << deco + "\n"
    @sLog << s
    puts s if @verbose
  end

  def h2(x)
    s, deco = '', '== '
    s << "\n" + deco + "\n"
    s << deco + x.to_s + "\n"
    s << deco + "\n"
    @sLog << s
    puts s if @verbose
  end

  def h3(x)
    s, deco = '', '>> '
    s << "\n"
    s << deco + x.to_s + "\n"
    s << "\n"
    @sLog << s
    puts s if @verbose
  end
  
  def warn(x='')
    s = x.to_s + "\n"
    @sLog << s
    @sWarn << s
    puts s if @verbose
  end

  def shout(x='')
    s = x.to_s + "\n"
    @sLog << s
    @sWarn << s
    puts s
  end
  
end