mob {
	Foliage {
		Shrubbery {
			icon = 'shrubbery.dmi';
			density = 1;
		}
	}
}
obj {

	TurfObjects {
		var/radiusOfFirstRing,radiusOfSecondRing,radiusOfThirdRing;
		New() {
			..()
			radiusOfFirstRing = rand(5,6);
			radiusOfSecondRing = rand(4,5) + radiusOfFirstRing;
			radiusOfThirdRing = rand(3,4) + radiusOfSecondRing;
		}
		Grass {

			icon = 'grass.dmi';

		}

		Sand {

			icon = 'sand.dmi';
			Red{
				icon_state = "red";
			}
			Green{
				icon_state = "green";
			}
			Blue{
				icon_state = "blue";
			}

		}

		Water {

			icon = 'water.dmi';
			density = 1;

			Water_Overlays {
				icon = 'water_overlay.dmi'
				South_Overlay {
					icon_state = "south";
				}
				North_Overlay {
					icon_state = "north";
				}
				East_Overlay{
					icon_state = "east";
				}
				West_Overlay{
					icon_state = "west";
				}

			}
		}

	} // TurfObjects

} // Obj Class