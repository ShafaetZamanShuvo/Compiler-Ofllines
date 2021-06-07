%{
#include<bits/stdc++.h>	
#include<iostream>
#include<cstdlib>	
#include<cmath>
#include "1705086_symtab.h"


using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
FILE *logout;
FILE *errorout;

extern int line_count;
extern int error;
int semantic_error = 0;

int bucket = 30;
int id = 1;

SymbolTable symtab(bucket,id,NULL);

int return_status = 0;
string return_type;
string current_ret_type;

void yyerror(char *s)
{
	//write your code
}
// type specifier
string var_type; // int float char etc
//variable_declarartion
string specifier_type; //int float char etc
string var_name; // x , y, z etx
//unit
string var_declaration_name; // int x, y, z;
string func_declaration_name;
string func_definition_name;
//start
string unit_name; 

string code_segment ; // int x,y,z;
//parameter list
string parameter_type; // int float char
int position;
string parameter_name;
vector<SymbolInfo*> parameters;
//program
vector <string> code_list;
//var_declaration
string bracket_material; // 5 6 8 etc
int size;
//function_declaration
string func_name;
string func_type;
//arguments
vector<SymbolInfo*> args;
string logic_name;
//factor
string int_name;
string float_name;

// unary_expression
string factor_name;
string factor_type;

//term
string unary_expression_name;

//simple_expression
string term_name;

//rel_expression
string simple_expression_name;

//logic_expression
string rel_expression_name;

//expression
string logic_expression_name;

//variable
string expression_name;

//arguments

string arguments_name;

//factor
string variable_name;
string variable_identity;

//statement
string expression_statement_name;
string compound_statement_name;
string loop_statement;
string conditional_statement;
string return_statement;

//statements
string statement_name;

//compound_statement
string statements_name;

//func_definition
vector<SymbolInfo*> variables_in_scope;
SymbolInfo *currentFunc;


string int2s(int n)
{
	string s;
	s = to_string(n);
	return s;
}

void scopeParameters()
{

	for (int i = 0; i < parameters.size(); ++i)
	{
		if (symtab.insert(parameters[i]-> getName(), "ID"))
		{
			

			SymbolInfo *temp = symtab.Lookup(parameters[i]->getName());
			temp->setVarType(parameters[i]->getVarType());
			temp->size = parameters[i]->size;
		}
		else
		{
			semantic_error++;
			fprintf(errorout, "Error at line %d: Multiple declaration of %s\n", line_count, parameters[i]->getName().c_str() );
			cout << "Error at line "<< line_count << ":" << " Multiple declaration of "<< parameters[i]->getName() <<endl <<endl;
		}
	}

	parameters.clear();
}


%}


%union{
	SymbolInfo *ival;
	SymbolInfo *fval;
	SymbolInfo *cval;
	SymbolInfo *id;
	SymbolInfo *symbol;
}
%token INT FLOAT VOID SEMICOLON IF DO WHILE FOR ELSE CHAR DOUBLE RETURN DEFAULT ASSIGNOP INCOP DECOP NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA PRINTLN

%token<id> ID
%token<ival> CONST_INT
%token<fval> CONST_FLOAT
%token<cval> CONST_CHAR
%token<symbol> ADDOP
%token<symbol> MULOP
%token<symbol> RELOP
%token<symbol> LOGICOP
%token<symbol> BITOP

%type<symbol> type_specifier
%type<symbol> declaration_list
%type<symbol> var_declaration
%type<symbol> unit
%type<symbol> parameter_list
%type<symbol> func_declaration
%type<symbol> logic_expression
%type<symbol> factor
%type<symbol> unary_expression
%type<symbol> term
%type<symbol> simple_expression
%type<symbol> rel_expression
%type<symbol> expression
%type<symbol> variable
%type<symbol> arguments
%type<symbol> argument_list
%type<symbol> func_definition
%type<symbol> expression_statement
%type<symbol> statement
%type<symbol> statements
%type<symbol> compound_statement





//%left 
//%right

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE


%%
/*
input :
	  | input statements
	  ;*/
start : program
	  {
		cout<< "Line " <<line_count<<":"<< " start : program " << endl << endl;
		// int count = code_list.size();
		// for (int i = 0; i < count; ++i)
		// {
		// 	cout << code_list[i]<<endl << endl;
		// }
		symtab.PrintAllScope();
	  }
	  ;

program : program unit
        {
        	cout<< "Line " <<line_count<<":"<< " program : program unit " << endl << endl;
        	unit_name = $2->getName();
        	code_list.push_back(unit_name);

        	for(int i = 0; i< code_list.size(); i++)
        	{
        		cout << code_list[i] << endl;
        	}
        }
        | unit 
		{
			unit_name = $1->getName();
			code_list.push_back(unit_name);

			cout<< "Line " <<line_count<<":"<< " program : unit " << endl << endl;
			cout<< unit_name << endl << endl;
		}	
	   ;
	
unit : var_declaration 
	 {	
	 	var_declaration_name = $1->getName();

	 	SymbolInfo *s;
	 	s = new SymbolInfo(var_declaration_name, "unit");
	 	$$ = s;

	 	cout<< "Line " <<line_count<<":"<< " unit : var_declaration " << endl << endl;
	 	cout<< var_declaration_name << endl << endl;


	 }
	 | func_declaration
	 {
	 	func_declaration_name = $1->getName();



	 	SymbolInfo *s;
	 	s = new SymbolInfo(func_declaration_name, "unit");
	 	$$ = s;

	 	cout<< "Line " <<line_count<<":"<< " unit : func_declaration " << endl << endl;
	 	cout<< func_declaration_name << endl << endl;

	 }
	 | func_definition
	 {
	 	func_definition_name = $1->getName();
	 	//cout << func_definition_name << endl;

	 	SymbolInfo *s;
	 	s = new SymbolInfo(func_definition_name, "unit");
	 	$$ = s;

	 	cout<< "Line " <<line_count<<":"<< " unit : func_definition " << endl << endl;
	 	cout<< func_definition_name<< endl << endl;
	 }
	 
     ;

func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
				 {
				 	cout<< "Line " <<line_count<<":"<< " func_declaration : type_specifier ID LPAREN  parameter_list RPAREN SEMICOLON " << endl << endl;
				 	
				 	func_name = $2->getName();
				 	func_type = $1->getType();

                 	if(symtab.insert(func_name,"ID"))  // not inserted before
                 	{
                 		
                 		//symtab.printLex();
                 		SymbolInfo *temp;
                 		temp = symtab.Lookup(func_name);
                 		temp->setRetType(func_type);
                 		temp->setIdentity("function_declaration");

                 		size = $4->edge.size();

                 		for (int i = 0; i < size; ++i)
                 		{
                 			temp->edge.push_back($4->edge[i]);
                 		}
                 	}

                 	else  
                 	{
                 		semantic_error++;
                 		fprintf(errorout,"Error at line %d: redeclaration of function %s", line_count, func_name);
						 cout << "Error at line " << line_count << ":" << " redeclaration of function "<< func_name << endl << endl;

                 	}

                 	code_segment = "";
                 	code_segment += func_type + " " + func_name  + "(";

                 	size = $4->edge.size();

					//fprintf(errorout," edge size %d",size); 

               		for (int i = 0; i < size; ++i)
               		{
               			if(i < (size - 1))
               			{
               				parameter_type = $4->edge[i]-> getType();
               				parameter_name = $4->edge[i]-> getName();
               				code_segment += parameter_type +" "+parameter_name +",";
               			}
               			else
               			{
               				parameter_type = $4->edge[i]-> getType();
               				parameter_name = $4->edge[i]-> getName();
               				code_segment += parameter_type +" "+parameter_name +");";
               			}
               			
               		}

               		SymbolInfo * s;
               		s = new SymbolInfo(code_segment, "func_declaration");
               		$$ = s;

               		parameters.clear();

               		cout<< code_segment <<endl << endl;

				 }
                 | type_specifier ID LPAREN RPAREN SEMICOLON
				 {
				 	cout<< "Line " <<line_count<<":"<< " func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON " << endl << endl;

				 	//check if the name of the function already exists or not
				 	func_name = $2->getName();
				 	func_type = $1->getType();



				 

                 	if(symtab.insert(func_name,"ID"))  // not inserted before
                 	{
                 		
                 		//symtab.printLex();
                 		SymbolInfo *temp;
                 		temp = symtab.Lookup(func_name);
                 		temp->setRetType(func_type);
                 		temp->setIdentity("function_declaration");
                 	}
                 	else
                 	{
                 		semantic_error++;
                 		fprintf(errorout,"Error at line %d: redeclaration of function %s", line_count, func_name);
						 cout << "Error at line " << line_count << ":" << " redeclaration of function "<< func_name << endl << endl;

                 	}

                 	code_segment = "";
                 	code_segment += func_type+ " " + func_name  + "(" +")" +";";

                 	SymbolInfo *s;
                 	s = new SymbolInfo(code_segment,"func_declaration");
                 	$$ = s;

                 	cout << code_segment << endl << endl;
				 }
				 ;

