#ifndef __TILE_VFLD__
#define __TILE_VFLD__

#include <cstddef>

/**
 * @brief VFLD class
 * 
 */
class VFLD {

    private:


    public:

    enum copy_direction { host_device, device_host };

    float3 *buffer;     // Data buffer (host)
    float3 *d_buffer;   // Data buffer (device)

    int2 nx;            // Tile grid size
    int2 gc[2];         // Tile guard cells
    int2 nxtiles;       // Number of tiles in each direction

    __host__ VFLD( const int2 gnx, const int2 tnx, const int2 gc[2]);
    __host__ ~VFLD();

    __host__ int zero();
    __host__ void set( const float3 val );
    __host__ int update_data( const copy_direction direction );

    __host__ void add( const VFLD &rhs );

    __host__ int gather( const int fc, float * data );

    /**
     * @brief Tile size
     * 
     * @return total number of cells in tile, including guard cells 
     */
    __host__
    std::size_t tile_size() {
        return ( gc[0].x + nx.x + gc[1].x ) * ( gc[0].y + nx.y + gc[1].y );
    };

    /**
     * @brief Buffer size
     * 
     * @return total size of data buffers
     */
    __host__
    std::size_t buffer_size() {
        return nxtiles.x * nxtiles.y * tile_size();
    };

    /**
     * @brief Global grid size
     * 
     * @return int2 
     */
    __host__
    int2 g_nx() {
        return make_int2 (
            nxtiles.x * nx.x,
            nxtiles.y * nx.y
        );
    };

    /**
     * @brief External size of tile (inc. guard cells)
     * 
     * @return      int2 value specifying external size of tile 
     */
    __host__
    int2 ext_nx() {
        return make_int2(
           gc[0].x +  nx.x + gc[1].x,
           gc[0].y +  nx.y + gc[1].y
        );
    };

    /**
     * @brief External volume of tile (inc. guard cells)
     * 
     * @return      size_t value of external volume
     */
    __host__
    size_t ext_vol() {
        return ( gc[0].x +  nx.x + gc[1].x ) *
               ( gc[0].y +  nx.y + gc[1].y );
    }

    /**
     * @brief Offset in cells between lower tile corner and position (0,0)
     * 
     * @return      Offset in cells 
     */
    __host__
    int offset() {
        return gc[0].y * (gc[0].x +  nx.x + gc[1].x) + gc[0].x;
    }

    /**
     * @brief Updates guard cell values
     * 
     * Guard cell values are copied from neighboring tiles assuming periodic boundaries
     * Values are copied along x first and then along y.
     * 
     */
    __host__
    void update_gc();
};

#endif