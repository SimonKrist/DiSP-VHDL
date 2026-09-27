-------------------------------------------------------------------------------
--                                                                      
--                        		DISP_TOP
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         disp_top
--
-- FILENAME:       disp_top_struct_cfg.vhd
-- 
-- ARCHITECTURE:   struct
-- 
-- ENGINEER:       Simon Krist
--
-- DATE:           2026-01-06
--
-- VERSION:        0.0.1
--
-------------------------------------------------------------------------------
--                                                                      
-- DESCRIPTION:    This is the configuration of the disp_top module.
--
--
-------------------------------------------------------------------------------
--
-- REFERENCES:     (none)
--
-------------------------------------------------------------------------------
--                                                                      
-- PACKAGES:       std_logic_1164 (IEEE library)
--
-------------------------------------------------------------------------------
--                                                                      
-- CHANGES:        (none)
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

configuration disp_top_struct_cfg of disp_top is
  for struct        -- architecture struct is used for entity disp_top
  end for;
end disp_top_struct_cfg;