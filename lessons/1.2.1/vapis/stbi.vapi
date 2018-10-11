/* emscripten Vala Bindings
 * Copyright (c) 2018 Bruce Davidspn <darkoverlordofdata@gmail.com>
 * 
 * ***********************************************************************
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ***********************************************************************
 * 
 */
[CCode (lower_case_cprefix ="", cheader_filename="stbi/stbi_image.h")]
namespace Stbi
{
    
    [SimpleType]
    public struct stbi_uc: uchar {}

    public stbi_uc *stbi_load (string filename, int *x, int *y, int *channels_in_file, int desired_channels);
    public void stbi_image_free(void* retval_from_stbi_load);

}