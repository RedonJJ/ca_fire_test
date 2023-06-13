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

# Méthode pour lire le contenu du sudoku à partir d'un fichier.
def read_sudoku(filename)
  sudoku = []
  File.foreach(filename) do |line|
    sudoku << line.chomp.chars.map(&:to_i)
  end
  sudoku
end

# Méthode pour résoudre le Sudoku.
def solve_sudoku(sudoku)
  solve_cell(0, 0, sudoku)
end

# Méthode récursive pour résoudre une cellule du Sudoku.
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

  false # Aucune solution trouvée pour cette configuration.
end

# Méthode pour vérifier si le placement d'un numéro est valide dans la ligne, la colone, est la case.
def valid_placementrow(row, col, num, sudoku)
  return false if num_in_row?(row, num, sudoku)
  return false if num_in_col?(col, num, sudoku)
  return false if num_in_box?(row, col, num, sudoku)

  true
end

# Méthode pour vérifier si le numéro est déjà présent dans la ligne.
def num_in_row?(row, num, sudoku)
  sudoku[row].include?(num)
end

# Méthode pour vérifier si le numéro est déjà présent dans la colonne.
def num_in_col?(col, num, sudoku)
  sudoku.transpose[col].include?(num)
end

# Méthode pour vérifier si le numéro est déjà présent dans la boite 3x3.
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

# Méthode pour passer à la cellule suivante dans le Sudoku.
def next_cell(row, col)
  col == 8 ? [row + 1, 0] : [row, col + 1]
end

# Méthode pour afficher le Sudoku.
def print_sudoku(sudoku)
  sudoku.each do |row|
    puts row.join
  end
end

# Gestion des erreurs.
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