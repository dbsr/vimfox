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
 let g:vimfox_user_ft_hooks['less'] = function("vimfox#less_ft_hook")
 <
```

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


Vimfox uses the filename of the current buffer for its reload request. This
works when you are working on 'real' css and js files but fails for example
on less and coffee files.
Less files for example first need to be compiled to regular css and its name
changed from foo.less to foo.css.

```vim
" ft hook example for less files

function! ExampleLessFtHook(do_write)
  " change foo.coffee -> foo.css
  let bname = expand('%:t:r')
  let fname = bname . '.css'
  " the do_write argument is optional, use it to skip unnessary writes after
  " reload write hooks.
  if a:do_write
    call system('lessc ....')
  endif
  " if the buffer name is different from the filename used on the page
  " you can return a dictionary with the correct filename
  return {'fname': fname}
endfunction

let g:vimfox_user_ft_hooks['less'] = function('ExampleLessFtHook')
```

For very simple hooks you can also use a string, which vimfox will try 
to run using *execute*.

###disclaimer

This plugin has not been thorougly tested (as in has not been tested yet).


###contact

Comments and critique always welcome @ dydrmntion _AT_ gmail



----
Thu Jun 13 06:12:42 CEST 2013
