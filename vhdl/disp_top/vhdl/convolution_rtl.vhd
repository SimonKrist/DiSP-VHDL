-------------------------------------------------------------------------------
--                                                                      
--                        		CONVOLUTION
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         convolution
--
-- FILENAME:       convolution_rtl.vhd
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
-- DESCRIPTION:    This is the architecture of the convolution module.
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

use work.filter_pkg.all;

architecture rtl of convolution is

	-- used for rounding
	constant HALF_LSB : signed(ACCU_WIDTH-1 downto 0) := shift_left(to_signed(1, ACCU_WIDTH), INPUT_WIDTH-2);

	signal s_filter : t_filter := C_FILTER;

	-- past sample memory, needed for FIR conv
	type t_memory is array (0 to FILTER_LENGTH-1) of signed(INPUT_WIDTH-1 downto 0); -- storage for historical samples
	signal s_memory : t_memory := (others => (others => '0'));

	-- state machine type
	type t_state is (bypass, convolution_idle, convolution_busy, convolution_rounding);
	signal s_state : t_state := bypass;
	
	signal s_accu : signed(ACCU_WIDTH-1 downto 0) := (others => '0'); -- convolution accumulator
	signal s_index : integer range 0 to FILTER_LENGTH-1; -- index (used to sweep through filter)

	signal s_buffer : signed(INPUT_WIDTH-1 downto 0) := (others => '0');

	signal s_strobe_rec_meta : std_logic;
	signal s_strobe_rec_sync_0 : std_logic;
	signal s_strobe_rec_sync_1 : std_logic;

	signal s_strobe_pb_meta : std_logic;
	signal s_strobe_pb_sync_0 : std_logic;
	signal s_strobe_pb_sync_1 : std_logic;

	signal s_strobe_rec_event : std_logic := '0';
	signal s_strobe_pb_event : std_logic := '0';

	signal s_data_valid : std_logic := '0';

	attribute dont_touch : string;
	attribute dont_touch of s_accu : signal is "true";
	attribute dont_touch of s_buffer : signal is "true";

	attribute ram_style: string;
	attribute ram_style of s_filter : signal is "block";
	
begin
	
	-- convolution process
	p_convolution: process(clk_i)
	begin
		-- we operate on the rising edge of clk_i
		if rising_edge(clk_i) then

			-- sync reset
			if(reset_i = '1') then

				pb_o <= (others => '0');
			
				s_index <= 0;
				s_accu <= (others => '0');
				s_buffer <= (others => '0');
				s_data_valid <= '0';

				s_strobe_rec_meta <= '0';
				s_strobe_rec_sync_0 <= '0';
				s_strobe_rec_sync_1 <= '0';

				s_strobe_pb_meta <= '0';
				s_strobe_pb_sync_0 <= '0';
				s_strobe_pb_sync_1 <= '0';

				s_strobe_rec_event <= '0';
				s_strobe_pb_event <= '0';

			else

				-- update buffered strobes rec on rising edge (safe cdc)
				s_strobe_rec_meta <= strobe_rec_i;
				s_strobe_rec_sync_0 <= s_strobe_rec_meta;
				s_strobe_rec_sync_1 <= s_strobe_rec_sync_0;
				s_strobe_rec_event <= s_strobe_rec_sync_0 xor s_strobe_rec_sync_1;

				-- update buffered strobes pb on rising edge (safe cdc)
				s_strobe_pb_meta <= strobe_pb_i;
				s_strobe_pb_sync_0 <= s_strobe_pb_meta;
				s_strobe_pb_sync_1 <= s_strobe_pb_sync_0;
				s_strobe_pb_event <= s_strobe_pb_sync_0 xor s_strobe_pb_sync_1;

				--- CONVOLUTION FSM ---

				case s_state is

					when bypass =>

						if (s_strobe_rec_event = '1') then

							s_buffer <= signed(rec_i);
							s_data_valid <= '1';

						end if;

						if (filter_enable_i = '1') then

							s_state <= convolution_idle;

						end if;

					when convolution_idle =>

						if (s_strobe_rec_event = '1') then

							-- shift the register
							for i in FILTER_LENGTH-1 downto 1 loop

								s_memory(i) <= s_memory(i - 1);

							end loop;

							s_memory(0) <= signed(rec_i); -- and store the new sample

							-- initialize MAC
							s_accu <= (others => '0');
							s_index <= 0;

							s_state <= convolution_busy;

						end if;

						if (filter_enable_i = '0') then

							s_state <= bypass;

						end if; 

					when convolution_busy =>

						-- do a MAC and increase the index for the next cycle
						s_accu <= s_accu + resize((s_memory(s_index) * s_filter(s_index)), ACCU_WIDTH);

						-- check if we are on our last convolution cycle
						if (s_index = FILTER_LENGTH - 1) then

							-- if so, round and write output on next cycle
							s_state <= convolution_rounding;

						else

							s_index <= s_index + 1;

						end if;

					when convolution_rounding =>

						-- build output using arithmentic shift and rounding using half lsb
						s_buffer <= resize(shift_right(s_accu + HALF_LSB, INPUT_WIDTH-1),INPUT_WIDTH);

						s_data_valid <= '1';

						s_state <= convolution_idle;

				end case;

				--- OUTPUT STAGE ---
				-- write to output only if playback sample is requested
				if (s_strobe_pb_event = '1') then

					-- only write if data is valid
					if (s_data_valid = '1') then

						pb_o <= std_logic_vector(s_buffer);
						s_data_valid <= '0'; -- sample used
					
					-- do not change pb out, sample not ready
					else

						null;

					end if;

				end if;

			end if;

		else

			null;

		end if;
			
	end process;

end rtl;