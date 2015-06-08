# jogo ticatactoe
class Tictac
  def initialize
    @board = [[' ', ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']]
  end

  def show
    @board.each do |place|
      puts place.join(' | ')
    end
  end

  def put(line, column, symbol)
    @board[line.to_i - 1][column.to_i - 1] = symbol
  end

  def end
    @board = @board = [[' ', ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']]
  end

  def fim?
    linha?(@board) || linha?(@board.transpose) || diagonal?(@board) || diagonal?(@board.transpose)
  end

  # verifica se ha 3 em linha
  def linha?(board)
    board.detect do |linha|
      linha[0] == linha[1] && linha[1] = linha[2] && !linha.include?(' ')
    end
  end

  # verfica se ha 3 em diagonal
  def diagonal?(board)
    (board[0][0] == board[1][1]) == board[2][2] && !linha.include?(' ')
  end

  def jogada(n, s)
    puts "Jogador #{n}, em que linha quer colocar o seu #{s}?"
    line = gets.chomp
    puts "Jogador #{n}, em que coluna quer colocar o seu #{s}?"
    coluna = gets.chomp
    put(line, coluna, s)
    show
    if fim? then puts "Parabens, jogador #{n}, venceu o jogo!" else show end
    show
  end
end

game = Tictac.new

puts 'Bem-Vindos ao Jogo do Galo!'
puts 'Jogador 1 -> X | Jogador 2 -> O'
puts 'Tabuleiro: '
game.show
puts 'Começa Jogador 1!'
game.jogada(1, 'x')
game.jogada(2, 'o')
game.jogada(1, 'x')
game.jogada(2, 'o')
game.jogada(1, 'x')
game.jogada(2, 'o')
game.jogada(1, 'x')
game.jogada(2, 'o')

# hipotese de empate
# nao podem colocar num local onde ja foi colocado
