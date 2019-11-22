![](https://i.ibb.co/vLkwSgy/adjective-logo1.png)

# Adjective
## A utility that can be used to help ease the creation of RPG games

_This is currently in-development. Only the blank repo is available on rubygems at the moment_

The intent of this project is to establish core functionality that is found in traditional JRPG games and allows you to extend them and modify initial values and pass in your own modifiers instead of having to write all of the more-or-less boilerplate interaction logic. 

The included functionality will have the ability to change multipliers, add conditions, and generally save time by modifying values as opposed to hard-coding values. This will make for quick customization and the ability to turn out encounters quickly so you can rapidly prototype and test new ideas.

It will include modules for usage such as:
 - Skills
 - Equipment
 - Inventory *
 - Items *
 - Stauses (Buffs/Debuffs) -
 - Experience *
 
### Ideation
This project has shifted the design principles quite a lot since the beginning, and after more research it seems like most of the functionality can be pulled out into modules rather than using inheritance. 

I found it funny that the name of the project was somewhat synonymous with what type of code I had to write. 
   
### Global Management
This project will also include a global management system and auto-incrementing instance ids on a per-model basis. Essentially, you can set globals at startup and have important adjective-specific ones be automatically managed in runtime.

### Modules
#### Statusable
Intermediary class that contains application of debuff and buff logic including type checking and flexible (attribute-based) processing of data for health modifiers (healing/damage) and stat changes.

#### Imbibable
Module that takes resonsibility for experience tracking. Includes options to constrain experience and supress level-ups for event-based gating for other code to be run. 

#### Storable
Module that takes responsibility for inventory. Anything can potentially have inventory slots - like a weapon with enchanted jewels or a backpack of infinite holding. Includes utility methods to help with filtering and CRUD.

#### Vulnerable
Module that takes responsibility for hitpoint values. Includes methods that allow for the ability to take damage and heal. 

