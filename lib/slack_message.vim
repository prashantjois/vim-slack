let g:SlackMessage = { "url": "", "token": "", "content_file_path": "", "channels": [], "title": "", "comment": "", "language": "" }

function! SlackMessage.new(url, token, content_file_path, options)
  let l:obj = copy(self)

  let l:obj.url = a:url
  let l:obj.token = a:token
  let l:obj.content_file_path = a:content_file_path

  if !has_key(a:options, "channels") || len(a:options["channels"]) == 0
    throw "Please specify the channel(s) you want to post to (-channels)"
  else
    let l:obj.channels = a:options.channels
  endif

  if has_key(a:options, "title")
    let l:obj.title = a:options.title
  endif

  if has_key(a:options, "comment")
    let l:obj.title = a:options.comment
  endif

  if has_key(a:options, "language")
    let l:obj.title = a:options.language
  endif

  return l:obj
endfunction

function! SlackMessage.post_snippet()
  let l:output=system(self.file_upload_command())
  if v:shell_error == 0
    throw l:output
  endif
endfunction

function! SlackMessage.file_upload_command()
  let l:command="curl -s -X POST"
  let l:command=l:command . " -F token=" . self.token
  let l:command=l:command . " -F file=@" . self.content_file_path
  let l:command=l:command . " -F channels=" . self.channels

  if len(self.title) > 0
    let l:command=l:command . " -F title=" . self.title
  endif

  if len(self.comment) > 0
    let l:command=l:command . " -F initial_comment=" . self.comment
  endif

  if len(self.language) > 0 
    let l:command=l:command . " -F filetype=" . self.language
  endif

  let l:command=l:command . " " . self.url
  let l:command=l:command . " | grep '\"ok\":false'"
  return l:command
endfunction
