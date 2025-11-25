extends Node2D

@export var speed: float = 200.0
@export var gap_size: float = 150.0
@export var gap_variation: float = 100.0

@onready var top_pipe: StaticBody2D = $TopPipe
@onready var bottom_pipe: StaticBody2D = $BottomPipe
@onready var top_sprite: Sprite2D = $TopPipe/Sprite2D
@onready var bottom_sprite: Sprite2D = $BottomPipe/Sprite2D
@onready var top_collision: CollisionShape2D = $TopPipe/CollisionShape2D
@onready var bottom_collision: CollisionShape2D = $BottomPipe/CollisionShape2D
@onready var score_area: Area2D = $ScoreArea

var passed: bool = false

func _ready():
    randomize_gap()

func _physics_process(delta: float):
    position.x -= speed * delta
    
    # Check if pipe is off screen
    if position.x < -100:
        queue_free()

func randomize_gap():
    var screen_height = get_viewport_rect().size.y
    var gap_center = randf_range(gap_size/2 + gap_variation, screen_height - gap_size/2 - gap_variation)
    
    top_pipe.position.y = gap_center - gap_size/2 - top_sprite.texture.get_height()/2
    bottom_pipe.position.y = gap_center + gap_size/2 + bottom_sprite.texture.get_height()/2

func _on_score_area_body_entered(body: Node2D):
    if body.is_in_group("bird") and not passed:
        passed = true
        get_parent().score_point()