shader_type canvas_item;


uniform vec2 direction; // x and y
uniform float speed; //speed
uniform sampler2D noise_texture: repeat_enable;
varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec2 move = direction * TIME * speed; //create offset
	COLOR = texture(noise_texture, UV + move) * modulate;
	}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
