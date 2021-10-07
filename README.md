# FAVRUN

## <span style="color:red">Fav</span>ourite <span style="color:blue">Run</span>ner

## Introduction

Favrun is a simple zsh plugin to load and save long commands (as in with loads of characters) to a file. Kind of like aliases in the init file, but easier access to add and run. The objective is to avoid copying and pasting stuff to the terminal during development.

## What it consists in

Have you ever been in a middle of developing a programming project and it implies running loads of commands that are very long? Do you see yourself pasting those commands to a text file and then copying them to the command line when needed? Well not any more!

Sometimes it is inconvenient to have hundreds of small script files for each of these long commands, so my idea was to do a function that reads these commands from a file and then runs them in the current shell.

For instance, I had a file that looked like this:

`commands.txt`
```text
# get root
http POST localhost:5000/api/users < user1.json
# authed request
http localhost:5000/api/auth x-auth-token:eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dyt0CoTl4WoVjAHI9Q_CwSKhl6d_9rhM3NrXuJttkao
```
and would copy those commands to the terminal for the project I am currently (6/10/2021) working on. 
Now, what I can do is wrap those commands with the following line:
```
#FAVRUN <command_name>
```
which would make that commands file look like this:

`commands.txt`
```
#FAVRUN basicget - get root
http localhost:5000/
#FAVRUN registeruser
# authed request
http localhost:5000/api/auth x-auth-token:eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dyt0CoTl4WoVjAHI9Q_CwSKhl6d_9rhM3NrXuJttkao
```
and would mean that I could run one of the commands like this:
```
$ favrun -c basicget -f commands.txt
```
which will result in
```
the commands to run:
http localhost:5000/
the results:
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 11
Content-Type: text/html; charset=utf-8
Date: Thu, 07 Oct 2021 15:20:27 GMT
ETag: W/"b-b/dpicSS1cSWkCO01+K2HkvYfao"
Keep-Alive: timeout=5
X-Powered-By: Express

API Running
```
as it would if I had copied and pasted the command to the terminal. What comes after the word "basicget" in the file is a simple optional description.

If no filename is provided, nor a variable named `$FAVRUNFILE` exists, the file named "favrun.txt" is used as default.

## Install
It can be installed as a zsh plugin with zinit, or any other plugin manager, probably, by adding the following to `.zshrc`:

```bash
zinit load zuntik/favrun
```

## Notes


### Disclaimer
This work is not ready, but as per rule 3 of the [Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy), "_Design and build software, even operating systems, to be tried early, ideally within weeks._", I guess it's fair to publicise and use it right away.


### Things I would like some help with or still want to do

1. Make the code more robust because there are lots of bash programming quirks I am not familiar with.
2. Help decide if this code should be POSIX compliant so that can be used by other shells. It doesn't seem to work with bash right now.
4. Use build systems to help people install.
5. Make default favourites files in `$XDG_DATA_HOME`, for example.
6. Do completion. Maybe display all the available commands in a file upon pressing tab or even past the whole command under the cursor automatically.
7. Improve this README.

### And finally,
Feel free to fork. Feel free to do pull requests. Your help with probably be accepted.
