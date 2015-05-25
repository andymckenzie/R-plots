#include <stdio.h> 
#include <ctype.h> 
#include <string.h> 
#include <stdlib.h> 

/* K&R 6-3: Write a cross-referencer that prints a list of all words in a document, and 
, for each word, a list of the line numbers on which it occurs. Remove noise like "the", "and", &c. */

#define BUFSIZE 100 
#define MAXWORD 100

char buf[BUFSIZE]; /* character array buffer for ungetch */
int bufp = 0; /*next free position in buf */ 

int getch(void); 
void ungetch(int); 
int getword(char *, int);

struct tnode {
	char *word; 
	int count; 
	struct tnode *left; 
	struct tnode *right; 
}; 

struct tnode *addtree(struct tnode *, char *); 
void treeprint(struct tnode *); 
int getword(char *, int); 

struct tnode *talloc(void); 

/* word frequency count */
int main(int argc, char **argv){
	FILE *fp;
	fp=fopen(argv[1], "r");
	
	if (fp == 0)
	    {
	        //fopen returns 0, the NULL pointer, on failure
	        perror("Canot open input file\n");
	        exit(-1);
	    }
	
	struct tnode *root; 
	char word[MAXWORD]; 
	
	root = NULL; 
	while (getword(word, MAXWORD) != EOF)
		if (isalpha(word[0]))
			root = addtree(root, word); 
	treeprint(root); 
	return 0; 
}

struct tnode *addtree(struct tnode *p, char *w){
	
	int cond; 
	
	if(p == NULL){
		p = talloc(); /* returns pointer to free space sutable for holding tree node */
		p->word = strdup(w); /* duplicate string */
		p->count = 1; 
		p->left = p->right = NULL; 
	} else if ((cond = strcmp(w, p->word)) == 0) /* words are same */
		p->count++;
	else if (cond < 0) /* less than, go into left subtree */
		p->left = addtree(p->left, w); 
	else 
		p->right = addtree(p->right, w); 
	return p; 
	
}

void treeprint(struct tnode *p){
	if(p != NULL) {
		treeprint(p->left); 
		printf("%4d %s\n", p->count, p->word); 
		treeprint(p->right); 
	}
}

int getch(void) /* get a character */
{
	return (bufp > 0) ? buf[--bufp] : getchar(); 
}

void ungetch(int c)
{
	if (bufp >= BUFSIZE)
		printf("ungetch: too many characters \n"); 
	else 
		buf[bufp++] = c;
}

int getword(char *word, int lim)
{
	int c, getch(void); 
	void ungetch(int);
	char *w = word; 
	
	while (isspace(c = getch()))
		; 
	if (c != EOF)
		*w++ = c; 
	if (!isalpha(c)) {
		*w = '\0'; 
		return c; 
	}
	for ( ; --lim > 0; w++)
		if (!isalnum(*w = getch())) {
			ungetch(*w);
			break; 
		}
	*w = '\0'; 
	return word[0];
	
}

struct tnode *talloc(void) {
	return (struct tnode *) malloc(sizeof(struct tnode)); 
}