----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Özgür Ünal
-- 
-- Create Date: 11/01/2023 05:35:39 PM
-- Design Name: 
-- Module Name: decimation - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decimation is
    generic (
        g_rst_type      : string;
        g_rst_pol       : std_logic;
        g_in_width      : positive;
        g_out_width     : positive;
        g_decim_factor  : positive
    );
    port (
        in_clk          : in  std_logic;
        in_rst          : in  std_logic;
        in_valid        : in  std_logic;
        in_data         : in  std_logic_vector(g_in_width-1 downto 0);
        out_valid       : out std_logic;
        out_data        : out std_logic_vector(g_out_width-1 downto 0)
        
    );
end entity decimation;


architecture rtl of decimation is

        signal      arst            : std_logic;
        signal      rst             : std_logic;
        signal      in_data_reg     : std_logic_vector(g_in_width-1 downto 0);

    begin
        
        async   : if g_rst_type = "async" generate
            arst <= in_rst;
            rst  <= not g_rst_pol;
        end generate async;

        sync    : if g_rst_type = "sync" generate
            arst <= not g_rst_pol;
            rst  <= in_rst;
        end generate sync;

        none    : if g_rst_type = "none" generate
            arst <= not g_rst_pol;
            rst  <= not g_rst_pol;
        end generate none;
        
        MainProcess : process(in_clk, arst)
                variable counter : std_logic := '0';
            begin
                if arst = g_rst_pol then
                    out_data        <= (others => '0');
                    out_valid       <= '0';
                else
                    if rising_edge(in_clk) then
                        if rst = g_rst_pol then
                            out_data        <= (others => '0');
                            out_valid       <= '0';
                        else
                            if in_valid = '1' then
                                if counter = '0' then
                                    out_data    <= in_data;
                                    out_valid   <= '1';
                                else
                                    out_data    <= out_data;
                                    out_valid   <= '0';
                                end if;
                                counter     := not counter;
                            else
                                out_data        <= out_data;
                                out_valid       <= out_valid;
                            end if;
                        end if;
                    end if;
                end if;

        end process MainProcess;
        
end architecture rtl;    