%%% modified by egreg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Copyright (c) 2011 Trey Hunner                                          %
%                                                                          %
%  Permission is hereby granted, free of charge, to any person obtaining   %
%  a copy of this software and associated documentation files (the         %
%  "Software"), to deal in the Software without restriction, including     %
%  without limitation the rights to use, copy, modify, merge, publish,     %
%  distribute, sublicense, and/or sell copies of the Software, and to      %
%  permit persons to whom the Software is furnished to do so, subject to   %
%  the following conditions:                                               %
%                                                                          %
%  The above copyright notice and this permission notice shall be          %
%  included in all copies or substantial portions of the Software.         %
%                                                                          %
%  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,         %
%  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF      %
%  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                   %
%  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE  %
%  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION  %
%  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION   %
%  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.         %
%                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ProvidesClass{invoice}

\LoadClass[12pt]{article}

\usepackage[letterpaper,hmargin=0.79in,vmargin=0.79in]{geometry}
\usepackage[parfill]{parskip} % Do not indent paragraphs
\usepackage{fp} % Fixed-point arithmetic
\usepackage{longtable}

\pagestyle{empty} % No page numbers
\linespread{1.5}

\setlength{\doublerulesep}{\arrayrulewidth} % Double rules look like one thick one

% variables for total cost and subcost, total hours and subhours
\def\totalcost{0}\def\subcost{0}
\def\totalhours{0}\def\subhours{0}

% Command for setting a default hourly rate
\newcommand{\hourlyrate}[1]{\def \@hourlyrate {#1}}
\hourlyrate{1}
\newcommand{\feetype}[1]{
    \textbf{#1}
    \\
}

% Formats inputed number with 2 digits after the decimal place
\newcommand*{\formatNumber}[1]{\FPround{\temp}{#1}{2}\temp} %

% Returns the total of counter
\newcommand*{\total}[1]{\formatNumber{#1}}

% Create an invoice table
\newenvironment{invoiceTable}{%
    % Create a new row from title, unit quantity, unit rate, and unit name
    \newcommand*{\unitrow}[4]{%
         \FPmul{\tempa}{##2}{##3}%
         \FPadd{\tempb}{\totalcost}{\tempa}%
         \global\let\totalcost\tempb
         \FPadd{\tempb}{\subcost}{\tempa}%
         \global\let\subcost\tempb
         ##1 & \formatNumber{##2} ##4 & \$\formatNumber{##3} & \$\FPmul{\temp}{##2}{##3}\formatNumber{\temp}%
         \\
    }%
    % Create a new row from title and expense amount
    \newcommand*{\feerow}[2]{%
         \FPadd{\tempa}{\totalcost}{##2}%
         \global\let\totalcost\tempa
         \FPadd{\tempa}{\subcost}{##2}%
         \global\let\subcost\tempa
         ##1 & & \$\formatNumber{##2} & \$\formatNumber{##2}%
         \\
    }%
    \newcommand{\subtotalNoStar}{%
        \textbf{Subtotal} & \textbf{\total{\subhours} hours} &  & \textbf{\$\total{\subcost}}%
        \gdef\subcost{0}%
        \gdef\subhours{0}%
        \\*[1.5ex]
    }%
    \newcommand{\subtotalStar}{%
        \textbf{Subtotal} & & & \textbf{\$\total{\subcost}}
        \gdef\subcost{0}%
        \\*[1.5ex]
    }%
    \newcommand{\subtotal}{%
         \hline
         \@ifstar
         \subtotalStar
         \subtotalNoStar
    }%
    % Create a new row from date and hours worked (use stored fee type and hourly rate)
    \newcommand*{\hourrow}[2]{%
        \FPadd{\tempa}{\totalhours}{##2}%
        \global\let\totalhours\tempa
        \FPadd{\tempa}{\subhours}{##2}%
        \global\let\subhours\tempa
        \unitrow{##1}{##2}{\@hourlyrate}{hours}%
    }%
    \setlength{\tabcolsep}{0.8ex}%
    \setlength\LTleft{0pt}%
    \setlength\LTright{0pt}%
    \begin{longtable}{@{\extracolsep{\fill}\hspace{\tabcolsep}} p{10cm} r r r }
    \hline
    \bfseries Description of Services & \multicolumn{1}{c}{\bfseries Quantity} & \multicolumn{1}{c}{\bfseries Unit Price} & \multicolumn{1}{c}{\bfseries Amount} \\*
    \hline\hline
    \endhead
}{
    \hline\hline\hline
    \bfseries Balance Due & & & \bfseries \$\total{\totalcost} \\
    \end{longtable}
}