func_definition : type_specifier ID LPAREN parameter_list RPAREN {id++; symtab.enterScope(bucket,id); scopeParameters();} compound_statement
				{

					cout<< endl;
					symtab.PrintAllScope();
					cout<< "Line " <<line_count<<":"<< " func_definition : type_specifier ID LPAREN  parameter_list RPAREN compound_statement " << endl << endl;

					code_segment = $1->getType() + " " + $2->getName() + "(";

					for (int i = 0; i < $4->edge.size(); ++i)
					{
						if( i == $4->edge.size() - 1)
						{
							code_segment += $4-> edge[i]->getType() + " " + $4->edge[i]->getName()+ ")";
						}
						else
						{
							code_segment += $4-> edge[i]->getType() + " " + $4->edge[i]->getName() + ",";
						}
					}

					code_segment += $7->getName();

					cout << code_segment << endl;

					SymbolInfo *s;
					s= new SymbolInfo(code_segment, "func_definition");
					$$=s;

					// cout << "current id of scope : " << id << endl; 
					 variables_in_scope = symtab.GetAllSymbolsInCurrentScope();
					// cout << "printing the variables" << endl;
					// for (int i = 0; i < variables_in_scope.size(); ++i)
					// {
					// 	cout<< variables_in_scope[i]->getName() << " "<< variables_in_scope[i]->getType() << endl;
					// }
					// cout << endl;
					//symtab.PrintAllScope();
					symtab.exitScope(id);
					//id--;
					//cout << "current id of scope : " << id << endl;

					//symtab.insert($2->getName(), "ID");
					
					return_type = $1->getType();

					if (return_status == 1)
					{
						if ($1->getType() == "void")
						{
							semantic_error++;
							fprintf(errorout,"Error at line %d: type_specifier is of type void, can't have return status\n", line_count);
							cout << "Error at line " << line_count << ":" << " type_specifier is of type void, can't have return status"<< endl << endl;
						}
					}
					if (return_status == 0)
					{
						if ($1->getType() != "void")
						{
							semantic_error++;
							fprintf(errorout,"Error at line %d: type_specifier is not of type void, but no return status", line_count);
							cout << "Error at line " << line_count << ":" << " type_specifier is not of type void, but no return status"<< endl << endl;
							

						}
					}
					if(return_type != $1->getType())
					{
						semantic_error++;
						//fprintf(errorout, "\n found error here \n" );
						//fprintf(errorout, "\n  %s  \n",return_type.c_str() );
						//fprintf(errorout, "\n  %s  \n",$1->getType().c_str() );
						fprintf(errorout,"Error at line %d: mismatch of return type\n", line_count);
						cout << "Error at line no "<< line_count << ":" << " Return type mismatched" << endl <<endl;
					}

					return_status = 0;

					SymbolInfo *x;
					x= symtab.Lookup($2->getName());

					if(x != NULL)
					{

						if (x->getIdentity() != "function_declaration")
						{
							semantic_error++;
							fprintf(errorout,"Error at line %d: Multiple declaration of %s\n", line_count, $2->getName().c_str());
							cout << "Error at line "<< line_count << ":" << "Multiple declaration of "<< $2->getName() <<endl <<endl;
						}
						else
						{
							//matching the parameters
							if (x->edge.size() != $4->edge.size())
							{
								semantic_error++;
								fprintf(errorout,"Error at line %d: Total number of arguments mismatch with declaration in function %s\n", line_count,$2->getName().c_str());
								cout << "Error at line "<< line_count << ":" << " Total number of arguments mismatch with declaration in function "<< $2->getName() << endl <<endl;

							}
							else
							{
								int func = 1;
								for (int i = 0; i < $4->edge.size(); ++i)
								{
									if ($4->edge[i]->getName() != x->edge[i]->getName())
									{
										semantic_error++;
										fprintf(errorout,"Error at line %d: parameters not matched", line_count);
										cout << "Error at line " << line_count<<":" << " parameters not matched" << endl <<endl;
										func = 0;
										break;

									}
									else if ($4->edge[i]->getType() != x->edge[i]->getType())
									{
										semantic_error++;
										fprintf(errorout,"Error at line %d: parameters type not matched", line_count);
										cout << "Error at line " << line_count<<":" << " parameters type not matched" << endl <<endl;

										func = 0;
										break;	
									}
								}

								if (func == 1)
								{
									// parameters have been matched, now match the return types
									if ($1->getType() == x-> getRetType())
									{
										x->setIdentity("func_defined");

										for (int i = 0; i < variables_in_scope.size(); ++i)
										{
											x->edge.push_back(variables_in_scope[i]);
										}

										x->setRetType($1->getType());
										currentFunc = x;

									}
									else
									{
										semantic_error++;
										fprintf(errorout,"Error at line %d: Return type mismatch with function declaration in function %s\n", line_count, $2->getName().c_str());
										cout <<"Error at line " << line_count <<" Return type mismatch with function declaration in function " <<$2->getName() << endl;
										
									}
								}
								else
								{
									semantic_error++;
									fprintf(errorout,"Error at line %d: parameter_list  not matched", line_count);
									cout << "Error at line " << line_count <<":" <<" parameter_list  not matched" << endl << endl;
								}
							}
							
						}

					}

					else
					{
						symtab.insert($2->getName(), "ID");

						x = symtab.Lookup($2->getName());
						x->setRetType($1->getType());
						x->setVarType($1->getVarType());
						x->setIdentity("func_defined");

						for (int i = 0; i < variables_in_scope.size(); ++i)
						{
							x->edge.push_back(variables_in_scope[i]);
						}

						currentFunc = x;

					}



					
					//symtab.printLex();
					variables_in_scope.clear();
					
				}
				| type_specifier ID LPAREN RPAREN {id++; symtab.enterScope(bucket,id); scopeParameters();} compound_statement
				{
					symtab.PrintAllScope();

					cout<< "Line " <<line_count<<":"<< " func_definition : type_specifier ID LPAREN RPAREN compound_statement " << endl << endl;

					code_segment = $1->getType() + " " + $2->getName() + "()"+ $6->getName();

					cout << code_segment << endl;

					SymbolInfo *s;
					s= new SymbolInfo(code_segment, "func_definition");
					$$=s;

					//cout << "current id of scope : " << id << endl; 
					variables_in_scope = symtab.GetAllSymbolsInCurrentScope();
					// cout << "printing the variables " << variables_in_scope.size() << endl;
					// for (int i = 0; i < variables_in_scope.size(); ++i)
					// {
					// 	cout<< variables_in_scope[i]->getName() << " "<< variables_in_scope[i]->getType() << endl;
					// }
					// cout << endl;
					
					symtab.exitScope(id);
					//id--;
					//cout << "current id of scope : " << id << endl;

					//symtab.insert($2->getName(), "ID");

					if (return_status == 1)
					{
						if ($1->getType() == "void")
						{
							semantic_error++;
							fprintf(errorout,"Error at line %d: type_specifier is of type void, can't have return status\n", line_count);
							cout << "Error at line " << line_count <<":" <<"type_specifier is of type void, can't have return status\n" <<endl;
							
						}
					}
					if (return_status == 0)
					{
						if ($1->getType() != "void")
						{
							semantic_error++;
							fprintf(errorout,"Error at line %d: type_specifier is not of type void, but missing return status", line_count);
							cout << "Error at line " << line_count <<":" <<"type_specifier is not of type void, but missing status\n" <<endl;
						}
					}
					
					return_status = 0;


					SymbolInfo *x;
					x= symtab.Lookup($2->getName());

					if(x != NULL)
					{

						if (x->getIdentity() != "function_declaration")
						{
							semantic_error++;
							fprintf(errorout,"Error at line %d: Multiple declaration of %s\n", line_count, $2->getName().c_str());
							cout << "Error at line " << line_count <<":" <<" Multiple declaration of " << $2->getName()<<endl <<endl;
						}
						else
						{
							//matching the parameters
							if (x->edge.size()>0)
							{
								semantic_error++;
								fprintf(errorout,"Error at line %d: Total number of arguments mismatch with declaration in function %s\n", line_count,$2->getName().c_str());
								cout << "Error at line " << line_count <<":" <<" Total numer of arguments mismatch with declaration in function "<< $2->getName() <<endl <<endl;
							}
							else
							{
									// now match the return types
									if ($1->getType() == x-> getRetType())
									{
										x->setIdentity("func_defined");

										for (int i = 0; i < variables_in_scope.size(); ++i)
										{
											x->edge.push_back(variables_in_scope[i]);
										}

										x->setRetType($1->getType());
										currentFunc = x;

									}
									else
									{
										semantic_error++;
										fprintf(errorout,"Error at line %d: Return type mismatch with function declaration in function %s\n", line_count,$2->getName().c_str());
										cout << "Error at line " << line_count <<":" <<" Return type mismatch with declaration in function "<< $2->getName() <<endl <<endl;
									}	
							}
							
						}

					}

					else
					{
						symtab.insert($2->getName(), "ID");

						x = symtab.Lookup($2->getName());
						x->setRetType($1->getType());
						x->setVarType($1->getVarType());
						x->setIdentity("func_defined");

						for (int i = 0; i < variables_in_scope.size(); ++i)
						{
							x->edge.push_back(variables_in_scope[i]);
						}

						currentFunc = x;

					}

					
					//symtab.printLex();
					
				}
				;

