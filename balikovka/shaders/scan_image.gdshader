shader_type canvas_item;

uniform vec4 silhouette_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // default červená

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float alpha = tex.a;

	COLOR = vec4(silhouette_color.rgb, silhouette_color.a * alpha);
}
