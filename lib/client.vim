let g:SlackClient = { "token": "" }


function! SlackClient.new(token)
  let l:obj = copy(self)
  let l:obj.token = a:token
  return l:obj
endfunction

function! SlackClient.post_snippet(snippet, channels)
  let l:output=system(self.file_upload_command(a:snippet, a:channels))
  if v:shell_error == 0
    throw l:output
  endif
endfunction

function! SlackClient.file_upload_command(snippet, channels)
  let l:aggregated_channels = join(a:channels.aggregated_channels(), ",")
  
  let l:command = g:slack_curl_binary
  let l:command = l:command . " -s -X POST"
  let l:command = l:command . " -F token=" . self.token
  let l:command = l:command . " -F file=@" . a:snippet.content_file_path
  let l:command = l:command . " -F channels='" . l:aggregated_channels . "'"

  if len(a:snippet.title) > 0
    let l:command = l:command . " -F title='" . a:snippet.title . "'"
  endif

  if len(a:snippet.comment) > 0
    let l:command = l:command . " -F initial_comment='" . a:snippet.comment . "'"
  endif

  if len(a:snippet.language) > 0 
    let l:command = l:command . " -F filetype=" . a:snippet.language
  endif

  let l:command = l:command . " " . g:slack_file_upload_url
  let l:command = l:command . " | grep '\"ok\":false'"
  return l:command
endfunction
