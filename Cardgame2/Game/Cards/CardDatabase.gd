# Card info = Name, Row, Colum, Color, Text, Event
class_name CardData

@export_enum("SLICE","MUTATE","DASH") var name : String

const ALLCARDS = {

	"SLICE":
		{
			"CARDNAME": "SLICE",
			"CARDTEXTURE":"res://Game/Cards/CardImg/CardFront/367ad8458569e202.jpeg",
			"ALLOWED_ROWS" : 12345,
			"ALLOWED_COLUMS" : 12345,
			"CARD_COLOR" : "RED",
			"CARD_SUPER_TYPE" : "ATTACK",
			"CARD_RANGE" : 1,
			"CARD_CODE" : "res://Game/Cards/Card-extensions/Card_SLICE.gd"
		},
	"MUTATE":
		{
			"CARDNAME": "MUTATE",
			"CARDTEXTURE": "res://Game/Cards/CardImg/CardFront/dd68e1c229da63a3.jpeg",
			"ALLOWED_ROWS" : 12345,
			"ALLOWED_COLUMS" : 12345,
			"CARD_COLOR" : "GREEN",
			"CARD_SUPER_TYPE" : "BUFF",
			"CARD_RANGE" : 0,
			"CARD_CODE" : "res://Game/Cards/Card-extensions/Card_MUTATE.gd"
		},
	"DASH":
		{
			"CARDNAME": "DASH",
			"CARDTEXTURE":"res://Game/Cards/CardImg/CardFront/a1069040220_10.jpg",
			"ALLOWED_ROWS" : 12345,
			"ALLOWED_COLUMS" : 12345,
			"CARD_COLOR" : "GREEN",
			"CARD_SUPER_TYPE" : "MOVE",
			"CARD_RANGE" : 2,
			"CARD_CODE" : "res://Game/Cards/Card-extensions/Card_DASH.gd"
		},
	"TELEPORT":
		{
			"CARDNAME": "TELEPORT",
			"CARDTEXTURE":"res://Game/Cards/CardImg/CardFront/0d7c9617e563f9b1.jpeg",
			"ALLOWED_ROWS" : 12345,
			"ALLOWED_COLUMS" : 12345,
			"CARD_COLOR" : "BLUE",
			"CARD_SUPER_TYPE" : "MOVE",
			"CARD_RANGE" : 4,
			"CARD_CODE" : "res://Game/Cards/Card-extensions/Card_TELEPORT.gd"
		},
	"LEAP":
		{
			"CARDNAME": "LEAP",
			"CARDTEXTURE":"res://Game/Cards/CardImg/CardFront/526a7c46d05fc544.jpeg",
			"ALLOWED_ROWS" : 12345,
			"ALLOWED_COLUMS" : 12345,
			"CARD_COLOR" : "GREEN",
			"CARD_SUPER_TYPE" : "MOVE",
			"CARD_RANGE" : 2,
			"CARD_CODE" : "res://Game/Cards/Card-extensions/Card_LEAP.gd"
		}
}
