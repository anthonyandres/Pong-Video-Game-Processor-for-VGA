library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pong is
    Port ( clk : in  STD_LOGIC;
           SW0 : in  STD_LOGIC;
           SW1 : in  STD_LOGIC;
           SW2 : in  STD_LOGIC;
           SW3 : in  STD_LOGIC;
           H : out  STD_LOGIC;-- when low retrace back to left
           V : out  STD_LOGIC; --when low, retrace back to top
           DAC_CLK : out  STD_LOGIC;
           Rout : out  STD_LOGIC_VECTOR (7 downto 0);
           Gout : out  STD_LOGIC_VECTOR (7 downto 0);
           Bout : out  STD_LOGIC_VECTOR (7 downto 0));
end pong;

architecture Behavioral of pong is

--VGA horizontal parameters--
	CONSTANT hFP : integer := 16; --front porch
	CONSTANT hBP : integer := 48; --back porch
	CONSTANT hEND : integer := 800; --complete line
	CONSTANT hSP : integer := 96; --sync pulse
-----------------------------	
	
--VGA vertical parameters----
	CONSTANT vFP : integer := 10;
	CONSTANT vBP : integer := 33;
	CONSTANT vEND : integer := 525;
	CONSTANT vSP : integer := 2;
-----------------------------

--clk signals----------------
	signal clk25 : STD_LOGIC := '0'; -- normal clk runs at 50Mhz, VGA 640x480 60fps(?) requires 25MHz
	signal clk_counter : integer := 0;
	signal movementTick : STD_LOGIC := '0';
-----------------------------
	
-----------------------------	
	signal bright : STD_LOGIC;
	signal hpos : integer := 0; --hpos and vpos keep track of current pixel position on screen
	signal vpos : integer := 0; -- hpos counts from 0 to 639(horizontal), vpos from 0 to 479(vertical)
	signal leftBarX : integer := 50; --left bar x position, default position at pixel 50 (always count from left)
	signal leftBarY : integer := 360;--represents bottom of bar
	signal RightBarX : integer := 580;-- right bar x position, default position at pixel 580
	signal RightBarY : integer := 60;
	signal BallX : integer := 310;--represents left side of ball (default start on the right)
	signal BallY : integer := 230;--represents the bottom of the ball
	signal hMove : STD_LOGIC; --determine if left or right movement (0 right, 1 left)
	signal vMove : STD_LOGIC; --determine if up or down movement (0 down, 1 up)
	
	begin

