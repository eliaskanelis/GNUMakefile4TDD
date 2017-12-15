/******************************************************************************
	Code
******************************************************************************/

/******************************************************************************
	Include files
******************************************************************************/

#include "board.h"

#include <stdio.h>
#include <stdint.h>

/******************************************************************************
	Function definitions
******************************************************************************/

/**
 * \brief Get the boards name.
 *
 * \return					The board's name.
 */
const char* getBoardName( void )
{
	return "GNU/Linux PC";
}

void bsp_setup_led( void )
{
	printf( "Led: setup\n" );
}

void bsp_led_on( void )
{
	printf( "Led: ON\n" );
}

void bsp_led_off( void )
{
	printf( "Led: OFF\n" );
}

void bsp_delay( const uint32_t num )
{
	printf( "Delay...\n" );
}