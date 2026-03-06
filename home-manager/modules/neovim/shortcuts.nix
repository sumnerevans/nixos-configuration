{ lib, ... }:
with lib;
let
  mkAuGroup =
    {
      name,
      commands,
      filetype,
    }:
    ''
      augroup ${name}
        autocmd!
        ${concatMapStringsSep "\n  " mkAutocmd (map (c: { filetype = filetype; } // c) commands)}
      augroup END
    '';
  mkAutocmd =
    {
      filetype,
      shortcut,
      action,
    }:
    "autocmd FileType ${filetype} inoremap ;${shortcut} ${action}";

  groups = [
    {
      name = "LaTeX";
      filetype = "tex";
      commands = [
        {
          shortcut = "bf";
          action = "\\textbf{<Esc>a";
        }
        {
          shortcut = "it";
          action = "\\textit{<Esc>a";
        }
        {
          shortcut = "tt";
          action = "\\texttt{<Esc>a";
        }
        {
          shortcut = "bb";
          action = "\\mathbb{<Esc>a";
        }
        {
          shortcut = "ta";
          action = "\\begin{tabular}<Enter>(<>)<Enter>\\end{tabular}<Esc>2kA{}<Esc>i";
        }
        {
          shortcut = "ol";
          action = "\\begin{enumerate}<Enter><Enter>\\end{enumerate}<Esc>kA\\item<Space>";
        }
        {
          shortcut = "ul";
          action = "\\begin{itemize}<Enter><Enter>\\end{itemize}<Esc>kA\\item<Space>";
        }
        {
          shortcut = "li";
          action = "\\item";
        }
        {
          shortcut = "sec";
          action = "\\section{<Esc>a";
        }
        {
          shortcut = "ssec";
          action = "\\subsection{<Esc>a";
        }
        {
          shortcut = "sssec";
          action = "\\subsubsection{<Esc>a";
        }
        {
          shortcut = "be";
          action = "\\begin{DELRN}(<>)<Enter>(<>)<Enter>\\end{DELRN}<Esc>2k0fR:call vm#commands#find_under(0,0)<Enter>:call vm#commands#find_next(0,0)<Enter>c";
        }
        {
          shortcut = "min";
          action = "\\begin{minted}{(<>)}<Enter>(<>)<Enter>\\end{minted}<Esc>2kA{}<Esc>i";
        }
        {
          shortcut = "int";
          action = "\\int_{(<>)}^{(<>)}<Space>(<>)<Esc>T{i";
        }
        {
          shortcut = "sum";
          action = "\\sum_{(<>)}^{(<>)}<Space>(<>)<Esc>T{i";
        }
        {
          shortcut = "verb";
          action = "\\verb\\|\\|<Esc>i";
        }
      ];
    }
    {
      name = "HTML";
      filetype = "html,xhtml,javascript.jsx";
      commands = [
        {
          shortcut = "s";
          action = "<strong></strong><Space>(<>)<Esc>FbT>i";
        }
        {
          shortcut = "em";
          action = "<em></em><Space>(<>)<Esc>FeT>i";
        }
        {
          shortcut = "h1";
          action = "<h1></h1><Esc>F>a";
        }
        {
          shortcut = "h2";
          action = "<h2></h2><Esc>F>a";
        }
        {
          shortcut = "h3";
          action = "<h3></h3><Esc>F>a";
        }
        {
          shortcut = "p";
          action = "<p></p><Esc>F<i";
        }
        {
          shortcut = "a";
          action = ''<a<Space>href="">(<>)</a><Space>(<>)<Esc>14hi'';
        }
        {
          shortcut = "ul";
          action = "<ul><Enter><li></li><Enter></ul><Esc>0k2f<i";
        }
        {
          shortcut = "li";
          action = "<li></li><Esc>F>a";
        }
        {
          shortcut = "ol";
          action = "<ol><Enter><li></li><Enter></ol><Esc>0k2f<i";
        }
        {
          shortcut = "div";
          action = ''<div class=""><Enter>(<>)<Enter></div><Esc>02kf"a'';
        }
        {
          shortcut = "tr";
          action = "<tr></tr><Esc>F<i";
        }
        {
          shortcut = "td";
          action = "<td></td><Esc>F<i";
        }
        {
          shortcut = "th";
          action = "<th></th><Esc>F<i";
        }
      ];
    }
    {
      name = "Python";
      filetype = "python";
      commands = [
        {
          shortcut = "def";
          action = "def ():<Enter><Space><Space><Space><Space>(<>)<Esc>0kf(i";
        }
        {
          shortcut = "pr";
          action = "print()<Esc>F(a";
        }
        {
          shortcut = "for";
          action = "for  in (<>):<Enter>(<>)<Esc>0kfrla";
        }
      ];
    }
    {
      name = "Go";
      filetype = "go";
      commands = [
        {
          shortcut = "pr";
          action = ''fmt.Printf("\n", )<Esc>F(la'';
        }
        {
          shortcut = "lfor";
          action = "for _,  := range (<>) { (<>) }<Esc>0f,la";
        }
        {
          shortcut = "for";
          action = "for  := range (<>) { (<>) }<Esc>0frla";
        }
      ];
    }
    {
      name = "JavaScript";
      filetype = "javascript";
      commands = [
        {
          shortcut = "$";
          action = "$().(<>)<Esc>2F(a";
        }
        {
          shortcut = "af";
          action = "<Space>=> (<>)<Esc>F=hi";
        }
        {
          shortcut = "cf";
          action = "((<>)) {<Enter>(<>)<Enter>}<Esc>02kf(i";
        }
        {
          shortcut = "cl";
          action = "console.log();<Esc>F(a";
        }
        {
          shortcut = "cs";
          action = "class  {<Enter>(<>)<Enter>}<Esc>2k$Fsla";
        }
        {
          shortcut = "fn";
          action = "function() {<Enter>(<>)<Enter>}<Esc>2k$F(a";
        }
        {
          shortcut = "for";
          action = "for () {<Enter>(<>)<Enter>}<Esc>02kf(a";
        }
        {
          shortcut = "if";
          action = "if () {<Enter>(<>)<Enter>}<Esc>02kf(a";
        }
        {
          shortcut = "let";
          action = "let  = (<>);<Esc>F=hi";
        }
        {
          shortcut = "x";
          action = "extends<Space>";
        }
        {
          shortcut = "im";
          action = "import  from '(<>)';<Esc>Ftla";
        }
        {
          shortcut = "var";
          action = "var  = (<>);<Esc>F=hi";
        }
      ];
    }
    {
      name = "Rust";
      filetype = "rust";
      commands = [
        {
          shortcut = "pr";
          action = ''println!("{}", );<Esc>hi'';
        }
      ];
    }
    {
      name = "CPP";
      filetype = "cpp";
      commands = [
        {
          shortcut = "pr";
          action = "cout <<  << endl;<Esc>2bhi";
        }
      ];
    }
    {
      name = "C_CUDA";
      filetype = "c,cuda";
      commands = [
        {
          shortcut = "pr";
          action = "printf();<Esc>hi";
        }
      ];
    }
  ];
in
{
  programs.neovim.extraConfig = ''
    inoremap ;g (<>)

    " Navigating with guides
    map <Space><Backspace> a(<>) <Esc>
    map <Space><Space> <Esc>/(<>)<Enter>"_c4l

    ${concatMapStringsSep "\n\n" mkAuGroup groups}
  '';
}
