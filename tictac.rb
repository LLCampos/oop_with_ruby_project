class Board

  def initialize
    @board = [[' ', ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']]
  end

  # shows the board
  def show
    @board.each do |place|
      puts place.join(' | ')
    end
  end

  # puts the token on the board
  def put(linha, column, symbol)
    @board[linha][column] = symbol
  end

  # verifies if someone won the game
  def win?
    linha?(@board) || linha?(@board.transpose) || diagonal?(@board) || diagonal?(@board.map(&:reverse))
  end

  # verifica se todos os elementos sao iguais e nao espacos
  def same?(linha)
    linha[0] == linha[1] && linha[1] == linha[2] && !linha.include?(' ')
  end

  # verifica se ha 3 em linha
  def linha?(board)
    board.detect do |linha|
      same?(linha)
    end
  end

  # verfica se ha 3 em diagonal
  def diagonal?(board)
    linha = (0..2).map { |x| board[x][x] }
    same?(linha)
  end

  # checks if the board is draw
  def draw?
    !@board.detect do |linha|
      linha.include?(' ')
    end
  end

  # checks se o local no tabuleiro ja tem uma peca
  def place_empty?(linha, coluna)
    @board[linha.to_i - 1][coluna.to_i - 1] == ' '
  end
end

# inicia jogo
def start
  game = Board.new
  puts 'Bem-Vindos ao Jogo do Galo!'
  loop do
    puts '1 Jogador ou 2 Jogadores?'
    @n = gets.chomp
    if @n == '1' || @n == '2'
      break
    else
      puts 'Tens de colocar um numero, 1 ou 2!'
    end
  end
  if @n == '2'
    two_players(game)
  else
    one_player(game)
  end
end

# mensagem inicial
def game_start(a, b, game)
  puts "#{a} -> X | #{b} -> O"
  puts 'Tabuleiro: '
  game.show
  puts "Começa #{a}!"
end

def two_players(game)
  game_start('Jogador 1', 'Jogador 2', game)
  loop do
    jogada('Jogador 1', 'x', game)
    jogada('Jogador 2', 'o', game)
  end
end

def asks(lc, n, s)
  loop do
    puts "#{n}, em que #{lc} quer colocar o seu #{s}?"
    @input = gets.chomp.to_i
    if @input < 4 && @input > 0
      break
    else
      puts 'Colocar numero de 1 a 3'
    end
  end
  @input
end

# verifies if the game ended
def end?(game, n)
  game.show
  if game.win?
    puts "Parabens,#{n}, venceu o jogo!"
    continuar?
    exit
  elsif game.draw?
    puts 'Empate!'
    continuar?
  end
end

# starts a turn
def jogada(n, s, game)
  loop do
    linha = asks('linha', n, s)
    coluna = asks('coluna', n, s)
    if game.place_empty?(linha, coluna)
      game.put(linha.to_i - 1, coluna.to_i - 1, s)
      break
    else
      puts 'Nao podes colocal num local que ja esta marcado!'
    end
  end
  end?(game, n)
end

def continuar?
  puts 'Novo Jogo?(Y/N)'
  input = gets.chomp.downcase
  if input == 'y'
    start
  elsif input == 'n'
    exit
  else
    puts 'Tens de colocar Y ou N!'
    continuar?
  end
end

# begins vs. IA game picking who's first
def one_player(game)
  r = rand(2)
  if r == 0
    ia_first(game)
  else
    player_first(game)
  end
end

# case where ia is first
def ia_first(game)
  game_start('Computador', 'Jogador', game)
  a = rand(2) * 2
  b = rand(2) * 2
  game.put(a, b, 'x')
  game.show
  end?(game, 'Computador')
  jogada('Jogador', 'o', game)
  if game.place_empty?(2, 2)

  else
    ia_second_move_middle(change(a), change(b), game)
  end
end

def ia_second_move_middle(a, b, game)
  game.put(a, b, 'x')
  end?(game, 'Computador')
end

# muda de 2 para 0 e de 0 para 2
def change(x)
  x == 2 ? 0 : 2
end




start