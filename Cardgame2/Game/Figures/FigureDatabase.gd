class_name FigureData

@export_enum("CYBORG","MUTANT","SOLDIER") var name : String
#name,scene,deckname,is_controllable
const ALLFIGURES = {
	"CYBORG" :
		["Cyborg","res://Game/Figures/FigureScenes/BasicFigure.tscn","StandartDeck",true],
	"MUTANT" :
		["Mutant","res://Game/Figures/FigureScenes/Mutant.tscn","StandartDeck",true],
	"SOLDIER" :
		["Soldier","res://Game/Figures/FigureScenes/BasicFigure.tscn","StandartDeck",true]
}
