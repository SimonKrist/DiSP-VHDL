-------------------------------------------------------------------------------
--                                                                      
--                        I2S to parallel bidirectional
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:        i2s
--
-- FILENAME:	  i2s_.vhd
-- 
-- ARCHITECTURE:   rtl
-- 
-- ENGINEER:       Simon Krist
--
-- DATE:           2025.10.13
--
-- VERSION:        0.0.1
--
-------------------------------------------------------------------------------
--                                                                      
-- DESCRIPTION:    This is the entity i2s.
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

entity i2s is

generic(width : integer := 16);

	port(reset_i		: in std_logic; -- asynchronous reset
		bit_clk_i		: in std_logic; -- bit clock - also used for sending
		lr_clk_rec_i	: in std_logic; -- l/r indicator clock receive
		lr_clk_pb_i		: in std_logic; -- l/r indicator clock send
		data_rec_i		: in std_logic; -- serial data in
		data_pb_o		: out std_logic; -- serial data out
		l_rec_o			: out std_logic_vector(width-1 downto 0); -- parallel data out left
		r_rec_o			: out std_logic_vector(width-1 downto 0); -- parallel data out right
		l_pb_i			: in std_logic_vector(width-1 downto 0); -- parallel data in left
		r_pb_i			: in std_logic_vector(width-1 downto 0); -- parallel data in right
		strobe_rec_l_o	: out std_logic; -- event signals parallel output data readiness (left)
		strobe_rec_r_o	: out std_logic; -- event signals parallel output data readiness (right)
		strobe_pb_l_o	: out std_logic; -- event signals parallel input data readiness (left)
		strobe_pb_r_o	: out std_logic); -- event signals parallel input data readiness (right)
		
end i2s;