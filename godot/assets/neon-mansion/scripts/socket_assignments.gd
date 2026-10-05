extends RefCounted
## Run-scoped assignments live in the repository work folder, never in source/vendor assets.
var path: String
var assignments: Dictionary = {}
var writable := true

func load_run(file_path: String, sockets: Array, templates: Dictionary) -> void:
	path = file_path
	if not FileAccess.file_exists(path):
		return
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	if not parsed is Dictionary or parsed.get("schema_version", 0) != 1 or not parsed.get("assignments", null) is Dictionary:
		writable = false
		push_warning("Run assignments invalid; preserving file and using temporary fallback assignments.")
		return
	for socket in sockets:
		var chosen: String = parsed.assignments.get(socket.socket_id, "")
		if not chosen.is_empty():
			if not compatible(socket, chosen, templates):
				writable = false
				push_warning("Incompatible saved socket assignment; preserving source save.")
				continue
			assignments[socket.socket_id] = chosen

func compatible(socket: Dictionary, key: String, templates: Dictionary) -> bool:
	if not templates.has(key) or not key in socket.templates:
		return false
	var t: Dictionary = templates[key]
	return t.size_class == socket.size_class and t.footprint == socket.footprint and t.category in socket.permitted_categories and t.floor == socket.floor and t.wing == socket.wing and t.entry_edge == socket.entry_edge and t.entry_offset == socket.entry_offset and t.entry_width == socket.door_connections[0].width and t.service_requirement == socket.service_requirement and (not t.requires_window or socket.exterior_window.allowed) and (not socket.exterior_window.required or t.requires_window)

func select(socket: Dictionary, templates: Dictionary, seed_value: int) -> String:
	var id: String = socket.socket_id
	if assignments.has(id):
		return assignments[id]
	var valid: Array[String] = []
	for key in socket.templates:
		if compatible(socket, key, templates):
			valid.append(key)
	assert(not valid.is_empty(), "No compatible authored room template")
	var choice := valid[posmod(seed_value, valid.size())]
	assignments[id] = choice
	save()
	return choice

func save() -> void:
	if not writable:
		return
	var directory_error := DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path).get_base_dir())
	if directory_error != OK:
		push_error("Cannot create room assignment directory: " + path)
		return
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Cannot save room assignments: " + path)
		return
	file.store_string(JSON.stringify({"schema_version": 1, "assignments": assignments}, "\t"))
