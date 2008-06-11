#!/usr/bin/env ruby

Pressed = 1
Repeated = 2
Released = 0

keyboard_dev = '/dev/input/event1'
stream = open(keyboard_dev)
@dict = {
  10 => '1',
  11 => '2',
  12 => '3',
  13 => '4',
  14 => '5',
  15 => '6',
  16 => '7',
  17 => '8',
  18 => '9',
  19 => '0',
  22 => '⌫',
  23 => 'tab',
  24 => 'q',
  25 => 'w',
  26 => 'e',
  27 => 'r',
  28 => 't',
  29 => 'y',
  30 => 'u',
  31 => 'i',
  32 => 'o',
  33 => 'p',
  34 => 'è',
  35 => '+',
  36 => '⏎',
  37 => 'ctrl',
  38 => 'a',
  39 => 's',
  40 => 'd',
  41 => 'f',
  42 => 'g',
  43 => 'h',
  44 => 'j',
  45 => 'k',
  46 => 'l',
  47 => 'ò',
  48 => 'à',
  50 => '⇧',
  51 => 'ù',
  52 => 'z',
  53 => 'x',
  54 => 'c',
  55 => 'v',
  56 => 'b',
  57 => 'n',
  58 => 'm',
  59 => ',',
  60 => '.',
  61 => '-',
  62 => '↑',
  63 => '*',
  64 => 'alt',
  67 => 'F1',
  68 => 'F2',
  69 => 'F3',
  70 => 'F4',
  71 => 'F5',
  72 => 'F6',
  73 => 'F7',
  74 => 'F8',
  75 => 'F9',
  76 => 'F10',
  82 => '-',
  86 => '+',
  95 => 'F11',
  96 => 'F12',
  105 => 'ctrl',
  106 => '/',
  108 => 'altGr',
  110 => '↖',
  111 => '↑',
  112 => 'pag↑',
  113 => '←',
  114 => '→',
  115 => 'end',
  116 => '↓',
  117 => 'pag↓',
  118 => 'ins',
  119 => 'del',
  133 => '☠',
  134 => '☠'
}

@queue = []
@combo_keycodes = [37, 50, 62, 64, 105, 108]

# /usr/share/X11/xkb/keycodes/evdev
# /usr/share/X11/xkb/symbols/latin
# TODO
def load_keycodes_from(file)
end

def interpret(keycode,state)
   #if state == Pressed and (@combo_keycodes.find keycode).nil? 
   keycode = keycode.to_i + 8 #offset
   key = (@dict[keycode] or keycode.to_s)
   if Pressed == state and @combo_keycodes.include? keycode
     @queue << key+" "
   elsif Released == state #and @combo_keycodes.include? keycode
     @queue.delete key+" "
   elsif Pressed == state and !@queue.empty? and not @combo_keycodes.include? keycode
      puts "#{@dict[keycode]} Pressed"
      `notify-send -t 500 "#{@queue} #{key}"`
   end
end
      
loop do
   line = stream.read(16)
   keycode,state = line[10], line[12]
   interpret(keycode,state) if line[10] != 0
end
