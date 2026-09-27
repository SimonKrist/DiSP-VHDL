-------------------------------------------------------------------------------
--                                                                      
--                        		CONVOLUTION
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         convolution
--
-- FILENAME:       convolution_rtl_cfg.vhd
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
-- DESCRIPTION:    This is the configuration for the entity convolution and the
--                 architecture rtl.
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

configuration convolution_rtl_cfg of convolution is
  for rtl        -- architecture rtl is used for entity convolution
  end for;
end convolution_rtl_cfg;
