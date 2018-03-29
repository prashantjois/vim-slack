runtime lib/option_parser.vim
runtime lib/temp_file.vim
runtime lib/slack_message.vim

let s:slack_params = [ 'users', 'channels', 'title', 'comment', 'language' ]

function! slack#version()
    return '1.0.0'
endfunction

function! slack#complete(lead, cmd, pos)
  let l:args = map(copy(s:slack_params), '"-" . v:val . " "')
  return filter(l:args, 'v:val =~# "^-*".a:lead')
endfunction

function! slack#post(kwargs)
  try
    let l:options = g:OptionParser.parse(a:kwargs, s:slack_params)
    let l:tmp_file = g:TempFile.new()
    let l:slack_message = g:SlackMessage.new(g:slack_vim_token, l:tmp_file.path(), l:options)

    call l:tmp_file.write_selection()
    call l:slack_message.post_snippet()
    call l:tmp_file.delete()
    echom "Slacked your message :)"
  catch /.*/
    echoerr v:exception
  endtry
endfunction

function! s:set_var(var, value)
  if !exists(a:var)
    exec 'let ' . a:var . ' = ' . "'" . substitute(a:value, "'", "''", "g") . "'"
    return 1
  endif
  return 0
endfunction

if !executable('curl')
  throw "'curl' not found"
endif

if !exists('g:slack_vim_token')
  throw "Couldn't find your API token for slack (g:slack_vim_token)"
endif

call s:set_var("g:slack_file_upload_url", "https://slack.com/api/files.upload")
call s:set_var("g:slack_user_lookup_by_email_url", "https://slack.com/api/users.lookupByEmail")
