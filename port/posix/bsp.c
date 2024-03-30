// ############################################################################
// ############################################################################
// Code

// ############################################################################
// ############################################################################
// Include files

#include "bsp.h"

#include <stdio.h>
#include <stdint.h>

// ############################################################################
// ############################################################################
// Function definitions

/**
 * \brief Initialise the board.
 */
void bsp_init( void )
{
	( void )printf( "Led: setup\n" );
}


/**
 * \brief Turn the led on.
 */
void bsp_led_on( void )
{
	( void )printf( "Led: ON\n" );
}


/**
 * \brief Turn the led off.
 */
void bsp_led_off( void )
{
	( void )printf( "Led: OFF\n" );
}


/**
 * \brief Delay for some time.
 */
void bsp_delay( const uint32_t num )
{
	( void )num;
#if 0
	( void )printf( "Delay...\n" );
#endif
}

/**
 * \brief Get the boards name.
 *
 * \return The board's name.
 */
const char *bsp_getName( void )
{
	const char *boardName = "posix";
	return boardName;
}
