-------------------------------------------------------------------------------
--                                                                      
--                        		CONVOLUTION
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         tb_convolution
--
-- FILENAME:       tb_convolution_sim:cfg.vhd
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
-- DESCRIPTION:    This is the config of the convolution testbench
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

configuration tb_convolution_sim_cfg of tb_convolution is
  for sim
    for i_convolution : convolution
      use configuration work.convolution_rtl_cfg;
    end for;
  end for;
end tb_convolution_sim_cfg;