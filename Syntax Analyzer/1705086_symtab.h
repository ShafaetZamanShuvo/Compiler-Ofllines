#include<bits/stdc++.h>
using namespace std;


class SymbolInfo
{
private:

    string name;
    string type;
    string identity;
    string var_type;
    string ret_type;

public:
    SymbolInfo *next;
    int size;
    vector<SymbolInfo*> edge;
    int *i;
    float *f;
    char *c;
    SymbolInfo(string name, string type)
    {
        this->name = name;
        this->type = type;
        next = NULL;
    }
    
    SymbolInfo(string type)
    {
    	this->name = "";
    	this->type = type;
    	next = NULL;
    }
    
    string getName (){return name;}

    void setName(string name) {this->name = name;}
    
    string getType () {return type;}

    void setType(string type) {this->type = type;}
    
    void setRetType(string ret_type) {this->ret_type = ret_type;}
    
    string getRetType() {return ret_type;}
    
    void setVarType (string var_type) {this->var_type = var_type;}
    
    string getVarType() {return var_type;}
    
    void setIdentity(string identity) {this->identity = identity;}
    
    string getIdentity() {return identity;}
    
    void setNext(SymbolInfo * next){this->next = next;}
    
    SymbolInfo* getNext(){return next;}

    
    void AllocateIntegerMemory(int n)
    {
    	i = new int[n];
    	int count = 0;
    	for(count = 0; count < n; count++)
    	{
    		i[count] = 0;
    	}
    }
    
    void AllocateFloatMemory(int n)
    {
    	f = new float[n];
    	int count = 0;
    	for(count = 0; count < n; count++)
    	{
    		f[count] = 0.0;
    	}
    }
    
    void AllocateCharMemory(int n)
    {
    	c = new char[n];
    	int count = 0;
    	for(count = 0; count < n; count++)
    	{
    		c[count] = '#';
    	}
    }

};

class ScopeTable
{

public:
    int scopeid;
    int bucket;
    SymbolInfo **hashtable;
    ScopeTable *parentScope;

    ScopeTable(int n,int id, ScopeTable* parentScope)
    {
        bucket = n;
        hashtable = new SymbolInfo* [n];
        for(int i = 0; i<n; i++)
        {
            hashtable[i] = NULL;
        }
        this->scopeid = id;
        this-> parentScope = parentScope;
    }

    int getScopeID()
    {
        return this->scopeid;
    }

    ScopeTable* getParentScope()
    {
        return parentScope;
    }

    int HashIndex(string name)
    {
        int index = 0;
        int len = name.size();

        for(int i = 0; i<len; i++)
        {
            index = index + name[i];
        }

        index = index % this->bucket;
        return index;
    }

    bool Insert(string name,string type)
    {
        int count = 0;
        SymbolInfo *parent = NULL;
        int index = HashIndex(name);
        SymbolInfo *current = hashtable[index];
        while(current!=NULL)
        {

            count++;
            parent = current;
            if(current->getName() == name)
            {
                cout << "Can't insert, already exists" <<endl;
                return false;
            }
            current = current->getNext();
        }


        if(current == NULL)
        {
            current = new SymbolInfo(name,type);

            if(parent == NULL)
            {
                hashtable[index] = current;

            }
            else
            {
                parent->next = current;
            }
            //cout << "Inserted in ScopeTable# "<<  scopeid << " at position " << index <<" , "<< count << endl;
            return true;

        }
        return false;
    }

    SymbolInfo* Lookup(string name)
    {

        int index = HashIndex(name);

        SymbolInfo *sym;

        sym = hashtable[index];
        int count = -1;
        while(sym!= NULL)
        {
           count++;
            if(sym->getName() == name)
            {
                //cout << "Found at ScopeTable#" << scopeid << "At position " << index << ", "<< count<<endl;
                return sym;
            }

            sym = sym->getNext();
            //count++;

        }
        //cout << "Not Found" <<endl;

        return NULL;

    }

    bool Delete(string name)
    {

        if(Lookup(name) == NULL)
        {
            cout << "Not found"<<endl;
            return false;
        }
        int index = HashIndex(name);

        SymbolInfo *sym;
        SymbolInfo *previous = NULL;



        sym = hashtable[index];

        while(sym != NULL)
        {
            if(sym->getName() == name)
            {
                if(previous == NULL)
                {

                    hashtable[index] = NULL;

                }
                else
                {
                    previous->setNext(sym->getNext());
                    return true;
                }
            }

            previous = sym;
            sym = sym->getNext();
        }

            return false;
    }

