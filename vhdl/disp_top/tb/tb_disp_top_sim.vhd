-------------------------------------------------------------------------------
--                                                                      
--                        		DISP_TOP
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         tb_disp_top
--
-- FILENAME:       tb_disp_top_sim.vhd
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
-- DESCRIPTION:    This is the architecture for the simulation
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

architecture sim of tb_disp_top is

	component disp_top is

		port(reset_i			: in std_logic; -- asynchronous reset
			bit_clk_i			: in std_logic; -- bit clock - also used for sending
			conv_clk_i      	: in std_logic; -- 100 MHz convolution clock      
			filter_enable_l_i 	: in std_logic; -- active high
			filter_enable_r_i	: in std_logic; -- active high
			lr_clk_rec_i		: in std_logic; -- l/r indicator clock receive
			lr_clk_pb_i			: in std_logic; -- l/r indicator clock send
			data_rec_i			: in std_logic; -- serial data in
			data_pb_o			: out std_logic); -- serial data out
	
	end component;

	-- Declare the signals used stimulating the design's inputs.
	signal s_reset				: std_logic := '1'; -- asynchronous reset
	signal s_bit_clk			: std_logic := '0'; -- bit clk
	signal s_conv_clk			: std_logic := '0'; -- 100 MHz clock
	signal s_filter_enable_l	: std_logic := '1';
	signal s_filter_enable_r	: std_logic := '1';
	signal s_lr_clk_rec	 		: std_logic := '1';
	signal s_lr_clk_pb			: std_logic := '1';
	signal s_data_rec			: std_logic := '0';
	signal s_data_pb			: std_logic;

	-- example-data
	type sample_array is array (0 to 15) of std_logic_vector(15 downto 0);

	constant samples_sine : sample_array := (
    x"0000",
    x"30FB",
    x"5A81",
    x"7641",
    x"7FFF",
    x"7641",
    x"5A81",
    x"30FB",
    x"0000",
    x"CF05",
    x"A57F",
    x"89BF",
    x"8001",
    x"89BF",
    x"A57F",
    x"CF05"
	);

	constant samples_impulse : sample_array := (
    0  => x"7FFF",
    1  => x"0000",
    2  => x"0000",
    3  => x"0000",
    4  => x"0000",
    5  => x"0000",
    others => x"0000"
	);

	
begin

	-- Instantiate the design for testing
	i_disp_top : disp_top
	port map              
		(reset_i			=> s_reset,
		bit_clk_i			=> s_bit_clk,
		conv_clk_i			=> s_conv_clk,
		filter_enable_l_i 	=> s_filter_enable_l,
		filter_enable_r_i	=> s_filter_enable_r,
		lr_clk_rec_i		=> s_lr_clk_rec,
		lr_clk_pb_i			=> s_lr_clk_pb,
		data_rec_i			=> s_data_rec,
		data_pb_o			=> s_data_pb);

	s_reset <= '0' after 5 us;

	p_conv_clk : process
	begin
		s_conv_clk <= not(s_conv_clk);
		wait for 33.333 ns;
	end process;

	p_bit_clk : process
	begin
		s_bit_clk <= not(s_bit_clk);
		wait for 162.760 ns;
	end process;

	p_enable : process
  	begin
		wait for 1 ms;
		s_filter_enable_l <= '1';
		wait for 1 ms;
		s_filter_enable_r <= '1';
		wait;
	end process;
	
	p_lr_clk_rec_i : process
		variable cnt : integer := 0;
	begin
		-- initial level
		s_lr_clk_rec <= '0';

		loop
			wait until falling_edge(s_bit_clk);  -- LR changes on BCLK falling edge
			cnt := cnt + 1;
			if cnt = 192 then             -- 16 bits * 2 channels = 32 BCLK per LR period
				s_lr_clk_rec <= not s_lr_clk_rec;
				cnt := 0;
			end if;
		end loop;
	end process;

	p_lr_clk_pb_i : process
		variable cnt : integer := 0;
	begin
		-- initial level
		s_lr_clk_pb <= '0';

		loop
			wait until falling_edge(s_bit_clk);  -- LR changes on BCLK falling edge
			cnt := cnt + 1;
			if cnt = 192 then             -- 16 bits * 2 channels = 32 BCLK per LR period
				s_lr_clk_pb <= not s_lr_clk_pb;
				cnt := 0;
			end if;
		end loop;
	end process;

	p_data_rec : process
		variable bit_cnt    : integer := 0;
		variable sample_idx : integer := 0;
		variable prev_lr    : std_logic := '0';
	begin
		wait until s_lr_clk_rec = '1';
		-- init prev-lr with current state
		prev_lr := s_lr_clk_rec;
		-- main loop
		loop
			wait until falling_edge(s_bit_clk);

			if s_lr_clk_rec /= prev_lr then
				prev_lr := s_lr_clk_rec;
				bit_cnt := 0;
			end if;
			
			if bit_cnt < 16 then

				if sample_idx > 15 then

					s_data_rec <= '0';

				else

					s_data_rec <= samples_impulse(sample_idx)(15 - bit_cnt);

				end if;
			
			elsif bit_cnt = 16 then
				s_data_rec <= '0';
				if s_lr_clk_rec = '0' then

					if sample_idx <= 15 then

						-- sample_idx := (sample_idx + 1) mod 16;
						sample_idx := (sample_idx + 1);

					end if;

				end if;
				
			else
			
				s_data_rec <= '0';
			
			end if;
			
			bit_cnt := bit_cnt + 1;

		end loop;
	end process;
end sim;

