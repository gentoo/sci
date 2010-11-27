ScriptAlias /gbrowse/cgi-bin/gbrowse "/var/www/localhost/htdocs/gbrowse/cgi-bin/gbrowse"
ScriptAlias /gbrowse/cgi-bin/ "/var/www/localhost/htdocs/gbrowse/cgi-bin/"

<Directory "/var/www/localhost/htdocs/gbrowse/cgi-bin/">
    Options ExecCGI
    AllowOverride None
    <IfModule mod_access.c>
        Order allow,deny
        Allow from all
    </IfModule>
</Directory>

Alias /gbrowse/i "/var/www/localhost/htdocs/gbrowse/images"
Alias /gbrowse "/var/www/localhost/htdocs/gbrowse"
Alias /gbrowse2 "/var/www/localhost/htdocs/gbrowse"

<Directory "/var/www/localhost/htdocs/gbrowse">
    Options FollowSymlinks
    AllowOverride None
    <IfModule mod_access.c>
        Order allow,deny
        Allow from all
    </IfModule>
</Directory>


