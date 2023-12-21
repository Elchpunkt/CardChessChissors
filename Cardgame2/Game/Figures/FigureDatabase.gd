class_name FigureData

@export_enum("CYBORG","MUTANT","SOLDIER","WALKINGTURRET") var name : String
#name,scene,deckname,is_controllable
const ALLFIGURES = {
	"CYBORG" :
		["Cyborg","res://Game/Figures/FigureScenes/Cyborg.tscn","StandartDeck",true],
	"MUTANT" :
		["Mutant","res://Game/Figures/FigureScenes/Mutant.tscn","StandartDeck",true],
	"SOLDIER" :
		["Soldier","res://Game/Figures/FigureScenes/Soldier.tscn","StandartDeck",true],
	"WALKINGTURRET":
		["Walking Turret","res://Game/Figures/FigureScenes/Minion.tscn","Miniondeck",false]
}
