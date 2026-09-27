-------------------------------------------------------------------------------
--                                                                      
--                        		CONVOLUTION
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         convolution
--
-- FILENAME:       convolution_.vhd
-- 
-- ARCHITECTURE:   rtl
-- 
-- ENGINEER:       Simon Krist
--
-- DATE:           2025-12-14
--
-- VERSION:        0.0.1
--
-------------------------------------------------------------------------------
--                                                                      
-- DESCRIPTION:    This is the entity declaration of the convolution module.
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

entity convolution is

	generic(
		INPUT_WIDTH: integer := 16;
		ACCU_WIDTH: integer := 48
	);

	port(reset_i		: in std_logic; -- asynchronous reset
		clk_i			: in std_logic; -- conv clock @ 100 MHz
		filter_enable_i	: in std_logic; -- activate convolution if 1, act as bypass if 0
		strobe_rec_i	: in std_logic; -- input (record) sample ready indicator
		strobe_pb_i		: in std_logic; -- output (playback) sample ready indicator
		rec_i			: in std_logic_vector(INPUT_WIDTH-1 downto 0); -- input sample data
		pb_o			: out std_logic_vector(INPUT_WIDTH-1 downto 0)); -- output sample data;
		
end convolution;