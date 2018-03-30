runtime lib/option_parser.vim
runtime lib/temp_file.vim
runtime lib/client.vim
runtime lib/channels.vim
runtime lib/snippet.vim

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
    let l:client = g:SlackClient.new(g:slack_vim_token)
    let l:snippet = g:SlackSnippet.new(l:tmp_file.path(), l:options)

    if has_key(l:options, "channels")
      if type(l:options.channels) == 1
        let l:channels = split(l:options.channels, ',')
      else
        let l:channels = l:options.channels
      end
    else
      let l:channels = []
    endif

    if has_key(l:options, "users")
      if type(l:options.users) == 1
        let l:users = split(l:options.users, ',')
      else
        let l:users = l:options.users
      end
    else
      let l:users = []
    endif
    let l:channels = g:SlackChannels.new(g:slack_vim_token, l:channels, l:users)

    call l:tmp_file.write_selection()
    call l:client.post_snippet(l:snippet, l:channels)
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

call s:set_var("g:slack_file_upload_url", "https://slack.com/api/files.upload")
call s:set_var("g:slack_user_lookup_by_email_url", "https://slack.com/api/users.lookupByEmail")
call s:set_var("g:slack_curl_binary", "curl")

if !executable(g:slack_curl_binary)
  throw "'curl' not found"
endif

if !exists('g:slack_vim_token')
  throw "Couldn't find your API token for slack (g:slack_vim_token)"
endif
