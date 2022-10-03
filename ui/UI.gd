extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var total_hell_coins = 0
var total_heaven_coins = 0

var death_count = 0 setget on_death_set

# Called when the node enters the scene tree for the first time.
func _ready():
	total_heaven_coins = (get_tree().get_nodes_in_group("HeavenCoins").size())
	total_hell_coins = (get_tree().get_nodes_in_group("HellCoins").size())
	
	$HeavenCoinLabel.text = (total_heaven_coins) as String
	$HellCoinLabel.text = (total_hell_coins as String)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("help"):
		$Instructions.visible = false if $Instructions.visible else true

func _on_Player_coins_changed(new_heaven_coins, new_hell_coins):

	$HeavenCoinLabel.text = (total_heaven_coins - new_heaven_coins) as String
	$HellCoinLabel.text = (total_hell_coins - new_hell_coins) as String

func show_you_win(should_show):
	$YouWin.visible = should_show


func _on_Level_you_win():
	show_you_win(true)


func _on_HelpTimer_timeout():
	$HelpLabel.visible = false

func on_death_set(new_val):
	death_count = new_val
	
	$DeathCount.text = (death_count as String) + " Deaths"
