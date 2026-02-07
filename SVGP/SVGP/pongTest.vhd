--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:21:31 11/27/2023
-- Design Name:   
-- Module Name:   /home/student1/aaandres/Desktop/COE758 Labs/SVGP/SVGP/pongTest.vhd
-- Project Name:  SVGP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pong
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY pongTest IS
END pongTest;
 
ARCHITECTURE behavior OF pongTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pong
    PORT(
         clk : IN  std_logic;
         SW0 : IN  std_logic;
         SW1 : IN  std_logic;
         SW2 : IN  std_logic;
         SW3 : IN  std_logic;
         H : OUT  std_logic;
         V : OUT  std_logic;
         DAC_CLK : OUT  std_logic;
         Rout : OUT  std_logic_vector(7 downto 0);
         Gout : OUT  std_logic_vector(7 downto 0);
         Bout : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal SW0 : std_logic := '0';
   signal SW1 : std_logic := '0';
   signal SW2 : std_logic := '0';
   signal SW3 : std_logic := '0';

 	--Outputs
   signal H : std_logic;
   signal V : std_logic;
   signal DAC_CLK : std_logic;
   signal Rout : std_logic_vector(7 downto 0);
   signal Gout : std_logic_vector(7 downto 0);
   signal Bout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   --constant DAC_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pong PORT MAP (
          clk => clk,
          SW0 => SW0,
          SW1 => SW1,
          SW2 => SW2,
          SW3 => SW3,
          H => H,
          V => V,
          DAC_CLK => DAC_CLK,
          Rout => Rout,
          Gout => Gout,
          Bout => Bout
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
--   DAC_CLK_process :process
--   begin
--		DAC_CLK <= '0';
--		wait for DAC_CLK_period/2;
--		DAC_CLK <= '1';
--		wait for DAC_CLK_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
