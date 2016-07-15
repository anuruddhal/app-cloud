-- Default url feature related db migration

UPDATE AC_APPLICATION JOIN AC_VERSION
ON AC_APPLICATION.id = AC_VERSION.application_id
SET AC_APPLICATION.default_version = AC_VERSION.name;

ALTER TABLE AC_APPLICATION ADD custom_domain VARCHAR(200);

UPDATE AC_APPLICATION
INNER JOIN AC_VERSION ON AC_APPLICATION.id = AC_VERSION.application_id
INNER JOIN AC_DEPLOYMENT ON AC_DEPLOYMENT.id = AC_VERSION.deployment_id
INNER JOIN AC_CONTAINER ON AC_CONTAINER.deployment_id = AC_DEPLOYMENT.id
INNER JOIN AC_CONTAINER_SERVICE_PROXY ON AC_CONTAINER_SERVICE_PROXY.container_id = AC_CONTAINER.id
SET AC_APPLICATION.custom_domain = AC_CONTAINER_SERVICE_PROXY.host_url
WHERE AC_CONTAINER_SERVICE_PROXY.host_url NOT LIKE '%-%-%.%';

ALTER TABLE AC_CONTAINER_SERVICE_PROXY
DROP COLUMN host_url;

-- Updated Container Specification names

update AC_CONTAINER_SPECIFICATIONS set CON_SPEC_NAME = '128MB RAM and 0.1x vCPU' where MEMORY = '128';
update AC_CONTAINER_SPECIFICATIONS set CON_SPEC_NAME = '256MB RAM and 0.2x vCPU' where MEMORY = '256';
update AC_CONTAINER_SPECIFICATIONS set CON_SPEC_NAME = '512MB RAM and 0.3x vCPU' where MEMORY = '512';
update AC_CONTAINER_SPECIFICATIONS set CON_SPEC_NAME = '1024MB RAM and 0.5x vCPU' where MEMORY = '1024';


-- Adding new msf4j 2.0.0 runtime - need to check in prod before upgrade

insert into AC_RUNTIME (name, repo_url, image_name, tag, description) values ('OpenJDK 8 + WSO2 MSF4J 2.0.0', 'registry.docker.appfactory.private.wso2.com:5000', 'msf4j', '2.0.0', 'OS:Debian, JAVA Version:8u72');

update AC_RUNTIME set name = 'OpenJDK 8 + WSO2 MSF4J 1.0.0', tag = '1.0.0' where name = 'OpenJDK 8';

insert into AC_RUNTIME_CONTAINER_SPECIFICATIONS values (8, 1);
insert into AC_RUNTIME_CONTAINER_SPECIFICATIONS values (8, 2);
insert into AC_RUNTIME_CONTAINER_SPECIFICATIONS values (8, 3);
insert into AC_RUNTIME_CONTAINER_SPECIFICATIONS values (8, 4);

insert into AC_RUNTIME_TRANSPORT values (3, 8);
insert into AC_RUNTIME_TRANSPORT values (4, 8);

insert into AC_APP_TYPE_RUNTIME values(2, 8);