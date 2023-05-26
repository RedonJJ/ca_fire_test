# Créer un programme qui affiche un rectangle dans le terminal.

width = ARGV[0].to_i
height = ARGV[1].to_i

# Méthode
def draw_line(width, is_top_or_bottom)
    if width == 1 then
        puts 'o'
    elsif is_top_or_bottom then
        puts 'o' + '-' * (width - 2) + 'o'
    else 
        puts '|' + ' ' * (width - 2) + '|'
    end
end

# Erreur
if width.zero? || height.zero? then
    puts 'Erreur'
    exit
end

# Affichage du rectangle
height.times do |i|
    if i.zero? || i == height - 1 then
        draw_line(width, true)
    else
        draw_line(width, false)
    end
end
# Fin de l'exercice