--determine clk signals
	process (clk)
	begin
		if (clk'Event and clk = '1') then
			clk25 <= NOT clk25; --whenever 50Mhz clk has rising edge, invert the signal of clk25. clk 25 starts at 0, then rising edge clk, clk25=1, then next period of clk, clk25=0. So period of clk 25 is half of clk, thus 25MHz
			if (clk_counter  = 180000) then
				movementTick <= NOT movementTick;--same premise as clk>clk25 conversion, except much slower
				clk_counter <= 0;						--50MHz clock is 50 million cycles per second, wayy to fast to update movement
			else
				clk_counter <= clk_counter + 1;
			end if;
		end if;
	end process;

	--pixel tracking
	process (clk25, SW0)
	begin
		-- Reset Switch
		if (SW0 = '1') then
			hpos <= 0;
			vpos <= 0;
			H <= '1';
			V <= '0';
			bright <= '0';
		else
			if (clk25'Event and clk25 = '1') then
				
				--hpos vpos counters
				if (hpos < hEND - 1) then --once hpos reaches 799 (ie it has gone through all 800 pixels), stop incrementing
					hpos <= hpos + 1;
				else
					hpos <= 0;
				if (vpos < vEND - 1) then
					vpos <= vpos + 1;
				else
					vpos <= 0;
				end if;
				end if;
				
				
				-- Horizontal Sync
				--if the hpos is within before the back porch
				if ((hpos < 639 + hFP) OR (hpos >= 639 + hFP + hSP)) then -- |      Active display area     |  front porch  |  Hsync  |  Back Porch  |
					H <= '1';															 -- |                      H = '1'          			| H = '0' |		H = '1'	 |
				else
					H <= '0'; --otherwise retrace occurs
				end if;
				-- if the vpos is within before the front porch
				if ((vpos < 479 + vFP) OR (vpos >= 479 + vFP + vSP)) then
					V <= '1';
				else
					V <= '0';--retrace occurs
				end if;
				
				--check if in display area, bright
				if ((hpos < 640) AND (vpos < 480)) then										
					bright <= '1';									-- |      Active display area     |  front porch  |  Hsync  |  Back Porch  |	
				else													-- |          bright = '1'        |              bright = '0'              |
					bright <= '0';
				end if;
			end if;
		end if;
	end process;
	
	--MOVEMENT & COLLISION
	process (movementTick, SW3, SW1, leftBarY, RightBarY)
	begin
		if (movementTick'Event and movementTick = '1') then
			
			--left bar movement
			if (SW3 = '0') then --when sw3 is up...
				if (leftBarY < 360) then--...and leftbar is below 360(the bounds of the white border)...
					leftBarY <= leftBarY + 1;--...move the bar up one pixel
				else
					leftBarY <= 360;--otherwise if it is at the border, keep the bar at that position
				end if;
			else
				if (leftBarY > 40) then-- when sw3 is down and leftbar is above the bottom white border
					leftBarY <= leftBarY - 1;--...move the bar down 1 pixel
				else
					leftBarY <= 40;
				end if;
			end if;
			
			--right bar movement
			if (SW1 = '0') then -- same logic as left bar movement
				if (RightBarY < 360) then
					RightBarY <= RightBarY + 1;--move 1 pixel up
				else
					RightBarY <= 360;
				end if;
			else
				if (RightBarY > 40) then
					RightBarY <= RightBarY - 1;--move 1 pixel down
				else
					RightBarY <= 40;
				end if;
			end if;
			

			-- COLLISION
			if ( BallX >= leftBarX and BallX < leftBarX + 10) then
				-- when ball hits left player, ball is moving left (0), change direction to right (1)
				if (((BallY >= leftBarY) or (BallY + 10 >= leftBarY)) and ((BallY < leftBarY + 80) or (BallY + 10 < leftBarY + 80)) ) then
					hMove <= '0';
				end if;
			elsif ( BallX = 40 ) then
				-- Change direction when hit left boundary
				if ( (BallY >= 40 and BallY < 160) or (BallY + 10 >= 360 and BallY + 10 < 440) ) then
					hMove <= '0';
				end if;
			elsif (BallX + 10 > RightBarX and BallX + 10 <= RightBarX + 10) then
				-- Change direction when hit the right player
				if ( ((BallY >= RightBarY) or (BallY + 10 >= RightBarY)) and ((BallY < RightBarY + 80) or (BallY + 10 < RightBarY + 80)) ) then
					hMove <= '1';
				end if;
			elsif (BallX + 10 = 600) then
				-- Change direction when hit right boundary
				if ( (BallY >= 40 and BallY < 160) or (BallY + 10 >= 360 and BallY + 10 < 440) ) then
					hMove <= '1';
				end if;
			end if;
			if ( BallY - 1 <= 40 ) then --the ball only changes vertical direction when hitting 
				vMove <= '1';				 --the top boundary or the bottom boundary at 40 and 440 pixels respectively
			elsif (BallY + 11 >= 440) then
				vMove <= '0';
			end if;
			

			-- Update ball location
			--BallX is the right side of the ball, the ball is 10pixels wide
			if ((BallX > 0) and (BallX + 10) < 639) then --when the ball is within the display area...
				-- Horizontal
				if (hMove = '0') then--if hmov indicates right movement
					BallX <= BallX + 1;--ball keeps going to the right
				elsif (hMove = '1') then--if hmov indicates left movement
					BallX <= BallX - 1;--ball keeps going to the left
				end if;
				-- Vertical
				if (vMove = '0') then--same logic as above
					BallY <= BallY - 1;
				elsif(vMove = '1') then
					BallY <= BallY + 1;
				end if;
			else
				BallX <= 300; --set default posiiton for ball if something happens
				BallY <= 220;
			end if;
		end if;
	end process;
	
	
	--set colours when pixel is within the display area
	process (bright)
	begin
		if (bright = '0') then
			Rout <= (others => '0');
			Gout <= (others => '0');
			Bout <= (others => '0');
		else
			if (hpos >= 20 and hpos < 640 - 20 and vpos >=20 and vpos < 460) then
				if ( vpos < 40 or vpos >= 440) then
					Rout <= (others => '1');  -- Display white for top & bottom border
					Gout <= (others => '1');
					Bout <= (others => '1');
				elsif (((hpos < 40) OR (hpos >= 640 - 40)) and (vpos < 160 or vpos >= 320)) then
					Rout <= (others => '1');  -- Display white for left & right border
					Gout <= (others => '1');
					Bout <= (others => '1');
				elsif ((hpos >= BallX and hpos < BallX + 10) and (vpos >= BallY and vpos < BallY + 10) )then
					Rout <= (others => '1');   -- Color Ball inside play field (gate + border)
					Gout <= (others => '1');
					Bout <= (others => '0');
				elsif ((hpos >= leftBarX and hpos < leftBarX + 10) and (vpos >= leftBarY and vpos < leftBarY + 80) )then
					Rout <= (others => '0');   -- Color Player 1
					Gout <= (others => '0');
					Bout <= (others => '1');
				elsif ((hpos >= RightBarX and hpos < RightBarX + 10) and (vpos >= RightBarY and vpos < RightBarY + 80) )then
					Rout <= (others => '1');   -- Color Player 2
					Gout <= (others => '0');
					Bout <= (others => '1');
				elsif (vpos >= 40 and vpos < 440 and hpos > 316 and hpos <324) then
					if(((vpos+7) mod 16) = 0 or ((vpos+6) mod 16) = 0 or ((vpos+5) mod 16) = 0 or ((vpos+4) mod 16) = 0 or ((vpos+3) mod 16) = 0 or ((vpos+2) mod 16) = 0 or ((vpos+1) mod 16) = 0 or ((vpos) mod 16) = 0 or ((vpos-1) mod 16) = 0)then
						Rout <= (others => '0');   -- within an 8 pixel line in the middle between the white border (40, 440)...
						Gout <= (others => '1');	-- if a pixel position
						Bout <= (others => '0');
					else
						Rout <= (others => '0');   -- black center line
						Gout <= (others => '0');
						Bout <= (others => '0');
					end if;
				else
					Rout <= (others => '0');	-- Color background
					Gout <= (others => '1');
					Bout <= (others => '0');
				end if;
			elsif ((hpos >= BallX and hpos < BallX + 10) and (vpos >= BallY and vpos < BallY + 10) )then
				Rout <= (others => '1');   -- Color Ball
				Gout <= (others => '0');
				Bout <= (others => '0');
			else
				Rout <= (others => '0');	-- Color background
				Gout <= (others => '1');
				Bout <= (others => '0');
			end if;
		end if;
	end process;
	
	DAC_CLK <= clk25;

end Behavioral;


