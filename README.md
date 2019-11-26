![](https://i.ibb.co/vLkwSgy/adjective-logo1.png)

# Adjective
## A utility that can be used to help ease the creation of RPG games

_This is currently in-development. Only the blank repo is available on rubygems at the moment_

The intent of this project is to establish core functionality that is found in traditional JRPG games and allows you to extend them and modify initial values and pass in your own modifiers instead of having to write all of the more-or-less boilerplate interaction logic. 

The included functionality will have the ability to change multipliers, add conditions, and generally save time by modifying values as opposed to hard-coding values. This will make for quick customization and the ability to turn out encounters quickly so you can rapidly prototype and test new ideas.

It will include modules for usage such as:
 - Confrontable (Battle)
 - Skills
 - Equipment
 - Inventory *
 - Items *
 - Stauses (Buffs/Debuffs) -
 - Experience *
 
### Ideation
This project has shifted the design principles quite a lot since the beginning, and after more research it seems like most of the functionality can be pulled out into modules rather than using inheritance. 

I found it funny that the name of the project was somewhat synonymous with what type of code I had to write. 

_Completed so far_

### Classes
#### Item
Provides a good skeleton class for Storable to use immediately. Nothing too complex - but it does include default instance_id incrementation at the moment. 
```Ruby
item = Adjective::Item.new({ name: "Potato"})
```

#### Status
A flexible class that has simple utility methods and allows for direct integration with Statusable. Ex:
```Ruby
Adjective::Status.new("Renew", { affected_attributes: { hitpoints: 5 }})
```

This will increment the hitpoints of the receiver by 5. 

### Modules
### Global Management
This project will include a global management system and auto-incrementing instance ids on a per-model basis. Essentially, you can set globals at startup and have important adjective-specific ones be automatically managed in runtime.
```Ruby
Adjective::GlobalManager.initialize do |settings|
  # Will automatically include and increment adjective-specific entries that will need distinguination
  settings[:custom] = {
    key: 0,
    other_global: 0
  }
end
$key #=> 0
$other_global #=> 0

Adjective::GlobalManager.get_globals #=> {"key" => "0", "other_global" => "0", "item_instance_ref"=>"1", "actor_instance_ref"=>"1", "inventory_instance_ref"=>"1"}

Adjective::GlobalManager.initialize
Adjective::GlobalManager.load_globals({data: enemies_killed: 10})
Adjective::GlobalManager.get_globals #=> {"item_instance_ref"=>"1", "actor_instance_ref"=>"1", "inventory_instance_ref"=>"1", "enemies_killed" => 10}
```

#### Statusable
Intermediary class that contains application of debuff and buff logic including type checking and flexible (attribute-based) processing of data for health modifiers (healing/damage) and stat changes.
```Ruby
renew = Adjective::Status.new("Renew", { affected_attributes: { hitpoints: 5 }})
actor = Actor.new("DefaultDude") # has Statusable and Vulnerable included
actor.hitpoints #=> 1
actor.apply_status(@renew)
actor.tick_all
actor.hitpoints #=> 6

```

#### Imbibable
Module that takes resonsibility for experience tracking. Includes options to constrain experience and supress level-ups for event-based gating for other code to be run. This is purely index-based, meaning the code below assumes 'actor' is level 1 and has 200 experience by default from the table given to the exp_table option. This actor would need 200 exp to go from level 0 to 1, but only 100 to go from 1 to 2.

```Ruby
actor = Actor.new("DefaultDude", {exp_table: [0,200,300,400,500,600,700,800,900,1000, 1200]}) # Has Imbibable included
actor.level #=> 1
actor.experience #=> 200
actor.grant_experience(100)
actor.level #=> 2
```

#### Storable
Module that takes responsibility for inventory. Anything can potentially have inventory slots - like a weapon with enchanted jewels or a backpack of infinite holding. Includes utility methods to help with filtering and CRUD.

```Ruby
# Some example cases...
mana_potion = SurrogateItem.new({name: "Mana Potion", uses: 2, potency: 8})
health_potion = SurrogateItem.new({name: "Health Potion", uses: 2, potency: 8})
speed_potion = SurrogateItem.new({name: "Speed Potion", uses: 1, potency: 12})
seed = SurrogateItem.new({name: "Grass Seed", uses: 1, effect: "grow"})

inventory = Inventory.new("Backpack", [mana_potion, mana_potion, health_potion, speed_potion]) # Has Storable included
inventory.sort! #=> [health_potion, mana_potion, mana_potion, speed_potion]

inventory.store(seed)
inventory.items #=> [seed, health_potion, mana_potion, mana_potion, speed_potion]

inventory.search("uses") #=> [seed, health_potion, mana_potion, mana_potion, speed_potion] Will look at both attributes and values
inventory.search("potion", :values) #=> [health_potion, mana_potion, mana_potion, speed_potion] Will only look at values
inventory.search("effect", :attributes) #=> [seed] Will only look at attributes

inventory.dump #=> [seed, health_potion, mana_potion, mana_potion, speed_potion]
inventory.empty? #=> true
inventory.items #=> []
```

#### Vulnerable
Module that takes responsibility for hitpoint values. Includes methods that allow for the ability to take damage and heal. 

```Ruby
actor = SurrogateActor.new("DefaultDude") # Has Vulnerable included
actor.hitpoints #=> 1
actor.alive? #=> true

actor.heal_to_full
actor.hitpoints #=> 10

actor.take_damage(10) #=> 0
actor.dead? #=> true

# Also has overflow and underflow checks by default
actor.heal_for(9999) #=> 10
actor.hitpoints #=> 10

actor.take_damage(9999) #=> 0
actor.hitpoints #=> 0

```

_In the Works_

#### Confrontable
Base combat module. I imagine this taking two main supporting modules - Aggressible and Defensible. 
 - Aggressible will contain logic for calculating attacks and damage output types.
 - Defensible will include damage reduction and immunity check mechanics.

#### Comprehensible
Module for skills. Will handle Status objects with a simple paradigm set up around the Skill class.