parameter_list :parameter_list COMMA type_specifier ID
				{
					cout<< "Line " <<line_count<<":"<< " parameter_list : parameter_list COMMA type_specifier ID " << endl << endl;

               		parameter_name = $4->getName();
               		parameter_type = $3->getType();

               		SymbolInfo *x = new SymbolInfo(parameter_name,parameter_type);

               		$$->edge.push_back(x);

               		size = $$->edge.size();

               		for (int i = 0; i < size; ++i)
               		{
               			if(i < (size - 1))
               			{
               				parameter_type = $$->edge[i]-> getType();
               				parameter_name = $$->edge[i]-> getName();
               				cout << parameter_type << " " << parameter_name << ",";
               			}
               			else
               			{
               				parameter_type = $$->edge[i]-> getType();
               				parameter_name = $$->edge[i]-> getName();
               				cout<< parameter_type <<" "<< parameter_name<<endl << endl;
               			}
               			
               		}

               		position = $$->edge.size() - 1;

               		$$->edge[position]->setIdentity("variable");

               		SymbolInfo *temp = new SymbolInfo(parameter_name, "ID");
               		temp->size = $4->size;
               		temp->setVarType(parameter_type);

               		int n;
               		if(temp->size > 1)
               		{
               			n = temp->size;
               		}
               		else
               		{
               			n = 1;
               		}

               		if(parameter_type== "int") {temp->AllocateIntegerMemory(n);}
                 	else if(parameter_type == "float") {temp->AllocateFloatMemory(n);}
                 	else if(parameter_type== "char") {temp->AllocateCharMemory(n);}	

                 	parameters.push_back(temp);

				}
               |parameter_list COMMA type_specifier
			   {
			    	cout<< "Line " <<line_count<<":"<< " parameter_list : parameter_list COMMA type_specifier " << endl << endl;

			    	parameter_type = $3->getType();
			    	SymbolInfo *x = new SymbolInfo("",parameter_type);
			    	$$->edge.push_back(x);

			    	position = $$->edge.size() - 1;

               		$$->edge[position]->setIdentity("parameter");

               		size = $$->edge.size();

               		for (int i = 0; i < size; ++i)
               		{
               			if(i < (size - 1))
               			{
               				parameter_type = $$->edge[i]-> getType();
               				parameter_name = $$->edge[i]-> getName();
               				cout << parameter_type << " " << parameter_name << ",";
               			}
               			else
               			{
               				parameter_type = $$->edge[i]-> getType();
               				cout<< parameter_type <<endl << endl;
               			}
               			
               		}

               		
			   }
				
			   | type_specifier ID
               {	
               		//line_count--;
               		SymbolInfo *s;
               		s = new SymbolInfo("parameter_list");
               		$$ = s;

               		parameter_name = $2->getName();
               		parameter_type = $1->getType();

               		SymbolInfo *x = new SymbolInfo(parameter_name,parameter_type);

               		$$->edge.push_back(x);

               		position = $$->edge.size() - 1;

               		$$->edge[position]->setIdentity("variable");

               		SymbolInfo *temp = new SymbolInfo(parameter_name, "ID");
               		temp->size = $2->size;
               		temp->setVarType(parameter_type);

               		int n;
               		if(temp->size > 1)
               		{
               			n = temp->size;
               		}
               		else
               		{
               			n = 1;
               		}

               		if(parameter_type== "int") {temp->AllocateIntegerMemory(n);}
                 	else if(parameter_type == "float") {temp->AllocateFloatMemory(n);}
                 	else if(parameter_type== "char") {temp->AllocateCharMemory(n);}	

                 	parameters.push_back(temp);



               		cout<< "Line " <<line_count<<":"<< " parameter_list : type_specifier ID" << endl << endl;
               		cout<< parameter_type << " " << parameter_name <<endl << endl;

               }
               | type_specifier
               {
               		//line_count--;
               		SymbolInfo *s;
               		s = new SymbolInfo("parameter_list");
               		$$ = s;

               		parameter_type = $1->getType();

               		SymbolInfo *x = new SymbolInfo("",parameter_type);

               		$$->edge.push_back(x);

               		position = $$->edge.size() - 1;

               		$$->edge[position]->setIdentity("parameter");


               		cout<< "Line " <<line_count<<":"<< " parameter_list : type_specifier" << endl << endl;
               		cout<< parameter_type << endl << endl;
               }
               ; 		    

compound_statement : LCURL statements RCURL
				   {
				   	 cout<< "Line " <<line_count<<":"<< " compound_statement : LCURL statements RCURL" << endl << endl;
				   	 statements_name = "{";

				   	 size = $2->edge.size();
				   	 for (int i = 0; i < size; ++i)
				   	 {
				   	 	if(i == size -1)
				   	 	{
				   	 		statements_name += $2->edge[i]->getName() + "}" + "\n" ;
				   	 	}
				   	 	else{
				   	 		statements_name += $2->edge[i]->getName()+"\n";
				   	 	}
				   	 }

				   	 cout << statements_name << endl << endl;

				   	 SymbolInfo *s;
				   	 s= new SymbolInfo(statements_name, "compound_statement");
				   	 $$ = s;


				   } 
				   | LCURL RCURL
				   {
				   	 cout<< "Line " <<line_count<<":"<< " compound_statement :LCURL RCURL" << endl << endl;
				   	 cout << "{}";

				   	 SymbolInfo *s;
				   	 s = new SymbolInfo("{}","compound_statement");
				   	 $$ = s;
				   }           

