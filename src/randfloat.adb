
package body randfloat is

   x : Integer := 977; -- seed
   
   function next_float return Float is
      n : Integer;
      
   begin

      x := x * 29 + 37;
      n := x;
      x := x mod 1001;
      return Float(n mod 101) / 100.0;
   end next_float;

end randfloat;
