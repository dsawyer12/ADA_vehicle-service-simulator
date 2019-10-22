with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
package MaintenanceRecord is
   
   outFile : File_Type;

   type vehicle_type is (Tie_Fighter, Star_Destroyer);
   type maintenanced is (serviced, rejected);

   type maintenance_record is record
      vehicleType : vehicle_type;
      vehile_name : Unbounded_String;
      repair_time, start_time, finish_time : Integer;
      serviced : maintenanced;
      
   end record;
   
   procedure report(record_item : maintenance_record; outFile : in out File_Type);

end MaintenanceRecord;
