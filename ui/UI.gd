extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var total_hell_coins = 0
var total_heaven_coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	total_heaven_coins = (get_tree().get_nodes_in_group("HeavenCoins").size())
	total_hell_coins = (get_tree().get_nodes_in_group("HellCoins").size())
	
	$HeavenCoinLabel.text = (total_heaven_coins) as String
	$HellCoinLabel.text = (total_hell_coins as String)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_coins_changed(new_heaven_coins, new_hell_coins):

	$HeavenCoinLabel.text = (total_heaven_coins - new_heaven_coins) as String
	$HellCoinLabel.text = (total_hell_coins - new_hell_coins) as String

func show_you_win(should_show):
	$YouWin.visible = should_show


func _on_Level_you_win():
	show_you_win(true)
