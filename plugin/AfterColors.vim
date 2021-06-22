" Vim Plugin: AfterColors.vim:
" Provides: Automatic sourcing of after/colors/ scripts.
" Author: Peter Hodge <toomuchphp-vim@yahoo.com>
" URL: http://www.vim.org/scripts/script.php?script_id=1641
" Version: 1.3
" Last Update: May 13, 2008
" Requires: Vim 6 or later (preferably 7) with autocommand support
"
"
" Minor Bug: if you just add your 'after/colors' scripts to
" 'vimfiles/after/colors/myColorsName.vim', when you go to
" use CTRL-D after the 'colors' command, vim will list
" 'myColorsName' twice, because it doesn't know that one of them
" is an 'after' script. I have sent an email to Bram regarding this
" bug, but as a work-around, I have made it possible that you can
" also put your scripts in an 'after_colors' folder:
"   vimfiles/after_colors/myColorsName.vim
" or
"   vimfiles/after/after_colors/myColorsName.vim
"
"
" Note: because you generally choose your colorscheme in
" _vimrc and plugins are loaded afterwards, the sequence files
" are loaded on startup may be a little confusing at first:
" -- Vim Load Sequence --
" 	1 - _vimrc
" 	2 - vimfiles/colors/myColorsName.vim
" 	3 - vimfiles/plugins/[plugins]
" 	4 - vimfiles/plugins/AfterColors.vim
" 	5 - vimfiles/plugins/[more plugins]
" 	6 - vimfiles/after_colors/myColorsName.vim

" requires vim 6 at least
if version <= 600 || exists('g:loaded_aftercolors') || ! has("autocmd")
	finish
endif

let g:loaded_aftercolors = 1

" provide ability for an 'after/colors' file using autocommands
augroup ex_aftercolors
	autocmd!

	" source the 'after' colors scripts only after vim has finished everything
	" else, because there are many things which will reset the colors
	if exists('##VimEnter')
		autocmd VimEnter * call <SID>after_colors_script()
	endif

	" if this vim has the 'Colorscheme' event, we can hook onto it to ensure
	" that the 'after' colors are reloaded when the colorscheme is changed
	if exists('##ColorScheme')
		autocmd ColorScheme * call <SID>after_colors_script()
	endif

augroup end

" " Relative path of script file:
" let s:path = expand('<sfile>')
"
" " Absolute path of script file:
" let s:path = expand('<sfile>:p')
"
" " Absolute path of script file with symbolic links resolved:
" let s:path = resolve(expand('<sfile>:p'))
"
" " Folder in which script resides: (not safe for symlinks)
" let s:path = expand('<sfile>:p:h')
"
" " If you're using a symlink to your script, but your resources are in
" " the same directory as the actual script, you'll need to do this:
" "   1: Get the absolute path of the script
" "   2: Resolve all symbolic links
" "   3: Get the folder of the resolved absolute file
let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
echomsg s:path
function! s:after_colors_script()
	if exists('g:colors_name') && strlen(g:colors_name)
		" allow global colors in 'common.vim'
		execute "source " . s:path . "/../after/colors/common.vim"

		" allow two places to store after/colors scripts
		execute "source " . s:path . "/../after/colors/common.vim"
		execute "source " . s:path . "/../after/colors/" . g:colors_name . '.vim'
	endif
endfunction

" vim:ts=4:sw=4:sts=4 et fdm=marker:
