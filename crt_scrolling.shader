shader_type canvas_item;

// https://pastebin.com/LtwNM3da
 
uniform float scan_line_count : hint_range(0, 1080) = 160.0;
uniform bool scrolling = false;
uniform float scroll_speed : hint_range(0.1, 99.9) = 50.0;
 
vec2 uv_curve(vec2 uv) {
    uv = (uv - 0.5) * 2.0;
    uv.x *= 1.0 + pow(abs(uv.y) / 4.5, 2.0);
    uv.y *= 1.0 + pow(abs(uv.x) / 4.5, 2.0);
    uv /= 1.2;
    uv = (uv / 2.0) + 0.5;
    return uv;
}
 
void fragment() {
    float PI = 3.14159;
    float r = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x*0.0), 0.0).r;
    float g = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x*1.5), 0.0).g;
    float b = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x*-1.5), 0.0).b;
   
    float s = 0.0;
   
    if(scrolling) {
        s = sin((uv_curve(SCREEN_UV).y + TIME/abs(100.0 - scroll_speed)) * scan_line_count * PI * 2.0);
    } else {
        s = sin(uv_curve(SCREEN_UV).y * scan_line_count * PI * 2.0);
    }
    s = (s * 0.5 + 0.5) * 0.9 + 0.1;
    vec4 scan_line = vec4(vec3(pow(s, 0.25)), 1.0);
   
    COLOR = vec4(r, g, b, 1.0) * scan_line;
}