statements : statement
		   {
		   	  statement_name = $1->getName();
              cout<< "Line " <<line_count<<":"<< " statements : statement " << endl << endl;
              cout << statement_name << endl<<endl;

              SymbolInfo *s;
              s= new SymbolInfo(statement_name, "statements");
              $$ = s;
              $$->edge.push_back($1); // wrote extra line

		   }
		   | statements statement
		   {
		   	 cout<< "Line " <<line_count<<":"<< " statements : statements statement " << endl << endl;

		   	 $1->edge.push_back($2);

		   	 size = $1->edge.size();

		   	 for (int i = 0; i < size; ++i)
		   	 {
		   	 	if(i == size -1)
		   	 	{
		   	 		cout << $1->edge[i]->getName() << endl<<endl;;
		   	 	}
		   	 	else
				cout << $1->edge[i]->getName();

		   	 }
		   }               
		   ;
statement : var_declaration
		  { 
		  	 $$ = $1;
		  	 var_declaration_name = $1->getName();
		  	 cout<< "Line " <<line_count<<":"<< " statement : var_declaration " << endl << endl;
		  	 cout << var_declaration_name << endl << endl;
		  } 
		  | expression_statement
		  {
		  	$$ = $1;
		  	expression_statement_name = $1->getName();
		  	cout<< "Line " <<line_count<<":"<< " statement : expression_statement " << endl << endl;
		  	cout << expression_statement_name << endl << endl;
		  }
		  | compound_statement
		  {
		    $$ = $1;
		  	compound_statement_name = $1->getName();
		  	cout<< "Line " <<line_count<<":"<< " statement : compound_statement " << endl << endl;
		  	cout << compound_statement_name << endl << endl;
		  }
		  | FOR LPAREN expression_statement expression_statement expression RPAREN statement
          {


          	cout<< "Line " <<line_count<<":"<< " statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement " << endl << endl;

          	loop_statement = "for(" + $3->getName() +$4->getName()+ $5-> getName() + ")"+ $7->getName(); 

          	SymbolInfo *s;
          	s = new SymbolInfo(loop_statement, "statement");
          	$$ = s;

          	cout << loop_statement << endl << endl;

          }
          | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
          {
          	cout<< "Line " <<line_count<<":"<< " statement : IF LPAREN expression RPAREN statement " << endl << endl;

          	conditional_statement = "if(" + $3->getName() + ")" + $5->getName();

          	SymbolInfo *s;
          	s = new SymbolInfo(conditional_statement, "statement");
          	$$ = s;

          	cout << conditional_statement << endl << endl;


          }
          | IF LPAREN expression RPAREN statement ELSE statement
          {
          	cout<< "Line " <<line_count<<":"<< " statement : IF LPAREN expression RPAREN statement  ELSE statement" << endl << endl;

          	conditional_statement = "if(" + $3->getName() + ")" + $5->getName() + "else" + $7->getName();

          	SymbolInfo *s;
          	s = new SymbolInfo(conditional_statement, "statement");
          	$$ = s;

          	cout << conditional_statement << endl << endl;

          }
          | WHILE LPAREN expression RPAREN statement
          {
          	cout<< "Line " <<line_count<<":"<< " statement : WHILE LPAREN expression RPAREN statement  ELSE statement" << endl << endl;

          	conditional_statement = "while(" + $3->getName() + ")" + $5->getName();

          	SymbolInfo *s;
          	s = new SymbolInfo(conditional_statement, "statement");
          	$$ = s;

          	cout << conditional_statement << endl << endl;
          }

          | PRINTLN LPAREN ID RPAREN SEMICOLON
          {
          	cout<< "Line " <<line_count<<":"<< " statement : PRINTLN LPAREN ID RPAREN SEMICOLON" << endl << endl;
          	cout << "printf(" << $3->getName() << ");"<<endl << endl;
			
			SymbolInfo *s;
			s= symtab.Lookup($3->getName());
			if(s == NULL)
			{
				semantic_error++;
				fprintf(errorout, "Error at line %d: Undeclared variable %s", line_count, $3->getName().c_str());
				cout << "Error at line " << line_count <<":" <<" Undeclared variable "<< $3->getName() <<endl <<endl;
			} 



          }
          | RETURN expression SEMICOLON
          {
            return_statement = "return " + $2->getName() + ";";
            return_status = 1;
            return_type = $2->getVarType();
          	//cout << return_type << endl;

          	cout<< "Line " <<line_count<<":"<< " statement : RETURN expression SEMICOLON" << endl << endl;
          	
          	cout<< return_statement << endl << endl;

          	SymbolInfo *s;
          	s= new SymbolInfo(return_statement, "statement");
          	$$ = s;

          

          }
          ;

expression_statement : SEMICOLON
                     {
                     	SymbolInfo *s;
                     	s = new SymbolInfo(";", "expression_statement");
                     	$$ = s;

                     	cout<< "Line " <<line_count<<":"<< " expression_statement : SEMICOLON " << endl << endl;
                     	cout<< ";" << endl << endl;


                     }
                     | expression SEMICOLON
                     {
                     	expression_name = $1-> getName() + ";";
                     	SymbolInfo *s;
                     	s = new SymbolInfo(expression_name, "expression_statement");
                     	$$ = s;
                     	$$->setVarType($1->getVarType());

                     	cout<< "Line " <<line_count<<":"<< " expression_statement :expression SEMICOLON " << endl << endl;
                     	cout<< expression_name << endl << endl;


                     }

                     ;

var_declaration : type_specifier declaration_list SEMICOLON 
				{	
					code_segment ="";
					specifier_type = $1->getType();
					cout<< "Line " <<line_count<<":"<< " var_declaration : type_specifier declaration_list SEMICOLON  " << endl << endl; 
					cout<< specifier_type << " ";
					code_segment += specifier_type + " ";

					for (int i = 0; i < $2->edge.size(); ++i)
							                	{	
							                		if(i == $2->edge.size()-1)
							                		{
							                			if($2->edge[i]->getIdentity() == "array")
							                				{
							                					cout << $2->edge[i]->getName() << "[" << $2->edge[i]->size << "]";
							                					code_segment += $2->edge[i]->getName()+"["+int2s($2->edge[i]->size)+"]";

							                				}
							                			else
							                				{
							                					cout << $2->edge[i]->getName() ;
							                					code_segment+= $2->edge[i]->getName();
							                				}	
							                		}
							                		else
							                		{
							                			if($2->edge[i]->getIdentity() == "array")
							                				{
							                					cout << $2->edge[i]->getName() << "[" << $2->edge[i]->size << "]" <<",";
							                					code_segment += $2->edge[i]->getName()+"["+int2s($2->edge[i]->size)+"]"+",";
							                		}
							                			else
							                				{
							                					cout << $2->edge[i]->getName() << ",";
							                					code_segment+= $2->edge[i]->getName()+",";
							                				}
							                		}
							                		
							                		
							                	}

					$2->edge.clear();
					//cout << "Edge size is " << $2->edge.size() << endl << endl;
					cout << ";"<<endl << endl;
					code_segment += ";";

					//cout << "This is the code_segment " << code_segment << endl << endl;

					SymbolInfo *s;
					s = new SymbolInfo(code_segment, "var_declaration");
					$$ = s;

				}
		 		 ;
 		 
