----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Project Name: upsample
-- Target Devices: Spartan 6 LX9 
-- Tool versions: 
-- Description: Generate a 96Mhz clock for for the audio playback and memory controller
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity clocking is
    Port ( clk50 : in  STD_LOGIC;
			  clk100 : out  STD_LOGIC);
end clocking;

architecture Behavioral of clocking is
	signal clk0 : std_logic;
	signal clkfb, clkfbbuf : std_logic;
begin


i_DCM: DCM
   generic map (
      -- CLKDV_DIVIDE => 2.0, --  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                           --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      CLKFX_DIVIDE => 1,   --  Can be any interger from 1 to 32
      CLKFX_MULTIPLY => 2, --  Can be any integer from 1 to 32
      CLKIN_DIVIDE_BY_2 => FALSE, --  TRUE/FALSE to enable CLKIN divide by two feature
      CLKIN_PERIOD => 20.0
	) --  Delay configuration DONE until DCM LOCK, TRUE/FALSE
   port map (
      CLKIN => clk50,   -- Clock input (from IBUFG, BUFG or DCM)
      PSCLK => '0',   -- Dynamic phase adjust clock input
      PSEN => '0',     -- Dynamic phase adjust enable input
      PSINCDEC => '0', -- Dynamic phase adjust increment/decrement
      RST => '0',       -- DCM asynchronous reset input
--		CLK2X => realclk0,
--		CLK2X180 => realclk180,
		CLK0 => clkfb,
		CLKFB => clkfbbuf,
		CLKFX => clk100
   );

	-- clkfb is run through a BUFG only to shut up ISE 8.1
	BUFG_clkfb : BUFG
   port map (
      O => clkfbbuf,     -- Clock buffer output
      I => clkfb         -- Clock buffer input
   );

end Behavioral;

