command! -nargs=* -range=0 -complete=customlist,slack#complete Slack call slack#post(<q-args>)