type_specifier	: INT 
				{
					cout<< "Line " <<line_count<<":"<< " type_specifier: INT" << endl << endl;
					cout << "int" <<endl << endl;
					SymbolInfo *s;
					s = new SymbolInfo("int");
					$$ = s;
					var_type = "int";
					
				}
				| FLOAT 
				{
					cout<< "Line " <<line_count<<":"<< " type_specifier: FLOAT" << endl << endl;
					cout << "float" <<endl << endl;
					SymbolInfo *s;
					s = new SymbolInfo("float");
					$$ = s;
					var_type = "float";
				}
				| VOID 
				{
					cout<< "Line " <<line_count<<":"<< " type_specifier: VOID" << endl << endl;
					cout << "void" <<endl << endl;
					SymbolInfo *s;
					s = new SymbolInfo("void");
					$$ = s;
					var_type = "void";
				}
		 		;
 		
declaration_list : declaration_list COMMA ID
				 {
				 	var_name = $3->getName();
				 	cout<< "Line " <<line_count<<":"<< " declaration_list: declaration_list COMMA ID" << endl << endl;
				 	for (int i = 0; i < $$->edge.size(); ++i)
					                	{
					                		if($$->edge[i]->getIdentity() == "array")
					                		{
					                			cout << $$->edge[i]->getName() << "[" << $$->edge[i]->size << "]" <<",";
					                		}
					                		else
					                		{
					                			cout << $$->edge[i]->getName() << ",";
					                		}
					                		
					                	}
					cout << var_name << endl << endl;
					$3->setIdentity("variable");
                 	$3->setVarType(var_type);
                 	$$->edge.push_back($3);
                 	
                 	if(var_type == "void")
                 	{
                 		semantic_error++;
                 		fprintf(errorout,"Error at line %d: Variable type cannot be void\n", line_count);
						 cout << "Error at line " << line_count <<":" <<" Variable type cannon be void " <<endl <<endl;
                 		//now we can't insert	
                 	}
                 	// but if variable type is not "void" we need to insert it into symboltable
                 	else
                 	{
                 		
                 		if(symtab.insert(var_name,"ID")) // no other variable isn't available in the same name in the currentScope
                 		{
                 			
                 			//symtab.printLex();
                 			SymbolInfo *temp;
                 			temp = symtab.Lookup(var_name);
                 			temp->setIdentity("variable");
                 			temp->setVarType(var_type);
                 			if(var_type == "int") {temp->AllocateIntegerMemory(1);}
                 			else if(var_type == "float") {temp->AllocateFloatMemory(1);}
                 			 		
                 		}
                 		
                 		else // it exists already, so error
                 		{
                 			error++;
                 			fprintf(errorout,"Error at line %d: Multiple declaration of %s\n", line_count, $3->getName().c_str());	
							 cout << "Error at line " << line_count <<":" <<" Multiple declaration of "<< $3->getName() <<endl <<endl;
                 		}

                 	}
					                	
                 }

                 | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
                 {
                 	var_name = $3->getName();
                 	bracket_material = $5->getName();
                 	size = stoi($5->getName());
					cout<< "Line " <<line_count<<":"<< " declaration_list: declaration_list COMMA ID LTHIRD CONST_INT RTHIRD" << endl << endl; 
					//now print the declaration list
					for (int i = 0; i < $$->edge.size(); ++i)
					                	{
					                		if($$->edge[i]->getIdentity() == "array")
					                		{
					                			cout << $$->edge[i]->getName() << "[" << $$->edge[i]->size << "]" <<",";
					                		}
					                		else
					                		{
					                			cout << $$->edge[i]->getName() << ",";
					                		}
					                	}
					cout <<  var_name << "["<< bracket_material << "]" <<endl << endl; 

					$3->setIdentity("array");
                 	$3->setVarType(var_type);
                 	$3->size = size;

                 	$$->edge.push_back($3);

                 	if(var_type == "void")
                 	{
                 		semantic_error++;
                 		fprintf(errorout,"Error at line %d: Variable type cannot be void.", line_count);
						 cout << "Error at line " << line_count <<":" <<" Variable type cannot be void "<<endl <<endl;
                 		//now we can't insert	
                 	}
                 	// but if variable type is not "void" we need to insert it into symboltable
                 	else
                 	{
                 		
                 		if(symtab.insert(var_name,"ID")) // no other variable isn't available in the same name in the currentScope
                 		{
                 			
                 			//symtab.printLex();
                 			SymbolInfo *temp;
                 			temp = symtab.Lookup(var_name);
                 			temp->setIdentity("array");
                 			temp->setVarType(var_type);
                 			temp->size = size;
                 			if(var_type == "int") {temp->AllocateIntegerMemory(size);}
                 			else if(var_type == "float") {temp->AllocateFloatMemory(size);}
                 			else if(var_type == "char") {temp->AllocateCharMemory(size);}		
                 		}
                 		
                 		else// it exists already, so error
                 		{
                 			error++;
                 			fprintf(errorout,"Error at line %d: Multiple declaration of %s\n", line_count, $3->getName().c_str());	
							 cout << "Error at line " << line_count <<":" <<" Multiple declaration of "<< $3->getName() <<endl <<endl;
                 		}
                 	}

                 }
                 | ID
                 {	
                 	var_name = $1->getName();
                 	cout<< "Line " <<line_count<<":"<< " declaration_list: ID" << endl << endl;
                 	cout<< var_name << endl << endl;
                 	SymbolInfo *s;
                 	s = new SymbolInfo("declaration_list");
                 	$$ = s;
                 	$$-> setIdentity("declaration_list");
                 	
                 	$1->setIdentity("variable");
                 	$1->setVarType(var_type);
                 	$$->edge.push_back($1);
                 	
                 	if(var_type == "void")
                 	{
                 		semantic_error++;
                 		fprintf(errorout,"Error at line %d: Variable type cannot be void.\n", line_count);
						 cout << "Error at line " << line_count <<":" <<" variable type cannot be void"<<endl <<endl;
                 		//now we can't insert	
                 	}
                 	// but if variable type is not "void" we need to insert it into symboltable
                 	else
                 	{
                 		
                 		if(symtab.insert(var_name,"ID")) // no other variable isn't available in the same name in the currentScope
                 		{
                 			
                 			//symtab.printLex();
                 			SymbolInfo *temp;
                 			temp = symtab.Lookup(var_name);
                 			temp->setIdentity("variable");
                 			temp->setVarType(var_type);
                 			if(var_type == "int") {temp->AllocateIntegerMemory(1);}
                 			else if(var_type == "float") {temp->AllocateFloatMemory(1);}
                 			 		
                 		}
                 		
                 		else // it exists already, so error
                 		{
                 			error++;
                 			fprintf(errorout,"Error at line %d: Multiple declaration of %s\n", line_count, $1->getName().c_str());
							 cout << "Error at line " << line_count <<":" <<" Multiple declaration of "<< $1->getName() <<endl <<endl;	
                 		}

                 	}
                 	
                 	
                 	
                 	
                 }
                 | ID LTHIRD CONST_INT RTHIRD 
                 {
                 	var_name = $1->getName();
                 	bracket_material = $3->getName();
                 	size = stoi($3->getName());
                 	cout << size << endl << endl;
                 	cout<< "Line " <<line_count<<":"<< " declaration_list: ID LTHIRD CONST_INT RTHIRD" << endl << endl;
					
                 	cout<< var_name << "["<< bracket_material << "]" <<endl << endl;
                 	SymbolInfo *s;
                 	s = new SymbolInfo("declaration_list");
                 	$$ = s;
                 	$$-> setIdentity("declaration_list");

                 	
                 	$1->setIdentity("array");
                 	$1->setVarType(var_type);
                 	$1->size = size;

                 	$$->edge.push_back($1);

                 	if(var_type == "void")
                 	{
                 		semantic_error++;
                 		fprintf(errorout,"Error at line %d: Variable type cannot be void\n", line_count);
						 cout << "Error at line " << line_count <<":" <<" Variable type cannot be void "<<endl <<endl;
						
                 		//now we can't insert	
                 	}
                 	// but if variable type is not "void" we need to insert it into symboltable
                 	else
                 	{
                 		if(symtab.insert(var_name,"ID")) // no other variable isn't available in the same name in the currentScope
                 		{
                 			
                 			//symtab.printLex();
                 			SymbolInfo *temp;
                 			temp = symtab.Lookup(var_name);
                 			temp->setIdentity("array");
                 			temp->setVarType(var_type);
                 			temp->size = size;
                 			if(var_type == "int") {temp->AllocateIntegerMemory(size);}
                 			else if(var_type == "float") {temp->AllocateFloatMemory(size);}
                 			else if(var_type == "char") {temp->AllocateCharMemory(size);}		
                 		}
                 		
                 		else // it exists already, so error
                 		{
                 			error++;
                 		}
                 	}
                 	
                 }
                 ; 

