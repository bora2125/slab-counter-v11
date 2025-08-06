# CLAUDE.md - Memoria del Proyecto Slab Detector V11

## 📋 Descripción del Proyecto
**AZA Slab Counter V11.0** - Aplicación web Flask industrial para detección y gestión de palanquillas usando YOLO con sistema de persistencia robusto, navegación avanzada y validación inteligente de datos.

## 🏗️ Arquitectura del Sistema
```
basic_slab_v11.py          # Aplicación Flask principal con persistencia
├── BasicSlabDetector      # Clase detector YOLO
├── Sistema Persistencia   # JSON + CSV + Backups automáticos
├── Gestión de Lotes       # Organización por lotes de producción
├── Validación Inteligente # Solo guarda datos significativos
└── API REST              # Endpoints completos para CRUD

templates/basic_index_v11.html  # Frontend avanzado con navegación optimizada
├── Editor visual          # Modo editar slabs + modo lotes
├── Zoom inteligente       # Pan-zoom con panzoom.js
├── Radio inteligente      # Detección adaptativa por zoom
├── Navegación avanzada    # Scroll automático + flechas teclado
├── Validación datos       # Prevención guardado innecesario
└── UI optimizada          # Layout compacto y centrado

data/
├── slab_data.json        # Datos principales (solo significativos)
├── backups/              # Respaldos automáticos
└── database/             # CSV histórico

uploads/                  # Imágenes subidas
best.pt                   # Modelo YOLO entrenado
```

## ⚙️ Componentes Principales

### 🎯 BasicSlabDetector (basic_slab_v11.py:39-141)
- **Modelo**: `best.pt` (YOLO v8)
- **Formatos**: PNG, JPG, JPEG, BMP, TIFF, WEBP
- **Límite**: 16MB por archivo
- **Confidence**: 0.60 por defecto
- **Detección**: Centros de bounding boxes como puntos

### 🗄️ Sistema de Persistencia Robusto
- **JSON Principal**: `data/slab_data.json` - Solo datos significativos
- **CSV Histórico**: `database/detecciones_historicas.csv` - Registro temporal
- **Backups**: Automáticos cada hora en `data/backups/`
- **Locks**: Threading locks para operaciones concurrentes
- **Validación**: Solo guarda datos con puntos manuales o lotes

### 🧠 **Sistema de Validación Inteligente** ⭐ **NUEVA V11**
```javascript
function hasSignificantData(imageObj) {
    // Solo considera significativo si hay:
    // 1. Puntos manuales (detección editada)
    // 2. Lotes asignados
    // 3. Estado 'with-batches'
    // La detección automática NO es suficiente
}
```

### 📊 Estructura de Datos
```json
{
  "images": [{
    "name": "imagen.jpg",
    "status": "with-batches",
    "manualPoints": [
      {
        "id": 1,
        "x": 120,
        "y": 150,
        "confidence": 1.0,
        "batchNumber": "L001",
        "isOriginal": false
      }
    ],
    "batches": [
      {
        "number": "L001",
        "color": "#ff0000"
      }
    ],
    "nextPointId": 2
  }]
}
```

## 🖥️ Frontend Avanzado V11

### 🎮 Modos de Edición
1. **Modo Slabs**: Agregar/eliminar palanquillas individuales
2. **Modo Lotes**: Selección libre para agrupar en lotes

### 🔍 Sistema de Radio Inteligente
- **Radio Base**: 15px para detección de puntos
- **Escalado**: `radio = radioBase × zoomActual`
- **Consistencia**: Mismo sistema para agregar y eliminar
- **Zoom 1x**: 15px | **Zoom 2x**: 30px | **Zoom 3x**: 45px

### 📍 Detección de Puntos Cercanos
```javascript
// V11 - Radio inteligente implementado
const baseSearchRadius = 15;
const currentZoom = container._zoomData?.scale || 1;
const searchRadius = baseSearchRadius * currentZoom;
```

