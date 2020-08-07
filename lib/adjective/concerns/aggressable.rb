module Adjective
  module Aggressable
    # This modules intent is to give the ability to calculate attack and damage output types
    # It will need to be completely decoupled from Defensible and will be conjoined with it through
    # Controntable. Might need to consider Skillable in this implementation too...
  
    # It will need to be able to handle a few key factors:
    # 1. Delegates damage calulations based on given attributes.
    # 2. Utility methods to be present to ease development


    # =begin
    # I need to start with a model that is at lower-level than having to bind strict data to Attackable and Defensable.
    # I am thinking a "skill"

    # The skill will be held in either defensible or Aggressable.
    # For DSL for each, Aggressable would get offensive_skills and Defensible gets defensive_skills

    # Skillable (or some other name) will be the model that includes Skills and the operational logic to apply
    # or give back the proper numbers for the other two modules to use.

    # A skill is different from a status in the fact that they are directly applicable and provide 
    # more instantaneous effects. Vanilla attack would be a skill, item use would be a skill, etc.


    # If it's a skill, it would have attributes of:
    # a name/id on the test case in surrogate
    # modifiers (just like in statuses)

    # =end
  
  end
end