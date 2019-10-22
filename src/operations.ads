with MaintenanceRecord; use MaintenanceRecord;
with Ada.Text_IO; use Ada.Text_IO;
package Operations is

   TieTop, StarTop, lower, upper, numRejects, ET : Integer;
   TiesRepaired, StarsRepaired : Integer;
   
   type vector is array(Integer range <>) of maintenance_record;
   
   procedure reportRejected(record_item : maintenance_record);
   procedure push(stack : in out vector; record_item : in out maintenance_record);
   procedure popTie(stack : in out vector; outFile : in out File_Type);
   procedure popStar(stack : in out vector; outFile : in out File_Type);
   function NumberNewArrivals return Integer;
   function timeToRepair(vehicle : vehicle_type) return Integer;
   function arrrivalForRepair return vehicle_type;

end Operations;
