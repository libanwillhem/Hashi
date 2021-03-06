#Classe permettant de définir une case
class Case

	## Partie variables d'instance

	# @x -> Coordonnée X de la case
	# @y -> Coordonnée Y de la case
	# @grille -> La grille dans laquelle la case se trouve
	# @contenu -> Le contenu de la case
	# @surbrillance -> Booléen qui definit si la case est en surbrillance ou non

  ## Partie accesseurs

  # Accesseur get sur les attributs x et y
  attr_reader :x, :y

  # Accesseur get et set sur les attributs surbrillance, grille et contenu
  attr_accessor :surbrillance, :grille, :contenu

  ## Partie initialize

	# Initialisation de la classe Case
	#
	# === Paramètres
	#
	# * +x+ : Coordonnée X de la case
	# * +y+ : Coordonnée Y de la case
    def initialize(x, y)
        @x = x
        @y = y
        @grille = nil
        @contenu = nil
        @surbrillance = false
    end

    ##Teste si la case a des voisins
    #
    # === Return
    #
    # True si la case a au moins 1 voisin, false sinon
    def aSommetVoisin()
        if(@grille != nil)
            #puts "dimension de la grille : " + @grille.longueur.to_s + ":" + @grille.largeur.to_s
            #puts "test du voisin gauche, y = " + y.to_s
            boolSommetGauche = y-1 >= 0 ? @grille.getCase(x, y-1).contenu.is_a?(Sommet) : false
            #puts "test du voisin droit, y = " + y.to_s
            boolSommetDroit = y+1 < @grille.largeur ? @grille.getCase(x, y+1).contenu.is_a?(Sommet) : false
            #puts "test du voisin haut, x = " + x.to_s
            boolSommetHaut = x-1 >= 0 ? @grille.getCase(x-1, y).contenu.is_a?(Sommet) : false
            #puts "test du voisin bas, x = " + x.to_s
            boolSommetBas = x+1 < @grille.longueur ? @grille.getCase(x+1, y).contenu.is_a?(Sommet) : false
            return boolSommetGauche || boolSommetDroit || boolSommetHaut || boolSommetBas
        else
            return false
        end
    end

	##Test si la case est une case voisine
	#
	# === Paramètre
	#
	# * +caseTest+ : la case à tester
	#
	# === Return
	#
	# True si la case est un voisin, false sinon
    def estVoisin(caseTest)
        difX = @x - caseTest.x
        difY = @y - caseTest.y
        return difX.abs() == 1 || difY.abs() == 1
    end

    ##Teste si la case est vide
    #Teste si la case a un contenu
    #
    # === Return
    #
    # True si la case n'a pas de contenu, false sinon
    def estVide()
      return @contenu==nil
    end

    ##Test si la case contient une arête
    #
    # === Return
    #
    # True si la case contient une arête, false dans tous les autres cas
    def aArete()
        if !estVide()
            return contenu.class == Arete
        end
        return false
    end

    ##Test si la case contient un sommet
    #
    # === Return
    #
    # True si la case contient un sommet, false dans tous les autres cas
    def aSommet()
        if !estVide()
            return contenu.class == Sommet
        end
        return false
    end

	##Affiche la case dans le terminal
    def afficher()
       if(@contenu == nil)
           print("·")
       else
           @contenu.afficher()
       end
    end
end
