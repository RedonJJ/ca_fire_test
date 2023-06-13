# Créez un programme qui trouve le plus court chemin entre l’entrée et la sortie d’un labyrinthe en évitant les obstacles.


# Le labyrinthe est transmis en argument du programme. 
# La première ligne du labyrinthe contient les informations pour lire la carte : LIGNESxCOLS, caractère plein, vide, chemin, entrée et sortie du labyrinthe. 


# Le but du programme est de remplacer les caractères “vide” par des caractères “chemin” pour représenter le plus court chemin pour traverser le labyrinthe. 
# Un déplacement ne peut se faire que vers le haut, le bas, la droite ou la gauche.
# Exemples d’utilisation :
# $> cat -e example.map
# 10x10* o12$
# *****2****$
# * *   ****$
# *   **** *$
# * ****   *$
# *  *     2$
# *  ** *  *$
# *     * **$
# ***  **  *$
# 1     ****$
# **********$

# $> ruby exo.rb example.map
# 10x10* o12
# *****2****
# * *   **** 
# *   **** *
# * ****   * 
# *  * oooo2
# *  **o*  *
# *  ooo* **
# ***o **  *
# 1ooo  ****
# **********
# => SORTIE ATTEINTE EN 12 COUPS !

# Vérification des paramètres d'entrée.
if ARGV.count < 3 || ARGV[2].length < 5 then
    puts 'params needed: height width characters'
  else
    height, width, chars, gates = ARGV[0].to_i, ARGV[1].to_i, ARGV[2], ARGV[3].to_i
    entry = rand(width - 4) + 2
    entry2 = rand(width - 4) + 2
    puts("#{height}x#{width}#{ARGV[2]}")

    # Génération du labyrinthe.
    height.times do |y|
      width.times do |x|
        if y == 0 && x == entry then
          print chars[3].chr
        elsif y == height - 1 && x == entry2 then
          print chars[4].chr
        elsif y.between?(1, height - 2) && x.between?(1, width - 2) && rand(100) > 20 then
          print chars[1].chr
        else
          print chars[0].chr
        end
      end
      print "\n"
    end
  end
  
# Méthode d'affichage du labyrinthe.
def show_maze(maze)
   maze.each { |line| puts line.join('') }
end

# Méthode pour trouver le chemin le plus court.
def find_shortest_way(maze)
    # Recherche de l'entrer.
    entrance = nil
    maze.each_with_index do |line, y|
        if line.include?('o') then
            x = line.index('o')
            entrance = [x, y]
            break
        end
    end

    return nil if entrance.nil?

    # Initialisation des variables.
    tail = [entrance]
    parents = { entrance => nil }

    # Affichage du point de départ.
    puts "Départ: #{entrance}"

    # Parcours en largeur.
    while !tail.empty?
        current = tail.shift
        x, y = current

        # Vérification de la sortie.
        if maze[x][y] == '2'
            # Reconstruction du chemin.
            way = []
            while current != entrance
                way.unshift(current)
                current = parents[current]
            end
            # Affichage du chemin trouvé.
            puts "Chemin trouvé: #{way}"
            return way
        end

        # Déplacements possibles: haut, bas, gauche, droite.
        move = [[x, y - 1], [x, y + 1], [x - 1, y], [x + 1, y]]

        # Affichage des coordonnées actuelles et des mouvements explorés.
        puts "Coordonnées actuelles: #{current}"
        puts "Mouvements explorés: #{move}"

        # Exploration des déplacements.
        move.each do |nx, ny|
            next if nx < 0 || nx >= maze[0].size || ny < 0 || ny >= maze.size
            next if maze[nx][ny] != ' ' && maze[nx][ny] != '2' && maze[nx][ny] != '1'
            next if parents.key?([nx, ny]) # Vérifier si la position a déjà était visitée.

            position = [nx, ny]
            tail << position
            parents[position] = current
            maze[nx][ny] = 'o' # Marquer le chemin exploré.

            # Message de débogage.
            puts "Déplacement"
        end
    end

    return nil # Aucun chemin trouvé.
end

# Récupération du labyrinthe depuis les arguments de la ligne de commande.
maze = File.readlines(ARGV.last).map(&:chomp).map(&:chars)


# Recherche du chemin le plus court.
way = find_shortest_way(maze)

# Affichage du résultat.
if way then
    way.each { |x, y| maze[y][x] = 'o' }
    show_maze(maze)
    puts '=> SORTIE ATTEINTE EN ' + (way.size - 1).to_s + ' COUPS !'
else
    puts 'Aucun chemin trouvé.'
end

# Fin de l'exercice.