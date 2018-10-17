using GL;
using GLFW;
using cglm;
using System;
#if (__EMSCRIPTEN__)
using Emscripten;
#endif

public struct Vector3
{
    public float x;
    public float y;
    public float z;
    public Vector3(float x=0, float y=0, float z=0)
    {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}
/**
 * Camera class
 */
 public class Camera : Object
 {

    // Defines several possible options for camera movement. Used as abstraction to stay away from window-system specific input methods
    public enum Movement {
        FORWARD,
        BACKWARD,
        LEFT,
        RIGHT
    }

    // Default camera values
    public const float YAW         = -90f;
    public const float PITCH       =  0f;
    public const float SPEED       =  2.5f;
    public const float SENSITIVITY =  0.1f;
    public const float ZOOM        =  45f;

    // Camera Attributes
    Vec3 Position;
    Vec3 Front;
    Vec3 Up;
    Vec3 Right;
    Vec3 WorldUp;
    Vec3 scaled = new Vec3();
    Vec3 front = new Vec3();
    Vec3 cross = new Vec3();
    // Euler Angles
    float Yaw;
    float Pitch;
    // Camera options
    float MovementSpeed;
    float MouseSensitivity;
    float Zoom;

    // Constructor with vectors
    public Camera(  float[] position = { 0f, 0f, 0f }, 
                    float[] up = { 0f, 1f, 0f} , 
                    float yaw = YAW, 
                    float pitch = PITCH) 
    {
                        
        Front = new Vec3(0f, 0f, -1f);
        MovementSpeed = SPEED;
        MouseSensitivity = SENSITIVITY;
        Zoom = ZOOM;
        Position = new Vec3();
        glm_vec_copyf(position, Position);
        // Position = position;
        WorldUp = new Vec3();
        glm_vec_copyf(up, WorldUp);
        // WorldUp = up;
        Yaw = yaw;
        Pitch = pitch;
        updateCameraVectors();

    }        

    public Mat4 GetViewMatrix()
    {
        // return LookAt(Position, Vec3.Add(Position, Front), Up);

        var result = new Mat4();
        var center = new Vec3();
        glm_vec_add(Position, Front, center);
        glm_lookat(Position, center, Up, result);
        return result;

    }

    // Processes input received from any keyboard-like input system. Accepts input parameter in the form of camera defined ENUM (to abstract it from windowing systems)
    public void ProcessKeyboard(Movement direction, float deltaTime)
    {
        float velocity = MovementSpeed * deltaTime;
        switch (direction)
        {
            case Movement.FORWARD:
                // Position += Front * velocity;
                glm_vec_scale(Front, velocity, scaled);
                glm_vec_add(Position, scaled, Position);
                break;

            case Movement.BACKWARD:
                // Position -= Front * velocity;
                glm_vec_scale(Front, velocity, scaled);
                glm_vec_sub(Position, scaled, Position);
                break;

            case Movement.LEFT:
                // Position -= Right * velocity;
                glm_vec_scale(Right, velocity, scaled);
                glm_vec_sub(Position, scaled, Position);
                break;

            case Movement.RIGHT:
                // Position += Right * velocity;
                glm_vec_scale(Right, velocity, scaled);
                glm_vec_add(Position, scaled, Position);
                break;

            default:
                assert_not_reached();

        }
    }


    // Processes input received from a mouse input system. Expects the offset value in both the x and y direction.
    public void ProcessMouseMovement(float xoffset, float yoffset, GLboolean constrainPitch = GL_TRUE)
    {
        xoffset *= MouseSensitivity;
        yoffset *= MouseSensitivity;

        Yaw   += xoffset;
        Pitch += yoffset;

        // Make sure that when pitch is out of bounds, screen doesn't get flipped
        if (constrainPitch == GL_TRUE)
        {
            if (Pitch > 89f)
                Pitch = 89f;
            if (Pitch < -89f)
                Pitch = -89f;
        }

        // Update Front, Right and Up Vectors using the updated Euler angles
        updateCameraVectors();
    }

    // Processes input received from a mouse scroll-wheel event. Only requires input on the vertical wheel-axis
    public void ProcessMouseScroll(float yoffset)
    {
        if (Zoom >= 1f && Zoom <= 45f)
            Zoom -= yoffset;
        if (Zoom <= 1f)
            Zoom = 1f;
        if (Zoom >= 45f)
            Zoom = 45f;
    }

    // Calculates the front vector from the Camera's (updated) Euler Angles
    void updateCameraVectors()
    {
        // Calculate the new Front vector
        front.x = Math.cosf(glm_rad(Yaw)) * Math.cosf(glm_rad(Pitch));
        front.y = Math.sinf(glm_rad(Pitch));
        front.z = Math.sinf(glm_rad(Yaw)) * Math.cosf(glm_rad(Pitch));

        glm_normalize_to(front, Front);
        // Also re-calculate the Right and Up vector

        glm_cross(Front, WorldUp, cross);
        glm_normalize_to(cross, Right);

        glm_cross(Right, Front, cross);
        glm_normalize_to(cross, Up);

    }
}