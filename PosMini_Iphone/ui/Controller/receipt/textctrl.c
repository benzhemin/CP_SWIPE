//
//  textctrl.c
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void swap(char *a, char *b){
	char temp = *a;
	*a = *b;
	*b = temp;
}

void delete_amount(char *text){
	int len = strlen(text);
	*(text+len-1) = '\0';
	
	char *p = strchr(text, '.');
	swap(p, p-1);
	
	if(*text == '.'){
		memmove(text+1, text, len+1);
		*text = '0';
	}
}

void insert_amount(char *text, char digit){
	int len = strlen(text);
	
	text[len] = digit;
	text[len+1] = '\0';
	
	char *p = strchr(text, '.');
	swap(p, p+1);
	
	if(strncmp(text, "00", 2)==0 || (*text=='0'&&*(text+1)!='.')){
		memmove(text, text+1, strlen(text));
	}
}

int main_unit(void){
	char *text = malloc(20);
	memset(text, 0, 20);
	strcpy(text, "0.00");
	
	//nondigit account for delete
	//+ account for exit
	int ch;
	while((ch=getchar()) != EOF){
		if(isdigit(ch)){
			insert_amount(text, ch);
		}else if(isalpha(ch)){
			delete_amount(text);
		}
		else{
			continue;
		}
		printf("%s\n", text);
	}
	
	free(text);
	return 0;
}