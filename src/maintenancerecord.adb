package body MaintenanceRecord is

   -- procedure for reporting the repaired vehicles

   procedure report(record_item : maintenance_record; outFile : in out File_Type) is
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

end MaintenanceRecord;
