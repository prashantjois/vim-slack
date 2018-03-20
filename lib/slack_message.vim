let g:SlackMessage = { "token": "", "content_file_path": "", "channels": [], "users": [], "title": "", "comment": "", "language": "" }

function! SlackMessage.new(token, content_file_path, options)
  let l:obj = copy(self)

  let l:obj.token = a:token
  let l:obj.content_file_path = a:content_file_path

  if has_key(a:options, "channels")
    if type(a:options.channels) == 1
      let a:options.channels = split(a:options.channels, ',')
    endif
    let l:obj.channels = a:options.channels
  endif

  if has_key(a:options, "users")
    if type(a:options.users) == 1
      let a:options.users = split(a:options.users, ',')
    endif
    let l:obj.users = a:options.users
  endif

  if len(l:obj.channels) == 0 && len(l:obj.users) == 0
    throw "Please specify the channel(s) and/or users(s) you want to post this message to"
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
  let l:aggregated_channels = join(self.aggregated_channels(), ",")
  let l:command="curl -s -X POST"
  let l:command=l:command . " -F token=" . self.token
  let l:command=l:command . " -F file=@" . self.content_file_path
  let l:command=l:command . " -F channels='" . l:aggregated_channels . "'"

  if len(self.title) > 0
    let l:command=l:command . " -F title=" . self.title
  endif

  if len(self.comment) > 0
    let l:command=l:command . " -F initial_comment=" . self.comment
  endif

  if len(self.language) > 0 
    let l:command=l:command . " -F filetype=" . self.language
  endif

  let l:command=l:command . " " . g:slack_file_upload_url
  let l:command=l:command . " | grep '\"ok\":false'"
  return l:command
endfunction

function! SlackMessage.aggregated_channels()
  let l:channels = self.channels
  if len(self.users) > 0
    let l:users = self.lookup_user_ids()
    for l:user in l:users
      call add(l:channels, l:user)
    endfor
  endif
  return l:channels
endfunction

function! SlackMessage.lookup_user_ids()
  let l:user_ids = []
  for username in self.users
    let l:user_id = self.lookup_user_id(username)
    call add(l:user_ids, l:user_id)
  endfor
  return l:user_ids
endfunction

function! SlackMessage.lookup_user_id(username)
  let l:command="curl -s"
  let l:command=l:command . " -F token=" . self.token
  let l:command=l:command . " -F email='" . a:username . "@" . g:slack_email_domain . "'"
  let l:command=l:command . " " . g:slack_user_lookup_by_email_url

  let l:output = system(l:command)
  let l:id = matchstr(l:output, '"id" *: *"\zs.\{-}\ze"')
  if l:id == ""
    throw l:output
  endif
  return l:id
endfunction
