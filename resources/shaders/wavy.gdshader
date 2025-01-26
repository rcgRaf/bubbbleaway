shader_type canvas_item;

uniform float speed = 2.0;
uniform float frequency_y = 5.0;
uniform float frequency_x = 5.0;
uniform float amplitude_y = 50.0;
uniform float amplitude_x = 25.0;
uniform float inclination = 50.0;
uniform float rotation_angle = 0.0; // Angle in degrees to be converted to radians.

void vertex() {
// Convert rotation angle from degrees to radians.
float rad = radians(rotation_angle);
// Create a rotation matrix.
mat2 rot = mat2(vec2(cos(rad), -sin(rad)), vec2(sin(rad), cos(rad)));

// Apply rotation to the vertex position.
vec2 rotated_vertex = rot * VERTEX.xy;

// Apply the wave effect.
rotated_vertex.y += sin((UV.x - TIME * speed) * frequency_y) * amplitude_y * (UV.y + 1.0);
rotated_vertex.x += cos((UV.y - TIME * speed) * frequency_x) * amplitude_x * (UV.x + 1.0);
rotated_vertex.x -= UV.y * inclination;
rotated_vertex.y -= UV.x * inclination;

// Apply the inverse rotation to the vertex position to get the final position.
VERTEX.xy = rot * rotated_vertex;
}