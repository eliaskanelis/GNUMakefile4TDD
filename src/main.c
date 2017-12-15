/******************************************************************************
	Includes
******************************************************************************/

#include <stdio.h>

#include "board.h"

#include "version.h"

/******************************************************************************
	Code
******************************************************************************/

int main( void )
{
	printf( "Hello world!\n" );
	printf( "Board name: %s!\n", getBoardName() );
	printf( "Version:    v%s\n", VERSION );

	/* Test led */
	bsp_setup_led();
	for( int i = 25; i>0; i-- )
	{
		bsp_led_on();
		bsp_delay( 100000 );
		bsp_led_off();
		bsp_delay( 100000 );
	}
	bsp_led_on();

	/* Will never reach here. Will never return... */
	return 0;
}
