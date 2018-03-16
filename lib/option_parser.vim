let g:OptionParser = {}

function! OptionParser.parse(kwargs, valid_variables)
  let l:variables = {}
  let l:variable=""
  let l:arguments = s:shellwords(a:kwargs)
  for l:argument in l:arguments
    if l:argument =~ '^-'
      let l:variable = substitute(l:argument, '^-', '', '')
      if index(a:valid_variables, l:variable) < 0
        throw "Unknown option '" . l:argument . "'"
      endif
    else
      if len(l:variable) == 0
        throw "Unknown option '" . l:argument . "'"
        break
      endif
      exec 'let l:variables.' . l:variable . ' = ' . "'" . substitute(l:argument, "'", "''", "l") . "'"
    endif
  endfor

  return l:variables
endfunction

function! s:shellwords(str)
  " File: gist.vim
  " Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
  " License: BSD
  " see: https://github.com/mattn/gist-vim/blob/master/autoload/gist.vim#L112
  let l:words = split(a:str, '\%(\([^ \t\''"]\+\)\|''\([^\'']*\)''\|"\(\%([^\"\\]\|\\.\)*\)"\)\zs\s*\ze')
  let l:words = map(l:words, 'substitute(v:val, ''\\\([\\ ]\)'', ''\1'', "g")')
  let l:words = map(l:words, 'matchstr(v:val, ''^\%\("\zs\(.*\)\ze"\|''''\zs\(.*\)\ze''''\|.*\)$'')')

  return l:words
endfunction
