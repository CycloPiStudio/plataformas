extends Node
var pant_carga
var loader
var wait_frames
var time_max = 100 # msec
var current_scene

func _ready():
    var root = get_tree().get_root()
    current_scene = root.get_child(root.get_child_count() -1)

func goto_scene(path): # game requests to switch to this scene
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
#        show_error()
		return
	set_process(true)
	
	current_scene.queue_free() # get rid of the old scene
	pant_carga = load("res://Menus/pantalla_carga/Carga.tscn").instance()
#	pant_carga.instance()
	get_tree().get_root().add_child(pant_carga)
	# start your "loading..." animation
#    get_node("animation").play("carga")

	wait_frames = 40

func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	if wait_frames > 0: # wait for frames to let the "loading" animation show up
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control for how long we block this thread

        # poll your loader
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
#			update_progress()
			pass
		else: # error during loading
#            show_error()
            loader = null
            break
			
#func update_progress():
#    var progress = float(loader.get_stage()) / loader.get_stage_count()
    # Update your progress bar?
#    get_node("progress").set_progress(progress)

    # ... or update a progress animation?
#    var length = get_node("animation").get_current_animation_length()

    # Call this on a paused animation. Use "true" as the second argument to force the animation to update.
#    get_node("animation").seek(progress * length, true)

func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
	pant_carga.queue_free()