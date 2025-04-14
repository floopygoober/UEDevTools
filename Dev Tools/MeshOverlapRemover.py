import unreal

# Tolerance value is the overlap allowance
POSITION_TOLERANCE = 0.01  

# Get the current level
editor_level = unreal.EditorLevelLibrary.get_editor_world()

# Check if two vectors are within tolerance
def are_positions_overlapping(pos1, pos2, tolerance=POSITION_TOLERANCE):
    return (abs(pos1.x - pos2.x) < tolerance and 
            abs(pos1.y - pos2.y) < tolerance and 
            abs(pos1.z - pos2.z) < tolerance)

# Get out static mesh actors
def get_mesh_from_actor(actor):
    if isinstance(actor, unreal.StaticMeshActor):
        static_mesh_component = actor.get_component_by_class(unreal.StaticMeshComponent)
        if static_mesh_component:
            return static_mesh_component.get_static_mesh()
    return None

# Search and destroy
def remove_duplicates_in_scene():
    actors = unreal.EditorLevelLibrary.get_all_level_actors()
    
    seen_actors = {}  # Dictionary to track {position, mesh} and actors at those positions
    
    for actor in actors:
        if isinstance(actor, unreal.StaticMeshActor):  # Check if the actor is a StaticMeshActor
            actor_location = actor.get_actor_location()
            actor_mesh = get_mesh_from_actor(actor)
            
            # Check if there's already an actor at the same or overlapping position and with the same mesh. 
            # This way if the mesh is different for design reasons (idk what) then keep it
            for (location, mesh) in list(seen_actors.keys()):
                if are_positions_overlapping(actor_location, location) and actor_mesh == mesh:
                    # If there is a duplicate, nuke it
                    print(f"Removing duplicate actor: {actor.get_name()} with mesh {actor_mesh.get_name()} at position {actor_location}")
                    unreal.EditorLevelLibrary.destroy_actor(actor)
                    break
            else:
                # nothing to see here move along
                seen_actors[(actor_location, actor_mesh)] = actor

remove_duplicates_in_scene()
