using GL;
using GLFW;
using glm;
using System;
#if (__EMSCRIPTEN__)
using Emscripten;
#endif

/**
 * Camera class
 */
 public class Camera : Object
 {

    // Defines several possible options for camera movement. Used as abstraction to stay away from window-system specific input methods
    public enum CameraMovement {
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
    // float[] Position;
    float* Position;
    float[] Front;
    float[] Up;
    float[] Right;
    float[] WorldUp;
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
                        
        Front =  { 0f, 0f, -1f };
        MovementSpeed = SPEED;
        MouseSensitivity = SENSITIVITY;
        Zoom = ZOOM;
        Position = position;
        WorldUp = up;
        Yaw = yaw;
        Pitch = pitch;
        updateCameraVectors();
    }        

    public float[,] GetViewMatrix()
    {
        return LookAt(Position, Vec3.Add(Position, Front), Up);
    }

    // Processes input received from any keyboard-like input system. Accepts input parameter in the form of camera defined ENUM (to abstract it from windowing systems)
    public void ProcessKeyboard(CameraMovement direction, float deltaTime)
    {
        float velocity = MovementSpeed * deltaTime;
        switch (direction)
        {
            case CameraMovement.FORWARD:
                Position = Vec3.Add(Position, Vec3.Scale(Front, velocity));
                break;

            case CameraMovement.BACKWARD:
                Position = Vec3.Sub(Position, Vec3.Scale(Front, velocity));
                break;

            case CameraMovement.LEFT:
                Position = Vec3.Sub(Position, Vec3.Scale(Right, velocity));
                break;

            case CameraMovement.RIGHT:
                Position = Vec3.Add(Position, Vec3.Scale(Right, velocity));
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
        float[] front = {
            Math.cosf(Rad(Yaw)) * Math.cosf(Rad(Pitch)),
            Math.sinf(Rad(Pitch)),
            Math.sinf(Rad(Yaw)) * Math.cosf(Rad(Pitch))
        };
        Front = Normalize(front);
        // Also re-calculate the Right and Up vector
        Right = Normalize(Cross(Front, WorldUp));  // Normalize the vectors, because their length gets closer to 0 the more you look up or down which results in slower movement.
        Up    = Normalize(Cross(Right, Front));
    }
}