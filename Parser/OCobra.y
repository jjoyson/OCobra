%{
  void yyerror (char *s);
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <math.h>
  int symbols[52];
 // char symbols1[256];
  int symbolVal(char symbol);
  void updateSymbolVal(char symbol, float val);
 // void updateSymbolVal1(char symbol, char* str);
  %}

%union {float num; char id;}         /* Yacc definitions */
%start line
%token print exit_command ABS SQRT
%token <num> number
%token <id> identifier
%type <num> line exp term 
%type <id> assignment //assignment1
%right '='
%left '+' '-'
%left '*' '/'
%left '^'

%%

 /* descriptions of expected inputs     corresponding actions (in C) */

line    : assignment ';'{;}
        | exit_command ';'{exit(EXIT_SUCCESS);}
        | print exp ';'{printf("Printing %f\n", $2);}
        | line assignment ';'{;}
        | line print exp ';'{printf("Printing %f\n", $3);}
        | line exit_command ';'{exit(EXIT_SUCCESS);}

;
assignment : identifier '=' exp  { updateSymbolVal($1,$3); }
;

/*assignment1: identifier '=' string {updateSymbolVal1($1, $3);}
;
*/
exp    : term			{$$ = $1;}
       | exp '+' exp          {$$ = $1 + $3;}
       | exp '-' exp          {$$ = $1 - $3;}
       | exp '*' exp	       {$$ = $1 * $3;}
       | exp '/' exp	       {$$ = $1 / $3;}
       | exp '^' exp	       {$$ = powf($1, $3);}
       | SQRT '('exp')'        {$$ = sqrtf($3);}
       | ABS '('exp')'		{$$ = fabs($3);}
;

term   : number                {$$ = $1;}
	| '-' number		{$$ = 0-$2;}
       | identifier             {$$ = symbolVal($1);}
       | '('exp')'		{$$ = $2;}
       
;

%%                     /* C code */

int computeSymbolIndex(char token)
{
  int idx = -1;
  if(islower(token)) {
    idx = token - 'a' + 26;
  } else if(isupper(token)) {
    idx = token - 'A';
  }
  return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
  int bucket = computeSymbolIndex(symbol);
  return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, float val)
{
  int bucket = computeSymbolIndex(symbol);
  symbols[bucket] = val;
}

/*void updateSymbolVal1(char symbol, char* str)
{
  int bucket = computeSymbolIndex(symbol);
  symbols[bucket] = str;
}
*/
int main (void) {
  /* init symbol table */
  int i;
  for(i=0; i<52; i++) {
    symbols[i] = 0;
  }

  return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 
