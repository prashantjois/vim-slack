let g:TempFile = { "abs_path": "" }

function! TempFile.new()
    return copy(self)
endfunction

function! TempFile.path()
  if len(self.abs_path) == 0
    let l:filename = self.get_name()
    let l:tmpdir = "/tmp"
    let self.abs_path = l:tmpdir . "/" .  l:filename
  endif

  return self.abs_path
endfunction
"
function! TempFile.get_name()
  let l:prefix = "vim-slack"
  let l:extension = expand('%:e')
  " Not perfectly reliable in creating a unique name, but I would rather not
  " rely on an external tool to get a true unique number or temporary file
  let l:filename = strftime("%Y%m%d%H%M%S")
  return l:prefix . "-" . l:filename . "." . l:extension
endfunction

function! TempFile.write_selection()
  execute "'<,'>w " . self.path()
endfunction

function! TempFile.delete()
  let l:rm_command ="rm -f " . self.path()
  call system(l:rm_command)
endfunction
