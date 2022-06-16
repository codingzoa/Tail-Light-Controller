library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TAIL_LIGHT is
    port(
        CLK : in std_logic;
        RESET : in std_logic;
        BREAK : in std_logic;
        LEFT : in std_logic;
        RIGHT : in std_logic;
        LED : out std_logic_vector(7 downto 0));
end TAIL_LIGHT;

architecture Behavioral of TAIL_LIGHT is
    signal state : std_logic_vector(2 downto 0);       --state�� ������ �� 5���̱� ������ 0~7���� ��Ÿ�� �� �ֵ��� 3bit std_logic_vector �̿�
    signal next_state : std_logic_vector(2 downto 0);  --Flipfolp 3�� �̿��Ѵٴ� �ǹ�
begin
    --state transition
    process(CLK, RESET)                         --state reg�� sequential logic�̱� ������ CLK�ʿ�, asynchronous reset
        begin
            if(RESET='0') then
                state<="000";   --RESET state
            elsif(CLK='1' and CLK'event) then
                state<=next_state;
            end if;
    end process;
    
    --led out
    process(state)                  --moore machine�� ����� ���� ���� ���¿� ���ؼ� ����
        begin
            if(state="000") then    --RESET state
                LED<="00000000";    -- all led off
            elsif(state="001") then --ready state
                LED<="10000001";	   --�� �� led on
            elsif(state="010") then     -- left state
                LED<="11110000";        -- ���� 4�� led on
            elsif(state="011") then     -- right state
                LED<="00001111";        --������ 4�� led on
            else
                LED<="11111111";	--break state / all led on
            end if;
    end process;
    
    --next state
    process(RESET, BREAK, LEFT, RIGHT, state) --���� ���¿��� � �Է��� �޴����� ���� ���� ���� ����
        begin
        --reset state
        if(state="000")then                         
            if(RESET='0') then next_state<="000";  --���� ���� reset state
            else next_state<="001";                --���� ���� ready state 
            end if;
            
        --ready state
        elsif(state="001") then
            if(RESET='0') then next_state<="000";   --���� ���� reset state
            elsif(BREAK='1') then next_state<="100";    --���� ���� break state
            elsif(LEFT='1' and RIGHT='0') then next_state<="010";   --���� ���� left state
            elsif(LEFT='0' and RIGHT='1') then next_state<="011";   --���� ���� right state
            else next_state<="001";     --���� ���� ready state
            end if;
            
	--left state
        elsif(state="010") then
            if(RESET='0') then next_state<="000";   --���� ���� reset state
            elsif(BREAK='1') then next_state<="100";    --���� ���� break state
            elsif(LEFT='1' and RIGHT='0') then next_state<="010";   --���� ���� left state
            else next_state<="001";     --���� ���� ready state
            end if;
            
	--right state
        elsif(state="011") then
            if(RESET='0') then next_state<="000";       --���� ���� reset state
            elsif(BREAK='1') then next_state<="100";        --���� ���� break state
            elsif(LEFT='0' and RIGHT='1') then next_state<="011";       --���� ���� right state
            else next_state<="001"; --���� ���� ready state
            end if;
            
	--break state
        else
            if(RESET='0') then next_state<="000";   --���� ���� reset state
            elsif(BREAK='1') then next_state<="100";    --���� ���� break state
            else next_state<="001"; --���� ���� ready state
            end if;
        end if;	
    end process;

end Behavioral;