### 🖱️ Controles de Interacción Optimizados V11
- **Click Izquierdo**: Agregar/reemplazar palanquilla
- **Click Derecho**: Eliminar palanquilla cercana
- **CTRL + Click Izquierdo Mantenido**: Pan/arrastre exclusivo (sin edición)
- **Botón Scroll del Mouse**: Pan/arrastre alternativo
- **Zoom**: Rueda del mouse + controles
- **Selección Libre**: Dibujar área para lotes
- **← → Flechas Teclado**: Navegación + scroll automático
- **Botones ⬅️ ➡️**: Navegación visual + scroll automático

## 🔧 API REST Endpoints

### 📤 Subida y Detección
- `POST /upload` - Subir imagen
- `POST /detect` - Ejecutar detección YOLO (NO guarda automáticamente)

### 💾 Persistencia Inteligente
- `GET /load_persistent_data` - Cargar datos significativos
- `POST /save_image_data` - Guardar solo datos significativos
- `GET /get_image_data/<filename>` - Datos específicos
- `POST /optimize_data` - Optimizar archivo JSON

### 📊 Base de Datos Histórica
- `POST /guardar_lote_historico` - Nuevo registro CSV
- `GET /obtener_datos_historicos` - Leer todos los registros
- `POST /actualizar_registro_historico` - Actualizar registro
- `POST /eliminar_registro_historico` - Eliminar registro
- `POST /sincronizar_lotes_historico` - Sincronizar cambios

### 🧹 Limpieza y Mantenimiento
- `POST /clean_database` - Limpieza perfecta (múltiples opciones)
- `POST /clean_image_data` - Limpiar imagen específica
- `POST /force_save_backup` - Forzar respaldo
- `POST /verify_save_status` - Verificar sincronización

## 🚀 Comandos de Ejecución

```bash
# Ejecutar aplicación V11
python basic_slab_v11.py --port 5000

# Acceso desde WSL/Windows
http://localhost:5000
http://172.20.135.105:5000

# Verificar procesos activos
ps aux | grep basic_slab
```

## 🔍 **MEJORAS PRINCIPALES V11** ⭐

### ✅ **1. Sistema de Validación Inteligente**
**Problema Solucionado**: Registros innecesarios tras limpieza total

#### **🔧 Funciones Corregidas**:
- ✅ **`saveCurrentImageDataSilently()`** - Validación antes de guardar
- ✅ **`saveCurrentImageDataNow()`** - Validación antes de guardar
- ✅ **`initAutoSaveSystem()`** - Auto-guardado inteligente
- ✅ **`selectImage()`** - Navegación sin guardado innecesario
- ✅ **Detección YOLO** - NO guarda automáticamente

#### **🎯 Comportamiento Perfecto V11**:
- 🚫 **Subida de imagen** → NO crea registro
- 🚫 **Detección YOLO** → NO crea registro  
- ✅ **Edición manual** → SÍ crea registro
- ✅ **Asignación de lotes** → SÍ crea registro
- 🧹 **Limpieza Total** → JSON vacío permanentemente

### ✅ **2. Navegación Avanzada con Scroll Automático**
```javascript
// Nueva función V11 - Scroll automático
function scrollToSelectedImageInGrid(imageId) {
    const grid = document.getElementById('imagesGrid');
    const imageElement = document.querySelector(`[data-image-id="${imageId}"]`);
    
    if (grid && imageElement) {
        imageElement.scrollIntoView({
            behavior: 'smooth',
            block: 'nearest',
            inline: 'nearest'
        });
    }
}
```

**Integración Completa**:
- ✅ **Flechas del teclado** → Navegación + scroll automático
- ✅ **Botones visuales** → Navegación + scroll automático  
- ✅ **Atributo data-image-id** → Identificación precisa
- ✅ **UX fluida** → Sin pérdida de contexto visual

### ✅ **3. UI/UX Optimizada y Compacta**

#### **🎨 Layout Optimizado**:
- **Panel Izquierdo**: Espaciado compacto (10px), estado de persistencia reubicado
- **Panel Central**: Imagen despejada sin overlays innecesarios
- **Panel Derecho**: Botones de gestión estratégicamente ubicados

