# Use small node base image
FROM node:18-alpine

# Create app dir
WORKDIR /usr/src/app

# Copy package.json and install deps first (layering)
COPY package*.json ./
RUN npm install --production

# Copy source
COPY . .

EXPOSE 3000
CMD ["node", "app.js"]
