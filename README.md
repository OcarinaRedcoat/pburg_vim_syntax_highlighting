# Pburg VIM Syntax Highlighting

## Install the syntax file 
Save the file, then install it by copying the file to ~/.vim/syntax/pburg.vim on Unix-based systems.

You may need to create the .vim (or vimfiles) directory, and you may need to create the syntax subdirectory. In Vim, your home directory is specified with ~ on Unix systems. You can see what directories to use by entering commands like the following in Vim: 

```
:echo expand('~')
:echo expand('~/.vim/syntax/pburg.vim')
```

Using the directory specified above means the syntax file will be available to you, but not to other users. If you want the syntax file to be available to all users, do not save the file under your home directory; instead, copy the file under your Vim system directory. The default for both Unix is that system-wide syntax files are placed in the $VIM/vimfiles/syntax directory (which you may need to create). You can see the full path name of the required file by entering the following in Vim:

```
:echo expand('$VIM/vimfiles/syntax/pburg.vim')
```

Another procedure to show the base directories which can be used is to enter either of the following commands in Vim (the first displays the value of the 'runtimepath' option, and the second inserts that value into the current buffer):
```
:set runtimepath?
:put =&runtimepath
```
By default, the first item in runtimepath is the base directory for your personal Vim files, and the second item is the base directory for system-wide Vim files. Place the syntax subdirectory under either of these directories; doing that means your syntax file will not be overwritten when you next upgrade Vim. Do not use a directory containing the files distributed with Vim because that will be overwritten during an upgrade (in particular, do not use the $VIMRUNTIME directory).

### Add to vimrc 
Simply create a file in ~/.vim/ftdetect with the same name as your syntax file, in this case ~/.vim/ftdetect/pburg.vim. In this file place a single line to set the filetype on buffer read or creation
Add filetype detection to vimrc in this case the Vim script is named pburg.vim so we use the filetype "pburg".
```
au BufRead,BufNewFile *.brg set filetype=pburg
```
