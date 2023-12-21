extends Control



func listen_to_figure(figure : Figure):
	if figure.is_controllable:
		figure.connect("update_figure_interface",updatefigureinterface)
		
		
var updatefigureinterface = func update_figure_interface(figure : Figure):
	if figure.figure_owner.playerid == 1:
		$Figure_Stats_Loc/PFigureHealth.set_text("Pfigure Life = " + str(figure.life))
		$Figure_Stats_Loc/PColorStats.set_text("RED = " + str(figure.figure_deck.color_stats.x)
		+ "  GREEN = " + str(figure.figure_deck.color_stats.y) + "  BLUE = " + str(figure.figure_deck.color_stats.z))
		$Figure_Stats_Loc/PResources.set_text(str(figure.resource))
	else:
		$Figure_Stats_Loc/OFigureHealth.set_text("Ofigure Life = " + str(figure.life))
		$Figure_Stats_Loc/OColorStats.set_text("RED = " + str(figure.figure_deck.color_stats.x)
		+ "  GREEN = " + str(figure.figure_deck.color_stats.y) + "  BLUE = " + str(figure.figure_deck.color_stats.z))
		$Figure_Stats_Loc/OResources.set_text(str(figure.resource))	
