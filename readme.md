Miner launch tool with unified settings.
This project was created to improve skills in DOS/Windows shell.
This tool helps to run different miners from a remote host without remembering the specific settings keys of different miners. 
It also adds the convenience of editing urls and wallets in one place for all miners.

To achieve even greater convenience, you need to make a bat file with a remote call to this program. 
Example: <<C:\Scripts\"Cash_button.bat">> 
Content: <<call \\'set_your_remote_node'\Miners\start_miner.bat rigel nexa+zil set_custom_settings "lock_cclk=1500 lock_mclk=5000 lock_cclk=1100 lock_mclk=X">>
Just make a link on the desktop for the bat file or create a task in the task scheduler.

To manage multiple machines you can use pstools:
If you have networks over the Internet, use this tool with your own encrypted VPN.
PSTools need firewall settings (one part to establish connection, another part to ensure fast operation).
Firewall settings: (RU)
netsh advfirewall firewall set rule name="Наблюдение за виртуальной машиной (DCOM - входящий трафик)" localport=135 protocol=tcp new enable=yes
netsh advfirewall firewall set rule name="Удаленное управление службой (RPC)" new enable=yes
netsh advfirewall firewall set rule name="Общий доступ к файлам и принтерам (имена NetBios - входящий)" protocol=udp localport=137 new enable=yes
netsh advfirewall firewall set rule name="Общий доступ к файлам и принтерам (датаграммы NetBios - входящий)" protocol=udp localport=138 new enable=yes
netsh advfirewall firewall set rule name="Общий доступ к файлам и принтерам (входящий трафик сеанса NB)" protocol=tcp localport=139 new enable=yes
netsh advfirewall firewall set rule name="Общий доступ к файлам и принтерам (входящий трафик SMB)" new enable=yes
Firewall settings: (EN)
<<Will add later>>
Make file with ip/computer_name to call miner remotely.
Kill running miner: psexec @path/to/file.txt  -u "set_username" -p "set_password" -s -d taskkill /F /IM miner.exe
Run script to start miner: psexec @path/to/file.txt -u "set_username" -p "set_password" -d -i (set_session_id: "1" if you log in machine by: usb keyboard, radmin, lm, aspia, rms, anydesk, etc. "2" if you log in by: RDP. If you have multiple users and work on the computer, just learn it accurately.) "C:\Scripts\Cash_button.bat"
If you have problems with "psexec -i" and don't see the running window, try using zabbix to monitor. Update: ready-made scripts in a folder.

How to use:
To add new miner follow the steps. (See examples in folders)
1. Add miner folder to ./ with miner name. Inside the folder, the startup file should be called "miner.exe".
2. Add algorithm miner to ./#vars/algorithms/"miner_folder"/"algorithm_name".txt.
3. Add common_settings for algorithm to ./#vars/common_settings/"miner_folder"/"algorithm_name".txt
4. Add settings_var_names to ./#vars/settings_var_names/"miner_name".bat
5. Add mining url to ./#vars/url/"algorithm_name".txt
6. Add address wallet to ./#vars/wallet/"coin_name".txt

run keys:
	Miner:
		Just type miner name
	Algorithms:
		One coin mining: "kas", "nexa", "zil", etc.
		Dual coin mining: etc_zil, eth_zil, etc+zil, etc+kaspa, nexa+zil etc. (_ - mining on one url; + mining on different url)
		Tripple coin mining: etc_zil+kaspa, eth_zil+alephium, etc+kas+zil, eth+nexa+zil etc. (_ - mining on one url; + mining on different url)		
	Settings:
		Dont use special settings: ""
		Use the most frequent settings: "set_common_settings"
		Use your settings: "set_custom_settings"
	Custom settings name:
		"lock_core_clock"
		"lock_mem_clock"
		"core_clock_offset"
		"mem_clock_offset"
		"power_limit"
		"fan"
		"memory_tweaks"
		"devices"
		"kernel"
		"log"
		"api"
		"temp_limit"
		"zil_caсhing"
		"password"
		"personalization"
Example: ./start_mining.bat t-rex nexa 
Example: ./start_mining.bat lolminer eth_zil+alephium set_common_settings
Example: ./start_mining.bat rigel etc+nexa+zil set_custom_settings "lock_cclock=1500,1200,1300 lock_mclock=X fan=70,30 cclk_offset=100,200 mclk_offset=500,400 password=x"
Example: ./start_mining.bat rigel nexa+zil set_custom_settings "lock_cclock=1500,1200,1300/1100,1200,1500 lock_mclock=5000/X fan=70/80 cclk_offset=100,200/-400,-500 mclk_offset=-1000,-500/1000,1200 password=x"