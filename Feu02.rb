# Créez un programme qui affiche la position de l’élément le plus en haut à gauche (dans l’ordre) d’une forme au sein d’un plateau.
# Vous devez gérer les potentiels problèmes d’arguments et de lecture de fichiers.

# Méthode pour lire le contenudu plateau à partir d'un fichier.
def read_board(filename)
    board = File.readlines(filename, chomp: true).map(&:chars)
    board
end

# Méthode pour lire le contenu de la forme à partir d'un fichier.
def read_shape(filename)
    shape = File.readlines(filename, chomp: true).map {|line| line.chars}
    shape
end

# Méthode pour trouver la forme dans le plateau.
def find_shape(board, shape)
    board_height = board.length
    board_width = board[0].length
    shape_height = shape.length
    shape_width = shape[0].length

    puts "Board content:"
    board.each do |row|
        puts row.join
    end
    puts "Shape content:"
    shape.each do |row|
        puts row.join
    end

    # Parcours toutes le positions possibles dans le plateau.
    (0..board_height - shape_height).each do |row|
        (0..board_width - shape_width).each do |col|
            found = true
            # Vérifie si la forme correspond à cette position.
            (0..shape_height - 1).each do |i|
                (0..shape_width - 1).each do |j|
                    next if shape[i][j] == ''
                    if board[row + i][col + j] != shape[i][j] then
                        puts "Mismatch at (#{row + i}, #{col + j})"
                        found = false
                        break
                    end
                end
                break unless found
            end
            return [row, col, shape] if found # Retourne la position si la forme est trouvé.
        end
    end
    nil # Retourne nil si la forme n'est pas trouvée.
end

# Méthode pour afficher le résultat de la recherche de la forme.
def print_result(result, board)
    if result.nil? then
        puts 'Introuvable'
    else
        puts 'Trouvé !'
        puts "Coordonnées : #{result[0]},#{result[1]}"
        puts '----'
        
        # Créer une copie du plateau pour afficher le résultat avec la forme mise en évidence.
        board_content = Marshal.load(Marshal.dump(board))
        shape_height = result[2].length
        shape_width = result[2][0].length

        # Met en évidence la forme dans la copie du plateau en utilisant des couleurs.
        result[0].upto(result[0] + shape_height - 1) do |row|
            result[1].upto(result[1] + shape_width - 1) do |col|
                board_content[row][col] = "\e[41m#{board_content[row][col]}\e[0m"
            end
        end
        board_content.each do |row|
            puts row.join
        end
    end
end

# Vérifie le nombre d'arguments donnés en ligne de commande.
if ARGV.length != 2 then
    puts 'Erreur: nombre incorrect d\'arguments.'
    puts "Utilisation: ruby #{__FILE__} board_file shape_file"
    exit
end

board_file = ARGV[0]
shape_file = ARGV[1]

board = read_board(board_file)
shape = read_shape(shape_file)

result = find_shape(board, shape)
print_result(result, board)

# Fin de l'exercice.