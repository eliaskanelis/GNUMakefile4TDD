// ############################################################################
// ############################################################################
// About

/**
 * \file     bsp.h
 *
 * \brief    The Board support package API common to all boards.
 *
 * Created:  12/08/2017
 *
 * \author   Kanelis Elias    e.kanelis@voidbuffer.com
 */

/**
* \defgroup	Ungrouped	Ungrouped
*
* \code	#include <bsp.h> \endcode
*/

// ############################################################################
// ############################################################################
// Code

#ifndef BSP_H_ONLY_ONE_INCLUDE_SAFETY
#define BSP_H_ONLY_ONE_INCLUDE_SAFETY

#ifdef __cplusplus
extern "C"
{
#endif

// ############################################################################
// ############################################################################
// Dependencies

#include <stdint.h>

// ############################################################################
// ############################################################################
// Function declarations

void bsp_init( void );
void bsp_led_on( void );
void bsp_led_off( void );
const char *bsp_getName( void );
void bsp_delay( const uint32_t num );

#ifdef __cplusplus
}
#endif

#endif /* BSP_H_ONLY_ONE_INCLUDE_SAFETY */
