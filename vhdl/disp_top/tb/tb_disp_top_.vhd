-------------------------------------------------------------------------------
--                                                                      
--                        		DISP_TOP
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         tb_disp_top
--
-- FILENAME:       tb_disp_top_.vhd
-- 
-- ARCHITECTURE:   sim
-- 
-- ENGINEER:       Simon Krist
--
-- DATE:           2026-01-06
--
-- VERSION:        0.0.1
--
-------------------------------------------------------------------------------
--                                                                      
-- DESCRIPTION:    This is the entity declaration for the simulation
--					of the disp_top module.
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

entity tb_disp_top is
	generic(
		INPUT_WIDTH: integer := 16
	);
end tb_disp_top;