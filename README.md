This script is a Pcap Command Extractor that extracts terminal commands from a given pcap (packet capture) file. It checks if tshark (a network protocol analyzer) is installed, and if not, installs it automatically. Once tshark is confirmed, the script scans the pcap file for specific terminal commands (e.g., whoami, pwd, ls, ifconfig, etc.), extracts them, and saves them into an output file. The script also displays the extracted commands in the terminal for user review. It's a helpful tool for extracting and analyzing commands from captured network traffic.


![Image Alt](https://github.com/AviorMostovski/PCAP-commands-script/blob/67e5977af13ad9bec18838a329b036d0761600b4/commands%20pcap.png)