variable : ID
		 {
		  	$$= $1;
		  	$$-> setIdentity("variable");


		  	cout<< "Line " << line_count << ": variable : ID" << endl << endl;
		  	expression_name = $1->getName();
		  	cout << expression_name << endl << endl;


		  	SymbolInfo *temp;
		  	temp = symtab.Lookup($1->getName());
		  	if(temp == NULL)
		  	{
		  		semantic_error++;
				fprintf(errorout, "Error at line %d: Undeclared variable %s \n",line_count, $1->getName().c_str());
				cout << "Error at line " << line_count <<":" <<" Undeclared variable "<< $1->getName() <<endl <<endl;
		  	}
		  	else if (temp != NULL)
		  	{
		  		$$-> setVarType(temp->getVarType());
		  	}
		 }
		 | ID LTHIRD expression RTHIRD
		  {
		  	SymbolInfo* s;
		  	s = new SymbolInfo($1->getName(), "variable");
		  	$$= s;

		  	size = stoi($3->getName());
		  	$$-> size = size ; //cout << $$->size <<endl << endl;
		  	$$-> setIdentity("array");// cout << $$->getIdentity() << endl << endl;
		  	$$-> setVarType($3-> getVarType()); //cout<< $$->getVarType() <<endl << endl;


		  	cout<< "Line " << line_count <<":" <<" variable : ID LTHIRD expression RTHIRD " << endl << endl;
		  	expression_name = $1->getName() + "[" + $3-> getName() + "]";
		  	cout << expression_name << endl << endl;

		  	//if expression type is nor integer then semantic error

		  	if ($3->getVarType() != "int" )
		  	{
		  		semantic_error++;
				fprintf(errorout, "Error at line %d: Expression inside third brackets not an integer \n",line_count);
				cout << "Error at line " << line_count <<":" <<" Expression inside third brackets not an integer "<<endl <<endl;
		  	}

		  	// if id not declared before in the current scope. then semantic error

		  	SymbolInfo *temp;
		  	temp = symtab.Lookup($1->getName());
		  	if(temp == NULL)
		  	{
		  		semantic_error++;
				fprintf(errorout, "Error at line %d: Undeclared variable %s \n",line_count, $1->getName().c_str());
				cout << "Error at line " << line_count <<":" <<" Undeclared variable "<< $1->getName() <<endl <<endl;
		  	}
		  	else if (temp != NULL)
		  	{
		  		$$-> setVarType(temp->getVarType());
		  	}

		  }
		  ;	  

expression : logic_expression
			{
				$$ = $1;
				cout<< "Line " << line_count << ": expression : logic expression " << endl << endl;
				logic_expression_name = $1->getName();
				cout << logic_expression_name << endl << endl;
			}

			| variable ASSIGNOP logic_expression
			{
				//cout << $1->size << endl;

				if($1->getIdentity() == "array")
                {
                	var_name = $1->getName();
					var_name += "[" + int2s($1->size) + "]";
                }
                else
                {
                	var_name = $1->getName();
                }
				

                if($1->getIdentity() == "array")
                {
                	code_segment = $1->getName();
					code_segment += "[" + int2s($1->size) + "]";
				    code_segment += "=" + $3-> getName();
                }
                else
                {
                	code_segment = $1->getName();

					if($1->size)
					{
						code_segment += "[" + int2s($1->size) + "]";
					}
					

					code_segment += "=" + $3-> getName();
                }


				cout << "Line " << line_count << ": expression : variable ASSIGNOP logic_expression " << endl << endl;
				cout << var_name << "=" << $3->getName() << endl << endl;
                
                

				SymbolInfo *s;
				s = new SymbolInfo(code_segment, "expression");
				$$ = s;

				code_segment = "";



				//semantic error
				//array index error
				// assign er dui pashe alada alada variable type

				SymbolInfo *temp;
				temp = symtab.Lookup($1->getName());


				if(temp != NULL)
				{	
					if ((temp-> getVarType() == "int" && $3-> getVarType() != "int" ) | (temp-> getVarType() == "float" && $3-> getVarType() == "char") | (temp-> getVarType() == "char" && $3-> getVarType() != "char"))
					{

						semantic_error++;
						fprintf(errorout, "Error at line %d: Type mismatch\n",line_count);
						cout << "Error at line " << line_count <<":" <<" Type mismatch " <<endl <<endl;
					}

					if(temp->getIdentity() != "array")
					{
						if($1->size != 0)
						{
							semantic_error++;
							fprintf(errorout, "Error at line %d: variable %s Array Index Error. \n",line_count, $1->getName().c_str());
							cout << "Error at line " << line_count <<":" <<" variable "<< $1->getName() << " Array Index Error" <<endl <<endl;
						}
					}
					else if (temp->getIdentity() == "array")
					{
						if ($1->getIdentity() != "array")
						{
							semantic_error++;
							fprintf(errorout, "Error at line %d: variable %s Array Index Error. \n",line_count, $1->getName().c_str());
							cout << "Error at line " << line_count <<":" <<" variable "<< $1->getName() << " Array Index Error" <<endl <<endl;
						}
					}

					$$-> setVarType( temp-> getVarType());
				}
				else if (temp == NULL)
				{
					//checked in the id section not needed here.
					//semantic_error++;
				    //fprintf(errorout, "Error at line %d: Undeclared variable %s \n",line_count, $1->getName().c_str());
				}

			}
			
			;

logic_expression : rel_expression
				 {
				 	$$ = $1;
				  	cout<< "Line " << line_count << ": logic_expression : rel_expression" << endl << endl;
				  	rel_expression_name = $1->getName();
				  	cout << rel_expression_name << endl << endl;
				 }
				 | rel_expression LOGICOP rel_expression
				 {
				 	cout<< "Line " << line_count << ": logic_expression : rel_expression LOGICOP rel_expression" << endl << endl;
					rel_expression_name =$1->getName() + $2->getName() + $3->getName();
					cout << rel_expression_name << endl << endl;

					SymbolInfo *s;
					s= new SymbolInfo(rel_expression_name, "logic_expression");
					$$ = s;
					$$->setVarType("int");

					//logicop will have int on both sides
					// else symantic error

					if ($1->getVarType() != "int")
					{
						semantic_error++;
						fprintf(errorout, "Error at line %d: %s is only possible between integers. \n",line_count, $2->getName().c_str() );
						cout << "Error at line " << line_count <<":" <<" "<< $2->getName() << " is only possible between integers" <<endl <<endl;
					}
					else if ($3->getVarType() != "int")
					{
						semantic_error++;
						fprintf(errorout, "Error at line %d: %s is only possible between integers. \n",line_count, $2->getName().c_str() );
						cout << "Error at line " << line_count <<":" <<" "<< $2->getName() << " is only possible between integers" <<endl <<endl;

					}
				 }
				 ;

