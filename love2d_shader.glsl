extern float TIME = 0.0;

const vec2 SCREEN_PIXEL_SIZE = vec2(0.001, 0.001);

// https://pastebin.com/LtwNM3da
 
float scan_line_count = 50.0; //  : hint_range(0, 1080)
bool scrolling = true;
float scroll_speed = 10.0; //  : hint_range(0.1, 99.9)
 
vec2 uv_curve(vec2 uv) {
    uv = (uv - 0.5) * 2.0;
    uv.x *= 1.0 + pow(abs(uv.y) / 8.0, 2.0);
    uv.y *= 1.0 + pow(abs(uv.x) / 4.5, 2.0);
    uv /= 1.2;
    uv = (uv / 2.0) + 0.5;
    return uv;
}
 
vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    float PI = 3.14159;
    float r = Texel(tex, uv_curve(texture_coords) + vec2(SCREEN_PIXEL_SIZE.x*0.0, 0.0)).r;
    float g = Texel(tex, uv_curve(texture_coords) + vec2(SCREEN_PIXEL_SIZE.x*1.0, 0.0)).g;
    float b = Texel(tex, uv_curve(texture_coords) + vec2(SCREEN_PIXEL_SIZE.x*-1.0, 0.0)).b;
   
    float s = 0.0;
   
    if(scrolling) {
        s = sin((uv_curve(texture_coords).y + TIME/abs(100.0 - scroll_speed)) * scan_line_count * PI * 2.0);
    } else {
        s = sin(uv_curve(texture_coords).y * scan_line_count * PI * 2.0);
    }
    s = (s * 0.5 + 0.5) * 0.9 + 0.1;
    vec4 scan_line = vec4(vec3(pow(s, 0.25)), 1.0);
   
    return vec4(r, g, b, 1.0) * scan_line;
}