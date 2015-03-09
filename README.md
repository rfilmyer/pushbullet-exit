pushbullet-exit
===============

BASH script to send a pushbullet notification upon the exit of a unix shell command.

`pushbullet-exit` uses the 
[Pushbullet API v2](https://docs.pushbullet.com/v2/pushes/) to send a 
notification to your device when run. This can include an exit status to let
you know that your command ran successfully or not, or it can just act as
a naive indicator.

##Requirements:  
* `curl` must be installed
* Your Pushbullet [Account token](https://www.pushbullet.com/account) must be
  accessible to the script (see "Account Token Handling" below)

##Instructions:  
* Call `pushbullet-exit.sh` in the terminal as you would any other shell script.
* Ensure that your account token is in the appropriate place.
* To include your exit status, put `$?` as the first argument like so:  
`./pushbullet-exit.sh $?`  

It's generally useful to call the script as part of a larget command, eg
`make install; ./pushbullet-exit.sh $?`. Remember to use `;`, as `&&` will
not run the script if the previous command fails.

##Account Token Handling
This branch is reworking the handling of account tokens. Tokens are looked for in this priority:  
1. A `-t` flag when the script is called, manually specifying the key.
2. An environment variable called `PUSHBULLET_ACCT_TOKEN`
3. As the first line in `~/.config/pushbullet`. This is similar to how [pushbullet-bash](https://github.com/Red5d/pushbullet-bash/blob/master/pushbullet), another pushbullet bash script I found on GitHub, handles tokens.
4. In a file called `acct-token` in the current directory (The current way, which will eventually be deprecated)

##Future Features:  
* A more versatile options system to better customize notifications
* Being able to pipe `stdin` to the body of the notification


