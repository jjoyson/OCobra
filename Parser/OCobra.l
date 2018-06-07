%{
#include "y.tab.h"
%}
%%
"print"    {return print}
"exit"     {return exit_command;}
"abs"	   { return ABS; }
"sqrt"	   {return SQRT;}
[a-zA-Z]   {yylval.id = yytext[0]; return identifier;}
[-]?[0-9]+.[0-9]*     {yylval.num = atof(yytext); return number;}
[ \t\n]    ;
[-+=/*^;()$]     {return yytext[0];}
.          {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}
