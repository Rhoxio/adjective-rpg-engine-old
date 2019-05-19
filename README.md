# Adjective
## A utility that can be used to help ease the creation of RPG games

The intent of this project is to establish core functionality that is found in traditional JRPG games and allows you to extend them and modify initial values and pass in your own modifiers instead of having to write all of the more-or-less boilerplate interaction logic. 

The included functionality will have the ability to change multipliers, add conditions, and generally save time by modifying values as opposed to hard-coding values. This will make for quick customization and the ability to turn out encounters quickly so you can rapidly prototype and test new ideas.

It will include modules for usage such as:
 - Skills
 - Equipment
 - Inventory
 - Items
 - Effects (Buffs/Debuffs)
 - Experience
 - Actors (Characters)
 - Encounters
 - Locations
 
### Ideation
#### Notes on how to implement and sync up the appropriate models to one another

##### Actor
This model will hold and control the values and transformations for itself. The top-level functionality set is as follows:
Base Data:
   - Name
   - Level
   - EXP
   - Metadata (custom values)

Related Data:
   - Inventory
   - Skills
   - Equipment
   - Effects
   - Locations

## Actors and their Singleton Methods

The Actor class has a nuance in order to keep unwanted errors from propogating across models with custom data attributes when designing and writing logic. 

The intent is to be able to take any named attribute and corresponding value. The Actor class needs to be directly inhertiable from and take the child class's arguments as well. 

This means that singleton methods must be used to keep attributes from coming up nil when the end-user is trying to code against it. This curcumvents them potentially nil/falsey checking everything and instead throws a NoMethodError.

This is solved with a little bit of metaprogramming by dynamically assigning a getter, setter, and instance variable. For example:

``` 
archer = Actor.new("Legolas", {agility: 10}) 
ranger = Actor.new("Aragorn", {strength: 11})
warrior = Actor.new("Gimli", {strength: 11, wisdom: 3})
```

The archer class instance will only respond to getter/setters of #agility, ranger class instance to #strength, and warrior to #strength and #wisdom. If they have code that requires them to check multiple attributes for special moves or something, they can still assign those values and run their own checks against it.

This solution circumvents namespace pollution, as assigning the getter/setters in :attr_accessor changes the Actor class's instance variables and eliminates the need to 'purge' attributes before using the Actor class to create another type of actor (Legolas vs. Gimli, from the example above).

