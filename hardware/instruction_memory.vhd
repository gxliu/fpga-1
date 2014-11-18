library ieee;
use ieee.std_logic_1164.all;
use work.defines.all;
use ieee.numeric_std.all;


entity instruction_memory is
    port ( clk : in std_logic;
           reset : in std_logic;
           write_enable_in : in std_logic;
           address_in : in  instruction_address_t;
           address_hi_select_in : in  std_logic;
           data_in : in word_t;
           data_out : out instruction_t
           );
end instruction_memory;

architecture behavioral of instruction_memory is

  type mem_t is array(INSTRUCTION_MEM_SIZE - 1 downto 0) of word_t;
  signal inst_mem_hi : mem_t := ( (3) => X"0002" 
                                , (4) => X"0001"
                                , (5) => X"0002"
                                , (6) => X"1000"
                                , (7) => X"7800"
                                , (8) => X"4000"
                                , others => (others => '0')
                                );
  signal inst_mem_lo : mem_t := ( (3) => X"2804" 
                                , (4) => X"1804"
                                , (5) => X"2004"
                                , (6) => X"0000"
                                , (7) => X"0000"
                                , (8) => X"0000"
                                , others => (others => '0'));

begin

  registers: process (clk) is
  begin

    if rising_edge(clk) then
      if write_enable_in = '0' then
        data_out <= inst_mem_hi(to_integer(unsigned(address_in))) & inst_mem_lo(to_integer(unsigned(address_in)));
      elsif write_enable_in = '1' then
        if address_hi_select_in = '1' then
          inst_mem_hi(to_integer(unsigned(address_in))) <= data_in;
        else
          inst_mem_lo(to_integer(unsigned(address_in))) <= data_in;
        end if;
      end if;
    end if;

  end process;

end behavioral;