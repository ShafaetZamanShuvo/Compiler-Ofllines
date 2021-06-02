%option noyywrap

%x STRING_AFTER_QUOTE
%x STRING_AFTER_SLASH
%x AFTER_DOUBLE_SLASH
%x AFTER_SLASH_STAR

%{
#include<iostream>
#include<stdlib.h>
#include<string.h>
#include "1705086_symtab.h"
#include "y.tab.h"


using namespace std;


void yyerror(char *);

extern int line_count=1;
extern int error=0;

char lex2char(string s)
	{
		if(s[1] != '\\')
		{
			return s[1];
		}
		if (s[1] == '\\')
		{
			if(s[2] == 'n') { return (char) 10;}
			else if(s[2] == 't') { return (char) 9;}
			else if(s[2] == '\\') { return (char) 92 ;}
			else if(s[2] == '\'') { return (char) 39;}
			else if(s[2] == 'a') { return (char) 7;}
			else if(s[2] == 'f') { return (char) 12;}
			else if(s[2] == 'r') { return (char) 13;}
			else if(s[2] == 'b') { return (char) 8;}
			else if(s[2] == 'v') { return (char) 11;}
			else if(s[2] == '0') { return (char) 0;}	
		}
		return 'o';	
	}



string lex2string(string s) {	
	string str = "";
	int len = s.length();
	int i = 0;
	for(i = 0; i<len-1; i++)
	{
		if(s[i] == '\\' && s[i+1] == 'n') { str.append(1u,'\n'); i++;}
		else if(s[i] == '\\' && s[i+1] == 't') { str.append(1u,'\t'); i++;}
		else if(s[i] == '\\' && s[i+1] == 'a') { str.append(1u,'\a'); i++;}
		else if(s[i] == '\\' && s[i+1] == 'f') { str.append(1u,'\f'); i++;}
		else if(s[i] == '\\' && s[i+1] == 'r') { str.append(1u,'\r'); i++;}
		else if(s[i] == '\\' && s[i+1] == 'b') { str.append(1u,'\b'); i++;}
		else if(s[i] == '\\' && s[i+1] == 'v') { str.append(1u,'\v'); i++;}
		else if(s[i] == '\\' && s[i+1] == '0') { str.append(1u,'\0'); i++;}
		else {str.append(1u,s[i]);}
	}
	return str;	}
/*
void comment(string s)
{
	string c = "";
	int len = c.length();
	int i = 0;
	for (i = 0; i<len ; i++) {c.append(1u, c[i]);}
}*/

void countLine (string s) {
	int len = s.length();	
	for(int i=0; i<len; i++) {
		if(s[i] == '\n') line_count++; }
	
	return ; }
%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
LETTER_PLUS [a-zA-Z_]
DIGIT [0-9]
NEWLINE \n
COMM_END \*\/


%%

{NEWLINE} { line_count++; }

"if"	{ return IF;	}
		
"else"	{return ELSE;}

"for"	{ return FOR;	}

"while" {return WHILE;}

"do"	{ return DO;	}
		
"int"	{ return INT;	}
										
"char" { return CHAR;	}

"float" { return FLOAT; 	}

"double" { return DOUBLE;	}

"void"	{ return VOID;	}

"return"	{ return RETURN;	}

"default"	{ return DEFAULT;	}
		
		

"<"|"<="|">"|">="|"=="|"!="	{
	SymbolInfo *s=new SymbolInfo(yytext,"RELOP");
	yylval.symbol=s;
	return RELOP;
	}	
	
"=" 	{ return ASSIGNOP;}					
					
					
"++" { return INCOP;}

"--" { return DECOP;}					
					
"+"|"-" 	{
	
			SymbolInfo *s=new SymbolInfo(yytext,"ADDOP");
			yylval.symbol=s;
			return ADDOP;
			
		}
"*"|"/"|"%" 	{
	
			SymbolInfo *s=new SymbolInfo(yytext,"MULOP");
			yylval.symbol=s;
			return MULOP;
			
		}
"&&"|"||" {	
		SymbolInfo *s=new SymbolInfo(yytext,"LOGICOP");
		yylval.symbol=s;
		return LOGICOP;
	}
		
"!" 	{return NOT;}

"(" {return LPAREN;}

")" 	{return RPAREN;}

"{" 	{return LCURL;}

"}" 	{return RCURL;}

"[" 	{return LTHIRD;}

"]" 	{return RTHIRD;}

"," 	{return COMMA;}																							
		
";"	{return SEMICOLON;}		
"printf" {return PRINTLN;}
						

		
		
{DIGIT}+ 	{
				SymbolInfo *s=new SymbolInfo(yytext,"CONST_INT");
				yylval.ival=s;
				return CONST_INT;
		}
({DIGIT}+(\.{DIGIT}+)?|(\.{DIGIT}+))([Ee][+-]?{DIGIT}+)?	{
								SymbolInfo *s=new SymbolInfo(yytext,"CONST_FLOAT");
								yylval.fval=s;
								return CONST_FLOAT;

							}
'([ !-~]{-}['\\])'|'\\[ntvfrab0\\']'  {  
						SymbolInfo *s=new SymbolInfo(yytext,"CONST_CHAR");
						yylval.cval=s;
						return CONST_CHAR;
					}
[a-zA-Z][0-9a-zA-Z_]*	{	
			SymbolInfo *s=new SymbolInfo(yytext,"ID");
				yylval.id=s;
				return ID;
			}					
					

"\"" {
	BEGIN STRING_AFTER_QUOTE;
	 }

<STRING_AFTER_QUOTE>([\t !-~]{-}[\"])*(\\[ntvfrab0\\"'?e])*\" {
								////fprintf(tokenout,"<STRING,");
								string s = lex2string(yytext);
								int i = 0;
								for(i = 0; i< s.length(); i++)
								{
								 	//fprintf(tokenout,"%c",s[i]);
								}
								//fprintf(tokenout,">");
								////fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme \"%s found\n",line_count,yytext);
								cout << "Line no " << line_count << " TOKEN <STRING>  \""<< yytext << " found" <<endl<<endl;
								//cout << "This is a string after quote"<< endl;
								//cout << lex2string(yytext) <<endl;
								BEGIN INITIAL;
							}
							
								 					
<STRING_AFTER_QUOTE>([\t !-~]{-}[\"])*(\\[ntvfrab0\\"'?e])*\\ {
								BEGIN STRING_AFTER_SLASH;
								//fprintf(tokenout,"<STRING,");
								string s = lex2string(yytext);
								int i = 0;
								for(i = 0; i< s.length(); i++)
								{
								 	//fprintf(tokenout,"%c",s[i]);
								}
								////fprintf(tokenout,">");
								////fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s found\n",line_count,yytext);
								cout << "Line no " << line_count << " TOKEN <STRING> "<< yytext << " found" <<endl<<endl;
								//cout << "This is a string after slash hidgdswhd"<< endl;
								//cout << lex2string(yytext) <<endl;
							}
							
							
<STRING_AFTER_SLASH>([\t !-~]{-}[\"])*(\\[ntvfrab0\\"'?e])*\\ { 
											BEGIN STRING_AFTER_SLASH;
											line_count++;
											////fprintf(tokenout,"<STRING,");
											string s = lex2string(yytext);
											int i = 0;
											for(i = 0; i< s.length(); i++)
											{
											 	//fprintf(tokenout,"%c",s[i]);
											}
											////fprintf(tokenout,">");
											////fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s found\n",line_count,yytext);
											cout << "Line no " << line_count << " TOKEN <STRING> "<< yytext << " found" <<endl<<endl;
											
											//cout << "This is a string after slash"<< endl;
											//cout << lex2string(yytext) <<endl;

										}	
																			
																		
<STRING_AFTER_SLASH>([\t !-~]{-}[\"])*(\\[ntvfrab0\\"'?e])*\" { 
										BEGIN INITIAL;
										line_count++;
										////fprintf(tokenout,"<STRING,");
										string s = lex2string(yytext);
										int i = 0;
										for(i = 0; i< s.length(); i++)
										{
										 	//fprintf(tokenout,"%c",s[i]);
										}
										//fprintf(tokenout,">");
										////fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s found\n",line_count,yytext);
										cout << "Line no " << line_count << " TOKEN <STRING> "<< yytext << " found" <<endl<<endl;
										//cout << "This is a string after slash ending"<< endl;
										//cout << lex2string(yytext) <<endl;
										}	
								

("/*")([^*]|\*[^\/])*("*/") {
													
				
				countLine(yytext);   				
				}
\/\/([\t !-~]*(\\\n))*([\t !-~]*([\t !-~]{-}[\\]))*	{
				   			
				   			countLine(yytext);
				  			 }
{DIGIT}+(\.{DIGIT}+)(\.{DIGIT}+)+ {
					error++;
					////fprintf(logout,"Error at line no %d: Too many decimal points %s\n",line_count,yytext);
					cout << "Error at Line no " << line_count << " too many decimal points "<< yytext <<endl<<endl;
					}
																  			 						
(\.)*((\.{DIGIT}+)|({DIGIT}+\.?{DIGIT}*))(\.+{DIGIT}*)* {
							error++;
							////fprintf(logout,"Error at line no %d: Too many decimal points %s\n",line_count,yytext);
							cout << "Error at Line no " << line_count << " too many decimal points "<< yytext <<endl<<endl;
							
							}							
							
({DIGIT}+\.?{DIGIT}*)(\.+{DIGIT}*)*([Ee][+-]?({DIGIT}+\.?{DIGIT}*|\.{DIGIT}+)(\.+{DIGIT}*)*)* {
							error++;
							////fprintf(logout,"Error at line no %d: Ill formed number %s\n",line_count,yytext);
							cout << "Error at Line no " << line_count << " ill formed number "<< yytext <<endl<<endl;
							
							}

{DIGIT}+{LETTER_PLUS}+ {	
				error++;
				////fprintf(logout,"Error at line no %d: Invalid prefix on ID or invalid suffix on Number %s\n",line_count,yytext);
				cout << "Error at line no "<<line_count<< " Invalid prefix on ID or invalid suffix on number "<<yytext <<endl<<endl;
			}	
'' { 
						
						error++;
						////fprintf(logout,"Error at line no %d: Empty character constant error %s\n",line_count, yytext);
						cout << "Error at Line no " << line_count << " empty character constant error "<< yytext <<endl<<endl;
	}
				


'((([ -~]{-}['\\])|(\\[nt\\frabv0\"e?']))*)' { 
						
						error++;
						////fprintf(logout,"Error at line no %d: Multi character constant error %s\n",line_count, yytext);
						cout << "Error at Line no " << line_count << " multi character constant error "<< yytext <<endl<<endl;


	}
	
'((([ -~]{-}['\\])|(\\[nt\\frabv0\"e?']))*)	{ 
						
						error++;
						////fprintf(logout,"Error at line no %d: Unterminated Character %s\n",line_count, yytext);
						cout << "Error at Line no " << line_count << " unterminated character "<< yytext <<endl<<endl;


	}
	
<STRING_AFTER_SLASH>([\t !-~]{-}[\"\\])*(\\[ntvfrab0\\"'?e])* { 
									error++;
								
								cout << "Error at Line no " << line_count << " unfinished string "<< yytext <<endl<<endl;
								
								BEGIN INITIAL;
									
								}
<STRING_AFTER_QUOTE>([\t !-~]{-}[\"\\])*(\\[ntvfrab0\\"'?e])* {
								
								error++;
								
								cout << "Error at Line no " << line_count << " unfinished string "<< yytext <<endl<<endl;
								
								BEGIN INITIAL;
							}

("/*")([^*]|\*[^\/])*	{	
				error++;
				////fprintf(logout,"Error at line no %d: Unfinished comment %s\n",line_count, yytext);
				cout << "Error at Line no " << line_count << " unfinished comment "<< yytext <<endl<<endl;
				countLine(yytext);
				}
														
										   
						

{WHITESPACE} {}
. {
	error++;
	////fprintf(logout,"Error at line no %d: Unrecognized char %s\n",line_count, yytext);
	cout << "Error at Line no " << line_count << " unrecognized character "<< yytext <<endl<<endl;
	//countLine(yytext);
	
	}		

%%
/*
int yywrap(void)
{
	return 1;
}

*/




