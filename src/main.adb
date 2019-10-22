with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with randfloat; use randfloat;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Main is

   outFile : File_Type;
   TieTop, StarTop, lower, upper, numRejects, ET : Integer;
   TiesRepaired, StarsRepaired : Integer;

   subtype LastCharOfName is Character range 'A'..'Z';
   TieName, StarName : Character := 'A';

   type vehicle_type is (Tie_Fighter, Star_Destroyer);
   type maintenanced is (serviced, rejected);

   type maintenanceRecord is record
      vehicleType : vehicle_type;
      vehile_name : Unbounded_String;
      repair_time, start_time, finish_time : Integer;
      serviced : maintenanced;
   end record;

   type vector is array(Integer range <>) of maintenanceRecord;

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

   -- procedure for reporting the repaired vehicles

   procedure report(record_item : maintenanceRecord; outFile : in out File_Type) is
   begin
      New_Line(outFile);
      Put_Line(outFile, "Vehicle Type : " & vehicle_type'Image(record_item.vehicleType));
      Put_Line(outFile, "Vehicle Name : " & To_String(record_item.vehile_name));
      Put_Line(outFile, "Time to repair : " & Integer'Image(record_item.repair_time));
      Put_Line(outFile, "Start time : " & Integer'Image(record_item.start_time));
      Put_Line(outFile, "Finish time : " & Integer'Image(record_item.finish_time));
      Put_Line(outFile, "vehicle status : " & maintenanced'Image(record_item.serviced));
      New_Line(outFile);
   end report;

   -- procedeure to report a rejected vehicle

   procedure reportRejected(record_item : maintenanceRecord) is
   begin
      New_Line(outFile);
      Put(outfile, "Occupancy full. Sending vehicle to the Dagaba System...");
      Put(outfile, "Vehicle rejected : " & To_String(record_item.vehile_name));
      Put(outFile, "Rejected Time" & Integer'Image(ET));
   end reportRejected;

   -- procedure for pushing a vehicle into it's appropriate stack

   procedure push(stack : in out vector; record_item : in out maintenanceRecord) is
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

               New_Line(outFile);
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
      item : maintenanceRecord;
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
      item : maintenanceRecord;
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

begin
   put("Enter the lower bounds : ");
   get(lower);
   put("Enter the upper bounds : ");
   get(upper);

   Create(outFile, Out_File, "out_file.text");

   declare
      stack : vector(lower..upper);
      record_item : maintenanceRecord;

   begin
      TieTop := 0;
      numRejects := 0;
      TiesRepaired := 0;
      StarsRepaired := 0;
      StarTop := stack'Length + 1;

      while (numRejects < 5) loop

         for k in 1..NumberNewArrivals loop
            record_item.vehicleType := arrrivalForRepair;
            record_item.repair_time := timeToRepair(record_item.vehicleType);

            if record_item.vehicleType = Tie_Fighter then
               record_item.vehile_name := To_Unbounded_String("Tie" & TieName'Image);
               if TieName = 'Z' then
                  TieName := 'A';
               else
                  TieName := LastCharOfName'Succ(TieName);
               end if;

            else
               record_item.vehile_name := To_Unbounded_String("Star" & StarName'Image);
               if StarName = 'Z' then
                  StarName := 'A';
               else
                  StarName := LastCharOfName'Succ(StarName);
               end if;
            end if;

            push(stack, record_item);

         end loop;

         -- pop a Star Destroyer first if available

         if StarTop < stack'Length + 1 then
            popStar(stack, outFile);

         -- else, pop a Tie fighter if one is available

         else
            if TieTop > 0 then
               popTie(stack, outFile);
            end if;
         end if;

--           delay 2.0;

      end loop;

   end;
  Close(outFile);

end Main;
