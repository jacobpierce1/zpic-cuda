NVCC = nvcc
CFLAGS = -O3
LDFLAGS =
 
SOURCE = field.cu tile_vfld.cu tile_part.cu tile_zdf.cu \
         emf.cu laser.cu current.cu particles.cu \
         main.cu

# Add ZDF library
SOURCE += zdf.c

TARGET = zpic-cuda

# Add CUDA object files
OBJ = $(SOURCE:.cu=.o)

# Add C object files
OBJ := $(OBJ:.c=.o)

all: $(SOURCE) $(TARGET)

$(TARGET) : $(OBJ)
	$(NVCC) $(CFLAGS) $(OBJ) $(LDFLAGS) -o $@

%.o : %.cu
	$(NVCC) -c $(CFLAGS) $< -o $@

%.o : %.c
	$(NVCC) -c $(CFLAGS) $< -o $@

clean:
	@touch $(TARGET) $(OBJ)
	rm -f $(TARGET) $(OBJ)