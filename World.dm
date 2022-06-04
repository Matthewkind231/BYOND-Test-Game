world {
	view = 32;
	fps = 60;
	New() {

		..()
		sleep(10)
		// When a new world is created, populate the TurfList with water objects.
		TurfList = new/list(world.maxx, world.maxy);
		for(var/row = 1, row <= TurfList.len, row++) {
			for(var/col = 1, col <= TurfList[row].len, col++) {
				// This nested for loop runs through each element of the two-dimensional array.
				TurfList[row][col] = new/obj/TurfObjects/Water;
				TurfList[row][col].loc = locate(row, col, 1);
			}
		}
		var/IslandGenerationHandler/islandGenerationHandler = new/IslandGenerationHandler;
		islandGenerationHandler.generateSandMap(rand(10,20));
		islandGenerationHandler.patchIslandHoles();
		islandGenerationHandler.waterOverlay();
		islandGenerationHandler.removeSingleSandPatches();
	} // World Class Constructor

} // World Class

mob {
	Login() {
		usr.density = 0
		usr.loc = locate(round(world.maxx / 2), round(world.maxy / 2), 1);
		world << "<b><font color = purple>Welcome to the game!";
	}
	verb {
		Restart_World() {
			world << "Rebooting the world...";
			world.Reboot();
		}
	}
}