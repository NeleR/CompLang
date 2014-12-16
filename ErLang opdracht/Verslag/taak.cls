%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                    %%%
%%%   Class bestand voor het verslag van P&O: Computerwetenschappen.   %%%
%%%                                                                    %%%
%%%   Opties:                                                          %%%
%%%     tt1     Tussentijdsverslag 1                                   %%%
%%%     tt2     Tussentijdsverslag 2                                   %%%
%%%     tt3     Tussentijdsverslag 3                                   %%%
%%%     eind    Eindverslag                                            %%%
%%%                                                                    %%%
%%%   26 september 2012                                                %%%
%%%   Versie 1.0                                                       %%%
%%%                                                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%\NeedsTeXFormat{LaTeX2e}[1995/12/01]

\ProvidesClass{taak}[2012/09/25 v1.0 taak document class]
\def\thepagelimit{100}
\ProcessOptions
\LoadClass[10pt,a4paper]{article}
\RequirePackage{everypage}
\RequirePackage{geometry}
\RequirePackage{graphicx}

\geometry{margin=3cm}
\def\title#1{\def\thetitle{#1}}
\def\subtitle#1{\def\thesubtitle{#1}}
\def\italic#1{\def\theitalic{#1}}
\def\bold#1{\def\thebold{#1}}
\def\members#1{\def\themembers{#1}}
\def\year#1{\def\theyear{#1}}
\def\code#1{\def\thecode{#1}}
\def\course#1{\def\thecourse{#1}}
\def\prof#1{\def\theprof{#1}}

\def\maketitlepage{%
  \begin{titlepage}%
    \begin{center}%
      \@makelogo%
      \vfill%
      {\Huge\sc \thetitle}\\[0.75cm]%
      {\huge\bf \thesubtitle}%\\[0.4cm]%
      \vfill%
      \begin{minipage}{0.4\textwidth}%
        \begin{flushleft}%
          {\Large\em \theitalic} \\[6pt]%
          {\LARGE\bf \thebold}%
        \end{flushleft}%
      \end{minipage}\hfill%
      \begin{minipage}{0.6\textwidth}%
        \begin{flushright}%
          {\Large\sc \themembers\\}%
        \end{flushright}%
      \end{minipage}\\%
      \vspace{20mm}%
      {\large Academiejaar \theyear}%
    \end{center}%
  \end{titlepage}%
}
\def\@makelogo{%
  \hfil%
  \begin{minipage}{0.2\textwidth}%
    \centering%
    \includegraphics[height=\sedes@height]{sedes}%
  \end{minipage}%
  \begin{minipage}{0.7\textwidth}%
    {\huge\sf KU~Leuven}\\[10pt]%
    {\LARGE\sf Departement Computerwetenschappen}\\[10pt]%
    {\large \sf \thecode, \thecourse, prof. \theprof}%
  \end{minipage}%
  \hfil%
}
\def\sedes@height{3.4cm}
\def\pagelimittext{PAGE LIMIT}
\def\pagelimitfontsize{2cm}
\def\pagelimitscale{5}
\newcommand\sc@wm@inbox[1]{%
  \setbox\@tempboxa\vbox to \z@{%
    \vskip -1in \moveleft 1in \vbox{%
      \hbox to \z@{%
        #1\hss}%
    }%
    \vss%
  }
  \dp\@tempboxa\z@
  \box\@tempboxa%
}
\newcommand\sc@wm@printtext[1]{%
  \setlength{\@tempdimb}{.5\paperwidth}%
  \setlength{\@tempdimc}{-.5\paperheight}%
  \setlength{\unitlength}{1pt}%
  \put(\strip@pt\@tempdimb,\strip@pt\@tempdimc){%
    \makebox(0,0){%
      \rotatebox{45}{\scalebox{\pagelimitscale}{%
        \textcolor[gray]{0.7}%
          {\fontsize{\pagelimitfontsize}{1.2\pagelimitfontsize}\selectfont{\pagelimittext}}%
      }}%
    }%
  }%
}
\AddEverypageHook{%
  \ifnum\thepage>\thepagelimit%
    \sc@wm@inbox{\sc@wm@printtext}
  \fi
}
\def\makeappendix{%
  \appendix%
  \addtocontents{toc}{\protect\setcounter{tocdepth}{1}}%
}
\endinput

