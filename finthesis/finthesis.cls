\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{finthesis}[2022/08/08 Faculty of Engineering, University of Kragujevac thesis class]

\newif\if@master
\newif\if@bachelor
\newif\if@finalthesis
\newif\if@hints
\newif\if@usehyperref
\newif\if@pdfmetadata
\newif\if@courseissubject

\def\@nothesis{%
    \@masterfalse%
    \@bachelorfalse%
    \@finalthesisfalse%
}

\DeclareOption{master}{\@nothesis\@mastertrue}
\DeclareOption{bachelor}{\@nothesis\@bachelortrue}
\DeclareOption{finalthesis}{\@nothesis\@finalthesistrue}
\DeclareOption{hints}{\@hintstrue}
\DeclareOption{nohints}{\@hintsfalse}
\DeclareOption{usehyperref}{\@usehyperreftrue}
\DeclareOption{nousehyperref}{\@usehyperreffalse}
\DeclareOption{pdfmetadata}{\@pdfmetadatatrue}
\DeclareOption{nopdfmetadata}{\@pdfmetadatafalse}
\DeclareOption{pdfcoursesubject}{\@courseissubjecttrue}
\DeclareOption{nopdfcoursesubject}{\@courseissubjectfalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ExecuteOptions{bachelor,nohints,usehyperref,pdfmetadata,nopdfcoursesubject}
\ProcessOptions*\relax

% Base class and external package settings
\LoadClass[a4paper, oneside, 12pt]{article}
\RequirePackage[a4paper, margin=25mm]{geometry}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1, T2A]{fontenc}
\RequirePackage[english, serbianc]{babel}
\RequirePackage{enumitem}
\RequirePackage{varwidth}
\RequirePackage{listings}
\RequirePackage{datetime2}
\RequirePackage[style=numeric, sorting=none, defernumbers]{biblatex}
\RequirePackage{csquotes}
\RequirePackage[dvipsnames]{xcolor}
\if@usehyperref%
    \if@pdfmetadata \RequirePackage[linktoc=all,pdfusetitle,pdflang=sr-Cyrl,pdfduplex=Simplex,pdfpicktraybypdfsize=true]{hyperref}%
    \else \RequirePackage[linktoc=all]{hyperref}\fi%
    \RequirePackage[open,openlevel=2,numbered]{bookmark}%
\fi
\RequirePackage{caption}
\RequirePackage{parskip}

% hyperref
\ifcsname texorpdfstring\endcsname \else%
    \gdef\texorpdfstring #1#2{#1}%
\fi
\if@usehyperref
\if@pdfmetadata
\AtBeginDocument{%
    \hypersetup{
        pdfkeywords={%
            \@keywordsen%
            \ifx\@keywordsen\@empty\else%
                \ifx\@keywordssr\@empty\else , \fi%
            \fi \@keywordssr%
        },
    }

    \if@courseissubject \hypersetup{pdfsubject={\@course}} \fi
}
\fi
\fi

