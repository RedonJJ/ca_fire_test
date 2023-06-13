# Créez un programme qui remplace les caractères vides par des caractères plein pour représenter le plus grand carré possible sur un plateau. 
# Le plateau sera transmis dans un fichier. 
# La première ligne du fichier contient les informations pour lire la carte : nombre de lignes du plateau, caractères pour “vide”, “obstacle” et “plein”.


# Exemples d’utilisation :
# $> cat plateau
# 9.xo
# ...........................
# ....x......................
# ............x..............
# ...........................
# ....x......................
# ...............x...........
# ...........................
# ......x..............x.....
# ..x.......x................
# $> ruby exo.rb plateau
# .....ooooooo...............
# ....xooooooo...............
# .....ooooooox..............
# .....ooooooo...............
# ....xooooooo...............
# .....ooooooo...x...........
# .....ooooooo...............
# ......x..............x.....
# ..x.......x................

# Vous devez gérer les potentiels problèmes d’arguments, de fichiers, ou de carte invalide.

# Une carte est valide uniquement si : les lignes ont toute la même longueur, il y a au moins une ligne d’une case, 
# les lignes sont séparées d’un retour à la ligne, les caractères présents dans la carte sont uniquement ceux de la première ligne.

# En cas de plusieurs solutions, le carré le plus en haut à gauche sera choisi.

# Vous trouverez un générateur de plateau en dessous.
# Voici un générateur de plateau écrit en Ruby :
  
x = ARGV[0].to_i
y = ARGV[1].to_i
density = ARGV[2].to_i
output_file = ARGV[3]
  
# Génère et enregistre une nouvelle carte aléatoire dans le fichier de sortie.
File.open(output_file, "w") do |file|
    file.puts "#{y}.xo"
    for i in 0..y do
        for j in 0..x do
        file.print ((rand(100) < density) ? '.' : 'x')
        end
    file.print "\n"
    end
end

# Méthode pour lire la carte à partir d'un fichier.
def read_map(filename)
    lines = File.readlines(filename, chomp: true)
    line_length = lines[1].length

    lines.drop(2).each do |line|
    raise 'Invalid map: lines have different lengths' if line.length != line_length
    end

    [lines, lines[1]]
end  

# Méthode pour remplacer les caractères vides par des caractères pleins dans la carte.
def replace_empty_with_full(lines, empty_char, full_char)
    max_square_row, max_square_col, max_square_size = find_largest_square(lines, empty_char)

    map = lines.map(&:chars)

    (max_square_row..(max_square_row + max_square_size - 1)).each do |row|
        (max_square_col..(max_square_col + max_square_size - 1)).each do |col|
            map[row][col] = full_char if map[row][col] == empty_char
        end
    end

    map.each_with_index do  |row, i|
        row.each_with_index do |char, j|
            if i >= max_square_row && i < max_square_row + max_square_size && j >= max_square_col && j < max_square_col + max_square_size then
                map[i][j] = 'o' if char == empty_char
            end
        end
    end

    map.each { |line| puts line.join }
end

# Méthode pour trouver le plus grand carré rempli de caractères vides.
def find_largest_square(lines, empty_char)
    map = lines.map(&:chars)
    max_square_size = 0
    max_square_row = 0
    max_square_col = 0

    map.each_with_index do |row, i|
        row.each_with_index do |char, j|
            next if char != empty_char

            square_size = 1
            valid_square = true

            while valid_square && (i + square_size) < map.length && (j + square_size) < row.length
                (i..(i+ square_size)).each do |row_idx|
                    break unless valid_square

                    valid_square = false if map[row_idx][(j + square_size)] != empty_char
                end

                (j..(j + square_size)).each do |col_idx|
                    break unless valid_square

                    valid_square = false if map[(i + square_size)][col_idx] != empty_char
                end

                if valid_square then
                    square_size += 1
                end
            end

            if square_size > max_square_size then
                max_square_size = square_size
                max_square_row = i
                max_square_col = j
            end
        end
    end

    [max_square_row, max_square_col, max_square_size] # Retourne les coordonnées et la taille du plus grand carré rempli de caractères vides.
end

# Gestions des erreurs.
if ARGV.length != 4 then
    puts 'Erreur: nombre incorrect d\'arguments.'
    puts "Utilisation: ruby #{__FILE__} x y density map.file"
    exit
end

map_file = ARGV[3]
lines, first_line = read_map(map_file) # Lit la carte à partir du fichier.
  
empty_char = first_line[1]
full_char = first_line[2]
  
replace_empty_with_full(lines, empty_char, full_char) 

# Fin de l'exercice.