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
    @board[linha][column] = symbol if @board[linha][column] == ' '
  end

  # muda de 2 para 0 e de 0 para 2
  def change(x)
    if x != 1
      x == 2 ? 0 : 2
    end
  end

  # puts the token on the opposite position
  def put_opposite(linha, column, symbol)
    put(change(linha), change(column), symbol)
  end

  # verifies if someone won the game
  def win?
    linha?(@board) || linha?(@board.transpose) || linha?(diagonals)
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

  # give the diagonals in two rows
  def diagonals
    [diagonal(@board), diagonal(@board.map(&:reverse))]
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

  # shows board after IA plays and check if he won
  def jogada_computador
    puts 'Jogada do computador:'
    end?('Computador')
  end


  def winning_position(symbol)
    a = check_two_in_row?(@board, symbol) + check_two_in_row?(@board.transpose, symbol).map(&:rotate) + diagonal_position_to_board(check_two_in_row?(diagonals, symbol))
    a.find { |x| !x.nil? }
  end

  def diagonal_position_to_board(arr)
    (0..arr.size-1).each do |diag|
      if arr[diag][0] == 0
        arr[diag][0] = arr[diag][1]
      else
        if arr[diag][1] == 2
          arr[diag] = [2, 0]
        elsif arr[diag][1] == 0
          arr[diag] = [0, 2]
        end
      end
    end
    arr
  end

  def put_winning_position(symbol)
    a = winning_position(symbol)
    if a.nil?
      false
    else
      put(a[0], a[1], 'x')
      jogada_computador
    end
  end

  def ia_play
    if winning_position('x').nil?
      put_winning_position('o')
    else
      put_winning_position('x')
    end
  end

  # verifies if the game ended
  def end?(n)
    show
    if win?
      puts "Parabens,#{n}, venceu o jogo!"
      continuar?
      exit
    elsif draw?
      puts 'Empate!'
      continuar?
    end
  end
end

# checks if there is two equal tokens same row (line, column or diagonal)
def check_two_in_row?(rows, symbol)
  a = []
  rows.each_with_index do |x, index|
    a << [index, two?(x, symbol)] if [index, two?(x, symbol)].compact.size == 2
  end
  a
end

# returns the index of a winning position or nil if there isn't such position
def two?(array, symbol)
  array.count(symbol) == 2 ? array.find_index(' ') : nil
end

# first diagonal of a board
def diagonal(board)
  (0..2).map { |x| board[x][x] }
end

@corners = [[0, 0], [0, 2], [2, 0], [2, 2]]

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



# starts a turn
def jogada(n, s, game)
  loop do
    @linha = asks('linha', n, s)
    @coluna = asks('coluna', n, s)
    if game.place_empty?(@linha, @coluna)
      game.put(@linha - 1, @coluna - 1, s)
      break
    else
      puts 'Nao podes colocal num local que ja esta marcado!'
    end
  end
  @lastplay = [@linha - 1, @coluna - 1]
  game.end?(n)
end

# after the end of the game, asks user if we wants to play again
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
    ia_first_first(game)
  else
    player_first(game)
  end
end

# first turn in the case where IA is first
def ia_first_first(game)
  game_start('Computador', 'Jogador', game)
  @a = rand(2) * 2
  @b = rand(2) * 2
  game.put(@a, @b, 'x')
  game.show
  jogada('Jogador', 'o', game)
  ia_first_second(game)
end

# second turn in the case where IA is first
def ia_first_second(game)
  if @lastplay == [1, 1]
    ia_second_move_center(game)
  else
    ia_second_move_not_center(game)
  end
end

# second turn if player put token in the center
def ia_second_move_center(game)
  game.put_opposite(@a, @b, 'x')
  game.jogada_computador
  jogada('Jogador', 'o', game)
  ia_first_third_1(game)
end

# second turn if player NOT put token in the center
def ia_second_move_not_center(game)
end



# third turn, option 1
def ia_first_third_1(game)
  loop do
    game.ia_play
    jogada('Jogador', 'o', game)
  end
end

start