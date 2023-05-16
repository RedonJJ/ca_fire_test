# Créer un programme qui affiche un rectangle dans le terminal.

width = ARGV[0].to_i
height = ARGV[1].to_i

# Méthode
def drawLine(width, is_top_or_bottom)
    if width == 1
        puts 'o'
    elsif is_top_or_bottom
        puts 'o' + '-' * (width - 2) + 'o'
    else 
        puts '|' + ' ' * (width - 2) + '|'
    end
end

# Erreur
if width.zero? || height.zero?
    puts 'Erreur'
    exit
end

# Affichage du rectangle
height.times do |i|
    if i.zero? || i == height - 1
        drawLine(width, true)
    else
        drawLine(width, false)
    end
end
# Fin de l'exercice