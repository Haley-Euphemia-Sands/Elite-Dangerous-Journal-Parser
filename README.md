# Elite-Dangerous-Journal-Parser
A Bash script for returning various datapoints from Elite Dangerous journal Log

## To use
The script uses `jq` so make sure to install it first on Debian Based Systems just use `sudo apt install jq`

The modes that exist :

Universal Cartographics mode e.g. `<script> uc <working dir> <journal> <output>` 
Lists out all the systems you have sold at Universal Cartographics.

Universal Cartographics Profit mode e.g. `<script> ucp <working dir> <journal> <output>`
Lists the profits of every Universal Cartographics sold.

Message mode e.g. `<script> msg <working dir> <journal> <output>`
Lists all message history both recieved and sent.

Missed Universal Cartographics mode e.g. `<script> muc <working dir> <journal> <output>`
Lists all Terraformable, Water worlds, Ammonia worlds, and Earth-like worlds you have scanned with the FSS but haven't mapped.

There is more targeted versions of Missed Universal Cartographics mode focusing on those individual planet types however it currently doesn't output those so rewriting of that part of the script is needed.



## TODO:

1. The ability to ignore sent or recieved messages with message history as well as whether to include npc or not
2. FSD jumps info
3. Other Statistics
4. May redo in C++.
