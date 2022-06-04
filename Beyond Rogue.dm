/*
How To Handle Procedural Generation --
Start by populating the world with water. Store the water objects in a global list,
and have the indices of the list correspond to the location of the water objects.

Hot spot point for volcano activity.
Concentric rings of probability space, with diminishing probability of sand.


Now for each tile in the first ring, make a probability of 95 percent sand.
Second ring is 75 percent.
Third ring is 45 percent.
Finally, spruce up the holes.

*/

/* I'm at square [i][j]. Check outer square radius to the right, to the left, up, and down.
   Do these spaces fall within the bounds of the map?
*/