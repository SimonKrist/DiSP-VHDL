-------------------------------------------------------------------------------
--                                                                      
--                        I2S to parallel bidirectional
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         tb_i2s
--
-- FILENAME:       tb_i2s_sim_cfg.vhd
-- 
-- ARCHITECTURE:   sim
-- 
-- ENGINEER:       Simon Krist
--
-- DATE:           2025-10-17
--
-- VERSION:        0.0.1
--
-------------------------------------------------------------------------------
--                                                                      
-- DESCRIPTION:    This is the configuration for the i2s testbench
--                 of the i2s.
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

configuration tb_i2s_sim_cfg of tb_i2s is
  for sim
    for i_i2s : i2s
      use configuration work.i2s_rtl_cfg;
    end for;
  end for;
end tb_i2s_sim_cfg;