-------------------------------------------------------------------------------
--                                                                      
--                        		DISP_TOP
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         disp_top
--
-- FILENAME:       disp_top_struct.vhd
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
-- DESCRIPTION:    This is the architecture of the disp_top module.
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

architecture struct of disp_top is

    component i2s
        port(reset_i		: in std_logic; -- asynchronous reset
            bit_clk_i		: in std_logic; -- bit clock - also used for sending
            lr_clk_rec_i	: in std_logic; -- l/r indicator clock receive
            lr_clk_pb_i		: in std_logic; -- l/r indicator clock send
            data_rec_i		: in std_logic; -- serial data in
            data_pb_o		: out std_logic; -- serial data out
            l_rec_o			: out std_logic_vector(INPUT_WIDTH-1 downto 0); -- parallel data out left
            r_rec_o			: out std_logic_vector(INPUT_WIDTH-1 downto 0); -- parallel data out right
            l_pb_i			: in std_logic_vector(INPUT_WIDTH-1 downto 0); -- parallel data in left
            r_pb_i			: in std_logic_vector(INPUT_WIDTH-1 downto 0); -- parallel data in right
            strobe_rec_l_o	: out std_logic; -- rising edge signals parallel output data readiness (left)
            strobe_rec_r_o	: out std_logic; -- rising edge signals parallel output data readiness (right)
            strobe_pb_l_o	: out std_logic; -- rising edge signals parallel input data readiness (left)
            strobe_pb_r_o	: out std_logic); -- rising edge signals parallel input data readiness (right)
    end component;

    component convolution
        port(reset_i		: in std_logic; -- asynchronous reset
            clk_i			: in std_logic; -- conv clock @ 100 MHz
            filter_enable_i : in std_logic; -- active high
            strobe_rec_i	: in std_logic; -- input (record) sample ready indicator
            strobe_pb_i		: in std_logic; -- output (playback) sample ready indicator
            rec_i			: in std_logic_vector(INPUT_WIDTH-1 downto 0); -- input sample data
            pb_o			: out std_logic_vector(INPUT_WIDTH-1 downto 0)); -- output sample data;
    end component;

    signal s_l_rec : std_logic_vector(INPUT_WIDTH-1 downto 0); -- left parallel input coming from codec -> i2s -> conv_l
    signal s_r_rec : std_logic_vector(INPUT_WIDTH-1 downto 0); -- right parallel input coming form codec -> i2s -> conv_r

    signal s_l_pb : std_logic_vector(INPUT_WIDTH-1 downto 0); -- left parralel output coming from conv_l -> i2s -> codec
    signal s_r_pb : std_logic_vector(INPUT_WIDTH-1 downto 0); -- right parallel output coming from conv_r -> i2s -> codec

    signal s_strobe_rec_l : std_logic; -- strobe signals new sample for left channel
    signal s_strobe_rec_r : std_logic; -- strobe singals new sample for right channel

    signal s_strobe_pb_l : std_logic; -- strobe requests new sample for left channel (not used, conv more than fast enough)
    signal s_strobe_pb_r : std_logic; -- strobe requests new sample for right channel (not used, conv more than fast enough)

begin

i_i2s : i2s
port map
    (
        reset_i		        => reset_i,
        bit_clk_i		    => bit_clk_i,
        lr_clk_rec_i		=> lr_clk_rec_i,
        lr_clk_pb_i		    => lr_clk_pb_i,
        data_rec_i			=> data_rec_i,
        data_pb_o			=> data_pb_o,
        l_rec_o				=> s_l_rec,
        r_rec_o				=> s_r_rec,
        l_pb_i				=> s_l_pb,
        r_pb_i				=> s_r_pb,
        strobe_rec_l_o	    => s_strobe_rec_l,
        strobe_rec_r_o	    => s_strobe_rec_r,
        strobe_pb_l_o	    => s_strobe_pb_l,
        strobe_pb_r_o	    => s_strobe_pb_r
    );

i_convolution_l : convolution
port map
    (
        reset_i		    => reset_i,
		clk_i			=> conv_clk_i,
        filter_enable_i => filter_enable_l_i,
		strobe_rec_i	=> s_strobe_rec_l,
		strobe_pb_i		=> s_strobe_pb_l,
		rec_i			=> s_l_rec,
		pb_o			=> s_l_pb
    );

i_convolution_r : convolution
port map
    (
        reset_i		    => reset_i,
		clk_i			=> conv_clk_i,
        filter_enable_i => filter_enable_r_i,
		strobe_rec_i	=> s_strobe_rec_r,
		strobe_pb_i		=> s_strobe_pb_r,
		rec_i			=> s_r_rec,
		pb_o			=> s_r_pb
    );

end struct;