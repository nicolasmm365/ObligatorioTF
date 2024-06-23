Este código crea varios grupos de seguridad en AWS para diferentes componentes de la infraestructura:

- Uno para un balanceador de carga (tf_sg_lb_obligatorio), al cual todos podrán acceder (incluso desde afera de la red.
- Uno para las aplicaciones web (tf_sg_appweb_obligatorio), que permite SSH desde cualquier dirección (en produccion se pondrían solo las IPs de los admin) y tráfico HTTP solamente desde el balanceador de carga.
- Uno para una base de datos MySQL (tf_sg_mysql_obligatorio), que permite acceso desde las aplicaciones web.
- Uno para EFS (tf_sg_efs_obligatorio), que permite acceso NFS desde las aplicaciones web.

Estos grupos de seguridad ayudan a controlar el tráfico dentro de la VPC y entre los diferentes componentes de la infraestructura, siguiendo las prácticas recomendadas de seguridad de AWS.
