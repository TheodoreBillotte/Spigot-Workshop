# Workshop Plugin Minecraft

## Table des matières
- [Installation](#installation--faire-avant-le-workshop-)
- [Initialisation](#initialisation-du-projet)
- [Création du Serveur](#création-du-serveur)
- [Vérification](#vérification-que-tout-a-bien-été-fait)

## Installation (Faire avant le Workshop)
- [Java 19](https://www.oracle.com/fr/java/technologies/downloads/#java19)
- [IntelliJ IDEA](https://www.jetbrains.com/idea/download/#section=windows)
- [Spigot 1.19.3](https://getbukkit.org/download/spigot)
- [Minecraft](https://www.minecraft.net/fr-fr/download)
    - [Minecraft Crack](https://tlauncher.org/jar)

## Initialisation du Projet
- Télécharger le plugin Minecraft Development sur IntelliJ IDEA
- Créer un nouveau projet Minecraft
  - Selectionner Spigot Plugin &rarr; Next
  - Configuration du Compiler
    - GroupId: `fr.votre_pseudo`
    - ArtifactId: `Nom du Plugin`
    - Version: `1.0-SNAPSHOT`
  - Configuration Spigot &rarr; Next
  - Création du Projet
    - Créez le ficher dans lequel sera stocké le code source du plugin

## Création du Serveur
- Créer un dossier pour le serveur
- Copier le fichier spigot-1.19.3.jar dans le dossier
- Créer un fichier start.sh
  - `java -Xmx1024M -Xms1024M -jar spigot-1.19.3.jar nogui`
- Lancez le serveur avec `./start.sh`
- Dans le fichier eula.txt mettre `eula=true`
- Relancer le serveur

### Si vous êtes en Crack:
- Aller dans le fichier `server.properties` qui a été créé à la racine de 
  votre serveur Minecraft
- Mettre `online-mode=false`
- Relancer le serveur

## Vérification que tout a bien été fait
- Dans le fichier qui a été créé quand vous avez créé votre projet ajoutez 
  le code suivant dans la fonction `onEnable`:
  ```js
  getLogger().info("Votre plugin a été activé !");
  ```
- Compilez le plugin
- Vous devriez avoir un dossier target qui vient de se créer et qui contient 
  votre plugin
- Copiez le plugin dans le dossier plugins de votre serveur
- Entrez la commande `/reload` ou `/rl` dans le chat du serveur
- Vous devriez voir le message `Votre plugin a été activé !` dans la console
  du serveur
- Si vous avez un message d'erreur, vérifiez que vous avez bien suivi les 
  étapes précédentes
