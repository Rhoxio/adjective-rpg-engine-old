![](https://i.ibb.co/vLkwSgy/adjective-logo1.png)

# Adjective
## A utility that can be used to help ease the creation of RPG games

_This is currently in-development. Only the blank repo is available on rubygems at the moment_

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
   
## Global Management
This project will also include a global management system and auto-incrementing instance ids on a per-model basis. Essentially, you can set globals at startup and have important adjective-specific ones be automatically managed in runtime.

#### Effect
Parent class for an Effect. 
Effects are categorized as things that modify (buff or debuff) Items and their dynamic attributes.

#### Status
Parent class for a Status.
Statuses are categorized as things that modify an Actor or added when a Skill is used. 

#### Effect::Actor
Effects will need to be applied to Actors:
- Applies to specific attribute(s)
- Execute arbitrary code against attribute specified (proc block something?)
- Have general types that are able to be changed in init (not after, specifically)
- Establish top-end duration, if no top-end, specify :unlimited
- Designate condition for removal
  - Time-based
  - Effect-based

#### Statusable
Intermediary class that contains application of debuff and buff logic including type checking and flexible (attribute-based) processing of data for health modifiers (healing/damage) and stat changes.

#### Affectable
Intermediary class that will contain intermediary logic between Effects < Effects::Actors, ::Items, ::Skills etc. 

First we need a base Effect class.

Each class will probably need 

