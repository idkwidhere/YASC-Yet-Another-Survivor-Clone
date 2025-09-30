extends Node2D

const DEFLECTOR_ORBITER = preload("uid://5rst88yt6q7j")

var orbiter_count: int = 1
var orbit_speed: float = 1.0
var orbiters: Array = []
var orbit_radius: float = 64.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_orbiters()

func spawn_orbiters() -> void:
	clear_orbiters()
	for i in range(orbiter_count):
		var orbiter = DEFLECTOR_ORBITER.instantiate()
		add_child(orbiter)
		orbiters.append(orbiter)
		# Give each orbiter its own angle offset
		orbiter.angle = (TAU / orbiter_count) * i
		orbiter.orbit_radius = orbit_radius
		orbiter.orbit_speed = orbit_speed

func clear_orbiters():
	for orb in orbiters:
		orb.queue_free()
	orbiters.clear()
	
func upgrade_amount(add_amount: int) -> void:
	orbiter_count += add_amount
	spawn_orbiters()

func upgrade_radius(add_amount: float) -> void:
	orbit_radius += add_amount
	for orb in orbiters:
		orbit_radius = orbit_radius
