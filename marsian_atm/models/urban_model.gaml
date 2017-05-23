/**
* Name: surfacemodel
* Author: nati
* Description: This model shows robot agents randomly situated on a limited size martian surface
* Tags: Tag1, Tag2, TagN
*/

model surfacemodel

/* Insert your model definition here */

global{
	
	
	int num_drones <- 10;
	int num_rovers <- 10;
	file road_shpfile <- file("../includes/road.shp");
	file building_shpfile <-file("../includes/building.shp");
	geometry shape <- envelope(road_shpfile);
	graph road_network;
	
	init{
		create drones number:num_drones;
		create rovers number:num_rovers;
		create building from:building_shpfile;
		create roads from:road_shpfile;
		road_network <-as_edge_graph(roads);
	}
}

species drones skills:[moving]{
	
	float altitude <- 10#m + rnd(10) #m;
	reflex moving3D{
		do wander;
	}
	
	aspect cube3D {
		draw cube(15) color: #green;
		
	}
}
species rovers skills:[driving]{
	
	bool is_collision <- flip(0.5);
	int collision_range <- 10;
	
	reflex driving{
		do wander on:road_network;
	}
	reflex avoid when: !empty(rovers at_distance collision_range){
		ask rovers at_distance collision_range{
			if(self.is_collision){
				do wander on:road_network;
			}
		}
	}
		
	aspect cube3D{
		draw cube(15) color:#red;
	}

}
 species roads{
 	geometry display_shape <- shape + 2.0;
	aspect geom {
		draw display_shape color: #black depth: 3.0;
	}
 }
 species building{
 	float height <- 40#m + rnd(10) #m;
 	
 	aspect geom {
		draw shape color:#black depth:height;
	}
 }
experiment main_exp type:gui{
	
	parameter "Number of Drones" var: num_drones;
	parameter "Number of Rovers" var: num_rovers; 
	
	output{
		display map_3D type: opengl{
			image "../includes/soil.jpg";
			species drones aspect:cube3D;
			species rovers aspect:cube3D;
			species roads aspect:geom;
			species building aspect:geom transparency:0.2;
			
		}
	}
}