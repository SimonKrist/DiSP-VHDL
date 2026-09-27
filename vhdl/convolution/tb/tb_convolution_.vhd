-------------------------------------------------------------------------------
--                                                                      
--                        		CONVOLUTION
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         tb_convolution
--
-- FILENAME:       tb_convolution_.vhd
-- 
-- ARCHITECTURE:   sim
-- 
-- ENGINEER:       Simon Krist
--
-- DATE:           2025-12-14
--
-- VERSION:        0.0.1
--
-------------------------------------------------------------------------------
--                                                                      
-- DESCRIPTION:    This is the entity declaration of the convolution testbench
--                 for the convolution module.
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
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_convolution is
	generic(
		INPUT_WIDTH: integer := 16;
		ACCU_WIDTH: integer := 48
	);
end tb_convolution;