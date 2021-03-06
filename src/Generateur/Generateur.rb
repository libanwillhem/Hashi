require "matrix"

#Classe permettant la manipulation d'un générateur de grille
class Generateur

    ## Partie variable d'instance

    #@difficulty    -> Une chaine de caractère contenant le preset de difficulté à utiliser
    #@longueur      -> La longueur de la grille à générer (initialisée à nil de base)
    #@largeur       -> La largeur de la grille a générer (initialisée à nil de base)
    #densite        -> La densité de sommet par rapport à la taille de la grille
    #@sommets       -> Liste des sommets générés
    #@nbSommet      -> Nombre de sommet à placer dans la grille
    #@grille        -> Grille créée
    #@estGenere     -> Booleen qui défini si la grille a été générée ou non (bloque des methodes nécessitant une grille générée)

    #Accesseur get
    attr_reader :grille

    ## Partie initialize
    #Initialisation du générateur
    #
    # === Paramètres
    #
    # * +difficulty+ : La difficulté de la grille à générer
    # * +longueur+ : La longueur de la grille à générer (initialisée à nil)
    # * +largeur+ : La largeur de la grille à générer (initialisée à nil)
    # * +densite+ : La densite de la grille à générer (initialisée à nil)
    def initialize(difficulty, longueur=nil, largeur=nil, densite=nil)
        @estGenere = false
        @chanceDeDouble = 38+rand(0..6)
        case difficulty
          when "easy"
            #Taille 6x6 à 9x10, densité 35 à 41
            @longueur = 6+rand(0..3)
            @largeur = 6+rand(0..4)
            @densite = 35+rand(0..6)
          when "normal"
            #Taille 7x9 à 9x12, densité 32 à 39
            @longueur = 7+rand(0..2)
            @largeur = 9+rand(0..3)
            @densite = 32+rand(0..7)
            @chanceDeDouble = 25+rand(0..9)
          when "hard"
            #Taille 9x13 à 10x14, densité 32 à 38
            @longueur = 9+rand(0..1)
            @largeur = 13+rand(0..1)
            @densite = 32+rand(0..6)
            @chanceDeDouble = 26+rand(0..2)
          else
            @longueur = longueur
            @largeur = largeur
            @densite = densite
        end
        @sommets = Array.new()
        #(@longueur * @largeur) / (@sommets.length() + 1) * 100;
        ##puts "longueur : " + @longueur.to_s
        ##puts "largeur : " + @largeur.to_s
        ##puts "densite : " + @densite.to_s
        ##puts "longueur*largeur.ceil : " + (((@longueur * @largeur).to_f / 100).ceil).to_s
        @nbSommet = (((@longueur * @largeur).to_f  / 100) * @densite).ceil
        ##puts "Dimensions : "+@longueur.to_s+"x"+@largeur.to_s+"("+(@largeur*@longueur).to_s+"cases). Nb sommets attendus "+@nbSommet.to_s+" pour une densité de "+@densite.to_s
        @grille = Grille.creer(@longueur, @largeur)
    end

    ##Partie méthodes

    ##Methode qui récupère la case demandée de la grille générée
    #
    # === Paramètres
    #
    # * +x+ : la coordonnée x de la case
    # * +y+ : la coordonnée y de la case
    #
    # === Return
    #
    # La case x, y de la case
    def getCase(x, y)
        if @estGenere
            return @grille[x][y]
        end
        return nil
    end

    ##Vide la grille générée
    #Recrée une grille vide pour remplacer la grille actuelle
    def vider()
        @grille = Grille.creer(@longueur, @largeur)
        @estGenere = false
    end

    ##Récupère une copie de la grille générée sans les arêtes
    #
    # === Return
    #
    # Une copie de la grille sans arêtes
    def getGrilleSansArete()
        if @estGenere
            cloneGrille = Marshal.load(Marshal.dump(@grille))
            cloneGrille.clearAretes()
            return cloneGrille
        end
        return nil
    end

    ##Récupère la grille générée avec les arêtes
    #
    # === Return
    #
    # La grille générée
    def getGrilleAvecArete()
        if @estGenere
            return @grille
        end
        return nil
    end

    ##Place les labels des sommets de la grille
    def placerLabelSommet()
        if @estGenere
            @sommets.each { |sommet|
                sommet.valeur = sommet.compterArete()
            }
        end
    end

    ##Vérifie si la case passée en paramètre plus les ajouts passés en paramètres sont dans la grille
    #
    #
    # === Paramètres
    #
    # * +caseDeDepart+ : la case d'où partir
    # * +lesAdds+ : tableau de 2 cases contenant la valeur à ajouter aux x et y de la caseDeDepart
    #
    # === Return
    #
    # True si la case obtenue est dans la grille, false sinon
    def estDansMatrice(caseDeDepart, lesAdds)
        xDuSommet = caseDeDepart.x
        yDuSommet = caseDeDepart.y
        return (xDuSommet + lesAdds[0] < @longueur) && (xDuSommet + lesAdds[0] >= 0) && (yDuSommet + lesAdds[1] < @largeur) && (yDuSommet + lesAdds[1] >= 0)
    end

    ##Vérifie si la grille passée en paramètre correspond à la grille générée (arêtes exclues)
    #
    # === Paramètres
    #
    # * +grille+ : la grille à vérifier
    #
    # === Return
    #
    # True si la grille est identique, false sinon
    def grilleIdentique(grille)
        if @estGenere
            if @sommets.size() == grille.sommets.size()
                for i in 0...@sommets.size()
                    if !(@sommets[i].position.x == grille.sommets[i].position.x || @sommets[i].position.y == grille.sommets[i].position.y)
                        return false
                    end
                end
                return true
            else
                return false
            end
        end
        return false
    end

    ##Génère une grille du nombre de sommet calculés ou passés en paramètre
    #
    # === Paramètres
    #
    # * +nbSommet+ : le nombre de sommet à placer (initialisé à nil)
    #
    # === Return
    #
    # La grille générée sans les aretes
    def creeUneGrille(nbSommet=nil)
        if(nbSommet != nil)
          @nbSommet = nbSommet
        end
        self.vider()
        tableauDeAdd = [[0,1],[0,-1],[1,0],[-1,0]]
        sommetPlaces = 0

        coordXPremierSommet = rand(0...@longueur)
        coordYPremierSommet = rand(0...@largeur)
        sommetDeDepart = Sommet.creer(0, @grille.getCase(coordXPremierSommet, coordYPremierSommet))
        @sommets.push(sommetDeDepart)
        sommetPlaces += 1
        #@grille.afficher()

        #boucle qui place des sommets
        nbCancel = 0
        tourneEnBoucle = 0
        loop {
            break if sommetPlaces >= @nbSommet || nbCancel > sommetPlaces || tourneEnBoucle > @nbSommet * 2
            #puts "nbCancel : " + nbCancel.to_s() + "\ntourneEnBoucle : " + tourneEnBoucle.to_s() + "\nsommetsPlaces : " + sommetPlaces.to_s() + "\nnbSommets : " + @nbSommet.to_s()
            #puts "nbSommets : " + sommetPlaces.to_s + "/" + @nbSommet.to_s
            #on commence par choisir un sommet
            sommetAEtePlace = false
       		aEteCancel = false
            indiceSommetChoisi = rand(0...@sommets.size())
            sommetChoisi = @sommets[indiceSommetChoisi]
            xDuSommet = sommetChoisi.position.x
            yDuSommet = sommetChoisi.position.y

            #puts "on part du sommet " + indiceSommetChoisi.to_s + " en " + sommetChoisi.position.x.to_s + ":" + sommetChoisi.position.y.to_s

            #on choisi une direction
            #tant que la direction ne marche pas on continu d'en choisir une
            lesAdds = nil
            loop {
                indiceDirectionChoisie = rand(0...tableauDeAdd.size())
                lesAdds = tableauDeAdd[indiceDirectionChoisie]

                boolYaUneCaseDevant = estDansMatrice(sommetChoisi.position, lesAdds)
                boolYaUneCase2Devant = estDansMatrice(sommetChoisi.position, [lesAdds[0]*2, lesAdds[1]*2])
                break if boolYaUneCaseDevant && boolYaUneCase2Devant
            }
            #puts "direction choisie : " + lesAdds.to_s
            #break

            caseOuPlacer = @grille.getCase(xDuSommet + 2*lesAdds[0], yDuSommet + 2*lesAdds[1])
            #puts "on part de " + caseOuPlacer.x.to_s + ":" + caseOuPlacer.y.to_s
            #puts "contenu de la case de depart : " + caseOuPlacer.contenu.class.to_s
            #on garde la case juste devant (celle entre sommetChoisi.position et caseOuPlacer) pour tester histoire de pas passer par dessus quelque chose
            caseEntreLesDeux = @grille.getCase(xDuSommet + lesAdds[0], yDuSommet + lesAdds[1])

            #si la case est vide alors on commence à essayer de placer
            #puts "Case Où Placer avant if: " + caseOuPlacer.x.to_s + ":" + caseOuPlacer.y.to_s
            if caseOuPlacer.estVide() && caseEntreLesDeux.estVide()
                #puts "Case Ou Placer après if: " + caseOuPlacer.x.to_s + ":" + caseOuPlacer.y.to_s
                sommetAEtePlace = false
                aEteCancel = false
                tourneEnBoucle = 0
                loop {
                    break if sommetAEtePlace || aEteCancel

                    #puts "Case Ou Placer : " + caseOuPlacer.x.to_s + ":" + caseOuPlacer.y.to_s
                    #puts "Contenu : " + caseOuPlacer.class.to_s

                    boolArretViaRand = rand(0..3) <= 2
                    boolSommetJusteDevant = estDansMatrice(caseOuPlacer, lesAdds) && @grille.caseSuivante(caseOuPlacer, lesAdds[0], lesAdds[1]).contenu.class == Sommet
                    boolAreteJusteDevant = estDansMatrice(caseOuPlacer, lesAdds) && @grille.caseSuivante(caseOuPlacer, lesAdds[0], lesAdds[1]).contenu.class == Arete
                    boolBordDuTableau = !(estDansMatrice(caseOuPlacer, lesAdds))

                    #si un seul des booléen est vrai
                    if boolArretViaRand || boolSommetJusteDevant || boolAreteJusteDevant || boolBordDuTableau
                        #on test les bool un par un

                        if boolSommetJusteDevant
                            #puts "Arret via sommet devant en " + caseOuPlacer.x.to_s + ":" + caseOuPlacer.y.to_s
                            #on recule jusqu'à trouver une case bien
                            while caseOuPlacer.aSommetVoisin()
                                caseOuPlacer = @grille.getCase(caseOuPlacer.x - lesAdds[0], caseOuPlacer.y - lesAdds[1])
                                break if caseOuPlacer == sommetChoisi.position || caseOuPlacer.estVoisin(sommetChoisi.position)
                            end

                            #on test pourquoi on s'est arreté
                            if caseOuPlacer == sommetChoisi.position || caseOuPlacer.estVoisin(sommetChoisi.position)
                                aEteCancel = true
                            else
                                nouveauSommet = Sommet.creer(0, caseOuPlacer)
                                @sommets.push(nouveauSommet)
                                sommetPlaces += 1

                                Arete.creer(nouveauSommet, sommetChoisi, rand(1..100) < @chanceDeDouble)

                                sommetAEtePlace = true
                            end
                        elsif boolAreteJusteDevant
                            #puts "Arrêt via areteDevant en " + caseOuPlacer.x.to_s + ":" + caseOuPlacer.y.to_s
                            #si on peut placer sur l'arete on le fait, sinon on recule
                            caseDArete = @grille.getCase(caseOuPlacer.x + lesAdds[0], caseOuPlacer.y + lesAdds[1])
                            if !(caseDArete.aSommetVoisin()) && caseDArete.contenu.getTaille() >= 3
                                sommet1 = caseDArete.contenu.sommet1
                                sommet2 = caseDArete.contenu.sommet2
                                caseDArete.contenu.supprimer()

                                nouveauSommet = Sommet.creer(0, caseDArete)
                                @sommets.push(nouveauSommet)
                                sommetPlaces += 1

                                Arete.creer(nouveauSommet, sommetChoisi, rand(1..100) < @chanceDeDouble)

                                sommetAEtePlace = true

                                Arete.creer(sommet1, nouveauSommet, rand(1..100) < @chanceDeDouble)
                                Arete.creer(sommet2, nouveauSommet, rand(1..100) < @chanceDeDouble)
                            else
                                #sinon on recule jusqu'à trouver un truc bien
                                while caseOuPlacer.aSommetVoisin()
                                    caseOuPlacer = @grille.getCase(caseOuPlacer.x - lesAdds[0], caseOuPlacer.y - lesAdds[1])
                                    break if caseOuPlacer == sommetChoisi.position || caseOuPlacer.estVoisin(sommetChoisi.position)
                                end

                                #on test pourquoi on s'est arreté
                                if caseOuPlacer == sommetChoisi.position || caseOuPlacer.estVoisin(sommetChoisi.position)
                                    aEteCancel = true
                                else
                                    nouveauSommet = Sommet.creer(0, caseOuPlacer)
                                    @sommets.push(nouveauSommet)
                                    sommetPlaces += 1

                                    Arete.creer(nouveauSommet, sommetChoisi, rand(1..100) < @chanceDeDouble)

                                    sommetAEtePlace = true
                                end
                            end
                        elsif boolBordDuTableau
                            #puts "Arrêt via bord " + caseOuPlacer.x.to_s + ":" + caseOuPlacer.y.to_s
                            if !(caseOuPlacer.aSommetVoisin())
                                nouveauSommet = Sommet.creer(0, caseOuPlacer)
                                #puts "sommet crée"
                                @sommets.push(nouveauSommet)
                                sommetPlaces += 1

                                Arete.creer(nouveauSommet, sommetChoisi, rand(1..100) < @chanceDeDouble)

                                sommetAEtePlace = true
                            else
                                #sinon, on recule jusqu'à trouver un endroit bien
                                while caseOuPlacer.aSommetVoisin()
                                    caseOuPlacer = @grille.getCase(caseOuPlacer.x - lesAdds[0], caseOuPlacer.y - lesAdds[1])
                                    break if caseOuPlacer == sommetChoisi.position || caseOuPlacer.estVoisin(sommetChoisi.position)
                                end

                                #on test pourquoi on s'est arreté
                                if caseOuPlacer == sommetChoisi.position || caseOuPlacer.estVoisin(sommetChoisi.position)
                                    aEteCancel = true
                                else
                                    nouveauSommet = Sommet.creer(0, caseOuPlacer)
                                    #puts "sommet créé après recul en " + caseOuPlacer.x.to_s + ":" + caseOuPlacer.y.to_s
                                    @sommets.push(nouveauSommet)
                                    sommetPlaces += 1

                                    Arete.creer(nouveauSommet, sommetChoisi, rand(1..100) < @chanceDeDouble)

                                    sommetAEtePlace = true
                                end
                            end
                        elsif boolArretViaRand
                            #puts "Arrêt via rand en " + caseOuPlacer.x.to_s + ":" + caseOuPlacer.y.to_s
                            #on vérifie qu'il n'y a rien autour
                            if !(caseOuPlacer.aSommetVoisin())
                                nouveauSommet = Sommet.creer(0, caseOuPlacer)
                                @sommets.push(nouveauSommet)
                                sommetPlaces += 1

                                Arete.creer(nouveauSommet, sommetChoisi, rand(1..100) < @chanceDeDouble)

                                sommetAEtePlace = true
                            else
                                #sinon, on recule jusqu'à trouver un endroit bien
                                while caseOuPlacer.aSommetVoisin()
                                    caseOuPlacer = @grille.getCase(caseOuPlacer.x - lesAdds[0], caseOuPlacer.y - lesAdds[1])
                                    break if caseOuPlacer == sommetChoisi.position || caseOuPlacer.estVoisin(sommetChoisi.position)
                                end

                                #on test pourquoi on s'est arreté
                                if caseOuPlacer == sommetChoisi.position || caseOuPlacer.estVoisin(sommetChoisi.position)
                                    aEteCancel = true
                                else
                                    nouveauSommet = Sommet.creer(0, caseOuPlacer)
                                    @sommets.push(nouveauSommet)
                                    sommetPlaces += 1

                                    Arete.creer(nouveauSommet, sommetChoisi, rand(1..100) < @chanceDeDouble)

                                    sommetAEtePlace = true
                                end
                            end
                        end
                    else
                        #si aucun arrêt est lancé, on avance juste
                        caseOuPlacer = @grille.caseSuivante(caseOuPlacer, lesAdds[0], lesAdds[1])
                        #puts "on a avancé"
                    end
                }
              	if sommetAEtePlace
              		nbCancel = 0
                    #puts "on reset"
              	else
              		nbCancel +=1
                    #puts "on ajoute"
              	end
            else
                tourneEnBoucle += 1
            end
            #@grille.afficher()
        }
        @estGenere = true
        placerLabelSommet()
        return getGrilleSansArete()
    end
end