#### **🎯 Centrado Perfecto de Modales**:
- ✅ **CSS Base**: `align-items: center; justify-content: center;`
- ✅ **JavaScript**: `display: 'flex'` consistente
- ✅ **Todos los modales**: Apertura centrada garantizada

### ✅ **4. Prevención Doble Click y Radio Inteligente**
- **Detección precisa** con `getAccurateCoordinates()`
- **Radio escalado** según nivel de zoom actual
- **Eliminación precisa** con click derecho

## 🏗️ **Estructura UI V11**

### Panel Izquierdo (380px)
1. 📤 **Subir Imágenes** (padding compacto: 10px)
2. 🎛️ **Controles de Confidence** (border sólido #1947BA)
3. 🚀 **Botón Detectar**
4. 🔧 **Modo de Edición** (margin-bottom: 1px)
5. 💾 **Estado de Persistencia** ← Reubicado para eficiencia
6. ⏳ **Loading**

### Panel Central (1fr - flexible)
- 🎯 **Imagen de Detección/Edición** (despejada, sin interferencias)
- 🎮 **Controles de Zoom/Pan**
- ⬅️➡️ **Navegación Inteligente** (con scroll automático)

### Panel Derecho (380px - equiparado)
1. 📊💾🗑️ **Botones de Gestión** (disposición 1x3 horizontal)
2. 📂 **Gestión de Imágenes** (diseño limpio)
3. 🔍 **Filtro por Estado**
4. 📷 **Grid Inteligente** (con scroll automático integrado)
5. 🎯 **Imagen Activa** (información esencial únicamente)

## 💡 Características Técnicas V11

### 🎨 Visualización
- **Puntos**: Círculos rojos con borde blanco
- **Lotes**: Colores diferenciados automáticamente
- **Confidence**: Texto superpuesto en detecciones
- **UI Responsiva**: Gradientes CSS modernos y espaciado optimizado

### 🔒 Seguridad y Robustez
- **Threading Locks**: Prevención de condiciones de carrera
- **Validación Inteligente**: Solo datos significativos persisten
- **Backups Automáticos**: Con verificación de integridad
- **Error Handling**: Try/catch en operaciones críticas

### 🔧 Optimizaciones V11
- **JSON Inteligente**: Solo datos con valor real (sin datos vacíos)
- **Limpieza Perfecta**: Reseteo total garantizado
- **Auto-guardado Inteligente**: Basado en contenido significativo
- **Navegación Fluida**: Scroll automático sin saltos
- **Logging Descriptivo**: Emojis para identificación rápida 🔍 ✅ ❌ 📊

## 📝 Notas de Desarrollo V11

### 🚨 Puntos Críticos
1. **Modelo YOLO**: Debe existir `best.pt` en directorio raíz
2. **Validación Inteligente**: `hasSignificantData()` controla toda persistencia
3. **Zoom**: `container._zoomData.scale` puede ser undefined
4. **Coordenadas**: Usar siempre `getAccurateCoordinates()` para consistencia
5. **Scroll Grid**: Elementos requieren `data-image-id="${img.id}"` para navegación

### 🎯 Convenciones V11
- **Logging**: Emojis descriptivos (🔍🔧📊✅❌⚠️💾🚫)
- **IDs**: Auto-incrementales para puntos y lotes
- **Estados**: `uploaded` → `detected` → `with-batches`
- **Persistencia**: Solo cuando hay puntos manuales o lotes
- **Base64**: Para imágenes en respuestas JSON
- **Espaciado**: Gaps optimizados para UI compacta (10px estándar)

### 📚 Dependencias
```txt
ultralytics  # YOLO
flask       # Web framework
opencv-python  # Procesamiento de imágenes
```

## 🎯 Flujo de Trabajo V11

1. **Subir imagen** → `uploads/` (sin crear registro JSON)
2. **Ejecutar detección** → YOLO procesa (sin guardar automáticamente)
3. **Modo editar slabs** → Ajustar puntos (primer guardado significativo)
4. **Modo lotes** → Agrupar palanquillas (actualización con lotes)
5. **Navegación inteligente** → Flechas + scroll automático en grid
6. **Auto-guardado inteligente** → Solo cuando hay datos significativos
7. **Gestión perfecta** → Limpieza total garantizada

## 🏁 Estado Actual - VERSIÓN V11 FINAL

### ✅ **Funcionalidades Core Perfeccionadas**
- ✅ Sistema de validación inteligente implementado
- ✅ Navegación dual optimizada (CTRL + click, botón scroll)
- ✅ Prevención total de guardado innecesario
- ✅ Sistema de radio inteligente perfeccionado
- ✅ Eliminación precisa con click derecho
- ✅ Consistencia completa entre operaciones
- ✅ Persistencia robusta con backups
- ✅ API REST completa y optimizada

### ✅ **UI/UX Perfeccionada V11** ⭐
- ✅ **Layout Inteligente**: Espaciado optimizado y organización eficiente
- ✅ **Paneles Equilibrados**: Distribución simétrica 380px ambos lados
- ✅ **Modales Centrados**: Apertura perfecta en centro de pantalla
- ✅ **Información Esencial**: Solo datos relevantes mostrados
- ✅ **Scroll Automático**: Navegación inteligente sin pérdida de contexto

### ✅ **Navegación Inteligente V11** ⭐
- ✅ **Flechas Teclado**: Navegación rápida + scroll automático
- ✅ **Botones Visuales**: ⬅️ Anterior | Siguiente ➡️
- ✅ **Scroll Inteligente**: Grid se posiciona automáticamente
- ✅ **UX Fluida**: Transiciones suaves, orientación constante
- ✅ **Contador Visual**: "X de Y" imágenes

### ✅ **Validación Inteligente V11** ⭐ **CARACTERÍSTICA PRINCIPAL**
- ✅ **Guardado Inteligente**: Solo datos significativos persisten
- ✅ **Limpieza Perfecta**: Reseteo total garantizado
- ✅ **Auto-guardado Preventivo**: Sin registros innecesarios
- ✅ **Detección Limpia**: YOLO no guarda automáticamente
- ✅ **Persistencia Significativa**: Solo puntos manuales y lotes

### 🎮 **Controles Finales V11**
- **Click Izquierdo**: Agregar/editar palanquillas ✅
- **Click Derecho**: Eliminar palanquillas ✅  
- **CTRL + Click Izquierdo**: Solo navegación (sin edición) ✅
- **Botón Scroll**: Navegación alternativa ✅
- **Rueda del Mouse**: Zoom in/out ✅
- **← → Flechas**: Navegación + scroll automático ✅
- **Botones ⬅️ ➡️**: Navegación visual + scroll automático ✅

## 🚀 **V11 - VERSIÓN FINAL Y FUNCIONAL**

### **🏆 Logros V11**
- **📊 Persistencia Perfecta**: Solo datos significativos
- **🧹 Limpieza Total Garantizada**: Reseteo completo funcional
- **🎯 Navegación Inteligente**: Scroll automático integrado
- **🎨 UI Optimizada**: Layout compacto y eficiente
- **🔧 Controles Precisos**: Radio inteligente y detección precisa
- **💾 Auto-guardado Inteligente**: Basado en validación de contenido
- **📱 UX Fluida**: Transiciones suaves y contexto preservado

### **🔄 Mejoras Futuras Sugeridas**
- Temas/skins personalizables
- Exportación avanzada (PDF, Excel)
- Métricas de productividad por sesión  
- Atajos de teclado adicionales
- Filtros avanzados de búsqueda
- Comparación entre lotes históricos
- Modo oscuro/claro automático

### **📋 Archivos Críticos V11**
- `basic_slab_v11.py` - Backend Flask optimizado
- `templates/basic_index_v11.html` - Frontend inteligente
- `data/slab_data.json` - Solo datos significativos
- `best.pt` - Modelo YOLO
- `CLAUDE.md` - Documentación completa V11

---

**🎉 AZA Slab Counter V11.0 - Sistema Industrial Completo y Optimizado**

*Versión estable, funcional y lista para producción - Enero 2025*