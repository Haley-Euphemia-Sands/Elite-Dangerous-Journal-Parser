# Elite-Dangerous-Journal-Parser
A Bash script for returning various datapoints from Elite Dangerous journal Log

## To use
The script uses `jq` so make sure to install it first on Debian Based Systems just use `sudo apt install jq`

### The modes
\
Universal Cartographics mode e.g. `<script> uc <working dir> <journal> <output>` 
\
Lists out all the systems you have sold at Universal Cartographics.
\
\
Universal Cartographics Profit mode e.g. `<script> ucp <working dir> <journal> <output>`
\
Lists the profits of every Universal Cartographics sold.
\
\
Message mode e.g. `<script> msg <working dir> <journal> <output>`
\
Lists all message history both recieved and sent. By default it will retrieve all messages, but n/N, s/S, and p/P can be added in submode to specify if you want npc, sent, and players messages respectivily.
\
\
Missed Universal Cartographics mode e.g. `<script> muc <working dir> <journal> <output>`
\
Lists planets you have scanned with FSS but haven't mapped.
\
To select which class to list you can use t or T for Terraformable, w or W for Water worlds, e or E for Earth-likes, and a or A for Ammonia worlds.
\
`<script> muc <working dir> <journal> <output> aTWe` is as valid as `<script> muc <working dir> <journal> <output> tWeA` an order doesn't matter as long as there are no spaces.

## TODO:

1. FSD jumps info
2. Other Statistics
3. May redo in C++.
