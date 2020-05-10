" VIM syntax file
" Language: pburg
" Mainteiner: Ricardo Caetano
" Last Change: May 10 2020
" Version: 1.0
" Options: {{{1
"
if exists("b:current_syntax")
	syntax clear
endif

if has("folding")
	com! -nargs=+ SynFold	<args> fold
else
	com! -nargs=+ SynFold	<args>
endif

let s:Cpath= fnameescape(expand("<sfile>:p:h").(exists("g:pburg_uses_cpp")? "/cpp.vim" : "/c.vim"))
if !filereadable(s:Cpath)
	for s:Cpath in split(globpath(&rtp,(exists("g:pburg_uses_cpp")? "syntax/cpp.vim" : "syntax/c.vim")),"\n")
		if filereadable(fnameescape(s:Cpath))
			let s:Cpath= fnameescape(s:Cpath)
			break
  	endif
	endfor
endif
exe "syn include @pburgCode ".s:Cpath

"	Pburg Clusters: {{{1
syn cluster pburgInitCluster	contains=pburgKey,pburgKeyActn,pburgBrkt,pburgType,pburgString,pburgUnionStart,pburgHeader2,pburgComment,pburgDefines,pburgParseParam,pburgParseOption
syn cluster pburgRulesCluster	contains=pburgNonterminal,pburgString,pburgComment

" Pburg Sections: {{{1
SynFold syn	region	pburgInit	start='.'ms=s-1,rs=s-1	matchgroup=pburgSectionSep		end='^%%\ze\(\s*/[*/].*\)\=$'me=e-2,re=e-2	contains=@pburgInitCluster	nextgroup=pburgRules	skipwhite skipempty contained
SynFold syn	region	pburgInit2      start='\%^.'ms=s-1,rs=s-1	matchgroup=pburgSectionSep		end='^%%\ze\(\s*/[*/].*\)\=$'me=e-2,re=e-2	contains=@pburgInitCluster	nextgroup=pburgRules	skipwhite skipempty
SynFold syn	region	pburgHeader2	matchgroup=pburgSep	start="^\s*\zs%{"		end="^\s*%}"			contains=@pburgCode	nextgroup=pburgInit	skipwhite skipempty contained
SynFold syn	region	pburgHeader	matchgroup=pburgSep	start="^\s*\zs%{"		end="^\s*%}"			contains=@pburgCode	nextgroup=pburgInit	skipwhite skipempty
SynFold syn	region	pburgRules	matchgroup=pburgSectionSep	start='^%%\ze\(\s*/[*/].*\)\=$'	end='^%%\ze\(\s*/[*/].*\)\=$'me=e-2,re=e-2	contains=@pburgRulesCluster	nextgroup=pburgEndCode	skipwhite skipempty contained
SynFold syn	region	pburgEndCode	matchgroup=pburgSectionSep	start='^%%\ze\(\s*/[*/].*\)\=$'	end='\%$'			contains=@pburgCode	contained

" Pburg Commands: {{{1
syn	match	pburgDefines	'^%define\s\+.*$'
syn	match	pburgParseParam	'%\(parse\|lex\)-param\>'		skipwhite	nextgroup=pburgParseParamStr
syn	match	pburgParseOption '%\%(api\.pure\|pure-parser\|locations\|error-verbose\)\>'
syn	region pburgParseParamStr	contained matchgroup=Delimiter	start='{'	end='}'	contains=cStructure

syn	match pburgDelim	"[:|]"	contained
syn	match	pburgOper	"@\d\+"	contained

syn	match	pburgKey	"^\s*%\(token\|type\|left\|right\|start\|ident\|nonassoc\)\>"	contained
syn	match	pburgKey	"\s%\(prec\|expect\)\>"	contained
syn	match	pburgKey	"\$\(<[a-zA-Z_][a-zA-Z_0-9]*>\)\=[\$0-9]\+"	contained
syn	keyword	pburgKeyActn	yyerrok yyclearin	contained

syn	match	pburgUnionStart	"^%union"	skipwhite skipnl nextgroup=pburgUnion	contained
SynFold syn	region	pburgUnion	matchgroup=pburgCurly start="{" matchgroup=pburgCurly end="}" contains=@pburgCode	contained
syn	match	pburgBrkt	"[<>]"	contained
syn	match	pburgType	"<[a-zA-Z_][a-zA-Z0-9_]*>"	contains=pburgBrkt	contained

SynFold syn	region	pburgNonterminal	start="^\s*\a\w*\ze\_s*\(/\*\_.\{-}\*/\)\=\_s*:"	matchgroup=pburgDelim end=";"	matchgroup=pburgSectionSep end='^%%$'me=e-2,re=e-2 contains=pburgAction,pburgDelim,pburgString,pburgComment	contained
syn	region	pburgComment	start="/\*"	end="\*/"
syn	region	pburgComment	start="//"	end="$"
syn	match	pburgString	"'[^']*'"	contained

" I'd really like to highlight just the outer {}.  Any suggestions??? {{{1
syn	match	pburgCurlyError	"[{}]"
SynFold syn	region	pburgAction	matchgroup=pburgCurly start="{" end="}" 	contains=@pburgCode,pburgVar		contained
syn	match	pburgVar	'\$\d\+\|\$\$\|\$<\I\i*>\$\|\$<\I\i*>\d\+'	containedin=cParen,cPreProc,cMulti	contained

" Pburg synchronization: {{{1
syn sync fromstart


if !exists("skip_pburg_syn_inits")
  hi def link pburgBrkt	pburgStmt
	hi def link pburgComment	Comment
	hi def link pburgCurly	Delimiter
	hi def link pburgCurlyError	Error
	hi def link pburgDefines	cDefine
	hi def link pburgDelim	Delimiter
  hi def link pburgKeyActn	Special
  hi def link pburgKey	pburgStmt
	hi def link pburgNonterminal	Function
	hi def link pburgOper	pburgStmt
	hi def link pburgParseOption	cDefine
	hi def link pburgParseParam	pburgParseOption
	hi def link pburgSectionSep	Todo
	hi def link pburgSep	Delimiter
	hi def link pburgStmt	Statement
	hi def link pburgString	String
	hi def link pburgType	Type
	hi def link pburgUnionStart	pburgKey
	hi def link pburgVar	Special
endif

" Cleanup: 
delcommand SynFold
let b:current_syntax = "pburg"


"  Modelines: {{{1
" vim: ts=15 fdm=marker
