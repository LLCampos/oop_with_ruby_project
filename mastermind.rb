# peg
class Peg
  attr_reader :color, :position
  def initialize(color, position)
    @color = color
    @position = position
  end
end

# code
class Code < Array
  attr_reader :code
  def initialize(peg1, peg2, peg3, peg4)
    @code = [peg1, peg2, peg3, peg4]
  end

  # shows code  colors
  def show_code
    @code.map(&:color).join(' ')
  end
end


# turns an array into a code
def a_to_c(array)
  Code.new(Peg.new(array[0], 0), Peg.new(array[1], 1), Peg.new(array[2], 2), Peg.new(array[3], 3))
end

# create random code
def random_code
  Code.new(random_peg(0), random_peg(1), random_peg(2), random_peg(3))
end

# well, the colors
def colors
  %w(red green blue purple pink orange)
end

# creates a new peg in postion n
def random_peg(n)
  Peg.new(colors[rand(6)], n)
end


def peg_choice
  loop do
    puts "Colors: #{colors.join(', ')}"
    @input = gets.chomp.downcase
    if colors.include?(@input)
      break
    else
      puts 'You have to choose one of the available colors!'
    end
  end
  @input
end

# starts game
def new_game
  puts 'Hello, welcome to Mastermind!!!'
  code_breaker
end

# prompts the user to choose his code
def user_guess_choice
  (0..3).to_a.map do |x|
    puts "Which peg will you put on position #{x + 1}?"
    peg_choice
  end
end

# game when user is the Code Breaker
def code_breaker
  rcode = random_code
  puts 'The computer already choose its code. Make your guess:'
  user_guess = a_to_c(user_guess_choice)
  puts 'Your guess:'
  puts user_guess.show_code
  compare_codes(user_guess.show_code.split, rcode.show_code.split, user_guess.show_code.split)
  i = 9
  while i > 0
    puts "You have #{i} more guesses!"
    turns(rcode)
    i -= 1
  end
  puts "You lost! The code was #{rcode.show_code}."
  new_game
end

# a turn
def turns(rcode)
  puts 'Make your new guess:'
  user_guess = a_to_c(user_guess_choice)
  puts 'Your new guess:'
  puts user_guess.show_code
  compare_codes(user_guess.show_code.split, rcode.show_code.split, user_guess.show_code.split)
end

# victory message and restart game
def victory_code_breaker
  puts 'Congratulations Code Breaker, you won!'
  new_game
end

# compares codes from codebreaker and codemaker
def compare_codes(code1, code2, code12)
  cpr, cr = cpr_and_cr(code1, code2, code12)
  if cpr == 4
    victory_code_breaker
  else
    puts "You have #{cpr} pegs of the right color in the right place and #{cr} pegs of the right color in wrong place!"
  end
end

# delete elements in the same position and color
def del_cpr(x, y)
  x.delete_if.with_index do |peg, index|
    peg == y[index]
  end
end

# gives cpr (color and position right) and cr (color right)
def cpr_and_cr(code1, code2, code12)
  del_cpr(code1, code2)
  del_cpr(code2, code12)
  cpr = 4 - code1.size
  cr = cr(code1, code2)
  [cpr, cr]
end

def cr(code1, code2)
  code1.size - (code1 - code2).size
end


new_game