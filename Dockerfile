# Imagen base Python
FROM python:3.11-slim

# Establecer directorio de trabajo
WORKDIR /app

# Instalar dependencias del sistema para OpenCV y YOLO
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libgl1-mesa-glx \
    libglib2.0-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copiar requirements.txt primero para optimizar cache de Docker
COPY requirements.txt .

# Instalar dependencias Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código fuente
COPY . .

# Crear directorios necesarios con permisos apropiados
RUN mkdir -p uploads database data/backups templates results exports && \
    chmod -R 755 uploads database data templates results exports

# Exponer puerto
EXPOSE 5000

# Comando por defecto
CMD ["python", "basic_slab_v11.py", "--port", "5000"]