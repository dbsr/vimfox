vimfox
======

Live **refreshless** web development for vim.


what is vimfox?
---------------

I don't care for css and I don't think that will ever change. Still, in this day 
and age you cannot escape having to write a stylesheet every once in a while.  
One thing that helps me tremendously is editing websites in firefox using firebug. 
Edits are near instantly applied which makes for a way more enjoyable experience
than the usual edit-write-reload-(disappointment)-cycle that is css (for me).

Vimfox brings live editing to your favorite text editor. With 
vimfox you can edit **.less, .css, .coffee, .js, ~~.html~~ files** in vim
and almost instantly see the result back in your browser without the need
to refresh the page.

> *A refreshless reload, if you will.*  


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
files. I forked it because I wanted to add *less* support. Then I thought it'd
be cool to find out if it was possible to implement *real* realtime editing.

That's when I decided to start over from scratch and find out how far I would
get.

|filetype|refreshless|auto-reload|
|:-:|:-:|:-:|
|.js|Y|Y|
|.coffee|Y|Y|
|.css|Y|Y|
|.less|Y|Y|
|.html|N|Y|


installation
------------

1. Install vimfox using pathogen / vundle or clone the repo directly into
your $HOME/.vim directory.

2. cd to the repo's root and:
        
    `$: ./sh install.sh`

   *This will download all the required modules using pip and install
   them locally in the plugins directory. As a result vimfox is not 
   dependent / doesnt have to look very far for its imports when working 
   in a virtualenv.*


how to use
----------

Start by adding this line to the document you are going to work on:

```javascript        
<script type='text/javascript' src="http://localhost:9000/vimfox/vimfox.js"></script>
```

If vimfox.js can't find io (the socketio) library in the documents' namespace
it will inject the document with the required script tag.
When the socketio library is loaded it will set up the sockets which enable the
vimfox server to communicate with the browser.


That's all. Start your (dev) server open a file in vim and start editing. 

> It might be very refreshlessning.


options
-------  
  

### settings
```vim
"address vimfox server
g:Vimfox_host` = "127.0.0.1"

"port vimfox server
g:Vimfox_port = 9000

"enable auto reload for the following filetypes
g:Vimfox_reload_auto_fts = ['.css', '.less']

"enable reload post write hook for the following filetypes
g:Vimfox_reload_write_fts = ['.js', '.coffee', '.html']

```

### commands
```vim
" toggle auto reload hook on and off
:VimfoxToggleAutoReload

" manually check buffer for changes and reload if changes found
:VimfoxCheckBuffer

" manually reload buffer in browser
:VimfoxReloadBuffer
```

disclaimer
----------

This plugin has not been thorougly tested (as in has not been tested yet).

  

> Comments and (to a lesser extend) critique always welcome @ dydrmntion _AT_ gmail

