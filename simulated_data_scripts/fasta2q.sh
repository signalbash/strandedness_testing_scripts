#name=$(echo "$1" | cut -f 1 -d '.fa')

name=$(basename "$1" '.fasta.gz')
dirname=$(dirname "$1")
zcat $1 | paste - - | perl -ne 'chomp; s/^>/@/; @v = split /\t/; printf("%s\n%s\n+\n%s\n", $v[0], $v[1], "B"x length($v[1]))' > $dirname/$name.fq

gzip $dirname/$name.fq
rm -f $1
