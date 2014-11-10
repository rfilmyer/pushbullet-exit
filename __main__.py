import subprocess, sys

def get_exit_code():
    '''get the exit code of the last program executed
    get_exit_code() -> int
    >>>get_exit_code()
    0
    '''
    exitcode = subprocess.call("$?", shell = True)
    return exitcode

#def get_last_command():
#    '''retrieve the last command executed in the shell
#    get_last_command() -> string
#    >>>get_last_command()
#    "apt-get moo"
#    '''
#    lastcommand = subprocess.call("(!:p)", shell = True)
#    return lastcommand

print("Last command: " + "get_last_command()" + ", Exit code: " +
      str(get_exit_code()))

sys.exit()
