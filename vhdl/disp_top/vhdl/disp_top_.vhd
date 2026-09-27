-------------------------------------------------------------------------------
--                                                                      
--                        		DISP_TOP
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         disp_top
--
-- FILENAME:       disp_top_.vhd
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
-- DESCRIPTION:    This is the entity declaration of the disp_top module.
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

entity disp_top is

    generic(
		INPUT_WIDTH: integer := 16
	);

	port(reset_i			: in std_logic; -- asynchronous reset
		bit_clk_i			: in std_logic; -- bit clock - also used for sending
        conv_clk_i      	: in std_logic; -- 100 MHz convolution clock    
		filter_enable_l_i 	: in std_logic; -- active high
		filter_enable_r_i 	: in std_logic; -- active high 
		lr_clk_rec_i		: in std_logic; -- l/r indicator clock receive
		lr_clk_pb_i			: in std_logic; -- l/r indicator clock send
		data_rec_i			: in std_logic; -- serial data in
		data_pb_o			: out std_logic); -- serial data out
		
end disp_top;