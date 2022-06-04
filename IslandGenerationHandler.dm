var/list/TurfList[][];
var/list/viableFocalPoints = new/list();
proc
	placeTile(var/typePath, var/x, var/y) {
		if(TurfList[x][y] != null) {
			del TurfList[x][y];
		}
		var/obj/TurfObjects/T = new typePath;
		TurfList[x][y] = T;
		T.loc = locate(x,y,1);
		return T;
	}


IslandGenerationHandler {
	var/volcanicFocalPoints;
	proc{
		/*placeFoliage(var/amountOfShrubs) {

			for(var/i = 1, i <= TurfList.len, i++) {
				for(var/j = 1, j <= TurfList[i].len, j++) {
					if(istype(TurfList[i][j], /obj/TurfObjects/Sand)) {

					}
				}
			}
		}*/
		generateSandRing(var/obj/TurfObjects/focalPoint, var/ringRadius, var/minDist, var/probSand,var/sandType) {
			for(var/i = focalPoint.loc.x - ringRadius, i <= focalPoint.loc.x + ringRadius, i++) {
				for(var/j = focalPoint.loc.y - ringRadius, j <= focalPoint.loc.y + ringRadius, j++) {
					if(i >= 1 && i <= world.maxx && j >= 1 && j <= world.maxy) {
						if(get_dist(TurfList[i][j], focalPoint) >= minDist) {
							if(prob(probSand) == 1) {
								placeTile(sandType, i, j);
							}
						}
					}
				}
			}
		}
		patchIslandHoles() {
			for(var/i = 1, i <= TurfList.len, i++) {
				for(var/j = 1, j <= TurfList[i].len, j++) {
					if(istype(TurfList[i][j], /obj/TurfObjects/Water)) {
						if(i+1 <= world.maxx && i-1 > 1 && j-1 > 1 && j+1 <= world.maxy) {
							if(istype(TurfList[i+1][j],/obj/TurfObjects/Sand) && istype(TurfList[i-1][j],/obj/TurfObjects/Sand) && istype(TurfList[i][j+1],/obj/TurfObjects/Sand) && istype(TurfList[i][j-1],/obj/TurfObjects/Sand)) {
								placeTile(/obj/TurfObjects/Sand, i, j);
							}
						}
					}
				}
			}
		}
		removeSingleSandPatches() {
			for(var/i = 1, i <= TurfList.len, i++) {
				for(var/j = 1, j <= TurfList[i].len, j++) {
					if(istype(TurfList[i][j],/obj/TurfObjects/Sand)) {
						if(i+1 <= world.maxx && i-1 > 1 && j-1 > 1 && j+1 <= world.maxy) {
							if(istype(TurfList[i+1][j],/obj/TurfObjects/Water) && istype(TurfList[i-1][j],/obj/TurfObjects/Water) && istype(TurfList[i][j+1],/obj/TurfObjects/Water) && istype(TurfList[i][j-1],/obj/TurfObjects/Water)) {
								placeTile(/obj/TurfObjects/Water, i, j);
							}
						}
					}
				}
			}
		}
		waterOverlay() {
			for(var/i = 1, i <= TurfList.len, i++) {
				for(var/j = 1, j <= TurfList[i].len, j++) {
					if(istype(TurfList[i][j],/obj/TurfObjects/Sand)) {
						if(i+1 <= world.maxx && i-1 > 1 && j-1 > 1 && j+1 <= world.maxy) {
							if(istype(TurfList[i][j-1],/obj/TurfObjects/Water)) {
								TurfList[i][j].overlays += /obj/TurfObjects/Water/Water_Overlays/South_Overlay;
							}
							if(istype(TurfList[i][j+1],/obj/TurfObjects/Water)) {
								TurfList[i][j].overlays += /obj/TurfObjects/Water/Water_Overlays/North_Overlay;
							}
							if(istype(TurfList[i+1][j],/obj/TurfObjects/Water)) {
								TurfList[i][j].overlays += /obj/TurfObjects/Water/Water_Overlays/East_Overlay;
							}
							if(istype(TurfList[i-1][j],/obj/TurfObjects/Water)) {
								TurfList[i][j].overlays += /obj/TurfObjects/Water/Water_Overlays/West_Overlay;
							}
						}
					}
				}
			}
		}
		generateSandMap(var/numberOfFocalPoints) {
			volcanicFocalPoints = numberOfFocalPoints; // This can be changed to numberOfFocalPoints later.
			/*
			var/areaOfFirstRing = (((radiusOfFirstRing)*2 + 1) ** 2) - 1;
			var/areaOfSecondRing = (((radiusOfSecondRing)*2 + 1) ** 2) - areaOfFirstRing - 1;
			var/areaOfThirdRing = (((radiusOfThirdRing)*2 + 1) ** 2) - areaOfSecondRing - areaOfFirstRing - 1;
			*/
			for(var/i = 1, i <= TurfList.len, i++) {
				for(var/j = 1, j <= TurfList[i].len, j++) {
					if(j + TurfList[i][j].radiusOfThirdRing <= world.maxy) {
						if(j - TurfList[i][j].radiusOfThirdRing >= 1) {
							if(i + TurfList[i][j].radiusOfThirdRing <= world.maxx) {
								if(i - TurfList[i][j].radiusOfThirdRing >= 1) {
									viableFocalPoints.Add(TurfList[i][j]);

								}
							}
						}
					}
				}
			}
			world << "[viableFocalPoints.len] number of viable focal points."
			if(viableFocalPoints.len == 0) {
				viableFocalPoints.Add(TurfList[round(world.maxx / 2)][round(world.maxy / 2)]);
				world << "I've had to resort to the middle of the map as the only viable focal point.";
				world << "Are you happy?";
				var/choice = input("Are you?") in list("Yes","I'm never happy");
				if(choice == "Yes") {
					world << "Carry on with your world, then.";
				}
				else {
					del world;
				}
			}
			for(var/i = 1, i <= volcanicFocalPoints, i++) {
				var/obj/TurfObjects/selectedFocalPoint;
				var/randomNumber;
				RETRY{
					if(viableFocalPoints.len == 0) break;
					randomNumber = rand(1,viableFocalPoints.len);
					if(viableFocalPoints[randomNumber] == null) {
						viableFocalPoints.Remove(viableFocalPoints[randomNumber]);
						goto RETRY;
					}
				}
				selectedFocalPoint = viableFocalPoints[randomNumber];
				var/oldRadiusOfFirstRing,oldRadiusOfSecondRing,oldRadiusOfThirdRing;
				oldRadiusOfFirstRing = selectedFocalPoint.radiusOfFirstRing;
				oldRadiusOfSecondRing = selectedFocalPoint.radiusOfSecondRing;
				oldRadiusOfThirdRing = selectedFocalPoint.radiusOfThirdRing;
				selectedFocalPoint = placeTile(/obj/TurfObjects/Sand, selectedFocalPoint.loc.x, selectedFocalPoint.loc.y);
				selectedFocalPoint.radiusOfFirstRing = oldRadiusOfFirstRing;
				selectedFocalPoint.radiusOfSecondRing = oldRadiusOfSecondRing;
				selectedFocalPoint.radiusOfThirdRing = oldRadiusOfThirdRing;
				var/ringOneProb,ringTwoProb,ringThreeProb;
				ringOneProb = rand(90,99);
				ringTwoProb = rand(45,75);
				ringThreeProb = rand(1,35);
				generateSandRing(selectedFocalPoint, selectedFocalPoint.radiusOfFirstRing, 1, ringOneProb,/obj/TurfObjects/Sand);
				generateSandRing(selectedFocalPoint, selectedFocalPoint.radiusOfSecondRing, selectedFocalPoint.radiusOfFirstRing + 1, ringTwoProb,/obj/TurfObjects/Sand);
				generateSandRing(selectedFocalPoint, selectedFocalPoint.radiusOfThirdRing, selectedFocalPoint.radiusOfSecondRing + 1, ringThreeProb,/obj/TurfObjects/Sand);
			}
		}
	}
} // Island Generation Handler Class