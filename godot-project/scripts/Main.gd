extends Node2D

@export var pipe_scene: PackedScene
@export var pipe_speed: float = 200.0
@export var pipe_speed_increment: float = 10.0
@export var spawn_rate: float = 2.0

@onready var bird: CharacterBody2D = $Bird
@onready var score_label: Label = $UI/ScoreLabel
@onready var game_over_screen: Control = $UI/GameOverScreen
@onready var restart_button: Button = $UI/GameOverScreen/RestartButton
@onready var final_score_label: Label = $UI/GameOverScreen/FinalScoreLabel

var score: int = 0
var game_running: bool = false
var pipe_timer: float = 0.0
var current_pipe_speed: float = 200.0

func _ready():
    start_game()

func _process(delta: float):
    if game_running:
        pipe_timer += delta
        if pipe_timer >= spawn_rate:
            spawn_pipe()
            pipe_timer = 0.0
        
        # Gradually increase pipe speed
        current_pipe_speed += pipe_speed_increment * delta * 0.1

func start_game():
    score = 0
    current_pipe_speed = pipe_speed
    pipe_timer = 0.0
    game_running = true
    bird.reset()
    score_label.text = "Score: " + str(score)
    game_over_screen.visible = false
    
    # Clear existing pipes
    for child in get_children():
        if child.is_in_group("pipe"):
            child.queue_free()

func spawn_pipe():
    var pipe = pipe_scene.instantiate()
    pipe.speed = current_pipe_speed
    pipe.position = Vector2(get_viewport_rect().size.x + 100, 0)
    add_child(pipe)

func score_point():
    score += 1
    score_label.text = "Score: " + str(score)

func bird_died():
    game_running = false
    game_over_screen.visible = true
    final_score_label.text = "Final Score: " + str(score)

func _on_restart_button_pressed():
    start_game()