#include "colors.inc"
#include "shapes.inc"
#include "textures.inc"
#include "Woods.inc"
#include "stones.inc"
#include "glass.inc"
#include "metals.inc"


background{ rgbt<0.0, 1.0, 0.0, 0.0> }

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
        
        object
        {
            Sphere
                               
            scale 0.6
            translate<0, 0, -0.5>
            material { texture { pigment { color Clear } finish { F_Glass1 } } interior { I_Glass1 fade_color Col_Azurite_04 } }
        }
   }
    
   material{M_Green_Glass}     
   
   scale<0.8, 1, 1>
   scale 1.4
}