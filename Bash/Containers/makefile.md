# Target + prereqs/dependencies + recipe = rule 
# Target behaves like function
# Preqs or dependencies follow target
target: prerequisites
<TAB> recipe

# Target = say_hello
say_hello:
# recipe
        echo "Hello World"

# target can be binary file that depends on prerequisites (source files)
# Or prerequisite can also be a target that depends on other dependencies
final_target: sub_target final_target.c
        Recipe_to_create_final_target

sub_target: sub_target.c
        Recipe_to_create_sub_target

# Target say_hello just name for recipe = phony target 
say_hello:
        @echo "Hello World"