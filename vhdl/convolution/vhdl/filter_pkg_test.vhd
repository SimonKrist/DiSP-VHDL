-------------------------------------------------------------------------------
--                                                                      
--                        		FILTER PKG
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         --
--
-- FILENAME:       filter_pkg.vhd
-- 
-- ARCHITECTURE:   pkg
-- 
-- ENGINEER:       Simon Krist
--
-- DATE:           2026-01-02
--
-- VERSION:        0.0.1
--
-------------------------------------------------------------------------------
--                                                                      
-- DESCRIPTION:    This is a package containing filter coefficient array constants.
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

package filter_pkg is

    constant FILTER_LENGTH : integer := 7;
    constant FILTER_WIDTH : integer := 16;

	type t_filter is array(0 to FILTER_LENGTH-1) of signed(FILTER_WIDTH-1 downto 0);
	
    constant C_FILTER : t_filter :=
    (
        0 => to_signed(5, FILTER_WIDTH),
        1 => to_signed(4, FILTER_WIDTH),
        2 => to_signed(3, FILTER_WIDTH),
        3 => to_signed(5, FILTER_WIDTH),
        4 => to_signed(4, FILTER_WIDTH),
        5 => to_signed(3, FILTER_WIDTH),
        6 => to_signed(5, FILTER_WIDTH)
    );

end package filter_pkg;