rel_expression : simple_expression
				{
					$$ = $1;
				  	cout<< "Line " << line_count << ": rel_expression : simple_expression" << endl << endl;
				  	simple_expression_name = $1->getName();
				  	cout << simple_expression_name << endl << endl;
				}
				| simple_expression RELOP simple_expression
				{
					cout<< "Line " << line_count << ": rel_expression : simple_expression RELOP simple_expression" << endl << endl;
					string a,b;
					if($1->getIdentity() == "array")
					 {
						 a= $1->getName()+ "[" + int2s($1->size) + "]";
					 }
					 else
					 {
						 a = $1->getName();
					 }

					  if($3->getIdentity() == "array")
					 {
						 b= $3->getName()+ "[" + int2s($3->size) + "]";
					 }
					 else
					 {
						 b = $3->getName();
					 }

					 simple_expression_name = a + $2->getName()+ b;

					//simple_expression_name =$1->getName() + $2->getName() + $3->getName();
					cout << simple_expression_name << endl << endl;

					SymbolInfo *s;
					s= new SymbolInfo(simple_expression_name, "rel_expression");
					$$ = s;
					$$->setVarType("int");

					//relop will have int on both sides
					// else symantic error

					if (($1->getVarType() == "int" | $1->getVarType() == "float" ) && ($3->getVarType() == "char"))
					{
						semantic_error++;
						
						fprintf(errorout, "Error at line %d: %s is only possible between integers or floats. \n",line_count, $2->getName().c_str() );
						cout << "Error at line " << line_count <<":" <<" "<< $2->getName() << " is only possible between integers" <<endl <<endl;
					}
					else if (($3->getVarType() == "int" | $3->getVarType() == "float" ) && ($1->getVarType() == "char"))
					{
						semantic_error++;
						
						fprintf(errorout, "Error at line %d: %s is only possible between integers or floats. \n",line_count, $2->getName().c_str() );
						cout << "Error at line " << line_count <<":" <<" "<< $2->getName() << " is only possible between integers" <<endl <<endl;

					}

				}
				;


simple_expression : term
				  {
				  	$$ = $1;
				  	cout<< "Line " <<line_count<<":"<< " simple_expression : term" << endl << endl;
				  	term_name = $1->getName();
					  if($1->getIdentity() == "array")
					{
						cout << term_name <<"["<< $1->size << "]"<<endl << endl;
					} 
					else
					{
						cout << term_name <<endl << endl;
					}

				  	
				  }
				  | simple_expression ADDOP term
				  {
				 	cout<< "Line " <<line_count<<":"<< " simple_expression : simple_expression ADDOP term" << endl << endl;
					 term_name = "";
					 string a,b;

					 if($1->getIdentity() == "array")
					 {
						 a= $1->getName()+ "[" + int2s($1->size) + "]";
					 }
					 else
					 {
						 a = $1->getName();
					 }

					  if($3->getIdentity() == "array")
					 {
						 b= $3->getName()+ "[" + int2s($3->size) + "]";
					 }
					 else
					 {
						 b = $3->getName();
					 }

					 term_name = a + $2->getName()+b;
					

					//cout << term_name <<endl;

				 	//term_name = $1->getName()+ $2->getName() + $3->getName();
				 	cout << term_name << endl << endl;

				 	SymbolInfo *s;
				 	s = new SymbolInfo(term_name, "simple_expression");
				 	$$ = s;
					//fprintf(errorout, " $3 -- %s",$3->getVarType().c_str() ); 
				 	if($1-> getVarType() == "int" && $3-> getVarType() == "int")
				 	{
				 		$$->setVarType("int");
				 	}
				 	else
				 	{
				 		$$->setVarType("float");
				 	}

				 	//cout << $$->getVarType() << endl << endl;

				  }
				  ;


term : unary_expression
	 {
	 	$$ = $1;
	 	cout<< "Line " <<line_count<<":"<< " term : unary_expression" << endl << endl;
	 	unary_expression_name = $1->getName();

			if($1->getIdentity() == "array")
					{
						cout << unary_expression_name <<"["<< $1->size << "]"<<endl << endl;
					} 
					else
					{
						cout << unary_expression_name <<endl << endl;
					}


	 	


	 }
	 | term MULOP unary_expression
	 {
	 	cout<< "Line " <<line_count<<":"<< " term :term MULOP unary_expression" << endl << endl;
	 	//cout << unary_expression_name << endl << endl;
		 string a;

					if($1->getIdentity() == "array")
					{
						a = $1->getName()+ "["+ int2s($1->size) + "]";
					} 
					else
					{
						a = $1->getName();
					}
		string b;

					if($3->getIdentity() == "array")
					{
						b = $3->getName()+ "["+ int2s($3->size) + "]";
					} 
					else
					{
						b = $3->getName();
					}			

	 	unary_expression_name =a + $2->getName() + b;
	 	cout << unary_expression_name << endl << endl;

	 	SymbolInfo *s;
	 	s = new SymbolInfo(unary_expression_name, "term");
	 	$$ = s;

	 	// set variable type now

	 	// if MULOP is 'mod' the full term will be integer

		

	 	if($2->getName() == "%")
	 	{
	 		$$->setVarType("int");
	 	}
	 	else
	 	{
	 		if($1->getVarType() == "float") {$$->setVarType("float");}
	 		else if ($3->getVarType() == "float") {$$->setVarType("float");}
	 		else {$$->setVarType("int");}
	 	}

	 	//cout << $$->getVarType() << endl << endl;

	 	// semantic error can be happened here
	 	// mod can only be happened between two integers

	 	if($2-> getName() == "%")

	 	{
			 if($3->getName() == "0" ||$1->getName() == "0" )
	 		{
	 			semantic_error++;
	 			fprintf(errorout, "Error at line %d: Modulus by Zero\n",line_count );
				 cout << "Error at line " << line_count <<":" <<" Modulus by Zero" <<endl <<endl;
	 		}

	 		else if($1->getVarType() != "int")
	 		{
	 			semantic_error++;
	 			fprintf(errorout, "Error at line %d: Non-Integer operand on modulus operator \n",line_count );
				  cout << "Error at line " << line_count <<":" <<" Non-Integer operand on modulus operator" <<endl <<endl;
	 		}
	 		else if($3-> getVarType() != "int" )
	 		{
	 			
	 			semantic_error++;
	 			fprintf(errorout, "Error at line %d: Non-Integer operand on modulus operator \n",line_count );
				  cout << "Error at line " << line_count <<":" <<" Non-Integer operand on modulus operator" <<endl <<endl;
	 		
	 		}
	 	}

	 }
	 ;

unary_expression : ADDOP unary_expression
				 {
				 	cout<< "Line " <<line_count<<":"<< " unary_expression : ADDOP unary_expression " << endl << endl;

					string a;

					if($2->getIdentity() == "array")
					{
						a = $2->getName()+ "["+ int2s($2->size) + "]";
					} 
					else
					{
						a = $2->getName();
					}
					 
                 	factor_name = $1->getName()+a;
                 	factor_type = $2->getType();
                 	cout << factor_name << endl << endl;

                 	SymbolInfo *s;
                 	s = new SymbolInfo(factor_name, "unary_expression");
                    $$ = s;

                    $$->setVarType($2->getVarType());
				 }
				 | NOT unary_expression
                 {
                 	cout<< "Line " <<line_count<<":"<< " unary_expression : NOT unary expression " << endl << endl;
                 	factor_name = $2->getName();
                 	factor_type = $2->getType();
                 	cout << "!" << factor_name << endl << endl;

                 	factor_name = "!" + factor_name;
        

                 	SymbolInfo *s;
                 	s = new SymbolInfo(factor_name, "unary_expression");
                    $$ = s;

                    $$->setVarType($2->getVarType());
                 }
				 | factor
				 {	
				 	$$ = $1;
				 	cout<< "Line " <<line_count<<":"<< " unary_expression : factor " << endl << endl;
				 	factor_name = $1->getName();
					if($1->getIdentity() == "array")
					{
						cout << factor_name <<"["<< $1->size << "]"<<endl << endl;
					} 
					else
					{
						cout << factor_name <<endl << endl;
					}
				 	
				 }
				 ;

