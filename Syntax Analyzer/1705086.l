%option noyywrap noyylineno
%x STRING_AFTER_QUOTE
%x STRING_AFTER_SLASH
%x AFTER_DOUBLE_SLASH
%x AFTER_SLASH_STAR

%{
#include<stdio.h>
#include<stdlib.h>
#include<bits/stdc++.h>
#include"1705086_symtab.h"

using namespace std;

int line_count=1;
int error = 0;

FILE *logout;
FILE *tokenout;
int bucket = 7;
int id = 1;

SymbolTable symtab(bucket,id,NULL);

void insert(string name, string type)
{	//cout << name << " " <<type <<endl;
	symtab.insert(name,type);
}
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



string lex2string(string s)
{	
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
	return str;	
}
/*
void comment(string s)
{
	string c = "";
	int len = c.length();
	int i = 0;
	for (i = 0; i<len ; i++) {c.append(1u, c[i]);}
}*/

void countLine(string s) 
{
	int len = s.length();	
	for(int i=0; i<len; i++) {
		if(s[i] == '\n') {
			line_count++;
		}
	}
	
	return ;
}



%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
LETTER_PLUS [a-zA-Z_]
DIGIT [0-9]
NEWLINE \n
COMM_END \*\/


%%

{NEWLINE} {line_count++;}

"if"	{
			fprintf(tokenout,"<IF>");
			//fprintf(logout,"Line no %d: TOKEN <IF> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <IF> "<< yytext << " found" <<endl<<endl;
		}
		
"else"	{
			fprintf(tokenout,"<ELSE>");
			//fprintf(logout,"Line no %d: TOKEN <ELSE> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <ELSE> "<< yytext << " found" <<endl<<endl;
		}

"for"	{
			fprintf(tokenout,"<FOR>");
			//fprintf(logout,"Line no %d: TOKEN <FOR> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <FOR> "<< yytext << " found" <<endl<<endl;
		}

"while"	{
			fprintf(tokenout,"<WHILE>");
			//fprintf(logout,"Line no %d: TOKEN <WHILE> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <WHILE> "<< yytext << " found" <<endl<<endl;
		}
"do"	{
			fprintf(tokenout,"<DO>");
			//fprintf(logout,"Line no %d: TOKEN <DO> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <DO> "<< yytext << " found" <<endl<<endl;
		}
"break"	{
			fprintf(tokenout,"<BREAK>");
			//fprintf(logout,"Line no %d: TOKEN <BREAK> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <BREAK> "<< yytext << " found" <<endl<<endl;
		}
"int"	{
			fprintf(tokenout,"<INT>");
			//fprintf(logout,"Line no %d: TOKEN <INT> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <INT> "<< yytext << " found" <<endl<<endl;
		}										
"char"	{
			fprintf(tokenout,"<CHAR>");
			//fprintf(logout,"Line no %d: TOKEN <CHAR> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <CHAR> "<< yytext << " found" <<endl<<endl;
		}
"float"	{
			fprintf(tokenout,"<FLOAT>");
			//fprintf(logout,"Line no %d: TOKEN <FLOAT> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <FLOAT> "<< yytext << " found" <<endl<<endl;
		}
"double"	{
			fprintf(tokenout,"<DOUBLE>");
			//fprintf(logout,"Line no %d: TOKEN <DOUBLE> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <DOUBLE> "<< yytext << " found" <<endl<<endl;
		}
"void"	{
			fprintf(tokenout,"<VOID>");
			//fprintf(logout,"Line no %d: TOKEN <VOID> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <VOID> "<< yytext << " found" <<endl<<endl;
		}
"return"	{
			fprintf(tokenout,"<RETURNS>");
			//fprintf(logout,"Line no %d: TOKEN <RETURNS> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <RETURNS> "<< yytext << " found" <<endl<<endl;
		}
"switch"	{
			fprintf(tokenout,"<SWITCH>");
			//fprintf(logout,"Line no %d: TOKEN <SWITCH> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <SWITCH> "<< yytext << " found" <<endl<<endl;
		}										
"case"		{
			fprintf(tokenout,"<CASE>");
			//fprintf(logout,"Line no %d: TOKEN <CASE> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <CASE> "<< yytext << " found" <<endl<<endl;
		}
"default"	{
			fprintf(tokenout,"<DEFAULT>");
			//fprintf(logout,"Line no %d: TOKEN <DEFAULT> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <DEFAULT> "<< yytext << " found" <<endl<<endl;
		}
"continue"	{
			fprintf(tokenout,"<CONTINUE>");
			//fprintf(logout,"Line no %d: TOKEN <CONTINUE> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <CONTINUE> "<< yytext << " found" <<endl<<endl;
		}
		
		

"<"|"<="|">"|">="|"=="|"!="		{
						fprintf(tokenout,"<RELOP,%s>",yytext);
						//fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);
						cout << "Line no " << line_count << " TOKEN <RELOP> "<< yytext << " found" <<endl<<endl;
						
					}
"=" 	{
	
			fprintf(tokenout,"<ASSIGNOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <ASSIGNOP> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <ASSIGNOP> "<< yytext << " found" <<endl<<endl;
			
		}					
					
					
"++"|"--" {
			fprintf(tokenout,"<INCOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <INCOP> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <INCOP> "<< yytext << " found" <<endl<<endl;
				
	  }					
					
"+"|"-" 	{
	
			fprintf(tokenout,"<ADDOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <ADDOP> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <ADDOP> "<< yytext << " found" <<endl<<endl;
			
		}
"*"|"/"|"%" 	{
	
			fprintf(tokenout,"<MULOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <MULOP> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <MULOP> "<< yytext << " found" <<endl<<endl;
			
		}
"&&" 	{
	
			fprintf(tokenout,"<LOGICOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <LOGICOP> "<< yytext << " found" <<endl<<endl;
			
		}
"||" 	{
	
			fprintf(tokenout,"<LOGICOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <LOGICOP> "<< yytext << " found" <<endl<<endl;
			
		}	
"!" 	{
	
			fprintf(tokenout,"<NOT,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <NOT> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <NOT> "<< yytext << " found" <<endl<<endl;
			
		}
"(" 	{
	
			fprintf(tokenout,"<LPAREN,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <LPAREN> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <LPAREN> "<< yytext << " found" <<endl<<endl;
		
		}
")" 	{
	
			fprintf(tokenout,"<RPAREN,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <RPAREN> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <RPAREN> "<< yytext << " found" <<endl<<endl;
			
		}
"{" 	{
	
			fprintf(tokenout,"<LCURL,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <LCURL> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <LCURL> "<< yytext << " found" <<endl<<endl;
			//enterscope
			
			id++;
			symtab.enterScope(bucket,id);
			
		}
"}" 	{
	
			fprintf(tokenout,"<RCURL,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <RCURL> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <RCURL> "<< yytext << " found" <<endl<<endl;
			//exitscope
			
			symtab.exitScope(id);
            		id--;
            		symtab.printLex();
            		
		}
"[" 	{
	
			fprintf(tokenout,"<LTHIRD,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <LTHIRD> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <LTHIRD> "<< yytext << " found" <<endl<<endl;
			
		}
"]" 	{
	
			fprintf(tokenout,"<RTHIRD,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <RTHIRD> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <RTHIRD> "<< yytext << " found" <<endl<<endl;
			
		}
"," 	{
	
			fprintf(tokenout,"<COMMA,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <COMMA> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <COMMA> "<< yytext << " found" <<endl<<endl;
			
		}																							
		
";"		{
			fprintf(tokenout,"<SEMICOLON, %s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <SEMICOLON> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <SEMICOLON> "<< yytext << " found" <<endl<<endl;
			

		}			
						

		
		
{DIGIT}+ 	{
				fprintf(tokenout,"<CONST_INT,%s>",yytext);
				//fprintf(logout,"Line no %d: TOKEN <CONST_INT> Lexeme %s found\n",line_count,yytext);
				cout << "Line no " << line_count << " TOKEN <CONST_INT> "<< yytext << " found" <<endl<<endl;
				insert(yytext, "CONST_INT");
				symtab.printLex();
				//insert in symbol table and print symbol table content(only non empty buckets)
		}
({DIGIT}+(\.{DIGIT}+)?|(\.{DIGIT}+))([Ee][+-]?{DIGIT}+)?	{
								fprintf(tokenout,"<CONST_FLOAT,%s>",yytext);
								//fprintf(logout,"Line no %d: TOKEN <CONST_FLOAT> Lexeme %s found\n",line_count,yytext);
								cout << "Line no " << line_count << " TOKEN <CONST_FLOAT> "<< yytext << " found" <<endl<<endl;
								insert(yytext, "CONST_FLOAT");
								symtab.printLex();

							}
'([ !-~]{-}['\\])'|'\\[ntvfrab0\\']'  {  
						fprintf(tokenout,"<CONST_CHAR,%c>",lex2char(yytext));
						//fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count,yytext);
						cout << "Line no " << line_count << " TOKEN <CONST_CHAR> "<< yytext << " found" <<endl<<endl;
						insert(yytext, "CONST_CHAR");
						symtab.printLex();
					}
[a-zA-Z][0-9a-zA-Z_]*	{	
			fprintf(tokenout,"<ID,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <ID> Lexeme %s found\n",line_count,yytext);
			cout << "Line no " << line_count << " TOKEN <ID> "<< yytext << " found" <<endl<<endl;
			//insert in symbol table and print symbol table content(only non empty buckets)
			insert(yytext, "ID");
			symtab.printLex();
			
			}					
					

"\"" {
	BEGIN STRING_AFTER_QUOTE;
	//cout << "After Quote Started" <<endl;
	 }

<STRING_AFTER_QUOTE>([\t !-~]{-}[\"])*(\\[ntvfrab0\\"'?e])*\" {
								fprintf(tokenout,"<STRING,");
								string s = lex2string(yytext);
								int i = 0;
								for(i = 0; i< s.length(); i++)
								{
								 	fprintf(tokenout,"%c",s[i]);
								}
								fprintf(tokenout,">");
								//fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme \"%s found\n",line_count,yytext);
								cout << "Line no " << line_count << " TOKEN <STRING>  \""<< yytext << " found" <<endl<<endl;
								//cout << "This is a string after quote"<< endl;
								//cout << lex2string(yytext) <<endl;
								BEGIN INITIAL;
							}
							
								 					
<STRING_AFTER_QUOTE>([\t !-~]{-}[\"])*(\\[ntvfrab0\\"'?e])*\\ {
								BEGIN STRING_AFTER_SLASH;
								fprintf(tokenout,"<STRING,");
								string s = lex2string(yytext);
								int i = 0;
								for(i = 0; i< s.length(); i++)
								{
								 	fprintf(tokenout,"%c",s[i]);
								}
								//fprintf(tokenout,">");
								//fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s found\n",line_count,yytext);
								cout << "Line no " << line_count << " TOKEN <STRING> "<< yytext << " found" <<endl<<endl;
								//cout << "This is a string after slash hidgdswhd"<< endl;
								//cout << lex2string(yytext) <<endl;
							}
							
							
<STRING_AFTER_SLASH>([\t !-~]{-}[\"])*(\\[ntvfrab0\\"'?e])*\\ { 
											BEGIN STRING_AFTER_SLASH;
											line_count++;
											//fprintf(tokenout,"<STRING,");
											string s = lex2string(yytext);
											int i = 0;
											for(i = 0; i< s.length(); i++)
											{
											 	fprintf(tokenout,"%c",s[i]);
											}
											//fprintf(tokenout,">");
											//fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s found\n",line_count,yytext);
											cout << "Line no " << line_count << " TOKEN <STRING> "<< yytext << " found" <<endl<<endl;
											
											//cout << "This is a string after slash"<< endl;
											//cout << lex2string(yytext) <<endl;

										}	
																			
																		
<STRING_AFTER_SLASH>([\t !-~]{-}[\"])*(\\[ntvfrab0\\"'?e])*\" { 
										BEGIN INITIAL;
										line_count++;
										//fprintf(tokenout,"<STRING,");
										string s = lex2string(yytext);
										int i = 0;
										for(i = 0; i< s.length(); i++)
										{
										 	fprintf(tokenout,"%c",s[i]);
										}
										fprintf(tokenout,">");
										//fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s found\n",line_count,yytext);
										cout << "Line no " << line_count << " TOKEN <STRING> "<< yytext << " found" <<endl<<endl;
										//cout << "This is a string after slash ending"<< endl;
										//cout << lex2string(yytext) <<endl;
										}	
								

("/*")([^*]|\*[^\/])*("*/") {
													
				//fprintf(logout,"Line no %d: TOKEN <COMMENT> Lexeme %s found\n",line_count,yytext);
				cout << "Line no " << line_count << " TOKEN <COMMENT> "<< yytext << " found" <<endl<<endl;
				countLine(yytext);   				
				}
\/\/([\t !-~]*(\\\n))*([\t !-~]*([\t !-~]{-}[\\]))*	{
				   			//fprintf(logout,"Line no %d: TOKEN <COMMENT> Lexeme %s found\n",line_count,yytext);
				   			cout << "Line no " << line_count << " TOKEN <COMMENT> "<< yytext << " found" <<endl<<endl;
				   			countLine(yytext);
				  			 }
{DIGIT}+(\.{DIGIT}+)(\.{DIGIT}+)+ {
					error++;
					//fprintf(logout,"Error at line no %d: Too many decimal points %s\n",line_count,yytext);
					cout << "Error at Line no " << line_count << " too many decimal points "<< yytext <<endl<<endl;
					
					}
																  			 						
(\.)*((\.{DIGIT}+)|({DIGIT}+\.?{DIGIT}*))(\.+{DIGIT}*)* {
							error++;
							//fprintf(logout,"Error at line no %d: Too many decimal points %s\n",line_count,yytext);
							cout << "Error at Line no " << line_count << " too many decimal points "<< yytext <<endl<<endl;
							
							}							
							
({DIGIT}+\.?{DIGIT}*)(\.+{DIGIT}*)*([Ee][+-]?({DIGIT}+\.?{DIGIT}*|\.{DIGIT}+)(\.+{DIGIT}*)*)* {
							error++;
							//fprintf(logout,"Error at line no %d: Ill formed number %s\n",line_count,yytext);
							cout << "Error at Line no " << line_count << " ill formed number "<< yytext <<endl<<endl;
							
							}

{DIGIT}+{LETTER_PLUS}+ {	
				error++;
				//fprintf(logout,"Error at line no %d: Invalid prefix on ID or invalid suffix on Number %s\n",line_count,yytext);
				cout << "Error at line no "<<line_count<< " Invalid prefix on ID or invalid suffix on number "<<yytext <<endl<<endl;
			}	
'' { 
						
						error++;
						//fprintf(logout,"Error at line no %d: Empty character constant error %s\n",line_count, yytext);
						cout << "Error at Line no " << line_count << " empty character constant error "<< yytext <<endl<<endl;
	}
				


'((([ -~]{-}['\\])|(\\[nt\\frabv0\"e?']))*)' { 
						
						error++;
						//fprintf(logout,"Error at line no %d: Multi character constant error %s\n",line_count, yytext);
						cout << "Error at Line no " << line_count << " multi character constant error "<< yytext <<endl<<endl;


	}
	
'((([ -~]{-}['\\])|(\\[nt\\frabv0\"e?']))*)	{ 
						
						error++;
						//fprintf(logout,"Error at line no %d: Unterminated Character %s\n",line_count, yytext);
						cout << "Error at Line no " << line_count << " unterminated character "<< yytext <<endl<<endl;


	}
	
<STRING_AFTER_SLASH>([\t !-~]{-}[\"\\])*(\\[ntvfrab0\\"'?e])* { 
									error++;
								//fprintf(logout,"Error at Line no %d: Unfinished string \"%s found\n",line_count,yytext);
								cout << "Error at Line no " << line_count << " unfinished string "<< yytext <<endl<<endl;
								//cout << "This is a string after quote"<< endl;
								//cout << lex2string(yytext) <<endl;
								BEGIN INITIAL;
									
								}
<STRING_AFTER_QUOTE>([\t !-~]{-}[\"\\])*(\\[ntvfrab0\\"'?e])* {
								//fprintf(tokenout,"<STRING,");
								//fprintf(tokenout,">");
								error++;
								//fprintf(logout,"Error at Line no %d: Unfinished string \"%s found\n",line_count,yytext);
								cout << "Error at Line no " << line_count << " unfinished string "<< yytext <<endl<<endl;
								//cout << "This is a string after quote"<< endl;
								//cout << lex2string(yytext) <<endl;
								BEGIN INITIAL;
							}

("/*")([^*]|\*[^\/])*	{	
				error++;
				//fprintf(logout,"Error at line no %d: Unfinished comment %s\n",line_count, yytext);
				cout << "Error at Line no " << line_count << " unfinished comment "<< yytext <<endl<<endl;
				countLine(yytext);
				}
														
										   
						

{WHITESPACE} {}
. {
	error++;
	//fprintf(logout,"Error at line no %d: Unrecognized char %s\n",line_count, yytext);
	cout << "Error at Line no " << line_count << " unrecognized character "<< yytext <<endl<<endl;
	countLine(yytext);
	
	}					
			

%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	//logout= fopen("log.txt","w");
	logout = freopen("log.txt", "w", stdout);
	tokenout= fopen("token.txt","w");

	yyin= fin;
	yylineno = 1;
	yylex();
	//fprintf(logout,"Total lines: %d.\nTotal errors : %d\n\n",line_count-1,error);
	cout << "Total lines : " <<line_count-1 <<endl<<endl<< " Total Errors : "<<error<<endl; 
	fclose(yyin);
	

	fclose(tokenout);
	fclose(logout);
	return 0;
}
