extends Node2D
enum GameState { Loading, Running, GameOver }


@onready var State = GameState.Loading
@onready var enemyObj = preload("res://enemy.tscn")


var Player = null
var Enemies = Array()
var cam = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.currentStage = 1
	var labelText = "Stage = " + str(Global.currentStage)
	$Stage_counter.set_text(labelText)
	$AnimationPlayer.play("Stage_Display")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$HUD/Kills.set_text("Kills = " + str(Global.kills))

func _input(_event):
	if(State == GameState.GameOver):
		get_tree().change_scene_to_file("res://TitleSamolet.tscn")  

func init_level_play():
	startAnimationDone()


func startAnimationDone():
	$Stage_counter.visible = false
	Player = load("res://player.tscn").instantiate()
	Player.position = Vector2(400, 500)
	cam = Camera2D.new()
	cam.position.x = 400
	add_child(Player)
	Player.add_child(cam)
	cam.enabled = true;
	cam.make_current()
	SpawnEnemies()
	State = GameState.Running

func _on_Area2D_area_entered(_area):
 	#Did we hit the trigger to queue boss fight?
	#if(area.get_collision_layer_bit(4)):
	if(State == GameState.Running):
		Player.PlayerSpeed = 0
		Global.currentStage = Global.currentStage + 1
		get_tree().reload_current_scene()
	 
func PlayerDied():
	for i in Player.get_children():
		i.queue_free()
	for i in Enemies:
		if i != null:
			remove_child(i)
	remove_child(Player)
	State = GameState.GameOver
	$Stage_counter.set_text("Game Over")
	$Stage_counter.visible = true

func SpawnEnemy(x,y):
	var enemy = enemyObj.instantiate()
	enemy.set_position(Vector2(x,y))
	add_child(enemy)
	Enemies.append(enemy)

func SpawnEnemies():
	randomize()
 	# One extra plane per stage
	for i in range(0,30+ 5 * Global.currentStage):
		SpawnEnemy(Random_X_pos(),Random_Y_pos())

func SpawnBossWave():
	for i in range(0,10):
		SpawnEnemy(3800 + randi()%220, randi()%int(get_viewport_rect().size.y - 300))

func Random_X_pos():
	return 1200 + randi() % 5000
	
func Random_Y_pos():
	return randi()%int(get_viewport_rect().size.y - 300) + 200
