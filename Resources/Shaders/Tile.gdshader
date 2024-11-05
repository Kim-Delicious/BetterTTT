shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D tex_frg_1;
uniform sampler2D tex_frg_2;
uniform sampler2D tex_frg_3;
instance uniform vec4 ColorAddition : source_color = vec4(0.000000, 0.000000, 0.000000, 1.000000);
instance uniform vec4 ColorSubtraction : source_color = vec4(0.000000, 0.000000, 0.000000, 1.000000);



void fragment() {
// Input:8
	vec2 n_out8p0 = UV;

	vec4 tex_1 = texture(tex_frg_1, n_out8p0);
	vec4 tex_2 = texture(tex_frg_2, n_out8p0);
	vec4 tex_3 = texture(tex_frg_3, n_out8p0);

// Texture2D:2
	vec4 n_out2p0 = tex_1 + tex_2 + tex_3;


// ColorConstant:9
	vec4 n_out9p0 = vec4(0.150000, 0.150000, 0.150000, 1.000000);


	vec3 n_out4p0;
// ColorOp:4
	{
		float base = vec3(n_out2p0.xyz).x;
		float blend = vec3(n_out9p0.xyz).x;
		if (base < 0.5) {
			n_out4p0.x = 2.0 * base * blend;
		} else {
			n_out4p0.x = 1.0 - 2.0 * (1.0 - blend) * (1.0 - base);
		}
	}
	{
		float base = vec3(n_out2p0.xyz).y;
		float blend = vec3(n_out9p0.xyz).y;
		if (base < 0.5) {
			n_out4p0.y = 2.0 * base * blend;
		} else {
			n_out4p0.y = 1.0 - 2.0 * (1.0 - blend) * (1.0 - base);
		}
	}
	{
		float base = vec3(n_out2p0.xyz).z;
		float blend = vec3(n_out9p0.xyz).z;
		if (base < 0.5) {
			n_out4p0.z = 2.0 * base * blend;
		} else {
			n_out4p0.z = 1.0 - 2.0 * (1.0 - blend) * (1.0 - base);
		}
	}


// ColorParameter:7
	vec4 n_out7p0 = ColorAddition;


// Input:26
	vec3 n_out26p0 = NODE_POSITION_WORLD;
	float n_out26p3 = n_out26p0.b;


// FloatFunc:27
	float n_out27p0 = abs(n_out26p3);


// FloatOp:28
	float n_in28p1 = 7.00000;
	float n_out28p0 = n_out27p0 / n_in28p1;


// FloatFunc:36
	float n_out36p0 = sin(n_out28p0);


// FloatFunc:38
	float n_out38p0 = abs(n_out36p0);


// FloatOp:39
	float n_in39p1 = -1.00000;
	float n_out39p0 = n_out38p0 + n_in39p1;


// FloatOp:32
	float n_in32p0 = 0.03000;
	float n_out32p0 = n_in32p0 * n_out39p0;


// FloatConstant:24
	float n_out24p0 = 3.000000;


// Input:13
	vec3 n_out13p0 = NODE_POSITION_WORLD;
	float n_out13p1 = n_out13p0.r;


// FloatFunc:21
	float n_out21p0 = abs(n_out13p1);


// FloatOp:20
	float n_in20p1 = 7.00000;
	float n_out20p0 = n_out21p0 / n_in20p1;


	int n_out23p0;
// Expression:23
	n_out23p0 = 0;
	{
		
		n_out23p0 = int(n_out24p0) % int(n_out20p0);
	}


// FloatFunc:41
	float n_out41p0 = abs(float(n_out23p0));


// FloatOp:37
	float n_out37p0 = n_out32p0 * n_out41p0;


// VectorCompose:33
	float n_in33p3 = 0.00000;
	vec4 n_out33p0 = vec4(n_out37p0, n_out37p0, n_out37p0, n_in33p3);


// VectorOp:34
	vec4 n_out34p0 = n_out7p0 - n_out33p0;


// VectorOp:10
	vec4 n_out10p0 = vec4(n_out4p0, 0.0) + n_out34p0;


// FloatFunc:35
	float n_out35p0 = sin(n_out20p0);


// FloatOp:25
	float n_in25p0 = 0.08000;
	float n_out25p0 = n_in25p0 * n_out35p0;


// VectorCompose:19
	float n_in19p3 = 0.00000;
	vec4 n_out19p0 = vec4(n_out25p0, n_out25p0, n_out25p0, n_in19p3);


// ColorParameter:11
	vec4 n_out11p0 = ColorSubtraction;


// VectorOp:14
	vec4 n_out14p0 = n_out19p0 - n_out11p0;


// VectorOp:12
	vec4 n_out12p0 = n_out10p0 - n_out14p0;


// Output:0
	ALBEDO = vec3(n_out12p0.xyz);


}
