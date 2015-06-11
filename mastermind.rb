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


# asks the user which style of game he wants
def game_choice
  loop do
    puts 'What do you want to be?'
    puts '1 - Code Breaker'
    puts '2 - Code Maker'
    @input = gets.chomp
    if @input == '1' || @input == '2'
      break
    else
      'You have to choose 1 or 2!'
    end
  end
  @input
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

def new_game
  puts 'Hello, welcome to Mastermind!'
  input = game_choice
  if input == '1'
    code_breaker
  else
    code_maker
  end
end

def user_guess_choice
  (0..3).to_a.map do |x|
    puts "Which peg will you put on position #{x + 1}?"
    peg_choice
  end
end

# begin of game when user is the Code Breaker
def code_breaker
  rcode = random_code
  puts rcode.show_code
  puts 'The computer already choose its code. Make your guess:'
  user_guess = a_to_c(user_guess_choice)
  puts 'Your guess:'
  puts user_guess.show_code
  compare_codes(user_guess.code, rcode.code)
  i = 9
  while i > 0
    puts "You have #{i} more guesses!"
    turns(rcode)
    i -= 1
  end
  puts "You lost! The code was #{rcode.show_code}."
  new_game
end


def turns(rcode)
  puts 'Make your new guess:'
  user_guess = a_to_c(user_guess_choice)
  puts 'Your new guess:'
  puts user_guess.show_code
  compare_codes(user_guess.code, rcode.code)
end


def victory_code_breaker
  puts 'Congratulations Code Breaker, you won!'
  new_game
end

def compare_codes(code1, code2)
  a = compare(code1, code2)
  if a[0] == 4
    victory_code_breaker
  else
    puts "You have #{a[0]} pegs of the right color in the right place and #{a[1]} pegs of the right color in wrong place!"
  end
end

def compare(code1, code2)
  @cpr = 0
  @cr = 0
  code1.each do |peg1|
    code2.each do |peg2|
      if peg1.color == peg2.color
        if peg1.position == peg2.position
          @cpr += 1
        else
          @cr += 1
        end
        break
      else
      end
    end
  end
  [@cpr, @cr]
end


new_game