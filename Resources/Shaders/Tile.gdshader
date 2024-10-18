shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment(Texture2D albedo) {
	// Called for every pixel the material is visible on.
	METALLIC = 0.0;
  	ROUGHNESS = 0.01;
	ALBEDO = vec3(0.1, 0.3, .05);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
