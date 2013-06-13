vimfox
======

Live web development plugin for vim.


###what is vimfox?

Vimfox brings live css, javascript and html editing to vim. This means you
can edit a file in vim and directly see the result without having to refresh 
the page in the browser.

This is not my idea. A couple of days ago I was browsing on github and found 
[browser-connect](https://github.com/Bogdanp/browser-connect.vim), a vim-plugin
made by [Bogdanp](http://github.com/Bogdanp) which offers live reloading of css
files. 

I was curious about how the plugin worked and after reading up on websockets I 
decided to write my own plugin.


###installation

1. Install vimfox using pathogen / vundle or clone the repo directly into
your $HOME/.vim directory.

2. cd to the repo's root and:
        
    `$: ./sh install.sh`

   *This will download all the required modules using pip and install
   them locally in the vimfox-plugin directory. This ensures vimfox will
   work in virtualenvs.*


###how to use

Start by adding this line to the document you are going to work on:

```html
<script type='text/javascript' src="http://localhost:9000/vimfox/vimfox.js"></script>
```

In vim:
```vim 
:VimfoxToggle<CR>
```

That's all. Now, depending on what reload setting you chose for this file's filetype
vimfox will reload the page after you leave insert mode or when you write the buffer..


###options


```vim
" host address vimfox server
g:vimfox_host = '127.0.0.1'
g:vimfox_port = 9000

" reload after writing buffer to file
g:vimfox_reload_post_write_filetypes = ['js', 'coffee', 'html']

" reload after leaving insert mode
g:vimfox_reload_insert_leave_filetypes = ['less', 'css']

" echo toggle state after VimfoxToggle
g:vimfox_echo_toggle_state = 1

" user file type hooks, see the 'filetype hooks' section for more information.
g:vimfox_user_ft_hooks = {}
 
 >example 
 let g:vimfox_user_ft_hooks['less'] = function("less_compress_css")
 <

###commands

```vim
" enable / disable vimfox for the current buffer
 
  :VimfoxToggle<cr>

" (force) reload current buffer in browser.
  
  :VimfoxReloadBuffer<cr>

" (force) reload page in browser.

  :VimfoxReloadPage<cr>

```

###filetype hooks

You can create hooks for specific filetypes. In the plugin are two very simple
hooks included. For less and coffee files. By default vimfox uses the filename 
of the current buffer when it sends a reload request to the vimfox server. This
works for basic css / js and html files but wont work for less and coffee files.

A hook can also take care of compiling to the correct filetype used by 
the page. The coffee hook for example, uses the coffee compiler to create
a valid js file, usable by the browser.

The filetype hook can be either a string for *execute* or a *funcref*. When 
it's a funcref vimfox will try to include a do_save:boolean argument in its 
first attempt. If it fails vimfox will try to call the function again without
any arguments.

A filetype hook can optionally return a dictionary. For now, Vimfox will look 
for only one key, 'fname'. This is the name of the file you want the browser
to reload. The less_ft_hook for example returns {'fname': 'foo.css'}, as a result,
vimfox will not look for the buffer's filename: 'foo.less' (and fail).

###disclaimer

This plugin has not been thorougly tested (as in has not been tested yet).


###contact

Comments and critique always welcome @ dydrmntion _AT_ gmail



----
Thu Jun 13 06:12:42 CEST 2013
