----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:41:07 11/20/2023 
-- Design Name: 
-- Module Name:    Graphics - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Graphics is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           P1up : in  STD_LOGIC;
			  P1dn : in  STD_LOGIC;
			  P2up : in  STD_LOGIC;
			  P2dn : in  STD_LOGIC;
           hpos : in  std_logic_vector(9 downto 0);
           vpos : in  std_logic_vector(9 downto 0);
           graphics_on : out  STD_LOGIC;
           hit : out  STD_LOGIC;
           miss : out  STD_LOGIC;
           rgb : out  STD_LOGIC_VECTOR (2 downto 0));
end Graphics;

architecture Behavioral of Graphics is
-------signals & constants---------
constant MAX_Y: integer:=640;
constant MAX_X: integer:=480;
constant twoBAR_X_L: integer:=80; --left and right x position of player 2 paddle
constant twoBAR_X_R: integer:=88;
constant oneBAR_X_L: integer:=600; --left and right x position of player 1 paddle
constant oneBAR_X_R: integer:=608;
constant BAR_Y_SIZE: integer:=72; --max size of paddle height
constant BAR_V: integer:=4; --bar velocity?? 4 pixels of movement at a time??

signal pix_x, pix_y: unsigned(9 downto 0);
--top and bottom positions of player 1 and 2 paddles, these change so they are a signal
signal onebar_y_top, onebar_y_bottom, twobar_y_top, twobar_y_bottom: unsigned(9 downto 0);
signal twobar_y_reg, twobar_y_next, onebar_y_reg, onebar_y_next: unsigned(9 downto 0); --unsigned is the same as std_logic_vector except you can use to_integer to convert it to a POSTITIVE integer only (signed numbers can represent negative!!)
--^^might be able to represent these as integers??
--btw these are just intermediary values



signal ball_x_l, ball_x_r: unsigned(9 downto 0);
signal ball_y_top, ball_y_bottom: unsigned(9 downto 0);
signal ball_x_reg, ball_y_reg, ball_x_next, ball_y_next: unsigned(9 downto 0);
signal ball_vx_reg, ball_vx_next, ball_vy_reg, ball_vy_next: unsigned(9 downto 0); --ball x y velocity??

constant BALL_SIZE: integer:=8; --used to determine ball's bounds when it is moving
constant BALL_V_P: unsigned(9 downto 0):=to_unsigned(2,10); --converting int 2 to binary 10 bits 
constant BALL_V_N: unsigned(9 downto 0):=unsigned(to_signed(-2,10));  
 
   signal twobar_on, onebar_on, ball_on: std_logic;  
   signal twobar_rgb, onebar_rgb, ball_rgb: std_logic_vector(2 downto 0);  
   signal dp_out: std_logic; --when we are at x=0 y=481 (ie we are out of the display area)
	
