class Peg
  attr_reader :color, :position
  def initialize(color, position)
    @color = color
    @position = position
  end
end


def show_code(code)
  puts code.join(" ")
end

# create random code
def random_code
  [random_peg(0), random_peg(1), random_peg(2), random_peg(3)]
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
    @input = gets.chomp.to_i
    if @input == 1 || @input == 2
      break
    else
      'You have to choose 1 or 2!'
    end
  end
  @input
end

def peg_choice(x)
  loop do
    puts "Colors: #{colors.join(', ')}"
    @input = gets.chomp.downcase
    if colors.include?(@input)
      break
    else
      puts 'You have to choose one of the available colors!'
    end
  end
  Peg.new(@input, x)
end

def new_game
  puts 'Hello, welcome to Mastermind!'
  input = game_choice
  if input == 1
    code_breaker
  else
    code_maker
  end
end

def user_code_choice
  (0..3).to_a.map do |x|
    puts "Which peg will you put on position #{x + 1}?"
    peg_choice(x)
  end
end

def code_breaker
  rcode = random_code
  user_code = user_code_choice
  puts "Your Code:"
  show_code(user_code)
end

new_game