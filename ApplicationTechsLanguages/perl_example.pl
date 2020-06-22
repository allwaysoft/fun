#!/opt/apps/local/perl/bin/perl -w
#################################################################
#
# file_name: get_cursor_stats.pl
# Description: This program runs a set of SQL queries to get hourly performance data key processes.
#
#################################################################

use strict;
use DBI;

my $dbh;
my $dbh1;
my $dbh2;
my $sth;
my $sth1;
my $sth2;
my $HOME_DIR=$ENV{"HOME"};
my ($SCRIPT_DIR,$LOG_DIR,$CFG_DIR,$FILE_DIR);
my $CFG_FILE="get_cursor_stats_engine.cfg";
my ($db_prod_name, $db_prod_host,$db_prod_user,$db_prod_pass);
my ($dbname, $dbhost,$dbuser,$dbpass);
my ($cursor_name, $as_of,$executions,$max_time,$total_time,$avg_time, $engine_name);
#$as_of =`date '+%m/%d/%Y`;
#chomp($as_of);

#$ENV{"ORACLE_HOME"}="/orahome/oracle/product/10.2.0";
my ($line,$epasswd,@line,$ORACLE_HOME); 
#Open the File to Read the Database Credentials
  my $db_connection_file = "$HOME_DIR/config/setEnv.sh";
     open (MYFILE, $db_connection_file) || die ("could not open $db_connection_file.");
     @line = <MYFILE>;
     close(MYFILE);
 
     foreach $line (@line)
     {
        chomp($line);
  if ($line =~ /ORACLE_HOME/) {
   $ENV{"ORACLE_HOME"} = substr($line, 12,  length($line)-11 );   
  }

  if ($line =~ /SCRIPT_DIR/) {
            $SCRIPT_DIR =substr($line, 11,  length($line)-10 );
        }
  
  if ($line =~ /LOG_DIR/) {
            $LOG_DIR =substr($line, 8,  length($line)-7 );
        }
  
  if ($line =~ /CFG_DIR/) {
            $CFG_DIR =substr($line, 8,  length($line)-7 );
        }
  
  if ($line =~ /FILE_DIR/) {
            $FILE_DIR =substr($line, 9,  length($line)-8 );
        }
  
        if ($line =~ /STAR_DB_PASS/) {
            $epasswd =substr($line, 13,  length($line)-12 );
            $db_prod_pass.=pack"h*", $epasswd;
        }

        if ($line =~ /STAR_DB_TNS/) {
            $db_prod_name =substr($line, 12,  length($line)-11 );
        }
 
  if ($line =~ /STAR_DB_USER/) {
   $db_prod_user = substr($line, 13,  length($line)-12 );
  } 
           
        if ($line =~ /STAROMETER_DB_PASS/) {
            $epasswd =substr($line, 19,  length($line)-18 );
            $dbpass.=pack"h*", $epasswd;
        }

        if ($line =~ /STAROMETER_DB_TNS/) {
            $dbname =substr($line, 18,  length($line)-17 );
        }
 
  if ($line =~ /STAROMETER_DB_USER/) {
   $dbuser = substr($line, 19,  length($line)-18 );
  }
     }
open(CFG, "${CFG_DIR}/$CFG_FILE") || die("cannot open ${CFG_DIR}/$CFG_FILE to read.");

while (<CFG>)
{
  my ($key, $value) = split('=', $_);
  if ($key =~ /\#/)
  {
     next;
  }
#  elsif ($key =~ /db_name/)
#  {
#    $dbname = $value;
#    chomp($dbname);
#  }
#  elsif ($key =~ /dbprodhost/)
#  {
#    $db_prod_host = $value;
#    chomp($db_prod_host);
#  }
#  elsif ($key =~ /db_user/)
#  {
#    $dbuser = $value;
#    chomp($dbuser);
#  }
#  elsif ($key =~ /db_password/)
#  {
#    $dbpass = $value;
#    chomp($dbpass);
#  }
#  elsif ($key =~ /dbprodpassword/)
#  {
#    $db_prod_pass = $value;
#    chomp($db_prod_pass);
#  }
#  elsif ($key =~ /dbprodname/)
#  {
#    $db_prod_name = $value;
#    chomp($db_prod_name);
#  }
#  elsif ($key =~ /dbproduser/)
#  {
#    $db_prod_user = $value;
#    chomp($db_prod_user);
#  }

}
close(CFG);


$dbh1 = DBI->connect( "dbi:Oracle:$dbname", $dbuser, $dbpass, { RaiseError => 1, AutoCommit => 1 }) || die "Database connection not made: $DBI::errstr";
$sth2 = $dbh1->prepare("delete from daily_cursor_statistics where as_of = trunc(sysdate)-1 and engine_name != 'ALL'");

$sth2->execute();

$sth1 = $dbh1->prepare("INSERT INTO daily_cursor_statistics
                 (cursor_name, as_of, executions, max_time, total_time, avg_time, engine_name) values
                 (?,?,?,?,?,?,?)");



#$dbh = DBI->connect("dbi:Oracle:HOST=$db_prod_host;SID=$db_prod_name;PORT=1521",$db_prod_user, $db_prod_pass, { RaiseError => 1, AutoCommit => 0 }) || die "$db_prod_name Database connection not made: $DBI::errstr";
$dbh = DBI->connect( "dbi:Oracle:$db_prod_name", $db_prod_user, $db_prod_pass, { RaiseError => 1, AutoCommit => 1 }) || die "Database connection not made: $DBI::errstr";

### Get Data First.

$sth = $dbh->prepare(
  "
 select cursor_name, trunc(monitor_time) as_of,
     sum(no_of_execs) executions,
     null max_time,
     sum(total_time) total_time,
         sum(total_time)/sum(decode(no_of_execs,0,null,no_of_execs)) avg_time, engine_name
 from 
   (select cursor_name, engine_name, engine_instance,  monitor_time,
    no_of_executions,average_time,
    nvl(lag(no_of_executions,1,0)
      over (partition by cursor_name, s.engine_name, engine_instance order by s.monitor_time),0),
    no_of_executions-
    nvl(lag(no_of_executions,1,0)
      over (partition by cursor_name, s.engine_name, engine_instance order by s.monitor_time),0) no_of_execs,
    (no_of_executions*average_time)-
    nvl(lag(no_of_executions*average_time,1,0)
      over (partition by cursor_name, s.engine_name, engine_instance order by s.monitor_time),0) total_time
    from   estar.engine_run_statistics s
    where  monitor_time between trunc(sysdate)-1.5 and trunc(sysdate)
    order by cursor_name, engine_name, engine_instance, monitor_time)
    where trunc(monitor_time)=trunc(sysdate)-1
 group by  cursor_name, engine_name, trunc(monitor_time)");

$sth->execute();

$sth->bind_col(1, \$cursor_name);
$sth->bind_col(2, \$as_of);
$sth->bind_col(3, \$executions);
$sth->bind_col(4, \$max_time);
$sth->bind_col(5, \$total_time);
$sth->bind_col(6, \$avg_time);
$sth->bind_col(7, \$engine_name);

while ($sth->fetch())
{
 $sth1->bind_param(1, $cursor_name);
 $sth1->bind_param(2, $as_of);
 $sth1->bind_param(3, $executions);
 $sth1->bind_param(4, $max_time);
 $sth1->bind_param(5, $total_time);
 $sth1->bind_param(6, $avg_time);
 $sth1->bind_param(7, $engine_name);

 $sth1->execute();
 $sth1->finish();
}


$dbh->disconnect();
exit(0);