begin
--initialize registers
process(clk, rst)
	begin
		if(rst='1')then
	      onebar_y_reg <= (OTHERS=>'0');
			twobar_y_reg <= (OTHERS=>'0');  
			ball_x_reg <= (OTHERS=>'0');  
			ball_y_reg <= (OTHERS=>'0');  
			ball_vx_reg <= ("0000000100");  
			ball_vy_reg <= ("0000000100");  		
		elsif(clk'event and clk = '1')then
			onebar_y_reg <= onebar_y_next;
			twobar_y_reg <= twobar_y_next; 
			ball_x_reg <= ball_x_next;  
			ball_y_reg <= ball_y_next;  
			ball_vx_reg <= ball_vx_next;  
			ball_vy_reg <= ball_vy_next; 
		end if;
end process;

pix_x<= unsigned(hpos);
pix_y<= unsigned(vpos);
dp_out<='1' when (pix_y=481) and (pix_x=0) else '0';

onebar_y_top <=onebar_y_reg;
onebar_y_bottom <=onebar_y_top + BAR_Y_SIZE - 1;
onebar_on<='1' when ((oneBAR_X_L<=pix_x) and (pix_x<=oneBAR_X_R)) else '0';
twobar_on<='1' when ((twoBAR_X_L<=pix_x) and (pix_x<=twoBAR_X_R)) else '0';
onebar_rgb<="101";
twobar_rgb<="001";

--bar movement
process(onebar_y_reg, twobar_y_reg, onebar_y_bottom, twobar_y_bottom, onebar_y_top, twobar_y_top, dp_out, P1up, P1dn, P2up, P2dn)
	begin
		onebar_y_next<= onebar_y_reg;
		twobar_y_next<= twobar_y_reg;
		if(dp_out='1')then
		--P1
			if(P1dn='1' and onebar_y_bottom<(MAX_Y - 1 - BAR_V)) then
				onebar_y_next<=onebar_y_reg+BAR_V; -- move down
			elsif(P1up='1' and onebar_y_top>BAR_V) then
				onebar_y_next<=onebar_y_reg-BAR_V; -- move up
			end if;
			
		--P2	
			if(P2dn='1' and twobar_y_bottom<(MAX_Y - 1 - BAR_V)) then
				twobar_y_next<=twobar_y_reg+BAR_V; -- move down
			elsif(P2up='1' and twobar_y_top>BAR_V) then
				twobar_y_next<=twobar_y_reg-BAR_V; -- move up
			end if;
		end if;
end process;

ball_x_l <= ball_x_reg;  
ball_y_top <= ball_y_reg;  
ball_x_r <= ball_x_l + BALL_SIZE - 1;  
ball_y_bottom <= ball_y_top + BALL_SIZE - 1;  

ball_rgb <= "110"; --red ball
ball_x_next <=  
    ball_x_reg + ball_vx_reg when dp_out='1' else  
    ball_x_reg ;  
   ball_y_next <=  
    ball_y_reg + ball_vy_reg when dp_out='1' else  
    ball_y_reg ; 

process(ball_vx_reg,ball_vy_reg,ball_x_l,ball_x_r, ball_y_top ,ball_y_bottom,onebar_y_top, twobar_y_top, onebar_y_bottom, twobar_y_bottom)  
   begin  
    hit <='0';  
    miss <='0';  
    ball_vx_next <= ball_vx_reg;  
    ball_vy_next <= ball_vy_reg;  
 
    if ball_y_top < 1 then     -- reach top  
      ball_vy_next <= BALL_V_P;  
    elsif ball_y_bottom > (MAX_Y-1) then -- reach bottom  
      ball_vy_next <= BALL_V_N;  
--    elsif ball_x_l <= twoBAR_X_R then -- reach P2  
--      ball_vx_next <= BALL_V_P;   -- bounce back  
    elsif (oneBAR_X_L<=ball_x_r) and (ball_x_r<=oneBAR_X_R) and --ball is inside bar x bound 
       (onebar_y_top<=ball_y_bottom) and (ball_y_top<=onebar_y_bottom) then --ball is within bar y bound
       -- reach x of right bar, a hit 
       ball_vx_next <= BALL_V_N; -- bounce back  
       hit <= '1';
	 elsif (twoBAR_X_L<=ball_x_r) and (ball_x_r<=twoBAR_X_R) and  
       (twobar_y_top<=ball_y_bottom) and (ball_y_top<=twobar_y_bottom) then  
       -- reach x of left bar, a hit 
       ball_vx_next <= BALL_V_N; -- bounce back  
       hit <= '1';  
    elsif (ball_x_r>MAX_X) then   -- reach right border  
      miss <= '1';         -- a miss  
    end if;  
   end process;
	
--rgb mux	
process(onebar_on, twobar_on, ball_on, onebar_rgb, twobar_rgb, ball_rgb)
	begin
		if(onebar_on='1')then
			rgb<=onebar_rgb;
		elsif(twobar_on='1')then
			rgb<=twobar_rgb;
		elsif(ball_on='1')then
			rgb<=ball_rgb;
		else
			rgb<="010"; --green bg
		end if;
end process;
end Behavioral;

