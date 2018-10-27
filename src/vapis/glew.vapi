[CCode (cprefix = "GL", gir_namespace = "GLEW", gir_version = "1.0", lower_case_cprefix = "gl_", cheader_filename = "GL/glew.h")]
namespace GLEW 
{
	//[CCode (cname = "glewInit")]
	[CCode (cname = "glewInit")]
	public bool glewInit();

	[CCode (cname = "glewExperimental")]
	public static bool glewExperimental;
}