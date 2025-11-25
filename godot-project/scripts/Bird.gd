extends CharacterBody2D

@export var gravity: float = 980.0
@export var flap_impulse: float = -300.0
@export var max_fall_speed: float = 400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var is_alive: bool = true
var flap_rotation: float = -0.5
var fall_rotation: float = 0.8

func _ready():
    sprite.play("flap")

func _physics_process(delta: float):
    if not is_alive:
        return
    
    # Apply gravity
    velocity.y += gravity * delta
    
    # Limit fall speed
    velocity.y = min(velocity.y, max_fall_speed)
    
    # Handle flap input
    if Input.is_action_just_pressed("flap"):
        velocity.y = flap_impulse
        rotation = flap_rotation
        sprite.play("flap")
    
    # Rotate based on velocity
    if velocity.y < 0:
        rotation = lerp(rotation, flap_rotation, 0.1)
    else:
        rotation = lerp(rotation, fall_rotation, 0.05)
    
    # Move and slide
    move_and_slide()
    
    # Check for ground collision
    if position.y > get_viewport_rect().size.y - 50:
        die()

func flap():
    if is_alive:
        velocity.y = flap_impulse
        rotation = flap_rotation
        sprite.play("flap")

func die():
    is_alive = false
    sprite.stop()
    rotation = fall_rotation
    # Emit signal to main game
    get_parent().bird_died()

func reset():
    position = Vector2(100, 300)
    velocity = Vector2.ZERO
    rotation = 0
    is_alive = true
    sprite.play("flap")