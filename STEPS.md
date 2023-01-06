# Toutes les étapes pour réaliser le plugin

## STEP 1: Creation point de départ, arrivée et checkpoint

### Description
Nous allons créer différents points comme le point de départ qui sera défini par
une plaque de pression sur un bloc d'or, le point d'arrivée qui sera défini par
une plaque de pression sur un bloc de diamant et les checkpoints qui seront
définis par des plaques de pression sur des blocs de fer.

### Objectifs
Gérer les événements lorsque l'on marche sur les plaques de pression pour 
définir les différents points de sauvegarde et utiliser des listes en Java pour
stocker les coordonnées du dernier checkpoint ou point de départ.

### Code
Nous allons commencer par créer une variable de type PluginManager qui va nous
permettre de gérer les événements du plugin.
Une fois cela fait nous allons pouvoir ajouter un event qui va nous permettre de
diriger les événements lorsque l'on marche sur une plaque de pression.

Dans la fonction `onEnable` de votre class Main ajoutez le code suivant :
```js
PluginManager pm = getServer().getPluginManager();
pm.registerEvents(new JumpEvent(), this);
```

Comme la class `JumpEvent` n'existe pas encore nous allons la créer. Pour cela,
créez un nouveau dossier `events` dans lequel vous allez créer un fichier
`JumpEvent.java`.

Dans ce fichier, ajoutez le code suivant :
```java
public class JumpEvent implements Listener {
    @EventHandler
    public void onPlayerInteract(PlayerInteractEvent event) {
        Block block = event.getClickedBlock();
        Action action = event.getAction();
        Player player = event.getPlayer();
        
        if (block == null)
            return;
        
        if (action.equals(Action.PHYSICAL) && block.getType().equals(Material.HEAVY_WEIGHTED_PRESSURE_PLATE)) {
            event.getPlayer().sendMessage("Vous avez marcher sur une plaque de pression");
        }
    }
}
```

Une fois que vous avez fait cela, si vous lancez votre serveur et que vous 
marchez sur une plaque de pression, vous devriez voir le message `Vous avez 
marcher sur une plaque de pression` dans le chat.

Vous allez maintenant devoir afficher un message différent en fonction de si 
le bloc qui se trouve en dessous est un bloc d'or, un bloc de fer ou un 
bloc de diamant.

pour récupérer le bloc sous la plaque de pression, vous pouvez utiliser le 
code suivant :
```java
Block block = event.getClickedBlock();
Block blockUnder = block.getRelative(BlockFace.DOWN);
```

Pour récupérer le type du bloc, vous pouvez utiliser le code suivant :
```java
blockUnder.getType();
```

A partir de cela vous pouvez afficher un message différent en fonction du type
du bloc, donc en fonction de si c'est un point de départ (or), un checkpoint
(fer) ou un point d'arrivée (diamant).

## STEP 2: Gestion des checkpoints

### Description
Nous allons maintenant mettre en place le système de checkpoint, c'est-à-dire
que lorsque nous marchons sur la plaque de pression nous allons sauvegarder 
les coordonnées du checkpoint et lorsque le joueur fera la commande 
`/checkpoint` il sera téléporté sur le dernier checkpoint.

### Objectifs
Pour enregistrer les checkpoints de tous les joueurs, nous allons utiliser une
HashMap qui va nous permettre de stocker les coordonnées du dernier checkpoint
pour chaque joueur. Cette HashMap sera mise à jour à chaque fois qu'un joueur
va marcher sur une plaque de pression.

Ensuite, nous allons créer une commande pour s'y téléporter dans le cas où 
nous avons un checkpoint.

### Code
Nous allons commencer par créer une HashMap qui va nous permettre de stocker
les coordonnées du dernier checkpoint pour chaque joueur. Pour cela, ajoutez
le code suivant dans la class `Main` :
```java
public static HashMap<UUID, Location> checkpoints = new HashMap<>();
```

Cette HashMap contient un UUID car chaque joueur a un UUID unique qui nous 
permet d'utiliser moins d'espace mémoire que de stocker toute la class Player.

Nous allons maintenant mettre à jour cette HashMap à chaque fois qu'un joueur
marche sur une plaque de pression. Dans le cas où le joueur marche sur le 
point de départ, ajoutez le joueur à la HashMap avec les coordonnées du point
de départ. Dans le cas où le joueur marche sur un checkpoint, actualisez la 
HashMap avec les coordonnées du checkpoint. Dans le cas où le joueur marche
sur le point d'arrivée, supprimez le joueur de la HashMap.

Pour récupérer les coordonnées du bloc, vous pouvez utiliser le code suivant :
```java
Location location = block.getLocation();
```

Pour récupérer la HashMap, vous pouvez utiliser le code suivant :
```java
HashMap<UUID, Location> checkpoints = Main.checkpoints;
```

