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
    @board[linha.to_i - 1][column.to_i - 1] = symbol
  end

  # verifies if someone won the game
  def fim?
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

  # checks if the board is full
  def full?
    !@board.detect do |linha|
      linha.include?(' ')
    end
  end

  # checks se o local no tabuleiro ja tem uma peca
  def place_empty?(linha, coluna)
    @board[linha.to_i - 1][coluna.to_i - 1] == ' '
  end

  def asks(lc, n, s)
    loop do
      puts "Jogador #{n}, em que #{lc} quer colocar o seu #{s}?"
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
  def jogada(n, s)
    loop do
      linha = asks('linha', n, s)
      coluna = asks('coluna', n, s)
      if place_empty?(linha, coluna)
        put(linha, coluna, s)
        break
      else
        puts 'Nao podes colocal num local que ja esta marcado!'
      end
    end
    show
    if fim?
      puts "Parabens, jogador #{n}, venceu o jogo!"
      continuar?
      exit
    elsif full?
      puts 'Empate!'
      continuar?
    end
  end


  def continuar?
    puts 'Novo Jogo?(Y/N)'
    input = gets.chomp.downcase
    if input == 'y'
      start_game
    elsif input == 'n'
      exit
    else
      puts 'Tens de colocar Y ou N!'
      continuar?
    end
  end
end

def start_game
  game = Board.new
  puts 'Bem-Vindos ao Jogo do Galo!'
  puts 'Jogador 1 -> X | Jogador 2 -> O'
  puts 'Tabuleiro: '
  game.show
  puts 'Começa Jogador 1!'
  loop do
    game.jogada(1, 'x')
    game.jogada(2, 'o')
  end
end

start_game