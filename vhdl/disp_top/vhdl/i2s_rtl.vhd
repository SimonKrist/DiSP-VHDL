-------------------------------------------------------------------------------
--                                                                      
--                        I2S to parallel bidirectional
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:        i2s
--
-- FILENAME:	  i2s_rtl.vhd
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
-- DESCRIPTION:    This is the architecture for the entity i2s.
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
use IEEE.STD_LOGIC_UNSIGNED.all;

architecture rtl of i2s is
	
	-- i2s rec signals
	signal s_current_lr_rec : std_logic; -- saves the current lr clock state
	signal s_counter_rec : integer range 0 to width; -- counts
	signal s_shift_reg_rec : std_logic_vector(width-1 downto 0);
	signal s_frame_finished_rec : std_logic;
	
	-- i2s pb signals
	signal s_current_lr_pb : std_logic; -- saves the current lr clock state
	signal s_counter_pb : integer range 0 to width; -- counts
	signal s_shift_reg_pb : std_logic_vector(width-1 downto 0);
	signal s_strobe_pb_sent : std_logic;
	signal s_strobe_rec_sent : std_logic;
	
	signal s_strobe_rec_l : std_logic := '0';
	signal s_strobe_rec_r : std_logic := '0';
	signal s_strobe_pb_l : std_logic := '0';
	signal s_strobe_pb_r : std_logic := '0';
	
begin
	
	-- i2s rec process
	p_i2s_rec : process(reset_i, bit_clk_i)
	begin
		-- async reset
		if (reset_i = '1') then
		
			l_rec_o <= (others => '0');
			r_rec_o <= (others => '0');

			s_current_lr_rec <= '0';
			s_counter_rec <= width;
			s_shift_reg_rec <= (others => '0');
			s_frame_finished_rec <= '0';
			
			s_strobe_rec_l <= '0';
			s_strobe_rec_r <= '0';
			
		elsif rising_edge(bit_clk_i) then
			
			-- check if the lr receiving clock has changed - if so, reset counter and clear shift reg
			if (lr_clk_rec_i /= s_current_lr_rec) then
				s_current_lr_rec <= lr_clk_rec_i;
				s_frame_finished_rec <= '0';
				s_shift_reg_rec <= s_shift_reg_rec(width-2 downto 0) & data_rec_i;
				s_counter_rec <= width;
				s_strobe_rec_sent <= '0';
				
			-- if the counter has not reached one, we are in the middle of a frame - push data into shift reg
			elsif (s_counter_rec > 1) then
			
				s_shift_reg_rec <= s_shift_reg_rec(width-2 downto 0) & data_rec_i;
				s_counter_rec <= s_counter_rec - 1;
			
			-- if the counter is 1, we reached the end of the frame --> push data to parallel outs and wait one cycle before setting event
			elsif (s_counter_rec = 1 and s_frame_finished_rec = '0') then

					if s_current_lr_rec = '1' then
					
						-- right channel out
						r_rec_o <= s_shift_reg_rec(width-2 downto 0) & data_rec_i;
				
					else
					
						-- left channel out
						l_rec_o <= s_shift_reg_rec(width-2 downto 0) & data_rec_i;
				
					end if;
				
				-- frame is finished, set flag
				s_frame_finished_rec <= '1';
			
			-- frame finished, reset shift reg and counter, set event strobe
			else

				if (s_current_lr_rec = '1' and s_strobe_rec_sent = '0') then
					
					-- right channel complete
					s_strobe_rec_r <= not s_strobe_rec_r;
					s_strobe_rec_sent <= '1';
					s_shift_reg_rec <= (others => '0');
					s_counter_rec <= width;
				
				elsif (s_current_lr_rec = '0' and s_strobe_rec_sent = '0') then
				
					-- left channel complete
					s_strobe_rec_l <= not s_strobe_rec_l;
					s_strobe_rec_sent <= '1';
					s_shift_reg_rec <= (others => '0');
					s_counter_rec <= width;

				else

					null;
			
				end if;
	
				
				
			end if;
		
		end if;
		
	end process;

	-- i2s pb process
	p_i2s_pb : process(reset_i, bit_clk_i)
	begin
		-- async reset
		if (reset_i = '1') then

			data_pb_o <= '0';
		
			s_shift_reg_pb <= (others => '0');
			s_current_lr_pb <= '0';
			s_counter_pb <= width-1;
			s_strobe_pb_sent <= '0';

			s_strobe_pb_l <= '0';
			s_strobe_pb_r <= '0';
		
		-- we drive the i2s data output, operate on the falling edge
		elsif falling_edge(bit_clk_i) then
			
			-- check if the lr playback clock has changed - if so, reset counter and clear shift reg
			if (lr_clk_pb_i /= s_current_lr_pb) then
				s_current_lr_pb <= lr_clk_pb_i; -- store lr state
				s_counter_pb <= width-2; -- prep counter (starts from 15-MSB) but we send the first bit in this cycle
				s_strobe_pb_sent <= '0';
				
				if (lr_clk_pb_i = '1') then
				
					-- copy right channel input into shift reg
					s_shift_reg_pb <= r_pb_i;
					data_pb_o <= r_pb_i(width-1); -- send first bit
					
				else
				
					-- copy left channel input into shift reg
					s_shift_reg_pb <= l_pb_i;
					data_pb_o <= l_pb_i(width-1); -- send first bit
					
				end if;
				
			-- if the counter has not reached zero, we are in the middle of a frame - push shift reg out to data_pb_o
			elsif (s_counter_pb > 0) then
			
				data_pb_o <= s_shift_reg_pb(s_counter_pb);
				s_counter_pb <= s_counter_pb - 1;
			
			-- if the counter is 0, we reached the end of the frame --> send last bit and request next frame, also switch l/r strobes accordingly
			else

				

				if (s_current_lr_pb = '1' and s_strobe_pb_sent = '0') then
				
					-- if the current sample is of the right channel, we want the left channel sample next
					s_strobe_pb_l <= not s_strobe_pb_l;
					s_strobe_pb_sent <= '1';
					data_pb_o <= s_shift_reg_pb(s_counter_pb); -- write last bit
					
				elsif (s_current_lr_pb = '0' and s_strobe_pb_sent = '0') then
				
					-- if the current sample is of the left channel, we want the right channel sample next
					s_strobe_pb_r <= not s_strobe_pb_r;
					s_strobe_pb_sent <= '1';
					data_pb_o <= s_shift_reg_pb(s_counter_pb); -- write last bit

				else

					-- reset data line for dont care bits
					data_pb_o <= '0';
					null;
					
				end if;
				
			end if;
		
		end if;
		
	end process;

	strobe_rec_l_o <= s_strobe_rec_l;
	strobe_rec_r_o <= s_strobe_rec_r;
	strobe_pb_l_o <= s_strobe_pb_l;
	strobe_pb_r_o <= s_strobe_pb_r;

end rtl;