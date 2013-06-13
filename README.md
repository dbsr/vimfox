
```
"lol
let g:boo = 2
```

```vim
"lal
let g:asd = 1
```
vimfox
======
Live **refreshless** web development for vim.


what is vimfox?
---------------


Thu Jun 13 05:04:58 CEST 2013
Vimfox brings live editing to your favorite text editor. With 
vimfox you can edit **.less, .css, .coffee, .js, ~~.html~~ files** in vim
and almost instantly see the result back in your browser without the need
to refresh the page.


how does it work?
-----------------

Staticticity is what being a static file is all about. The browser knows this
and normally doesnt bother reading them more than once. 
Vimfox fools the browser into thinking the static files are different 
which forces it to read and process them as if they were new.

Vimfox makes use of the excellent socket.io library to communicate with the 
page in the browser and for instance tell it to change a linksheets name
and force a refreshless reload.

This is not my idea. A couple of days ago I was browsing on github and found 
[browser-connect](https://github.com/Bogdanp/browser-connect.vim), a vim-plugin
made by [Bogdanp](http://github.com/Bogdanp) which offers live reloading of css
files. 

I was curious how the plugin worked and after reading up on websockets I 
decided to write my own plugin.


installation
------------

1. Install vimfox using pathogen / vundle or clone the repo directly into
your $HOME/.vim directory.

2. cd to the repo's root and:
        
    `$: ./sh install.sh`

   *This will download all the required modules using pip and install
   them locally in vimfox plugins directory.*


how to use
----------

Start by adding this line to the document you are going to work on:

```javascript        
<script type='text/javascript' src="http://localhost:9000/vimfox/vimfox.js"></script>
```

*If vimfox.js can't find io (the socketio) library in the documents' namespace
it will request the socketio library and add it to the page.*

Open a file that the page is using in vim and enter the following command:

>:VimfoxToggle<CR>

That's all. Now, depending on what reload setting you chose for this file's filetype
vimfox will reload the page after every edit or every write.


options
-------  

### settings

```vim
"address vimfox server
g:vimfox_host` = "127.0.0.1"

"port vimfox server
g:vimfox_port = 9000

"auto reload after leaving insert mode
g:vimfox_reload_insert_leave_filetypes = ['.css', '.less']

"auto reload after write
g:vimfox_reload_post_write_filetypes = ['.js', '.coffee', '.html']

"echo toggle state (after toggling)
g:vimfox_echo_toggle_state = 1

```


### commands

Enable / disable vimfox for the current buffer
>VimfoxToggle<CR>

Send a manual reload request for the current buffer to vimfox. Add 1 as 
an argument to force a reload regardless whether the file has changed since 
the last reload.
>VimfoxReloadBuffer<CR>

  *this command can also be used to create your own reload hooks

```

disclaimer
----------

This plugin has not been thorougly tested (as in has not been tested yet).

  

> Comments and (to a lesser extend) critique always welcome @ dydrmntion _AT_ gmail
