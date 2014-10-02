-- Copyright 2014 Shane's Crappy VHDL Coding.llc
-- Original Author: Shane Allman (michael.allman@colorado.edu)
-- Counts with each clock cycle and sets state of LED's to counts.
-- This version attempts to use a better clockdivider

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_MISC.ALL;

--library streaming_sgdma;
--use streaming_sgdma.streaming_sgdma;

entity SimpleLED is
	port (
		clk : in std_logic; -- ???MHz clock
		leds : out std_logic_vector(3 downto 0) --leds for status	
	);

end entity ; -- SimpleLed_top

architecture arch of SimpleLED is

signal q: unsigned(31 downto 0) := (others => '0');
signal reducedClk : std_logic := '0';
    
begin

    clkDiv  : process(clk,q) --The nth bit of q should flip at the rate clk/(2^(n+1))
    begin
        if (rising_edge(clk)) then 
            q <= q + 1;
        end if;
    reducedClk <= q(26); -- reducedClk should run at 100/134ish Hz if clk is 100MHz
    end process clkDiv;

    ledCounter: process(reducedClk)  
    variable counter: unsigned(3 downto 0) := (others => '0');
    begin
        if (rising_edge(reducedClk)) then
            counter := counter + 1;
        end if;
        leds <= not std_logic_vector(counter);
    end process ledCounter;

end arch;
