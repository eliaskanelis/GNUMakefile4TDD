// ############################################################################
// ############################################################################
// About

//TODO: Doxygen the about section in file board.h

/**
 * \file     board.h
 *
 * \brief    TODO: Write brief
 *
 * Created:  2017-12-08
 *
 * \author   Kanelis Ilias    hkanelhs@yahoo.gr
 */

/**
 * \defgroup Ungrouped    Ungrouped
 *
 * \code
 * #include "board.h"
 * \endcode
 */

// ############################################################################
// ############################################################################
// Code

#ifndef BOARD_H_ONLY_ONE_INCLUDE_SAFETY
#define BOARD_H_ONLY_ONE_INCLUDE_SAFETY

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

const char *getBoardName( void );
void bsp_setup_led( void );
void bsp_led_on( void );
void bsp_led_off( void );
void bsp_delay( const uint32_t num );

#ifdef __cplusplus
}
#endif

#endif /* BOARD_H_ONLY_ONE_INCLUDE_SAFETY */
