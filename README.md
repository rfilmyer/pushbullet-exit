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
* Your Pushbullet [Account token](https://www.pushbullet.com/account) must
be in a file named `acct-token` and placed in the current directory. 
This will be changed shortly (see "future features" below)

##Instructions:  
* Call `pushbullet-exit.sh` in the terminal as you would any other shell script.
* Ensure that your account token is in the appropriate place.
* To include your exit status, put `$?` as the first argument like so:  
`./pushbullet-exit.sh $?`  

It's generally useful to call the script as part of a larget command, eg
`make install; ./pushbullet-exit.sh $?`. Remember to use `;`, as `&&` will
not run the script if the previous command fails.

##Future Features:  
* A more versatile options system to better customize notifications
* Being able to pipe `stdin` to the body of the notification
* A proper `--help` message
* A less hacky way to handle account tokens
###Future Account Token Handling
The current way to handle account tokens (look for a file in the *current* directory) is needlessly hacky.
Instead, I'm going to make a new process, looking for tokens
in this priority:  
1. A `-k` flag when the script is called, manually specifying the key.
2. An environment variable, likely called `PUSHBULLET_ACCT_TOKEN`
3. As the first line in `~/.config/pushbullet`. This is similar to how [pushbullet-bash](https://github.com/Red5d/pushbullet-bash/blob/master/pushbullet), another pushbullet bash script I found on GitHub, handles tokens.
4. In a file called `acct-token` in the current directory (The current way, which will eventually be deprecated)
