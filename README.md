# Migración de Infraestructura On-Premise a AWS

## Descripción del Obligatorio

Este proyecto tiene como objetivo migrar la infraestructura on-premise de una empresa de e-commerce a Amazon Web Services (AWS) para mejorar la escalabilidad y la performance del sitio web tras una campaña publicitaria que incrementó significativamente el tráfico. La solución propuesta implica el uso de Terraform para automatizar la creación y configuración de la infraestructura en AWS.

## Arquitectura Implementada

![Diagrama AWS](https://github.com/nicolasmm365/ObligatorioTF/assets/56324802/69da7531-9c73-4641-a7e7-b1393c2140ff)

La nueva arquitectura en AWS incluye los siguientes componentes:

- Una Virtual Private Cloud (VPC) con subredes públicas en dos zonas de disponibilidad (us-east-1a y us-east-1b).
- Un Internet Gateway para proporcionar acceso a Internet.
- Grupos de seguridad (Security Groups) para controlar el tráfico de entrada y salida.
- Un Application Load Balancer (ALB) para distribuir el tráfico entre las instancias web.
- Dos instancias de aplicación EC2, cada una en una zona de disponibilidad diferente.
- Una base de datos relacional MySQL alojada en una instancia de RDS.
- Un sistema de archivos EFS para almacenamiento compartido y persistente.
- Políticas de backup para EFS.

## Contenido del Repositorio

El repositorio contiene los siguientes archivos y directorios:

- `main.tf`: Archivo principal de Terraform que define los recursos de AWS.
- `variables.tf`: Archivo que define las variables utilizadas en el proyecto.
- `outputs.tf`: Archivo que define las salidas de los recursos creados.
- `README.md`: Este archivo, que describe el proyecto y su implementación.
- Diagrama de arquitectura: Un archivo en formato `draw.io` que muestra la arquitectura completa de la solución.
- Documentación adicional: Información detallada sobre la configuración de la infraestructura, tipos de instancias, bloques CIDR, etc.

## Requisitos Previos

Para implementar esta solución, necesitarás:

- Una cuenta de AWS con permisos suficientes para crear los recursos mencionados.
- Terraform instalado en tu máquina local.
- Una clave SSH válida para acceder a las instancias EC2.
- Acceso a internet para clonar el repositorio de GitHub y descargar dependencias.

## Instrucciones de Implementación

1. **Clonar el Repositorio**:
    ```bash
    git clone <URL_DEL_REPOSITORIO>
    cd <NOMBRE_DEL_REPOSITORIO>
    ```

2. **Configurar Variables**:
    - Edita el archivo `variables.tf` para ajustar las configuraciones de acuerdo a tus necesidades.

3. **Inicializar Terraform**:
    ```bash
    terraform init
    ```

4. **Revisar el Plan**:
    ```bash
    terraform plan
    ```

5. **Aplicar la Configuración**:
    ```bash
    terraform apply
    ```
    - Ingresa `yes` cuando se te solicite para confirmar la aplicación de los cambios.

## Descripción Detallada de la Infraestructura

### VPC y Subredes
- **VPC**: Una VPC con un CIDR block de `10.0.0.0/16`.
- **Subredes**: Dos subredes públicas en las zonas de disponibilidad `us-east-1a` y `us-east-1b`.

### Grupos de Seguridad
- **Load Balancer Security Group**: Permite el tráfico HTTP entrante (puerto 80) desde cualquier IP.
- **App Web Security Group**: Permite el tráfico HTTP desde el Load Balancer y el tráfico SSH (puerto 22) desde cualquier IP.
- **MySQL Security Group**: Permite el tráfico MySQL (puerto 3306) desde el grupo de seguridad de la aplicación web.
- **EFS Security Group**: Permite el tráfico NFS (puerto 2049) desde el grupo de seguridad de la aplicación web.

### Load Balancer y Target Groups
- **Application Load Balancer**: Distribuye el tráfico HTTP entre las instancias de aplicación.
- **Target Groups**: Grupos de destino para las instancias de aplicación, con chequeos de salud configurados.

### Instancias de Aplicación
- **EC2 Instances**: Dos instancias `t2.micro` con Amazon Linux 2, cada una en una subred diferente. Configuradas para servir una aplicación PHP clonada desde un repositorio de GitHub.

### Base de Datos
- **RDS MySQL Instance**: Una instancia `db.t3.micro` de MySQL con 20GB de almacenamiento.

### Almacenamiento de Archivos
- **EFS**: Sistema de archivos EFS con puntos de montaje en ambas subredes y políticas de backup habilitadas.

## Colaboración y Buenas Prácticas

El trabajo en el repositorio ha seguido buenas prácticas de desarrollo colaborativo:

- **Branches**: Se ha utilizado una rama principal (`main`) y ramas de características para el desarrollo.
- **Pull Requests**: Se han realizado pull requests para la revisión de código antes de fusionar cambios.
- **Comentarios**: Se han agregado comentarios en el código para facilitar su comprensión.

## Diagramas y Documentación

El repositorio incluye un diagrama de arquitectura detallado en formato `draw.io`, mostrando todos los componentes de la infraestructura y sus interconexiones.

## Conclusión

Este proyecto demuestra cómo migrar una infraestructura on-premise a AWS utilizando Terraform para automatizar el proceso. La solución mejora la escalabilidad y resiliencia del sitio web de e-commerce, asegurando una mejor experiencia para los usuarios.

Para más información, consulta la documentación incluida en el repositorio.

---

© 2024 Nicolas Martins - Alexis D'Andrea
