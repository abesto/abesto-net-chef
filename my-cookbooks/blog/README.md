WordPress installation, currently set up from a snapshot at 2012. Jul. 07.

Using a snapshot has several security implications. Here's what's done to keep sensitive data out of the repository:
 
 * MySQL connections parameters are defined in node.json, set to "replaced_in_production" before committing
 * Authentication key and salt used for cookie encryption and signing is generated into the wp-config.php template using https://api.wordpress.org/secret-key/1.1/salt/
 * The admin user password is changed manually after setup; it's stored in the DB snapshot hashed and salted and all that, but it still can't hurt
