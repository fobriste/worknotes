#test mail in php

<?php

$to = "rackertestaccount@yahoo.com";
$subject = "Test mail";
$message = "Hello! This is a simple email message.";
$from = "root@localhost";
$headers = "From: $from";
mail($to,$subject,$message,$headers);
echo "Mail Sent.";

?>


#!/usr/bin/php
<?php

/**
  This script is a sendmail wrapper for php to log calls of the php mail() function.
  Author: Till Brehm, www.ispconfig.org
  (Hopefully) secured by David Goodwin <david @ _palepurple_.co.uk>

With help from Mr. Printz

Test this before you use it

Remove it after using it

Don't forget to "touch /tmp/mail_php.log" and "chmod 777 /tmp/mail_php.log"
*/

$sendmail_bin = '/usr/sbin/sendmail';
$logfile = '/tmp/mail_php.log';

//* Get the email content
$logline = '';
$pointer = fopen('php://stdin', 'r');

while ($line = fgets($pointer)) {
        if(preg_match('/^to:/i', $line) || preg_match('/^from:/i', $line)) {
                $logline .= trim($line).' ';
        }
        $mail .= $line;
}

//* compose the sendmail command
$command = 'echo ' . escapeshellarg($mail) . ' | '.$sendmail_bin.' -t -i';
for ($i = 1; $i < $_SERVER['argc']; $i++) {
        $command .= escapeshellarg($_SERVER['argv'][$i]).' ';
}



//* Write the log
file_put_contents($logfile, date('Y-m-d H:i:s') . ' ' . $_SERVER['REQUEST_URI'] . ' ' . $logline, FILE_APPEND);
//* Execute the command
return shell_exec($command);
?>
the apache config statements go in vhost.conf inside /home/httpd/vhosts/<domain>/conf
***MAKE SURE THE PATH IS NOT A SYMLINK***
<IfModule sapi_apache2.c>
php_admin_value open_basedir "/var/www/vhosts/ncarolinafurniture.com:/tmp"
</IfModule>
<IfModule mod_php5.c>
php_admin_value open_basedir "/var/www/vhosts/ncarolinafurniture.com:/tmp"
</IfModule>

 or any other valid apache config statements
then run  /usr/local/psa/admin/sbin/websrvmng -av && service httpd reload to import them 

# force php error reporting
php_admin_value error_reporting 6143
php_admin_flag display_errors On
php_admin_flag log_errors On

# disable php via .htaccess
AddHandler cgi-script .php .phps .htm .inc
Options -ExecCGI
