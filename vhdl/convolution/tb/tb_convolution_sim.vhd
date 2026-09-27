-------------------------------------------------------------------------------
--                                                                      
--                        		CONVOLUTION
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         tb_convolution
--
-- FILENAME:       tb_convolution_sim.vhd
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
-- DESCRIPTION:    This is the architecture of the convolution testbench
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
use IEEE.STD_LOGIC_UNSIGNED.all;


architecture sim of tb_convolution is

	component convolution is

		port(reset_i		: in std_logic; -- asynchronous reset
			clk_i			: in std_logic; -- conv clock @ 100 MHz
			filter_enable_i	: in std_logic; -- activate convolution if 1, act as bypass if 0
			strobe_rec_i	: in std_logic; -- input (record) sample ready indicator
			strobe_pb_i		: in std_logic; -- output (playback) sample ready indicator
			rec_i			: in std_logic_vector(INPUT_WIDTH-1 downto 0); -- input sample data
			pb_o			: out std_logic_vector(INPUT_WIDTH-1 downto 0)); -- output sample data;
	
	end component;

	-- Declare the signals used stimulating the design's inputs.
	signal reset_i		: std_logic := '1'; -- asynchronous reset
	signal clk_i		: std_logic := '0'; -- 100 MHz clock
	signal strobe_rec_i : std_logic := '0';
	signal strobe_pb_i	: std_logic := '0';
	signal rec_i		: std_logic_vector(INPUT_WIDTH-1 downto 0) := (others => '0');
	signal pb_o			: std_logic_vector(INPUT_WIDTH-1 downto 0) := (others => '0');
	signal filter_enable_i : std_logic := '1';

	signal s_bit_clk	: std_logic := '0';

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
	i_convolution : convolution
	port map              
		(reset_i		=> reset_i,
		clk_i			=> clk_i,
		filter_enable_i => filter_enable_i,
		strobe_rec_i	=> strobe_rec_i,
		strobe_pb_i		=> strobe_pb_i,
		rec_i			=> rec_i,
		pb_o			=> pb_o);

	reset_i <= '0' after 100 us;

	p_clk : process
	begin
		clk_i <= not(clk_i);
		wait for 5 ns;
	end process;

	p_bit_clk : process
	begin
		s_bit_clk <= not(s_bit_clk);
		wait for 1.953125 us;
	end process;

	-- operates on bit_clk
	p_inputs : process
		variable bit_cnt    : integer := 0;
		variable sample_idx : integer := 0;
	begin
		wait until reset_i = '0';

		-- main loop
		loop
			wait until rising_edge(s_bit_clk);

			if bit_cnt < 35 then

				bit_cnt := bit_cnt + 1;

				if bit_cnt = 18 then

					strobe_pb_i <= not(strobe_pb_i);

				end if;
				
			else

				if (sample_idx > 15) then

					rec_i <= (others => '0');

				else

					rec_i <= samples_impulse(sample_idx);
					sample_idx := sample_idx + 1;

				end if;

				strobe_rec_i <= not(strobe_rec_i);
				bit_cnt := 0;
			
			end if;

		end loop;
	end process;
	
end sim;