Pour savoir si un joueur est dans la HashMap, vous pouvez utiliser le code
suivant :
```java
checkpoints.containsKey(player.getUniqueId());
```

Pour récupérer les coordonnées du dernier checkpoint, vous pouvez utiliser le
code suivant :
```java
Location location = checkpoints.get(player.getUniqueId());
```

Pour ajouter un joueur à la HashMap, vous pouvez utiliser le code suivant :
```java
checkpoints.put(player.getUniqueId(), location);
```

Pour changer les coordonnées d'un joueur dans la HashMap, vous pouvez utiliser
le code suivant :
```java
checkpoints.replace(player.getUniqueId(), location);
```

Pour supprimer un joueur de la HashMap, vous pouvez utiliser le code suivant :
```java
checkpoints.remove(player.getUniqueId());
```

Nous allons maintenant créer une commande pour s'y téléporter. Pour cela,
allez dans la class `Main` et ajoutez le code suivant :
```java
getCommand("checkpoint").setExecutor(new CheckpointCommand());
```

Pour que la commande soit correctement créé, vous devez aller dans le 
dossier `ressources`, vous y trouverez un fichier `plugin.yml`. Ajoutez le
code suivant dans ce fichier :
```yaml
commands:
  checkpoint:
    description: Teleporte le joueur sur le dernier checkpoint
    aliases: [cp]
    usage: /checkpoint
    permission: checkpoint.command
    permission-message: Vous n'avez pas la permission d'utiliser cette commande
```

Comme la class `CheckpointCommand` n'existe pas encore nous allons la créer.
Créez un nouveau dossier `commands` dans lequel vous allez créer un fichier
`CheckpointCommand.java`.

Dans ce fichier, ajoutez le code suivant :
```java
public class CheckpointCommand implements CommandExecutor {

    @Override
    public boolean onCommand(CommandSender sender, Command command, String label, String[] args) {
        if (!(sender instanceof Player))
            return false;

        Player player = (Player) sender;
        HashMap<UUID, Location> checkpoints = TestPlugin.instance.checkpoints;
        return true;
    }

}
```

Une fois que vous avez cela, vous allez devoir vérifier si le joueur est dans
la HashMap. Si c'est le cas, vous allez le téléporter sur le dernier checkpoint
et vous allez afficher un message dans le chat pour dire que le joueur a 
bien été téléporté. Si ce n'est pas le cas, vous allez afficher un message 
dans le chat pour dire qu'il n'a pas de checkpoint.

## STEP 3: Gestion des points d'arrivée

### Description
Nous allons maintenant mettre en place le système de points d'arrivée, 
c'est-à-dire que lorsque nous marchons sur la plaque de pression, nous allons 
vérifier si le joueur a un checkpoint. Si c'est le cas, nous allons afficher un
message dans le chat pour dire que le joueur a gagné et afficher son temps de 
parcours après le message.

### Objectifs
Créer une nouvelle HashMap qui va contenir le temps auquel le jouer a 
commencé le parcours, puis une fois que le joueur a gagné, nous allons
calculer le temps qu'il a mis pour finir le parcours.

### Code
Nous allons commencer par créer une HashMap qui va nous permettre de stocker
le temps auquel le jouer a commencé le parcours. Pour cela, ajoutez le code
suivant dans la class `Main` :
```java
public static HashMap<UUID, Long> timers = new HashMap<>();
```

Nous allons maintenant mettre à jour cette HashMap à chaque fois qu'un joueur
marche sur le point de départ. Pour récupérer le temps actuel, vous pouvez
utiliser le code suivant :
```java
long time = System.currentTimeMillis();
```

Une fois le temps enregistré dans la HashMap quand le joueur marche sur le
point de départ, nous allons faire en sorte que quand le joueur marche sur le
point d'arrivée, nous allons calculer le temps qu'il a mis pour finir le
parcours.

Pour afficher le temps de parcours, vous pouvez utiliser le code suivant :
```java
player.sendMessage("Vous avez mis " + (startTime - time) / 1000 + "ms pour finir le parcours.");
```

## STEP 4: Création de Parcours

### Description
Nous allons maintenant créer un système qui va nous permettre de créer des
parcours. Pour cela, nous allons créer une commande qui va nous permettre de
créer un parcours, une commande qui va nous permettre de nous téléporter à 
un parcours et une commande qui va nous permettre de supprimer un parcours, 
tout ça avec des arguments.

Tous les parcours seront stockés dans un fichier `jump.yml` qui se trouvera
dans le dossier `ressources` du plugin.

### Objectifs
Créer une commande qui va prendre plusieurs arguments et qui va mettre à 
jour un fichier de configuration.

Créer un fichier de configuration qui va contenir tous les parcours, et 
mettre à jour les données à l'intérieur et récupérer les données à 
l'intérieur pour les utiliser dans le plugin.

