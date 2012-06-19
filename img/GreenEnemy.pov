#include "colors.inc"
#include "shapes.inc"
#include "textures.inc"
#include "Woods.inc"
#include "stones.inc"
#include "glass.inc"
#include "metals.inc"


background{ rgbt<0, 1.0, 0> }

camera
{
    location <0, 0, -10>
    look_at <0, 0, 0>    
}

light_source{ <1, 1, -6> White  }



object
{
    difference
    {
        object
        {
            Cube
            
            rotate<0, 0, 60>
        } 
        
        object
        {
            Cube
            
            scale<1, 10, 1.1>
            rotate<0, 0, 15>
            translate<1, 0, 0> 
            
            material{M_Green_Glass} 
            finish{ ambient 0.2 phong 0.3}
        }
   }
    
   material{M_Green_Glass} 
   //finish{ phong 0.3}
   
   scale<0.8, 1, 1>
   scale 0.6
}