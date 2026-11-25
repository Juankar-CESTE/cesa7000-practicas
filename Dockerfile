# Dockerfile: receta para construir la imagen de la calculadora (Tema 5, clase 7).
# Cada instrucción crea una capa; Docker reutiliza de la caché las capas que no cambian.

# Imagen base: Node 24 sobre Alpine (pequeña). La etiqueta fija la versión mayor para que
# la construcción sea reproducible (con "latest" una imagen nueva podría romper el build).
FROM node:24-alpine

# Carpeta de trabajo dentro del contenedor; los siguientes comandos se ejecutan aquí.
WORKDIR /app

# Se copian primero solo los ficheros de dependencias: mientras no cambien, la capa de
# "npm ci" se toma de la caché y el build es mucho más rápido al tocar solo el código.
COPY package*.json ./

# npm ci instala exactamente lo que fija package-lock.json. --omit=dev deja fuera Jest,
# jest-junit y demás dependencias de desarrollo: no hacen falta en producción.
RUN npm ci --omit=dev

# Código de la aplicación. Los tests no se copian (también los excluye .dockerignore).
COPY src ./src

# Se ejecuta como el usuario "node" (sin privilegios) en vez de root: si alguien
# comprometiera la aplicación, tendría menos permisos dentro del contenedor.
USER node

# Documenta el puerto en el que escucha el servidor; no lo publica (eso lo hace -p al hacer docker run).
EXPOSE 3000

# Comando de arranque. Al ejecutarse server.js directamente, el servidor escucha en el puerto 3000.
CMD ["node", "src/server.js"]