% lstlisting
\renewcommand*{\lstlistingname}{Листинг}
\newlength{\MaxSizeOfLineNumbers}
\newlength{\LineNumCharWidth}
\newcommand{\setlstmaxlinedigits}[1]{%
    \settowidth{\LineNumCharWidth}{\scriptsize 9}%
    \setlength{\MaxSizeOfLineNumbers}{\dimexpr\LineNumCharWidth*#1+10pt\relax}%
}
\setlstmaxlinedigits{2}
\definecolor{finNumber}{HTML}{949698}
\definecolor{finRule}{HTML}{949698}
\definecolor{finKeyword}{HTML}{228B22}
\definecolor{finComment}{rgb}{0.127,0.427,0.514}
\definecolor{finString}{rgb}{0.639,0.082,0.082}
\definecolor{finIdentifier}{HTML}{221E1F}
\lstset{
  aboveskip={\baselineskip},
  showstringspaces=false,
  columns=fullflexible,
  keepspaces=true,
  basicstyle={\small\fontencoding{T1}\fontfamily{fvm}\selectfont},
  numbers=left,
  numberstyle=\scriptsize\color{finNumber},
  keywordstyle=\color{finKeyword}\bfseries,
  commentstyle=\color{finComment}\ttfamily\itshape,
  stringstyle=\color{finString}\ttfamily,
  identifierstyle=\color{finIdentifier},
  frame=leftline,
  rulecolor=\color{finRule},
  xleftmargin=\MaxSizeOfLineNumbers,
  breaklines=true,
  postbreak=\mbox{\ensuremath{\hookrightarrow}\space},
  tabsize=2,
  upquote=true,
  extendedchars=true,
  inputencoding=utf8,
}

% datetime2
\DTMnewdatestyle{sr-dot}{%
  \renewcommand*{\DTMdisplaydate}[4]{\number##3.~\number##2.~##1\DTMfinaldot}%
  \renewcommand*{\DTMDisplaydate}{\DTMdisplaydate}%
}
\DTMnewdatestyle{onlyyear}{%
  \renewcommand*{\DTMdisplaydate}[4]{##1\DTMfinaldot}%
  \renewcommand*{\DTMDisplaydate}{\DTMdisplaydate}%
}
\DTMsetdatestyle{sr-dot}

% biblatex
\renewcommand*{\newunitpunct}{\addcomma\space} % Use comma for punctuation instead of period
\DeclareFieldFormat{url}{\url{#1}}
% \DefineBibliographyExtras{serbianc}{\renewcommand{\mkbibdateshort}[3]{%
%     \iffieldundef{#3}{}{\mkday{\thefield{#3}}\addperiod}%
%     \iffieldundef{#2}{}{\mkmonth{\thefield{#2}}\addperiod}%
%     \iffieldbibstring{#1}{\bibstring{\thefield{#1}}}%
%     {\dateeraprintpre{#1}\mkyearzeros{\thefield{#1}}\adddot}%
% }}

% article
\renewcommand*{\date}[1]{%
    {\DTMsetdatestyle{iso}%
    \global\edef\@date{#1}}%
}
\let\oldtableofcontents\tableofcontents
\if@usehyperref%
    \AddToHook{cmd/tableofcontents/before}{\newpage\pdfbookmark[section]{\contentsname}{toc}}%
\fi
\AddToHook{cmd/tableofcontents/after}{\newpage}
\let\oldsection\section
\AddToHook{cmd/section/before}{\clearpage}
% -------------------------

% Utility commands
\if@hints%
    \newcommand{\@fieldemptyhint}[1]{%
        \expandafter\ifx\csname @#1\endcsname\@empty {(\normalfont искористити наредбу \texttt{\textbackslash #1\{\ldots\})}}%
        \else \csname @#1\endcsname \fi%
    }
\else
    \newcommand{\@fieldemptyhint}[1]{\csname @#1\endcsname}
\fi

\newlength{\@currentparskip}

% Committee commands and typesetting
\newcommand\nextcommitteemember{}
\newcommand\missingcommitteemember{}

\newcommand*{\mincommitteemembers}{3}
\newcounter{@committeecount}
\setcounter{@committeecount}{1}

\newcommand\@committeemembers{}
\newcommand*{\committee}[1]{%
    \g@addto@macro\@committeemembers{\nextcommitteemember #1}%
    \stepcounter{@committeecount}%
}

\newcounter{@iteratemissing}
\newcommand{\@committeemissing}{%
    \setcounter{@iteratemissing}{\value{@committeecount}}
    \@whilenum \value{@iteratemissing} < \mincommitteemembers \do
        {\stepcounter{@iteratemissing} \nextcommitteemember \missingcommitteemember}
}

\newcommand\@enumeratecommittee{%
    \gdef\nextcommitteemember{\item}%
    \gdef\missingcommitteemember{\hrulefill}%
    \begin{enumerate}[left=0pt]
        \nextcommitteemember
        \ifx\@advisor\@empty
            \if@hints \@fieldemptyhint{advisor}
            \else Титула, име и презиме ментора\fi
        \else
            \@advisor
        \fi ~- ментор
        \@committeemembers
        \@committeemissing
    \end{enumerate}%
    \if@hints \ifnum\value{@committeecount}=1
        \par{\normalfont Чланови комисије се додају помоћу наредбе\\\texttt{\string\committee\{\ldots\}}.}\par
    \fi \fi
}

% titlepagebib commands and typesetting
\newcommand{\nexttpbib}{}

\newif\if@hastpbibs
\@hastpbibsfalse

\newcommand{\@tpbibs}{}

\newcommand*{\titlepagebib}[1]{%
    \@hastpbibstrue
    \g@addto@macro\@tpbibs{\nocite{#1}}%
}

\newcommand{\@enumeratetpbibs}{%
    \if@hastpbibs%
        \newrefsection%
        \@tpbibs%
        \printbibliography[heading=none]%
        \newrefsection%
    \else%
        \begin{enumerate}[label={[\arabic*]}]%
            \item%
            \if@hints Препоручена литература се додаје помоћу наредбе \texttt{\string\titlepagebib\{key\}}, где је \texttt{key} кључ из \texttt{.bib} датотеке.%
            \else \makebox[30ex]{\leavevmode\cleaders\hbox to 5pt{\hss .\hss }\hfill\kern0pt} \fi%
            %\makebox[3cm]{\dotfill}
        \end{enumerate}%
    \fi%
}

% Field commands
\newcommand\@newpublicfield[2][\@empty]{%
    \expandafter\newcommand\csname #2\endcsname[1]{%
        \expandafter\gdef\csname @#2\endcsname{##1}%
    }%
    \global\expandafter\let\csname @#2\endcsname#1%
}

\@newpublicfield{studid}
\@newpublicfield{advisor}
\@newpublicfield{advisorfull}
\@newpublicfield{studprog}
\@newpublicfield{module}
\@newpublicfield{course}
\@newpublicfield{studentshould}
\@newpublicfield{thesisapplicationfile}
\@newpublicfield{abstracten}
\@newpublicfield{keywordsen}
\@newpublicfield{abstractsr}
\@newpublicfield{keywordssr}

\if@hints % Don't let base class complain if these fields are not defined, typeset hints instead
    \global\let\@date\@empty
    \global\let\@author\@empty
    \global\let\@title\@empty
\fi

% Determine wording based on thesis type
\if@master
    \gdef\@thesistype{Мастер рад}
    \gdef\@studtype{Мастер академске студије}
    \newcommand*{\thesiscase}[1]{мастер}
\else\if@bachelor
    \gdef\@thesistype{дипломски рад}
    \gdef\@studtype{Основне академске студије}
    \newcommand*{\thesiscase}[1]{дипломск#1}
\else\if@finalthesis
    \gdef\@thesistype{завршни рад}
    \gdef\@studtype{Основне академске студије}
    \newcommand*{\thesiscase}[1]{завршн#1}
\else
    \gdef\@thesistype\@empty
    \gdef\@studtype\@empty
    \newcommand*{\thesiscase}[1]{\@empty}
\fi
\fi
\fi

\gdef\@studentshouldbeginning{У оквиру овог \thesiscase{ог}\ рада кандидат треба да}

\renewcommand{\maketitle}{%
    \firsttitlepage%
    \secondtitlepage%
    \thirdtitlepage%
    \fourthtitlepage%
}

\newcommand{\firsttitlepage}{\begin{titlepage}
    \bfseries
    \centering

    {\fontsize{15pt}{15pt}\selectfont
    Универзитет у Крагујевцу\par\medskip
    Факултет инжењерских наука Универзитета у Крагујевцу\par}

    \vfill

    {\fontsize{18pt}{18pt}\selectfont\@fieldemptyhint{author}\par\vspace{30pt}}
    {\fontsize{24pt}{24pt}\selectfont\@fieldemptyhint{title}\par\vspace{30pt}}
    {\fontsize{18pt}{18pt}\selectfont\@thesistype\par}

    \vfill

    {\fontsize{14pt}{14pt}\selectfont Крагујевац,
    \ifx\@date\@empty \@fieldemptyhint{date}
    \else \DTMsetdatestyle{onlyyear}\DTMdate{\@date} \fi}
\end{titlepage}}

\newcommand{\secondtitlepage}{\begin{titlepage}
    \bfseries

    \begin{center}
        \fontsize{15pt}{15pt}\selectfont
        Универзитет у Крагујевцу\par\smallskip
        Факултет инжењерских наука Универзитета у Крагујевцу\par\medskip
        \includegraphics[height=22mm]{finthesis_assets/unikg_logo}
        \qquad
        \includegraphics[height=22mm]{finthesis_assets/fink_logo}\par\smallskip
    \end{center}

    {\fontsize{12pt}{12pt}\selectfont
    Назив студијског програма: \@fieldemptyhint{studprog}\par
    Ниво студија: \@studtype\par
    \ifx\@module\@empty \else
        Модул: \@module\par
    \fi
    Предмет: \@fieldemptyhint{course}\par
    Број индекса: \@fieldemptyhint{studid}\par}

    \vspace{\stretch{1}}

    \begin{center}
        \fontsize{18pt}{18pt}\selectfont\@fieldemptyhint{author}\par\bigskip
        \fontsize{24pt}{24pt}\selectfont\@fieldemptyhint{title}\par\bigskip
        \fontsize{18pt}{18pt}\selectfont\@thesistype\par
    \end{center}

    \vspace{\stretch{2}}

    \setlength{\@currentparskip}{\parskip}
    \begin{minipage}[b]{0.55\linewidth}
        \setlength{\parskip}{\@currentparskip}
        \fontsize{14pt}{14pt}\selectfont Комисија за преглед и одбрану:
        \fontsize{11pt}{11pt}\selectfont \@enumeratecommittee
    \end{minipage}
    \hfill
    \begin{minipage}[b]{0.35\linewidth}
        \setlength{\parskip}{\@currentparskip}
        \fontsize{11pt}{11pt}\selectfont
        \normalfont
        Датум одбране: \hrulefill\par
        Оцена: \hrulefill\par
    \end{minipage}
\end{titlepage}}

\newcommand{\thirdtitlepage}{\begin{titlepage}
    \fontsize{11pt}{11pt}\selectfont
    \@studentshouldbeginning%
    \if@hints
        \
        \ifx\@studentshould\@empty (наставак овог текста се дефинише помоћу наредбе \texttt{\string\studentshould\{текст\}}).
        \else \ignorespaces\@studentshould \fi
    \else
        \ifx\@studentshould\@empty \ldots
        \else \ \ignorespaces\@studentshould \fi
    \fi \par

    \vfill

    Препоручена литература:\par
    \AtNextBibliography{\fontsize{11pt}{11pt}\selectfont}
    \@enumeratetpbibs

    \vfill

    \setlength{\@currentparskip}{\parskip}
    \begin{varwidth}[t]{0.45\linewidth}
        \raggedright
        \setlength{\parskip}{\@currentparskip}
        Крагујевац,
        \ifx\@date\@empty \@fieldemptyhint{date}
        \else \DTMdate{\@date} \fi
    \end{varwidth}
    \hfill
    \begin{varwidth}[t]{0.45\linewidth}
        \setlength{\parskip}{\@currentparskip}
        \centering
        Ментор:\par
        \@fieldemptyhint{advisorfull}
        \par\mbox{}\\\hrulefill
    \end{varwidth}
\end{titlepage}}

\newcommand{\fourthtitlepage}{\begin{titlepage}
    \ifx\@thesisapplicationfile\@empty
        \if@hints
            \null
            \vfill
            На овој страни треба да се налази скенирана оверена пријава \thesiscase{ог}\ рада. Путања до датотеке која садржи пријаву дефинише се преко наредбе:

            \centering\texttt{\string\thesisapplicationfile\{path\_to\_file.pdf\}}
            \vfill
            \null
        \else
            \null
        \fi
    \else
        \newgeometry{margin=0mm}
        \parbox[][\paperheight][c]{\paperwidth}{
            \centering
            \includegraphics[width=\linewidth, height=\textheight, keepaspectratio]{\@thesisapplicationfile}
        }
    \fi
\end{titlepage}}

\newcommand{\makeabstract}{%
        \newpage
        \thispagestyle{plain}

        \begin{otherlanguage*}{english}
            {\centering\large\bfseries Abstract\par}

            \medskip

            \ifx\@abstracten\@empty
                \if@hints English abstract is defined via the command \texttt{\string\abstracten\{text\}}. \fi
            \else
                \ignorespaces\@abstracten\par
            \fi

            {\sloppy
            \textbf{Keywords:}
            \ifx\@keywordsen\@empty
                \if@hints English keywords are defined via the command\\
                \texttt{\string\keywordsen\{text\}} \fi
            \else
                \ignorespaces\@keywordsen.\par
            \fi}
        \end{otherlanguage*}

        \bigskip\bigskip

        {\centering\large\bfseries Резиме\par}

        \medskip

        \ifx\@abstractsr\@empty
            \if@hints Резиме на српском се дефинише помоћу наредбе \texttt{\string\abstractsr\{текст\}}. \fi
        \else
            \ignorespaces\@abstractsr\par
        \fi

        {\sloppy
        \textbf{Кључне речи:}
        \ifx\@keywordssr\@empty
            \if@hints Кључне речи на срском се дефинишу помоћу наредбе\\
            \texttt{\string\keywordssr\{текст\}}. \fi
        \else
            \ignorespaces\@keywordssr.\par
        \fi}

        \clearpage
}

\newcommand{\makebibliography}{%
    \clearpage%
    {\sloppy%
    \printbibliography[heading=bibintoc]}%
}
