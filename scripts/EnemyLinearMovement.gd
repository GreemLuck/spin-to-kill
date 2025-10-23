extends MovementController
class_name EnemyLinearMovement

## Delay between back and forth movement
@export var delay: float = 1.0
## Makes the movement horizontal instead of vertical
@export var is_horizontal : bool = false
## Strength of the impulse between delays
@export var impulse_str : float = 100.0

## Timer used to change the direction of the entity
var timer : Timer
var direction : Vector2 = Vector2.UP

func init(owner):
	super(owner)
	
	# Timer setup
	timer = Timer.new()
	timer.wait_time = delay
	timer.autostart = true
	_self.add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	
	# Starts the movement
	if is_horizontal:
		direction = Vector2.RIGHT
	
	_self.apply_impulse(direction * (impulse_str/2))

	
func _on_timer_timeout():
	direction *= -1 # Flips the direction
	_self.apply_impulse(direction * impulse_str)
	
