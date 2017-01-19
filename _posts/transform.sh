#!/bin/bash
regextractor () {
    perl -E 'undef$/;$_=<>;($v1)= $_ =~ /'$1'/m;print "$v1";' <$2
}

for i in *.md
do
	mydate=`regextractor "^date:\s*(\S{10}).*$" $i`
	mytitle=`regextractor "^title:\w*(.*)\s*$" $i`
	myslug=`regextractor "^slug:\s*(\S*)\s*$" $i`
	toslug=`regextractor "^toslug:\s*(\S*)\s*$" $i`
	type=`regextractor "^type:\s*(\S*)\s*$" $i`
	#echo found "mydate $mydate-type $type-toslug $toslug-myslug $myslug"
	#echo found "mydate$mydate -date"
	#echo found "type$type -type"
	#echo found "toslug$toslug -toslug"
	#echo found "myslug$myslug -myslug"
	if [ $type == "question" ]; then
		article=$myslug
		echo "mv $i $article/$mydate-$toslug.md"
		mkdir $article
		mv $i $article/$mydate-$article.md
	else
		article=$toslug
		echo "mv $i $article/$mydate-$type-$myslug.md"
		mv $i $article/$type-$myslug.md
		echo "{% include_relative $type-$myslug.md %}" | tee -a $article/*-$article.md
	fi
done
