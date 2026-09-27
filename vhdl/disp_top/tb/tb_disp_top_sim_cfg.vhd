-------------------------------------------------------------------------------
--                                                                      
--                        		DISP_TOP
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         tb_disp_top
--
-- FILENAME:       tb_disp_top_sim_cfg.vhd
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
-- DESCRIPTION:    This is the cfg for the simulation
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

configuration tb_disp_top_sim_cfg of tb_disp_top is
  for sim
    for i_disp_top : disp_top
      use configuration work.disp_top_struct_cfg;
    end for;
  end for;
end tb_disp_top_sim_cfg;