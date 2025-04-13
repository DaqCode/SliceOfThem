shader_type canvas_item;

uniform float brightness = -39.0;
uniform float contrast = 5.0;
uniform float gamma = 1.5;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Convert to grayscale (perceived luminance)
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

    // Apply brightness adjustment (-39 mapped to -0.1529 range)
    gray += brightness / 255.0;

    // Apply contrast (around 0.5 center)
    gray = ((gray - 0.5) * contrast) + 0.5;

    // Apply gamma correction
    gray = pow(gray, 1.0 / gamma);

    // Clamp to 0.0 - 1.0 so you don't break time and space
    gray = clamp(gray, 0.0, 1.0);

    COLOR = vec4(vec3(gray), tex_color.a);
}
