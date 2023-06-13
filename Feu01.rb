# Créez un programme qui reçoit une expression arithmétique dans une chaîne de caractères
# et en retourne le résultat après l’avoir calculé.

# Vous devez gérer les 5 opérateurs suivants : “+” pour l’addition, “-” pour la soustraction,
# “*” la multiplication, “/” la division et “%” le modulo.

class ArithmeticExpression
  # Méthode pour évaluer l'expression arithmétique donnée.
    def evaluate(expression)
        tokens = tokenize(expression)
        result = parse_expression(tokens)
        raise "Expression invalide: #{expression}" if tokens.any?
        result 
    end
  
    # Méthode pour analyser l'expression arithmétique.
    def parse_expression(tokens)
        result = parse_term(tokens) 
        while tokens.first == '+' || tokens.first == '-'
        operator = tokens.shift
        right = parse_term(tokens) 
        if operator == '+' then
          result += right # Éffectue l'addition.
        else 
          result -= right # Éffectue la soustraction.
        end
      end
      result
  end

# Méthode pour analyser un terme dans l'expression.
def parse_term(tokens)
  result = parse_factor(tokens)
while tokens.first == '*' || tokens.first == '/' || tokens.first == '%'
  operator = tokens.shift
  right = parse_factor(tokens)
  if operator == '*' then
  result *= right # Éffectue la multiplication.
 elsif operator == '/' then
  result /= right # Éffectue la division.
  elsif operator == '%' then
  result %= right # Éffectue le modulo.
  end
end
  result 
end

# Méthode pour analyser un facteur dans l'expression.
def parse_factor(tokens)
  if tokens.first == '(' then
      tokens.shift 
      result = parse_expression(tokens)
      raise "Expected ')'" if tokens.shift != ')'
      result
    elsif tokens.first =~ /\A[+-]?\d+\z/ then # Si le premier caractère est un nombre (positif ou négatif).
      tokens.shift.to_i
    else 
      raise "Unexpected token: #{tokens.first}" # Lève une exception si le caractère n'est ni une paranthèse ouvrante ni un nombre.
    end
  end

  def tokenize(expression)
    expression.scan(/\d+|[+\-*\/%()]|\S+/)
  end
end

unless ARGV.length == 1
  puts 'Erreur: nombre incorrect d\'arguments'
  puts "Utilisation: ruby #{__FILE__} \"expression\""
  exit
end

expression = ARGV[0]

arithmetic_expression = ArithmeticExpression.new

result = arithmetic_expression.evaluate(expression)
puts result

#Fin de l'exercice.