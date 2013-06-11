vimfox
======

Live (refreshless) website editing in vim


what is vimfox?
---------------

    I am not very good at css and I am lazy. Please hire me.

When im building a website I tend to switch between vim and the browser 
a lot, refreshing the page to see the changes more times than I'll blink my eyes.
This is because most of time I have only a vague idea what the result will be from 
for example adding a wrapper for the wrapper inside a both left and right 
floating container. This is a very time consuming, very frustrating process. 

Most modern browser either have builtin functionality and/or extensions which
enable you to edit the css from within the browser and instantly see the results
of those edits.

Vimfox brings this funtionality to your favorite text editor. Now you can 
edit your **.less, .css, .coffee, .js, <del>.html</del> files** and see the changes 
in the browser without refreshing the page.

*A refreshless reload, if you will.*

how does it work?
-----------------

First off. The idea for this concept is not mine. I couple of days back I found,
browser-connect, a vim-plugin which offered live reloading of css files.
    Author: [Bogdanp](http://github.com/Bogdanp)a
    [browser-connect](https://github.com/Bogdanp/browser-connect.vim)


installation
------------

1. Install vimfox using pathogen / vundle or clone the repo directly into
your $HOME/.vim directory.

2. cd to the repo's root and:
        
        ./sh install.sh

3. This will download all the required modules using pip and install
   them locally in the plugins directory. As a result vimfox is not 
   dependent / doesnt have to look very far for its imports when working 
   in a virtualenv.


how to use
----------

Start with adding this line to the document you are going to work on:
        
    <script type='text/javascript' src="http://localhost:9000/vimfox/vimfox.js"></script>

If vimfox.js can't find io (the socketio) library in the documents' namespace
it will inject the document with the required script tag.
When the socketio library is loaded it will set up the sockets which enable the
vimfox server to communicate with the browser.

For now vimfox can send two events to the browser. The first event 

k
vimfox.js will inject the document with the socketio.js library if he cant find 
it in the namespace. Next 





Very quick howto
================

1. add this plugin to vim using Pathogen / Vundle.
2. cd to the basedir of the vimfox repo and:

         ./install.sh

3. optionally change the default host / port for the vimfox server:

         let g:Vimfox_host = 127.0.0.1

         let g:Vimfox_port = 9000

4. add this line to the html page you want to work on:


5. reload the page and you're done.
