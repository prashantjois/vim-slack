let g:SlackSnippet = { "content_file_path": "", "title": "", "comment": "", "language": "" }

function! SlackSnippet.new(content_file_path, options)
  let l:obj = copy(self)

  let l:obj.content_file_path = a:content_file_path

  if has_key(a:options, "title")
    let l:obj.title = a:options.title
  endif

  if has_key(a:options, "comment")
    let l:obj.comment = a:options.comment
  endif

  if has_key(a:options, "language")
    let l:obj.language = a:options.language
  endif

  return l:obj
endfunction
