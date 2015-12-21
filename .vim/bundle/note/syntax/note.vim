if exists("b:current_syntax")
    finish
endif

highlight nAttention cterm=bold ctermfg=1
highlight nQuestion term=bold ctermfg=6  
highlight nHeader   cterm=bold,underline ctermfg=3*
highlight nCLStart term=standout, ctermfg=4, ctermbg=248
highlight nCLDone  term=standout, ctermfg=2*
highlight nCLWarn term=standout, ctermfg=3*
highlight nCLError term=standout, ctermfg=1

"Attention 
syntax region noteAttention start=/\~\~/ end=/\~\~/
highlight link noteAttention nAttention

"Headers 
"syntax keyword noteHeader QUESTIONS TODO NOTES DESCRIPTION YESTERDAY TODAY GOALS
"syntax region noteHeader start=/#/ end=/\n/
syntax match noteHeader /^[A-Z][\ -_?!]*$/
highlight link noteHeader nHeader 

"Questions
"syntax region noteQuestion start=/??/ end=/?/
syntax match noteQuestion /.*?$/
highlight link noteQuestion nQuestion 

"Checklist items
syntax match noteCLStart /^\s*\[\].*$/
highlight link noteCLStart nCLStart 
syntax match noteCLDone /^\s*\[\*\].*$/
highlight link noteCLDone nCLDone
syntax match noteCLWarn /^\s*\[\/\].*$/
highlight link noteCLWarn nCLWarn
syntax match noteCLError /^\s*\[X\].*$/
highlight link noteCLError nCLError
 
let b:current_syntax = "potion"
