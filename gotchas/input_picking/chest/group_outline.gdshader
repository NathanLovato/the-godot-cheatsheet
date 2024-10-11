// This program draws an outline around sprites grouped under a CanvasGroup node.
shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec4 line_color : source_color = vec4(0, 0, 0, 1);
uniform float line_thickness = 4.0;
uniform vec2 viewport_scale = vec2(1.0);


void vertex() {
	VERTEX += (UV * 2.0 - 1.0) * line_thickness;
}


void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 size = (SCREEN_PIXEL_SIZE * line_thickness) * viewport_scale;


    float outline = texture(screen_texture, uv + vec2(-size.x, 0)).a;
    outline += texture(screen_texture, uv + vec2(0, size.y)).a;
    outline += texture(screen_texture, uv + vec2(size.x, 0)).a;
    outline += texture(screen_texture, uv + vec2(0, -size.y)).a;
    outline += texture(screen_texture, uv + vec2(-size.x * 0.866, size.y * 0.5)).a;
    outline += texture(screen_texture, uv + vec2(-size.x * 0.5, size.y * 0.866)).a;
    outline += texture(screen_texture, uv + vec2(size.x * 0.866, size.y * 0.5)).a;
    outline += texture(screen_texture, uv + vec2(size.x * 0.5, size.y * 0.866)).a;
    outline += texture(screen_texture, uv + vec2(-size.x * 0.866, -size.y * 0.5)).a;
    outline += texture(screen_texture, uv + vec2(-size.x * 0.5, -size.y * 0.866)).a;
    outline += texture(screen_texture, uv + vec2(size.x * 0.866, -size.y * 0.5)).a;
    outline += texture(screen_texture, uv + vec2(size.x * 0.5, -size.y * 0.866)).a;
    outline = min(outline, 1.0);

	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	COLOR = mix(screen_color, line_color, outline - screen_color.a);

}
