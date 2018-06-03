--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:33:05 07/14/2014
-- Design Name:   
-- Module Name:   C:/Users/Mike Field/Projects/Upsample/tb_upsample.vhd
-- Project Name:  Upsample
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: upsample
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
 
ENTITY tb_upsample IS
END tb_upsample;
 
ARCHITECTURE behavior OF tb_upsample IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT upsample
    PORT(
         clk50 : IN  std_logic;
         rx : IN  std_logic;
         tx : OUT  std_logic;
         --btn : IN  std_logic_vector(3 downto 0);
         led : OUT  std_logic_vector(1 downto 0);
         --audio_l : OUT  std_logic;
         --audio_r : OUT  std_logic;
         SDRAM_CLK : OUT  std_logic;
         SDRAM_CKE : OUT  std_logic;
         --SDRAM_CS : OUT  std_logic;
         SDRAM_nRAS : OUT  std_logic;
         SDRAM_nCAS : OUT  std_logic;
         SDRAM_nWE : OUT  std_logic;
         SDRAM_DQM : OUT  std_logic_vector(1 downto 0);
         SDRAM_ADDR : OUT  std_logic_vector(12 downto 0);
         SDRAM_BA : OUT  std_logic_vector(1 downto 0);
         SDRAM_DQ : INOUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk50 : std_logic := '0';
   signal rx : std_logic := '0';
   signal btn : std_logic_vector(3 downto 0) := (others => '0');
   signal reset_i : std_logic := '0';
   signal refresh_i : std_logic := '0';
   signal rw_i : std_logic := '0';
   signal we_i : std_logic := '0';
   signal addr_i : std_logic_vector(23 downto 0) := (others => '0');
   signal data_i : std_logic_vector(15 downto 0) := (others => '0');
   signal ub_i : std_logic := '0';
   signal lb_i : std_logic := '0';
	--BiDirs
   signal SDRAM_DQ : std_logic_vector(15 downto 0);

 	--Outputs
   signal tx : std_logic;
   signal led : std_logic_vector(1 downto 0);
   signal audio_l : std_logic;
   signal audio_r : std_logic;
   signal SDRAM_CLK : std_logic;
   signal SDRAM_CKE : std_logic;
   signal SDRAM_CS : std_logic;
   signal SDRAM_RAS : std_logic;
   signal SDRAM_CAS : std_logic;
   signal SDRAM_WE : std_logic;
   signal SDRAM_nRAS : std_logic;
   signal SDRAM_nCAS : std_logic;
   signal SDRAM_nWE : std_logic;
   signal SDRAM_DQM : std_logic_vector(1 downto 0);
   signal SDRAM_ADDR : std_logic_vector(12 downto 0);
   signal SDRAM_BA : std_logic_vector(1 downto 0);
	signal ready_o : std_logic;
   signal done_o : std_logic;
   signal data_o : std_logic_vector(15 downto 0);

   type state_type is (ST_WAIT, ST_IDLE, ST_READ, ST_WRITE, ST_REFRESH);
   signal state_r, state_x : state_type := ST_WAIT;
	 
   -- Clock period definitions
   constant clk50_period : time := 50 ns;
 
BEGIN
 
 
	-- Instantiate the Unit Under Test (UUT)
   uut: upsample PORT MAP (
          clk50 => clk50,
          rx => rx,
          tx => tx,
          --btn => btn,
          led => led,
          --audio_l => audio_l,
          --audio_r => audio_r,
          SDRAM_CLK => SDRAM_CLK,
          SDRAM_CKE => SDRAM_CKE,
          --SDRAM_CS => SDRAM_CS,
          SDRAM_nRAS => SDRAM_nRAS,
          SDRAM_nCAS => SDRAM_nCAS,
          SDRAM_nWE => SDRAM_nWE,
          SDRAM_DQM => SDRAM_DQM,
          SDRAM_ADDR => SDRAM_ADDR,
          SDRAM_BA => SDRAM_BA,
          SDRAM_DQ => SDRAM_DQ
        );

   -- Clock process definitions
   clk50_process :process
   begin
		clk50 <= '0';
		wait for clk50_period/2;
		clk50 <= '1';
		wait for clk50_period/2;
   end process;
 
    process (clk50)
    begin
        if rising_edge(clk50) then
            state_r <= state_x;
        end if;
    end process;
 
    process ( state_r, ready_o, done_o )
    begin
 
        state_x <= state_r;
        rw_i <= '0';
        we_i <= '1';
        ub_i <= '0';
        lb_i <= '0';
 
        case ( state_r ) is
 
        when ST_WAIT =>
            if  ready_o = '1' then
                state_x <= ST_READ;
            end if;
 
        when ST_IDLE =>
            state_x <= ST_IDLE;
 
        when ST_READ =>
            if done_o = '0' then
                rw_i <= '1';
                addr_i <= "000000000000011000000001";
            else
                state_x <= ST_WRITE;
            end if;
 
        when ST_WRITE =>
            if done_o = '0' then
                rw_i <= '1';
                we_i <= '0';
                addr_i <= "000000000000011000000001";
                data_i <= X"ADCD";
                ub_i <= '1';
                lb_i <= '0';
            else
                state_x <= ST_REFRESH;
            end if;
 
        when ST_REFRESH =>
            if done_o = '0' then
                refresh_i <= '1';
            else
                state_x <= ST_IDLE;
            end if;
        end case;
 
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin
      -- hold reset state for xx period.
        reset_i <= '1';
		-- complete simulation of UART RX here :
		
		-- receiving from UART data
		
		
      wait for 20 ms;
        reset_i <= '0';
        wait;
    end process;

END;