### Code
Nous allons commencer par créer un fichier de configuration avec le nom 
`jump.yml` qui se trouvera dans le dossier `ressources` du plugin.
Pour cela, ajoutez le code suivant dans la class `Main` :
```java
public static YamlConfiguration config;
public static File configFile;
```

Ensuite, ajoutez le code suivant dans la méthode `onEnable` :
```js
configFile = new File(getDataFolder(), "jump.yml");
config = YamlConfiguration.loadConfiguration(configFile);
```

Nous allons maintenant créer une commande qui va nous permettre de créer un
parcours. Pour cela, ajoutez le code suivant dans la class `Main` :
```java
getCommand("parkour").setExecutor(new ParkourCommand());
```

Pour que la commande soit correctement créé, vous devez retourner dans le 
fichier `plugin.yml` et ajouter le code suivant :
```yaml
commands:
  parkour:
    description: Gestion des parcours
    aliases: [pk]
    usage: /parkour <create | delete | <name>> [name]
    permission: parkour.command
    permission-message: Vous n'avez pas la permission d'utiliser cette commande
```

Comme la class `ParkourCommand` n'existe pas encore nous allons la créer.
Dans le dossier `commands` que vous avez créé précédemment, créez un fichier
`ParkourCommand.java`.

Dans ce fichier, ajoutez le code suivant :
```java

public class ParkourCommand implements CommandExecutor {

    @Override
    public boolean onCommand(CommandSender sender, Command command, String label, String[] args) {
        if (!(sender instanceof Player))
            return false;

        Player player = (Player) sender;
        YamlConfiguration config = Main.config;
        File configFile = Main.configFile;
    }

}
```

Une fois que vous avez cela, vous allez devoir vérifier si la commande a été
utilisée avec le bon nombre d'arguments (2 ou 3).

Pour cela, ajoutez le code suivant :
```js
if (args.length < 2 || args.length > 3) {
    player.sendMessage("§cUsage: /parkour <create | delete | <name>> [name]");
    return false;
}
```

Nous allons maintenant vérifier les arguments de la commande pour savoir ce 
que le joueur veut faire. Pour cela, ajoutez le code suivant :
```js
if (args[0].equalsIgnoreCase("create")) {
    // Création d'un parcours
} else if (args[0].equalsIgnoreCase("delete")) {
    // Suppression d'un parcours
} else {
    // Téléportation à un parcours
}
```

Pour créer un parcours, supprimer un parcours et se téléporter vers un 
parcours, vous aurez besoin de récupérer les informations dans le fichier 
`jump.yml` et de les mettre à jour.

Pour récupérer les informations dans le fichier `jump.yml`, vous pouvez
utiliser le code suivant :
```js
config.get("path.to.data");
```

Pour mettre à jour les informations dans le fichier `jump.yml`, vous pouvez
utiliser le code suivant :
```js
config.set("path.to.data", value);
```

Pour supprimer une donnée dans le fichier `jump.yml`, vous pouvez utiliser
le code suivant :
```js
config.set("path.to.data", null);
```

Pour sauvegarder les modifications dans le fichier `jump.yml`, vous pouvez
utiliser le code suivant :
```js
try {
    config.save(configFile);
} catch (IOException e) {
    e.printStackTrace();
}
```

Une fois que vous savez faire ça vous pouvez créer un parcours sachant que 
le premier argument est `create` et que le deuxième argument est le nom du 
parcours qui va être créé.

Donc, vous allez devoir sauvegarder la `Location` du joueur dans le fichier.

Pour récupérer la `Location` du joueur, vous pouvez utiliser le code suivant :
```js
Location location = player.getLocation();
```

Pour sauvegarder la `Location` du joueur dans le fichier, vous pouvez
utiliser le code suivant :
```js
config.set(args[1], location);
```

Pour supprimer un parcours cela va fonctionner de la même manière que pour
créer un parcours sauf que vous allez devoir mettre `null` à la place de la
`Location`.
Et enfin pour se téléporter vers un parcours, vous allez devoir récupérer
la `Location` du parcours dans le fichier et vous téléporter à cette
`Location`.

Pour cela, vous pouvez utiliser le code suivant :
```js
Location location = config.getLocation(args[0]);
player.teleport(location);
```

N'hésitez pas à ajouter différents messages en fonction de si la commande 
est incomplète, ou avec des arguments invalides, ou encore si la commande a 
été correctement entrée et que le parcours a été créé ou supprimé.


## STEP 5: Pour aller plus loin
- Ajouter un item qui permet de se téléporter vers un checkpoint
- Ajouter un item qui permet de se téléporter vers le début du parcours
- Ajouter un message au-dessus de la hotbar avec le temps que vous mettez à 
  faire le parcours.
