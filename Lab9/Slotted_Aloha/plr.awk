BEGIN{
    pktsend=0;
    pktrec=0;
    ctime=20.0;
}
{
    e=$1;
   
    if ($2 > ctime) {
		printf("%d\t%f\n", ctime, (1-pktrec/pktsend));
		ctime = ctime + 20.0;
		pktsend = 0;
		pktrec = 0;
	}
    if(e =="r" && ($3 >= 0 && $3 <=  12))
    {
        pktrec++;
    }
    if(e =="+" && ($3 >= 0 && $3 <=  16))
    {
        pktsend++;
    }
}
END{
    printf("%d\t%f", ctime, (1-pktrec/pktsend));
}