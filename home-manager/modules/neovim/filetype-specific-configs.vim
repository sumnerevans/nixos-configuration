" FILETYPE SPECIFIC CONFIGURATIONS
" =============================================================================
set modeline " allow stuff like vim: set spelllang=en_us at the top of files

" Automatically break lines at 80 characters on TeX/LaTeX, Markdown, and text
" files
" Enable spell check on TeX/LaTeX, Markdown, and text files
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal tw=80
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal linebreak breakindent
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal spell spelllang=en_gb
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal colorcolumn=80

" Automatically break lines at 100 characters when writing HTML files
" Enable spell check on HTML files
autocmd BufNewFile,BufRead *.html setlocal tw=100
autocmd BufNewFile,BufRead *.html setlocal spell spelllang=en_gb

" Automatically break lines at 80 characters when writing emails in mutt
" Enable spell check for emails in mutt and quotes file
autocmd BufRead *.email,$HOME/tmp/mutt-*,$HOME/tmp/neomutt-*,$HOME/.config/home-manager/modules/email/quotes setlocal tw=72
autocmd BufRead *.email,$HOME/tmp/mutt-*,$HOME/tmp/neomutt-*,$HOME/.config/home-manager/modules/email/quotes setlocal spell spelllang=en_gb
autocmd BufRead *.email,$HOME/tmp/mutt-*,$HOME/tmp/neomutt-*,$HOME/.config/home-manager/modules/email/quotes setlocal colorcolumn=72,80

" Use TAB = 2 spaces for a few file types
autocmd FileType javascript,json,xhtml,html,htmldjango,scss,less,yaml,css,markdown,rst,lisp,nix setlocal shiftwidth=2

" Disable folding on RST
autocmd FileType rst setlocal nofoldenable
