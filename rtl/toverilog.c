#include <stdio.h>
#include <string.h>

int main(argc,argv)
int argc;
char **argv;
{
	int character;
	int count;
	int length;
	int point;
	int lcount = 0;
	int start = 0;
	int high;
	int low;
	char value[90];
	FILE *fi;
	FILE *fo;
	int a;
	
	if(argc < 4)
	{
		printf("\n  Usage\n\n   toverilog input output *start **length\n\n  *start should be entered with 4 hex digits\n  **length is optional and is entered in hex\n");
		exit(1);
	}

	fi=fopen(argv[1],"rb");
	if(fi == NULL) printf("Input file, %s, cannot be opened\n",argv[2]);
	fo=fopen(argv[2],"w");
	while(argv[3][lcount] != 0)
	{
		count = argv[3][lcount++] - '0';
		if(count > 9) count = count - 7;
		if(count >15) count = count - 32;
		start = 16 * start + count;
	}
	lcount = 0;
	if(argc > 4)
	{
		while(argv[4][lcount] != 0)
		{
			count = argv[4][lcount++] - '0';
			if(count > 9) count = count - 7;
			if(count >15) count = count - 32;
			length = 16 * length + count;
		}
	}
	else
	{
		length = 2048;
	}
	for(count=0; count<start; count++) character = fgetc(fi);
	strcpy(value, "       .INIT_00(256'h");
	point = 84;
	value[85] = 0;
	for(count=0; count<length; count++)
	{
		character = fgetc(fi);

		high = ((character & 240) / 16) + '0';
		low = (character & 15) + '0';
		if(high > '9')
		 high+=7;
		if(low > '9')
		 low+=7;
		value[point--] = low;
		value[point--] = high;
//		printf("%c%c\n",value[point+1],value[point+2]);
//		printf("%d\n",point);
		lcount = (count+1)/32;
		high = ((lcount & 240) / 16) + '0';
		low = (lcount & 15) + '0';
		if(high > '9')
		 high+=7;
		if(low > '9')
		 low+=7;
//		 for(a=0;a<90;a++)printf("%c",value[a]);
		if((count %32) == 31)
		{
			fprintf(fo,"%s),\n",value);
			sprintf(value,"       .INIT_%c%c(256'h",high,low);
			point = 84;
			value[85] = 0;
		}
	}
	fclose(fi);
	fclose(fo);
//	printf("%s\n", value); 
}