factor :variable
		{
		 $$ = $1;
		 variable_name = $1->getName();
		 variable_identity = $1->getIdentity();
		 //cout<< variable_identity << endl;
		 
		 cout<< "Line " <<line_count<<":"<< " factor : variable " << endl << endl;
		 if(variable_identity == "array")
		 {
			 cout << variable_name << "["<< $1->size << "]"<<endl<<endl;
		 }
		 else
		 {
            cout << variable_name << endl << endl;
		 }
	   	 
		}
		| ID LPAREN argument_list RPAREN
		{
			cout<< "Line " <<line_count<<":"<< " factor : ID LPAREN argument_list RPAREN " << endl << endl;
			cout<< $1->getName() << "("<< $3->getName() <<")" << endl << endl;

			SymbolInfo *s;
			s = new SymbolInfo($1->getName() + "(" + $3->getName() + ")", "factor");
			$$ = s;
			//semantic error check

			SymbolInfo *x;
			x = symtab.Lookup($1->getName());

			if (x == NULL)
			{
				$$->setVarType("func_not_found");
				semantic_error++;
	 			fprintf(errorout, "Error at line %d: Undeclared function %s\n",line_count, $1->getName().c_str() );
				  cout << "Error at line " << line_count <<":" <<" Undeclared function " <<$1->getName()<<endl <<endl;
			}
			else if(x != NULL)
			{
				current_ret_type = x->getRetType();
				$$->setVarType(current_ret_type);
			}

			if(x != NULL)
			{
				if (x->getIdentity() == "func_defined")
				{
					//size mismatch of arguments passed
					if (x->edge.size() != args.size())
					{
						//fprintf(errorout, "x->edgesize = %d args.size = %d\n",x->edge.size(),args.size());
						semantic_error++;
	 					fprintf(errorout, "Error at line %d: Total number of arguments mismatch in function %s \n",line_count, $1->getName().c_str() );
						  cout << "Error at line " << line_count <<":" <<" Total number of arguments mismatch in function " << $1->getName() <<endl <<endl;

					}
					else //type mismatched of arguments passed
					{
						size = x->edge.size();
						for (int i = 0; i < size; ++i)
						{
							if (args[i]->getIdentity() == "variable")
							{
								semantic_error++;
								//fprintf(errorout, " error\n",line_count );
	 							fprintf(errorout, "Error at line %d: Type mismatch\n",line_count );
								  cout << "Error at line " << line_count <<":" <<" Type mismatch" <<endl <<endl;
	 							break;
							}

							SymbolInfo *temp;
							temp = symtab.Lookup(args[i]->getName());

							if(temp != NULL)
							{
								if (x->getVarType() != temp->edge[i]->getVarType())
								{
									semantic_error++;
									//fprintf(errorout, " error\n",line_count );
	 								fprintf(errorout, "Error at line %d: type mismatched of arguments \n",line_count );
									  cout << "Error at line " << line_count <<":" <<" Type mismatched of arguments" <<endl <<endl;
	 								break;
								}
								else if (x->size != temp->edge[i]->size)
								{
									semantic_error++;
	 								fprintf(errorout, "Error at line %d: more or less arguments \n",line_count );
									  cout << "Error at line " << line_count <<":" <<" More of Less arguments" <<endl <<endl;
	 								break;
								}
							}

							
						}
					}
				}
			}
			args.clear();

		}
        | LPAREN expression RPAREN
		{
		 expression_name = "(" + $2->getName() + ")";

	   	 SymbolInfo *s;
	   	 s = new SymbolInfo(expression_name, "factor");
	   	 $$ = s;
	   	 $$->setVarType($2->getVarType());

	   	 cout<< "Line " <<line_count<<":"<< " factor : LPAREN expression RPAREN " << endl << endl;
	   	 cout << expression_name << endl << endl;

		}
       | CONST_INT
	   {

	   	 $$=$1;
	   	 $$->setVarType("int");

	   	 cout<< "Line " <<line_count<<":"<< " factor : CONST_INT " << endl << endl;
	   	 int_name = $1->getName();

	   	 cout << int_name <<endl << endl;
	   }
	   | CONST_FLOAT
	   {
	   	 $$=$1;
	   	 $$->setVarType("float");

	   	 cout<< "Line " <<line_count<<":"<< " factor : CONST_FLOAT " << endl << endl;
	   	 float_name = $1->getName();

	   	 cout << float_name <<endl << endl;
	   }
	   
	   | variable DECOP
	   {
		  string a;

					if($1->getIdentity() == "array")
					{
						a = $1->getName()+ "["+ int2s($1->size) + "]";
					} 
					else
					{
						a = $1->getName();
					}
		 
         variable_name = a + "--";

	   	 SymbolInfo *s;
	   	 s = new SymbolInfo(variable_name, "factor");
	   	 $$ = s;
	   	 $$->setVarType($1->getVarType());

	   	 cout<< "Line " <<line_count<<":"<< " factor : variable DECOP " << endl << endl;
	   	 cout << variable_name << endl << endl;


	   } 
	   | variable INCOP
	   {
		    string a;

					if($1->getIdentity() == "array")
					{
						a = $1->getName()+ "["+ int2s($1->size) + "]";
					} 
					else
					{
						a = $1->getName();
					}
	
	   	 variable_name = a + "++";

	   	 SymbolInfo *s;
	   	 s = new SymbolInfo(variable_name, "factor");
	   	 $$ = s;
	   	 $$->setVarType($1->getVarType());

	   	 cout<< "Line " <<line_count<<":"<< " factor : variable INCOP " << endl << endl;
	   	 cout << variable_name << endl << endl;
	   } 
	   ;  

argument_list : arguments
			  {

			  	 $$=$1;
			  	 $$->setType("argument_list");

			  	 cout<< "Line " <<line_count<<":"<< " argument_list : arguments" << endl << endl;
			  	 arguments_name = $1->getName();
			  	 cout << arguments_name << endl << endl;
			  }	 
			  |
			  {
			  	arguments_name = "";
			  	SymbolInfo *s;
			  	s = new SymbolInfo(arguments_name, "argument_list");
			  	$$ = s;
			  }  
			  ;
			  
arguments : arguments COMMA logic_expression
          {
          	cout<< "Line " <<line_count<<":"<< " arguments:arguments COMMA logic_expression" << endl << endl;
          	logic_name = $1->getName()+  "," + $3->getName();
          	cout << logic_name << endl << endl;

          	SymbolInfo *s;
          	s = new SymbolInfo(logic_name, "arguments");
          	$$ = s;

          	args.push_back($3);

          }
		  | logic_expression
		  {	
		  	$$ = $1;
		  	args.push_back($$);

		  	logic_name = $1->getName();
		  	cout<< "Line " <<line_count<<":"<< " arguments: logic_expression" << endl << endl;
		  	cout << logic_name << endl << endl;


		  }
		  ;                 

%%
int main(int argc,char *argv[])
{

	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	

	logout = freopen("log.txt", "w", stdout);
	errorout= fopen("error.txt","w");



	yyin= fin;
	
	yyparse();

	cout << "Total lines: "<<line_count<<endl<< "Total errors: "<<semantic_error <<endl;


   // fprintf(errorout, "\n Total errors : %d \n", semantic_error );
	
	fclose(yyin);
	
	fclose(logout);
	
	fclose(errorout);
	return 0;
}

