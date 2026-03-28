# Usa una imagen base de Node.js
FROM node:18-alpine

# Crea y accede al directorio de la aplicación
WORKDIR /usr/src/app

# Copia los archivos necesarios para instalar las dependencias
COPY package.json package-lock.json ./ 

# Instala las dependencias
RUN npm install

# Copia el resto del código fuente al contenedor
COPY . .

# Expone el puerto por el que se accede a la aplicación
EXPOSE 3001

# Comando para iniciar la aplicación
CMD ["npm", "start"]