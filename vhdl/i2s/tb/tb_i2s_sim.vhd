-------------------------------------------------------------------------------
--                                                                      
--                        I2S to parallel bidirectional
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         tb_i2s
--
-- FILENAME:       tb_i2s_sim.vhd
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
-- DESCRIPTION:    This is the architecture of the i2s testbench
--                 for the i2s.
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
use IEEE.STD_LOGIC_UNSIGNED.all;


architecture sim of tb_i2s is

	component i2s is
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
	end component;

	-- Declare the signals used stimulating the design's inputs.
	signal reset_i			: std_logic := '1'; -- asynchronous reset
	signal bit_clk_i		: std_logic := '0'; -- bit clk
	signal lr_clk_rec_i		: std_logic := '0'; -- l/r indicator clock receive
	signal lr_clk_pb_i		: std_logic := '0'; -- l/r indicator clock send
	signal data_rec_i			: std_logic := '0'; -- serial data in
	signal data_pb_o			: std_logic := '0'; -- serial data out
	signal l_rec_o				: std_logic_vector(width-1 downto 0) := (others => '0'); -- parallel data out left
	signal r_rec_o				: std_logic_vector(width-1 downto 0) := (others => '0'); -- parallel data out right
	signal l_pb_i				: std_logic_vector(width-1 downto 0) := (others => '0'); -- parallel data in left
	signal r_pb_i				: std_logic_vector(width-1 downto 0) := (others => '0'); -- parallel data in right
	signal strobe_rec_l_o	: std_logic := '0'; -- rising edge signals parallel output data readiness
	signal strobe_rec_r_o	: std_logic := '0'; -- l/r indicator parallel output
	signal strobe_pb_l_o	: std_logic := '0'; -- rising edge signals parallel input data readiness
	signal strobe_pb_r_o	: std_logic := '0'; -- l/r indicator parallel input
	
	-- example-data
	type sample_array is array (0 to 3) of std_logic_vector(15 downto 0);
	constant left_samples  : sample_array := (
		x"1111", x"2222", x"3333", x"4444"
	);
	constant right_samples : sample_array := (
		x"AAAA", x"BBBB", x"CCCC", x"DDDD"
	);
	
begin

	-- Instantiate the flipflop design for testing
	i_i2s : i2s
	port map              
		(reset_i		=> reset_i,
		bit_clk_i		=> bit_clk_i,
		lr_clk_rec_i		=> lr_clk_rec_i,
		lr_clk_pb_i		=> lr_clk_pb_i,
		data_rec_i			=> data_rec_i,
		data_pb_o			=> data_pb_o,
		l_rec_o				=> l_rec_o,
		r_rec_o				=> r_rec_o,
		l_pb_i				=> l_pb_i,
		r_pb_i				=> r_pb_i,
		strobe_rec_l_o	=> strobe_rec_l_o,
		strobe_rec_r_o	=> strobe_rec_r_o,
		strobe_pb_l_o	=> strobe_pb_l_o,
		strobe_pb_r_o	=> strobe_pb_r_o);
	

	reset_i <= '0' after 2 us;
	
	lr_clk_pb_i <= lr_clk_rec_i; -- same timing

	-- 8 kHz × 16 × 2 = 256kHz --> 1.953125 us

	p_bit_clk : process
	begin
		bit_clk_i <= not(bit_clk_i);
		wait for 162.760 ns;
	end process;
	
	p_lr_clk : process
		variable cnt : integer := 0;
	begin
		-- initial level
		lr_clk_rec_i <= '0';

		loop
			wait until falling_edge(bit_clk_i);  -- LR changes on BCLK falling edge
			cnt := cnt + 1;
			if cnt = 192 then             -- 16 bits * 2 channels = 32 BCLK per LR period
				lr_clk_rec_i <= not lr_clk_rec_i;
				cnt := 0;
			end if;
		end loop;
	end process;
	
	p_data_rec : process
		variable bit_cnt    : integer := 0;
		variable sample_idx : integer := 0;
		variable prev_lr    : std_logic := '0';
	begin
		wait until lr_clk_rec_i = '1';
		-- init prev-lr with current state
		prev_lr := lr_clk_rec_i;
		-- main loop
		loop
			wait until falling_edge(bit_clk_i);

			if lr_clk_rec_i /= prev_lr then
				prev_lr := lr_clk_rec_i;
				bit_cnt := 0;
			end if;
			
			if bit_cnt < 16 then

				if sample_idx > 15 then

					data_rec_i <= '0';

				else

					-- now serial bits - MSB first
					if lr_clk_rec_i = '0' then
						data_rec_i <= left_samples(sample_idx)(15 - bit_cnt);
					else
						data_rec_i <= right_samples(sample_idx)(15 - bit_cnt);
					end if;

				end if;
			
			elsif bit_cnt = 16 then
				data_rec_i <= '0';
				if lr_clk_rec_i = '0' then

					sample_idx := (sample_idx + 1) mod 4;

				end if;
				
			else
			
				data_rec_i <= '0';
			
			end if;
			
			bit_cnt := bit_cnt + 1;

		end loop;
	end process;
	
	p_data_pb_l : process
	
		variable sample_idx : integer := 0;
		
	begin
		wait until reset_i = '0';
		
		-- main loop
		loop
		
			wait on strobe_pb_l_o;
			
			l_pb_i <= left_samples(sample_idx);
				
			-- switch sample index
			sample_idx := (sample_idx + 1) mod 4;
			
		end loop;
	end process;

	p_data_pb_r : process
	
		variable sample_idx : integer := 0;
		
	begin
		wait until reset_i = '0';
		
		-- main loop
		loop
		
			wait on strobe_pb_r_o;
			
			r_pb_i <= right_samples(sample_idx);
				
			-- switch sample index
			sample_idx := (sample_idx + 1) mod 4;
			
		end loop;
	end process;

	
end sim;