    void Print()
    {
        cout << "ScopeTable# " << scopeid << endl;
        for(int i = 0; i< bucket; i++)
        {
            SymbolInfo *sym;

            sym = hashtable[i];
            if(sym == NULL){
                cout << i << " " << "--> " <<endl;
            }
            else{
                while(sym!= NULL)
            {
                cout << i << " " << "--> " ;
                while(sym != NULL)
                {
                cout << "< "<<sym->getName() << ", " << sym->getType()<<" >"<< " ";
                sym = sym->getNext();
                }
                cout << endl;

            }
            }



        }
        cout << endl;

    }
    
    void PrintCurrentBucket()
    {	
    		cout << "ScopeTable # " << scopeid << endl;
        for(int i = 0; i< bucket; i++)
        {
            SymbolInfo *sym;

            sym = hashtable[i];
         
            
                while(sym!= NULL)
            {
                cout << i << " " << "--> " ;
                while(sym != NULL)
                {
                cout << "< "<<sym->getName() << ", " << sym->getType()<<" >"<< " ";
                sym = sym->getNext();
                }
                cout << endl;

            }
            
        }
        cout << endl;    
    }

    vector<SymbolInfo*> returnAllSymbolsInCurrentScope()
     {
        vector<SymbolInfo*> v;
        SymbolInfo *temp;


        for (int i = 0; i < bucket; i++)
        {
            if (!hashtable[i])
                continue;

            temp = hashtable[i];
            while (temp)
            {
                v.push_back(temp);
                temp = temp->getNext();
            }
        }

        return v;
    }

    ~ScopeTable()
    {

        for(int i = 0; i<bucket;i++){
            SymbolInfo* temp =hashtable[i];
            while(temp!=nullptr){
                SymbolInfo* parent = temp;
                temp = temp->next;
                delete parent;
            }
        }
        delete [] hashtable;
    }

};
class SymbolTable
{
public:

    ScopeTable *currentScope;


    SymbolTable(int n, int id, ScopeTable *newScope)

    {
        ScopeTable* temp = new ScopeTable(n, id, newScope);
        currentScope = temp;
        id = 1;

    }

    void enterScope(int n,int id)
    {

        currentScope = new ScopeTable(n,id,currentScope);

        //cout << "Hello" <<endl;
      //  cout<< "New ScopeTable with ID " << id << " created" <<endl;

    }

    void exitScope(int id)
    {
        if(currentScope == NULL)
        {
            return;
        }
        else
        {
            //cout<< "ScopeTable with ID " << id << " removed" <<endl;

            currentScope = currentScope->getParentScope();
            //id--;

        }
    }

    bool insert(string name,string type)
    {

        if(currentScope == NULL)
        {
            //cout << "Hello" << endl;
            return false;
        }
        else
        {
            //cout << "Hello else" << endl;
            return currentScope->Insert(name,type);
        }

    }

    bool Remove(string name)
    {
        if(currentScope == NULL)
        {
            return false;
        }
        else
        {
            return currentScope->Delete(name);
        }
    }

    SymbolInfo* Lookup(string name)
    {
        if(currentScope == NULL)
        {
            return NULL;
        }
        ScopeTable* temp = currentScope;
        SymbolInfo* sym = NULL;

        while(temp != NULL)
        {
            sym = temp -> Lookup(name);

            if(sym != NULL)
            {
                break;
            }

            temp = temp->getParentScope();
        }
	//cout << "Not Found" <<endl;
        return sym;


    }

    void printCurrentScope()
    {
        if(currentScope==NULL)
        {
            return;
        }
        currentScope->Print();
    }

    void PrintAllScope()
    {
        ScopeTable* temp = currentScope;

        while(temp != NULL) {
            temp->PrintCurrentBucket();

            cout << endl;


            temp = temp->getParentScope();
        }

        return ;
    }
     void printLex()
    {
        PrintAllScope();
    }

    vector<SymbolInfo*> GetAllSymbolsInCurrentScope(){
        ScopeTable *temp = currentScope;
        cout << temp->scopeid << endl;
        vector<SymbolInfo*> v;
        v = temp->returnAllSymbolsInCurrentScope();
        
        return v;
    }
    
   

};



