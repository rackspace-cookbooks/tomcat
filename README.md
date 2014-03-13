rackspace_tomcat Cookbook
===============
Installs and configures Tomcat, Java servlet engine and webserver.


Requirements
------------
### Platforms
- Debian, Ubuntu 
- CentOS 6+, Red Hat 6+

### Dependencies
- rackspace_java
- openssl


Attributes
----------
* `node['rackspace_tomcat']['base_version']` - The version of tomcat to install, default `6`.
* `node['rackspace_tomcat']['port']` - The network port used by Tomcat's HTTP connector, default `8080`.
* `node['rackspace_tomcat']['proxy_port']` - if set, the network port used by Tomcat's Proxy HTTP connector, default nil.
* `node['rackspace_tomcat']['ssl_port']` - The network port used by Tomcat's SSL HTTP connector, default `8443`.
* `node['rackspace_tomcat']['ssl_proxy_port']` - if set, the network port used by Tomcat's Proxy SSL HTTP connector, default nil.
* `node['rackspace_tomcat']['ajp_port']` - The network port used by Tomcat's AJP connector, default `8009`.
* `node['rackspace_tomcat']['catalina_options']` - Extra options to pass to the JVM only during start and run commands, default "".
* `node['rackspace_tomcat']['java_options']` - Extra options to pass to the JVM, default `-Xmx128M -Djava.awt.headless=true`.
* `node['rackspace_tomcat']['use_security_manager']` - Run Tomcat under the Java Security Manager, default `false`.
* `node['rackspace_tomcat']['loglevel']` - Level for default Tomcat's logs, default `INFO`.
* `node['rackspace_tomcat']['deploy_manager_apps']` - whether to deploy manager apps, default `true`.
* `node['rackspace_tomcat']['authbind']` - whether to bind tomcat on lower port numbers, default `no`.
* `node['rackspace_tomcat']['max_threads']` - maximum number of threads in the connector pool.
* `node['rackspace_tomcat']['tomcat_auth']` -
* `node['rackspace_tomcat']['user']` -
* `node['rackspace_tomcat']['group']` -
* `node['rackspace_tomcat']['home']` -
* `node['rackspace_tomcat']['base']` -
* `node['rackspace_tomcat']['config_dir']` -
* `node['rackspace_tomcat']['log_dir']` -
* `node['rackspace_tomcat']['tmp_dir']` -
* `node['rackspace_tomcat']['work_dir']` -
* `node['rackspace_tomcat']['context_dir']` -
* `node['rackspace_tomcat']['webapp_dir']` -
* `node['rackspace_tomcat']['lib_dir']` -
* `node['rackspace_tomcat']['endorsed_dir']` -

### Attributes for SSL
* `node['rackspace_tomcat']['ssl_cert_file']` - SSL certificate file
* `node['rackspace_tomcat']['ssl_chain_files']` - SSL CAcert chain files used for generating the SSL certificates
* `node['rackspace_tomcat']['ssl_max_threads']` - maximum number of threads in the ssl connector pool, default `150`.
* `node['rackspace_tomcat']['keystore_file']` - Location of the file where the SSL keystore is located
* `node['rackspace_tomcat']['keystore_password']` - Generated by the `secure_password` method from the openssl cookbook; if you are using Chef Solo, set this attribute on the node
* `node['rackspace_tomcat']['truststore_password']` - Generated by the `secure_password` method from the openssl cookbook; if you are using Chef Solo, set this attribute on the node
* `node['rackspace_tomcat']['truststore_file']` - location of the file where the SSL truststore is located
* `node['rackspace_tomcat']['certificate_dn']` - DN for the certificate
* `node['rackspace_tomcat']['keytool']` - path to keytool, used for generating the certificate, location varies by platform


Usage
-----
Simply include the recipe where you want Tomcat installed.

Due to the ways that some system init scripts call the configuration, you may wish to set the java options to include `JAVA_OPTS`. As an example for a java app server role:

```ruby
name "java-app-server"
run_list("recipe[rackspace_tomcat]")
override_attributes(
  'rackspace_tomcat' => {
    'java_options' => "${JAVA_OPTS} -Xmx128M -Djava.awt.headless=true"
  }
)
```


Managing Tomcat Users
---------------------
The recipe `rackspace_tomcat::users` included in this cookbook is used for managing Tomcat users. The recipe adds users and roles to the `tomcat-users.xml` conf file.

Users are defined by creating a `tomcat_users` data bag and placing [Encrypted Data Bag Items](http://wiki.opscode.com/display/chef/Encrypted+Data+Bags) in that data bag. Each encrypted data bag item requires an 'id', 'password', and a 'roles' field.

```javascript
{
  "id": "reset",
  "password": "supersecret",
  "roles": [
    "manager",
    "admin"
  ]
}
```

If you are a Chef Solo user the data bag items are not required to be encrypted and should not be.


License & Authors
-----------------
- Author: Seth Chisamore (<schisamo@opscode.com>)
- Author: Jamie Winsor (<jamie@vialstudios.com>)
- Author: Phillip Goldenburg (<phillip.goldenburg@sailpoint.com>)
- Auther: Mariano Cortesi (<mariano@zauberlabs.com>)
- Author: Brendan O'Donnell (<brendan.james.odonnell@gmail.com>)
- Author: Christopher Coffey (<christopher.coffey@rackspace.com>)

```text
Copyright:: 2010-2013, Opscode, Inc
Copyright:: 2014, Rackspace US, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
