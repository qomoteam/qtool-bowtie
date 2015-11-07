use Getopt::Long;

my ($db,$input,$opt,$mapper,$inputformat,$HADOOP_BIN,$cmd,$sdb);
GetOptions(
	   "db=s" => \$db,
	   "input=s" => \$input,
	   "opt=s" => \$opt,
	   "out=s" => \$out,
	   "qry=s" => \$qry,
	   "HADOOP_BIN=s" => \$HADOOP_BIN,
	   "STREAMING_JAR=s" => \$STREAMING_JAR,
	   "QOMO_COMMON=s" => \$QOMO_COMMON
	  );
$sdb=substr($db,rindex($db,"/")+1);
$sdb=substr($sdb,0,index($sdb,"."));

my $fmt=substr($input,rindex($input,".")+1);
if ($fmt eq "fasta"){
  $opt = $opt . " " . '-f';
}else{
  $opt = $opt . " " . '-q';
}


$mapper = "bowtie $opt $sdb -";
$inputformat = "qomo.common.io.".uc($fmt)."InputFormat";

$cmd = "$HADOOP_BIN jar $STREAMING_JAR -D stream.map.input.ignoreKey=true -D mapred.reduce.tasks=0 -libjars $QOMO_COMMON -files bowtie -archives $db#indexes -inputformat $inputformat -input $qry -output $out -mapper \"$mapper\"";
print $cmd;
print "\n";
system($cmd) == 0 or
	exit 1