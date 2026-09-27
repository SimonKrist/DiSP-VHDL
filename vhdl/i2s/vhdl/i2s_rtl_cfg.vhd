-------------------------------------------------------------------------------
--                                                                      
--                        I2S to parallel bidirectional
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:        i2s
--
-- FILENAME:	  i2s_rtl_cfg.vhd
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
-- DESCRIPTION:    This is the configuration for the entity i2s and the
--                 architecture rtl.
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

configuration i2s_rtl_cfg of i2s is
  for rtl        -- architecture rtl is used for entity i2s
  end for;
end i2s_rtl_cfg;
