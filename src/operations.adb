with randfloat; use randfloat;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
package body Operations is

    -- retrieve the number of new arrivals

   function NumberNewArrivals return Integer is
      randNum: float;
   begin
      randNum := next_float;  -- 0.0 <= randNumm <= 1.0.
      if randNum <= 0.25 then
         return 1;
      elsif randNum <= 0.5 then
         return 2;
      elsif
         randNum <= 0.75 then
         return 3;
      else
         return 4;
      end if;
    end NumberNewArrivals;

   -- procedeure to report a rejected vehicle

   procedure reportRejected(record_item : maintenance_record) is
   begin
      New_Line(outFile);
      Put(outfile, "Occupancy full. Sending vehicle to the Dagaba System...");
      Put(outfile, "Vehicle rejected : " & To_String(record_item.vehile_name));
      Put(outFile, "Rejected Time" & Integer'Image(ET));
   end reportRejected;

   -- procedure for pushing a vehicle into it's appropriate stack

   procedure push(stack : in out vector; record_item : in out maintenance_record) is
   begin
      case record_item.vehicleType is

         when Tie_Fighter =>
            if TieTop < StarTop - 1 then  -- there is space to push a Tie Fighter
               TieTop := TieTop + 1;
               stack(TieTop) := record_item;

               New_Line(outFile);
               Put(outFile, "pushed : " & To_String(record_item.vehile_name));
            else
               record_item.serviced := rejected;
               numRejects := numRejects + 1;
               reportRejected(record_item);
            end if;

         when Star_Destroyer =>
            if StarTop > TieTop + 1 then  -- there is space to push a Star Destroyer
               StarTop := StarTop - 1;
               stack(StarTop) := record_item;

               New_Line;
               Put(outFile, "pushed : " & To_String(record_item.vehile_name));
            else
               record_item.serviced := rejected;
               numRejects := numRejects + 1;
               reportRejected(record_item);
            end if;

      end case;
   end push;

   -- Procedure to pop Tie Fighters from the appropriate stack

   procedure popTie(stack : in out vector; outFile : in out File_Type) is
      item : maintenance_record;
   begin
      if TieTop = 0 then
         Put_Line("underflow");
      else
         item := stack(TieTop);
         TieTop := TieTop - 1;
         item.serviced := serviced;
         item.start_time := ET;
         ET := ET + item.repair_time;

         delay Standard.Duration(item.repair_time);

         item.finish_time := ET;
         ET := ET + 2;
         report(item, outFile);
         TiesRepaired := TiesRepaired + 1;
      end if;
   end popTie;

   -- Procedure to pop Star Destroyers from the appropriate stack

   procedure popStar(stack : in out vector; outFile : in out File_Type) is
      item : maintenance_record;
   begin
       if StarTop = stack'Size + 1 then
         Put_Line("underflow");
      else
         item := stack(StarTop);
         StarTop := StarTop + 1;
         item.serviced := serviced;
         item.start_time := ET;
         ET := ET + item.repair_time;

         delay Standard.Duration(item.repair_time);

         item.finish_time := ET;
         ET := ET + 2;
         report(item, outFile);

         StarsRepaired := StarsRepaired + 1;
      end if;
   end popStar;

   -- function that returns a uniformly distributed repair time for Tie Fighters

   function timeToRepair(vehicle : vehicle_type) return Integer is
      randNum : Float;

   begin
      randNum := next_float;
      case vehicle is
         when Tie_Fighter =>
            if randNum <= 0.3333 then
               return 2;
            elsif randNum <= 0.6666 then
               return 4;
            else
               return 6;
            end if;

         when Star_Destroyer =>
            if randNum <= 0.25 then
               return 3;
            elsif randNum <= 0.5 then
               return 4;
            elsif randNum <= 0.75 then
               return 7;
            else
               return 10;
            end if;
      end case;

   end timeToRepair;

   -- function that returns the type of vehicle that is arriving

   function arrrivalForRepair return vehicle_type is
      randNum : Float;

   begin
      randNum := next_float;
      if randNum <= 0.75 then
         return Tie_Fighter;
      else
         return
           Star_Destroyer;
      end if;

   end arrrivalForRepair;

end Operations;
