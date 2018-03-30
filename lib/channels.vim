let g:SlackChannels = { "token": "", "channels": [], "users": [] }

function! SlackChannels.new(token, channels, users)
  let l:obj = copy(self)

  let l:obj.token = a:token
  let l:obj.channels = a:channels
  let l:obj.users = a:users

  if len(l:obj.channels) == 0 && len(l:obj.users) == 0
    throw "Please specify the channel(s) and/or users(s) you want to post this message to"
  endif
  return l:obj
endfunction

function! SlackChannels.aggregated_channels()
  let l:channels = self.channels
  if len(self.users) > 0
    let l:users = self.lookup_user_ids()
    for l:user in l:users
      call add(l:channels, l:user)
    endfor
  endif
  return l:channels
endfunction

function! SlackChannels.lookup_user_ids()
  let l:user_ids = []
  for username in self.users
    let l:user_id = self.lookup_user_id(username)
    call add(l:user_ids, l:user_id)
  endfor
  return l:user_ids
endfunction

function! SlackChannels.lookup_user_id(username)
  let l:command = g:slack_curl_binary . " -s"
  let l:command = l:command . " -F token=" . self.token
  let l:command = l:command . " -F email='" . self.get_email_address(a:username) . "'"
  let l:command = l:command . " " . g:slack_user_lookup_by_email_url

  let l:output = system(l:command)
  let l:id = matchstr(l:output, '"id" *: *"\zs.\{-}\ze"')
  if l:id == ""
    throw l:output
  endif
  return l:id
endfunction

function! SlackChannels.get_email_address(username)
  if a:username !~ "@" && len(g:slack_email_domain) > 0
    return a:username . "@" . g:slack_email_domain
  else
    return a:username
  endif
endfunction
