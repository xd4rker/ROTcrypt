ROTcrypt
===

A simple ROT-x (Caesar cipher) encryption/decryption tool written in Bash

Screenshots
===

![01](http://i.imgur.com/1ezTOLb.png)

![02](http://i.imgur.com/AUACzyj.png)

![03](http://i.imgur.com/gJGXILA.png)


Usage
===

    $ ./rotcrypt.sh <Rotation number> [Options] <String>

Options
===

    -h    Show the help message
    -v    Verbose mode. This parameter can only be combined with the -d parameter
    -e    Encrypt a given string
    -d    Decrypt a given string
  
Examples
===

Decrypting a ROT-10 encrypted text

    $ ./rotcrypt.sh 10 -d "drsc sc k cezob dyz combod wocckqo"
   
Encrypting a text through ROT-8

    $ ./rotcrypt.sh 8 -e "This is a super top secret message"

If the ROT argument isn't set, the script will use ROT-13 by default

    $ ./rotcrypt.sh -e "This is a super top secret message"

This will decrypt the cypher based on letters' frequency (Works only with English alphabet) if the ROT argument isn't set

    $ ./rotcrypt.sh -d "drsc sc k cezob dyz combod wocckqo"

Using verbose mode

    $ ./rotcrypt.sh -d "drsc sc k cezob dyz combod wocckqo" -v


