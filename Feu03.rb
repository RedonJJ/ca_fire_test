# Créez un programme qui trouve et affiche la solution d’un Sudoku.


# Exemples d’utilisation :
# $> cat s.txt
# 1957842..
# 3.6529147
# 4721.3985
# 637852419
# 8596.1732
# 214397658
# 92.418576
# 5.8976321
# 7612358.4

# $> ruby exo.rb s.txt
# 195784263
# 386529147
# 472163985
# 637852419
# 859641732
# 214397658
# 923418576
# 548976321
# 761235894

# Afficher error et quitter le programme en cas de problèmes d’arguments.
def read_sudoku(filename)
  sudoku = []
  File.foreach(filename) do |line|
    sudoku << line.chomp.chars.map(&:to_i)
  end
  sudoku
end

def solve_sudoku(sudoku)
  solve_cell(0, 0, sudoku)
end

def solve_cell(row, col, sudoku)
  return true if row == 9

  if sudoku[row][col] != 0
    next_row, next_col = next_cell(row, col)
    return solve_cell(next_row, next_col, sudoku)
  end

  (1..9).each do |num|
    if valid_placement(row, col, num, sudoku)
      sudoku[row][col] = num
      next_row, next_col = next_cell(row, col)
      return true if solve_cell(next_row, next_col, sudoku)
      sudoku[row][col] = 0
    end
  end

  false
end

def valid_placementrow, col, num, sudoku)
  return false if num_in_row?(row, num, sudoku)
  return false if num_in_col?(col, num, sudoku)
  return false if num_in_box?(row, col, num, sudoku)

  true
end

def num_in_row?(row, num, sudoku)
  sudoku[row].include?(num)
end

def num_in_col?(col, num, sudoku)
  sudoku.transpose[col].include?(num)
end

def num_in_box?(row, col, num, sudoku)
  box_start_row = (row / 3) * 3
  box_start_col = (col / 3) * 3

  (box_start_row..box_start_row + 2).each do |r|
    (box_start_col..box_start_col + 2).each do |c|
      return true if sudoku[r][c] == num
    end
  end
  false
end

def next_cell(row, col)
  col == 8 ? [row + 1, 0] : [row, col + 1]
end

def print_sudoku(sudoku)
  sudoku.each do |row|
    puts row.join
  end
end

# Gestion des erreurs
if ARGV.length != 1
  puts 'Erreur: nombre incorrect d\'arguments.'
  puts "Utilisation: ruby #{__FILE__} sudoku_file"
  exit
end
sudoku_file = ARGV[0]
  
sudoku = read_sudoku(sudoku_file)
if solve_sudoku(sudoku)
  print_sudoku(sudoku)
else
  puts 'Aucune solution trouvée.'
end

# Fin de l'exercice.